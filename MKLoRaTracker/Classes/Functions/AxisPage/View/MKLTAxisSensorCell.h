//
//  MKLTAxisSensorCell.h
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLTAxisSensorCellModel : NSObject

/// 开关是否打开
@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *xAxisSensorData;

@property (nonatomic, copy)NSString *yAxisSensorData;

@property (nonatomic, copy)NSString *zAxisSensorData;

@end

@protocol MKLTAxisSensorCellDelegate <NSObject>

- (void)mk_axisSensorDataSwitchChanged:(BOOL)isOn;

@end

@interface MKLTAxisSensorCell : MKBaseCell

@property (nonatomic, strong)MKLTAxisSensorCellModel *dataModel;

@property (nonatomic, weak)id <MKLTAxisSensorCellDelegate>delegate;

+ (MKLTAxisSensorCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
