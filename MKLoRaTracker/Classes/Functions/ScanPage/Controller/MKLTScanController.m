//
//  MKLTScanController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTScanController.h"

#import "Masonry.h"

#import "UIViewController+HHTransition.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKSearchButton.h"
#import "MKSearchConditionsView.h"
#import "MKCustomUIAdopter.h"
#import "MKTrackerAboutController.h"

#import "MKLTSDK.h"

#import "MKLTConnectModel.h"
#import "MKLTScanPageModel.h"

#import "MKLTScanPageCell.h"

#import "MKLTTabBarController.h"

static NSString *const localPasswordKey = @"mk_lt_passwordKey";

@interface MKLTAboutPageModel : NSObject<MKTrackerAboutParamsProtocol>

/// 导航栏标题,默认@"ABOUT"
@property (nonatomic, copy)NSString *title;

/// 导航栏title颜色，默认白色
@property (nonatomic, strong)UIColor *titleColor;

/// 顶部导航栏背景颜色，默认蓝色
@property (nonatomic, strong)UIColor *titleBarColor;

/// 最上面那个关于的icon
@property (nonatomic, strong)UIImage *aboutIcon;

/// 底部背景图片
@property (nonatomic, strong)UIImage *bottomBackIcon;

/// 要显示的app名字，如果不填，则默认显示当前工程的app名称
@property (nonatomic, copy)NSString *appName;

/// app当前版本，如果不填，则默认取当前工程的版本号
@property (nonatomic, copy)NSString *appVersion;

@end

@implementation MKLTAboutPageModel
@end

static CGFloat const searchButtonHeight = 40.f;

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKLTScanController ()<UITableViewDelegate,
UITableViewDataSource,
mk_lt_centralManagerScanDelegate,
MKLTScanPageCellDelegate,
MKSearchButtonDelegate,
MKLTTabBarControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKSearchButtonDataModel *buttonModel;

@property (nonatomic, strong)MKSearchButton *searchButton;

@property (nonatomic, strong)UIButton *refreshButton;

@property (nonatomic, strong)UIImageView *refreshIcon;

/**
 数据源
 */
@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 当左侧按钮停止扫描的时候,currentScanStatus = NO,开始扫描的时候currentScanStatus=YES
@property (nonatomic, assign)BOOL currentScanStatus;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)UITextField *passwordField;

@property (nonatomic, strong)MKLTConnectModel *connectModel;

@end

@implementation MKLTScanController

