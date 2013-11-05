//
//  ReflectionUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager
{
    // key=クラス名、value=テーブル名
    NSMutableDictionary *classTableNameMap;
    
    // key=クラス名、value=NSDictionary( Key=プロパティ名, Value=attribute)
    NSMutableDictionary *classPropertyMap;
    
    // key=クラス名、NSArray(カラム名)
    NSMutableDictionary *classColumnNameMap;
    
    // key=クラス名、NSArray(カラム名)
    NSMutableDictionary *classValueColumnNameMap;
}

static ModelManager *sharedInstance = nil;
static NSString * const COLUMN_ROW_ID  = @"row_id";
static NSString * const COLUMN_INVALID_PRFFIX  = @"_";

+ (ModelManager *)instance{
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init{
    self = [super init];
    
    if( self){
        classTableNameMap = [[NSMutableDictionary alloc] init];
        classPropertyMap = [[NSMutableDictionary alloc] init];
        classColumnNameMap = [[NSMutableDictionary alloc] init];
        classValueColumnNameMap = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void) addModel:(Class) clazz{
    // クラス名とテーブル名のマップ
    NSString *className = [NSString stringWithUTF8String:class_getName( clazz)];
    NSString *tableName = [StringUtil toTableName:className];
    [classTableNameMap setObject:tableName forKey:className];

    NSMutableDictionary *propertyMap = [classPropertyMap valueForKey: className];
    
    // キャッシュになければ新たに作成
    if( propertyMap == nil){
        // プロパティ情報のマップ
        propertyMap = [NSMutableDictionary dictionaryWithCapacity:0];
        [classPropertyMap setObject:propertyMap forKey:className];
        
        // カラム名のマップ
        NSMutableArray *columnNames = [[NSMutableArray alloc] init];
        [classColumnNameMap setObject:columnNames forKey:className];

        // 値カラム名のマップ
        NSMutableArray *valueColumnNames = [[NSMutableArray alloc] init];
        [classValueColumnNameMap setObject:valueColumnNames forKey:className];
        
        unsigned int outCount, i;
        objc_property_t *props = class_copyPropertyList(clazz, &outCount);
        for(i = 0; i < outCount; i++) {
            objc_property_t property = props[i];
            const char *propName = property_getName(property);
            const char *attribute = property_getAttributes(property);
            
            if(propName) {
                NSString *propertyName = [NSString stringWithUTF8String:propName];
                NSString *propertyType = [NSString stringWithUTF8String:attribute];
                NSString *columnName = [StringUtil toColumnName:propertyName];
                
               if(! [propertyName hasPrefix:COLUMN_INVALID_PRFFIX]){
                    [columnNames addObject:columnName];
                    if( [StringUtil equals:columnName str2: COLUMN_ROW_ID]){
                        [valueColumnNames addObject:columnName];
                    }
                    [propertyMap setObject:propertyType forKey:propertyName];
                }
            }
        }
        free(props);
    }
}

- (NSString *) getIdColumnName:(Class)clazz{
    return COLUMN_ROW_ID;
}

- (NSString *) getTableName:(Class)clazz{
    NSString *className = [NSString stringWithUTF8String:class_getName( clazz)];
    return [classTableNameMap valueForKey:className];
}

- (NSArray *) getAllColumnName: (Class) clazz{
    NSString *className = [NSString stringWithUTF8String:class_getName( clazz)];
    return [classColumnNameMap valueForKey:className];
}

- (NSArray *) getValueColumnName: (Class) clazz{
    NSString *className = [NSString stringWithUTF8String:class_getName( clazz)];
    return [classValueColumnNameMap valueForKey:className];
}

- (BOOL) isDate:(Class) clazz fieldName: (NSString *)fieldName{
    NSString *className = [NSString stringWithUTF8String:class_getName( clazz)];
    NSMutableDictionary *propertyMap = [classPropertyMap valueForKey: className];
    NSString *attribute = [propertyMap valueForKey:fieldName];
    return [StringUtil contains:attribute keyword:@"NSDate"];
}

@end
