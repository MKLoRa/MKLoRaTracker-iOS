//
//  MKLTInterface.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTInterface.h"

#import "MKLTCentralManager.h"
#import "MKLTOperationID.h"
#import "MKLTOperation.h"
#import "CBPeripheral+MKLTAdd.h"

#define centralManager [MKLTCentralManager shared]
#define peripheral ([MKLTCentralManager shared].peripheral)

@implementation MKLTInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)lt_readBatteryPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lt_taskReadBatteryPowerOperation
                           characteristic:peripheral.lt_batteryPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lt_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lt_taskReadDeviceModelOperation
                           characteristic:peripheral.lt_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lt_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lt_taskReadFirmwareOperation
                           characteristic:peripheral.lt_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lt_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lt_taskReadHardwareOperation
                           characteristic:peripheral.lt_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lt_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lt_taskReadSoftwareOperation
                           characteristic:peripheral.lt_sofeware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)lt_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_lt_taskReadManufacturerOperation
                           characteristic:peripheral.lt_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************设备系统应用信息读取************************************************

+ (void)lt_readTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadTimeSyncIntervalOperation
                     cmdFlag:@"1e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBeaconProximityUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadBeaconUUIDOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBeaconMajorWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadBeaconMajorOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBeaconMinorWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadBeaconMinorOperation
                     cmdFlag:@"22"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readMeasuredPowerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadMeasuredPowerOperation
                     cmdFlag:@"23"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadTxPowerOperation
                     cmdFlag:@"24"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBroadcastIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadBroadcastIntervalOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadDeviceNameOperation
                     cmdFlag:@"26"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readDeviceScanParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadScanParamsOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readDeviceConnectableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadConnectableStatusOperation
                     cmdFlag:@"2a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************设备LoRa参数读取************************************************

+ (void)lt_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanModemOperation
                     cmdFlag:@"2b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanRegionOperation
                     cmdFlag:@"2c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"2d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"2e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"2f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanDEVADDROperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanCHOperation
                     cmdFlag:@"33"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanDROperation
                     cmdFlag:@"34"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanADRWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanADROperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanMessageTypeOperation
                     cmdFlag:@"36"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"37"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadNetworkCheckIntervalOperation
                     cmdFlag:@"38"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAlarmTriggerRSSIWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAlarmTriggerRSSIOperation
                     cmdFlag:@"39"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAlarmNotificationTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAlarmNotificationTypeOperation
                     cmdFlag:@"3a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readVibrationIntensityWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadVibrationIntensityOperation
                     cmdFlag:@"3b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readDurationOfVibrationWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadDurationOfVibrationOperation
                     cmdFlag:@"3c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readVibrationCycleOfMotorWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadVibrationCycleOfMotorOperation
                     cmdFlag:@"3d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadMacAddressOperation
                     cmdFlag:@"3f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLowPowerPromptOperation
                     cmdFlag:@"41"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readScanDatasReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadScanDatasReportIntervalOperation
                     cmdFlag:@"42"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readValidBLEDataFilterIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadValidBLEDataFilterIntervalOperation
                     cmdFlag:@"55"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readDeviceInfoReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadDeviceInfoReportIntervalOperation
                     cmdFlag:@"56"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readGatheringWarningRssiWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadGatheringWarningRssiOperation
                     cmdFlag:@"58"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAlarmOptionalPayloadContentWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAlarmOptionalPayloadContentOperation
                     cmdFlag:@"71"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readReportNumberOfBeaconsWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadReportNumberOfBeaconsOperation
                     cmdFlag:@"72"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorSampleRateWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorSampleRateOperation
                     cmdFlag:@"73"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorGravitationalaccelerationWithSucBlock:(void (^)(id returnData))sucBlock
                                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorGravitationalaccelerationOperation
                     cmdFlag:@"74"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorTriggerSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorTriggerSensitivityOperation
                     cmdFlag:@"75"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorSwitchStatusOperation
                     cmdFlag:@"76"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorDataReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorDataReportIntervalOperation
                     cmdFlag:@"77"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorDataStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorDataStatusOperation
                     cmdFlag:@"78"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readAxisSensorReportDataContentTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadAxisSensorReportDataContentTypeOperation
                     cmdFlag:@"7a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readSOSSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadSOSSwitchStatusOperation
                     cmdFlag:@"7b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readSOSDataReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadSOSDataReportIntervalOperation
                     cmdFlag:@"7c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readSOSReportDataContentTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadSOSReportDataContentTypeOperation
                     cmdFlag:@"7d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readGPSHardwareStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadGPSHardwareStatusOperation
                     cmdFlag:@"7e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readGPSSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadGPSSwitchStatusOperation
                     cmdFlag:@"7f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readGPSSatellitesSearchTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadGPSSatellitesSearchTimeOperation
                     cmdFlag:@"80"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readGPSDataReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadGPSDataReportIntervalOperation
                     cmdFlag:@"81"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readGPSReportDataContentTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadGPSReportDataContentTypeOperation
                     cmdFlag:@"82"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readUpLinkDellTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadUpLinkeDellTimeOperation
                     cmdFlag:@"83"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readDutyCycleWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadDutyCycleStatusOperation
                     cmdFlag:@"84"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBeaconReportSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadBeaconReportSwitchStatusOperation
                     cmdFlag:@"85"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************过滤规则读取************************************************

