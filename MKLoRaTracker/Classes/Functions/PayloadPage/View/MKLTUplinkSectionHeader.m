//
//  MKLTUplinkSectionHeader.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/4/1.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTUplinkSectionHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"


@interface MKLTUplinkSectionHeader ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKLTUplinkSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:RGBCOLOR(242, 242, 242)];
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(18.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setTitleMsg:(NSString *)titleMsg {
    _titleMsg = nil;
    _titleMsg = titleMsg;
    self.msgLabel.text = SafeStr(_titleMsg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = NAVBAR_COLOR_MACROS;
        _msgLabel.font = MKFont(18.f);
        _msgLabel.textAlignment  =NSTextAlignmentLeft;
    }
    return _msgLabel;
}

@end
