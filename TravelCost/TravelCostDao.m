//
//  TravelCostDao.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "TravelCostDao.h"

@implementation TravelCostDao

+ (NSString *)createTableSql{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@" create table if not exists "];
    [sql appendString: TCM_TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendString:@"   row_id integer primary key autoincrement not null,"];
    [sql appendString:@"   date real not null,"];
    [sql appendString:@"   trans_type text,"];
    [sql appendString:@"   ride_location text,"];
    [sql appendString:@"   drop_off_location text,"];
    [sql appendString:@"   one_way text,"];
    [sql appendString:@"   amount integer,"];
    [sql appendString:@"   favorite_order integer"];
    [sql appendString:@" )"];
    return sql;
}

- (id)init{
    self = [ super init];
    clazz = [TravelCostModel class];
    return self;
}

- (BOOL) saveTravelCost: (TravelCostModel *)costModel values:(NSArray *)values{
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];
    
    [fmdb open];
    [fmdb beginTransaction];
    
    BOOL isSuccess = YES;

    // PK名
    NSString *idColumnName = [costModel getIdColumnName];

    // PKの値
    NSNumber *travelCostId = [costModel valueForKey:[ StringUtil toFieldName: idColumnName]];

    // TravelCostModelの保存
    {
        // 値のカラム名
        NSArray *valueColumnNames = [costModel getValueColumnNames];
        NSArray *values = [super getValues:costModel columnNames:valueColumnNames];
        if( travelCostId == nil){
            NSString *sql = [super createInsertSql:costModel];
            
            if( [fmdb executeUpdate:sql withArgumentsInArray:values]){
                travelCostId = [NSNumber numberWithInt:[self getMax:idColumnName db:fmdb]];
            }
            else{
                isSuccess = NO;
            }
        }
        else{
            NSString *sql = [super createUpdateSql:costModel];
            NSMutableArray *updateValues = [NSMutableArray arrayWithArray:values];
            [updateValues addObject:travelCostId];
            
            if(! [fmdb executeUpdate:sql withArgumentsInArray:updateValues]){
                isSuccess = NO;
            }
        }
    }
    
    for( ItemValueModel *model in values){
        model.travelCostId = travelCostId;
        
        // PK名
        NSString *idColumnName = [model getIdColumnName];
        
        // PK名
        NSArray *valueColumnNames = [model getValueColumnNames];
        
        // 値のカラム名
        NSArray *values = [super getValues:model columnNames:valueColumnNames];
        
        // PKの値
        NSNumber *rowId = [model valueForKey:[ StringUtil toFieldName: idColumnName]];
        
        if( rowId == nil){
            NSString *sql = [super createInsertSql:model];
            
            if(! [fmdb executeUpdate:sql withArgumentsInArray:values]){
                isSuccess = NO;
            }
        }
        else{
            NSString *sql = [super createUpdateSql:model];
            // 更新の場合はパラメータにrowIdを追加
            NSMutableArray *updateValues = [NSMutableArray arrayWithArray: values];
            [ updateValues addObject:rowId];
            
            if(! [fmdb executeUpdate:sql withArgumentsInArray:updateValues]){
                isSuccess = NO;
            }
        }
    }
    
    if( isSuccess){
        [fmdb commit];
    }
    else{
        [fmdb rollback];
    }
    
    [fmdb close];
    return isSuccess;
}

@end
