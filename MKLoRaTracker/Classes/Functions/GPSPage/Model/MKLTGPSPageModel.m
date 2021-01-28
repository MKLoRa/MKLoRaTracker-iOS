//
//  MKLTGPSPageModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTGPSPageModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTGPSPageModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTGPSPageModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readGPSStatus]) {
            [self operationFailedBlockWithMsg:@"Read GPS Function Switch Error" block:failedBlock];
            return;
        }
        if (![self readGPSReportInterval]) {
            [self operationFailedBlockWithMsg:@"Read GPS Payload Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readGPSSearchTime]) {
            [self operationFailedBlockWithMsg:@"Read Satellite Search Time Error" block:failedBlock];
            return;
        }
        if (![self readGPSOptionalPayloadContent]) {
            [self operationFailedBlockWithMsg:@"Read Optional Payload Content Error" block:failedBlock];
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
        if (![self configGPSStatus]) {
            [self operationFailedBlockWithMsg:@"Config GPS Function Switch Error" block:failedBlock];
            return;
        }
        if (![self configGPSReportInterval]) {
            [self operationFailedBlockWithMsg:@"Config GPS Payload Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configGPSSearchTime]) {
            [self operationFailedBlockWithMsg:@"Config Satellite Search Time Error" block:failedBlock];
            return;
        }
        if (![self configGPSOptionalPayloadContent]) {
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

#pragma mark - interface
- (BOOL)readGPSStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_readGPSSwitchStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGPSStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_configGPSSwitchStatus:self.isOn sucBlock:^{
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

- (BOOL)readGPSSearchTime {
    __block BOOL success = NO;
    [MKLTInterface lt_readGPSSatellitesSearchTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.searchTime = returnData[@"result"][@"time"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGPSSearchTime {
    __block BOOL success = NO;
    [MKLTInterface lt_configGPSSatellitesSearchTime:[self.searchTime integerValue] sucBlock:^{
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

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"gpsParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.searchTime) || [self.searchTime integerValue] < 1 || [self.searchTime integerValue] > 10) {
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
        _readQueue = dispatch_queue_create("gpsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
