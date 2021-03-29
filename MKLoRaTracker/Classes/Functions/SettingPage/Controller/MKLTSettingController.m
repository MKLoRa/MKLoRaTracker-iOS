//
//  MKLTSettingController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTSettingController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextButtonCell.h"
#import "MKTextSwitchCell.h"

#import "MKLTInterface+MKLTConfig.h"

#import "MKLTConnectModel.h"

#import "MKLTSettingDataModel.h"

#import "MKLTAdvertiserController.h"
#import "MKLTVibrationSettingController.h"
#import "MKLTSOSController.h"
#import "MKLTGPSController.h"
#import "MKLTAxisController.h"

@interface MKLTSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextButtonCellDelegate,
mk_textSwitchCellDelegate
>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKLTSettingDataModel *dataModel;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

/// 当前present的alert
@property (nonatomic, strong)UIAlertController *currentAlert;

@property (nonatomic, copy)NSString *passwordAsciiStr;

@property (nonatomic, copy)NSString *confirmAsciiStr;

@end

@implementation MKLTSettingController

- (void)dealloc {
    NSLog(@"MKLTSettingController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self loadSectionsData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissAlert)
                                                 name:@"mk_lt_settingPageNeedDismissAlert"
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lt_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCellModel *cellModel = self.section0List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 1) {
        MKTextSwitchCellModel *cellModel = self.section1List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    if (indexPath.section == 2) {
        MKTextButtonCellModel *cellModel = self.section2List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCellModel *cellModel = self.section0List[indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
            [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
        }
#pragma clang diagnostic pop
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
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextButtonCell *cell = [MKTextButtonCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Connectable
        [self configConnectEnable:isOn];
        return;
    }
    if (index == 1) {
        //Power Off
        [self powerOff];
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
        //低电量报警
        [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
        [MKLTInterface lt_configLowPowerPrompt:(dataListIndex + 1) sucBlock:^{
            [[MKHudManager share] hide];
            
            MKTextButtonCellModel *cellModel = self.section2List[0];
            cellModel.dataListIndex = dataListIndex;
            cellModel.noteMsg = [NSString stringWithFormat:@"*When the battery is less than or equal to %@, the red LED will flashe once every 30 seconds.",value];
            [self.tableView mk_reloadRow:0 inSection:2 withRowAnimation:UITableViewRowAnimationNone];
            
        } failedBlock:^(NSError * _Nonnull error) {
            [[MKHudManager share] hide];
            [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        }];
        return;
    }
}

#pragma mark - note
- (void)dismissAlert {
    if (self.currentAlert && (self.presentedViewController == self.currentAlert)) {
        [self.currentAlert dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - section0 的点击事件
- (void)pushAdvertiserPage {
    MKLTAdvertiserController *vc = [[MKLTAdvertiserController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushVibrationSettingPage {
    MKLTVibrationSettingController *vc = [[MKLTVibrationSettingController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushSOSFunctionPage {
    MKLTSOSController *vc = [[MKLTSOSController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushGPSFunctionPage {
    MKLTGPSController *vc = [[MKLTGPSController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushAxisSensorPage {
    MKLTAxisController *vc = [[MKLTAxisController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置密码
- (void)configPassword{
    @weakify(self);
    self.currentAlert = nil;
    NSString *msg = @"Note:The password should be 8 characters.";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Change Password"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.passwordTextField = nil;
        self.passwordTextField = textField;
        self.passwordAsciiStr = @"";
        [self.passwordTextField setPlaceholder:@"Enter new password"];
        [self.passwordTextField addTarget:self
                                   action:@selector(passwordTextFieldValueChanged:)
                         forControlEvents:UIControlEventEditingChanged];
    }];
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.confirmTextField = nil;
        self.confirmTextField = textField;
        self.confirmAsciiStr = @"";
        [self.confirmTextField setPlaceholder:@"Enter new password again"];
        [self.confirmTextField addTarget:self
                                  action:@selector(passwordTextFieldValueChanged:)
                        forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setPasswordToDevice];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)passwordTextFieldValueChanged:(UITextField *)textField{
    NSString *inputValue = textField.text;
    if (!ValidStr(inputValue)) {
        textField.text = @"";
        if (textField == self.passwordTextField) {
            self.passwordAsciiStr = @"";
        }else if (textField == self.confirmTextField) {
            self.confirmAsciiStr = @"";
        }
        return;
    }
    NSInteger strLen = inputValue.length;
    NSInteger dataLen = [inputValue dataUsingEncoding:NSUTF8StringEncoding].length;
    
    NSString *currentStr = @"";
    if (textField == self.passwordTextField) {
        currentStr = self.passwordAsciiStr;
    }else {
        currentStr = self.confirmAsciiStr;
    }
    if (dataLen == strLen) {
        //当前输入是ascii字符
        currentStr = inputValue;
    }
    if (currentStr.length > 8) {
        textField.text = [currentStr substringToIndex:8];
        if (textField == self.passwordTextField) {
            self.passwordAsciiStr = [currentStr substringToIndex:8];
        }else {
            self.confirmAsciiStr = [currentStr substringToIndex:8];
        }
    }else {
        textField.text = currentStr;
        if (textField == self.passwordTextField) {
            self.passwordAsciiStr = currentStr;
        }else {
            self.confirmAsciiStr = currentStr;
        }
    }
}

- (void)setPasswordToDevice{
    NSString *password = self.passwordTextField.text;
    NSString *confirmpassword = self.confirmTextField.text;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length != 8 || confirmpassword.length != 8) {
        [self.view showCentralToast:@"The password should be 8 characters.Please try again."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"Password do not match! Please try again."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKLTInterface lt_configPassword:password sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Password changed successfully!Please reconnect the device."];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset{
    NSString *msg = @"After factory reset,all the data will be reseted to the factory values.";
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Factory Reset"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.currentAlert addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self sendResetCommandToDevice];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKLTInterface lt_FactoryResetWithSucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Factory reset successfully!Please reconnect the device."];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置可连接性
- (void)configConnectEnable:(BOOL)connect{
    NSString *msg = (connect ? @"Are you sure to make the device connectable?" : @"Are you sure to make the device unconnectable?");
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = !connect;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setConnectStatusToDevice:connect];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKLTInterface lt_configConnectableStatus:connect sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = connect;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = !connect;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 开关机
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the device? Please make sure the device has a button to turn on!";
    self.currentAlert = nil;
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        MKTextSwitchCellModel *model = self.section1List[1];
        model.isOn = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self commandPowerOff];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKLTInterface lt_powerOffWithSucBlock:^{
        [[MKHudManager share] hide];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[1];
        model.isOn = YES;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
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
    MKNormalTextCellModel *nameModel = self.section0List[0];
    nameModel.rightMsg = self.dataModel.advName;
    
    MKTextSwitchCellModel *connectableModel = self.section1List[0];
    connectableModel.isOn = self.dataModel.connectable;
    
    MKTextButtonCellModel *cellModel = self.section2List[0];
    cellModel.dataListIndex = self.dataModel.lowPowerAlarm;
    cellModel.noteMsg = [NSString stringWithFormat:@"*When the battery is less than or equal to %@, the red LED will flashe once every 30 seconds.",cellModel.dataList[self.dataModel.lowPowerAlarm]];
    
    [self.tableView reloadData];
}

#pragma mark - loadSectionsData
- (void)loadSectionsData {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"Advertiser";
    cellModel1.showRightIcon = YES;
    cellModel1.methodName = @"pushAdvertiserPage";
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Vibration Setting";
    cellModel2.showRightIcon = YES;
    cellModel2.methodName = @"pushVibrationSettingPage";
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.leftMsg = @"SOS Function";
    cellModel3.showRightIcon = YES;
    cellModel3.methodName = @"pushSOSFunctionPage";
    [self.section0List addObject:cellModel3];
    
    if ([MKLTConnectModel shared].supportGps) {
        MKNormalTextCellModel *cellModel4 = [[MKNormalTextCellModel alloc] init];
        cellModel4.leftMsg = @"GPS Function";
        cellModel4.showRightIcon = YES;
        cellModel4.methodName = @"pushGPSFunctionPage";
        [self.section0List addObject:cellModel4];
    }
    
    MKNormalTextCellModel *cellModel5 = [[MKNormalTextCellModel alloc] init];
    cellModel5.leftMsg = @"3-Axis Sensor";
    cellModel5.showRightIcon = YES;
    cellModel5.methodName = @"pushAxisSensorPage";
    [self.section0List addObject:cellModel5];
    
    MKNormalTextCellModel *cellModel6 = [[MKNormalTextCellModel alloc] init];
    cellModel6.leftMsg = @"Change Password";
    cellModel6.showRightIcon = YES;
    cellModel6.methodName = @"configPassword";
    [self.section0List addObject:cellModel6];
    
    MKNormalTextCellModel *cellModel7 = [[MKNormalTextCellModel alloc] init];
    cellModel7.leftMsg = @"Factory Reset";
    cellModel7.showRightIcon = YES;
    cellModel7.methodName = @"factoryReset";
    [self.section0List addObject:cellModel7];
}

- (void)loadSection1Datas {
    MKTextSwitchCellModel *cellModel1 = [[MKTextSwitchCellModel alloc] init];
    cellModel1.msg = @"Connectable";
    cellModel1.index = 0;
    [self.section1List addObject:cellModel1];
    
    MKTextSwitchCellModel *cellModel2 = [[MKTextSwitchCellModel alloc] init];
    cellModel2.msg = @"Power Off";
    cellModel2.index = 1;
    [self.section1List addObject:cellModel2];
}

- (void)loadSection2Datas {
    MKTextButtonCellModel *cellModel = [[MKTextButtonCellModel alloc] init];
    cellModel.msg = @"Low Power Prompt Setting";
    cellModel.index = 0;
    cellModel.dataList = @[@"10%",@"20%",@"30%",@"40%",@"50%",@"60%"];
    cellModel.noteMsg = @"*When the battery is less than or equal to 10%, the red LED will flashe once every 30 seconds.";
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SETTINGS";
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

- (MKLTSettingDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTSettingDataModel alloc] init];
    }
    return _dataModel;
}

@end
