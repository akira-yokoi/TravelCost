//
//  ItemValueModel.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ItemValueModel.h"


@implementation ItemValueModel

NSString * const IVM_TABLE_NAME = @"item_value";

NSString * const IVM_COLUMN_ROW_ID = @"row_id";
NSString * const IVM_COLUMN_ITEM_SETTING_ID = @"item_setting_id";
NSString * const IVM_COLUMN_TRAVEL_COST_ID = @"travel_cost_id";
NSString * const IVM_COLUMN_VALUE = @"value";

+ (ItemValueModel *) initFromSetting:(ItemSettingModel *)setting{
    ItemValueModel *value = [[ItemValueModel alloc] init];
    [value setItemSettingId: [setting rowId]];
    return value;
}

- (NSString *)getTableName{
    return IVM_TABLE_NAME;
}

- (NSString *)getIdColumnName{
    return IVM_COLUMN_ROW_ID;
}

- (NSArray *)getValueColumnNames{
    return @[ IVM_COLUMN_ITEM_SETTING_ID, IVM_COLUMN_TRAVEL_COST_ID, IVM_COLUMN_VALUE];
}

- (Model *)newEntity{
    return [[ItemValueModel alloc]init];
}

@end