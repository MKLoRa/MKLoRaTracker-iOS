//
//  CBPeripheral+MKLTAdd.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKLTAdd)

#pragma mark - Read only

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lt_batteryPower;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lt_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lt_deviceModel;

@property (nonatomic, strong, readonly)CBCharacteristic *lt_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lt_sofeware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *lt_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *lt_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *lt_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *lt_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *lt_gpsData;

- (void)lt_updateCharacterWithService:(CBService *)service;

- (void)lt_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)lt_connectSuccess;

- (void)lt_setNil;

@end

NS_ASSUME_NONNULL_END
