//
//  MKLTCentralManager.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKLTPeripheral.h"
#import "MKLTOperation.h"
#import "MKLTTaskAdopter.h"
#import "CBPeripheral+MKLTAdd.h"


NSString *const mk_lt_peripheralConnectStateChangedNotification = @"mk_lt_peripheralConnectStateChangedNotification";
NSString *const mk_lt_centralManagerStateChangedNotification = @"mk_lt_centralManagerStateChangedNotification";

NSString *const mk_lt_receive3AxisSensorDataNotification = @"mk_lt_receive3AxisSensorDataNotification";
NSString *const mk_lt_deviceDisconnectTypeNotification = @"mk_lt_deviceDisconnectTypeNotification";

static MKLTCentralManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKLTCentralManager ()

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, assign)mk_lt_centralConnectStatus connectStatus;

@end

@implementation MKLTCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKLTCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKLTCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dataModel = [self parseModelWithRssi:RSSI advDic:advertisementData peripheral:peripheral];
        if (!dataModel) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(mk_lt_receiveDevice:)]) {
                [self.delegate mk_lt_receiveDevice:dataModel];
            }
        });
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_lt_startScan)]) {
        [self.delegate mk_lt_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_lt_stopScan)]) {
        [self.delegate mk_lt_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    NSLog(@"蓝牙中心改变");
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_lt_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_lt_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_lt_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_lt_centralConnectStatusConnectedFailed;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_lt_centralConnectStatusDisconnect;
    }
    NSLog(@"当前连接状态发生改变了:%@",@(connectState));
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_lt_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSString *type = [content substringWithRange:NSMakeRange(8, 2)];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_lt_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":type}];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        //GPS、三轴数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSString *type = [content substringWithRange:NSMakeRange(4, 2)];
        if ([type isEqualToString:@"03"]) {
            //三轴
            NSDictionary *dic = @{
                @"x-axis":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)],
                @"y-axis":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(12, 4)],
                @"z-axis":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 4)],
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_lt_receive3AxisSensorDataNotification
                                                                object:nil
                                                              userInfo:@{@"axisData":dic}];
            return;
        }
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_lt_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_lt_centralManagerStatusEnable
    : mk_lt_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"AA01"]] options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (password.length != 8 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"Password Error" failedBlock:failedBlock];
        return;
    }
    self.password = nil;
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (BOOL)notifyGPSDataData:(BOOL)notify {
    if (self.connectStatus != mk_lt_centralConnectStatusConnected || [MKBLEBaseCentralManager shared].peripheral == nil || [MKBLEBaseCentralManager shared].peripheral.lt_gpsData == nil) {
        return NO;
    }
    [[MKBLEBaseCentralManager shared].peripheral setNotifyValue:notify
                                              forCharacteristic:[MKBLEBaseCentralManager shared].peripheral.lt_gpsData];
    return YES;
}

