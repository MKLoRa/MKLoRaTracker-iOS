//
//  MKLTVibrationDataModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTVibrationDataModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTVibrationDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTVibrationDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readVibrationIntensity]) {
            [self operationFailedBlockWithMsg:@"Read Vibration Intensity Error" block:failedBlock];
            return;
        }
        if (![self readVibrationCycle]) {
            [self operationFailedBlockWithMsg:@"Read Vibration Cycle Error" block:failedBlock];
            return;
        }
        if (![self readDuration]) {
            [self operationFailedBlockWithMsg:@"Read Duration Of Vibration Error" block:failedBlock];
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
        if (![self configVibrationIntensity]) {
            [self operationFailedBlockWithMsg:@"Config Vibration Intensity Error" block:failedBlock];
            return;
        }
        if (![self configVibrationCycle]) {
            [self operationFailedBlockWithMsg:@"Config Vibration Cycle Error" block:failedBlock];
            return;
        }
        if (![self configDuration]) {
            [self operationFailedBlockWithMsg:@"Config Duration Of Vibration Error" block:failedBlock];
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
- (BOOL)readVibrationIntensity {
    __block BOOL success = NO;
    [MKLTInterface lt_readVibrationIntensityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        if ([returnData[@"result"][@"intensity"] integerValue] == 50) {
            self.intensity = 1;
        }else if ([returnData[@"result"][@"intensity"] integerValue] == 100) {
            self.intensity = 2;
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configVibrationIntensity {
    __block BOOL success = NO;
    [MKLTInterface lt_configVibrationIntensity:self.intensity sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readVibrationCycle {
    __block BOOL success = NO;
    [MKLTInterface lt_readVibrationCycleOfMotorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.cycle = returnData[@"result"][@"cycle"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configVibrationCycle {
    __block BOOL success = NO;
    [MKLTInterface lt_configVibrationCycleOfMotor:[self.cycle integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDuration {
    __block BOOL success = NO;
    [MKLTInterface lt_readDurationOfVibrationWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.duration = returnData[@"result"][@"duration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDuration {
    __block BOOL success = NO;
    [MKLTInterface lt_configDurationOfVibration:[self.duration integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"vibrationParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.cycle) || [self.cycle integerValue] < 1 || [self.cycle integerValue] > 600 || !ValidStr(self.duration) || [self.duration integerValue] < 0 || [self.duration integerValue] > 10) {
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
        _readQueue = dispatch_queue_create("vibrationQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
