//
//  MKLTAxisSensorCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTAxisSensorCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const axisLabelWidth = 85.f;
static CGFloat const axisDataLabelWidth = 85.f;

@implementation MKLTAxisSensorCellModel
@end

@interface MKLTAxisSensorCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UIView *dataView;

@property (nonatomic, strong)UILabel *xAxisLabel;

@property (nonatomic, strong)UILabel *xAxisDataLabel;

@property (nonatomic, strong)UILabel *yAxisLabel;

@property (nonatomic, strong)UILabel *yAxisDataLabel;

@property (nonatomic, strong)UILabel *zAxisLabel;

@property (nonatomic, strong)UILabel *zAxisDataLabel;

@end

@implementation MKLTAxisSensorCell

+ (MKLTAxisSensorCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTAxisSensorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTAxisSensorCellIdenty"];
    if (!cell) {
        cell = [[MKLTAxisSensorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTAxisSensorCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchButton];
        [self.contentView addSubview:self.dataView];
        [self.dataView addSubview:self.xAxisLabel];
        [self.dataView addSubview:self.xAxisDataLabel];
        [self.dataView addSubview:self.yAxisLabel];
        [self.dataView addSubview:self.yAxisDataLabel];
        [self.dataView addSubview:self.zAxisLabel];
        [self.dataView addSubview:self.zAxisDataLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        if (self.switchButton.selected) {
            //开关打开
            make.top.mas_equalTo(15.f);
        }else {
            //开关关闭
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    if (!self.switchButton.selected) {
        //隐藏底部
        return;
    }
    [self.dataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.right.mas_equalTo(-30.f);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    [self.xAxisLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(axisLabelWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.xAxisDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(axisDataLabelWidth);
        make.centerY.mas_equalTo(self.xAxisLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.yAxisLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(axisLabelWidth);
        make.top.mas_equalTo(self.xAxisLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.yAxisDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(axisDataLabelWidth);
        make.centerY.mas_equalTo(self.yAxisLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.zAxisLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(axisLabelWidth);
        make.top.mas_equalTo(self.yAxisLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.zAxisDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(axisDataLabelWidth);
        make.centerY.mas_equalTo(self.zAxisLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *image = (_dataModel.selected ? LOADICON(@"MKLoRaTracker", @"MKLTAxisSensorCell", @"lt_switchSelectedIcon.png") : LOADICON(@"MKLoRaTracker", @"MKLTAxisSensorCell", @"lt_switchUnselectedIcon.png"));
    [self.switchButton setImage:image forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(mk_axisSensorDataSwitchChanged:)]) {
        [self.delegate mk_axisSensorDataSwitchChanged:self.switchButton.selected];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKLTAxisSensorCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;;
    }
    if (self.switchButton.superview) {
        [self.switchButton removeFromSuperview];
    }
    [self.contentView addSubview:self.switchButton];
    self.switchButton.selected = _dataModel.selected;
    UIImage *image = (_dataModel.selected ? LOADICON(@"MKLoRaTracker", @"MKLTAxisSensorCell", @"lt_switchSelectedIcon.png") : LOADICON(@"MKLoRaTracker", @"MKLTAxisSensorCell", @"lt_switchUnselectedIcon.png"));
    [self.switchButton setImage:image forState:UIControlStateNormal];
    self.dataView.hidden = !_dataModel.selected;
    if (_dataModel.selected) {
        self.xAxisDataLabel.text = SafeStr(_dataModel.xAxisSensorData);
        self.yAxisDataLabel.text = SafeStr(_dataModel.yAxisSensorData);
        self.zAxisDataLabel.text = SafeStr(_dataModel.zAxisSensorData);
    }
    [self setNeedsLayout];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Sensor Data";
    }
    return _msgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTAxisSensorCell", @"lt_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = [[UIView alloc] init];
        _dataView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _dataView;
}

- (UILabel *)xAxisLabel {
    if (!_xAxisLabel) {
        _xAxisLabel = [[UILabel alloc] init];
        _xAxisLabel.textColor = DEFAULT_TEXT_COLOR;
        _xAxisLabel.textAlignment = NSTextAlignmentLeft;
        _xAxisLabel.font = MKFont(13.f);
        _xAxisLabel.text = @"X-Axis";
    }
    return _xAxisLabel;
}

- (UILabel *)xAxisDataLabel {
    if (!_xAxisDataLabel) {
        _xAxisDataLabel = [[UILabel alloc] init];
        _xAxisDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _xAxisDataLabel.textAlignment = NSTextAlignmentCenter;
        _xAxisDataLabel.font = MKFont(13.f);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_xAxisDataLabel addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _xAxisDataLabel;
}

- (UILabel *)yAxisLabel {
    if (!_yAxisLabel) {
        _yAxisLabel = [[UILabel alloc] init];
        _yAxisLabel.textColor = DEFAULT_TEXT_COLOR;
        _yAxisLabel.textAlignment = NSTextAlignmentLeft;
        _yAxisLabel.font = MKFont(13.f);
        _yAxisLabel.text = @"Y-Axis";
    }
    return _yAxisLabel;
}

- (UILabel *)yAxisDataLabel {
    if (!_yAxisDataLabel) {
        _yAxisDataLabel = [[UILabel alloc] init];
        _yAxisDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _yAxisDataLabel.textAlignment = NSTextAlignmentCenter;
        _yAxisDataLabel.font = MKFont(13.f);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_yAxisDataLabel addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _yAxisDataLabel;
}

- (UILabel *)zAxisLabel {
    if (!_zAxisLabel) {
        _zAxisLabel = [[UILabel alloc] init];
        _zAxisLabel.textColor = DEFAULT_TEXT_COLOR;
        _zAxisLabel.textAlignment = NSTextAlignmentLeft;
        _zAxisLabel.font = MKFont(13.f);
        _zAxisLabel.text = @"Z-Axis";
    }
    return _zAxisLabel;
}

- (UILabel *)zAxisDataLabel {
    if (!_zAxisDataLabel) {
        _zAxisDataLabel = [[UILabel alloc] init];
        _zAxisDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _zAxisDataLabel.textAlignment = NSTextAlignmentCenter;
        _zAxisDataLabel.font = MKFont(13.f);
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_zAxisDataLabel addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _zAxisDataLabel;
}

@end
