//
//  MKLTNormalTextCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTNormalTextCellModel : NSObject

/// 左侧msg
@property (nonatomic, copy)NSString *leftMsg;

/// 右侧msg
@property (nonatomic, copy)NSString *rightMsg;

@end

@interface MKLTNormalTextCell : MKBaseCell

@property (nonatomic, strong)MKLTNormalTextCellModel *dataModel;

+ (MKLTNormalTextCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
