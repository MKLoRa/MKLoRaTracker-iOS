//
//  Target_LoRaWANLT_Module.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/28.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "Target_LoRaWANLT_Module.h"

#import "MKLTScanController.h"

@implementation Target_LoRaWANLT_Module

/// 扫描页面
- (UIViewController *)Action_LoRaWANLT_Module_ScanController:(NSDictionary *)params {
    return [[MKLTScanController alloc] init];
}

@end
