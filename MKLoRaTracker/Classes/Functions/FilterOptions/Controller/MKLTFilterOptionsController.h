//
//  MKLTFilterOptionsController.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_filterOptionsPageType) {
    mk_filterOptionsTrackingPageType,
    mk_filterOptionsPageLocationType,
};

@interface MKLTFilterOptionsController : MKBaseViewController

@property (nonatomic, assign)mk_filterOptionsPageType *pageType;

@end

NS_ASSUME_NONNULL_END
