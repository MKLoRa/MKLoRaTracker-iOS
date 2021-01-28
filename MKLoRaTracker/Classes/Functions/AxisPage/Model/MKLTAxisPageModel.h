//
//  MKLTAxisPageModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTAxisPageModel : NSObject

@property (nonatomic, assign)BOOL axisIsOn;

/// 0:1hz
/// 1:10hz
/// 2:25hz
/// 3:50hz
/// 4:100hz
@property (nonatomic, assign)NSInteger sampleRate;

/// 0:±2g;
/// 1:±4g;
/// 2:±8g;
/// 3:±16g
@property (nonatomic, assign)NSInteger acceleration;

/// 7~255
@property (nonatomic, copy)NSString *sensitivity;

/// 1~60
@property (nonatomic, copy)NSString *reportInterval;

@property (nonatomic, assign)BOOL macIsOn;

@property (nonatomic, assign)BOOL timestampIsOn;

@property (nonatomic, assign)BOOL sensorDataIsOn;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置三轴数据开关，这个开关跟底部的sensor data开关有联动，每次设置都需要重新读取sensor data状态
/// @param isOn isOn
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)configAxisSwitchStatus:(BOOL)isOn
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

/// APP是否需要打开监听数据的开关，这个开关跟顶部的3-Axis Switch有联动，每次设置都需要重新读取3-Axis Switch状态
/// @param isOn isOn
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)configSensorDataStatus:(BOOL)isOn
                      sucBlock:(void (^)(void))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
