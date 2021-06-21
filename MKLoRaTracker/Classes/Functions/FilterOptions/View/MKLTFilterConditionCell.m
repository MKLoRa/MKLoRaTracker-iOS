//
//  MKLTFilterConditionCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTFilterConditionCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

@implementation MKLTFilterConditionCellModel
@end

@interface MKLTFilterConditionCell ()

@property (nonatomic, strong)UILabel *leftMsgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@property (nonatomic, strong)UIButton *centerButton;

@end

@implementation MKLTFilterConditionCell

+ (MKLTFilterConditionCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTFilterConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTFilterConditionCellIdenty"];
    if (!cell) {
        cell = [[MKLTFilterConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTFilterConditionCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftMsgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
        [self.contentView addSubview:self.centerButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.leftMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.centerButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.rightMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerButton.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
}

#pragma mark - event method
- (void)centerButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.dataList.count; i ++) {
        if ([self.centerButton.titleLabel.text isEqualToString:self.dataModel.dataList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataModel.dataList selectedRow:index block:^(NSInteger currentRow) {
        [self.centerButton setTitle:self.dataModel.dataList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mk_filterConditionsChanged:)]) {
            [self.delegate mk_filterConditionsChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKLTFilterConditionCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    [self.centerButton setTitle:_dataModel.dataList[_dataModel.conditionIndex] forState:UIControlStateNormal];
    self.centerButton.enabled = _dataModel.enable;
    [self.centerButton setBackgroundColor:(_dataModel.enable ? NAVBAR_COLOR_MACROS : [UIColor grayColor])];
    [self.centerButton setTitleColor:(_dataModel.enable ? COLOR_WHITE_MACROS : DEFAULT_TEXT_COLOR) forState:UIControlStateNormal];
    self.leftMsgLabel.text = SafeStr(_dataModel.leftMsg);
    self.rightMsgLabel.text = SafeStr(_dataModel.rightMsg);
}

#pragma mark - getter
- (UILabel *)leftMsgLabel {
    if (!_leftMsgLabel) {
        _leftMsgLabel = [[UILabel alloc] init];
        _leftMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _leftMsgLabel.font = MKFont(15.f);
        _leftMsgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftMsgLabel;
}

- (UILabel *)rightMsgLabel {
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _rightMsgLabel.font = MKFont(15.f);
        _rightMsgLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightMsgLabel;
}

- (UIButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [MKCustomUIAdopter customButtonWithTitle:@"And"
                                                      titleColor:COLOR_WHITE_MACROS
                                                 backgroundColor:NAVBAR_COLOR_MACROS
                                                          target:self
                                                          action:@selector(centerButtonPressed)];
        _centerButton.titleLabel.font = MKFont(14.f);
    }
    return _centerButton;
}

@end
