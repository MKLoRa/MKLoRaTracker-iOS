//
//  MKLTScanWindowView.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/28.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_lt_scanWindowViewType) {
    mk_lt_scanWindowViewTypeClose,            //close.
    mk_lt_scanWindowViewTypeOpen,             //open.
    mk_lt_scanWindowViewTypeHalfOpen,         //Open in half time.
    mk_lt_scanWindowViewTypeQuarterOpen,      //Open a quarter of the time.
    mk_lt_scanWindowViewTypeOneEighthOpen,    //Open in one eighth time.
};

@interface MKLTScanWindowView : UIView

- (void)showViewWithValue:(mk_lt_scanWindowViewType)type completeBlock:(void (^)(mk_lt_scanWindowViewType resultType))block;

@end

NS_ASSUME_NONNULL_END
