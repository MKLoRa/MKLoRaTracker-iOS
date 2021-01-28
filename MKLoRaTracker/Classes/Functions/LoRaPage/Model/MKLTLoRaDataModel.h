//
//  MKLTLoRaDataModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTLoRaDataModel : NSObject

@property (nonatomic, copy)NSString *modem;

@property (nonatomic, copy)NSString *region;

@property (nonatomic, copy)NSString *classType;

/// 网络连接状态
@property (nonatomic, copy)NSString *networkStatus;

@property (nonatomic, copy)NSString *syncInterval;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
