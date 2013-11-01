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
#import "MessageBuilder.h"

@interface InputSettingEditViewController ()
{
    PickerKeyboardViewController *dataTypeKeyborad;
    DataTypeDataSource *dataTypeDataSource;
}
@end

@implementation InputSettingEditViewController

- (void) viewDidLoad{
    [super viewDidLoad];

    // キーボードの表示タイミングで自動スクロール
    [super autoScroll:self.scrollView];

    // キーボードを生成してインスタンス変数に設定
    dataTypeKeyborad = [[PickerKeyboardViewController alloc] init];
    self.dataTypeText.inputView = [dataTypeKeyborad view];
    dataTypeKeyborad.okBlock = ^{
        int selectedRow = (int)[dataTypeKeyborad.picker selectedRowInComponent:0];
        NSString *dataTypeCode = [DataTypeDataSource getDataTypeCodeFromIndex:selectedRow];
        NSString *dataTypeName = [DataTypeDataSource getDataTypeNameFromIndex:selectedRow];
        self.dataTypeText.text = dataTypeName;
        
        [self changeDataType:dataTypeCode];
        [self.dataTypeText resignFirstResponder];
    };
    dataTypeKeyborad.cancelBlock = ^{
        [self.dataTypeText resignFirstResponder];
    };
    
    
    // データソースの設定
    dataTypeDataSource = [[DataTypeDataSource alloc] init];
    dataTypeKeyborad.picker.dataSource = dataTypeDataSource;
    dataTypeKeyborad.picker.delegate = dataTypeDataSource;

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

        int rowIndex = [DataTypeDataSource getIndex:dataTypeCode];
        NSString *dataTypeName = [DataTypeDataSource getDataTypeName:dataTypeCode];
        self.dataTypeText.text = dataTypeName;
        [dataTypeKeyborad.picker selectRow:rowIndex inComponent:0 animated:true];
        [self changeDataType:dataTypeCode];
        
        
        // 桁数
        if( self.settingModel.intLength != nil){
            self.intLengthText.text = [StringUtil toStringInt:self.settingModel.intLength.intValue];
        }
        if( self.settingModel.decimalLength != nil){
            self.decimalLengthText.text = [StringUtil toStringInt:self.settingModel.decimalLength.intValue];
        }
        
        // 単位
        if(! [StringUtil isEmpty:self.settingModel.unit]){
            self.unitText.text = self.settingModel.unit;
        }
        
        // デフォルト値
        if(! [StringUtil isEmpty:self.settingModel.defaultValue]){
            self.defaultValueText.text = self.settingModel.defaultValue;
        }
    }
}

- (void) changeDataType: (NSString *) dataTypeCode{
    
    // ラベルの切替
    if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_SELECT]){
        self.unitLabel.text = @"選択肢(カンマ区切り)";
    }
    else{
        self.unitLabel.text = @"単位";
    }
    
    // 数値
    if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_Num]){
        // 単位
        [self.unitLabel setHidden:NO];
        [self.unitText setHidden:NO];
        // 桁数
        [self.lengthLabel setHidden:NO];
        [self.pointLabel setHidden:NO];
        [self.intLengthText setHidden:NO];
        [self.decimalLengthText setHidden:NO];
        // デフォルト値
        [self.defaultValueLabel setHidden:NO];
        [self.defaultValueText setHidden:NO];
    }
    // 日付
    else if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_DATE]){
        // 単位
        [self.unitLabel setHidden:YES];
        [self.unitText setHidden:YES];
        // 桁数
        [self.lengthLabel setHidden:YES];
        [self.pointLabel setHidden:YES];
        [self.intLengthText setHidden:YES];
        [self.decimalLengthText setHidden:YES];
        // デフォルト値
        [self.defaultValueLabel setHidden:YES];
        [self.defaultValueText setHidden:YES];
    }
    // 選択肢
    else if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_SELECT]){
        // 単位
        [self.unitLabel setHidden:NO];
        [self.unitText setHidden:NO];
        // 桁数
        [self.lengthLabel setHidden:YES];
        [self.pointLabel setHidden:YES];
        [self.intLengthText setHidden:YES];
        [self.decimalLengthText setHidden:YES];
        // デフォルト値
        [self.defaultValueLabel setHidden:NO];
        [self.defaultValueText setHidden:NO];
    }
    // デフォルト値のみ表示
    else{
        // 単位
        [self.unitLabel setHidden:YES];
        [self.unitText setHidden:YES];
        // 桁数
        [self.lengthLabel setHidden:YES];
        [self.pointLabel setHidden:YES];
        [self.intLengthText setHidden:YES];
        [self.decimalLengthText setHidden:YES];
        // デフォルト値
        [self.defaultValueLabel setHidden:NO];
        [self.defaultValueText setHidden:NO];
    }

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
        self.settingModel.selectItems = self.unitText.text;
    }
    else{
        self.settingModel.unit = self.unitText.text;
    }
    // 桁数
    self.settingModel.intLength = [StringUtil toInteger:self.intLengthText.text];
    self.settingModel.decimalLength = [StringUtil toInteger:self.decimalLengthText.text];
    
    // 必須チェック
    {
        MessageBuilder *builder = [[MessageBuilder alloc] init];
        if( [StringUtil isEmpty: self.settingModel.name]){
            [builder addMessage: @"項目名を入力してください"];
        }
        
        // 数値の場合
        if( [StringUtil equals:dataTypeCode str2:ISM_DATA_TYPE_Num]){
            if( self.settingModel.intLength == nil){
                [builder addMessage: @"整数の桁数を入力してください"];
            }
            if( self.settingModel.decimalLength == nil){
                [builder addMessage: @"小数の桁数を入力してください"];
            }
        }
        
        // 項目名重複チェック
        NSString *where = [NSString stringWithFormat:@" %@='%@' ", ISM_COLUMN_NAME, self.settingModel.name];
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
    [ViewUtil showToast:@"保存しました"];
    [ViewUtil closeView:self];
}
@end
