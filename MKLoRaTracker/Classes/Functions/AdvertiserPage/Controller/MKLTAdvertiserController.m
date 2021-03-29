//
//  MKLTAdvertiserController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTAdvertiserController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextFieldCell.h"
#import "MKMeasureTxPowerCell.h"

#import "MKLTAdvertiserDataModel.h"

@interface MKLTAdvertiserController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKMeasureTxPowerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKLTAdvertiserDataModel *dataModel;

@end

@implementation MKLTAdvertiserController

- (void)dealloc {
    NSLog(@"MKLTAdvertiserController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
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
    [self loadSectionDatas];
    [self readDataFromDevice];
}

#pragma mark - super method

- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Saved Successfully!"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60.f;
    }
    if (indexPath.section == 1) {
        return 120.f;
    }
    return 0.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKMeasureTxPowerCell *cell = [MKMeasureTxPowerCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //BLE Name
        self.dataModel.advName = value;
        return;
    }
    if (index == 1) {
        //UUID
        self.dataModel.uuid = value;
        return;
    }
    if (index == 2) {
        //Major
        self.dataModel.major = value;
        return;
    }
    if (index == 3) {
        //Minor
        self.dataModel.minor = value;
        return;
    }
    if (index == 4) {
        //ADV Interval
        self.dataModel.advInterval = value;
        return;
    }
}

#pragma mark - MKMeasureTxPowerCellDelegate
- (void)mk_measureTxPowerCell_measurePowerValueChanged:(NSString *)measurePower {
    self.dataModel.measuredPower = [measurePower integerValue];
}

- (void)mk_measureTxPowerCell_txPowerValueChanged:(mk_deviceTxPower)txPower {
    self.dataModel.txPower = txPower;
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self processCellDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)processCellDatas {
    MKTextFieldCellModel *advNameModel = self.section0List[0];
    advNameModel.textFieldValue = self.dataModel.advName;
    
    MKTextFieldCellModel *uuidModel = self.section0List[1];
    uuidModel.textFieldValue = self.dataModel.uuid;
    
    MKTextFieldCellModel *majorModel = self.section0List[2];
    majorModel.textFieldValue = self.dataModel.major;
    
    MKTextFieldCellModel *minorModel = self.section0List[3];
    minorModel.textFieldValue = self.dataModel.minor;
    
    MKTextFieldCellModel *advIntervalModel = self.section0List[4];
    advIntervalModel.textFieldValue = self.dataModel.advInterval;
    
    MKMeasureTxPowerCellModel *measureModel = self.section1List[0];
    measureModel.measurePower = self.dataModel.measuredPower;
    measureModel.txPower = self.dataModel.txPower;
    
    [self.tableView reloadData];
}

#pragma mark -
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    
    MKTextFieldCellModel *advNameModel = [[MKTextFieldCellModel alloc] init];
    advNameModel.msg = @"ADV Name";
    advNameModel.textPlaceholder = @"1~10 Characters";
    advNameModel.maxLength = 10;
    advNameModel.textFieldType = mk_normal;
    advNameModel.index = 0;
    [self.section0List addObject:advNameModel];
    
    MKTextFieldCellModel *uuidModel = [[MKTextFieldCellModel alloc] init];
    uuidModel.msg = @"Proximity UUID";
    uuidModel.textPlaceholder = @"16 Bytes";
    uuidModel.textFieldType = mk_uuidMode;
    uuidModel.index = 1;
    [self.section0List addObject:uuidModel];
    
    MKTextFieldCellModel *majorModel = [[MKTextFieldCellModel alloc] init];
    majorModel.msg = @"Major";
    majorModel.textPlaceholder = @"0~65535";
    majorModel.maxLength = 5;
    majorModel.textFieldType = mk_realNumberOnly;
    majorModel.index = 2;
    [self.section0List addObject:majorModel];
    
    MKTextFieldCellModel *minorModel = [[MKTextFieldCellModel alloc] init];
    minorModel.msg = @"Minor";
    minorModel.textPlaceholder = @"0~65535";
    minorModel.maxLength = 5;
    minorModel.textFieldType = mk_realNumberOnly;
    minorModel.index = 3;
    [self.section0List addObject:minorModel];
    
    MKTextFieldCellModel *advIntervalModel = [[MKTextFieldCellModel alloc] init];
    advIntervalModel.msg = @"ADV Interval";
    advIntervalModel.textPlaceholder = @"1~100";
    advIntervalModel.maxLength = 3;
    advIntervalModel.textFieldType = mk_realNumberOnly;
    advIntervalModel.unit = @"x 100ms";
    advIntervalModel.index = 4;
    [self.section0List addObject:advIntervalModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    MKMeasureTxPowerCellModel *cellModel = [[MKMeasureTxPowerCellModel alloc] init];
    [self.section1List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Advertiser";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTAdvertiserController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKLTAdvertiserDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTAdvertiserDataModel alloc] init];
    }
    return _dataModel;
}

@end
