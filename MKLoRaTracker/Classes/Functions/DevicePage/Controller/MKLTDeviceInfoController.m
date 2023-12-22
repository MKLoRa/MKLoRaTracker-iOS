//
//  MKLTDeviceInfoController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKLTFirmwareCell.h"

#import "MKLTDeviceInfoDataModel.h"

#import "MKLTUpdateController.h"

@interface MKLTDeviceInfoController ()<UITableViewDelegate,
UITableViewDataSource,
MKLTFirmwareCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKLTDeviceInfoDataModel *dataModel;

@property (nonatomic, assign)BOOL onlyBattery;

/// 用户进入dfu页面开启升级模式，返回该页面，不需要读取任何的数据
@property (nonatomic, assign)BOOL isDfuModel;

@end

@implementation MKLTDeviceInfoController

- (void)dealloc {
    NSLog(@"MKLTDeviceInfoController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isDfuModel) {
        //用户进入dfu页面开启升级模式，返回该页面，不需要读取任何的数据
        [self startReadDatas];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceStartDFUProcess)
                                                 name:@"mk_lt_startDfuProcessNotification"
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lt_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKLTFirmwareCell *cell = [MKLTFirmwareCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - MKLTFirmwareCellDelegate
- (void)mk_firmwareButtonMethod {
    MKLTUpdateController *vc = [[MKLTUpdateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - note
- (void)deviceStartDFUProcess {
    self.isDfuModel = YES;
}

#pragma mark - interface
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel startLoadSystemInformation:self.onlyBattery sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        if (!self.onlyBattery) {
            self.onlyBattery = YES;
        }
        [self loadDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadDatasFromDevice {
    if (ValidStr(self.dataModel.batteryPower)) {
        MKNormalTextCellModel *soc = self.section0List[0];
        soc.rightMsg = [NSString stringWithFormat:@"%@%@",self.dataModel.batteryPower,@"%"];
    }
    if (ValidStr(self.dataModel.macAddress)) {
        MKNormalTextCellModel *mac = self.section0List[1];
        mac.rightMsg = self.dataModel.macAddress;
    }
    if (ValidStr(self.dataModel.productMode)) {
        MKNormalTextCellModel *produceModel = self.section0List[2];
        produceModel.rightMsg = self.dataModel.productMode;
    }
    if (ValidStr(self.dataModel.software)) {
        MKNormalTextCellModel *softwareModel = self.section0List[3];
        softwareModel.rightMsg = self.dataModel.software;
    }
    if (ValidStr(self.dataModel.firmware)) {
        MKLTFirmwareCellModel *firmwareModel = self.section1List[0];
        firmwareModel.rightMsg = self.dataModel.firmware;
    }
    if (ValidStr(self.dataModel.hardware)) {
        MKNormalTextCellModel *hardware = self.section2List[0];
        hardware.rightMsg = self.dataModel.hardware;
    }
    if (ValidStr(self.dataModel.manu)) {
        MKNormalTextCellModel *manuModel = self.section2List[1];
        manuModel.rightMsg = self.dataModel.manu;
    }
    [self.tableView reloadData];
}

#pragma mark -
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *batteryModel = [[MKNormalTextCellModel alloc] init];
    batteryModel.leftMsg = @"Battery Level";
    [self.section0List addObject:batteryModel];
    
    MKNormalTextCellModel *macAddressModel = [[MKNormalTextCellModel alloc] init];
    macAddressModel.leftMsg = @"MAC Address";
    [self.section0List addObject:macAddressModel];
    
    MKNormalTextCellModel *productModel = [[MKNormalTextCellModel alloc] init];
    productModel.leftMsg = @"Product Model";
    [self.section0List addObject:productModel];
    
    MKNormalTextCellModel *softModel = [[MKNormalTextCellModel alloc] init];
    softModel.leftMsg = @"Software Version";
    [self.section0List addObject:softModel];
}

- (void)loadSection1Datas {
    MKLTFirmwareCellModel *cellModel = [[MKLTFirmwareCellModel alloc] init];
    cellModel.msg = @"Firmware Version";
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKNormalTextCellModel *hardModel = [[MKNormalTextCellModel alloc] init];
    hardModel.leftMsg = @"Hardware Version";
    [self.section2List addObject:hardModel];
    
    MKNormalTextCellModel *manufactureModel = [[MKNormalTextCellModel alloc] init];
    manufactureModel.leftMsg = @"Manufacture";
    [self.section2List addObject:manufactureModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"DEVICE";
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

- (MKLTDeviceInfoDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTDeviceInfoDataModel alloc] init];
    }
    return _dataModel;
}

@end
