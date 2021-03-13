//
//  MKLTGPSReportIntervalCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/3/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTGPSReportIntervalCellModel : NSObject

/// 0~19，对应dataList里面的数据
@property (nonatomic, assign)NSInteger gpsReportIntervalIndex;

@property (nonatomic, assign)NSInteger nonAlarmReportInterval;

@end

@protocol MKLTGPSReportIntervalCellDelegate <NSObject>

- (void)mk_lt_gpsReportIntervalChanged:(NSInteger)index;

@end

@interface MKLTGPSReportIntervalCell : MKBaseCell

@property (nonatomic, strong)MKLTGPSReportIntervalCellModel *dataModel;

@property (nonatomic, weak)id <MKLTGPSReportIntervalCellDelegate>delegate;

+ (MKLTGPSReportIntervalCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
