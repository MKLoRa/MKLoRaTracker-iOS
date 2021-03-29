//
//  MKLTUplinkPayloadController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTUplinkPayloadController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKTextButtonCell.h"
#import "MKMixedChoiceCell.h"
#import "MKTextSwitchCell.h"

#import "MKLTConnectModel.h"

#import "MKLTGPSReportIntervalCell.h"

#import "MKLTUplinkPayloadModel.h"

static CGFloat const sectionHeaderHeight = 55.f;

@interface MKLTUplinkPayloadController ()
<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
mk_textSwitchCellDelegate,
MKTextButtonCellDelegate,
MKMixedChoiceCellDelegate,
MKLTGPSReportIntervalCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)NSMutableArray *section5List;

@property (nonatomic, strong)NSMutableArray *section6List;

@property (nonatomic, strong)NSMutableArray *section7List;

@property (nonatomic, strong)NSMutableArray *section8List;

@property (nonatomic, strong)NSMutableArray *section9List;

@property (nonatomic, strong)NSMutableArray *section10List;

@property (nonatomic, strong)MKLTUplinkPayloadModel *dataModel;

@end

@implementation MKLTUplinkPayloadController

- (void)dealloc {
    NSLog(@"MKLTUplinkPayloadController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
        //因为gps report interval按钮标题要与nonAlarmInterval联动，所以需要刷新gps report interval所在cell
        MKLTGPSReportIntervalCellModel *cellModel = self.section7List[0];
        cellModel.nonAlarmReportInterval = [self.dataModel.nonAlarmInterval integerValue];
        [self.tableView mk_reloadSection:7 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //Report Interval
        MKTextFieldCellModel *cellModel = self.section0List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 1) {
        //Report Location Information
        MKTextSwitchCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 2) {
        //Reported Location Beacons
        MKTextButtonCellModel *cellModel = self.section2List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 3) {
        //Non-Alarm Report Interval
        MKTextFieldCellModel *cellModel = self.section3List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 4) {
        //Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section4List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 5) {
        //SOS Data Report Interval
        MKTextFieldCellModel *cellModel = self.section5List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 6) {
        //Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section6List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 7) {
        //GPS Payload Report Interval
        return 44.f;
    }
    if (indexPath.section == 8) {
        //Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section8List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 9) {
        //3-Axis Payload Report Interval
        MKTextFieldCellModel *cellModel = self.section9List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 10) {
        //Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section10List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 5 || ([MKLTConnectModel shared].supportGps && section == 7) || section == 9) {
        return 60.f;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 5 || section == 9 || ([MKLTConnectModel shared].supportGps && section == 7)) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, sectionHeaderHeight)];
        headerView.backgroundColor = RGBCOLOR(242, 242, 242);
        
        UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f,
                                                                      (sectionHeaderHeight - MKFont(20.f).lineHeight) / 2,
                                                                      kViewWidth - 30.f,
                                                                      MKFont(20.f).lineHeight)];
        msgLabel.textColor = NAVBAR_COLOR_MACROS;
        msgLabel.textAlignment = NSTextAlignmentLeft;
        if (section == 0) {
            msgLabel.text = @"Device Info Payload";
        }else if (section == 1) {
            msgLabel.text = @"Tracking And Location Payload";
        }else if (section == 5) {
            msgLabel.text = @"SOS Payload";
        }else if (section == 7) {
            msgLabel.text = @"GPS Payload";
        }else if (section == 9) {
            msgLabel.text = @"3-Axis Payload";
        }
        [headerView addSubview:msgLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.f,
                                                                    sectionHeaderHeight - CUTTING_LINE_HEIGHT,
                                                                    kViewWidth - 30.f,
                                                                    CUTTING_LINE_HEIGHT)];
        lineView.backgroundColor = CUTTING_LINE_COLOR;
        [headerView addSubview:lineView];
        
        return headerView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 0.01)];
    headerView.backgroundColor = COLOR_WHITE_MACROS;
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 11;
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
    if (section == 6) {
        return self.section6List.count;
    }
    if (section == 7) {
        return ([MKLTConnectModel shared].supportGps ? self.section7List.count : 0);
    }
    if (section == 8) {
        return ([MKLTConnectModel shared].supportGps ? self.section8List.count : 0);
    }
    if (section == 9) {
        return self.section9List.count;
    }
    if (section == 10) {
        return self.section10List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //Report Interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        //Report Location Information
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        //Reported Location Beacons
        MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        //Non-Alarm Report Interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 4) {
        //Optional Payload Content
        MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
        cell.dataModel = self.section4List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 5) {
        //SOS Data Report Interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section5List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 6) {
        //Optional Payload Content
        MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
        cell.dataModel = self.section6List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 7) {
        //GPS Payload Report Interval
        MKLTGPSReportIntervalCell *cell = [MKLTGPSReportIntervalCell initCellWithTableView:tableView];
        cell.dataModel = self.section7List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 8) {
        //Optional Payload Content
        MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
        cell.dataModel = self.section8List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 9) {
        //3-Axis Payload Report Interval
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section9List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    //Optional Payload Content
    MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
    cell.dataModel = self.section10List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Device Info Payload:Report Interval
        self.dataModel.deviceInfoInterval = value;
        MKTextFieldCellModel *cellModel = self.section0List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Tracking And Location Payload:Non-Alarm Report Interval
        self.dataModel.nonAlarmInterval = value;
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 2) {
        //SOS Payload:SOS Data Report Interval
        self.dataModel.sosInterval = value;
        MKTextFieldCellModel *cellModel = self.section5List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 3) {
        //3-Axis Payload:3-Axis Payload Report Interval
        self.dataModel.axisInterval = value;
        MKTextFieldCellModel *cellModel = self.section9List[0];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Tracking And Location Payload:Report Location Information
        self.dataModel.locationIsOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section1List[0];
        cellModel.isOn = isOn;
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
    if (index == 0) {
        //Tracking And Location Payload:Reported Location Beacons
        self.dataModel.locationBeacons = (dataListIndex + 1);
        MKTextButtonCellModel *cellModel = self.section2List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
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
        //Tracking And Location Payload:Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section4List[0];
        MKMixedChoiceCellButtonModel *buttonModel = cellModel.dataList[buttonIndex];
        buttonModel.selected = selected;
        if (buttonIndex == 0) {
            //The Host MAC Address
            self.dataModel.tlHostMacIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //Device Raw Data
            self.dataModel.tlDeviceRawDataIsOn = selected;
            return;
        }
        if (buttonIndex == 2) {
            //Battery Level
            self.dataModel.tlBatteryLevelIsOn = selected;
            return;
        }
        return;
    }
    if (cellIndex == 1) {
        //SOS Payload:Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section6List[0];
        MKMixedChoiceCellButtonModel *buttonModel = cellModel.dataList[buttonIndex];
        buttonModel.selected = selected;
        
        if (buttonIndex == 0) {
            //Timestamp
            self.dataModel.sosTimestampIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //The Host MAC Address
            self.dataModel.sosMacIsOn = selected;
            return;
        }
        
        return;
    }
    if (cellIndex == 2) {
        //GPS Payload:Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section8List[0];
        MKMixedChoiceCellButtonModel *buttonModel = cellModel.dataList[buttonIndex];
        buttonModel.selected = selected;
        
        if (buttonIndex == 0) {
            //Altitude
            self.dataModel.gpsAltitudeIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //TimeStamp
            self.dataModel.gpsTimeStampIsOn = selected;
            return;
        }
        if (buttonIndex == 2) {
            //PDOP
            self.dataModel.gpsPDOPIsOn = selected;
            return;
        }
        if (buttonIndex == 3) {
            //Number Of Satellites
            self.dataModel.gpsSatellitesIsOn = selected;
            return;
        }
        if (buttonIndex == 4) {
            //Satellites Search Mode
            self.dataModel.gpssearchModelIsOn = selected;
            return;
        }
        return;
    }
    if (cellIndex == 3) {
        //3-Axis Payload:Optional Payload Content
        MKMixedChoiceCellModel *cellModel = self.section10List[0];
        MKMixedChoiceCellButtonModel *buttonModel = cellModel.dataList[buttonIndex];
        buttonModel.selected = selected;
        
        if (buttonIndex == 0) {
            //Timestamp
            self.dataModel.axisTimeStampIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //The Host MAC Address
            self.dataModel.axisMacIsOn = selected;
            return;
        }
        
        return;
    }
}

