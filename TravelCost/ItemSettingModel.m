//
//  ItemSettingModel.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ItemSettingModel.h"


@implementation ItemSettingModel

//NSString * const ISM_DATA_TYPE_STAR5 = @"Star5";
//NSString * const ISM_DATA_TYPE_STAR4 = @"Star4";
//NSString * const ISM_DATA_TYPE_STAR3 = @"Star3";
//NSString * const ISM_DATA_TYPE_STAR2 = @"Star2";
//NSString * const ISM_DATA_TYPE_STAR1 = @"Star1";
NSString * const ISM_DATA_TYPE_STRING = @"String";
NSString * const ISM_DATA_TYPE_CHECK = @"Check";
NSString * const ISM_DATA_TYPE_Num = @"Num";
NSString * const ISM_DATA_TYPE_HHMM = @"HHMM";
NSString * const ISM_DATA_TYPE_DATE = @"Date";
NSString * const ISM_DATA_TYPE_SELECT = @"Select";
NSString * const ISM_DATA_TYPE_HHMM_LIST = @"HHMM_LIST";

NSString * const ISM_TABLE_NAME = @"item_setting";

NSString * const ISM_COLUMN_ROW_ID = @"row_id";
NSString * const ISM_COLUMN_NAME = @"name";
NSString * const ISM_COLUMN_DATA_TYPE = @"data_type";
NSString * const ISM_COLUMN_INPUT_TYPE = @"input_type";
NSString * const ISM_COLUMN_DEFAULT_VALUE_TYPE = @"default_value_type";
NSString * const ISM_COLUMN_DEFAULT_VALUE = @"default_value";
NSString * const ISM_COLUMN_SELECT_ITEMS = @"select_items";
NSString * const ISM_COLUMN_CAN_UPDATE_FLAG = @"can_update_flag";
NSString * const ISM_COLUMN_INPUT_ORDER_NUM = @"input_order_num";
NSString * const ISM_COLUMN_INPUT_FLAG = @"input_flag";
NSString * const ISM_COLUMN_OUTPUT_ORDER_NUM = @"output_order_num";
NSString * const ISM_COLUMN_OUTPUT_FLAG = @"output_flag";
NSString * const ISM_COLUMN_OUTPUT_SETTING = @"output_setting";

- (NSString *)getTableName{
    return ISM_TABLE_NAME;
}

- (NSString *)getIdColumnName{
    return ISM_COLUMN_ROW_ID;
}

- (NSArray *)getValueColumnNames{
    return @[ ISM_COLUMN_NAME, ISM_COLUMN_DATA_TYPE, ISM_COLUMN_INPUT_TYPE, ISM_COLUMN_DEFAULT_VALUE_TYPE, ISM_COLUMN_DEFAULT_VALUE, ISM_COLUMN_SELECT_ITEMS, ISM_COLUMN_CAN_UPDATE_FLAG, ISM_COLUMN_INPUT_ORDER_NUM, ISM_COLUMN_INPUT_FLAG, ISM_COLUMN_OUTPUT_ORDER_NUM, ISM_COLUMN_OUTPUT_FLAG, ISM_COLUMN_OUTPUT_SETTING];
}

- (Model *)newEntity{
    return [[ItemSettingModel alloc]init];
}

@end
