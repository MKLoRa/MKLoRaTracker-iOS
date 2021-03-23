//
//  MKLTOperation.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKLTOperationID.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const mk_lt_additionalInformation;
extern NSString *const mk_lt_dataInformation;
extern NSString *const mk_lt_dataStatusLev;

@interface MKLTOperation : NSOperation<MKBLEBaseOperationProtocol>

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param resetNum 是否需要根据外设返回的数据总条数来修改任务需要接受的数据总条数，YES需要，NO不需要
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(mk_lt_taskOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, mk_lt_taskOperationID operationID, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
