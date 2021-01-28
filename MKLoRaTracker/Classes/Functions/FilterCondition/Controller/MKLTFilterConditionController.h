//
//  MKLTFilterConditionController.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lt_conditionType) {
    mk_lt_trackingConditionA,
    mk_lt_trackingConditionB,
    mk_lt_locationConditionA,
    mk_lt_locationConditionB,
};

@interface MKLTFilterConditionController : MKBaseViewController

@property (nonatomic, assign)mk_lt_conditionType conditionType;

@end

NS_ASSUME_NONNULL_END
