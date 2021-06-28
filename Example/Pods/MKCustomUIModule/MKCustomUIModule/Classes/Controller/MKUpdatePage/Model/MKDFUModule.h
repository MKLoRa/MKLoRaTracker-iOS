//
//  MKDFUModule.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/6/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN
 
@interface MKDFUModule : NSObject

- (void)updateWithPeripheral:(CBPeripheral *)peripheral
                     fileUrl:(NSString *)url
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
