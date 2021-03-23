//
//  MKLTCentralManager.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKLTOperationID.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lt_centralConnectStatus) {
    mk_lt_centralConnectStatusUnknow,                                           //未知状态
    mk_lt_centralConnectStatusConnecting,                                       //正在连接
    mk_lt_centralConnectStatusConnected,                                        //连接成功
    mk_lt_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_lt_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_lt_centralManagerStatus) {
    mk_lt_centralManagerStatusUnable,                           //不可用
    mk_lt_centralManagerStatusEnable,                           //可用状态
};

//Notification of device connection status changes.
extern NSString *const mk_lt_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_lt_centralManagerStateChangedNotification;

//Notification of receive 3-Axis Sensor data.
extern NSString *const mk_lt_receive3AxisSensorDataNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02, after restoring the factory settings, it returns 0x03, the device has no data communication for two consecutive minutes, it returns 0x04, and the shutdown protocol is sent to make the device shut down and return 0x05.
 */
extern NSString *const mk_lt_deviceDisconnectTypeNotification;

@class CBCentralManager,CBPeripheral;
@protocol mk_lt_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param trackerModel device
- (void)mk_lt_receiveDevice:(NSDictionary *)trackerModel;

@optional

/// Starts scanning equipment.
- (void)mk_lt_startScan;

/// Stops scanning equipment.
- (void)mk_lt_stopScan;

@end

@interface MKLTCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_lt_centralManagerScanDelegate>delegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_lt_centralConnectStatus connectStatus;

+ (MKLTCentralManager *)shared;

/// Destroy the MKLoRaTHCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKLoRaTHCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (mk_lt_centralManagerStatus )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

/// Connect device function
/// @param trackerModel Model
/// @param password Device connection password,8 characters long ascii code
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

- (void)disconnect;

/**
 Whether to monitor device GPS data/3-Axis Sensor Data.
 Default is on.

 @param notify BOOL
 @return result
 */
- (BOOL)notifyGPSDataData:(BOOL)notify;

/// Start a task for data communication with the device
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param resetNum How many data will the communication device return
/// @param commandData Data to be sent to the device for this communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addTaskWithTaskID:(mk_lt_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;

/// Start a task to read device characteristic data
/// @param operationID operation id
/// @param characteristic characteristic for communication
/// @param successBlock Successful callback
/// @param failureBlock Failure callback
- (void)addReadTaskWithTaskID:(mk_lt_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
