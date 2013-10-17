//
//  ItemSettingDao.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ItemSettingDao.h"
#import "ItemSettingDao.m"

@implementation ItemSettingDao

+ (NSString *)createTableSql{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@" create table if not exists "];
    [sql appendString: ISM_TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendString:@"   row_id integer primary key autoincrement not null,"];
    [sql appendString:@"   name text not null,"];
    [sql appendString:@"   unit text,"];
    [sql appendString:@"   data_type text,"];
    [sql appendString:@"   input_type text,"];
    [sql appendString:@"   int_length integer,"];
    [sql appendString:@"   decimal_length integer,"];
    [sql appendString:@"   default_value_type text,"];
    [sql appendString:@"   default_value text,"];
    [sql appendString:@"   select_items text,"];
    [sql appendString:@"   can_update_flag bool,"];
    [sql appendString:@"   input_order_num integer,"];
    [sql appendString:@"   input_flag bool,"];
    [sql appendString:@"   output_order_num integer,"];
    [sql appendString:@"   output_flag bool,"];
    [sql appendString:@"   output_setting text"];
    [sql appendString:@" )"];
    return sql;
}

- (id)init{
    self = [ super init];
    clazz = [ItemSettingModel class];
    return self;
}


@end
