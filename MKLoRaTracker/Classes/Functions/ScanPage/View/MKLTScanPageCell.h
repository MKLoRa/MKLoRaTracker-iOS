//
//  MKLTScanPageCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKLTScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)lt_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKLTScanPageModel;
@interface MKLTScanPageCell : MKBaseCell

@property (nonatomic, strong)MKLTScanPageModel *dataModel;

@property (nonatomic, weak)id <MKLTScanPageCellDelegate>delegate;

+ (MKLTScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
