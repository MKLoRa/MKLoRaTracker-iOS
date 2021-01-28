//
//  MKLTScanWindowView.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/28.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTScanWindowView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static NSString *const titleMsg = @"Scan Window";
static NSString *const alertMsg = @"The setting of the scanning window represents the proportion of the scanning time. If you set to 0, the device will stop scanning.";

static CGFloat const sliderHeight = 20.f;
static CGFloat const buttonHeight = 55.f;
static CGFloat const offset_Y = 15.f;
static CGFloat const offset_X = 15.f;
static CGFloat const maxLabelHeight = 15.f;

@interface MKLTTriggerSenSlider : UISlider

@end

@implementation MKLTTriggerSenSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setThumbImage:[LOADICON(@"MKLoRaTracker", @"MKLTTriggerSenSlider", @"mk_lt_sensitivityThumbIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateNormal];
        [self setThumbImage:[LOADICON(@"MKLoRaTracker", @"MKLTTriggerSenSlider", @"mk_lt_sensitivityThumbIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[LOADICON(@"MKLoRaTracker", @"MKLTTriggerSenSlider", @"mk_lt_sensitivityMinTrackIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                          forState:UIControlStateNormal];
        [self setMaximumTrackImage:[LOADICON(@"MKLoRaTracker", @"MKLTTriggerSenSlider", @"mk_lt_sensitivityMaxTrackIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    }
    return self;
}

@end

@interface MKLTScanWindowView ()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleMsgLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *maxLabel;

@property (nonatomic, strong)UILabel *minLabel;

@property (nonatomic, strong)MKLTTriggerSenSlider *slider;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, strong)UIView *lineView1;

@property (nonatomic, strong)UIView *lineView2;

@property (nonatomic, copy)void (^valueConfirmBlock)(NSInteger resultValue);

@property (nonatomic, assign)mk_lt_scanWindowViewType currentType;

@end

@implementation MKLTScanWindowView

- (void)dealloc {
    NSLog(@"MKLTScanWindowView销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleMsgLabel];
        [self.alertView addSubview:self.msgLabel];
        [self.alertView addSubview:self.maxLabel];
        [self.alertView addSubview:self.minLabel];
        [self.alertView addSubview:self.slider];
        [self.alertView addSubview:self.valueLabel];
        [self.alertView addSubview:self.lineView1];
        [self.alertView addSubview:self.lineView2];
        [self.alertView addSubview:self.cancelButton];
        [self.alertView addSubview:self.confirmButton];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:@"mk_customUIModule_dismissPickView"
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize titleSize = [NSString sizeWithText:self.titleMsgLabel.text
                                      andFont:self.titleMsgLabel.font
                                   andMaxSize:CGSizeMake(kViewWidth - 4 * offset_X, MAXFLOAT)];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(kViewWidth - 4 * offset_X, MAXFLOAT)];
    CGFloat alertHeight = 4 * offset_Y + titleSize.height + msgSize.height + maxLabelHeight + sliderHeight + CUTTING_LINE_HEIGHT + buttonHeight + 15.f;
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(alertHeight);
    }];
    [self.titleMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.titleMsgLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(msgSize.height);
    }];
    [self.maxLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(80.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(maxLabelHeight);
    }];
    [self.minLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.maxLabel.mas_centerY);
        make.height.mas_equalTo(maxLabelHeight);
    }];
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.maxLabel.mas_bottom);
        make.height.mas_equalTo(sliderHeight);
    }];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.slider.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.lineView1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.valueLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.lineView2.mas_left);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.lineView2.mas_right);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.lineView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.width.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.top.mas_equalTo(self.lineView1.mas_bottom);
        make.height.mas_equalTo(buttonHeight);
    }];
}

#pragma mark - event Method

/**
 取消选择
 */
- (void)cancelButtonPressed {
    [self dismiss];
}

/**
 确认选择
 */
- (void)confirmButtonPressed {
    if (self.valueConfirmBlock) {
        self.valueConfirmBlock(self.currentType);
    }
    [self dismiss];
}

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)sliderValueChanged {
    [self updateSliderValue];
}

