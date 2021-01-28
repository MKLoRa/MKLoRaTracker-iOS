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
        NSDictionary *regionDic = [self RegionDic];
        self.region = regionDic[returnData[@"result"][@"region"]];
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
        NSInteger type = [returnData[@"status"] integerValue];
        if (type == 0) {
            self.networkStatus = @"Disconnected";
        }else if (type == 1) {
            self.networkStatus = @"Connecting";
        }else {
            self.networkStatus = @"Connected";
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

- (NSDictionary *)RegionDic {
    return @{
        @"0":@"AS923",
        @"1":@"AU915",
        @"2":@"CN470",
        @"3":@"CN779",
        @"4":@"EU433",
        @"5":@"EU868",
        @"6":@"KR920",
        @"7":@"IN865",
        @"8":@"US915",
        @"9":@"RU864"
    };
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
