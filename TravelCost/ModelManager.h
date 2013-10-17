//
//  ReflectionUtil.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/09.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import "StringUtil.h"

@interface ModelManager : NSObject

+ (ModelManager *) instance;

- (void) addModel:(Class) clazz;

- (NSString *) getTableName: (Class) clazz;

- (NSString *) getIdColumnName: (Class) clazz;

- (NSArray *) getAllColumnName: (Class) clazz;

- (NSArray *) getValueColumnName: (Class) clazz;

- (BOOL) isDate:(Class) clazz fieldName: (NSString *)fieldName;

@end