- (void)dealloc {
    NSLog(@"MKLTScanController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKLTCentralManager shared] stopScan];
    [MKLTCentralManager removeFromCentralList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    self.searchButton.dataModel = self.buttonModel;
    [self runloopObserver];
    [MKLTCentralManager shared].delegate = self;
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:.5f];
}

#pragma mark - super method

- (void)rightButtonMethod {
    MKLTAboutPageModel *model = [[MKLTAboutPageModel alloc] init];
    model.aboutIcon = LOADICON(@"MKLoRaTracker", @"MKLTScanController", @"lt_lw004CT-aboutIcon.png");
    model.appName = @"LW004-CT";
    model.appVersion = @"2.1";
    MKTrackerAboutController *vc = [[MKTrackerAboutController alloc] initWithProtocol:model];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKLTScanPageCell *cell = [MKLTScanPageCell initCellWithTableView:self.tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170.f;
}

#pragma mark - MKSearchButtonDelegate
- (void)mk_scanSearchButtonMethod {
    [MKSearchConditionsView showSearchKey:self.buttonModel.searchKey
                                     rssi:self.buttonModel.searchRssi
                                  minRssi:-127 searchBlock:^(NSString * _Nonnull searchKey, NSInteger searchRssi) {
        self.buttonModel.searchRssi = searchRssi;
        self.buttonModel.searchKey = searchKey;
        self.searchButton.dataModel = self.buttonModel;
        
        self.refreshButton.selected = NO;
        self.currentScanStatus = NO;
        [self refreshButtonPressed];
    }];
}

- (void)mk_scanSearchButtonClearMethod {
    self.buttonModel.searchRssi = -127;
    self.buttonModel.searchKey = @"";
    self.refreshButton.selected = NO;
    self.currentScanStatus = NO;
    [self refreshButtonPressed];
}

#pragma mark - mk_lt_centralManagerScanDelegate
- (void)mk_lt_receiveDevice:(NSDictionary *)trackerModel {
    MKLTScanPageModel *model = [MKLTScanPageModel mk_modelWithJSON:trackerModel];
    [self updateDataWithTrackerModel:model];
}

- (void)mk_lt_stopScan {
    //如果是左上角在动画，则停止动画
    if (self.refreshButton.isSelected) {
        [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.refreshButton setSelected:NO];
    }
}

#pragma mark - MKLTScanPageCellDelegate
- (void)lt_scanCellConnectButtonPressed:(NSInteger)index {
    [self connectDeviceWithModel:self.dataList[index]];
}

#pragma mark - MKLTTabBarControllerDelegate
- (void)mk_needResetScanDelegate:(BOOL)need {
    if (need) {
        [MKLTCentralManager shared].delegate = self;
    }
    [self performSelector:@selector(startScanDevice) withObject:nil afterDelay:(need ? 1.f : 0.1f)];
}

#pragma mark - event method
- (void)refreshButtonPressed {
    if ([MKLTCentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.refreshButton.selected = !self.refreshButton.selected;
    self.currentScanStatus = self.refreshButton.selected;
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.refreshButton.isSelected) {
        //停止扫描
        [[MKLTCentralManager shared] stopScan];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //刷新顶部设备数量
    [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
    [self.refreshIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [self scanTimerRun];
}

#pragma mark - notice method

- (void)showCentralStatus{
    if ([MKLTCentralManager shared].centralStatus != MKCentralManagerStateEnable) {
        NSString *msg = @"The current system of bluetooth is not available!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:moreAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self refreshButtonPressed];
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.refreshButton.selected = NO;
    self.currentScanStatus = NO;
    [self refreshButtonPressed];
}

- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKLTCentralManager shared] startScan];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    WS(weakSelf);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        [[MKLTCentralManager shared] stopScan];
        [weakSelf needRefreshList];
    });
    dispatch_resume(self.scanTimer);
}

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    WS(weakSelf);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (weakSelf.isNeedRefresh) {
                [weakSelf.tableView reloadData];
                [weakSelf.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)weakSelf.dataList.count]]];
                weakSelf.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

- (void)updateDataWithTrackerModel:(MKLTScanPageModel *)trackerModel{
    if (ValidStr(self.buttonModel.searchKey)) {
        //过滤设备名字和mac地址
        [self filterTrackerDataWithSearchName:trackerModel];
        return;
    }
    if (self.buttonModel.searchRssi > self.buttonModel.minSearchRssi) {
        //开启rssi过滤
        if (trackerModel.rssi >= self.buttonModel.searchRssi) {
            [self processTrackerData:trackerModel];
        }
        return;
    }
    [self processTrackerData:trackerModel];
}

/**
 通过设备名称和mac地址过滤设备，这个时候肯定开启了rssi
 
 @param trackerModel 设备
 */
- (void)filterTrackerDataWithSearchName:(MKLTScanPageModel *)trackerModel{
    if (trackerModel.rssi < self.buttonModel.searchRssi) {
        return;
    }
    if ([[trackerModel.deviceName uppercaseString] containsString:[self.buttonModel.searchKey uppercaseString]]
        || [[trackerModel.macAddress uppercaseString] containsString:[self.buttonModel.searchKey uppercaseString]]) {
        //如果mac地址和设备名称包含搜索条件，则加入
        [self processTrackerData:trackerModel];
    }
}

- (void)processTrackerData:(MKLTScanPageModel *)trackerModel{
    //查看数据源中是否已经存在相关设备
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"macAddress == %@", trackerModel.macAddress];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (contain) {
        //如果是已经存在了，替换
        [self dataExistDataSource:trackerModel];
        return;
    }
    //不存在，则加入
    [self dataNoExistDataSource:trackerModel];
}

/**
 将扫描到的设备加入到数据源
 
 @param trackerModel 扫描到的设备
 */
- (void)dataNoExistDataSource:(MKLTScanPageModel *)trackerModel{
    [self.dataList addObject:trackerModel];
    trackerModel.index = (self.dataList.count - 1);
    trackerModel.scanTime = @"N/A";
    trackerModel.lastScanDate = kSystemTimeStamp;
    [self needRefreshList];
}

/**
 如果是已经存在了，直接替换
 
 @param trackerModel  新扫描到的数据帧
 */
