//
//  MKLTUplinkPayloadModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTUplinkPayloadModel : NSObject

#pragma mark - device info payload

@property (nonatomic, copy)NSString *deviceInfoInterval;

#pragma mark - Tracking And Location Payload

@property (nonatomic, assign)BOOL locationIsOn;

/// 1~4
@property (nonatomic, assign)NSInteger locationBeacons;

@property (nonatomic, copy)NSString *nonAlarmInterval;

@property (nonatomic, assign)BOOL tlHostMacIsOn;

@property (nonatomic, assign)BOOL tlDeviceRawDataIsOn;

@property (nonatomic, assign)BOOL tlBatteryLevelIsOn;

#pragma mark - SOS Payload

@property (nonatomic, copy)NSString *sosInterval;

@property (nonatomic, assign)BOOL sosTimestampIsOn;

@property (nonatomic, assign)BOOL sosMacIsOn;

#pragma mark - GPS Payload

/// 0~19
@property (nonatomic, assign)NSInteger gpsInterval;

@property (nonatomic, assign)BOOL gpsAltitudeIsOn;

@property (nonatomic, assign)BOOL gpsTimeStampIsOn;

@property (nonatomic, assign)BOOL gpsPDOPIsOn;

@property (nonatomic, assign)BOOL gpsSatellitesIsOn;

@property (nonatomic, assign)BOOL gpssearchModelIsOn;

#pragma mark - 3-Axis Payload

@property (nonatomic, copy)NSString *axisInterval;

@property (nonatomic, assign)BOOL axisTimeStampIsOn;

@property (nonatomic, assign)BOOL axisMacIsOn;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
