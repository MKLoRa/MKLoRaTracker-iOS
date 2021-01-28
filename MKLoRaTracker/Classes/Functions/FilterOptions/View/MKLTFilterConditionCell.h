//
//  MKLTFilterConditionCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTFilterConditionCellModel : NSObject

@property (nonatomic, assign)NSInteger conditionIndex;

/// 当前按钮是否可用
@property (nonatomic, assign)BOOL enable;

/// 点击button显示的选择列表
@property (nonatomic, strong)NSArray *dataList;

/// 左侧msg
@property (nonatomic, copy)NSString *leftMsg;

/// 右侧msg
@property (nonatomic, copy)NSString *rightMsg;

@end

@protocol MKLTFilterConditionCellDelegate <NSObject>

/// 关于发生改变
/// @param conditionIndex 当前选择的列表中的index
- (void)mk_filterConditionsChanged:(NSInteger)conditionIndex;

@end

@interface MKLTFilterConditionCell : MKBaseCell

@property (nonatomic, strong)MKLTFilterConditionCellModel *dataModel;

@property (nonatomic, weak)id <MKLTFilterConditionCellDelegate>delegate;

+ (MKLTFilterConditionCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
