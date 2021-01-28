//
//  CBPeripheral+MKLTAdd.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKLTAdd.h"

#import <objc/runtime.h>

static const char *lt_batteryPowerKey = "lt_batteryPowerKey";
static const char *lt_manufacturerKey = "lt_manufacturerKey";
static const char *lt_deviceModelKey = "lt_deviceModelKey";
static const char *lt_hardwareKey = "lt_hardwareKey";
static const char *lt_softwareKey = "lt_softwareKey";
static const char *lt_firmwareKey = "lt_firmwareKey";

static const char *lt_passwordKey = "lt_passwordKey";
static const char *lt_disconnectTypeKey = "lt_disconnectTypeKey";
static const char *lt_customKey = "lt_customKey";
static const char *lt_gpsDataKey = "lt_gpsDataKey";

static const char *lt_passwordNotifySuccessKey = "lt_passwordNotifySuccessKey";
static const char *lt_disconnectTypeNotifySuccessKey = "lt_disconnectTypeNotifySuccessKey";
static const char *lt_customNotifySuccessKey = "lt_customNotifySuccessKey";
static const char *lt_gpsDataNotifySuccessKey = "lt_gpsDataNotifySuccessKey";

@implementation CBPeripheral (MKLTAdd)

- (void)lt_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180F"]]) {
        //电池电量
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
                objc_setAssociatedObject(self, &lt_batteryPowerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &lt_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &lt_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &lt_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &lt_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &lt_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &lt_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &lt_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &lt_gpsDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &lt_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
        return;
    }
}

- (void)lt_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &lt_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &lt_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &lt_gpsDataNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
        objc_setAssociatedObject(self, &lt_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)lt_connectSuccess {
    if (![objc_getAssociatedObject(self, &lt_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &lt_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &lt_disconnectTypeNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &lt_gpsDataNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.lt_batteryPower || !self.lt_manufacturer || !self.lt_deviceModel || !self.lt_hardware || !self.lt_sofeware || !self.lt_firmware) {
        return NO;
    }
    if (!self.lt_password || !self.lt_disconnectType || !self.lt_custom || !self.lt_gpsData) {
        return NO;
    }
    return YES;
}

- (void)lt_setNil {
    objc_setAssociatedObject(self, &lt_batteryPowerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &lt_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_gpsDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &lt_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lt_gpsDataNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)lt_batteryPower {
    return objc_getAssociatedObject(self, &lt_batteryPowerKey);
}

- (CBCharacteristic *)lt_manufacturer {
    return objc_getAssociatedObject(self, &lt_manufacturerKey);
}

- (CBCharacteristic *)lt_deviceModel {
    return objc_getAssociatedObject(self, &lt_deviceModelKey);
}

- (CBCharacteristic *)lt_hardware {
    return objc_getAssociatedObject(self, &lt_hardwareKey);
}

- (CBCharacteristic *)lt_sofeware {
    return objc_getAssociatedObject(self, &lt_softwareKey);
}

- (CBCharacteristic *)lt_firmware {
    return objc_getAssociatedObject(self, &lt_firmwareKey);
}

- (CBCharacteristic *)lt_password {
    return objc_getAssociatedObject(self, &lt_passwordKey);
}

- (CBCharacteristic *)lt_disconnectType {
    return objc_getAssociatedObject(self, &lt_disconnectTypeKey);
}

- (CBCharacteristic *)lt_custom {
    return objc_getAssociatedObject(self, &lt_customKey);
}

- (CBCharacteristic *)lt_gpsData {
    return objc_getAssociatedObject(self, &lt_gpsDataKey);
}

@end
