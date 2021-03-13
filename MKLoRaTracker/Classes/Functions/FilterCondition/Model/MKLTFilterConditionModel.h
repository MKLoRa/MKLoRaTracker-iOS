//
//  MKLTFilterConditionModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKLTInterface+MKLTConfig.h"

@interface MKLTFilterRawAdvDataModel : NSObject<mk_lt_BLEFilterRawDataProtocol>

@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:62 Bytes,maxIndex - minIndex <= 29 Bytes
@property (nonatomic, copy)NSString *rawData;

- (BOOL)validParams;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MKLTFilterConditionModel : NSObject

@property (nonatomic, assign)mk_lt_filterRulesType rulesType;

@property (nonatomic, assign)NSInteger rssiValue;

@property (nonatomic, assign)BOOL macIson;

@property (nonatomic, assign)BOOL macWhiteListIson;

@property (nonatomic, copy)NSString *macValue;

@property (nonatomic, assign)BOOL advNameIson;

@property (nonatomic, assign)BOOL advNameWhiteListIson;

@property (nonatomic, copy)NSString *advNameValue;

@property (nonatomic, assign)BOOL uuidIson;

@property (nonatomic, assign)BOOL uuidWhiteListIson;

@property (nonatomic, copy)NSString *uuidValue;

@property (nonatomic, assign)BOOL majorIson;

@property (nonatomic, assign)BOOL majorWhiteListIson;

/// 过滤的Major可以是一个范围值
@property (nonatomic, copy)NSString *majorMaxValue;

/// 过滤的Major可以是一个范围值
@property (nonatomic, copy)NSString *majorMinValue;

@property (nonatomic, assign)BOOL minorIson;

@property (nonatomic, assign)BOOL minorWhiteListIson;

//过滤的Minor可以是一个范围值
@property (nonatomic, copy)NSString *minorMaxValue;

//过滤的Minor可以是一个范围值
@property (nonatomic, copy)NSString *minorMinValue;

@property (nonatomic, assign)BOOL rawDataIson;

@property (nonatomic, assign)BOOL rawDataWhiteListIson;

/// 过滤的原始数据
@property (nonatomic, strong)NSMutableArray *rawDataList;

@property (nonatomic, assign)BOOL enableFilterConditions;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithRawDataList:(NSArray <MKLTFilterRawAdvDataModel *>*)list
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
