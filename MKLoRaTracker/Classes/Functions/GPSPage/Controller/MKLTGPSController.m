//
//  MKLTGPSController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTGPSController.h"

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

#import "MKLTGPSPageModel.h"

@interface MKLTGPSController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKMixedChoiceCellDelegate,
MKTextButtonCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)MKLTGPSPageModel *dataModel;

@end

@implementation MKLTGPSController

- (void)dealloc {
    NSLog(@"MKLTGPSController销毁");
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
    WS(weakSelf);
    [self.dataModel configDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        //GPS Payload Report Interval
        MKTextButtonCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 3) {
        MKMixedChoiceCellModel *cellModel = self.section3List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
    MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
    cell.dataModel = self.section3List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.isOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
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
        //GPS Payload:GPS Payload Report Interval
        self.dataModel.gpsInterval = dataListIndex;
        MKTextButtonCellModel *cellModel = self.section1List[0];
        cellModel.dataListIndex = dataListIndex;
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.dataModel.searchTime = value;
        MKTextFieldCellModel *cellModel = self.section2List[0];
        cellModel.textFieldValue = value;
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
        //
        MKMixedChoiceCellModel *cellModel = self.section3List[0];
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
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel readDataWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *checkModel = [[MKTextSwitchCellModel alloc] init];
    checkModel.msg = @"GPS Function Switch";
    checkModel.index = 0;
    checkModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:checkModel];
}

- (void)loadSection1Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.msg = @"GPS Payload Report Interval";
    cellModel.index = 0;
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSInteger i = 1; i < 21; i ++) {
        NSString *string = [NSString stringWithFormat:@"%ld",(long)i * 10];
        [list addObject:string];
    }
    cellModel.dataList = list;
    cellModel.dataListIndex = self.dataModel.gpsInterval;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Satellite Search Time";
    cellModel.unit = @"Min";
    cellModel.cellType = mk_realNumberOnly;
    cellModel.textPlaceholder = @"1~10";
    cellModel.textFieldTextFont = MKFont(13.f);
    cellModel.maxLength = 2;
    cellModel.textFieldValue = self.dataModel.searchTime;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
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
    cellModel.index = 0;
    cellModel.dataList = @[altitudeModel,timestampModel,pdopModel,numberModel,searchModel];
    [self.section3List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"GPS Function";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTGPSController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKLTGPSPageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTGPSPageModel alloc] init];
    }
    return _dataModel;
}

@end
