//
//  MKLTFilterConditionController.m
//  MKLoRaTracker_Example
//
//  Created by aa on 2021/1/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLTFilterConditionController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKFilterDataCell.h"
#import "MKTextSwitchCell.h"
#import "MKRawAdvDataOperationCell.h"
#import "MKFilterRawAdvDataCell.h"
#import "MKCustomUIAdopter.h"
#import "MKNormalSliderCell.h"

#import "MKLTFilterConditionModel.h"

static CGFloat const statusOnHeight = 145.f;
static CGFloat const statusOffHeight = 60.f;

@interface MKLTFilterConditionController ()
<UITableViewDelegate,
UITableViewDataSource,
MKNormalSliderCellDelegate,
MKFilterDataCellDelegate,
MKRawAdvDataOperationCellDelegate,
mk_textSwitchCellDelegate,
MKFilterRawAdvDataCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)NSMutableArray *section4List;

@property (nonatomic, strong)MKLTFilterConditionModel *dataModel;

@end

@implementation MKLTFilterConditionController

- (void)dealloc {
    NSLog(@"MKLTFilterConditionController销毁");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    NSMutableArray *list = [NSMutableArray array];
    if (self.dataModel.rawDataIson) {
        for (NSInteger i = 0; i < self.section3List.count; i ++) {
            MKFilterRawAdvDataCellModel *cellModel = self.section3List[i];
            MKLTFilterRawAdvDataModel *model = [[MKLTFilterRawAdvDataModel alloc] init];
            model.dataType = cellModel.dataType;
            model.maxIndex = [cellModel.maxIndex integerValue];
            model.minIndex = [cellModel.minIndex integerValue];
            model.rawData = cellModel.rawData;
            if (![model validParams]) {
                [self.view showCentralToast:@"Filter by Raw Adv Data Params Error"];
                return;
            }
            [list addObject:model];
        }
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configWithRawDataList:list sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95.f;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //mac
            return self.dataModel.macIson ? statusOnHeight : statusOffHeight;
        }
        if (indexPath.row == 1) {
            //adv name
            return self.dataModel.advNameIson ? statusOnHeight : statusOffHeight;
        }
        if (indexPath.row == 2) {
            //uuid
            return self.dataModel.uuidIson ? statusOnHeight : statusOffHeight;
        }
        if (indexPath.row == 3) {
            //major
            return self.dataModel.majorIson ? statusOnHeight : statusOffHeight;
        }
        if (indexPath.row == 4) {
            //minor
            return self.dataModel.minorIson ? statusOnHeight : statusOffHeight;
        }
    }
    if (indexPath.section == 2) {
        return self.dataModel.rawDataIson ? 80.f : 44.f;
    }
    if (indexPath.section == 3) {
        return 95.f;
    }
    if (indexPath.section == 4) {
        MKTextSwitchCellModel *cellModel = self.section4List[indexPath.row];
        return [cellModel cellHeightWithContentWidth:kViewWidth];
    }
    return 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    if (section == 3) {
        return (self.dataModel.rawDataIson ? self.section3List.count : 0);
    }
    if (section == 4) {
        return self.section4List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalSliderCell *cell = [MKNormalSliderCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 1) {
        MKFilterDataCell *cell = [MKFilterDataCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 2) {
        MKRawAdvDataOperationCell *cell = [MKRawAdvDataOperationCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section == 3) {
        MKFilterRawAdvDataCell *cell = [MKFilterRawAdvDataCell initCellWithTableView:tableView];
        cell.dataModel = self.section3List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
    cell.dataModel = self.section4List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKNormalSliderCellDelegate
/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index {
    if (index == 0) {
        //RSSI
        self.dataModel.rssiValue = value;
        MKNormalSliderCellModel *cellModel = self.section0List[0];
        cellModel.sliderValue = value;
        return;
    }
}

#pragma mark - MKFilterDataCellDelegate
/// 顶部开关状态发生改变
/// @param isOn 开关状态
/// @param index 当前cell所在index
- (void)mk_fliterSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.macIson = isOn;
    }else if (index == 1) {
        self.dataModel.advNameIson = isOn;
    }else if (index == 2) {
        self.dataModel.uuidIson = isOn;
    }else if (index == 3) {
        self.dataModel.majorIson = isOn;
    }else if (index == 4) {
        self.dataModel.minorIson = isOn;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.isOn = isOn;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)mk_listButtonStateChanged:(BOOL)selected index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.macWhiteListIson = selected;
    }else if (index == 1) {
        self.dataModel.advNameWhiteListIson = selected;
    }else if (index == 2) {
        self.dataModel.uuidWhiteListIson = selected;
    }else if (index == 3) {
        self.dataModel.majorWhiteListIson = selected;
    }else if (index == 4) {
        self.dataModel.minorWhiteListIson = selected;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.selected = selected;
}

/// mk_filterDataCellType==mk_filterDataCellType_normal的情况下输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_filterTextFieldValueChanged:(NSString *)value index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.macValue = value;
    }else if (index == 1) {
        self.dataModel.advNameValue = value;
    }else if (index == 2) {
        self.dataModel.uuidValue = value;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.textFieldValue = value;
}

/// mk_filterDataCellType==mk_filterDataCellType_double的情况下左侧输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_leftFilterTextFieldValueChanged:(NSString *)value index:(NSInteger)index {
    if (index == 3) {
        self.dataModel.majorMinValue = value;
    }else if (index == 4) {
        self.dataModel.minorMinValue = value;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.leftTextFieldValue = value;
}

/// mk_filterDataCellType==mk_filterDataCellType_double的情况下右侧输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_rightFilterTextFieldValueChanged:(NSString *)value index:(NSInteger)index {
    if (index == 3) {
        self.dataModel.majorMaxValue = value;
    }else if (index == 4) {
        self.dataModel.minorMaxValue = value;
    }
    MKFilterDataCellModel *cellModel = self.section1List[index];
    cellModel.rightTextFieldValue = value;
}

