//
//  SingleEntityDao.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/04.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "Dao.h"

#import "DatabaseManager.h"
#import "ModelManager.h"
#import "StringUtil.h"
#import "ModelManager.h"
#import "ReflectionUtil.h"

@implementation Dao
{
    NSMutableDictionary *columnFieldNameMap;
    ModelManager *modelManager;
}

-(id) init{
    self = [super init];
    columnFieldNameMap = [[NSMutableDictionary alloc] init];
    modelManager = [ModelManager instance];
    return self;
}


- (Model *) load: (NSNumber *)modelId{
    NSMutableString *where = [[NSMutableString alloc] init];
    [ where appendString: [modelManager getIdColumnName: clazz]];
    [ where appendString:@" = "];
    [ where appendString: [ StringUtil toStringNumber:modelId] ];

    NSMutableArray *list = [self list: where order:nil];
    if( list.count != 0){
        return list[ 0];
    }
    return nil;
}

/**
 * テーブルの存在チェック
 */
- (BOOL) existTable{
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];
    [fmdb open];
    
    NSString *tableName = [modelManager getTableName: clazz];
    NSString *query = [NSString stringWithFormat: @"select count(*) from sqlite_master where type='table' and name = %@", tableName];
    FMResultSet *resultSet = [fmdb executeQuery: query];
    
    BOOL existTable = NO;
    while ([resultSet next]) {
        existTable = [resultSet boolForColumnIndex:0];
    }
    [fmdb close];
    return existTable;
}

/**
 * テーブルの行数カウント
 */
- (int) getCount{
    NSString *tableName = [modelManager getTableName: clazz];
    
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];
    [fmdb open];
    
    NSString *query = [NSString stringWithFormat: @"select count(*) from %@", tableName];
    FMResultSet *resultSet = [fmdb executeQuery: query];
    
    int rowCount = 0;
    while ([resultSet next]) {
        rowCount = [resultSet intForColumnIndex:0];
    }
    [fmdb close];
    return rowCount;
}

- (int) getMax:(NSString *) columnName{
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];
    [fmdb open];
    
    int result = [self getMax:columnName db:fmdb];
    
    [fmdb close];
    return result;
}

- (int) getMax:(NSString *) columnName db:(FMDatabase *)fmdb{
    NSString *tableName = [modelManager getTableName: clazz];
    
    NSString *query = [NSString stringWithFormat: @"select max(%@) from %@", columnName, tableName];
    FMResultSet *resultSet = [fmdb executeQuery: query];
    
    // 検索結果の取得
    int result = 0;
    while ([resultSet next]) {
        result = [resultSet intForColumnIndex:0];
    }
    return result;
}


- (NSMutableArray *) list: (NSString *)where order:(NSString *)order{
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];
    [fmdb open];
    
    // 全カラム検索の実行
    NSString *tableName = [modelManager getTableName:clazz];
    NSMutableArray *allColumnNames = [[NSMutableArray alloc] init];
    [allColumnNames addObjectsFromArray:[modelManager getAllColumnName:clazz]];
    NSString *valueKey = [allColumnNames componentsJoinedByString:@","];
    
    NSMutableString *query = [[NSMutableString alloc] init];
    [ query appendFormat:@"select %@ from %@", valueKey, tableName];
    
    if( ![StringUtil isEmpty: where] ){
        [ query appendFormat:@" where %@", where];
    }
    if( ![StringUtil isEmpty: order] ){
        [ query appendFormat:@" order by %@", order];
    }
    
    FMResultSet *resultSet = [fmdb executeQuery: query];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        Model *model = [clazz new];
        Class modelClass = [model class];
        
        for (NSString *columnName in allColumnNames){
            id value = [resultSet objectForColumnName:columnName];
            // カラム名をフィールド名に変換して値を設定
            NSString *fieldName = [StringUtil toFieldName:columnName];
            
            // 日付かどうかの判定
            BOOL isDate = [modelManager isDate:modelClass fieldName:fieldName];
            if( isDate){
                double dValue = (double) [value doubleValue];
                [model setValue: [NSDate dateWithTimeIntervalSince1970:dValue] forKey:fieldName];
            }
            else{
                [model setValue:value forKey: fieldName];
            }
        }
        [result addObject:model];
    }
    [fmdb close];
    return result;
}

- (NSMutableArray *) list{
    return [self list: nil order:nil];
}

- (BOOL) saveModel:( Model *)model{
    NSArray *models = @[ model];
    return [self saveModels:models];
}