- (void)addTaskWithTaskID:(mk_lt_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
                 resetNum:(BOOL)resetNum
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKLTOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                   characteristic:characteristic
                                                                                         resetNum:resetNum
                                                                                      commandData:commandData
                                                                                     successBlock:successBlock
                                                                                     failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_lt_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKLTOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                       characteristic:characteristic
                                                                                         successBlock:successBlock
                                                                                         failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKLTPeripheral *trackerPeripheral = [[MKLTPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:trackerPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self sendPasswordToDevice];
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *commandData = @"ed010108";
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    
    MKLTOperation *operation = [[MKLTOperation alloc] initOperationWithID:mk_lt_connectPasswordOperation resetNum:NO commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.lt_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nonnull error, mk_lt_taskOperationID operationID, id  _Nonnull returnData) {
        NSDictionary *dataDic = ((NSArray *)returnData[mk_lt_dataInformation])[0];
        if (![dataDic[@"state"] isEqualToString:@"01"]) {
            //密码错误
            [self operationFailedBlockWithMsg:@"Password Error" failedBlock:self.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_lt_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_lt_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKLTOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_lt_taskOperationID)operationID
                                                                 characteristic:(CBCharacteristic *)characteristic
                                                                       resetNum:(BOOL)resetNum
                                                                    commandData:(NSString *)commandData
                                                                   successBlock:(void (^)(id returnData))successBlock
                                                                   failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKLTOperation <MKBLEBaseOperationProtocol>*operation = [[MKLTOperation alloc] initOperationWithID:operationID resetNum:resetNum commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nonnull error, mk_lt_taskOperationID operationID, id  _Nonnull returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSString *lev = returnData[mk_lt_dataStatusLev];
        if ([lev isEqualToString:@"1"]) {
            //通用无附加信息的
            NSArray *dataList = (NSArray *)returnData[mk_lt_dataInformation];
            if (!dataList) {
                [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
                return;
            }
            NSDictionary *resultDic = @{@"msg":@"success",
                                        @"code":@"1",
                                        @"result":(dataList.count == 1 ? dataList[0] : dataList),
                                        };
            MKBLEBase_main_safe(^{
                if (successBlock) {
                    successBlock(resultDic);
                }
            });
            return;
        }
        //对于有附加信息的
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData[mk_lt_dataInformation],
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKLTOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_lt_taskOperationID)operationID
                                                                     characteristic:(CBCharacteristic *)characteristic
                                                                       successBlock:(void (^)(id returnData))successBlock
                                                                       failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKLTOperation <MKBLEBaseOperationProtocol>*operation = [[MKLTOperation alloc] initOperationWithID:operationID resetNum:NO commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nonnull error, mk_lt_taskOperationID operationID, id  _Nonnull returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSString *lev = returnData[mk_lt_dataStatusLev];
        if ([lev isEqualToString:@"1"]) {
            //通用无附加信息的
            NSArray *dataList = (NSArray *)returnData[mk_lt_dataInformation];
            if (!dataList) {
                [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
                return;
            }
            NSDictionary *resultDic = @{@"msg":@"success",
                                        @"code":@"1",
                                        @"result":(dataList.count == 1 ? dataList[0] : dataList),
                                        };
            MKBLEBase_main_safe(^{
                if (successBlock) {
                    successBlock(resultDic);
                }
            });
            return;
        }
        //对于有附加信息的
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData[mk_lt_dataInformation],
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

#pragma mark - private method
- (NSDictionary *)parseModelWithRssi:(NSNumber *)rssi advDic:(NSDictionary *)advDic peripheral:(CBPeripheral *)peripheral {
    if ([rssi integerValue] == 127 || !MKValidDict(advDic) || !peripheral) {
        return @{};
    }
    NSData *manufacturerData = advDic[@"kCBAdvDataServiceData"][[CBUUID UUIDWithString:@"AA01"]];
    if (manufacturerData.length != 15) {
        return nil;
    }
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:manufacturerData];
    
    NSString *deviceType = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
    
    NSString *major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
    NSString *minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
    NSNumber *rssi1m = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(10, 2)]];
    NSNumber *txPower = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 2)]];
    
    NSString *distance = [self calcDistByRSSI:[rssi intValue] measurePower:labs([rssi1m integerValue])];
    NSString *proximity = @"Unknown";
    if ([distance doubleValue] <= 0.1) {
        proximity = @"Immediate";
    }else if ([distance doubleValue] > 0.1 && [distance doubleValue] <= 1.f){
        proximity = @"Near";
    }else if ([distance doubleValue] > 1.f){
        proximity = @"Far";
    }
    
    NSString *state = [MKBLEBaseSDKAdopter binaryByhex:[content substringWithRange:NSMakeRange(14, 2)]];
    BOOL connectable = [[state substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
    BOOL track = [[state substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
    BOOL sensor = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
    BOOL flash = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
    
    NSString *batteryPercentage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 2)];
    
    NSString *tempMac = [[content substringWithRange:NSMakeRange(18, 12)] uppercaseString];
    NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
    [tempMac substringWithRange:NSMakeRange(0, 2)],
    [tempMac substringWithRange:NSMakeRange(2, 2)],
    [tempMac substringWithRange:NSMakeRange(4, 2)],
    [tempMac substringWithRange:NSMakeRange(6, 2)],
    [tempMac substringWithRange:NSMakeRange(8, 2)],
    [tempMac substringWithRange:NSMakeRange(10, 2)]];
    
    return @{
        @"rssi":rssi,
        @"peripheral":peripheral,
        @"deviceName":(advDic[CBAdvertisementDataLocalNameKey] ? advDic[CBAdvertisementDataLocalNameKey] : @""),
        @"major":major,
        @"minor":minor,
        @"rssi1m":rssi1m,
        @"txPower":txPower,
        @"proximity":proximity,
        @"connectable":@(connectable),
        @"track":@(track),
        @"sensor":@(sensor),
        @"flash":@(flash),
        @"batteryPercentage":batteryPercentage,
        @"macAddress":macAddress,
    };
}

- (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower{
    int iRssi = abs(rssi);
    float power = (iRssi - measurePower) / (10 * 2.0);
    return [NSString stringWithFormat:@"%.2fm",pow(10, power)];
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.trackerCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

@end
