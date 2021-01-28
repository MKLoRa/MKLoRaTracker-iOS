//
//  MKLTAdvertiserDataModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTAdvertiserDataModel : NSObject

@property (nonatomic, copy)NSString *advName;

@property (nonatomic, copy)NSString *uuid;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, assign)NSInteger measuredPower;

/*
 0,   //RadioTxPower:-40dBm
 1,   //-20dBm
 2,   //-16dBm
 3,   //-12dBm
 4,    //-8dBm
 5,    //-4dBm
 6,       //0dBm
 7,       //3dBm
 8,       //4dBm
 
 */
@property (nonatomic, assign)NSInteger txPower;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