+ (void)lt_readBLEFilterDeviceRSSIWithType:(mk_lt_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterRssiOperation;
    NSString *cmd = @"43";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterRssiOperation;
        cmd = @"4a";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterRssiOperation;
        cmd = @"5f";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterRssiOperation;
        cmd = @"66";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterDeviceNameWithType:(mk_lt_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterDeviceNameOperation;
    NSString *cmd = @"44";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterDeviceNameOperation;
        cmd = @"4b";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterDeviceNameOperation;
        cmd = @"60";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterDeviceNameOperation;
        cmd = @"67";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterDeviceMacWithType:(mk_lt_filterRulesType)type
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterMacOperation;
    NSString *cmd = @"45";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterMacOperation;
        cmd = @"4c";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterMacOperation;
        cmd = @"61";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterMacOperation;
        cmd = @"68";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterDeviceMajorWithType:(mk_lt_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterMajorOperation;
    NSString *cmd = @"46";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterMajorOperation;
        cmd = @"4d";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterMajorOperation;
        cmd = @"62";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterMajorOperation;
        cmd = @"69";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterDeviceMinorWithType:(mk_lt_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterMinorOperation;
    NSString *cmd = @"47";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterMinorOperation;
        cmd = @"4e";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterMinorOperation;
        cmd = @"63";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterMinorOperation;
        cmd = @"6a";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterDeviceUUIDWithType:(mk_lt_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterUUIDOperation;
    NSString *cmd = @"48";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterUUIDOperation;
        cmd = @"4f";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterUUIDOperation;
        cmd = @"64";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterUUIDOperation;
        cmd = @"6b";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterDeviceRawDataWithType:(mk_lt_filterRulesType)type
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterRawDataOperation;
    NSString *cmd = @"49";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterRawDataOperation;
        cmd = @"50";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterRawDataOperation;
        cmd = @"65";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterRawDataOperation;
        cmd = @"6c";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readBLEFilterStatusWithType:(mk_lt_filterRulesType)type
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    mk_lt_taskOperationID taskID = mk_lt_taskReadTrackingAFilterStatusOperation;
    NSString *cmd = @"51";
    if (type == mk_lt_contactTrackingFilterConditionB) {
        taskID = mk_lt_taskReadTrackingBFilterStatusOperation;
        cmd = @"52";
    }else if (type == mk_lt_locationBeaconFilterConditionA) {
        taskID = mk_lt_taskReadLocationAFilterStatusOperation;
        cmd = @"6d";
    }else if (type == mk_lt_locationBeaconFilterConditionB) {
        taskID = mk_lt_taskReadLocationBFilterStatusOperation;
        cmd = @"6e";
    }
    [self readDataWithTaskID:taskID
                     cmdFlag:cmd
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readTrackingLogicalRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadTrackingLogicalRelationshipOperation
                     cmdFlag:@"53"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readTrackingFilterRepeatingDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadTrackingFilterRepeatingDataTypeOperation
                     cmdFlag:@"54"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLocationLogicalRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLocationLogicalRelationshipOperation
                     cmdFlag:@"6f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)lt_readLocationFilterRepeatingDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_lt_taskReadLocationFilterRepeatingDataTypeOperation
                     cmdFlag:@"70"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark - private method

+ (void)readDataWithTaskID:(mk_lt_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.lt_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
