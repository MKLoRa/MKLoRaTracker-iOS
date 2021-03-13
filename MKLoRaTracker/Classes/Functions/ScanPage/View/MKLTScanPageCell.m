//
//  MKLTScanPageCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/20.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTScanPageCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKLTScanPageModel.h"

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 25.f;
static CGFloat const batteryIconHeight = 25.f;
static CGFloat const valueLabelWidth = 110.f;

#pragma mark - cell顶部视图

@interface MKLTScanPageCellTopView : UIView

@property (nonatomic, strong)UIImageView *rssiIcon;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UIButton *connectButton;

@end

@implementation MKLTScanPageCellTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:COLOR_WHITE_MACROS];
        [self addSubview:self.rssiIcon];
        [self addSubview:self.rssiLabel];
        [self addSubview:self.deviceNameLabel];
        [self addSubview:self.macLabel];
        [self addSubview:self.connectButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(10.f);
        make.width.mas_equalTo(rssiIconWidth);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(connectButtonWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(connectButtonHeight);
    }];
    CGFloat nameWidth = (kViewWidth - 2 * offset_X - rssiIconWidth - 10.f - 8.f - connectButtonWidth);
    CGSize nameSize = [NSString sizeWithText:self.deviceNameLabel.text
                                     andFont:self.deviceNameLabel.font
                                  andMaxSize:CGSizeMake(nameWidth, MAXFLOAT)];
    [self.deviceNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(15.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-8.f);
        make.height.mas_equalTo(nameSize.height);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_left);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.deviceNameLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
}

#pragma mark - getter
- (UIImageView *)rssiIcon {
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADICON(@"MKLoRaTracker", @"MKLTScanPageCell", @"lt_scan_signalIcon.png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
        _rssiLabel.font = MKFont(10.f);
    }
    return _rssiLabel;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    return _deviceNameLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] init];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.font = MKFont(12.f);
        _macLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _macLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
    }
    return _connectButton;
}

@end

#pragma mark - cell底部视图

@interface MKLTScanPageCellBottomView : UIView

@property (nonatomic, strong)UIImageView *batteryIcon;

@property (nonatomic, strong)UILabel *batteryLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *trackLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UILabel *majorLabel;

@property (nonatomic, strong)UILabel *minorLabel;

@property (nonatomic, strong)UILabel *rssi1mLabel;

@property (nonatomic, strong)UILabel *proximityLabel;

@end

@implementation MKLTScanPageCellBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:COLOR_WHITE_MACROS];
        [self addSubview:self.batteryIcon];
        [self addSubview:self.batteryLabel];
        [self addSubview:self.txPowerLabel];
        [self addSubview:self.trackLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.majorLabel];
        [self addSubview:self.minorLabel];
        [self addSubview:self.rssi1mLabel];
        [self addSubview:self.proximityLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.batteryIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.width.mas_equalTo(batteryIconWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.batteryIcon.mas_centerX);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.batteryIcon.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(valueLabelWidth);
        make.centerY.mas_equalTo(self.batteryIcon.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.trackLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.trackLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.majorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.minorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.majorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.rssi1mLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.minorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.proximityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.rssi1mLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter

- (UIImageView *)batteryIcon {
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADICON(@"MKLoRaTracker", @"MKLTScanPageCell", @"lt_scan_batteryIcon.png");
    }
    return _batteryIcon;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [self createLabelWithFont:MKFont(10.f)];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _txPowerLabel;
}

- (UILabel *)trackLabel {
    if (!_trackLabel) {
        _trackLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _trackLabel;
}

- (UILabel *)majorLabel {
    if (!_majorLabel) {
        _majorLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _majorLabel;
}

- (UILabel *)minorLabel {
    if (!_minorLabel) {
        _minorLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _minorLabel;
}

- (UILabel *)rssi1mLabel {
    if (!_rssi1mLabel) {
        _rssi1mLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _rssi1mLabel;
}

- (UILabel *)proximityLabel {
    if (!_proximityLabel) {
        _proximityLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _proximityLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = DEFAULT_TEXT_COLOR;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = MKFont(12.f);
        _timeLabel.text = @"N/A";
    }
    return _timeLabel;
}

- (UILabel *)createLabelWithFont:(UIFont *)font {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = font;
    return msgLabel;
}

@end


@interface MKLTScanPageCell ()

@property (nonatomic, strong)MKLTScanPageCellTopView *topView;

@property (nonatomic, strong)MKLTScanPageCellBottomView *bottomView;

@end

@implementation MKLTScanPageCell

+ (MKLTScanPageCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTScanPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTScanPageCellIdenty"];
    if (!cell) {
        cell = [[MKLTScanPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTScanPageCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.topView];
        [self.contentView addSubview:self.bottomView];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50.f);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(80.f);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed {
    if ([self.delegate respondsToSelector:@selector(lt_scanCellConnectButtonPressed:)]) {
        [self.delegate lt_scanCellConnectButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter

- (void)setDataModel:(MKLTScanPageModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    //顶部
    self.topView.rssiLabel.text = [NSString stringWithFormat:@"%lddBm",(long)dataModel.rssi];
    self.topView.deviceNameLabel.text = (ValidStr(dataModel.deviceName) ? dataModel.deviceName : @"N/A");
    self.topView.macLabel.text = [@"MAC: " stringByAppendingString:(ValidStr(dataModel.macAddress) ? dataModel.macAddress : @"N/A")];
    self.topView.connectButton.hidden = !dataModel.connectable;
    //底部
    self.bottomView.txPowerLabel.text = [NSString stringWithFormat:@"%@ %lddBm",@"Tx Power:",(long)dataModel.txPower];
    self.bottomView.trackLabel.text = (dataModel.track ? @"Track: ON" : @"Track: OFF");
    self.bottomView.batteryLabel.text = [NSString stringWithFormat:@"%ld%@",(long)dataModel.batteryPercentage,@"%"];
    self.bottomView.majorLabel.text = [NSString stringWithFormat:@"Major:                  %ld",(long)dataModel.major];
    self.bottomView.minorLabel.text = [NSString stringWithFormat:@"Minor:                  %ld",(long)dataModel.minor];
    self.bottomView.rssi1mLabel.text = [NSString stringWithFormat:@"RSSI@1m:           %lddBm",(long)dataModel.rssi1m];
    self.bottomView.proximityLabel.text = [NSString stringWithFormat:@"Proximity:           %@",dataModel.proximity];
    self.bottomView.timeLabel.text = dataModel.scanTime;
}

#pragma mark - getter
- (MKLTScanPageCellTopView *)topView {
    if (!_topView) {
        _topView = [[MKLTScanPageCellTopView alloc] init];
        [_topView.connectButton addTarget:self action:@selector(connectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (MKLTScanPageCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MKLTScanPageCellBottomView alloc] init];
    }
    return _bottomView;
}

@end
