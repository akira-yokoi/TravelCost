//
//  ItemSettingModel.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ItemSettingModel: Model

// データタイプ定数
extern NSString * const ISM_DATA_TYPE_STAR5;
extern NSString * const ISM_DATA_TYPE_STAR4;
extern NSString * const ISM_DATA_TYPE_STAR3;
extern NSString * const ISM_DATA_TYPE_STAR2;
extern NSString * const ISM_DATA_TYPE_STAR1;
extern NSString * const ISM_DATA_TYPE_STRING;
extern NSString * const ISM_DATA_TYPE_CHECK;
extern NSString * const ISM_DATA_TYPE_Num;
extern NSString * const ISM_DATA_TYPE_HHMM;
extern NSString * const ISM_DATA_TYPE_DATE;
extern NSString * const ISM_DATA_TYPE_SELECT;
extern NSString * const ISM_DATA_TYPE_HHMM_LIST;

// カラム名定数
extern NSString * const ISM_TABLE_NAME;
extern NSString * const ISM_COLUMN_ROW_ID;
extern NSString * const ISM_COLUMN_NAME;
extern NSString * const ISM_COLUMN_UNIT;
extern NSString * const ISM_COLUMN_DATA_TYPE;
extern NSString * const ISM_COLUMN_INPUT_TYPE;
extern NSString * const ISM_COLUMN_INT_LENGTH;
extern NSString * const ISM_COLUMN_DECIMAL_LENGTH;
extern NSString * const ISM_COLUMN_DEFAULT_VALUE_TYPE;
extern NSString * const ISM_COLUMN_DEFAULT_VALUE;
extern NSString * const ISM_COLUMN_SELECT_ITEMS;
extern NSString * const ISM_COLUMN_CAN_UPDATE_FLAG;
extern NSString * const ISM_COLUMN_INPUT_ORDER_NUM;
extern NSString * const ISM_COLUMN_INPUT_FLAG;
extern NSString * const ISM_COLUMN_OUTPUT_ORDER_NUM;
extern NSString * const ISM_COLUMN_OUTPUT_FLAG;
extern NSString * const ISM_COLUMN_OUTPUT_SETTING;

@property (strong, nonatomic) NSNumber *rowId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSString *dataType;
@property (strong, nonatomic) NSString *inputType;
@property NSInteger intLength;
@property NSInteger decimalLength;
@property (strong, nonatomic) NSString *defaultValueType;
@property (strong, nonatomic) NSString *defaultValue;
@property (strong, nonatomic) NSString *selectItems;
@property BOOL canUpdateFlag;
@property NSInteger inputOrderNum;
@property BOOL inputFlag;
@property NSInteger outputOrderNum;
@property BOOL outputFlag;
@property (strong, nonatomic) NSString *outputSetting;

@end