#pragma mark - public method
- (void)showViewWithValue:(mk_lt_scanWindowViewType)type completeBlock:(void (^)(mk_lt_scanWindowViewType resultType))block {
    [kAppWindow addSubview:self];
    self.valueConfirmBlock = block;
    self.slider.value = [self fetchSliderValueWithScanType:type];
    [self updateSliderValue];
}

#pragma mark - private method
- (void)updateSliderValue {
    NSString *value = [NSString stringWithFormat:@"%.f",self.slider.value];
    if ([value integerValue] == 0) {
        self.currentType = mk_lt_scanWindowViewTypeHalfOpen;
        self.valueLabel.text = @"1/2";
        return;
    }
    if ([value integerValue] == 1) {
        self.valueLabel.text = @"1/4";
        self.currentType = mk_lt_scanWindowViewTypeQuarterOpen;
        return;
    }
    if ([value integerValue] == 2) {
        self.valueLabel.text = @"1/8";
        self.currentType = mk_lt_scanWindowViewTypeOneEighthOpen;
        return;
    }
    if ([value integerValue] == 3) {
        self.valueLabel.text = @"0";
        self.currentType = mk_lt_scanWindowViewTypeClose;
    }
}

- (NSInteger)fetchSliderValueWithScanType:(mk_lt_scanWindowViewType)scanType {
    if (scanType == mk_lt_scanWindowViewTypeClose) {
        return 3;
    }
    if (scanType == mk_lt_scanWindowViewTypeHalfOpen) {
        return 0;
    }
    if (scanType == mk_lt_scanWindowViewTypeQuarterOpen) {
        return 1;
    }
    if (scanType == mk_lt_scanWindowViewTypeOneEighthOpen) {
        return 2;
    }
    return 0;
}

#pragma mark - getter
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = RGBCOLOR(239, 239, 239);
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.borderColor = RGBCOLOR(167, 166, 167).CGColor;
        _alertView.layer.borderWidth = 0.5f;
        _alertView.layer.cornerRadius = 8.f;
    }
    return _alertView;
}

- (UILabel *)titleMsgLabel {
    if (!_titleMsgLabel) {
        _titleMsgLabel = [[UILabel alloc] init];
        _titleMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleMsgLabel.textAlignment = NSTextAlignmentCenter;
        _titleMsgLabel.font = MKFont(17.f);
        _titleMsgLabel.numberOfLines = 0;
        _titleMsgLabel.text = titleMsg;
    }
    return _titleMsgLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.numberOfLines = 0;
        _msgLabel.text = alertMsg;
    }
    return _msgLabel;
}

- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] init];
        _maxLabel.textColor = RGBCOLOR(171, 174, 181);
        _maxLabel.textAlignment = NSTextAlignmentLeft;
        _maxLabel.font = MKFont(13.f);
        _maxLabel.text = @"1/2";
    }
    return _maxLabel;
}

- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] init];
        _minLabel.textAlignment = NSTextAlignmentRight;
        _minLabel.textColor = RGBCOLOR(171, 174, 181);
        _minLabel.font = MKFont(13.f);
        _minLabel.text = @"0";
    }
    return _minLabel;
}

- (MKLTTriggerSenSlider *)slider {
    if (!_slider) {
        _slider = [[MKLTTriggerSenSlider alloc] init];
        _slider.maximumValue = 3;
        _slider.minimumValue = 0;
        _slider.value = 0.f;
        [_slider addTarget:self
                    action:@selector(sliderValueChanged)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = DEFAULT_TEXT_COLOR;
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.font = MKFont(13.f);
    }
    return _valueLabel;
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = RGBCOLOR(167, 166, 167);
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = RGBCOLOR(167, 166, 167);
    }
    return _lineView2;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0x2F84D0) forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:MKFont(15.f)];
        [_cancelButton addTarget:self
                          action:@selector(cancelButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"OK" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColorFromRGB(0x2F84D0) forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:MKFont(15.f)];
        [_confirmButton addTarget:self
                           action:@selector(confirmButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