- (BOOL) saveModels:( NSArray *)models{
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];

    [fmdb open];
    [fmdb beginTransaction];
    
    BOOL isSuccess = YES;
    
    for( Model *model in models){
        // PK名
        NSString *idColumnName = [model getIdColumnName];
        // 値のカラム名
        NSArray *valueColumnNames = [model getValueColumnNames];
        
        // PKの値
        NSNumber *rowId = [model valueForKey:[ StringUtil toFieldName: idColumnName]];
        NSArray *values = [self getValues:model columnNames:valueColumnNames];

        if( rowId == nil){
            NSString *sql = [self createInsertSql:model];
            
            if(! [fmdb executeUpdate:sql withArgumentsInArray:values]){
                isSuccess = NO;
            }
        }
        else{
            NSString *sql = [self createUpdateSql:model];
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



- (BOOL) deleteModel:( Model *)model{
    NSArray *models = @[ model];
    return [self deleteModels:models];
}

- (BOOL) deleteModels:( NSArray *)models{
    DatabaseManager *db = [DatabaseManager instance];
    FMDatabase *fmdb = [db connect];
    
    [fmdb open];
    [fmdb beginTransaction];
    
    BOOL isSuccess = YES;
    
    for( Model *model in models){
        // PK名
        NSString *idColumnName = [model getIdColumnName];
        
        // PKの値
        NSNumber *rowId = [model valueForKey:[ StringUtil toFieldName: idColumnName]];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        if( rowId != nil){
            NSString *deleteSql = [self createDeleteSql:model];
            [ values addObject:rowId];
            
            if(! [fmdb executeUpdate:deleteSql withArgumentsInArray:values]){
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


-( NSArray *) getValues:(Model *)model columnNames:(NSArray *)columnNames{
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:columnNames.count];
    
    for( NSString *columnName in columnNames){
        
        // カラム名をフィールド名に変換して値を設定
        NSString *fieldName = [StringUtil toFieldName:columnName];
        id value = [model valueForKey:fieldName];
        if( value != nil){
            if( [ReflectionUtil instanceof:value class:[NSDate class]]){
                NSDate *date = (NSDate *)value;
                NSTimeInterval interval = [date timeIntervalSince1970];
                NSNumber *dateNumber = [NSNumber numberWithDouble:(double)interval];
                [values addObject: dateNumber];
            }
            else{
                [values addObject:value];
            }
        }
        else{
            [values addObject:[NSNull null]];
        }
    }
    
    return values;
}

-( NSString *) createInsertSql:(Model *)model{
    // テーブル名
    NSString *tableName = [model getTableName];
    // 値のカラム名
    NSArray *valueColumnNames = [model getValueColumnNames];
    
    // Insert
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString: @" insert into "];
    [sql appendString: tableName];
    [sql appendString: @" ( "];
    // カラム名
    [sql appendString: [self createValueName:valueColumnNames]];
    [sql appendString: @" ) "];
    [sql appendString: @" values ( "];
    // 値に置換する?
    [sql appendString: [self createValueParam:valueColumnNames]];
    [sql appendString: @" )"];
    return sql;
}

-( NSString *) createUpdateSql:(Model *)model{
    // テーブル名
    NSString *tableName = [model getTableName];
    // PK名
    NSString *idColumnName = [model getIdColumnName];
    // 値のカラム名
    NSArray *valueColumnNames = [model getValueColumnNames];
    
    // Update
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString: @" update "];
    [sql appendString: tableName];
    [sql appendString: @" set "];
    // カラム名
    for( int cnt = 0; cnt < valueColumnNames.count; cnt++){
        [sql appendString: valueColumnNames[ cnt]];
        [sql appendString: @" = ? "];
        if( cnt != valueColumnNames.count - 1){
            [sql appendString:@","];
        }
    }
    [sql appendString: @" where "];
    [sql appendString: idColumnName];
    [sql appendString: @" = ? "];
    return sql;
}

-( NSString *) createDeleteSql:(Model *)model{
    // テーブル名
    NSString *tableName = [model getTableName];
    // PK名
    NSString *idColumnName = [model getIdColumnName];
    
    return [NSString stringWithFormat:@"delete from %@ where %@ = ?", tableName, idColumnName];
}

-( NSString *) createValueName: (NSArray *)valueColumnNames{
    return [valueColumnNames componentsJoinedByString:@","];
}

-( NSString *) createValueParam: (NSArray *)valueColumnNames{
    NSMutableString *result = [[NSMutableString alloc] init];
    for( NSString *columnName in valueColumnNames){
        [result appendString: @"?"];
        if( ![columnName isEqualToString:valueColumnNames.lastObject]){
            [result appendString: @","];
        }
    }
    return result;
}
@end