#pragma mark - MKLTGPSReportIntervalCellDelegate
- (void)mk_lt_gpsReportIntervalChanged:(NSInteger)index {
    //GPS Payload:GPS Payload Report Interval
    self.dataModel.gpsInterval = index;
    MKLTGPSReportIntervalCellModel *cellModel = self.section7List[0];
    cellModel.gpsReportIntervalIndex = index;
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

#pragma mark - 加载列表数据
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    [self loadSection5Datas];
    [self loadSection6Datas];
    [self loadSection7Datas];
    [self loadSection8Datas];
    [self loadSection9Datas];
    [self loadSection10Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Report Interval";
    cellModel.unit = @"H";
    cellModel.textPlaceholder = @"2 ~ 120";
    cellModel.textFieldValue = self.dataModel.deviceInfoInterval;
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 3;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.msg = @"Report Location Information";
    cellModel.isOn = self.dataModel.locationIsOn;
    cellModel.index = 0;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Reported Location Beacons";
    cellModel.dataList = @[@"1",@"2",@"3",@"4"];
    cellModel.dataListIndex = self.dataModel.locationBeacons - 1;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 1;
    cellModel.msg = @"Non-Alarm Report Interval";
    cellModel.unit = @"Min";
    cellModel.textPlaceholder = @"1 ~ 60";
    cellModel.textFieldValue = self.dataModel.nonAlarmInterval;
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.maxLength = 2;
    [self.section3List addObject:cellModel];
}

- (void)loadSection4Datas {
    MKMixedChoiceCellButtonModel *macModel = [[MKMixedChoiceCellButtonModel alloc] init];
    macModel.buttonMsg = @"The Host MAC Address";
    macModel.buttonIndex = 0;
    macModel.selected = self.dataModel.tlHostMacIsOn;
    
    MKMixedChoiceCellButtonModel *rawDataModel = [[MKMixedChoiceCellButtonModel alloc] init];
    rawDataModel.buttonMsg = @"Device Raw Data";
    rawDataModel.buttonIndex = 1;
    rawDataModel.selected = self.dataModel.tlDeviceRawDataIsOn;
    
    MKMixedChoiceCellButtonModel *batteryModel = [[MKMixedChoiceCellButtonModel alloc] init];
    batteryModel.buttonMsg = @"Battery Level";
    batteryModel.buttonIndex = 2;
    batteryModel.selected = self.dataModel.tlBatteryLevelIsOn;
    
    MKMixedChoiceCellModel *cellModel = [[MKMixedChoiceCellModel alloc] init];
    cellModel.msg = @"Optional Payload Content";
    cellModel.index = 0;
    cellModel.dataList = @[macModel,rawDataModel,batteryModel];
    [self.section4List addObject:cellModel];
}

- (void)loadSection5Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 2;
    cellModel.msg = @"SOS Data Report Interval";
    cellModel.unit = @"Min";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldValue = self.dataModel.sosInterval;
    cellModel.textPlaceholder = @"1~10";
    cellModel.maxLength = 2;
    [self.section5List addObject:cellModel];
}

