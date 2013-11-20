//
//  ItemValueDao.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ItemValueDao.h"

#import "StringUtil.h"

@implementation ItemValueDao

+ (NSString *)createTableSql{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@" create table if not exists "];
    [sql appendString: IVM_TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendString:@"   row_id integer primary key autoincrement not null,"];
    [sql appendString:@"   item_setting_id integer not null,"];
    [sql appendString:@"   travel_cost_id integer not null,"];
    [sql appendString:@"   value text"];
    [sql appendString:@" )"];
    return sql;
}

- (id)init{
    self = [ super init];
    clazz = [ItemValueModel class];
    return self;
}

- (NSArray *) getValueModels: (int) travelCostId{
    NSString *where = [NSString stringWithFormat: @"%@='%d'", IVM_COLUMN_TRAVEL_COST_ID, travelCostId];
    NSArray *valueModels = [ self list:where order:nil];
    return valueModels;
}

- (NSString *)getHistoryValues: (int) itemSettingId{
    NSString *where = [NSString stringWithFormat: @"%@='%d' and value != '' and value is not null order by %@ limit 10", IVM_COLUMN_ITEM_SETTING_ID, itemSettingId, IVM_COLUMN_ROW_ID];
    NSArray *valueModels = [ self list:where order:nil];
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    for( ItemValueModel *valueModel in valueModels){
        [valueArray addObject:valueModel.value];
    }
    NSString *csvValue = [StringUtil createCSV:valueArray];
    return csvValue;
}

@end
