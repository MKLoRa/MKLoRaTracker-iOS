//
//  MKLTFirmwareCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTFirmwareCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *rightMsg;

@end

@protocol MKLTFirmwareCellDelegate <NSObject>

- (void)mk_firmwareButtonMethod;

@end

@interface MKLTFirmwareCell : MKBaseCell

@property (nonatomic, strong)MKLTFirmwareCellModel *dataModel;

@property (nonatomic, weak)id <MKLTFirmwareCellDelegate>delegate;

+ (MKLTFirmwareCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
