//
//  MKLTAdvertiserDataModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTAdvertiserDataModel.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTAdvertiserDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTAdvertiserDataModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read Adv Name Error" block:failedBlock];
            return;
        }
        if (![self readUUID]) {
            [self operationFailedBlockWithMsg:@"Read UUID Error" block:failedBlock];
            return;
        }
        if (![self readMajor]) {
            [self operationFailedBlockWithMsg:@"Read Major Error" block:failedBlock];
            return;
        }
        if (![self readMinor]) {
            [self operationFailedBlockWithMsg:@"Read Minor Error" block:failedBlock];
            return;
        }
        if (![self readAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Read Adv interval Error" block:failedBlock];
            return;
        }
        if (![self readMeasuredPower]) {
            [self operationFailedBlockWithMsg:@"Read Measured Power Error" block:failedBlock];
            return;
        }
        if (![self readTxPower]) {
            [self operationFailedBlockWithMsg:@"Read Tx Power Error" block:failedBlock];
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
        if (![self configDeviceName]) {
            [self operationFailedBlockWithMsg:@"Config Adv Name Error" block:failedBlock];
            return;
        }
        if (![self configUUID]) {
            [self operationFailedBlockWithMsg:@"Config Adv Name Error" block:failedBlock];
            return;
        }
        if (![self configMajor]) {
            [self operationFailedBlockWithMsg:@"Config Major Error" block:failedBlock];
            return;
        }
        if (![self configMinor]) {
            [self operationFailedBlockWithMsg:@"Config Minor Error" block:failedBlock];
            return;
        }
        if (![self configAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Config Adv Interval Error" block:failedBlock];
            return;
        }
        if (![self configMeasuredPower]) {
            [self operationFailedBlockWithMsg:@"Config Measured Power Error" block:failedBlock];
            return;
        }
        if (![self configTxPower]) {
            [self operationFailedBlockWithMsg:@"Config Tx Power Error" block:failedBlock];
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
- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKLTInterface lt_readDeviceNameWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advName = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceName {
    __block BOOL success = NO;
    [MKLTInterface lt_configDeviceName:self.advName sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readUUID {
    __block BOOL success = NO;
    [MKLTInterface lt_readBeaconProximityUUIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuid = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUUID {
    __block BOOL success = NO;
    [MKLTInterface lt_configBeaconProximityUUID:self.uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMajor {
    __block BOOL success = NO;
    [MKLTInterface lt_readBeaconMajorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.major = returnData[@"result"][@"major"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMajor  {
    __block BOOL success = NO;
    [MKLTInterface lt_configMajor:[self.major integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMinor {
    __block BOOL success = NO;
    [MKLTInterface lt_readBeaconMinorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.minor = returnData[@"result"][@"minor"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMinor  {
    __block BOOL success = NO;
    [MKLTInterface lt_configMinor:[self.minor integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readBroadcastIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configBroadcastInterval:[self.advInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMeasuredPower {
    __block BOOL success = NO;
    [MKLTInterface lt_readMeasuredPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.measuredPower = [returnData[@"result"][@"measuredPower"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMeasuredPower {
    __block BOOL success = NO;
    [MKLTInterface lt_configMeasuredPower:self.measuredPower sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTxPower {
    __block BOOL success = NO;
    [MKLTInterface lt_readTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.txPower = [self fetchTxPowerWithString:returnData[@"result"][@"txPower"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTxPower {
    __block BOOL success = NO;
    [MKLTInterface lt_configTxPower:[self fetchTxPowerValue:self.txPower] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"advertiserParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (NSInteger)fetchTxPowerWithString:(NSString *)string {
    if ([string isEqualToString:@"-40dBm"]) {
        return 0;
    }
    if ([string isEqualToString:@"-20dBm"]) {
        return 1;
    }
    if ([string isEqualToString:@"-16dBm"]) {
        return 2;
    }
    if ([string isEqualToString:@"-12dBm"]) {
        return 3;
    }
    if ([string isEqualToString:@"-8dBm"]) {
        return 4;
    }
    if ([string isEqualToString:@"-4dBm"]) {
        return 5;
    }
    if ([string isEqualToString:@"0dBm"]) {
        return 6;
    }
    if ([string isEqualToString:@"3dBm"]) {
        return 7;
    }
    if ([string isEqualToString:@"4dBm"]) {
        return 8;
    }
    return 5;
}

- (mk_lt_txPower)fetchTxPowerValue:(NSInteger)txPower {
    if (txPower == 0) {
        return mk_lt_txPowerNeg40dBm;
    }
    if (txPower == 1) {
        return mk_lt_txPowerNeg20dBm;
    }
    if (txPower == 2) {
        return mk_lt_txPowerNeg16dBm;
    }
    if (txPower == 3) {
        return mk_lt_txPowerNeg12dBm;
    }
    if (txPower == 4) {
        return mk_lt_txPowerNeg8dBm;
    }
    if (txPower == 5) {
        return mk_lt_txPowerNeg4dBm;
    }
    if (txPower == 6) {
        return mk_lt_txPower0dBm;
    }
    if (txPower == 7) {
        return mk_lt_txPower3dBm;
    }
    if (txPower == 8) {
        return mk_lt_txPower4dBm;
    }
    return mk_lt_txPowerNeg4dBm;
}

- (BOOL)checkParams {
    if (!ValidStr(self.advName) || self.advName.length > 10) {
        return NO;
    }
    if (![self.uuid isUUIDNumber]) {
        return NO;
    }
    if (!ValidStr(self.major) || [self.major integerValue] < 0 || [self.major integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.minor) || [self.minor integerValue] < 0 || [self.minor integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.advInterval) || [self.advInterval integerValue] < 1 || [self.advInterval integerValue] > 100) {
        return NO;
    }
    if (self.measuredPower < -127 || self.measuredPower > 0) {
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
        _readQueue = dispatch_queue_create("advertiserQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
