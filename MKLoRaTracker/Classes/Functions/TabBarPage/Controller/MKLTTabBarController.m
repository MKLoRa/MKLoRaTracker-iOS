//
//  MKLTTabBarController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKAlertController.h"

#import "MKLTLoRaController.h"
#import "MKLTScannerController.h"
#import "MKLTSettingController.h"
#import "MKLTDeviceInfoController.h"

#import "MKLTCentralManager.h"

@interface MKLTTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 03:恢复出厂设置成功后，返回结果，断开开连接
/// 04:连续两分钟设备没有数据通信断开，返回结果，断开连接
/// 05:发送关机协议使设备关机，返回结果，断开开连接并关机
@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKLTTabBarController

- (void)dealloc {
    NSLog(@"MKLTTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKLTCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_lt_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_lt_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_lt_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_lt_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_lt_peripheralConnectStateChangedNotification
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_lt_needResetScanDelegate:)]) {
            [self.delegate mk_lt_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_lt_needResetScanDelegate:)]) {
            [self.delegate mk_lt_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //02:修改密码成功后，返回结果，断开连接
    //03:恢复出厂设置成功后，返回结果，断开开连接
    //04:连续两分钟设备没有数据通信断开，返回结果，断开连接
    //05:重启设备
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Password changed successfully! Please reconnect the device." title:@"Change Password"];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self showAlertWithMsg:@"No data communication for 2 minutes, the device is disconnected." title:@""];
        return;
    }
    if ([type isEqualToString:@"03"] || [type isEqualToString:@"05"]) {
        [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType) {
        return;
    }
    if ([MKLTCentralManager shared].centralStatus != mk_lt_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
    if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    MKAlertController *alertController = [MKAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self gotoScanPage];
    }];
    [alertController addAction:moreAction];
    
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_lt_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(presentAlert:) withObject:alertController afterDelay:1.2f];
}

- (void)presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadSubPages {
    MKLTLoRaController *loraPage = [[MKLTLoRaController alloc] init];
    loraPage.tabBarItem.title = @"LORA";
    loraPage.tabBarItem.image = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_adv_tabBarUnselected.png");
    loraPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_adv_tabBarSelected.png");
    MKBaseNavigationController *advNav = [[MKBaseNavigationController alloc] initWithRootViewController:loraPage];

    MKLTScannerController *scannerPage = [[MKLTScannerController alloc] init];
    scannerPage.tabBarItem.title = @"SCANNER";
    scannerPage.tabBarItem.image = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_scanner_tabBarUnselected.png");
    scannerPage.tabBarItem.selectedImage = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_scanner_tabBarSelected.png");
    MKBaseNavigationController *scannerNav = [[MKBaseNavigationController alloc] initWithRootViewController:scannerPage];

    MKLTSettingController *setting = [[MKLTSettingController alloc] init];
    setting.tabBarItem.title = @"SETTINGS";
    setting.tabBarItem.image = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_setting_tabBarUnselected.png");
    setting.tabBarItem.selectedImage = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_setting_tabBarSelected.png");
    MKBaseNavigationController *settingPage = [[MKBaseNavigationController alloc] initWithRootViewController:setting];
    
    MKLTDeviceInfoController *deviceInfo = [[MKLTDeviceInfoController alloc] init];
    deviceInfo.tabBarItem.title = @"DEVICE";
    deviceInfo.tabBarItem.image = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_device_tabBarUnselected.png");
    deviceInfo.tabBarItem.selectedImage = LOADICON(@"MKLoRaTracker", @"MKLTTabBarController", @"lt_device_tabBarSelected.png");
    MKBaseNavigationController *deviceInfoPage = [[MKBaseNavigationController alloc] initWithRootViewController:deviceInfo];
    
    self.viewControllers = @[advNav,scannerNav,settingPage,deviceInfoPage];
}

@end
