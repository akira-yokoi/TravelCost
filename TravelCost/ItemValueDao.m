//
//  ItemValueDao.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ItemValueDao.h"

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

@end
