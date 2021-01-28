//
//  MKLTDeviceInfoDataModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTDeviceInfoDataModel : NSObject

/// 电池电量
@property (nonatomic, copy)NSString *batteryPower;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 产品型号
 */
@property (nonatomic, copy)NSString *productMode;

/**
 软件版本
 */
@property (nonatomic, copy)NSString *software;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmware;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardware;

/**
 厂商信息
 */
@property (nonatomic, copy)NSString *manu;

/// 开始读取设备信息
/// @param onlyBattery 是否只读取电池电量
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)startLoadSystemInformation:(BOOL)onlyBattery
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
