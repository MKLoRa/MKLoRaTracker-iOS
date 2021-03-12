//
//  MKLTAxisPageModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTAxisPageModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTAxisPageModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTAxisPageModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readAxisSwitchStatus]) {
            [self operationFailedBlockWithMsg:@"Read 3-Axis Switch Error" block:failedBlock];
            return;
        }
        if (![self readAxisSampleRate]) {
            [self operationFailedBlockWithMsg:@"Read Sample Rate Error" block:failedBlock];
            return;
        }
        if (![self readAxisAcceleration]) {
            [self operationFailedBlockWithMsg:@"Read Gravitational acceleration Error" block:failedBlock];
            return;
        }
        if (![self readAxisSensitivity]) {
            [self operationFailedBlockWithMsg:@"Read Trigger Sensitivity Error" block:failedBlock];
            return;
        }
        if (![self readAxisReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read 3-Axis Payload Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readAxisOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Read Optional Payload Content Error" block:failedBlock];
            return;
        }
        if (![self readAxisSeneorDataStatus]) {
            [self operationFailedBlockWithMsg:@"Read Sensor Data Error" block:failedBlock];
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
        if (![self configAxisSampleRate]) {
            [self operationFailedBlockWithMsg:@"Config Sample Rate Error" block:failedBlock];
            return;
        }
        if (![self configAxisAcceleration]) {
            [self operationFailedBlockWithMsg:@"Config Gravitational acceleration Error" block:failedBlock];
            return;
        }
        if (![self configAxisSensitivity]) {
            [self operationFailedBlockWithMsg:@"Config Trigger Sensitivity Error" block:failedBlock];
            return;
        }
        if (![self configAxisReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config 3-Axis Payload Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configAxisOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Config Optional Payload Content Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configAxisSwitchStatus:(BOOL)isOn
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configAxisSwitchStatus:isOn]) {
            [self operationFailedBlockWithMsg:@"Config 3-Axis Switch Error" block:failedBlock];
            return;
        }
        if (![self readAxisSeneorDataStatus]) {
            [self operationFailedBlockWithMsg:@"Read Sensor Data Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configSensorDataStatus:(BOOL)isOn
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configAxisSeneorDataStatus:isOn]) {
            [self operationFailedBlockWithMsg:@"Config Sensor Data Switch Status Error" block:failedBlock];
            return;
        }
        if (![self readAxisSwitchStatus]) {
            [self operationFailedBlockWithMsg:@"Read 3-Axis Switch Error" block:failedBlock];
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
- (BOOL)readAxisSwitchStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorSwitchStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.axisIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisSwitchStatus:(BOOL)isOn {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorSwitchStatus:isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAxisSampleRate {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorSampleRateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.sampleRate = [returnData[@"result"][@"sampleRate"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisSampleRate {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorSampleRate:self.sampleRate sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAxisAcceleration {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorGravitationalaccelerationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.acceleration = [returnData[@"result"][@"value"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisAcceleration {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorGravitationalacceleration:self.acceleration sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAxisSensitivity {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorTriggerSensitivityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.sensitivity = returnData[@"result"][@"value"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisSensitivity {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorTriggerSensitivity:[self.sensitivity integerValue] sucBlock:^{
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
        self.reportInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisReportInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorDataReportInterval:[self.reportInterval integerValue] sucBlock:^{
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
        self.macIsOn = [returnData[@"result"][@"macIsOn"] boolValue];
        self.timestampIsOn = [returnData[@"result"][@"timestampIsOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisOptionalPayloadContent {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorReportDataContentTypeWithTimestampIsOn:self.timestampIsOn macIsOn:self.macIsOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAxisSeneorDataStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_readAxisSensorDataStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.sensorDataIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAxisSeneorDataStatus:(BOOL)isOn {
    __block BOOL success = NO;
    [MKLTInterface lt_configAxisSensorDataStatus:isOn sucBlock:^{
        success = YES;
        self.sensorDataIsOn = isOn;
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
        NSError *error = [[NSError alloc] initWithDomain:@"axisParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.sensitivity) || [self.sensitivity integerValue] < 7 || [self.sensitivity integerValue] > 255) {
        return NO;
    }
    if (!ValidStr(self.reportInterval) || [self.reportInterval integerValue] < 1 || [self.reportInterval integerValue] > 60) {
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
        _readQueue = dispatch_queue_create("axisQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
