//
//  MKLTUplinkPayloadModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTUplinkPayloadModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTUplinkPayloadModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTUplinkPayloadModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceInfoInterval]) {
            [self operationFailedBlockWithMsg:@"Read Device Info Payload Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readBeaconReportSwitchStatus]) {
            [self operationFailedBlockWithMsg:@"Read Tracking And Location Payload Report Location Information Error" block:failedBlock];
            return;
        }
        if (![self readReportNumberOfBeacons]) {
            [self operationFailedBlockWithMsg:@"Read Tracking And Location Payload Reported Location Beacons Error" block:failedBlock];
            return;
        }
        if (![self readNonAlarmReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read Tracking And Location Payload Non-Alarm Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readAlarmOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Read Tracking And Location Payload Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self readSOSDataReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read SOS Data Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readSOSOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Read SOS Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self readGPSReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read GPS Data Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readGPSOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Read GPS Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self readAxisReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read Axis Data Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readAxisOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Read Axis Optional Payload Content Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configDeviceInfoInterval]) {
            [self operationFailedBlockWithMsg:@"Config Device Info Payload Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configBeaconReportSwitchStatus]) {
            [self operationFailedBlockWithMsg:@"Config Tracking And Location Payload Report Location Information Error" block:failedBlock];
            return;
        }
        if (![self configReportNumberOfBeacons]) {
            [self operationFailedBlockWithMsg:@"Config Tracking And Location Payload Reported Location Beacons Error" block:failedBlock];
            return;
        }
        if (![self configNonAlarmReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config Tracking And Location Payload Non-Alarm Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configAlarmOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Config Tracking And Location Payload Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self configSOSDataReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config SOS Data Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configSOSOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Config SOS Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self configGPSReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config GPS Data Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configGPSOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Config GPS Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self configAxisReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config Axis Data Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configAxisOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Config Axis Optional Payload Content Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readDeviceInfoInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readDeviceInfoReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.deviceInfoInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceInfoInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configDeviceInfoReportInterval:[self.deviceInfoInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBeaconReportSwitchStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_readBeaconReportSwitchStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.locationIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeaconReportSwitchStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_configBeaconReportSwitchStatus:self.locationIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportNumberOfBeacons {
    __block BOOL success = NO;
    [MKLTInterface lt_readReportNumberOfBeaconsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.locationBeacons = [returnData[@"result"][@"number"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportNumberOfBeacons {
    __block BOOL success = NO;
    [MKLTInterface lt_configReportNumberOfBeacons:self.locationBeacons sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNonAlarmReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readScanDatasReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.nonAlarmInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNonAlarmReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configScanDatasReportInterval:[self.nonAlarmInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAlarmOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_readAlarmOptionalPayloadContentWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.tlBatteryLevelIsOn = [returnData[@"result"][@"batteryIsOn"] boolValue];
        self.tlHostMacIsOn = [returnData[@"result"][@"macIsOn"] boolValue];
        self.tlDeviceRawDataIsOn = [returnData[@"result"][@"rawIsOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAlarmOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_configAlarmOptionalPayloadContentWithBatteryIsOn:self.tlBatteryLevelIsOn macIsOn:self.tlHostMacIsOn rawIsOn:self.tlDeviceRawDataIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSOSDataReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readSOSDataReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.sosInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSOSDataReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configSOSDataReportInterval:[self.sosInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSOSOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_readSOSReportDataContentTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.sosTimestampIsOn = [returnData[@"result"][@"timestampIsOn"] boolValue];
        self.sosMacIsOn = [returnData[@"result"][@"macIsOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSOSOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_configSOSReportDataContentTypeWithTimestampIsOn:self.sosTimestampIsOn macIsOn:self.sosMacIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readGPSReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readGPSDataReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.gpsInterval = [returnData[@"result"][@"interval"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGPSReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configGPSDataReportInterval:(self.gpsInterval + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readGPSOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_readGPSReportDataContentTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.gpsAltitudeIsOn = [returnData[@"result"][@"altitudeIsOn"] boolValue];
        self.gpsTimeStampIsOn = [returnData[@"result"][@"timestampIsOn"] boolValue];
        self.gpsPDOPIsOn = [returnData[@"result"][@"pdopIsOn"] boolValue];
        self.gpsSatellitesIsOn = [returnData[@"result"][@"numberOfSatellitesIsOn"] boolValue];
        self.gpssearchModelIsOn = [returnData[@"result"][@"searchModeIsOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGPSOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_configGPSReportDataContentTypeWithAltitudeIsOn:self.gpsAltitudeIsOn timestampIsOn:self.gpsTimeStampIsOn searchModeIsOn:self.gpssearchModelIsOn pdopIsOn:self.gpsPDOPIsOn numberOfSatellitesIsOn:self.gpsSatellitesIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAxisReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorDataReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.axisInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorDataReportInterval:[self.axisInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAxisOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorReportDataContentTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.axisTimeStampIsOn = [returnData[@"result"][@"timestampIsOn"] boolValue];
        self.axisMacIsOn = [returnData[@"result"][@"macIsOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorReportDataContentTypeWithTimestampIsOn:self.axisTimeStampIsOn macIsOn:self.axisMacIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"uplinkParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.deviceInfoInterval) || [self.deviceInfoInterval integerValue] < 2 || [self.deviceInfoInterval integerValue] > 120) {
        return NO;
    }
    if (self.locationBeacons < 1 || self.locationBeacons > 4) {
        return NO;
    }
    if (!ValidStr(self.nonAlarmInterval) || [self.nonAlarmInterval integerValue] < 1 || [self.nonAlarmInterval integerValue] > 60) {
        return NO;
    }
    if (!ValidStr(self.sosInterval) || [self.sosInterval integerValue] < 1 || [self.sosInterval integerValue] > 10) {
        return NO;
    }
    if (!ValidStr(self.axisInterval) || [self.axisInterval integerValue] < 1 || [self.axisInterval integerValue] > 60) {
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("uplinkQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
