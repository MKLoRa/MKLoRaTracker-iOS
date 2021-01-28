//
//  MKLTNormalTextCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTNormalTextCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKLTNormalTextCellModel
@end

@interface MKLTNormalTextCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@end

@implementation MKLTNormalTextCell

+ (MKLTNormalTextCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTNormalTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTNormalTextCellIdenty"];
    if (!cell) {
        cell = [[MKLTNormalTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTNormalTextCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.rightMsgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rightMsgLabel.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.rightMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKLTNormalTextCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.leftMsg);
    self.rightMsgLabel.text = SafeStr(_dataModel.rightMsg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _msgLabel;
}

- (UILabel *)rightMsgLabel {
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _rightMsgLabel.textAlignment  =NSTextAlignmentRight;
        _rightMsgLabel.font = MKFont(13.f);
    }
    return _rightMsgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"MKLoRaTracker", @"MKLTNormalTextCell", @"lt_go_next_button.png");
    }
    return _rightIcon;
}

@end
