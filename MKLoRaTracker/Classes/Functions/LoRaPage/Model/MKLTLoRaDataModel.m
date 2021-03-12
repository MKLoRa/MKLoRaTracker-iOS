//
//  MKLTLoRaDataModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTLoRaDataModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTLoRaDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTLoRaDataModel

- (instancetype)init {
    if (self = [super init]) {
        self.classType = @"ClassA";
    }
    return self;
}

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readModem]) {
            [self operationFailedBlockWithMsg:@"Read Modem Error" block:failedBlock];
            return;
        }
        if (![self readRegion]) {
            [self operationFailedBlockWithMsg:@"Read Region Error" block:failedBlock];
            return;
        }
        if (![self readNetworkStatus]) {
            [self operationFailedBlockWithMsg:@"Read Network Status Error" block:failedBlock];
            return;
        }
        if (![self readDevTimeSyncInterval]) {
            [self operationFailedBlockWithMsg:@"Read Time Sync Interval Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configDevTimeSyncInterval]) {
            [self operationFailedBlockWithMsg:@"Config DevTime Sync Interval Error" block:failedBlock];
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
- (BOOL)readModem {
    __block BOOL success = NO;
    [MKLTInterface lt_readLorawanModemWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.modem = ([returnData[@"result"][@"modem"] integerValue] == 1) ? @"ABP" : @"OTAA";
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRegion {
    __block BOOL success = NO;
    [MKLTInterface lt_readLorawanRegionWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.region = [self regionMsg:[returnData[@"result"][@"region"] integerValue]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNetworkStatus {
    __block BOOL success = NO;
    [MKLTInterface lt_readLorawanNetworkStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger type = [returnData[@"result"][@"status"] integerValue];
        if (type == 0) {
            self.networkStatus = @"Disconnected";
        }else if (type == 1) {
            self.networkStatus = @"Connected";
        }else {
            self.networkStatus = @"Connecting";
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDevTimeSyncInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readTimeSyncIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.syncInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDevTimeSyncInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_configTimeSyncInterval:[self.syncInterval integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"loraParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.syncInterval)) {
        return NO;
    }
    if ([self.syncInterval integerValue] < 0 || [self.syncInterval integerValue] > 240) {
        return NO;
    }
    return YES;
}

- (NSString *)regionMsg:(NSInteger)dataRegion {
    if (dataRegion == 0) {
        return @"EU868";
    }
    if (dataRegion == 1) {
        return @"US915";
    }
    if (dataRegion == 3) {
        return @"CN779";
    }
    if (dataRegion == 4) {
        return @"EU433";
    }
    if (dataRegion == 5) {
        return @"AU915";
    }
    if (dataRegion == 7) {
        return @"CN470";
    }
    if (dataRegion == 8) {
        return @"AS923";
    }
    if (dataRegion == 9) {
        return @"KR920";
    }
    if (dataRegion == 10) {
        return @"IN865";
    }
    if (dataRegion == 13) {
        return @"RU864";
    }
    return @"EU868";
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
        _readQueue = dispatch_queue_create("loraParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
