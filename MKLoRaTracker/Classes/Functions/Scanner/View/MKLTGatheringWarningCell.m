//
//  MKLTGatheringWarningCell.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTGatheringWarningCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

@implementation MKLTGatheringWarningCellModel
@end

@interface MKLTGatheringWarningCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *valueLabel;

@property (nonatomic, strong)UIButton *selectedButton;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKLTGatheringWarningCell

+ (MKLTGatheringWarningCell *)initCellWithTableView:(UITableView *)tableView {
    MKLTGatheringWarningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLTGatheringWarningCellIdenty"];
    if (!cell) {
        cell = [[MKLTGatheringWarningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLTGatheringWarningCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.valueLabel];
        [self.contentView addSubview:self.selectedButton];
        [self.contentView addSubview:self.unitLabel];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.selectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.selectedButton.mas_centerY);
        make.height.mas_equalTo(self.selectedButton.mas_height);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(135.f);
        make.centerY.mas_equalTo(self.selectedButton.mas_centerY);
        make.height.mas_equalTo(self.selectedButton.mas_height);
    }];
    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(20.f);
        make.right.mas_equalTo(self.selectedButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.selectedButton.mas_centerY);
        make.height.mas_equalTo(self.selectedButton.mas_height);
    }];
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-10.f);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)selectedButtonPressed {
    [self.dataList removeAllObjects];
    if (self.dataModel.triggerRssi <= -124) {
        [self.dataList addObject:@"-127"];
    }else {
        for (NSInteger i = self.dataModel.triggerRssi; i >= -127 ; i --) {
            [self.dataList addObject:[NSString stringWithFormat:@"%ld",(long)i]];
        }
    }
    NSInteger row = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        if ([self.selectedButton.titleLabel.text isEqualToString:self.dataList[i]]) {
            row = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = self.dataList;
    [pickView showPickViewWithIndex:row block:^(NSInteger currentRow) {
        [self.selectedButton setTitle:self.dataList[currentRow] forState:UIControlStateNormal];
        self.noteLabel.text = [NSString stringWithFormat:@"* People gathering warning will take effect，when the BLE RSSI scanned is greater than %@dBm.",self.dataList[currentRow]];
        if ([self.delegate respondsToSelector:@selector(mk_gatheringWarningRssiValueChanged:)]) {
            [self.delegate mk_gatheringWarningRssiValueChanged:[self.dataList[currentRow] integerValue]];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKLTGatheringWarningCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    NSLog(@"当前的rssi值:%@+++++++++++%@",@(dataModel.triggerRssi),@(dataModel.gatheringWarningRssi));
    [self.selectedButton setTitle:[NSString stringWithFormat:@"%ld",(long)_dataModel.gatheringWarningRssi] forState:UIControlStateNormal];
    self.valueLabel.text = [NSString stringWithFormat:@"-127-%@dBm",[NSString stringWithFormat:@"%ld",(long)_dataModel.triggerRssi]];
    self.noteLabel.text = [NSString stringWithFormat:@"* People gathering warning will take effect，when the BLE RSSI scanned is greater than %@dBm.",[NSString stringWithFormat:@"%ld",(long)_dataModel.gatheringWarningRssi]];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Gathering Warning";
    }
    return _msgLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = UIColorFromRGB(0x353535);
        _valueLabel.font = MKFont(12.f);
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.text = @"-127 - 0dBm";
    }
    return _valueLabel;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [MKCustomUIAdopter customButtonWithTitle:@"0"
                                                        titleColor:COLOR_WHITE_MACROS
                                                   backgroundColor:UIColorFromRGB(0x2F84D0)
                                                            target:self
                                                            action:@selector(selectedButtonPressed)];
    }
    return _selectedButton;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = UIColorFromRGB(0x353535);
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.text = @"* People gathering warning will take effect，when the BLE RSSI scanned is greater than -40dbm.";
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.font = MKFont(13.f);
        _unitLabel.textAlignment = NSTextAlignmentRight;
        _unitLabel.text = @"dBm";
    }
    return _unitLabel;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
