//
//  InputSettingEditViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/17.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "InputSettingEditViewController.h"
#import "DataTypeDataSource.h"
#import "ViewUtil.h"
#import "ItemSettingDao.h"
#import "ItemSettingManager.h"
#import "MessageBuilder.h"
#import "NumberUtil.h"
#import "OkCancelAccessoryViewController.h"

@interface InputSettingEditViewController ()
{
    UIPickerView *mPicker;
    DataTypeDataSource *dataTypeDataSource;
}
@end

@implementation InputSettingEditViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    [ViewUtil setToolbarImages:self.toolbar];
    
    // キーボードの表示タイミングで自動スクロール
    [super autoScroll:self.scrollView];

    // キーボードを生成してインスタンス変数に設定
    mPicker = [[UIPickerView alloc] init];
    dataTypeDataSource = [[DataTypeDataSource alloc] init];
    mPicker.delegate = dataTypeDataSource;
    mPicker.dataSource = dataTypeDataSource;
    self.dataTypeText.inputView = mPicker;
    
    __block UIPickerView *blockPicker = mPicker;
    __block InputSettingEditViewController *blockSelf = self;
    
    OkCancelAccessoryViewController *okCancelVc =[[ OkCancelAccessoryViewController alloc] init];
    self.dataTypeText.inputAccessoryView = [okCancelVc view];
    
    okCancelVc.okBlock = ^{
        int selectedRow = (int)[blockPicker selectedRowInComponent:0];
        NSString *dataTypeCode = [DataTypeDataSource getDataTypeCodeFromIndex:selectedRow];
        NSString *dataTypeName = [DataTypeDataSource getDataTypeNameFromIndex:selectedRow];
        blockSelf.dataTypeText.text = dataTypeName;
        
        [blockSelf changeDataType:dataTypeCode];
        
        [super focusNextField: blockSelf.dataTypeText];
    };
    okCancelVc.cancelBlock = ^{
        [blockSelf.dataTypeText resignFirstResponder];
    };
    
    
    [self addInputField:self.nameText];
    [self addInputField:self.dataTypeText];
    [self addInputField:self.defaultValueText];
    
    // モデルの値を設定
    {
        // 項目名
        self.nameText.text = _settingModel.name;
        
        // データタイプ
        NSString *dataTypeCode = self.settingModel.dataType;
        // 空なら先頭
        if( [StringUtil isEmpty:dataTypeCode]){
            dataTypeCode = [DataTypeDataSource getDataTypeCodeFromIndex:0];
        }
        NSString *dataTypeName = [DataTypeDataSource getDataTypeName:dataTypeCode];
        self.dataTypeText.text = dataTypeName;
        int rowIndex = [DataTypeDataSource getIndex:dataTypeCode];
        [mPicker selectRow:rowIndex inComponent:0 animated:true];
        [self changeDataType:dataTypeCode];
        
        // デフォルト値
        if(! [StringUtil isEmpty:self.settingModel.defaultValue]){
            self.defaultValueText.text = self.settingModel.defaultValue;
        }
    }
}

- (void) changeDataType: (NSString *) dataTypeCode{
    // 数値
    if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_Num]){
        // 選択肢
        [self.itemLabel setHidden:YES];
        [self.itemText setHidden:YES];
        // デフォルト値
        [self.defaultValueLabel setHidden:NO];
        [self.defaultValueText setHidden:NO];
    }
    // 日付
    else if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_DATE]){
        // 単位
        [self.itemLabel setHidden:YES];
        [self.itemText setHidden:YES];
        // デフォルト値
        [self.defaultValueLabel setHidden:YES];
        [self.defaultValueText setHidden:YES];
    }
    // 選択肢
    else if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_SELECT]){
        // 単位
        [self.itemLabel setHidden:NO];
        [self.itemText setHidden:NO];
        // デフォルト値
        [self.defaultValueLabel setHidden:NO];
        [self.defaultValueText setHidden:NO];
    }
    // デフォルト値のみ表示
    else{
        // 単位
        [self.itemLabel setHidden:YES];
        [self.itemText setHidden:YES];
        // デフォルト値
        [self.defaultValueLabel setHidden:NO];
        [self.defaultValueText setHidden:NO];
    }

    [super updateReturnKey];
}

