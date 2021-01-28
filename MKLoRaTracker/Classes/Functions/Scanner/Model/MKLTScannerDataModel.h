//
//  MKLTScannerDataModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTScannerDataModel : NSObject

@property (nonatomic, assign)NSInteger filterInterval;

/// 0:Off,1:Light,2:Vibration,3:Light + Vibration
@property (nonatomic, assign)NSInteger alarmNotification;

@property (nonatomic, assign)NSInteger triggerRssi;

@property (nonatomic, assign)NSInteger gatheringWarningRssi;

/*
 0,            //close.
 1,             //open.
 2,         //Open in half time.
 3,      //Open a quarter of the time.
 4,    //Open in one eighth time.
 */
@property (nonatomic, assign)NSInteger scanWindow;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
