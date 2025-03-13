//
//  MKHudManager.m
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKHudManager.h"
#import "SVProgressHUD.h"
#import "MKMacroDefines.h"

@interface MKHudManager (){
    __weak UIView *_inView;
}

@end

@implementation MKHudManager

+ (instancetype)share{
    static dispatch_once_t t;
    static MKHudManager *manager = nil;
    dispatch_once(&t, ^{
        manager = [[MKHudManager alloc] init];
        // 初始化 SVProgressHUD 配置
        [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat]; // 动画类型
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    });
    return manager;
}

- (void)showHUDWithTitle:(NSString *)title
                  inView:(UIView *)inView
           isPenetration:(BOOL)isPenetration{
    // 设置遮罩类型
    SVProgressHUDMaskType maskType = isPenetration ? SVProgressHUDMaskTypeNone : SVProgressHUDMaskTypeBlack;
    [SVProgressHUD setDefaultMaskType:maskType];
    // 显示 HUD
    if (title.length > 0) {
        [SVProgressHUD showWithStatus:title];
    } else {
        [SVProgressHUD show];
    }
}

-(void)hide{
    [SVProgressHUD dismiss];
}

- (void)hideAfterDelay:(NSTimeInterval)delay{
    [SVProgressHUD dismissWithDelay:delay];
}

@end