- (void)loadSection6Datas {
    MKMixedChoiceCellButtonModel *timestampModel = [[MKMixedChoiceCellButtonModel alloc] init];
    timestampModel.buttonMsg = @"Timestamp";
    timestampModel.buttonIndex = 0;
    timestampModel.selected = self.dataModel.sosTimestampIsOn;
    
    MKMixedChoiceCellButtonModel *macModel = [[MKMixedChoiceCellButtonModel alloc] init];
    macModel.buttonMsg = @"The Host MAC Address";
    macModel.buttonIndex = 1;
    macModel.selected = self.dataModel.sosMacIsOn;
    
    MKMixedChoiceCellModel *cellModel = [[MKMixedChoiceCellModel alloc] init];
    cellModel.msg = @"Optional Payload Content";
    cellModel.index = 1;
    cellModel.dataList = @[timestampModel,macModel];
    [self.section6List addObject:cellModel];
}

- (void)loadSection7Datas {
    MKLTGPSReportIntervalCellModel *cellModel = [[MKLTGPSReportIntervalCellModel alloc] init];
    cellModel.gpsReportIntervalIndex = self.dataModel.gpsInterval;
    cellModel.nonAlarmReportInterval = [self.dataModel.nonAlarmInterval integerValue];
    
    [self.section7List addObject:cellModel];
}

