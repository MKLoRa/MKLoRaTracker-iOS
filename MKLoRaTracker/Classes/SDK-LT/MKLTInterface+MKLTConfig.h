//
//  MKLTInterface+MKLTConfig.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTInterface.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lt_txPower) {
    mk_lt_txPower4dBm,       //RadioTxPower:4dBm
    mk_lt_txPower3dBm,       //3dBm
    mk_lt_txPower0dBm,       //0dBm
    mk_lt_txPowerNeg4dBm,    //-4dBm
    mk_lt_txPowerNeg8dBm,    //-8dBm
    mk_lt_txPowerNeg12dBm,   //-12dBm
    mk_lt_txPowerNeg16dBm,   //-16dBm
    mk_lt_txPowerNeg20dBm,   //-20dBm
    mk_lt_txPowerNeg40dBm,   //-40dBm
};

typedef NS_ENUM(NSInteger, mk_lt_loraWanRegion) {
    mk_lt_loraWanRegionEU868,
    mk_lt_loraWanRegionUS915,
    mk_lt_loraWanRegionUS915HYBRID,
    mk_lt_loraWanRegionCN779,
    mk_lt_loraWanRegionEU433,
    mk_lt_loraWanRegionAU915,
    mk_lt_loraWanRegionAU915OLD,
    mk_lt_loraWanRegionCN470,
    mk_lt_loraWanRegionAS923,
    mk_lt_loraWanRegionKR920,
    mk_lt_loraWanRegionIN865,
    mk_lt_loraWanRegionCN470PREQEL,
    mk_lt_loraWanRegionSTE920,
    mk_lt_loraWanRegionRU864,
};

typedef NS_ENUM(NSInteger, mk_lt_loraWanModem) {
    mk_lt_loraWanModemABP,
    mk_lt_loraWanModemOTAA,
};

typedef NS_ENUM(NSInteger, mk_lt_loraWanMessageType) {
    mk_lt_loraWanUnconfirmMessage,          //Non-acknowledgement frame.
    mk_lt_loraWanConfirmMessage,            //Confirm the frame.
};

typedef NS_ENUM(NSInteger, mk_lt_scanWindowType) {
    mk_lt_scanWindowTypeOff,            //close.
    mk_lt_scanWindowTypeLow,            //Low.
    mk_lt_scanWindowTypeMedium,         //Medium.
    mk_lt_scanWindowTypeStrong,         //Strong.
};

typedef NS_ENUM(NSInteger, mk_lt_threeAxisDataSamplingRate) {
    mk_lt_threeAxisDataSamplingRate0,       //1hz
    mk_lt_threeAxisDataSamplingRate1,       //10hz
    mk_lt_threeAxisDataSamplingRate2,       //25hz
    mk_lt_threeAxisDataSamplingRate3,       //50hz
    mk_lt_threeAxisDataSamplingRate4,       //100hz
};

typedef NS_ENUM(NSInteger, mk_lt_threeAxisGravitationalAcceleration) {
    mk_lt_threeAxisGravitationalAcceleration0,      //±2g
    mk_lt_threeAxisGravitationalAcceleration1,      //±4g
    mk_lt_threeAxisGravitationalAcceleration2,      //±8g
    mk_lt_threeAxisGravitationalAcceleration3,      //±16g
};

typedef NS_ENUM(NSInteger, mk_lt_alarmNotificationType) {
    mk_lt_alarmNotificationOff,
    mk_lt_alarmNotificationLight,
    mk_lt_alarmNotificationVibration,
    mk_lt_alarmNotificationLightAndVibration,
};

typedef NS_ENUM(NSInteger, mk_lt_filterRepeatingDataType) {
    mk_lt_filterRepeatingDataTypeNo,
    mk_lt_filterRepeatingDataTypeMac,
    mk_lt_filterRepeatingDataTypeMacAndDataType,
    mk_lt_filterRepeatingDataTypeMacRawData,
};

typedef NS_ENUM(NSInteger, mk_lt_BLELogicalRelationship) {
    mk_lt_lLELogicalRelationshipOR,
    mk_lt_lLELogicalRelationshipAND
};

typedef NS_ENUM(NSInteger, mk_lt_filterRules) {
    mk_lt_filterRules_off,
    mk_lt_filterRules_forward,          //Filter data forward
    mk_lt_filterRules_reverse,          //Filter data in reverse
};

@protocol mk_lt_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes,maxIndex - minIndex <= 29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end

@interface MKLTInterface (MKLTConfig)

#pragma mark ****************************************设备系统应用信息设置************************************************

