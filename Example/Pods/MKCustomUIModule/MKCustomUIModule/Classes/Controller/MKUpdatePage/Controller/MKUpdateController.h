//
//  MKUpdateController.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/6/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKUpdateControllerDelegate <NSObject>

/// 开始DFU升级
- (void)mk_updatePage_dfuStart;

/// 升级进度
/// @param progress progress
- (void)mk_updatePage_dfuProgress:(CGFloat)progress;

/// DFU升级成功
- (void)mk_updatePage_dfuSuccess;

/// DFU升级失败
/// @param error 失败error
- (void)mk_updatePage_dfuFailed:(NSError *)error;

@end

@interface MKUpdateController : MKBaseViewController

@property (nonatomic, weak)id <MKUpdateControllerDelegate>delegate;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

@end

NS_ASSUME_NONNULL_END
