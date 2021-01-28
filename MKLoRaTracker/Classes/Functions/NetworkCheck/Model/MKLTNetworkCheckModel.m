//
//  MKLTNetworkCheckModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTNetworkCheckModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTNetworkCheckModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTNetworkCheckModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readNetworkCheckInterval]) {
            [self operationFailedBlockWithMsg:@"Read network check interval error" block:failedBlock];
            return;
        }
        if (![self readNetworkStatus]) {
            [self operationFailedBlockWithMsg:@"Read network status error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError * error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (self.checkStatus && ([self.checkInterval integerValue] < 0 || [self.checkInterval integerValue] > 240)) {
            [self operationFailedBlockWithMsg:@"Network Check Interval must be 0 ~ 240" block:failedBlock];
            return;
        }
        if (![self configNetworkCheckInterval]) {
            [self operationFailedBlockWithMsg:@"Config network check interval error" block:failedBlock];
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
- (BOOL)readNetworkCheckInterval {
    __block BOOL success = NO;
    [MKLTInterface lt_readNetworkCheckIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.checkInterval = returnData[@"result"][@"interval"];
        self.checkStatus = ([self.checkInterval integerValue] > 0);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNetworkCheckInterval {
    __block BOOL success = NO;
    NSInteger interval = 0;
    if (self.checkStatus > 0) {
        //间隔为0的情况下，开关关闭
        interval = [self.checkInterval integerValue];
    }
    [MKLTInterface lt_configNetworkCheckInterval:interval sucBlock:^{
        success = YES;
        self.checkStatus = (interval > 0);
        self.checkInterval = [NSString stringWithFormat:@"%ld",(long)interval];
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

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"networkCheckParams"
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
        _readQueue = dispatch_queue_create("networkCheckQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
