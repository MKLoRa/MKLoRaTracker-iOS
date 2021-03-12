//
//  MKLTTaskAdopter.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKLTOperationID.h"

NSString *const mk_lt_communicationDataNum = @"mk_lt_communicationDataNum";

@implementation MKLTTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
        //电池电量
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        return [self dataParserGetDataSuccess:@{@"batteryPower":battery} operationID:mk_lt_taskReadBatteryPowerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_lt_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_lt_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_lt_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_lt_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_lt_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 10) {
            state = [content substringWithRange:NSMakeRange(8, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_lt_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    mk_lt_taskOperationID operationID = mk_lt_defaultTaskOperationID;
    return [self dataParserGetDataSuccess:@{@"result":@(YES)} operationID:operationID];
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data{
    mk_lt_taskOperationID operationID = mk_lt_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"1e"]) {
        //读取设备时间同步间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //读取设备UUID
        NSString *uuid = @"";
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[content substringWithRange:NSMakeRange(0, 8)],
                                 [content substringWithRange:NSMakeRange(8, 4)],
                                 [content substringWithRange:NSMakeRange(12, 4)],
                                 [content substringWithRange:NSMakeRange(16,4)],
                                 [content substringWithRange:NSMakeRange(20, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        resultDic = @{@"uuid":uuid};
        operationID = mk_lt_taskReadBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //读取设备Major
        NSString *major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"major":major};
        operationID = mk_lt_taskReadBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //读取设备Minor
        NSString *minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"minor":minor};
        operationID = mk_lt_taskReadBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //读取设备measured power
        NSString *measuredPower = [NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(0, content.length)]] integerValue]];
        resultDic = @{@"measuredPower":measuredPower};
        operationID = mk_lt_taskReadMeasuredPowerOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //读取设备Tx Power
        NSString *txPower = [self fetchTxPower:content];
        resultDic = @{@"txPower":txPower};
        operationID = mk_lt_taskReadTxPowerOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //读取设备广播间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{@"interval":interval};
        operationID = mk_lt_taskReadBroadcastIntervalOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //读取设备名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_lt_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //读取设备扫描窗口参数
        NSString *scanWindow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        resultDic = @{
            @"scanWindow":scanWindow
        };
        operationID = mk_lt_taskReadScanParamsOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //读取设备蓝牙可连接状态
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_lt_taskReadConnectableStatusOperation;
    }else if ([cmd isEqualToString:@"2b"]) {
        //读取LoRaWAN入网类型
        resultDic = @{
            @"modem":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLorawanModemOperation;
    }else if ([cmd isEqualToString:@"2c"]) {
        //读取LoRaWAN频段
        resultDic = @{
            @"region":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLorawanRegionOperation;
    }else if ([cmd isEqualToString:@"2d"]) {
        //读取LoRaWAN DEVEUI
        resultDic = @{
            @"devEUI":content,
        };
        operationID = mk_lt_taskReadLorawanDEVEUIOperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //读取LoRaWAN APPEUI
        resultDic = @{
            @"appEUI":content
        };
        operationID = mk_lt_taskReadLorawanAPPEUIOperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //读取LoRaWAN APPKEY
        resultDic = @{
            @"appKey":content
        };
        operationID = mk_lt_taskReadLorawanAPPKEYOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //读取LoRaWAN DEVADDR
        resultDic = @{
            @"devAddr":content
        };
        operationID = mk_lt_taskReadLorawanDEVADDROperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //读取LoRaWAN APPSKEY
        resultDic = @{
            @"appSkey":content
        };
        operationID = mk_lt_taskReadLorawanAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //读取LoRaWAN nwkSkey
        resultDic = @{
            @"nwkSkey":content
        };
        operationID = mk_lt_taskReadLorawanNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //读取LoRaWAN CH
        resultDic = @{
            @"CHL":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"CHH":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)]
        };
        operationID = mk_lt_taskReadLorawanCHOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //读取LoRaWAN DR
        resultDic = @{
            @"DR":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLorawanDROperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //读取LoRaWAN ADR
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadLorawanADROperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //读取LoRaWAN 上行数据类型
        resultDic = @{
            @"messageType":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLorawanMessageTypeOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //读取LoRaWAN网络状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLorawanNetworkStatusOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //读取网络检测间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //读取报警RSSI值
        resultDic = @{
            @"rssi":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_lt_taskReadAlarmTriggerRSSIOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //读取报警类型
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadAlarmNotificationTypeOperation;
    }else if ([cmd isEqualToString:@"3b"]) {
        //读取马达震动强度
        resultDic = @{
            @"intensity":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadVibrationIntensityOperation;
    }else if ([cmd isEqualToString:@"3c"]) {
        //读取马达震动时长
        resultDic = @{
            @"duration":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadDurationOfVibrationOperation;
    }else if ([cmd isEqualToString:@"3d"]) {
        //读取马达周期
        resultDic = @{
            @"cycle":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadVibrationCycleOfMotorOperation;
    }else if ([cmd isEqualToString:@"3f"]) {
        //读取设备MAC地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_lt_taskReadMacAddressOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //读取低电量报警百分比
        resultDic = @{
            @"percent":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLowPowerPromptOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //读取扫描数据定时上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadScanDatasReportIntervalOperation;
    }else if ([cmd isEqualToString:@"43"]) {
        //读取Tracking过滤规则A - RSSI
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:content];
        resultDic = @{
            @"rssi":rssi,
        };
        operationID = mk_lt_taskReadTrackingAFilterRssiOperation;
    }else if ([cmd isEqualToString:@"44"]) {
        //读取Tracking过滤规则A - deviceName
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *deviceName = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5)] encoding:NSUTF8StringEncoding];
        }
        if (!MKValidStr(deviceName)) {
            deviceName = @"";
        }
        resultDic = @{
            @"rule":rule,
            @"deviceName":deviceName,
        };
        operationID = mk_lt_taskReadTrackingAFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //读取Tracking过滤规则A - mac地址
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *macAddress = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            macAddress = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"macAddress":macAddress
        };
        operationID = mk_lt_taskReadTrackingAFilterMacOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //读取Tracking过滤规则A - major范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *majorLow = @"";
        NSString *majorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            majorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            majorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"majorLow":majorLow,
            @"majorHigh":majorHigh,
        };
        operationID = mk_lt_taskReadTrackingAFilterMajorOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //读取Tracking过滤规则A - minor范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *minorLow = @"";
        NSString *minorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            minorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            minorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"minorLow":minorLow,
            @"minorHigh":minorHigh,
        };
        operationID = mk_lt_taskReadTrackingAFilterMinorOperation;
    }else if ([cmd isEqualToString:@"48"]) {
        //读取Tracking过滤规则A - UUID
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *uuid = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            NSString *tempContent = [content substringWithRange:NSMakeRange(2, content.length - 2)];
            
            NSMutableArray *array = [NSMutableArray arrayWithObjects:[tempContent substringWithRange:NSMakeRange(0, 8)],
                                     [tempContent substringWithRange:NSMakeRange(8, 4)],
                                     [tempContent substringWithRange:NSMakeRange(12, 4)],
                                     [tempContent substringWithRange:NSMakeRange(16,4)],
                                     [tempContent substringWithRange:NSMakeRange(20, 12)], nil];
            [array insertObject:@"-" atIndex:1];
            [array insertObject:@"-" atIndex:3];
            [array insertObject:@"-" atIndex:5];
            [array insertObject:@"-" atIndex:7];
            for (NSString *string in array) {
                uuid = [uuid stringByAppendingString:string];
            }
        }
        resultDic = @{
            @"rule":rule,
            @"uuid":uuid
        };
        operationID = mk_lt_taskReadTrackingAFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"49"]) {
        //读取Tracking过滤规则A - 原始数据
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSMutableArray *filterList = [NSMutableArray array];
        if ([rule integerValue] > 0 && content.length > 2) {
            NSInteger subIndex = 2;
            //最多五条过滤数据
            for (NSInteger i = 0; i < 5; i ++) {
                NSInteger index0Len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(subIndex, 2)];
                NSString *index0Data = [content substringWithRange:NSMakeRange(subIndex + 2, index0Len * 2)];
                
                NSDictionary *index0Dic = @{
                    @"dataType":[index0Data substringWithRange:NSMakeRange(0, 2)],
                    @"minIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(2, 2)],
                    @"maxIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(4, 2)],
                    @"rawData":[index0Data substringFromIndex:6],
                    @"index":@(i),
                };
                [filterList addObject:index0Dic];
                subIndex += (index0Data.length + 2);
                if (subIndex >= content.length) {
                    break;
                }
            }
        }
        resultDic = @{
            @"rule":rule,
            @"filterList":filterList,
        };
        operationID = mk_lt_taskReadTrackingAFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"4a"]) {
        //读取Tracking过滤规则B - RSSI
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:content];
        resultDic = @{
            @"rssi":rssi,
        };
        operationID = mk_lt_taskReadTrackingBFilterRssiOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //读取Tracking过滤规则B - deviceName
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *deviceName = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5)] encoding:NSUTF8StringEncoding];
        }
        if (!MKValidStr(deviceName)) {
            deviceName = @"";
        }
        resultDic = @{
            @"rule":rule,
            @"deviceName":deviceName,
        };
        operationID = mk_lt_taskReadTrackingBFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //读取Tracking过滤规则B - mac地址
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *macAddress = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            macAddress = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"macAddress":macAddress
        };
        operationID = mk_lt_taskReadTrackingBFilterMacOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //读取Tracking过滤规则B - major范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *majorLow = @"";
        NSString *majorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            majorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            majorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"majorLow":majorLow,
            @"majorHigh":majorHigh,
        };
        operationID = mk_lt_taskReadTrackingBFilterMajorOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //读取Tracking过滤规则B - minor范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *minorLow = @"";
        NSString *minorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            minorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            minorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"minorLow":minorLow,
            @"minorHigh":minorHigh,
        };
        operationID = mk_lt_taskReadTrackingBFilterMinorOperation;
    }else if ([cmd isEqualToString:@"4f"]) {
        //读取Tracking过滤规则B - UUID
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *uuid = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            NSString *tempContent = [content substringWithRange:NSMakeRange(2, content.length - 2)];
            
            NSMutableArray *array = [NSMutableArray arrayWithObjects:[tempContent substringWithRange:NSMakeRange(0, 8)],
                                     [tempContent substringWithRange:NSMakeRange(8, 4)],
                                     [tempContent substringWithRange:NSMakeRange(12, 4)],
                                     [tempContent substringWithRange:NSMakeRange(16,4)],
                                     [tempContent substringWithRange:NSMakeRange(20, 12)], nil];
            [array insertObject:@"-" atIndex:1];
            [array insertObject:@"-" atIndex:3];
            [array insertObject:@"-" atIndex:5];
            [array insertObject:@"-" atIndex:7];
            for (NSString *string in array) {
                uuid = [uuid stringByAppendingString:string];
            }
        }
        resultDic = @{
            @"rule":rule,
            @"uuid":uuid
        };
        operationID = mk_lt_taskReadTrackingBFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"50"]) {
        //读取Tracking过滤规则B - 原始数据
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSMutableArray *filterList = [NSMutableArray array];
        if ([rule integerValue] > 0 && content.length > 2) {
            NSInteger subIndex = 2;
            //最多五条过滤数据
            for (NSInteger i = 0; i < 5; i ++) {
                NSInteger index0Len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(subIndex, 2)];
                NSString *index0Data = [content substringWithRange:NSMakeRange(subIndex + 2, index0Len * 2)];
                
                NSDictionary *index0Dic = @{
                    @"dataType":[index0Data substringWithRange:NSMakeRange(0, 2)],
                    @"minIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(2, 2)],
                    @"maxIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(4, 2)],
                    @"rawData":[index0Data substringFromIndex:6],
                    @"index":@(i),
                };
                [filterList addObject:index0Dic];
                subIndex += (index0Data.length + 2);
                if (subIndex >= content.length) {
                    break;
                }
            }
        }
        resultDic = @{
            @"rule":rule,
            @"filterList":filterList,
        };
        operationID = mk_lt_taskReadTrackingBFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //读取Tracking过滤规则A - 开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadTrackingAFilterStatusOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //读取Tracking过滤规则B - 开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadTrackingBFilterStatusOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //读取Tracking过滤规则A/B与或逻辑
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadTrackingLogicalRelationshipOperation;
    }else if ([cmd isEqualToString:@"54"]) {
        //读取Tracking重复数据判定规则
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadTrackingFilterRepeatingDataTypeOperation;
    }else if ([cmd isEqualToString:@"55"]) {
        //读取扫描有效数据筛选间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadValidBLEDataFilterIntervalOperation;
    }else if ([cmd isEqualToString:@"56"]) {
        //读取设备信息同步间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadDeviceInfoReportIntervalOperation;
    }else if ([cmd isEqualToString:@"58"]) {
        //读取人员聚集报警RSSI值
        resultDic = @{
            @"rssi":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_lt_taskReadGatheringWarningRssiOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //读取Location过滤规则A - RSSI
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:content];
        resultDic = @{
            @"rssi":rssi,
        };
        operationID = mk_lt_taskReadLocationAFilterRssiOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //读取Location过滤规则A - deviceName
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *deviceName = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5)] encoding:NSUTF8StringEncoding];
        }
        if (!MKValidStr(deviceName)) {
            deviceName = @"";
        }
        resultDic = @{
            @"rule":rule,
            @"deviceName":deviceName,
        };
        operationID = mk_lt_taskReadLocationAFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //读取Location过滤规则A - mac地址
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *macAddress = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            macAddress = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"macAddress":macAddress
        };
        operationID = mk_lt_taskReadLocationAFilterMacOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //读取Location过滤规则A - major范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *majorLow = @"";
        NSString *majorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            majorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            majorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"majorLow":majorLow,
            @"majorHigh":majorHigh,
        };
        operationID = mk_lt_taskReadLocationAFilterMajorOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //读取Location过滤规则A - minor范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *minorLow = @"";
        NSString *minorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            minorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            minorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"minorLow":minorLow,
            @"minorHigh":minorHigh,
        };
        operationID = mk_lt_taskReadLocationAFilterMinorOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //读取Location过滤规则A - UUID
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *uuid = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            NSString *tempContent = [content substringWithRange:NSMakeRange(2, content.length - 2)];
            
            NSMutableArray *array = [NSMutableArray arrayWithObjects:[tempContent substringWithRange:NSMakeRange(0, 8)],
                                     [tempContent substringWithRange:NSMakeRange(8, 4)],
                                     [tempContent substringWithRange:NSMakeRange(12, 4)],
                                     [tempContent substringWithRange:NSMakeRange(16,4)],
                                     [tempContent substringWithRange:NSMakeRange(20, 12)], nil];
            [array insertObject:@"-" atIndex:1];
            [array insertObject:@"-" atIndex:3];
            [array insertObject:@"-" atIndex:5];
            [array insertObject:@"-" atIndex:7];
            for (NSString *string in array) {
                uuid = [uuid stringByAppendingString:string];
            }
        }
        resultDic = @{
            @"rule":rule,
            @"uuid":uuid
        };
        operationID = mk_lt_taskReadLocationAFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //读取Location过滤规则A - 原始数据
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSMutableArray *filterList = [NSMutableArray array];
        if ([rule integerValue] > 0 && content.length > 2) {
            NSInteger subIndex = 2;
            //最多五条过滤数据
            for (NSInteger i = 0; i < 5; i ++) {
                NSInteger index0Len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(subIndex, 2)];
                NSString *index0Data = [content substringWithRange:NSMakeRange(subIndex + 2, index0Len * 2)];
                
                NSDictionary *index0Dic = @{
                    @"dataType":[index0Data substringWithRange:NSMakeRange(0, 2)],
                    @"minIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(2, 2)],
                    @"maxIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(4, 2)],
                    @"rawData":[index0Data substringFromIndex:6],
                    @"index":@(i),
                };
                [filterList addObject:index0Dic];
                subIndex += (index0Data.length + 2);
                if (subIndex >= content.length) {
                    break;
                }
            }
        }
        resultDic = @{
            @"rule":rule,
            @"filterList":filterList,
        };
        operationID = mk_lt_taskReadLocationAFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //读取Location过滤规则B - RSSI
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:content];
        resultDic = @{
            @"rssi":rssi,
        };
        operationID = mk_lt_taskReadLocationBFilterRssiOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //读取Location过滤规则B - deviceName
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *deviceName = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            deviceName = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, data.length - 5)] encoding:NSUTF8StringEncoding];
        }
        if (!MKValidStr(deviceName)) {
            deviceName = @"";
        }
        resultDic = @{
            @"rule":rule,
            @"deviceName":deviceName,
        };
        operationID = mk_lt_taskReadLocationBFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //读取Location过滤规则B - mac地址
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *macAddress = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            macAddress = [content substringWithRange:NSMakeRange(2, content.length - 2)];
        }
        resultDic = @{
            @"rule":rule,
            @"macAddress":macAddress
        };
        operationID = mk_lt_taskReadLocationBFilterMacOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //读取Location过滤规则B - major范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *majorLow = @"";
        NSString *majorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            majorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            majorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"majorLow":majorLow,
            @"majorHigh":majorHigh,
        };
        operationID = mk_lt_taskReadLocationBFilterMajorOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //读取Location过滤规则B - minor范围
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *minorLow = @"";
        NSString *minorHigh = @"";
        if ([rule integerValue] > 0 && content.length == 10) {
            minorLow = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
            minorHigh = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        }
        resultDic = @{
            @"rule":rule,
            @"minorLow":minorLow,
            @"minorHigh":minorHigh,
        };
        operationID = mk_lt_taskReadLocationBFilterMinorOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //读取Location过滤规则B - UUID
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *uuid = @"";
        if ([rule integerValue] > 0 && content.length > 2) {
            NSString *tempContent = [content substringWithRange:NSMakeRange(2, content.length - 2)];
            
            NSMutableArray *array = [NSMutableArray arrayWithObjects:[tempContent substringWithRange:NSMakeRange(0, 8)],
                                     [tempContent substringWithRange:NSMakeRange(8, 4)],
                                     [tempContent substringWithRange:NSMakeRange(12, 4)],
                                     [tempContent substringWithRange:NSMakeRange(16,4)],
                                     [tempContent substringWithRange:NSMakeRange(20, 12)], nil];
            [array insertObject:@"-" atIndex:1];
            [array insertObject:@"-" atIndex:3];
            [array insertObject:@"-" atIndex:5];
            [array insertObject:@"-" atIndex:7];
            for (NSString *string in array) {
                uuid = [uuid stringByAppendingString:string];
            }
        }
        resultDic = @{
            @"rule":rule,
            @"uuid":uuid
        };
        operationID = mk_lt_taskReadLocationBFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //读取Location过滤规则B - 原始数据
        NSString *rule = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSMutableArray *filterList = [NSMutableArray array];
        if ([rule integerValue] > 0 && content.length > 2) {
            NSInteger subIndex = 2;
            //最多五条过滤数据
            for (NSInteger i = 0; i < 5; i ++) {
                NSInteger index0Len = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(subIndex, 2)];
                NSString *index0Data = [content substringWithRange:NSMakeRange(subIndex + 2, index0Len * 2)];
                
                NSDictionary *index0Dic = @{
                    @"dataType":[index0Data substringWithRange:NSMakeRange(0, 2)],
                    @"minIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(2, 2)],
                    @"maxIndex":[MKBLEBaseSDKAdopter getDecimalStringWithHex:index0Data range:NSMakeRange(4, 2)],
                    @"rawData":[index0Data substringFromIndex:6],
                    @"index":@(i),
                };
                [filterList addObject:index0Dic];
                subIndex += (index0Data.length + 2);
                if (subIndex >= content.length) {
                    break;
                }
            }
        }
        resultDic = @{
            @"rule":rule,
            @"filterList":filterList,
        };
        operationID = mk_lt_taskReadLocationBFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //读取Location过滤规则A - 开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadLocationAFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //读取Location过滤规则B - 开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadLocationBFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //读取Location过滤规则A/B与或逻辑
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLocationLogicalRelationshipOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //读取Location重复数据判定规则
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadLocationFilterRepeatingDataTypeOperation;
    }else if ([cmd isEqualToString:@"71"]) {
        //读取警报和定时上报数据包内容可选项
        NSString *state = [MKBLEBaseSDKAdopter binaryByhex:content];
        BOOL batteryIsOn = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL macIsOn = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL rawIsOn = [[state substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"batteryIsOn":@(batteryIsOn),
            @"macIsOn":@(macIsOn),
            @"rawIsOn":@(rawIsOn)
        };
        operationID = mk_lt_taskReadAlarmOptionalPayloadContentOperation;
    }else if ([cmd isEqualToString:@"72"]) {
        //读取上报的iBeacon设备数量
        resultDic = @{
            @"number":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadReportNumberOfBeaconsOperation;
    }else if ([cmd isEqualToString:@"73"]) {
        //读取三轴采样率
        resultDic = @{
            @"sampleRate":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadAxisSensorSampleRateOperation;
    }else if ([cmd isEqualToString:@"74"]) {
        //读取三轴重力加速度参考值
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadAxisSensorGravitationalaccelerationOperation;
    }else if ([cmd isEqualToString:@"75"]) {
        //读取三轴触发灵敏度
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadAxisSensorTriggerSensitivityOperation;
    }else if ([cmd isEqualToString:@"76"]) {
        //读取三轴功能开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadAxisSensorSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"77"]) {
        //读取三轴数据上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadAxisSensorDataReportIntervalOperation;
    }else if ([cmd isEqualToString:@"78"]) {
        //读取APP监听三轴开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadAxisSensorDataStatusOperation;
    }else if ([cmd isEqualToString:@"7a"]) {
        //读取三轴上报数据包内容可选项
        NSString *state = [MKBLEBaseSDKAdopter binaryByhex:content];
        BOOL macIsOn = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL timestampIsOn = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"timestampIsOn":@(timestampIsOn),
            @"macIsOn":@(macIsOn),
        };
        operationID = mk_lt_taskReadAxisSensorReportDataContentTypeOperation;
    }else if ([cmd isEqualToString:@"7b"]) {
        //读取SOS报警开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadSOSSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"7c"]) {
        //读取SOS数据上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadSOSDataReportIntervalOperation;
    }else if ([cmd isEqualToString:@"7d"]) {
        //读取SOS上报数据包内容可选项
        NSString *state = [MKBLEBaseSDKAdopter binaryByhex:content];
        BOOL timestampIsOn = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL macIsOn = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"timestampIsOn":@(timestampIsOn),
            @"macIsOn":@(macIsOn),
        };
        operationID = mk_lt_taskReadSOSReportDataContentTypeOperation;
    }else if ([cmd isEqualToString:@"7e"]) {
        //读取设备是否包含GPS硬件
        BOOL contain = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"contain":@(contain)
        };
        operationID = mk_lt_taskReadGPSHardwareStatusOperation;
    }else if ([cmd isEqualToString:@"7f"]) {
        //读取GPS开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadGPSSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"80"]) {
        //读取GPS单次搜星时间
        resultDic = @{
            @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadGPSSatellitesSearchTimeOperation;
    }else if ([cmd isEqualToString:@"81"]) {
        //读取GPS上报间隔
        NSInteger interval = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":[NSString stringWithFormat:@"%ld",(long)(interval / 10)],
        };
        operationID = mk_lt_taskReadGPSDataReportIntervalOperation;
    }else if ([cmd isEqualToString:@"82"]) {
        //读取GPS上报数据包内容可选项
        NSString *state = [MKBLEBaseSDKAdopter binaryByhex:content];
        BOOL altitudeIsOn = [[state substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL timestampIsOn = [[state substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL searchModeIsOn = [[state substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        BOOL pdopIsOn = [[state substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
        BOOL numberOfSatellitesIsOn = [[state substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"altitudeIsOn":@(altitudeIsOn),
            @"timestampIsOn":@(timestampIsOn),
            @"searchModeIsOn":@(searchModeIsOn),
            @"pdopIsOn":@(pdopIsOn),
            @"numberOfSatellitesIsOn":@(numberOfSatellitesIsOn)
        };
        operationID = mk_lt_taskReadGPSReportDataContentTypeOperation;
    }else if ([cmd isEqualToString:@"83"]) {
        //读取up link dwell time检测间隔
        resultDic = @{
            @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_lt_taskReadUpLinkeDellTimeOperation;
    }else if ([cmd isEqualToString:@"84"]) {
        //读取LoRaWAN duty cycle
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"85"]) {
        //读取iBeacon数据上报开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_lt_taskReadBeaconReportSwitchStatusOperation;
    }
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_lt_taskOperationID operationID = mk_lt_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    if ([cmd isEqualToString:@"1e"]) {
        //配置设备时间同步间隔
        operationID = mk_lt_taskConfigTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //配置iBeacon的UUID
        operationID = mk_lt_taskConfigBeaconProximityUUIDOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //配置iBeacon的Major
        operationID = mk_lt_taskConfigBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //配置iBeacon的Minor
        operationID = mk_lt_taskConfigBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //配置Measured Power
        operationID = mk_lt_taskConfigMeasuredPowerOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //配置Tx Power
        operationID = mk_lt_taskConfigTxPowerOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //配置广播间隔
        operationID = mk_lt_taskConfigBroadcastIntervalOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //配置广播名称
        operationID = mk_lt_taskConfigDeviceNameOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //配置密码
        operationID = mk_lt_taskConfigPasswordOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //配置设备时间
        operationID = mk_lt_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //配置设备扫描开关与扫描窗口
        operationID = mk_lt_taskConfigScanWindowOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //配置设备蓝牙可连接状态
        operationID = mk_lt_taskConfigConnectableStatusOperation;
    }else if ([cmd isEqualToString:@"2b"]) {
        //modem
        operationID = mk_lt_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"2c"]) {
        //region
        operationID = mk_lt_taskConfigRegionOperation;
    }else if ([cmd isEqualToString:@"2d"]) {
        //devEUI
        operationID = mk_lt_taskConfigDEVEUIOperation;
    }else if ([cmd isEqualToString:@"2e"]) {
        //appEUI
        operationID = mk_lt_taskConfigAPPEUIOperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //appKey
        operationID = mk_lt_taskConfigAPPKEYOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //devAddr
        operationID = mk_lt_taskConfigDEVADDROperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //appSkey
        operationID = mk_lt_taskConfigAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //nwkSkey
        operationID = mk_lt_taskConfigNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //CH
        operationID = mk_lt_taskConfigCHValueOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //DR
        operationID = mk_lt_taskConfigDRValueOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //ADR
        operationID = mk_lt_taskConfigADRStatusOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //message type
        operationID = mk_lt_taskConfigMessageTypeOperation;
    }else if ([cmd isEqualToString:@"38"]) {
        //网络检测间隔
        operationID = mk_lt_taskConfigNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //配置报警RSSI
        operationID = mk_lt_taskConfigAlarmTriggerRSSIOperation;
    }else if ([cmd isEqualToString:@"3a"]) {
        //配置报警提醒类型
        operationID = mk_lt_taskConfigAlarmNotificationTypeOperation;
    }else if ([cmd isEqualToString:@"3b"]) {
        //配置马达震动强度
        operationID = mk_lt_taskConfigVibrationIntensityOperation;
    }else if ([cmd isEqualToString:@"3c"]) {
        //配置马达震动时长
        operationID = mk_lt_taskConfigDurationOfVibrationOperation;
    }else if ([cmd isEqualToString:@"3d"]) {
        //配置马达震动周期
        operationID = mk_lt_taskConfigVibrationCycleOfMotorOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //配置低电量报警电量百分比
        operationID = mk_lt_taskConfigLowPowerPromptOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //扫描数据定时上报间隔
        operationID = mk_lt_taskConfigScanDatasReportIntervalOperation;
    }else if ([cmd isEqualToString:@"43"]) {
        //配置Tracking过滤规则A - RSSI
        operationID = mk_lt_taskConfigTrackingAFilterRssiOperation;
    }else if ([cmd isEqualToString:@"44"]) {
        //配置Tracking过滤规则A - 设备名称
        operationID = mk_lt_taskConfigTrackingAFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //配置Tracking过滤规则A - MAC
        operationID = mk_lt_taskConfigTrackingAFilterMacOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //配置Tracking过滤规则A - Major范围
        operationID = mk_lt_taskConfigTrackingAFilterMajorOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //配置Tracking过滤规则A - Minor范围
        operationID = mk_lt_taskConfigTrackingAFilterMinorOperation;
    }else if ([cmd isEqualToString:@"48"]) {
        //配置Tracking过滤规则A - UUID
        operationID = mk_lt_taskConfigTrackingAFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"49"]) {
        //配置Tracking过滤规则A - raw
        operationID = mk_lt_taskConfigTrackingAFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"4a"]) {
        //配置Tracking过滤规则B - RSSI
        operationID = mk_lt_taskConfigTrackingBFilterRssiOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //配置Tracking过滤规则B - 设备名称
        operationID = mk_lt_taskConfigTrackingBFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //配置Tracking过滤规则B - MAC
        operationID = mk_lt_taskConfigTrackingBFilterMacOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //配置Tracking过滤规则B - Major范围
        operationID = mk_lt_taskConfigTrackingBFilterMajorOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //配置Tracking过滤规则B - Minor范围
        operationID = mk_lt_taskConfigTrackingBFilterMinorOperation;
    }else if ([cmd isEqualToString:@"4f"]) {
        //配置Tracking过滤规则B - UUID
        operationID = mk_lt_taskConfigTrackingBFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"50"]) {
        //配置Tracking过滤规则B - raw
        operationID = mk_lt_taskConfigTrackingBFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //配置Tracking过滤规则A - 开关
        operationID = mk_lt_taskConfigTrackingAFilterStatusOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //配置Tracking过滤规则B - 开关
        operationID = mk_lt_taskConfigTrackingBFilterStatusOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //配置Tracking规则A-B 关系
        operationID = mk_lt_taskConfigTrackingLogicalRelationshipOperation;
    }else if ([cmd isEqualToString:@"54"]) {
        //配置Tracking重复数据判定规则
        operationID = mk_lt_taskConfigTrackingFilterRepeatingDataTypeOperation;
    }else if ([cmd isEqualToString:@"55"]) {
        //配置扫描有效数据筛选间隔
        operationID = mk_lt_taskConfigValidBLEDataFilterIntervalOperation;
    }else if ([cmd isEqualToString:@"56"]) {
        //配置设备信息同步间隔
        operationID = mk_lt_taskConfigDeviceInfoReportIntervalOperation;
    }else if ([cmd isEqualToString:@"58"]) {
        //配置人员聚集报警RSSI
        operationID = mk_lt_taskConfigGatheringWarningRssiOperation;
    }else if ([cmd isEqualToString:@"5c"]) {
        //入网请求
        operationID = mk_lt_taskConfigConnectNetworkOperation;
    }else if ([cmd isEqualToString:@"5d"]) {
        //关机
        operationID = mk_lt_taskConfigDevicePowerOffOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //恢复出厂设置
        operationID = mk_lt_taskConfigDeviceFactoryResetOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //配置Location过滤规则A - RSSI
        operationID = mk_lt_taskConfigLocationAFilterRssiOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //配置Location过滤规则A - 设备名称
        operationID = mk_lt_taskConfigLocationAFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //配置Location过滤规则A - MAC
        operationID = mk_lt_taskConfigLocationAFilterMacOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //配置Location过滤规则A - Major范围
        operationID = mk_lt_taskConfigLocationAFilterMajorOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //配置Location过滤规则A - Minor范围
        operationID = mk_lt_taskConfigLocationAFilterMinorOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //配置Location过滤规则A - UUID
        operationID = mk_lt_taskConfigLocationAFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //配置Location过滤规则A - raw
        operationID = mk_lt_taskConfigLocationAFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //配置Location过滤规则B - RSSI
        operationID = mk_lt_taskConfigLocationBFilterRssiOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //配置Location过滤规则B - 设备名称
        operationID = mk_lt_taskConfigLocationBFilterDeviceNameOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //配置Location过滤规则B - MAC
        operationID = mk_lt_taskConfigLocationBFilterMacOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //配置Location过滤规则B - Major范围
        operationID = mk_lt_taskConfigLocationBFilterMajorOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //配置Location过滤规则B - Minor范围
        operationID = mk_lt_taskConfigLocationBFilterMinorOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //配置Location过滤规则B - UUID
        operationID = mk_lt_taskConfigLocationBFilterUUIDOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //配置Location过滤规则B - raw
        operationID = mk_lt_taskConfigLocationBFilterRawDataOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //配置Location过滤规则A - 开关
        operationID = mk_lt_taskConfigLocationAFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //配置Location过滤规则B - 开关
        operationID = mk_lt_taskConfigLocationBFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //配置Location规则A-B 关系
        operationID = mk_lt_taskConfigLocationLogicalRelationshipOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //配置Location重复数据判定规则
        operationID = mk_lt_taskConfigLocationFilterRepeatingDataTypeOperation;
    }else if ([cmd isEqualToString:@"71"]) {
        //配置警报和定时上报数据包内容可选项
        operationID = mk_lt_taskConfigAlarmOptionalPayloadContentOperation;
    }else if ([cmd isEqualToString:@"72"]) {
        //配置上报iBeacon设备数量
        operationID = mk_lt_taskConfigReportNumberOfBeaconsOperation;
    }else if ([cmd isEqualToString:@"73"]) {
        //配置三轴采样率
        operationID = mk_lt_taskConfigAxisSensorSampleRateOperation;
    }else if ([cmd isEqualToString:@"74"]) {
        //配置三轴重力加速度参考值
        operationID = mk_lt_taskConfigAxisSensorGravitationalaccelerationOperation;
    }else if ([cmd isEqualToString:@"75"]) {
        //配置三轴触发灵敏度
        operationID = mk_lt_taskConfigAxisSensorTriggerSensitivityOperation;
    }else if ([cmd isEqualToString:@"76"]) {
        //配置三轴开关
        operationID = mk_lt_taskConfigAxisSensorSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"77"]) {
        //配置三轴数据上报间隔
        operationID = mk_lt_taskConfigAxisSensorDataReportIntervalOperation;
    }else if ([cmd isEqualToString:@"78"]) {
        //配置app三轴数据监听开关
        operationID = mk_lt_taskConfigAxisSensorDataStatusOperation;
    }else if ([cmd isEqualToString:@"7a"]) {
        //配置三轴上报数据包内容可选项
        operationID = mk_lt_taskConfigAxisSensorReportDataContentTypeOperation;
    }else if ([cmd isEqualToString:@"7b"]) {
        //配置SOS报警开关状态
        operationID = mk_lt_taskConfigSOSSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"7c"]) {
        //配置SOS报警信息上报间隔
        operationID = mk_lt_taskConfigSOSDataReportIntervalOperation;
    }else if ([cmd isEqualToString:@"7d"]) {
        //配置SOS上报数据包内容可选项
        operationID = mk_lt_taskConfigSOSReportDataContentTypeOperation;
    }else if ([cmd isEqualToString:@"7f"]) {
        //配置GPS开关状态
        operationID = mk_lt_taskConfigGPSSwitchStatusOperation;
    }else if ([cmd isEqualToString:@"80"]) {
        //配置GPS单次搜星时间
        operationID = mk_lt_taskConfigGPSSatellitesSearchTimeOperation;
    }else if ([cmd isEqualToString:@"81"]) {
        //配置GPS上报间隔
        operationID = mk_lt_taskConfigGPSDataReportIntervalOperation;
    }else if ([cmd isEqualToString:@"82"]) {
        //配置GPS上报数据包内容可选项
        operationID = mk_lt_taskConfigGPSReportDataContentTypeOperation;
    }else if ([cmd isEqualToString:@"83"]) {
        //配置up link dell time
        operationID = mk_lt_taskConfigUpLinkeDellTimeOperation;
    }else if ([cmd isEqualToString:@"84"]) {
        //配置duty cycle
        operationID = mk_lt_taskConfigDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"85"]) {
        //配置iBeacon数据上报开关状态
        operationID = mk_lt_taskConfigBeaconReportSwitchStatusOperation;
    }
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_lt_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

+ (NSString *)fetchTxPower:(NSString *)content {
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"03"]) {
        return @"3dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"f4"]) {
        return @"-12dBm";
    }
    if ([content isEqualToString:@"f0"]) {
        return @"-16dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"-4dBm";
}

@end
