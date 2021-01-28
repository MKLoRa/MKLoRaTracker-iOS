//
//  MKLTNetworkCheckController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTNetworkCheckController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"
#import "MKNormalTextCell.h"

#import "MKLTNetworkCheckModel.h"

@interface MKLTNetworkCheckController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKLTNetworkCheckModel *dataModel;

@end

@implementation MKLTNetworkCheckController

- (void)dealloc {
    NSLog(@"MKLTNetworkCheckController销毁");
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
        
        MKTextSwitchCellModel *checkModel = self.section0List[0];
        checkModel.isOn = self.dataModel.checkStatus;
        
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        MKNormalTextCellModel *cellModel = self.section2List[indexPath.row];
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
        return (self.dataModel.checkStatus ? self.section1List.count : 0);
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
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.checkStatus = isOn;
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.dataModel.checkInterval = value;
        MKTextFieldCellModel *intervalModel = self.section1List[0];
        intervalModel.textFieldValue = value;
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
    [self.section0List removeAllObjects];
    MKTextSwitchCellModel *checkModel = [[MKTextSwitchCellModel alloc] init];
    checkModel.msg = @"Networkcheck";
    checkModel.index = 0;
    checkModel.isOn = self.dataModel.checkStatus;
    [self.section0List addObject:checkModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    MKTextFieldCellModel *intervalModel = [[MKTextFieldCellModel alloc] init];
    intervalModel.index = 0;
    intervalModel.msg = @"Networkcheck Interval      ";
    intervalModel.unit = @"              H";
    intervalModel.cellType = mk_realNumberOnly;
    intervalModel.textPlaceholder = @"0~240";
    intervalModel.textFieldTextFont = MKFont(13.f);
    intervalModel.maxLength = 3;
    intervalModel.textFieldValue = self.dataModel.checkInterval;
    [self.section1List addObject:intervalModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    MKNormalTextCellModel *statusModel = [[MKNormalTextCellModel alloc] init];
    statusModel.leftMsg = @"Network Status";
    statusModel.noteMsg = @"*If Networkcheck function off, the Network status will only be valid on OTAA mode when the device in the process of join the network";
    statusModel.noteMsgFont = MKFont(11.f);
    statusModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    statusModel.rightMsg = self.dataModel.networkStatus;
    [self.section2List addObject:statusModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Network Check";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTNetworkCheckController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKLTNetworkCheckModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTNetworkCheckModel alloc] init];
    }
    return _dataModel;
}

@end
