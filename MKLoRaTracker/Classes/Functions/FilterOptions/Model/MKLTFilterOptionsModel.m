//
//  MKLTFilterOptionsModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTFilterOptionsModel.h"

#import "MKMacroDefines.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@interface MKLTFilterOptionsModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTFilterOptionsModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readConditionAStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Condition A Error" block:failedBlock];
            return;
        }
        if (![self readConditionBStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Condition B Error" block:failedBlock];
            return;
        }
        if (![self readLogicalRelationship]) {
            [self operationFailedBlockWithMsg:@"Read Logical Relation Ship Error" block:failedBlock];
            return;
        }
        if (![self readRepeatingData]) {
            [self operationFailedBlockWithMsg:@"Read Filter Repeating Data Type Error" block:failedBlock];
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
- (BOOL)readConditionAStatus {
    __block BOOL success = NO;
    mk_lt_filterRulesType type = mk_lt_contactTrackingFilterConditionA;
    if (self.type == mk_filterOptionsModelType_location) {
        type = mk_lt_locationBeaconFilterConditionA;
    }
    [MKLTInterface lt_readBLEFilterStatusWithType:type sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.conditionAIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readConditionBStatus {
    __block BOOL success = NO;
    mk_lt_filterRulesType type = mk_lt_contactTrackingFilterConditionB;
    if (self.type == mk_filterOptionsModelType_location) {
        type = mk_lt_locationBeaconFilterConditionB;
    }
    [MKLTInterface lt_readBLEFilterStatusWithType:type sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.conditionBIsOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLogicalRelationship {
    __block BOOL success = NO;
    if (self.type == mk_filterOptionsModelType_tracking) {
        [MKLTInterface lt_readTrackingLogicalRelationshipWithSucBlock:^(id  _Nonnull returnData) {
            success = YES;
            self.ABIsOr = ([returnData[@"result"][@"type"] integerValue] == 1);
            dispatch_semaphore_signal(self.semaphore);
        } failedBlock:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(self.semaphore);
        }];
    }else {
        [MKLTInterface lt_readLocationLogicalRelationshipWithSucBlock:^(id  _Nonnull returnData) {
            success = YES;
            self.ABIsOr = ([returnData[@"result"][@"type"] integerValue] == 1);
            dispatch_semaphore_signal(self.semaphore);
        } failedBlock:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(self.semaphore);
        }];
    }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRepeatingData {
    __block BOOL success = NO;
    if (self.type == mk_filterOptionsModelType_tracking) {
        [MKLTInterface lt_readTrackingFilterRepeatingDataTypeWithSucBlock:^(id  _Nonnull returnData) {
            success = YES;
            self.filterRepeatingDataType = [returnData[@"result"][@"type"] integerValue];
            dispatch_semaphore_signal(self.semaphore);
        } failedBlock:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(self.semaphore);
        }];
    }else {
        [MKLTInterface lt_readLocationFilterRepeatingDataTypeWithSucBlock:^(id  _Nonnull returnData) {
            success = YES;
            self.filterRepeatingDataType = [returnData[@"result"][@"type"] integerValue];
            dispatch_semaphore_signal(self.semaphore);
        } failedBlock:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(self.semaphore);
        }];
    }
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"filterOptionsParams"
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
        _readQueue = dispatch_queue_create("filterOptionsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