#pragma mark - MKRawAdvDataOperationCellDelegate
/// +号按钮点击事件
- (void)mk_rawAdvDataOperation_addMethod {
    if (self.section3List.count >= 5) {
        [self.view showCentralToast:@"You can set up to 5 filters!"];
        return;
    }
    MKFilterRawAdvDataCellModel *cellModel = [[MKFilterRawAdvDataCellModel alloc] init];
    cellModel.dataTypePlaceHolder = @"00-FF";
    cellModel.minTextFieldPlaceHolder = @"00-FF";
    cellModel.maxTextFieldPlaceHolder = @"00-FF";
    cellModel.rawTextFieldPlaceHolder = @"00-FF";
    cellModel.rawDataMaxBytes = 62;
    cellModel.index = self.section3List.count;
    [self.section3List addObject:cellModel];
    [self.tableView mk_reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

/// -号按钮点击事件
- (void)mk_rawAdvDataOperation_subMethod {
    if (self.section3List.count == 0) {
        return;
    }
    [self.section3List removeLastObject];
    [self.tableView mk_reloadSection:3 withRowAnimation:UITableViewRowAnimationNone];
}

/// 开关状态发生改变
/// @param isOn YES:打开，NO:关闭
- (void)mk_rawAdvDataOperation_switchStatusChanged:(BOOL)isOn {
    self.dataModel.rawDataIson = isOn;
    MKRawAdvDataOperationCellModel *cellModel = self.section2List[0];
    cellModel.isOn = isOn;
    [self.tableView reloadData];
}

/// 白名单按钮点击事件
/// @param selected YES:选中,NO:未选中
- (void)mk_rawAdvDataOperation_whiteListButtonSelected:(BOOL)selected {
    self.dataModel.rawDataWhiteListIson = selected;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        self.dataModel.enableFilterConditions = isOn;
        MKTextSwitchCellModel *cellModel = self.section4List[0];
        cellModel.isOn = isOn;
    }
}

#pragma mark - MKFilterRawAdvDataCellDelegate
/// 输入框内容发生改变
/// @param textType 哪个输入框发生改变了
/// @param index 当前cell所在的row
/// @param textValue 当前textField内容
- (void)rawFilterDataChanged:(mk_filterRawAdvDataTextType)textType
                       index:(NSInteger)index
                   textValue:(NSString *)textValue {
    if (index >= self.section3List.count) {
        return;
    }
    MKFilterRawAdvDataCellModel *cellModel = self.section3List[index];
    if (textType == mk_filterRawAdvDataTextTypeDataType) {
        //过滤类型输入框内容发生改变
        cellModel.dataType = textValue;
        return;
    }
    if (textType == mk_filterRawAdvDataTextTypeMinIndex) {
        //开始过滤的Byte索引输入框发生改变
        cellModel.minIndex = textValue;
        return;
    }
    if (textType == mk_filterRawAdvDataTextTypeMaxIndex) {
        //截止过滤的Byte索引输入框发生改变
        cellModel.maxIndex = textValue;
        return;
    }
    if (textType == mk_filterRawAdvDataTextTypeRawDataType) {
        //过滤内容输入框发生改变
        cellModel.rawData = textValue;
        return;
    }
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [self loadSection4Datas];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKNormalSliderCellModel *cellModel = [[MKNormalSliderCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = [MKCustomUIAdopter attributedString:@[@"RSSI Filter",@"   (-127dBm ~ 0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,UIColorFromRGB(0x353535)]];
    cellModel.sliderValue = self.dataModel.rssiValue;
    cellModel.sliderMaxValue = 0;
    cellModel.sliderMinValue = -127;
    cellModel.changed = YES;
    cellModel.leftNoteMsg = @"*The device will uplink valid ADV data with RSSI no less than";
    cellModel.unit = @"dBm";
    cellModel.rightNoteMsg = @".";
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKFilterDataCellModel *macModel = [[MKFilterDataCellModel alloc] init];
    macModel.index = 0;
    macModel.msg = @"Filter by MAC Address";
    macModel.textFieldPlaceholder = @"1 ~ 6 Bytes";
    macModel.textFieldType = mk_hexCharOnly;
    macModel.maxLength = 12;
    macModel.isOn = self.dataModel.macIson;
    macModel.selected = self.dataModel.macWhiteListIson;
    macModel.textFieldValue = self.dataModel.macValue;
    [self.section1List addObject:macModel];
    
    MKFilterDataCellModel *advNameModel = [[MKFilterDataCellModel alloc] init];
    advNameModel.index = 1;
    advNameModel.msg = @"Filter by ADV Name";
    advNameModel.textFieldPlaceholder = @"1 ~ 10 Characters";
    advNameModel.textFieldType = mk_normal;
    advNameModel.maxLength = 10;
    advNameModel.isOn = self.dataModel.advNameIson;
    advNameModel.selected = self.dataModel.advNameWhiteListIson;
    advNameModel.textFieldValue = self.dataModel.advNameValue;
    [self.section1List addObject:advNameModel];
    
    MKFilterDataCellModel *uuidModel = [[MKFilterDataCellModel alloc] init];
    uuidModel.index = 2;
    uuidModel.msg = @"Filter by iBeacon Proximity UUID";
    uuidModel.textFieldPlaceholder = @"1 ~ 16 Bytes";
    uuidModel.textFieldType = mk_hexCharOnly;
    uuidModel.isOn = self.dataModel.uuidIson;
    uuidModel.maxLength = 32;
    uuidModel.selected = self.dataModel.uuidWhiteListIson;
    uuidModel.textFieldValue = self.dataModel.uuidValue;
    [self.section1List addObject:uuidModel];
    
    MKFilterDataCellModel *majorModel = [[MKFilterDataCellModel alloc] init];
    majorModel.index = 3;
    majorModel.msg = @"Filter by iBeacon Major";
    majorModel.cellType = mk_filterDataCellType_double;
    majorModel.isOn = self.dataModel.majorIson;
    majorModel.selected = self.dataModel.majorWhiteListIson;
    majorModel.leftTextFieldValue = self.dataModel.majorMinValue;
    majorModel.rightTextFieldValue = self.dataModel.majorMaxValue;
    [self.section1List addObject:majorModel];
    
    MKFilterDataCellModel *minorModel = [[MKFilterDataCellModel alloc] init];
    minorModel.index = 4;
    minorModel.msg = @"Filter by iBeacon Minor";
    minorModel.cellType = mk_filterDataCellType_double;
    minorModel.isOn = self.dataModel.minorIson;
    minorModel.selected = self.dataModel.minorWhiteListIson;
    minorModel.leftTextFieldValue = self.dataModel.minorMinValue;
    minorModel.rightTextFieldValue = self.dataModel.minorMaxValue;
    [self.section1List addObject:minorModel];
}

- (void)loadSection2Datas {
    MKRawAdvDataOperationCellModel *cellModel = [[MKRawAdvDataOperationCellModel alloc] init];
    cellModel.msg = @"Filter by Raw Adv Data";
    cellModel.isOn = self.dataModel.rawDataIson;
    cellModel.selected = self.dataModel.rawDataWhiteListIson;
    [self.section2List addObject:cellModel];
}

- (void)loadSection3Datas {
    for (NSInteger i = 0; i < self.dataModel.rawDataList.count; i ++) {
        NSDictionary *dic = self.dataModel.rawDataList[i];
        MKFilterRawAdvDataCellModel *cellModel = [[MKFilterRawAdvDataCellModel alloc] init];
        [cellModel mk_modelSetWithJSON:dic];
        cellModel.dataTypePlaceHolder = @"00-FF";
        cellModel.minTextFieldPlaceHolder = @"00-FF";
        cellModel.maxTextFieldPlaceHolder = @"00-FF";
        cellModel.rawTextFieldPlaceHolder = @"00-FF";
        cellModel.rawDataMaxBytes = 62;
        [self.section3List addObject:cellModel];
    }
}

- (void)loadSection4Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    NSString *conditionType = (self.conditionType == mk_lt_trackingConditionA || self.conditionType == mk_lt_locationConditionA) ? @"A" : @"B";
    cellModel.msg = [@"Enable Filter Condition " stringByAppendingString:conditionType];
    cellModel.noteMsg = [NSString stringWithFormat:@"*Turn on the Filter Condition %@ ,all filtration of this page will take effect.Turn off the Filter Condition %@, all filtration of this page will not take effect.",conditionType,conditionType];
    cellModel.noteMsgColor = RGBCOLOR(102, 102, 102);
    cellModel.isOn = self.dataModel.enableFilterConditions;
    [self.section4List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    if (self.conditionType == mk_lt_trackingConditionA) {
        self.defaultTitle = @"Tracking Filter Option A";
    }else if (self.conditionType == mk_lt_trackingConditionB) {
        self.defaultTitle = @"Tracking Filter Option B";
    }else if (self.conditionType == mk_lt_locationConditionA) {
        self.defaultTitle = @"Location Filter Option A";
    }else if (self.conditionType == mk_lt_locationConditionB) {
        self.defaultTitle = @"Location Filter Option B";
    }
    [self.rightButton setImage:LOADICON(@"MKLoRaTracker", @"MKLTFilterConditionController", @"lt_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

- (NSMutableArray *)section4List {
    if (!_section4List) {
        _section4List = [NSMutableArray array];
    }
    return _section4List;
}

- (MKLTFilterConditionModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKLTFilterConditionModel alloc] init];
        _dataModel.rulesType = self.conditionType;
    }
    return _dataModel;
}

@end
