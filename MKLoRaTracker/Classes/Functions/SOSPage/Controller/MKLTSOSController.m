//
//  MKLTSOSController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTSOSController.h"

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

#import "MKLTSOSPageModel.h"

@interface MKLTSOSController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate,
MKMixedChoiceCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKLTSOSPageModel *dataModel;

@end

@implementation MKLTSOSController

- (void)dealloc {
    NSLog(@"MKLTSOSController销毁");
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
    if (indexPath.section == 2) {
        MKMixedChoiceCellModel *cellModel = self.section2List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKMixedChoiceCell *cell = [MKMixedChoiceCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
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

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.dataModel.interval = value;
        MKTextFieldCellModel *intervalModel = self.section1List[0];
        intervalModel.textFieldValue = value;
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
        MKMixedChoiceCellModel *cellModel = self.section2List[0];
        MKMixedChoiceCellButtonModel *buttonModel = cellModel.dataList[buttonIndex];
        buttonModel.selected = selected;
        if (buttonIndex == 0) {
            //timestamp
            self.dataModel.timestampIsOn = selected;
            return;
        }
        if (buttonIndex == 1) {
            //Mac Address
            self.dataModel.macIsOn = selected;
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
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *checkModel = [[MKTextSwitchCellModel alloc] init];
    checkModel.msg = @"SOS Function Switch";
    checkModel.index = 0;
    checkModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:checkModel];
}

- (void)loadSection1Datas {
    
    MKTextFieldCellModel *intervalModel = [[MKTextFieldCellModel alloc] init];
    intervalModel.index = 0;
    intervalModel.msg = @"SOS Data Report Interval";
    intervalModel.unit = @"Min";
    intervalModel.cellType = mk_realNumberOnly;
    intervalModel.textPlaceholder = @"1~10";
    intervalModel.textFieldTextFont = MKFont(13.f);
    intervalModel.maxLength = 2;
    intervalModel.textFieldValue = self.dataModel.interval;
    [self.section1List addObject:intervalModel];
}

- (void)loadSection2Datas {
    MKMixedChoiceCellButtonModel *timestampModel = [[MKMixedChoiceCellButtonModel alloc] init];
    timestampModel.buttonMsg = @"Timestamp";
    timestampModel.buttonIndex = 0;
    timestampModel.selected = self.dataModel.timestampIsOn;
    
    MKMixedChoiceCellButtonModel *macModel = [[MKMixedChoiceCellButtonModel alloc] init];
    macModel.buttonMsg = @"The Host MAC Address";
    macModel.buttonIndex = 1;
    macModel.selected = self.dataModel.macIsOn;
    
    MKMixedChoiceCellModel *cellModel = [[MKMixedChoiceCellModel alloc] init];
    cellModel.msg = @"Optional Payload Content";
    cellModel.index = 0;
    cellModel.dataList = @[timestampModel,macModel];
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SOS Function";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTSOSController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKLTSOSPageModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTSOSPageModel alloc] init];
    }
    return _dataModel;
}

@end
