//
//  MKLTVibrationDataModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTVibrationDataModel : NSObject

/// 0:10%,1:50%,2:100%
@property (nonatomic, assign)NSInteger intensity;

@property (nonatomic, copy)NSString *cycle;

@property (nonatomic, copy)NSString *duration;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
