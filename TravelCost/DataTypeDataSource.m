//
//  DataTypeKeyboardViewController.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/31.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "DataTypeDataSource.h"
#import "ItemSettingModel.h"
#import "StringUtil.h"

@interface DataTypeDataSource ()

@end

@implementation DataTypeDataSource

static NSMutableDictionary *values;
static NSMutableArray *keys;

+ (void) initialize{
    keys = [[NSMutableArray alloc] init];
    [keys addObject:ISM_DATA_TYPE_STRING];
    [keys addObject:ISM_DATA_TYPE_Num];
    [keys addObject:ISM_DATA_TYPE_DATE];
    [keys addObject:ISM_DATA_TYPE_HHMM];
    [keys addObject:ISM_DATA_TYPE_SELECT];
    [keys addObject:ISM_DATA_TYPE_CHECK];
//    [keys addObject:ISM_DATA_TYPE_STAR5];
//    [keys addObject:ISM_DATA_TYPE_STAR4];
//    [keys addObject:ISM_DATA_TYPE_STAR3];
//    [keys addObject:ISM_DATA_TYPE_STAR2];
//    [keys addObject:ISM_DATA_TYPE_STAR1];
    
    values = [[NSMutableDictionary alloc] init];
    [values setObject:@"文字列" forKey:ISM_DATA_TYPE_STRING];
    [values setObject:@"数値" forKey:ISM_DATA_TYPE_Num];
    [values setObject:@"日付" forKey:ISM_DATA_TYPE_DATE];
    [values setObject:@"時分" forKey:ISM_DATA_TYPE_HHMM];
    [values setObject:@"選択" forKey:ISM_DATA_TYPE_SELECT];
    [values setObject:@"チェックボックス" forKey:ISM_DATA_TYPE_CHECK];
//    [values setObject:@"☆☆☆☆☆" forKey:ISM_DATA_TYPE_STAR5];
//    [values setObject:@"☆☆☆☆" forKey:ISM_DATA_TYPE_STAR4];
//    [values setObject:@"☆☆☆" forKey:ISM_DATA_TYPE_STAR3];
//    [values setObject:@"☆☆" forKey:ISM_DATA_TYPE_STAR2];
//    [values setObject:@"☆" forKey:ISM_DATA_TYPE_STAR1];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [keys count];
}

// 表示する内容を返す
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *key = keys[ row];
    return [values objectForKey:key];
}

+ (NSString *) getDataTypeCode: (NSString *)dataTypeName{
    // nameが一致するものを探す
    for (id key in [values keyEnumerator]) {
        NSString *name = [values valueForKey:key];
        if( [StringUtil equals:dataTypeName str2:name]){
            return key;
        }
    }
    return nil;
}

+ (NSString *) getDataTypeName: (NSString *)dataTypeCode{
    return [values valueForKey:dataTypeCode];
}

+ (NSString *) getDataTypeCodeFromIndex: (int)rowIndex{
    return keys[ rowIndex];
}

+ (NSString *) getDataTypeNameFromIndex: (int)rowIndex{
    NSString *key = keys[ rowIndex];
    return [values valueForKey:key];
}

+ (int) getIndex: (NSString *)key{
    return (int)[keys indexOfObject: key];
}

@end
