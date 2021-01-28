//
//  MKLTSettingDataModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTSettingDataModel : NSObject

@property (nonatomic, copy)NSString *advName;

@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, assign)NSInteger lowPowerAlarm;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