#pragma mark Menu Action
- (IBAction)helpSelected:(id)sender {
    NSMutableString *howTo = [[NSMutableString alloc] init];
    [howTo appendString:@"入力項目を編集します。\n"];
    [howTo appendString:@"デフォルト値にはデータ型に応じて下記の値を設定してください。\n\n"];
    [howTo appendString:@"【数値】\n"];
    [howTo appendString:@"桁数の範囲内の任意の文字列が指定可能です\n"];
    [howTo appendString:@"【時分】\n"];
    [howTo appendString:@"HH:mm形式で時間と分が指定可能です\n"];
    [howTo appendString:@"【文字列】\n"];
    [howTo appendString:@"任意の文字列が指定可能です\n"];
    [howTo appendString:@"【選択】\n"];
    [howTo appendString:@"選択肢に含まれる値が指定可能です\n"];
    [howTo appendString:@"【チェックボックス】\n"];
    [howTo appendString:@"ON,TRUE,1を指定するとチェックがONになり、その他の値だとチェックがOFFになります\n"];
    [ViewUtil showMessage:@"利用方法" message:howTo];
}

- (IBAction)deleteSelected:(id)sender {
    if( self.settingModel != nil){
        ItemSettingDao *dao = [[ItemSettingDao alloc] init];
        [dao deleteModel: self.settingModel];
        
        // 更新時間を設定
        [[ItemSettingManager instance] setUpdate:[ NSDate date]];
        
        [ViewUtil showToast:@"削除しました"];
        [ViewUtil closeView:self];
    }
}

- (IBAction)saveSelected:(id)sender {
    ItemSettingDao *dao = [[ItemSettingDao alloc] init];
    if( self.settingModel == nil){
        self.settingModel = [[ItemSettingModel alloc] init];
        
        self.settingModel.inputFlag = YES;
        self.settingModel.outputFlag = YES;
        
        int inputOrderNum = [dao getMax: ISM_COLUMN_INPUT_ORDER_NUM];
        int outputOrderNum = [dao getMax: ISM_COLUMN_OUTPUT_FLAG];
        self.settingModel.inputOrderNum = inputOrderNum + 1;
        self.settingModel.outputOrderNum = outputOrderNum + 1;
    }
    
    // 名前
    self.settingModel.name = self.nameText.text;
    // データタイプ
    NSString *dataTypeCode = [DataTypeDataSource getDataTypeCode: self.dataTypeText.text];
    self.settingModel.dataType = dataTypeCode;
    // デフォルト値
    self.settingModel.defaultValue = self.defaultValueText.text;
    // 選択肢 or 単位
    if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_SELECT]){
        self.settingModel.selectItems = self.itemText.text;
    }
    
    // 必須チェック
    {
        MessageBuilder *builder = [[MessageBuilder alloc] init];
        if( [StringUtil isEmpty: self.settingModel.name]){
            [builder addMessage: @"項目名を入力してください"];
        }
        
        // 項目名重複チェック
        NSMutableString *where = [NSMutableString stringWithFormat:@" %@='%@' ", ISM_COLUMN_NAME, self.settingModel.name];
        if( self.settingModel.rowId != nil){
            [where appendFormat: @"and %@ != %@ ", ISM_COLUMN_ROW_ID, self.settingModel.rowId];
        }
        NSArray *list = [dao list:where order:nil];
        if( [list count] != 0){
            [builder addMessage: @"項目名が重複しています"];
        }
    
        if(! [builder isEmpty]){
            // エラーあり
            [ViewUtil showMessage:nil message:builder.description];
            return;
        }
    }

    [dao saveModel:self.settingModel];
    
    // 更新時間を設定
    [[ItemSettingManager instance] setUpdate:[ NSDate date]];
    
    [ViewUtil showToast:@"保存しました"];
    [ViewUtil closeView:self];
}
@end
