//
//  Target_LoRaWANLT_Module.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/28.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_LoRaWANLT_Module : NSObject

/// 扫描页面
- (UIViewController *)Action_LoRaWANLT_Module_ScanController:(NSDictionary *)params;

/// 关于页面
- (UIViewController *)Action_LoRaWANLT_Module_AboutController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
