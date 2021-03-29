//
//  MKLTLoRaController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTLoRaController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextFieldCell.h"

#import "MKLTLoRaDataModel.h"

#import "MKLTLoRaSettingController.h"
#import "MKLTNetworkCheckController.h"
#import "MKLTUplinkPayloadController.h"

@interface MKLTLoRaController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKLTLoRaDataModel *dataModel;

@end

@implementation MKLTLoRaController

- (void)dealloc {
    NSLog(@"MKLTLoRaController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
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
    [self.dataModel configWithSucBlock:^{
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
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //LoRa Setting
        MKLTLoRaSettingController *vc = [[MKLTLoRaSettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        //Network Check
        MKLTNetworkCheckController *vc = [[MKLTNetworkCheckController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        //Uplink Payload
        MKLTUplinkPayloadController *vc = [[MKLTUplinkPayloadController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
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
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
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

#pragma mark - MKTextFieldCellDelegate
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.dataModel.syncInterval = value;
        MKTextFieldCellModel *intervalModel = self.section1List[0];
        intervalModel.textFieldValue = value;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
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
    MKNormalTextCellModel *loraSettingModel = self.section0List[0];
    loraSettingModel.rightMsg = [NSString stringWithFormat:@"%@/%@/%@",self.dataModel.modem,self.dataModel.region,self.dataModel.classType];
    MKNormalTextCellModel *connectModel = self.section0List[1];
    connectModel.rightMsg = self.dataModel.networkStatus;
    
    MKTextFieldCellModel *intervalModel = self.section1List[0];
    intervalModel.textFieldValue = self.dataModel.syncInterval;
    [self.tableView reloadData];
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
    MKNormalTextCellModel *loraSettingModel = [[MKNormalTextCellModel alloc] init];
    loraSettingModel.leftMsg = @"LoRa Setting";
    loraSettingModel.showRightIcon = YES;
    [self.section0List addObject:loraSettingModel];
    
    MKNormalTextCellModel *connectModel = [[MKNormalTextCellModel alloc] init];
    connectModel.leftMsg = @"Network Check";
    connectModel.showRightIcon = YES;
    [self.section0List addObject:connectModel];
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    
    MKTextFieldCellModel *intervalModel = [[MKTextFieldCellModel alloc] init];
    intervalModel.index = 0;
    intervalModel.msg = @"Time sync Interval             ";
    intervalModel.unit = @"              H";
    intervalModel.cellType = mk_realNumberOnly;
    intervalModel.textPlaceholder = @"0~240";
    intervalModel.textFieldTextFont = MKFont(13.f);
    intervalModel.maxLength = 3;
    [self.section1List addObject:intervalModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    MKNormalTextCellModel *payloadModel = [[MKNormalTextCellModel alloc] init];
    payloadModel.leftMsg = @"Uplink Payload";
    payloadModel.showRightIcon = YES;
    [self.section2List addObject:payloadModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"LORA";
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTLoRaController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
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

- (MKLTLoRaDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTLoRaDataModel alloc] init];
    }
    return _dataModel;
}

@end
