//
//  MKLTScannerDataModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTScannerDataModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTScannerDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTScannerDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFilterInterval]) {
            [self operationFailedBlockWithMsg:@"Read Valid BLE Data Filter Interval Error" block:failedBlock];
            return;
        }
        if (![self readAlarmNoti]) {
            [self operationFailedBlockWithMsg:@"Read Alarm Notification Error" block:failedBlock];
            return;
        }
        if (![self readAlarmTriggerRssi]) {
            [self operationFailedBlockWithMsg:@"Read Alarm Trigger RSSI Error" block:failedBlock];
            return;
        }
        if (![self readGatheringWarningRssi]) {
            [self operationFailedBlockWithMsg:@"Read Gathering Warning Error" block:failedBlock];
            return;
        }
        if (![self readScanParams]) {
            [self operationFailedBlockWithMsg:@"Read Scan Window Error" block:failedBlock];
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
        if (![self configFilterInterval]) {
            [self operationFailedBlockWithMsg:@"Config Valid BLE Data Filter Interval Error" block:failedBlock];
            return;
        }
        if (![self configAlarmNoti]) {
            [self operationFailedBlockWithMsg:@"Config Alarm Notification Error" block:failedBlock];
            return;
        }
        if (![self configAlarmTriggerRssi]) {
            [self operationFailedBlockWithMsg:@"Config Alarm Trigger RSSI Error" block:failedBlock];
            return;
        }
        if (![self configGatheringWarningRssi]) {
            [self operationFailedBlockWithMsg:@"Config Gathering Warning Error" block:failedBlock];
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
- (BOOL)readFilterInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readValidBLEDataFilterIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.filterInterval = [returnData[@"result"][@"interval"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configValidBLEDataFilterInterval:self.filterInterval sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAlarmNoti {
    __block BOOL success = NO;
    [MKLTInterface lt_readAlarmNotificationTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.alarmNotification = [returnData[@"result"][@"type"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAlarmNoti {
    __block BOOL success = NO;
    [MKLTInterface lt_configAlarmNotificationType:self.alarmNotification sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAlarmTriggerRssi {
    __block BOOL success = NO;
    [MKLTInterface lt_readAlarmTriggerRSSIWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerRssi = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAlarmTriggerRssi {
    __block BOOL success = NO;
    [MKLTInterface lt_configAlarmTriggerRSSI:self.triggerRssi sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readGatheringWarningRssi {
    __block BOOL success = NO;
    [MKLTInterface lt_readGatheringWarningRssiWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.gatheringWarningRssi = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGatheringWarningRssi {
    __block BOOL success = NO;
    [MKLTInterface lt_configGatheringWarningRssi:self.gatheringWarningRssi sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readScanParams {
    __block BOOL success = NO;
    [MKLTInterface lt_readDeviceScanParamsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        if (![returnData[@"result"][@"isOn"] boolValue]) {
            //关闭
            self.scanWindow = 0;
        }else {
            //打开
            self.scanWindow = [returnData[@"result"][@"scanWindow"] integerValue];
        }
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
        NSError *error = [[NSError alloc] initWithDomain:@"scannerParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
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
        _readQueue = dispatch_queue_create("scannerQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