- (void)dataExistDataSource:(MKLTScanPageModel *)trackerModel {
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKLTScanPageModel *dataModel = self.dataList[i];
        if ([dataModel.macAddress isEqualToString:trackerModel.macAddress]) {
            currentIndex = i;
            break;
        }
    }
    MKLTScanPageModel *dataModel = self.dataList[currentIndex];
    trackerModel.scanTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)([kSystemTimeStamp integerValue] - [dataModel.lastScanDate integerValue]) * 1000,@"ms"];
    trackerModel.lastScanDate = kSystemTimeStamp;
    trackerModel.index = currentIndex;
    [self.dataList replaceObjectAtIndex:currentIndex withObject:trackerModel];
    [self needRefreshList];
}

#pragma mark - 连接部分
- (void)connectDeviceWithModel:(MKLTScanPageModel *)trackerModel {
    //停止扫描
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    [[MKLTCentralManager shared] stopScan];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    NSString *msg = @"Please enter connection password.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordField = nil;
        weakSelf.passwordField = textField;
        NSString *localPassword = [[NSUserDefaults standardUserDefaults] objectForKey:localPasswordKey];
        textField.text = localPassword;
        weakSelf.passwordField.placeholder = @"The password is 8 characters.";
        [textField addTarget:self action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.refreshButton.selected = NO;
        weakSelf.currentScanStatus = NO;
        [weakSelf refreshButtonPressed];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf connectDeviceWithTrackerModel:trackerModel];
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)connectDeviceWithTrackerModel:(MKLTScanPageModel *)trackerModel {
    NSString *password = self.passwordField.text;
    if (password.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.connectModel connectDevice:trackerModel.peripheral password:password sucBlock:^{
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:localPasswordKey];
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Time sync completed!"];
        [weakSelf performSelector:@selector(pushTabBarPage) withObject:nil afterDelay:0.6f];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        [weakSelf connectFailed];
    }];
}

- (void)pushTabBarPage {
    MKLTTabBarController *vc = [[MKLTTabBarController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    WS(weakSelf);
    [self hh_presentViewController:vc presentStyle:HHPresentStyleErected completion:^{
        __strong typeof(self) sself = weakSelf;
        vc.delegate = sself;
    }];
}

- (void)connectFailed {
    self.refreshButton.selected = NO;
    self.currentScanStatus = NO;
    [self refreshButtonPressed];
}

/**
 监听输入的密码
 */
- (void)passwordInput{
    NSString *tempInputString = self.passwordField.text;
    if (!ValidStr(tempInputString)) {
        self.passwordField.text = @"";
        return;
    }
    self.passwordField.text = (tempInputString.length > 8 ? [tempInputString substringToIndex:8] : tempInputString);
}

#pragma mark - UI
- (void)loadSubViews {
    [self.view setBackgroundColor:RGBCOLOR(237, 243, 250)];
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTScanController", @"lt_scanRightAboutIcon.png") forState:UIControlStateNormal];
    self.titleLabel.text = @"DEVICE(0)";
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGBCOLOR(237, 243, 250);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(searchButtonHeight + 2 * 15.f);
    }];
    [self.refreshButton addSubview:self.refreshIcon];
    [topView addSubview:self.refreshButton];
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.refreshButton.mas_centerX);
        make.centerY.mas_equalTo(self.refreshButton.mas_centerY);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(40.f);
    }];
    [topView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.refreshButton.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 5.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderColor = COLOR_CLEAR_MACROS.CGColor;
        _tableView.layer.cornerRadius = 6.f;
    }
    return _tableView;
}

- (UIImageView *)refreshIcon {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.image = LOADICON(@"MKLoRaTracker", @"MKLTScanController", @"lt_scan_refreshIcon.png");
    }
    return _refreshIcon;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton addTarget:self
                           action:@selector(refreshButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

- (MKSearchButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[MKSearchButton alloc] init];
        _searchButton.delegate = self;
    }
    return _searchButton;
}

- (MKSearchButtonDataModel *)buttonModel {
    if (!_buttonModel) {
        _buttonModel = [[MKSearchButtonDataModel alloc] init];
        _buttonModel.placeholder = @"Edit Filter";
        _buttonModel.minSearchRssi = -127;
        _buttonModel.searchRssi = -127;
    }
    return _buttonModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKLTConnectModel *)connectModel {
    if (!_connectModel) {
        _connectModel = [[MKLTConnectModel alloc] init];
    }
    return _connectModel;
}

@end
