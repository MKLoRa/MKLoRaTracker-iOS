//
//  MKLTScanPageModel.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKLTScanPageModel : NSObject

@property (nonatomic, strong)CBPeripheral *peripheral;

/// Current rssi of the device
@property (nonatomic, assign)NSInteger rssi;

/// Device name
@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, assign)NSInteger major;

@property (nonatomic, assign)NSInteger minor;

/// RSSI@1m
@property (nonatomic, assign)NSInteger rssi1m;

@property (nonatomic, assign)NSInteger txPower;

/// Note:isTrackerPlus = YES;
@property (nonatomic, assign)NSInteger batteryPercentage;

/// mac address
@property (nonatomic, copy)NSString *macAddress;

/// Whether the current device can be connected.
@property (nonatomic, assign)BOOL connectable;

/// Whether the device's scanning function is turned on.
@property (nonatomic, assign)BOOL track;

/// Far and near information, immediate (within 10cm), near (within 1m), far (within 1m), unknown (no signal)
@property (nonatomic, copy)NSString *proximity;

/// cell上面显示的时间
@property (nonatomic, copy)NSString *scanTime;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;

/**
 当前model所在的row
 */
@property (nonatomic, assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
