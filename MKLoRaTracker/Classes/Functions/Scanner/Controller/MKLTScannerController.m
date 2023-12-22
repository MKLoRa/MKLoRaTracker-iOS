//
//  MKLTScannerController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTScannerController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "MKCustomUIAdopter.h"

#import "MKHudManager.h"
#import "MKTextButtonCell.h"
#import "MKNormalSliderCell.h"

#import "MKLTInterface+MKLTConfig.h"

#import "MKLTNormalTextCell.h"

#import "MKLTGatheringWarningCell.h"
#import "MKLTScanWindowView.h"

#import "MKLTScannerDataModel.h"

#import "MKLTFilterOptionsController.h"

@interface MKLTScannerController ()<
UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
MKNormalSliderCellDelegate,
MKLTGatheringWarningCellDelegate
>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)MKLTScannerDataModel *dataModel;

@end

@implementation MKLTScannerController

- (void)dealloc {
    NSLog(@"MKLTScannerController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lt_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        MKNormalSliderCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 3) {
        MKNormalSliderCellModel *cellModel = self.section3List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 4) {
        return 100;
    }
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        MKLTFilterOptionsController *vc = [[MKLTFilterOptionsController alloc] init];
        vc.pageType = mk_filterOptionsPageLocationType;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        MKLTFilterOptionsController *vc = [[MKLTFilterOptionsController alloc] init];
        vc.pageType = mk_filterOptionsTrackingPageType;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return self.section3List.count;
    }
    if (section == 4) {
        return self.section4List.count;
    }
    if (section == 5) {
        return self.section5List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKLTNormalTextCell *cell = [MKLTNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        MKLTGatheringWarningCell *cell = [MKLTGatheringWarningCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.section5List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    if (index == 0) {
        //Alarm Notification
        self.dataModel.alarmNotification = dataListIndex;
        MKTextButtonCellModel *alarmNotiModel = self.section2List[0];
        alarmNotiModel.dataListIndex = self.dataModel.alarmNotification;
        return;
    }
    if (index == 1) {
        //扫描参数
        self.dataModel.scanWindow = dataListIndex;
        MKTextButtonCellModel *scanModel = self.section5List[0];
        scanModel.dataListIndex = self.dataModel.scanWindow;
        return;
    }
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //Valid BLE Data Filter Interval
        self.dataModel.filterInterval = value;
        MKNormalSliderCellModel *filterIntervalModel = self.section1List[0];
        filterIntervalModel.sliderValue = value;
        return;
    }
    if (index == 1) {
        //Alarm Trigger RSSI
        self.dataModel.triggerRssi = value;
        [self updateGatheringWarningValues];
        return;
    }
}

#pragma mark - MKLTGatheringWarningCellDelegate
- (void)mk_gatheringWarningRssiValueChanged:(NSInteger)rssi {
    self.dataModel.gatheringWarningRssi = rssi;
    MKLTGatheringWarningCellModel *gatheringModel = self.section4List[0];
    gatheringModel.gatheringWarningRssi = rssi;
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self updateCellState];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)updateCellState {
    MKNormalSliderCellModel *filterIntervalModel = self.section1List[0];
    filterIntervalModel.sliderValue = self.dataModel.filterInterval;
    
    MKTextButtonCellModel *alarmNotiModel = self.section2List[0];
    alarmNotiModel.dataListIndex = self.dataModel.alarmNotification;
    
    MKNormalSliderCellModel *triggerModel = self.section3List[0];
    triggerModel.sliderValue = self.dataModel.triggerRssi;
    
    MKLTGatheringWarningCellModel *gatheringModel = self.section4List[0];
    gatheringModel.triggerRssi = self.dataModel.triggerRssi;
    gatheringModel.gatheringWarningRssi = self.dataModel.gatheringWarningRssi;
    
    MKTextButtonCellModel *scanWindowModel = self.section5List[0];
    scanWindowModel.dataListIndex = self.dataModel.scanWindow;
    
    [self.tableView reloadData];
}

- (void)updateGatheringWarningValues {
    MKLTGatheringWarningCellModel *gatheringModel = self.section4List[0];
    gatheringModel.triggerRssi = self.dataModel.triggerRssi;
    /*
     当报警RSSI值改变时，People gathering warning 的取值范围的最大值随动变化。若报警值在某一时刻更改后，小于People Gathering Warning当前值，则People Gathering Warning值改变为（更改后的报警值-3）。
     举例说明:当前报警值为-50dbm，People Gathering Warning值为-55dbm。当将报警值改为-60dbm时，people Gathering Warning值为-63dbm。
     极限情况说明，若报警值变为-124到-127时，People Gathering Warning值都变为-127
     */
    if (self.dataModel.gatheringWarningRssi < self.dataModel.triggerRssi) {
        //只改变Gathering Warning的范围，不需要改变Gathering Warning的按钮title,需要刷新人员聚集报警的上线RSSI值
        [self.tableView mk_reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    //改变Gathering Warning的范围和Gathering Warning的按钮title
    if (self.dataModel.triggerRssi <= -124) {
        //若报警值变为-124到-127时，People Gathering Warning值都变为-127
        self.dataModel.gatheringWarningRssi = -127;
    }else {
        //若报警值在某一时刻更改后，小于People Gathering Warning当前值，则People Gathering Warning值改变为（更改后的报警值-3）。
        self.dataModel.gatheringWarningRssi = self.dataModel.triggerRssi - 3;
    }
    gatheringModel.gatheringWarningRssi = self.dataModel.gatheringWarningRssi;
    [self.tableView mk_reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKLTNormalTextCellModel *cellModel1 = [[MKLTNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Location Beaocn Filter Options";
    [self.section0List addObject:cellModel1];
    
    MKLTNormalTextCellModel *cellModel2 = [[MKLTNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Contact Tracking Filter Options";
    [self.section0List addObject:cellModel2];
}

- (void)loadSection1Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"Valid BLE Data Filter Interval",@"   (1-600s)"] fonts:@[MKFont(15.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,UIColorFromRGB(0x353535)]];
    cellModel.sliderMaxValue = 600;
    cellModel.sliderMinValue = 1;
    cellModel.unit = @"s";
    cellModel.changed = YES;
    cellModel.leftNoteMsg = @"*The device will store the Contact Tracking  data every";
    cellModel.rightNoteMsg = @"and the same MAC address only be saved one time.";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.msg = @"Alarm Notification";
    cellModel.index = 0;
    cellModel.dataList = @[@"Off",@"Light",@"Vibration",@"Light+Vibration"];
    cellModel.buttonEnable = YES;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"Alarm Trigger RSSI",@"-127-0dBm"] fonts:@[MKFont(15.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,UIColorFromRGB(0x353535)]];
    cellModel.sliderMaxValue = 0;
    cellModel.sliderMinValue = -127;
    cellModel.unit = @"dBm";
    cellModel.changed = YES;
    cellModel.leftNoteMsg = @"*The device alarm  is triggered when the BLE RSSI scanned is greater than";
    cellModel.rightNoteMsg = @".";
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKLTGatheringWarningCellModel *cellModel = [[MKLTGatheringWarningCellModel alloc] init];
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.msg = @"Scan intensity";
    cellModel.index = 1;
    cellModel.dataList = @[@"Off",@"Low",@"Medium",@"Strong"];
    cellModel.buttonEnable = YES;
    [self.section5List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SCANNER";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTScannerController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (MKLTScannerDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTScannerDataModel alloc] init];
    }
    return _dataModel;
}

@end
