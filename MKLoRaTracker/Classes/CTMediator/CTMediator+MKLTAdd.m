//
//  CTMediator+MKLTAdd.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "CTMediator+MKLTAdd.h"

#import "MKMacroDefines.h"

#import "MKLoRaWANLTModuleKey.h"

@implementation CTMediator (MKLTAdd)

- (UIViewController *)CTMediator_LORAWAN_LT_AboutPage {
    UIViewController *viewController = [self performTarget:kTarget_loRaApp_la_module
                                                    action:kAction_loRaApp_la_aboutPage
                                                    params:@{}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    return [self performTarget:kTarget_loRaApp_lt_module
                        action:kAction_loRaApp_lt_aboutPage
                        params:@{}
             shouldCacheTarget:NO];
}

#pragma mark - private method
- (UIViewController *)Action_LoRaApp_ViewControllerWithTarget:(NSString *)targetName
                                                       action:(NSString *)actionName
                                                       params:(NSDictionary *)params{
    UIViewController *viewController = [self performTarget:targetName
                                                    action:actionName
                                                    params:params
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

@end
