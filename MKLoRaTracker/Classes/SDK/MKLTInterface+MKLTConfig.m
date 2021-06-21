//
//  MKLTInterface+MKLTConfig.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTInterface+MKLTConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKLTCentralManager.h"
#import "MKLTOperationID.h"
#import "MKLTOperation.h"
#import "CBPeripheral+MKLTAdd.h"

#define centralManager [MKLTCentralManager shared]
#define peripheral ([MKLTCentralManager shared].peripheral)

@implementation MKLTInterface (MKLTConfig)

#pragma mark ****************************************设备系统应用信息设置************************************************

/// Configure time synchronization interval.
/// @param interval 0h~254h
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 254) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed011e01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigTimeSyncIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBeaconProximityUUID:(NSString *)uuid
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBLEBaseSDKAdopter isUUIDString:uuid]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *commandString = [@"ed012010" stringByAppendingString:uuid];
    [self configDataWithTaskID:mk_lt_taskConfigBeaconProximityUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configMajor:(NSInteger)major
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (major < 0 || major > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)major];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed012102" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configMinor:(NSInteger)minor
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    if (minor < 0 || minor > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)minor];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed012202" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configMeasuredPower:(NSInteger)measuredPower
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (measuredPower > 0 || measuredPower < -127) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *power = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:measuredPower];
    NSString *commandString = [@"ed012301" stringByAppendingString:power];
    [self configDataWithTaskID:mk_lt_taskConfigMeasuredPowerOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configTxPower:(mk_lt_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ed012401" stringByAppendingString:[self fetchTxPower:txPower]];
    [self configDataWithTaskID:mk_lt_taskConfigTxPowerOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBroadcastInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed012501" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigBroadcastIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(deviceName) || deviceName.length < 1 || deviceName.length > 10
        || ![MKBLEBaseSDKAdopter asciiString:deviceName]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ed0126%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_lt_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length != 8) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"ed012708" stringByAppendingString:commandData];
    [self configDataWithTaskID:mk_lt_taskConfigPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)timestamp];
    NSString *commandString = [@"ed012804" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configScanWindow:(mk_lt_scanWindowType)scanWindow
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01290100";
    if (scanWindow == mk_lt_scanWindowTypeLow) {
        commandString = @"ed01290101";
    }else if (scanWindow == mk_lt_scanWindowTypeMedium) {
        commandString = @"ed01290102";
    }else if (scanWindow == mk_lt_scanWindowTypeStrong) {
        commandString = @"ed01290103";
    }
    [self configDataWithTaskID:mk_lt_taskConfigScanWindowOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configConnectableStatus:(BOOL)connectable
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (connectable ? @"ed012a0101" : @"ed012a0100");
    [self configDataWithTaskID:mk_lt_taskConfigConnectableStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************设备lorawan信息设置************************************************

+ (void)lt_configModem:(mk_lt_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (modem == mk_lt_loraWanModemABP) ? @"ed012b0101" : @"ed012b0102";
    [self configDataWithTaskID:mk_lt_taskConfigModemOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configRegion:(mk_lt_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed012c01",[self lorawanRegionString:region]];
    [self configDataWithTaskID:mk_lt_taskConfigRegionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devEUI) || devEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:devEUI]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012d08" stringByAppendingString:devEUI];
    [self configDataWithTaskID:mk_lt_taskConfigDEVEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appEUI) || appEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:appEUI]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012e08" stringByAppendingString:appEUI];
    [self configDataWithTaskID:mk_lt_taskConfigAPPEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appKey) || appKey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appKey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed012f10" stringByAppendingString:appKey];
    [self configDataWithTaskID:mk_lt_taskConfigAPPKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devAddr) || devAddr.length != 8 || ![MKBLEBaseSDKAdopter checkHexCharacter:devAddr]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed013004" stringByAppendingString:devAddr];
    [self configDataWithTaskID:mk_lt_taskConfigDEVADDROperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appSkey) || appSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appSkey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed013110" stringByAppendingString:appSkey];
    [self configDataWithTaskID:mk_lt_taskConfigAPPSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(nwkSkey) || nwkSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:nwkSkey]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed013210" stringByAppendingString:nwkSkey];
    [self configDataWithTaskID:mk_lt_taskConfigNWKSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock {
    if (chlValue < 0 || chlValue > 95 || chhValue < chlValue || chhValue > 95) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lowValue = [NSString stringWithFormat:@"%1lx",(unsigned long)chlValue];
    if (lowValue.length == 1) {
        lowValue = [@"0" stringByAppendingString:lowValue];
    }
    NSString *highValue = [NSString stringWithFormat:@"%1lx",(unsigned long)chhValue];
    if (highValue.length == 1) {
        highValue = [@"0" stringByAppendingString:highValue];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed013302",lowValue,highValue];
    [self configDataWithTaskID:mk_lt_taskConfigCHValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock {
    if (drValue < 0 || drValue > 15) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)drValue];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed013401",value];
    [self configDataWithTaskID:mk_lt_taskConfigDRValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configADRStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01350101" : @"ed01350100");
    [self configDataWithTaskID:mk_lt_taskConfigADRStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configMessageType:(mk_lt_loraWanMessageType)messageType
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (messageType == mk_lt_loraWanUnconfirmMessage) ? @"ed01360100" : @"ed01360101";
    [self configDataWithTaskID:mk_lt_taskConfigMessageTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configNetworkCheckInterval:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 254) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed013801",value];
    [self configDataWithTaskID:mk_lt_taskConfigNetworkCheckIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAlarmTriggerRSSI:(NSInteger)rssi
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [@"ed013901" stringByAppendingString:rssiValue];
    [self configDataWithTaskID:mk_lt_taskConfigAlarmTriggerRSSIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAlarmNotificationType:(mk_lt_alarmNotificationType)type
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed013a0100";
    if (type == mk_lt_alarmNotificationLight) {
        commandString = @"ed013a0101";
    }else if (type == mk_lt_alarmNotificationVibration) {
        commandString = @"ed013a0102";
    }else if (type == mk_lt_alarmNotificationLightAndVibration) {
        commandString = @"ed013a0103";
    }
    [self configDataWithTaskID:mk_lt_taskConfigAlarmNotificationTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configVibrationIntensity:(NSInteger)intensity
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (intensity < 0 || intensity > 2) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = @"ed013b0100";
    if (intensity == 1) {
        commandString = @"ed013b0132";
    }else if (intensity == 2) {
        commandString = @"ed013b0164";
    }
    [self configDataWithTaskID:mk_lt_taskConfigVibrationIntensityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDurationOfVibration:(NSInteger)duration
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (duration < 0 || duration > 255) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)duration];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed013c01",value];
    [self configDataWithTaskID:mk_lt_taskConfigDurationOfVibrationOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configVibrationCycleOfMotor:(NSInteger)cycle
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (cycle < 1 || cycle > 600) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)cycle];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed013d02",value];
    [self configDataWithTaskID:mk_lt_taskConfigVibrationCycleOfMotorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configLowPowerPrompt:(NSInteger)percentage
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (percentage < 1 || percentage > 6) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)(percentage * 10)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed014101",value];
    [self configDataWithTaskID:mk_lt_taskConfigLowPowerPromptOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configScanDatasReportInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 60) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed014201",value];
    [self configDataWithTaskID:mk_lt_taskConfigScanDatasReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark -
+ (void)lt_configValidBLEDataFilterInterval:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 600) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"000" stringByAppendingString:value];
    }else if (value.length == 2) {
        value = [@"00" stringByAppendingString:value];
    }else if (value.length == 3) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015502",value];
    [self configDataWithTaskID:mk_lt_taskConfigValidBLEDataFilterIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDeviceInfoReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 2 || interval > 120) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed015601",value];
    [self configDataWithTaskID:mk_lt_taskConfigDeviceInfoReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configGatheringWarningRssi:(NSInteger)rssi
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [@"ed015801" stringByAppendingString:rssiValue];
    [self configDataWithTaskID:mk_lt_taskConfigGatheringWarningRssiOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_connectNetworkWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015c0101";
    [self configDataWithTaskID:mk_lt_taskConfigConnectNetworkOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015d0101";
    [self configDataWithTaskID:mk_lt_taskConfigDevicePowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_FactoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed015e0101";
    [self configDataWithTaskID:mk_lt_taskConfigDeviceFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAlarmOptionalPayloadContentWithBatteryIsOn:(BOOL)batteryIsOn
                                                    macIsOn:(BOOL)macIsOn
                                                    rawIsOn:(BOOL)rawIsOn
                                                   sucBlock:(void (^)(void))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *byteStr = [NSString stringWithFormat:@"00000%@%@%@",rawIsOn ? @"1" : @"0",macIsOn ? @"1" : @"0",batteryIsOn ? @"1" : @"0"];
    NSString *value = [NSString stringWithFormat:@"%1lx",strtoul([byteStr UTF8String], 0, 2)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed017101" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigAlarmOptionalPayloadContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configReportNumberOfBeacons:(NSInteger)number
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 4) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)number];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed017201",value];
    [self configDataWithTaskID:mk_lt_taskConfigReportNumberOfBeaconsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorSampleRate:(mk_lt_threeAxisDataSamplingRate)rate
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01730100";
    if (rate == mk_lt_threeAxisDataSamplingRate1) {
        commandString = @"ed01730101";
    }else if (rate == mk_lt_threeAxisDataSamplingRate2) {
        commandString = @"ed01730102";
    }else if (rate == mk_lt_threeAxisDataSamplingRate3) {
        commandString = @"ed01730103";
    }else if (rate == mk_lt_threeAxisDataSamplingRate4) {
        commandString = @"ed01730104";
    }
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorSampleRateOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorGravitationalacceleration:(mk_lt_threeAxisGravitationalAcceleration)gravitational
                                            sucBlock:(void (^)(void))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01740100";
    if (gravitational == mk_lt_threeAxisGravitationalAcceleration1) {
        commandString = @"ed01740101";
    }else if (gravitational == mk_lt_threeAxisGravitationalAcceleration2) {
        commandString = @"ed01740102";
    }else if (gravitational == mk_lt_threeAxisGravitationalAcceleration3) {
        commandString = @"ed01740103";
    }
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorGravitationalaccelerationOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorTriggerSensitivity:(NSInteger)sensitivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (sensitivity < 7 || sensitivity > 255) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)sensitivity];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed017501",value];
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorTriggerSensitivityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorSwitchStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01760101" : @"ed01760100");
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorSwitchStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorDataReportInterval:(NSInteger)interval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 60) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed017701",value];
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorDataReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorDataStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01780101" : @"ed01780100");
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorDataStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configAxisSensorReportDataContentTypeWithTimestampIsOn:(BOOL)timestampIsOn
                                                          macIsOn:(BOOL)macIsOn
                                                         sucBlock:(void (^)(void))sucBlock
                                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *byteStr = [NSString stringWithFormat:@"000000%@%@",timestampIsOn ? @"1" : @"0",macIsOn ? @"1" : @"0"];
    NSString *value = [NSString stringWithFormat:@"%1lx",strtoul([byteStr UTF8String], 0, 2)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed017a01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigAxisSensorReportDataContentTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configSOSSwitchStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed017b0101" : @"ed017b0100");
    [self configDataWithTaskID:mk_lt_taskConfigSOSSwitchStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configSOSDataReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 10) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)interval];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed017c01",value];
    [self configDataWithTaskID:mk_lt_taskConfigSOSDataReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configSOSReportDataContentTypeWithTimestampIsOn:(BOOL)timestampIsOn
                                                   macIsOn:(BOOL)macIsOn
                                                  sucBlock:(void (^)(void))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *byteStr = [NSString stringWithFormat:@"000000%@%@",macIsOn ? @"1" : @"0",timestampIsOn ? @"1" : @"0"];
    NSString *value = [NSString stringWithFormat:@"%1lx",strtoul([byteStr UTF8String], 0, 2)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed017d01" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigSOSReportDataContentTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configGPSSwitchStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed017f0101" : @"ed017f0100");
    [self configDataWithTaskID:mk_lt_taskConfigGPSSwitchStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configGPSSatellitesSearchTime:(NSInteger)time
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 1 || time > 10) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)time];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed018001",value];
    [self configDataWithTaskID:mk_lt_taskConfigGPSSatellitesSearchTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configGPSDataReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 20) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [NSString stringWithFormat:@"%1lx",(unsigned long)(interval * 10)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed018101",value];
    [self configDataWithTaskID:mk_lt_taskConfigGPSDataReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configGPSReportDataContentTypeWithAltitudeIsOn:(BOOL)altitudeIsOn
                                            timestampIsOn:(BOOL)timestampIsOn
                                           searchModeIsOn:(BOOL)searchModeIsOn
                                                 pdopIsOn:(BOOL)pdopIsOn
                                   numberOfSatellitesIsOn:(BOOL)numberOfSatellitesIsOn
                                                 sucBlock:(void (^)(void))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *byteStr = [NSString stringWithFormat:@"000%@%@%@%@%@",numberOfSatellitesIsOn ? @"1" : @"0",pdopIsOn ? @"1" : @"0",searchModeIsOn ? @"1" : @"0",timestampIsOn ? @"1" : @"0",altitudeIsOn ? @"1" : @"0"];
    NSString *value = [NSString stringWithFormat:@"%1lx",strtoul([byteStr UTF8String], 0, 2)];
    if (value.length == 1) {
        value = [@"0" stringByAppendingString:value];
    }
    NSString *commandString = [@"ed018201" stringByAppendingString:value];
    [self configDataWithTaskID:mk_lt_taskConfigGPSReportDataContentTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configUpLinkeDellTime:(NSInteger)time
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (time != 0 && time != 1) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = (time == 0 ? @"ed01830100" : @"ed01830101");
    [self configDataWithTaskID:mk_lt_taskConfigUpLinkeDellTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01840101" : @"ed01840100");
    [self configDataWithTaskID:mk_lt_taskConfigDutyCycleStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBeaconReportSwitchStatus:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed01850101" : @"ed01850100");
    [self configDataWithTaskID:mk_lt_taskConfigBeaconReportSwitchStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************过滤规则配置************************************************

/// Configure filtered RSSI.
/// @param type type
/// @param rssi -127dBm~0dBm
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceRSSIWithType:(mk_lt_filterRulesType)type
                                        rssi:(NSInteger)rssi
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterRssiOperation;
    NSString *cmd = @"43";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterRssiOperation;
        cmd = @"4a";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterRssiOperation;
        cmd = @"5f";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterRssiOperation;
        cmd = @"66";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed01",cmd,@"01",rssiValue];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterDeviceNameWithType:(mk_lt_filterRulesType)type
                                       rules:(mk_lt_filterRules)rules
                                  deviceName:(NSString *)deviceName
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (rules != mk_lt_filterRules_off && (!MKValidStr(deviceName) || deviceName.length > 10)) {
        //1~10 ascii characters.If rules == mk_lt_filterRules_off, it can be empty.
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    deviceName = (deviceName ? deviceName : @"");
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)(deviceName.length + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *rulesString = @"00";
    if (rules == mk_lt_filterRules_forward) {
        rulesString = @"01";
    }else if (rules == mk_lt_filterRules_reverse) {
        rulesString = @"02";
    }
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterDeviceNameOperation;
    NSString *cmd = @"44";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterDeviceNameOperation;
        cmd = @"4b";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterDeviceNameOperation;
        cmd = @"60";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterDeviceNameOperation;
        cmd = @"67";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",cmd,lenString,rulesString,tempString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterDeviceMacWithType:(mk_lt_filterRulesType)type
                                      rules:(mk_lt_filterRules)rules
                                        mac:(NSString *)mac
                                 sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterMacOperation;
    NSString *cmd = @"45";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterMacOperation;
        cmd = @"4c";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterMacOperation;
        cmd = @"61";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterMacOperation;
        cmd = @"68";
    }
    if (rules == mk_lt_filterRules_off) {
        //关闭过滤
        NSString *commandString = [NSString stringWithFormat:@"ed01%@0100",cmd];
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    mac = [mac stringByReplacingOccurrencesOfString:@":" withString:@""];
    mac = [mac stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (!MKValidStr(mac) || mac.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:mac] || mac.length % 2 != 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rulesString = @"00";
    if (rules == mk_lt_filterRules_forward) {
        rulesString = @"01";
    }else if (rules == mk_lt_filterRules_reverse) {
        rulesString = @"02";
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)((mac.length / 2) + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",cmd,lenString,rulesString,mac];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterDeviceMajorWithType:(mk_lt_filterRulesType)type
                                        rules:(mk_lt_filterRules)rules
                                     majorMin:(NSInteger)majorMin
                                     majorMax:(NSInteger)majorMax
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterMajorOperation;
    NSString *cmd = @"46";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterMajorOperation;
        cmd = @"4d";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterMajorOperation;
        cmd = @"62";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterMajorOperation;
        cmd = @"69";
    }
    if (rules == mk_lt_filterRules_off) {
        //关闭过滤
        NSString *commandString = [NSString stringWithFormat:@"ed01%@0100",cmd];
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (majorMin < 0 || majorMin > 65535 || majorMax < majorMin || majorMax > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [NSString stringWithFormat:@"%1lx",(unsigned long)majorMin];
    if (minString.length == 1) {
        minString = [@"000" stringByAppendingString:minString];
    }else if (minString.length == 2) {
        minString = [@"00" stringByAppendingString:minString];
    }else if (minString.length == 3) {
        minString = [@"0" stringByAppendingString:minString];
    }
    NSString *maxString = [NSString stringWithFormat:@"%1lx",(unsigned long)majorMax];
    if (maxString.length == 1) {
        maxString = [@"000" stringByAppendingString:maxString];
    }else if (maxString.length == 2) {
        maxString = [@"00" stringByAppendingString:maxString];
    }else if (maxString.length == 3) {
        maxString = [@"0" stringByAppendingString:maxString];
    }
    NSString *rulesString = @"00";
    if (rules == mk_lt_filterRules_forward) {
        rulesString = @"01";
    }else if (rules == mk_lt_filterRules_reverse) {
        rulesString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ed01",cmd,@"05",rulesString,minString,maxString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterDeviceMinorWithType:(mk_lt_filterRulesType)type
                                        rules:(mk_lt_filterRules)rules
                                     minorMin:(NSInteger)minorMin
                                     minorMax:(NSInteger)minorMax
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterMinorOperation;
    NSString *cmd = @"47";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterMinorOperation;
        cmd = @"4e";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterMinorOperation;
        cmd = @"63";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterMinorOperation;
        cmd = @"6a";
    }
    if (rules == mk_lt_filterRules_off) {
        //关闭过滤
        NSString *commandString = [NSString stringWithFormat:@"ed01%@0100",cmd];
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (minorMin < 0 || minorMin > 65535 || minorMax < minorMin || minorMax > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [NSString stringWithFormat:@"%1lx",(unsigned long)minorMin];
    if (minString.length == 1) {
        minString = [@"000" stringByAppendingString:minString];
    }else if (minString.length == 2) {
        minString = [@"00" stringByAppendingString:minString];
    }else if (minString.length == 3) {
        minString = [@"0" stringByAppendingString:minString];
    }
    NSString *maxString = [NSString stringWithFormat:@"%1lx",(unsigned long)minorMax];
    if (maxString.length == 1) {
        maxString = [@"000" stringByAppendingString:maxString];
    }else if (maxString.length == 2) {
        maxString = [@"00" stringByAppendingString:maxString];
    }else if (maxString.length == 3) {
        maxString = [@"0" stringByAppendingString:maxString];
    }
    NSString *rulesString = @"00";
    if (rules == mk_lt_filterRules_forward) {
        rulesString = @"01";
    }else if (rules == mk_lt_filterRules_reverse) {
        rulesString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ed01",cmd,@"05",rulesString,minString,maxString];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterDeviceUUIDWithType:(mk_lt_filterRulesType)type
                                       rules:(mk_lt_filterRules)rules
                                        uuid:(NSString *)uuid
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterUUIDOperation;
    NSString *cmd = @"48";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterUUIDOperation;
        cmd = @"4f";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterUUIDOperation;
        cmd = @"64";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterUUIDOperation;
        cmd = @"6b";
    }
    if (rules == mk_lt_filterRules_off) {
        //关闭过滤
        NSString *commandString = [NSString stringWithFormat:@"ed01%@0100",cmd];
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length > 32 || uuid.length % 2 != 0) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    uuid = [uuid stringByReplacingOccurrencesOfString:@":" withString:@""];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)((uuid.length / 2) + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *rulesString = @"00";
    if (rules == mk_lt_filterRules_forward) {
        rulesString = @"01";
    }else if (rules == mk_lt_filterRules_reverse) {
        rulesString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",cmd,lenString,rulesString,uuid];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterDeviceRawDataWithType:(mk_lt_filterRulesType)type
                                          rules:(mk_lt_filterRules)rules
                                    rawDataList:(NSArray <mk_lt_BLEFilterRawDataProtocol> *)rawDataList
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterRawDataOperation;
    NSString *cmd = @"49";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterRawDataOperation;
        cmd = @"50";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterRawDataOperation;
        cmd = @"65";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterRawDataOperation;
        cmd = @"6c";
    }
    if (rules == mk_lt_filterRules_off) {
        //关闭过滤
        NSString *commandString = [NSString stringWithFormat:@"ed01%@0100",cmd];
        [self configDataWithTaskID:taskID
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    if (!MKValidArray(rawDataList) || rawDataList.count > 5) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *contentData = @"";
    for (id <mk_lt_BLEFilterRawDataProtocol>protocol in rawDataList) {
        if (![self isConfirmRawFilterProtocol:protocol]) {
            [self operationParamsErrorBlock:failedBlock];
            return;
        }
        NSString *minIndex = [NSString stringWithFormat:@"%1lx",(unsigned long)protocol.minIndex];
        if (minIndex.length == 1) {
            minIndex = [@"0" stringByAppendingString:minIndex];
        }
        NSString *maxIndex = [NSString stringWithFormat:@"%1lx",(unsigned long)protocol.maxIndex];
        if (maxIndex.length == 1) {
            maxIndex = [@"0" stringByAppendingString:maxIndex];
        }
        NSString *lenString = [NSString stringWithFormat:@"%1lx",(unsigned long)(protocol.rawData.length / 2 + 3)];
        if (lenString.length == 1) {
            lenString = [@"0" stringByAppendingString:lenString];
        }
        NSString *conditionString = [NSString stringWithFormat:@"%@%@%@%@%@",lenString,protocol.dataType,minIndex,maxIndex,protocol.rawData];
        contentData = [contentData stringByAppendingString:conditionString];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)((contentData.length / 2) + 1)];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *rulesString = @"00";
    if (rules == mk_lt_filterRules_forward) {
        rulesString = @"01";
    }else if (rules == mk_lt_filterRules_reverse) {
        rulesString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01",cmd,lenString,rulesString,contentData];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configBLEFilterStatusWithType:(mk_lt_filterRulesType)type
                                    isOn:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskConfigTrackingAFilterStatusOperation;
    NSString *cmd = @"51";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskConfigTrackingBFilterStatusOperation;
        cmd = @"52";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskConfigLocationAFilterStatusOperation;
        cmd = @"6d";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskConfigLocationBFilterStatusOperation;
        cmd = @"6e";
    }
    NSString *status = (isOn ? @"01" : @"00");
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ed01",cmd,@"01",status];
    [self configDataWithTaskID:taskID
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configTrackingLogicalRelationship:(mk_lt_BLELogicalRelationship)ship
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (ship == mk_lt_lLELogicalRelationshipOR ? @"ed01530101" : @"ed01530100");
    [self configDataWithTaskID:mk_lt_taskConfigTrackingLogicalRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configTrackingFilterRepeatingDataType:(mk_lt_filterRepeatingDataType)type
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01540100";
    if (type == mk_lt_filterRepeatingDataTypeMac) {
        commandString = @"ed01540101";
    }else if (type == mk_lt_filterRepeatingDataTypeMacAndDataType) {
        commandString = @"ed01540102";
    }else if (type == mk_lt_filterRepeatingDataTypeMacRawData) {
        commandString = @"ed01540103";
    }
    [self configDataWithTaskID:mk_lt_taskConfigTrackingFilterRepeatingDataTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configLocationLogicalRelationship:(mk_lt_BLELogicalRelationship)ship
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (ship == mk_lt_lLELogicalRelationshipOR ? @"ed016f0101" : @"ed016f0100");
    [self configDataWithTaskID:mk_lt_taskConfigLocationLogicalRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)lt_configLocationFilterRepeatingDataType:(mk_lt_filterRepeatingDataType)type
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01700100";
    if (type == mk_lt_filterRepeatingDataTypeMac) {
        commandString = @"ed01700101";
    }else if (type == mk_lt_filterRepeatingDataTypeMacAndDataType) {
        commandString = @"ed01700102";
    }else if (type == mk_lt_filterRepeatingDataTypeMacRawData) {
        commandString = @"ed01700103";
    }
    [self configDataWithTaskID:mk_lt_taskConfigLocationFilterRepeatingDataTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_lt_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.lt_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [self operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-999 message:@"Params error"];
            block(error);
        }
    });
}

+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block{
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-10001 message:@"Set parameter error"];
            block(error);
        }
    });
}

+ (NSString *)lorawanRegionString:(mk_lt_loraWanRegion)region {
    switch (region) {
        case mk_lt_loraWanRegionEU868:
            return @"00";
        case mk_lt_loraWanRegionUS915:
            return @"01";
        case mk_lt_loraWanRegionUS915HYBRID:
            return @"02";
        case mk_lt_loraWanRegionCN779:
            return @"03";
        case mk_lt_loraWanRegionEU433:
            return @"04";
        case mk_lt_loraWanRegionAU915:
            return @"05";
        case mk_lt_loraWanRegionAU915OLD:
            return @"06";
        case mk_lt_loraWanRegionCN470:
            return @"07";
        case mk_lt_loraWanRegionAS923:
            return @"08";
        case mk_lt_loraWanRegionKR920:
            return @"09";
        case mk_lt_loraWanRegionIN865:
            return @"0a";
        case mk_lt_loraWanRegionCN470PREQEL:
            return @"0b";
        case mk_lt_loraWanRegionSTE920:
            return @"0c";
        case mk_lt_loraWanRegionRU864:
            return @"0d";
    }
}

+ (NSString *)fetchTxPower:(mk_lt_txPower)txPower{
    switch (txPower) {
        case mk_lt_txPower4dBm:
            return @"04";
            
        case mk_lt_txPower3dBm:
            return @"03";
            
        case mk_lt_txPower0dBm:
            return @"00";
            
        case mk_lt_txPowerNeg4dBm:
            return @"fc";
            
        case mk_lt_txPowerNeg8dBm:
            return @"f8";
            
        case mk_lt_txPowerNeg12dBm:
            return @"f4";
            
        case mk_lt_txPowerNeg16dBm:
            return @"f0";
            
        case mk_lt_txPowerNeg20dBm:
            return @"ec";
            
        case mk_lt_txPowerNeg40dBm:
            return @"d8";
    }
}

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_lt_BLEFilterRawDataProtocol>)protocol {
    if (![protocol conformsToProtocol:@protocol(mk_lt_BLEFilterRawDataProtocol)]) {
        return NO;
    }
    if (!MKValidStr(protocol.dataType) || protocol.dataType.length != 2 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.dataType]) {
        return NO;
    }
    NSArray *typeList = [self dataTypeList];
    if (![typeList containsObject:[protocol.dataType uppercaseString]]) {
        return NO;
    }
    if (protocol.minIndex == 0 && protocol.maxIndex == 0) {
        if (!MKValidStr(protocol.rawData) || protocol.rawData.length > 124 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.rawData] || (protocol.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (protocol.minIndex < 0 || protocol.minIndex > 62 || protocol.maxIndex < 0 || protocol.maxIndex > 62) {
        return NO;
    }
    
    if (protocol.maxIndex < protocol.minIndex) {
        return NO;
    }
    if (!MKValidStr(protocol.rawData) || protocol.rawData.length > 124 || ![MKBLEBaseSDKAdopter checkHexCharacter:protocol.rawData]) {
        return NO;
    }
    NSInteger totalLen = (protocol.maxIndex - protocol.minIndex + 1) * 2;
    if (totalLen > 58 || protocol.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

+ (NSArray *)dataTypeList {
    return @[@"01",@"02",@"03",@"04",@"05",
             @"06",@"07",@"08",@"09",@"0A",
             @"0D",@"0E",@"0F",@"10",@"11",
             @"12",@"14",@"15",@"16",@"17",
             @"18",@"19",@"1A",@"1B",@"1C",
             @"1D",@"1E",@"1F",@"20",@"21",
             @"22",@"23",@"24",@"25",@"26",
             @"27",@"28",@"29",@"2A",@"2B",
             @"2C",@"2D",@"3D",@"FF"];
}

@end
