//
//  MKLTGatheringWarningCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTGatheringWarningCellModel : NSObject

/// 当前Gathering Warning Rssi
@property (nonatomic, assign)NSInteger gatheringWarningRssi;

/// 当前Alarm Trigger RSSI
@property (nonatomic, assign)NSInteger triggerRssi;

@end

@protocol MKLTGatheringWarningCellDelegate <NSObject>

- (void)mk_gatheringWarningRssiValueChanged:(NSInteger)rssi;

@end

@interface MKLTGatheringWarningCell : MKBaseCell

@property (nonatomic, strong)MKLTGatheringWarningCellModel *dataModel;

@property (nonatomic, weak)id <MKLTGatheringWarningCellDelegate>delegate;

+ (MKLTGatheringWarningCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
