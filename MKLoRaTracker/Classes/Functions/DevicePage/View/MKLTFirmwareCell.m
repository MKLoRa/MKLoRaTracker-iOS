//
//  MKLTFirmwareCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/21.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTFirmwareCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKLTFirmwareCellModel
@end

@interface MKLTFirmwareCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@property (nonatomic, strong)UIButton *dfuButton;

@end

@implementation MKLTFirmwareCell

+ (MKLTFirmwareCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTFirmwareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTFirmwareCellIdenty"];
    if (!cell) {
        cell = [[MKLTFirmwareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTFirmwareCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
        [self.contentView addSubview:self.dfuButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.dfuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.rightMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.dfuButton.mas_left).mas_offset(-10.f);
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(10.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)dfuButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_firmwareButtonMethod)]) {
        [self.delegate mk_firmwareButtonMethod];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKLTFirmwareCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.rightMsgLabel.text = SafeStr(_dataModel.rightMsg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UILabel *)rightMsgLabel {
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = RGBCOLOR(102, 102, 102);
        _rightMsgLabel.textAlignment = NSTextAlignmentRight;
        _rightMsgLabel.font = MKFont(13.f);
    }
    return _rightMsgLabel;
}

- (UIButton *)dfuButton {
    if (!_dfuButton) {
        _dfuButton = [MKCustomUIAdopter customButtonWithTitle:@"DFU"
                                                   titleColor:COLOR_WHITE_MACROS
                                              backgroundColor:UIColorFromRGB(0x2F84D0)
                                                       target:self
                                                       action:@selector(dfuButtonPressed)];
        _dfuButton.titleLabel.font = MKFont(13.f);
    }
    return _dfuButton;
}

@end