/// Configure time synchronization interval.
/// @param interval 0h~254h
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the UUID of iBeacon.
/// @param uuid uuid
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBeaconProximityUUID:(NSString *)uuid
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the major of iBeacon.
/// @param major 0~65535.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configMajor:(NSInteger)major
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the minor of iBeacon.
/// @param minor 0~65535.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configMinor:(NSInteger)minor
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the measured power(RSSI@1M) of device.
/// @param measuredPower -127dBm~0dBm
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configMeasuredPower:(NSInteger)measuredPower
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the txPower of device.
/// @param txPower txPower
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configTxPower:(mk_lt_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast interval of the device (unit: 100ms).
/// @param interval 1 ~ 100.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBroadcastInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast name of the device.
/// @param deviceName 1~10 ascii characters
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connection password of device.
/// @param password 8-character ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

/// Sync device time.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the scan window params of device.
/// @param scanWindow scanWindow
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configScanWindow:(mk_lt_scanWindowType)scanWindow
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connectable status of the device.
/// @param connectable connectable
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configConnectableStatus:(BOOL)connectable
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************设备lorawan信息设置************************************************

/// Configure LoRaWAN network access type.
/// @param modem modem
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configModem:(mk_lt_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the region information of LoRaWAN.
/// @param region region
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configRegion:(mk_lt_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVEUI of LoRaWAN.
/// @param devEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPEUI of LoRaWAN.
/// @param appEUI Hexadecimal characters, length must be 16.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPKEY of LoRaWAN.
/// @param appKey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DEVADDR of LoRaWAN.
/// @param devAddr Hexadecimal characters, length must be 8.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the APPSKEY of LoRaWAN.
/// @param appSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the NWKSKEY of LoRaWAN.
/// @param nwkSkey Hexadecimal characters, length must be 32.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the CH of LoRaWAN.
/// @param chlValue Minimum value of CH.0 ~ 95
/// @param chhValue Maximum value of CH. chlValue ~ 95
/// @param sucBlock Success callback
/// @param failedBlock  Failure callback
+ (void)lt_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the DR of LoRaWAN.
/// @param drValue 0~15
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the ADR status of LoRaWAN.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configADRStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the message type of LoRaWAN.
/// @param messageType messageType
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configMessageType:(mk_lt_loraWanMessageType)messageType
                    sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure network detection interval.
/// @param interval 0~254
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configNetworkCheckInterval:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure alarm trigger RSSI value.
/// @param rssi -127dBm~0dBm
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAlarmTriggerRSSI:(NSInteger)rssi
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure Alarm Notification Type.
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAlarmNotificationType:(mk_lt_alarmNotificationType)type
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure motor vibration intensity.
/// @param intensity 0:10%,1:50%,2:100%
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configVibrationIntensity:(NSInteger)intensity
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the vibration duration of the motor.
/// @param duration 0s~255s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDurationOfVibration:(NSInteger)duration
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the vibration period of the motor.
/// @param cycle 1s~600s
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configVibrationCycleOfMotor:(NSInteger)cycle
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the percentage of low battery alarm battery.
/// @param percentage 1(10%)~6(60%)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configLowPowerPrompt:(NSInteger)percentage
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure scan data timing report interval.
/// @param interval 1min~60min
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configScanDatasReportInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark -

/// Valid BLE Data Filter Interval.
/// @param interval 1s~600s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configValidBLEDataFilterInterval:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure device information synchronization interval.
/// @param interval 2h~120h
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDeviceInfoReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// * People gathering warning will take effect.
/// @param rssi -127dBm~0dBm
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configGatheringWarningRssi:(NSInteger)rssi
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Device network access/restart instruction.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_connectNetworkWithSucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Device shutdown.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_FactoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the alarm and report the content of the data packet regularly.
/// @param batteryIsOn Whether battery is reported.
/// @param macIsOn Whether mac address is reported.
/// @param rawIsOn Whether raw data is reported.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAlarmOptionalPayloadContentWithBatteryIsOn:(BOOL)batteryIsOn
                                                    macIsOn:(BOOL)macIsOn
                                                    rawIsOn:(BOOL)rawIsOn
                                                   sucBlock:(void (^)(void))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the number of reported ibeacon devices.
/// @param number 1~4
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configReportNumberOfBeacons:(NSInteger)number
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis sampling rate.
/// @param rate rate
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorSampleRate:(mk_lt_threeAxisDataSamplingRate)rate
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis gravity acceleration reference value.
/// @param gravitational gravitational
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorGravitationalacceleration:(mk_lt_threeAxisGravitationalAcceleration)gravitational
                                            sucBlock:(void (^)(void))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis trigger sensitivity.
/// @param sensitivity 7~255
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorTriggerSensitivity:(NSInteger)sensitivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorSwitchStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis data reporting interval.
/// @param interval 1Min~60Min
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorDataReportInterval:(NSInteger)interval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure whether the three-axis data monitoring status is open.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorDataStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure three-axis report data packet content optional.
/// @param timestampIsOn Whether timestamp is reported.
/// @param macIsOn Whether mac address is reported.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configAxisSensorReportDataContentTypeWithTimestampIsOn:(BOOL)timestampIsOn
                                                          macIsOn:(BOOL)macIsOn
                                                         sucBlock:(void (^)(void))sucBlock
                                                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure SOS alarm switch status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configSOSSwitchStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the reporting interval of SOS alarm information.
/// @param interval 1Min~10Min.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configSOSDataReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the contents of the SOS reported data packet optional.
/// @param timestampIsOn Whether timestamp is reported.
/// @param macIsOn Whether mac address is reported.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configSOSReportDataContentTypeWithTimestampIsOn:(BOOL)timestampIsOn
                                                   macIsOn:(BOOL)macIsOn
                                                  sucBlock:(void (^)(void))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure GPS switch status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configGPSSwitchStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure GPS search Satellites time.
///
/// @param time 1Min~10Min
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configGPSSatellitesSearchTime:(NSInteger)time
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure GPS data report interval.
/// 10-200 times, the minimum is 10 times. Minimum gradient 10 (multiple of the regular reporting interval)
/// @param interval 1~20
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configGPSDataReportInterval:(NSInteger)interval
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the contents of the GPS reported data packet optional.
/// @param altitudeIsOn Whether altitude is reported.
/// @param timestampIsOn Whether timestamp is reported.
/// @param searchModeIsOn Whether search mode is reported.
/// @param pdopIsOn Whether pdop is reported.
/// @param numberOfSatellitesIsOn Whether number of satellites  is reported.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configGPSReportDataContentTypeWithAltitudeIsOn:(BOOL)altitudeIsOn
                                            timestampIsOn:(BOOL)timestampIsOn
                                           searchModeIsOn:(BOOL)searchModeIsOn
                                                 pdopIsOn:(BOOL)pdopIsOn
                                   numberOfSatellitesIsOn:(BOOL)numberOfSatellitesIsOn
                                                 sucBlock:(void (^)(void))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for AS923 and AU915.0: Dell Time no limit,1:Dell Time 400ms.
/// @param time 0/1
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configUpLinkeDellTime:(NSInteger)time
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// It is only used for EU868,CN779, EU433,AS923,KR920,IN865,and RU864. Off: The uplink report interval will not be limit by region freqency. On:The uplink report interval will be limit by region freqency.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure iBeacon data and report switch status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBeaconReportSwitchStatus:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ****************************************过滤规则配置************************************************

/// Configure filtered RSSI.
/// @param type type
/// @param rssi -127dBm~0dBm
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceRSSIWithType:(mk_lt_filterRulesType)type
                                        rssi:(NSInteger)rssi
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the filtered device name.
/// @param type type
/// @param rules rules
/// @param deviceName 1~10 ascii characters.If rules == mk_lt_filterRules_off, it can be empty.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceNameWithType:(mk_lt_filterRulesType)type
                                       rules:(mk_lt_filterRules)rules
                                  deviceName:(NSString *)deviceName
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the filtered device mac.
/// @param type type
/// @param rules rules
/// @param mac 1Byte ~ 6Byte.If rules == mk_lt_filterRules_off, it can be empty.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceMacWithType:(mk_lt_filterRulesType)type
                                      rules:(mk_lt_filterRules)rules
                                        mac:(NSString *)mac
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the filtered MAJOR range.
/// @param type type
/// @param rules rules
/// @param majorMin 0~65535
/// @param majorMax majorMin ~ 65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceMajorWithType:(mk_lt_filterRulesType)type
                                        rules:(mk_lt_filterRules)rules
                                     majorMin:(NSInteger)majorMin
                                     majorMax:(NSInteger)majorMax
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the filtered MINOR range.
/// @param type type
/// @param rules rules
/// @param minorMin 0~65535
/// @param minorMax minorMin ~ 65535
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceMinorWithType:(mk_lt_filterRulesType)type
                                        rules:(mk_lt_filterRules)rules
                                     minorMin:(NSInteger)minorMin
                                     minorMax:(NSInteger)minorMax
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure filtered UUID.
/// @param type type
/// @param rules rules
/// @param uuid 1Byte ~ 16Byte.If rules == mk_lt_filterRules_off, it can be empty.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceUUIDWithType:(mk_lt_filterRulesType)type
                                       rules:(mk_lt_filterRules)rules
                                        uuid:(NSString *)uuid
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure filtered raw data.
/// @param type type
/// @param rules rules
/// @param rawDataList Filter rules, up to five groups of filters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterDeviceRawDataWithType:(mk_lt_filterRulesType)type
                                          rules:(mk_lt_filterRules)rules
                                    rawDataList:(NSArray <mk_lt_BLEFilterRawDataProtocol> *)rawDataList
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure filter rule switch status.
/// @param type type
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configBLEFilterStatusWithType:(mk_lt_filterRulesType)type
                                    isOn:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the logical relationship between the two sets of filtering rules, the two sets of rules can be OR and and.
/// (Contact Tracking Filter Condition    A / Contact Tracking Filter Condition    B)
/// @param ship ship
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configTrackingLogicalRelationship:(mk_lt_BLELogicalRelationship)ship
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure duplicate data filter type.(Contact Tracking Filter Condition)
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configTrackingFilterRepeatingDataType:(mk_lt_filterRepeatingDataType)type
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the logical relationship between the two sets of filtering rules, the two sets of rules can be OR and and.
/// (Location Beacon Filter Condition    A / Location Beacon Filter Condition    B)
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configLocationLogicalRelationship:(mk_lt_BLELogicalRelationship)ship
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read duplicate data filter type.(Location Beacon Filter Condition)
/// @param type type
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)lt_configLocationFilterRepeatingDataType:(mk_lt_filterRepeatingDataType)type
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;


@end

NS_ASSUME_NONNULL_END
