//
//  MKLTAxisController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTAxisController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextSwitchCell.h"
#import "MKMixedChoiceCell.h"
#import "MKTextButtonCell.h"

#import "MKLTCentralManager.h"

#import "MKLTAxisPageModel.h"

#import "MKLTAxisSensorCell.h"

@interface MKLTAxisController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKMixedChoiceCellDelegate,
MKTextButtonCellDelegate,
MKLTAxisSensorCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)MKLTAxisPageModel *dataModel;

@end

@implementation MKLTAxisController

- (void)dealloc {
    NSLog(@"MKLTAxisController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisSensorData:)
                                                 name:mk_lt_receive3AxisSensorDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)leftButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configSensorDataStatus:NO sucBlock:^{
        [[MKHudManager share] hide];
        [super leftButtonMethod];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [super leftButtonMethod];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        MKMixedChoiceCellModel *cellModel = self.section3List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 4) {
        return (self.dataModel.sensorDataIsOn ? 150.f : 44.f);
    }
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKLTAxisSensorCell *cell = [MKLTAxisSensorCell initCellWithTableView:tableView];
    cell.dataModel = self.section4List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //3-Axis Switch
        [self configAxisSwitch:isOn];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    MKTextFieldCellModel *cellModel = self.section2List[index];
    cellModel.textFieldValue = value;
    if (index == 0) {
        //Trigger Sensitivity
        self.dataModel.sensitivity = value;
        return;
    }
    if (index == 1) {
        //3-Axis Payload Report Interval
        self.dataModel.reportInterval = value;
    }
}

#pragma mark - MKMixedChoiceCellDelegate
/// 按钮的点击事件
/// @param selected YES:选中，NO:取消选中
/// @param cellIndex 当前cell所在index
/// @param buttonIndex 点击事件button所在的index
- (void)mk_mixedChoiceSubButtonEventMethod:(BOOL)selected
                                 cellIndex:(NSInteger)cellIndex
                               buttonIndex:(NSInteger)buttonIndex {
    if (cellIndex == 0) {
        //Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section3List[0];
        MKMixedChoiceCellButtonModel *buttonModel = cellModel.dataList[buttonIndex];
        buttonModel.selected = selected;
        if (buttonIndex == 0) {
            //Mac Address
            self.dataModel.macIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //timestamp
            self.dataModel.timestampIsOn = selected;
            return;
        }
        return;
    }
}

#pragma mark - MKTextButtonCellDelegate
/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value {
    MKTextButtonCellModel *cellModel = self.section1List[index];
    cellModel.dataListIndex = dataListIndex;
    if (index == 0) {
        //Sample Rate
        self.dataModel.sampleRate = dataListIndex;
        return;
    }
    if (index == 1) {
        //Gravitational acceleration
        self.dataModel.acceleration = dataListIndex;
        return;
    }
}

#pragma mark - MKLTAxisSensorCellDelegate
- (void)mk_axisSensorDataSwitchChanged:(BOOL)isOn {
    //Sensor Data
    [self configSensorDataStatus:isOn];
    return;
}

#pragma mark - note
- (void)receiveAxisSensorData:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    MKLTAxisSensorCellModel *cellModel = self.section4List[0];
    cellModel.xAxisSensorData = dic[@"axisData"][@"x-axis"];
    cellModel.yAxisSensorData = dic[@"axisData"][@"y-axis"];
    cellModel.zAxisSensorData = dic[@"axisData"][@"z-axis"];
    [self.tableView mk_reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configAxisSwitch:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configAxisSwitchStatus:isOn sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        
        self.dataModel.axisIsOn = isOn;
        MKTextSwitchCellModel *cellModel1 = self.section0List[0];
        cellModel1.isOn = isOn;
        
        MKLTAxisSensorCellModel *cellModel2 = self.section4List[0];
        cellModel2.selected = self.dataModel.sensorDataIsOn;
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configSensorDataStatus:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configSensorDataStatus:isOn sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        
        MKTextSwitchCellModel *cellModel1 = self.section0List[0];
        cellModel1.isOn = self.dataModel.axisIsOn;
        
        self.dataModel.sensorDataIsOn = isOn;
        MKLTAxisSensorCellModel *cellModel2 = self.section4List[0];
        cellModel2.selected = isOn;
        
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *checkModel = [[MKTextSwitchCellModel alloc] init];
    checkModel.msg = @"3-Axis Switch";
    checkModel.index = 0;
    checkModel.isOn = self.dataModel.axisIsOn;
    [self.section0List addObject:checkModel];
}

- (void)loadSection1Datas {
    
    MKTextButtonCellModel *cellModel1 = [[MKTextButtonCellModel alloc] init];
    cellModel1.msg = @"Sample Rate";
    cellModel1.index = 0;
    cellModel1.dataList = @[@"1HZ",@"10HZ",@"25HZ",@"50HZ",@"100HZ"];
    cellModel1.dataListIndex = self.dataModel.sampleRate;
    [self.section1List addObject:cellModel1];
    
    MKTextButtonCellModel *cellModel2 = [[MKTextButtonCellModel alloc] init];
    cellModel2.msg = @"Gravitational acceleration";
    cellModel2.index = 1;
    cellModel2.dataList = @[@"±2g",@"±4g",@"±8g",@"±16g"];
    cellModel2.dataListIndex = self.dataModel.acceleration;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Trigger Sensitivity";
    cellModel1.cellType = mk_realNumberOnly;
    cellModel1.textPlaceholder = @"7~255";
    cellModel1.textFieldTextFont = MKFont(13.f);
    cellModel1.maxLength = 3;
    cellModel1.textFieldValue = self.dataModel.sensitivity;
    [self.section2List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"3-Axis Payload Report Interval";
    cellModel2.unit = @"Min";
    cellModel2.cellType = mk_realNumberOnly;
    cellModel2.textPlaceholder = @"1~60";
    cellModel2.textFieldTextFont = MKFont(13.f);
    cellModel2.maxLength = 2;
    cellModel2.textFieldValue = self.dataModel.reportInterval;
    [self.section2List addObject:cellModel2];
}

- (void)loadSection3Datas {
    MKMixedChoiceCellButtonModel *macModel = [[MKMixedChoiceCellButtonModel alloc] init];
    macModel.buttonMsg = @"The Host MAC Address";
    macModel.buttonIndex = 0;
    macModel.selected = self.dataModel.macIsOn;
    
    MKMixedChoiceCellButtonModel *timestampModel = [[MKMixedChoiceCellButtonModel alloc] init];
    timestampModel.buttonMsg = @"Timestamp";
    timestampModel.buttonIndex = 1;
    timestampModel.selected = self.dataModel.timestampIsOn;
    
    MKMixedChoiceCellModel *cellModel = [[MKMixedChoiceCellModel alloc] init];
    cellModel.msg = @"Optional Payload Content";
    cellModel.index = 0;
    cellModel.dataList = @[macModel,timestampModel];
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKLTAxisSensorCellModel *cellModel = [[MKLTAxisSensorCellModel alloc] init];
    cellModel.selected = self.dataModel.sensorDataIsOn;
    [self.section4List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-Axis Sensor";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTAxisController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
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

- (MKLTAxisPageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTAxisPageModel alloc] init];
    }
    return _dataModel;
}

@end
