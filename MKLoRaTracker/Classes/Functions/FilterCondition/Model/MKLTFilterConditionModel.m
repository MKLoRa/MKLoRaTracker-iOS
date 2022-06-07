//
//  MKLTFilterConditionModel.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTFilterConditionModel.h"

#import "MKMacroDefines.h"
#import "NSObject+MKModel.h"
#import "NSString+MKAdd.h"

#import "MKLTInterface.h"
#import "MKLTInterface+MKLTConfig.h"

@implementation MKLTFilterRawAdvDataModel

- (BOOL)validParams {
    if (!ValidStr(self.dataType) || self.dataType.length != 2 || ![self.dataType regularExpressions:isHexadecimal]) {
        return NO;
    }
    if (self.minIndex == 0 && self.maxIndex == 0) {
        if (!ValidStr(self.rawData) || self.rawData.length > 124 || ![self.rawData regularExpressions:isHexadecimal] || (self.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (self.minIndex < 0 || self.minIndex > 62 || self.maxIndex < 0 || self.maxIndex > 62) {
        return NO;
    }
    
    if (self.maxIndex < self.minIndex) {
        return NO;
    }
    if (!ValidStr(self.rawData) || self.rawData.length > 124 || ![self.rawData regularExpressions:isHexadecimal]) {
        return NO;
    }
    NSInteger totalLen = (self.maxIndex - self.minIndex + 1) * 2;
    if (totalLen > 58 || self.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

@end

@interface MKLTFilterConditionModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKLTFilterConditionModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readRssi]) {
            [self operationFailedBlockWithMsg:@"Read rssi error" block:failedBlock];
            return;
        }
        if (![self readMacAddress]) {
            [self operationFailedBlockWithMsg:@"Read mac address error" block:failedBlock];
            return;
        }
        if (![self readDeviceName]) {
            [self operationFailedBlockWithMsg:@"Read advName error" block:failedBlock];
            return;
        }
        if (![self readUUID]) {
            [self operationFailedBlockWithMsg:@"Read uuid error" block:failedBlock];
            return;
        }
        if (![self readMajor]) {
            [self operationFailedBlockWithMsg:@"Read major error" block:failedBlock];
            return;
        }
        if (![self readMinor]) {
            [self operationFailedBlockWithMsg:@"Read minor error" block:failedBlock];
            return;
        }
        if (![self readRawData]) {
            [self operationFailedBlockWithMsg:@"Read raw data error" block:failedBlock];
            return;
        }
        if (![self readEnableFilterConditions]) {
            [self operationFailedBlockWithMsg:@"Read Enable Filter Condition Status Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithRawDataList:(NSArray <MKLTFilterRawAdvDataModel *>*)list
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams:list]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return ;
        }
        if (![self configRssi]) {
            [self operationFailedBlockWithMsg:@"Config rssi error" block:failedBlock];
            return;
        }
        if (![self configMacAddress]) {
            [self operationFailedBlockWithMsg:@"Config mac address error" block:failedBlock];
            return;
        }
        if (![self configDeviceName]) {
            [self operationFailedBlockWithMsg:@"Config advName error" block:failedBlock];
            return;
        }
        if (![self configUUID]) {
            [self operationFailedBlockWithMsg:@"Config uuid error" block:failedBlock];
            return;
        }
        if (![self configMajor]) {
            [self operationFailedBlockWithMsg:@"Config major error" block:failedBlock];
            return;
        }
        if (![self configMinor]) {
            [self operationFailedBlockWithMsg:@"Config minor error" block:failedBlock];
            return;
        }
        if (![self configRawDataWithList:list]) {
            [self operationFailedBlockWithMsg:@"Config raw data error" block:failedBlock];
            return;
        }
        if (![self configEnableFilterConditions]) {
            [self operationFailedBlockWithMsg:@"Config Enable Filter Condition Status Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - setter

#pragma mark - interface
- (BOOL)readRssi {
    __block BOOL success = NO;
    [MKLTInterface lt_readBLEFilterDeviceRSSIWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rssiValue = [returnData[@"result"][@"rssi"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRssi {
    __block BOOL success = NO;
    
    [MKLTInterface lt_configBLEFilterDeviceRSSIWithType:self.rulesType rssi:self.rssiValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacAddress {
    __block BOOL success = NO;
    [MKLTInterface lt_readBLEFilterDeviceMacWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macIson = ([returnData[@"result"][@"rule"] integerValue] > 0);
        self.macWhiteListIson = ([returnData[@"result"][@"rule"] integerValue] == 2);
        self.macValue = returnData[@"result"][@"macAddress"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMacAddress {
    __block BOOL success = NO;
    mk_lt_filterRules rules = mk_lt_filterRules_off;
    if (self.macIson) {
        rules = (self.macWhiteListIson ? mk_lt_filterRules_reverse : mk_lt_filterRules_forward);
    }
    [MKLTInterface lt_configBLEFilterDeviceMacWithType:self.rulesType rules:rules mac:self.macValue sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceName {
    __block BOOL success = NO;
    [MKLTInterface lt_readBLEFilterDeviceNameWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advNameIson = ([returnData[@"result"][@"rule"] integerValue] > 0);
        self.advNameWhiteListIson = ([returnData[@"result"][@"rule"] integerValue] == 2);
        self.advNameValue = returnData[@"result"][@"deviceName"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceName {
    __block BOOL success = NO;
    mk_lt_filterRules rules = mk_lt_filterRules_off;
    if (self.advNameIson) {
        rules = (self.advNameWhiteListIson ? mk_lt_filterRules_reverse : mk_lt_filterRules_forward);
    }
    [MKLTInterface lt_configBLEFilterDeviceNameWithType:self.rulesType rules:rules deviceName:self.advNameValue sucBlock:^{
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
    [MKLTInterface lt_readBLEFilterDeviceUUIDWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.uuidIson = ([returnData[@"result"][@"rule"] integerValue] > 0);
        self.uuidWhiteListIson = ([returnData[@"result"][@"rule"] integerValue] == 2);
        self.uuidValue = returnData[@"result"][@"uuid"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUUID {
    __block BOOL success = NO;
    mk_lt_filterRules rules = mk_lt_filterRules_off;
    if (self.uuidIson) {
        rules = (self.uuidWhiteListIson ? mk_lt_filterRules_reverse : mk_lt_filterRules_forward);
    }
    [MKLTInterface lt_configBLEFilterDeviceUUIDWithType:self.rulesType rules:rules uuid:self.uuidValue sucBlock:^{
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
    [MKLTInterface lt_readBLEFilterDeviceMajorWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.majorIson = ([returnData[@"result"][@"rule"] integerValue] > 0);
        self.majorWhiteListIson = ([returnData[@"result"][@"rule"] integerValue] == 2);
        self.majorMinValue = returnData[@"result"][@"majorLow"];
        self.majorMaxValue = returnData[@"result"][@"majorHigh"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMajor {
    __block BOOL success = NO;
    mk_lt_filterRules rules = mk_lt_filterRules_off;
    if (self.majorIson) {
        rules = (self.majorWhiteListIson ? mk_lt_filterRules_reverse : mk_lt_filterRules_forward);
    }
    [MKLTInterface lt_configBLEFilterDeviceMajorWithType:self.rulesType rules:rules majorMin:[self.majorMinValue integerValue] majorMax:[self.majorMaxValue integerValue] sucBlock:^{
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
    [MKLTInterface lt_readBLEFilterDeviceMinorWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.minorIson = ([returnData[@"result"][@"rule"] integerValue] > 0);
        self.minorWhiteListIson = ([returnData[@"result"][@"rule"] integerValue] == 2);
        self.minorMinValue = returnData[@"result"][@"minorLow"];
        self.minorMaxValue = returnData[@"result"][@"minorHigh"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMinor {
    __block BOOL success = NO;
    mk_lt_filterRules rules = mk_lt_filterRules_off;
    if (self.minorIson) {
        rules = (self.minorWhiteListIson ? mk_lt_filterRules_reverse : mk_lt_filterRules_forward);
    }
    [MKLTInterface lt_configBLEFilterDeviceMinorWithType:self.rulesType rules:rules minorMin:[self.minorMinValue integerValue] minorMax:[self.minorMaxValue integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRawData {
    __block BOOL success = NO;
    [MKLTInterface lt_readBLEFilterDeviceRawDataWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rawDataIson = ([returnData[@"result"][@"rule"] integerValue] > 0);
        self.rawDataWhiteListIson = ([returnData[@"result"][@"rule"] integerValue] == 2);
        self.rawDataList = returnData[@"result"][@"filterList"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRawDataWithList:(NSArray <MKLTFilterRawAdvDataModel *>*)list {
    __block BOOL success = NO;
    mk_lt_filterRules rules = mk_lt_filterRules_off;
    if (self.rawDataIson) {
        rules = (self.rawDataWhiteListIson ? mk_lt_filterRules_reverse : mk_lt_filterRules_forward);
    }
    [MKLTInterface lt_configBLEFilterDeviceRawDataWithType:self.rulesType rules:rules rawDataList:list sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEnableFilterConditions {
    __block BOOL success = NO;
    [MKLTInterface lt_readBLEFilterStatusWithType:self.rulesType sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.enableFilterConditions = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEnableFilterConditions {
    __block BOOL success = NO;
    [MKLTInterface lt_configBLEFilterStatusWithType:self.rulesType isOn:self.enableFilterConditions sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - params valid
- (BOOL)validParams:(NSArray *)list {
    if (self.macIson) {
        if (self.macValue.length % 2 != 0 || self.macValue.length == 0 || self.macValue.length > 12) {
            return NO;
        }
    }
    if (self.advNameIson) {
        if (!ValidStr(self.advNameValue) || self.advNameValue.length > 29) {
            return NO;
        }
    }
    if (self.uuidIson) {
        if (![self.uuidValue regularExpressions:isHexadecimal] || self.uuidValue.length % 2 != 0) {
            return NO;
        }
    }
    if (self.majorIson) {
        if (!ValidStr(self.majorMaxValue) || [self.majorMaxValue integerValue] < 0 || [self.majorMaxValue integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.majorMinValue) || [self.majorMinValue integerValue] < 0 || [self.majorMinValue integerValue] > 65535) {
            return NO;
        }
        if ([self.majorMaxValue integerValue] < [self.majorMinValue integerValue]) {
            return NO;
        }
    }
    if (self.minorIson) {
        if (!ValidStr(self.minorMaxValue) || [self.minorMaxValue integerValue] < 0 || [self.minorMaxValue integerValue] > 65535) {
            return NO;
        }
        if (!ValidStr(self.minorMinValue) || [self.minorMinValue integerValue] < 0 || [self.minorMinValue integerValue] > 65535) {
            return NO;
        }
        if ([self.minorMaxValue integerValue] < [self.minorMinValue integerValue]) {
            return NO;
        }
    }
    if (self.rawDataIson && !ValidArray(list)) {
        //打开了原始数据过滤
        return NO;
    }
    
    return YES;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"filterParams"
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
        _readQueue = dispatch_queue_create("filterQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
