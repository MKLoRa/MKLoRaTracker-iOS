//
//  MKLTGPSReportIntervalCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/3/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTGPSReportIntervalCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

@implementation MKLTGPSReportIntervalCellModel
@end

@interface MKLTGPSReportIntervalCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *intervalButton;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKLTGPSReportIntervalCell

+ (MKLTGPSReportIntervalCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTGPSReportIntervalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTGPSReportIntervalCellIdenty"];
    if (!cell) {
        cell = [[MKLTGPSReportIntervalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTGPSReportIntervalCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.intervalButton];
        [self loadDataList];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.intervalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.intervalButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)intervalButtonPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
    NSInteger index = 0;
    if (self.dataModel.nonAlarmReportInterval > 0) {
        for (NSInteger i = 0; i < self.dataList.count; i ++) {
            NSInteger tempValue = [self.dataList[i] integerValue] * self.dataModel.nonAlarmReportInterval;
            NSInteger currentValue = [self.intervalButton.titleLabel.text integerValue];
            if (tempValue == currentValue) {
                index = i;
                break;
            }
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = self.dataList;
    [pickView showPickViewWithIndex:index block:^(NSInteger currentRow) {
        NSInteger tempValue = [self.dataList[currentRow] integerValue] * self.dataModel.nonAlarmReportInterval;
        NSString *titleValue = [NSString stringWithFormat:@"%ld",(long)tempValue];
        [self.intervalButton setTitle:titleValue forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mk_lt_gpsReportIntervalChanged:)]) {
            [self.delegate mk_lt_gpsReportIntervalChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKLTGPSReportIntervalCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    NSString *title = [NSString stringWithFormat:@"%ld",(long)([self.dataList[_dataModel.gpsReportIntervalIndex] integerValue] * _dataModel.nonAlarmReportInterval)];
    [self.intervalButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - private method
- (void)loadDataList {
    for (NSInteger i = 1; i < 21; i ++) {
        NSString *string = [NSString stringWithFormat:@"%ld",(long)i * 10];
        [self.dataList addObject:string];
    }
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"GPS Payload Report Interval";
    }
    return _msgLabel;
}

- (UIButton *)intervalButton {
    if (!_intervalButton) {
        _intervalButton = [MKCustomUIAdopter customButtonWithTitle:@"10"
                                                        titleColor:COLOR_WHITE_MACROS
                                                   backgroundColor:NAVBAR_COLOR_MACROS
                                                            target:self
                                                            action:@selector(intervalButtonPressed)];
    }
    return _intervalButton;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
