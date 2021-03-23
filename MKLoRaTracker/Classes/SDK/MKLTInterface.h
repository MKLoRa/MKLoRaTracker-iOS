//
//  MKLTInterface.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lt_filterRulesType) {
    mk_lt_contactTrackingFilterConditionA,
    mk_lt_contactTrackingFilterConditionB,
    mk_lt_locationBeaconFilterConditionA,
    mk_lt_locationBeaconFilterConditionB,
};

@interface MKLTInterface : NSObject

#pragma mark ****************************************Device Service Information************************************************

/// Read the battery level of the device
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBatteryPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备系统应用信息读取************************************************

/// Read time synchronization interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the UUID of iBeacon.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBeaconProximityUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the major of iBeacon.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBeaconMajorWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the minor of iBeacon.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBeaconMinorWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the measured power(RSSI@1M) of device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readMeasuredPowerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the txPower of device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast interval of the device (unit: 100ms).
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBroadcastIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast name of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device scan parameters, including scan status and scan window duration.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDeviceScanParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the connectable status of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDeviceConnectableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备LoRa参数读取************************************************

/// Read LoRaWAN network access type.
/*
 1:ABP
 2:OTAA
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the region information of LoRaWAN.
/*
 0:EU868
 1:US915
 2:US915HYBRID
 3:CN779
 4:EU433
 5:AU915
 6:AU915OLD
 7:CN470
 8:AS923
 9:KR920
 10:IN865
 11:CN470PREQEL
 12:STE920
 13:RU864
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the DEVEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPEUI of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the DEVADDR of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the APPSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the NWKSKEY of LoRaWAN.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan CH.
/*
 @{
 @"CHL":0
 @"CHH":2
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan DR.
/*
 @{
 @"DR":1
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read ADR status of lorawan.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanADRWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan upstream data type.
/*
 0:Non-acknowledgement frame.
 1:Confirm the frame.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read lorawan upstream data type.
/*
 0:Non-acknowledgement frame.
 1:Confirm the frame.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanMessageTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the current network status of LoRaWAN.
/*
    0:Not connected to the network.
    1:Connecting
    2:OTAA network access or ABP mode.
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read network detection interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read alarm trigger RSSI value.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAlarmTriggerRSSIWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read Alarm Notification Type.
/// 0:Off
/// 1:Light
/// 2:Vibration
/// 3:Light + Vibration
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAlarmNotificationTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read motor vibration intensity.
/// Motor vibration intensity is divided into three gears: low(0,10%), medium(1,50%) and high(2,100%).
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readVibrationIntensityWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the vibration duration of the motor.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDurationOfVibrationWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the vibration period of the motor.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readVibrationCycleOfMotorWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Reading mac address
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the percentage of low battery alarm battery.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read scan data timing report interval.unit:minute
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readScanDatasReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Valid BLE Data Filter Interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readValidBLEDataFilterIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device information synchronization interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDeviceInfoReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// * People gathering warning will take effect.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readGatheringWarningRssiWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the alarm and report the content of the data packet regularly.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAlarmOptionalPayloadContentWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the number of reported ibeacon devices.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readReportNumberOfBeaconsWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read three-axis sampling rate.
/// 0:1hz
/// 1:10hz
/// 2:25hz
/// 3:50hz
/// 4:100hz
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorSampleRateWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read three-axis gravity acceleration reference value.
/// 0:±2g;
/// 1:±4g;
/// 2:±8g;
/// 3:±16g
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorGravitationalaccelerationWithSucBlock:(void (^)(id returnData))sucBlock
                                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Read three-axis trigger sensitivity.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorTriggerSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read three-axis status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read three-axis data reporting interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorDataReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Read whether the three-axis data monitoring status is open.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorDataStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read three-axis report data packet content optional.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readAxisSensorReportDataContentTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read SOS alarm switch status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readSOSSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the reporting interval of SOS alarm information.(unit:Min)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readSOSDataReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the contents of the SOS reported data packet optional.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readSOSReportDataContentTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read GPS hardware status (whether the device contains GPS function).
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readGPSHardwareStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read GPS switch status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readGPSSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read GPS search Satellites time.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readGPSSatellitesSearchTimeWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Read GPS data report interval.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readGPSDataReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the contents of the GPS reported data packet optional.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readGPSReportDataContentTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for AS923 and AU915.0: Dell Time no limit,1:Dell Time 400ms.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readUpLinkDellTimeWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for EU868,CN779, EU433,AS923,KR920,IN865,and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readDutyCycleWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read iBeacon data and report switch status.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBeaconReportSwitchStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************过滤规则读取************************************************

/// Read filtered RSSI.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceRSSIWithType:(mk_lt_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered device name.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceNameWithType:(mk_lt_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered device mac.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceMacWithType:(mk_lt_filterRulesType)type
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered MAJOR range.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceMajorWithType:(mk_lt_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the filtered MINOR range.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceMinorWithType:(mk_lt_filterRulesType)type
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filtered UUID.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceUUIDWithType:(mk_lt_filterRulesType)type
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filtered raw data.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterDeviceRawDataWithType:(mk_lt_filterRulesType)type
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read filter rule switch status.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readBLEFilterStatusWithType:(mk_lt_filterRulesType)type
                              sucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the logical relationship between the two sets of filtering rules, the two sets of rules can be OR and and.
/// (Contact Tracking Filter Condition    A / Contact Tracking Filter Condition    B)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readTrackingLogicalRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read duplicate data filter type.(Contact Tracking Filter Condition)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readTrackingFilterRepeatingDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the logical relationship between the two sets of filtering rules, the two sets of rules can be OR and and.
/// (Location Beacon Filter Condition    A / Location Beacon Filter Condition    B)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLocationLogicalRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Read duplicate data filter type.(Location Beacon Filter Condition)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_readLocationFilterRepeatingDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
