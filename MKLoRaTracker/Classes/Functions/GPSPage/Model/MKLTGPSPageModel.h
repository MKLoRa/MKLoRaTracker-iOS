//
//  MKLTGPSPageModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTGPSPageModel : NSObject

@property (nonatomic, assign)BOOL isOn;

/// 0~19
@property (nonatomic, assign)NSInteger gpsInterval;

@property (nonatomic, copy)NSString *searchTime;

@property (nonatomic, assign)BOOL gpsAltitudeIsOn;

@property (nonatomic, assign)BOOL gpsTimeStampIsOn;

@property (nonatomic, assign)BOOL gpsPDOPIsOn;

@property (nonatomic, assign)BOOL gpsSatellitesIsOn;

@property (nonatomic, assign)BOOL gpssearchModelIsOn;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