- (void)loadSection8Datas {
    MKMixedChoiceCellButtonModel *altitudeModel = [[MKMixedChoiceCellButtonModel alloc] init];
    altitudeModel.buttonMsg = @"Altitude";
    altitudeModel.buttonIndex = 0;
    altitudeModel.selected = self.dataModel.gpsAltitudeIsOn;
    
    MKMixedChoiceCellButtonModel *timestampModel = [[MKMixedChoiceCellButtonModel alloc] init];
    timestampModel.buttonMsg = @"Timestamp";
    timestampModel.buttonIndex = 1;
    timestampModel.selected = self.dataModel.gpsTimeStampIsOn;
    
    MKMixedChoiceCellButtonModel *pdopModel = [[MKMixedChoiceCellButtonModel alloc] init];
    pdopModel.buttonMsg = @"PDOP";
    pdopModel.buttonIndex = 2;
    pdopModel.selected = self.dataModel.gpsPDOPIsOn;
    
    MKMixedChoiceCellButtonModel *numberModel = [[MKMixedChoiceCellButtonModel alloc] init];
    numberModel.buttonMsg = @"Number Of Satellites";
    numberModel.buttonIndex = 3;
    numberModel.selected = self.dataModel.gpsSatellitesIsOn;
    
    MKMixedChoiceCellButtonModel *searchModel = [[MKMixedChoiceCellButtonModel alloc] init];
    searchModel.buttonMsg = @"Satellites Search Mode";
    searchModel.buttonIndex = 4;
    searchModel.selected = self.dataModel.gpssearchModelIsOn;
    
    MKMixedChoiceCellModel *cellModel = [[MKMixedChoiceCellModel alloc] init];
    cellModel.msg = @"Optional Payload Content";
    cellModel.index = 2;
    cellModel.dataList = @[altitudeModel,timestampModel,pdopModel,numberModel,searchModel];
    [self.section8List addObject:cellModel];
}

- (void)loadSection9Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 3;
    cellModel.msg = @"3-Axis Payload Report Interval";
    cellModel.unit = @"Min";
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.textFieldValue = self.dataModel.axisInterval;
    cellModel.textPlaceholder = @"1~60";
    cellModel.maxLength = 2;
    [self.section9List addObject:cellModel];
}

- (void)loadSection10Datas {
    MKMixedChoiceCellButtonModel *timestampModel = [[MKMixedChoiceCellButtonModel alloc] init];
    timestampModel.buttonMsg = @"Timestamp";
    timestampModel.buttonIndex = 0;
    timestampModel.selected = self.dataModel.axisTimeStampIsOn;
    
    MKMixedChoiceCellButtonModel *macModel = [[MKMixedChoiceCellButtonModel alloc] init];
    macModel.buttonMsg = @"The Host MAC Address";
    macModel.buttonIndex = 1;
    macModel.selected = self.dataModel.axisMacIsOn;
    
    MKMixedChoiceCellModel *cellModel = [[MKMixedChoiceCellModel alloc] init];
    cellModel.msg = @"Optional Payload Content";
    cellModel.index = 3;
    cellModel.dataList = @[timestampModel,macModel];
    [self.section10List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Uplink Payload";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTUplinkPayloadController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (NSMutableArray *)section5List {
    if (!_section5List) {
        _section5List = [NSMutableArray array];
    }
    return _section5List;
}

- (NSMutableArray *)section6List {
    if (!_section6List) {
        _section6List = [NSMutableArray array];
    }
    return _section6List;
}

- (NSMutableArray *)section7List {
    if (!_section7List) {
        _section7List = [NSMutableArray array];
    }
    return _section7List;
}

- (NSMutableArray *)section8List {
    if (!_section8List) {
        _section8List = [NSMutableArray array];
    }
    return _section8List;
}

- (NSMutableArray *)section9List {
    if (!_section9List) {
        _section9List = [NSMutableArray array];
    }
    return _section9List;
}

- (NSMutableArray *)section10List {
    if (!_section10List) {
        _section10List = [NSMutableArray array];
    }
    return _section10List;
}

- (MKLTUplinkPayloadModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTUplinkPayloadModel alloc] init];
    }
    return _dataModel;
}

@end
