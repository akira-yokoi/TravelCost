//
//  StringUtil.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/06.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

+ (BOOL)isEmpty: (NSString *)value;

+ (BOOL)equals: (NSString *)str1 str2:(NSString *) str2;

+ (NSString *) toTableName: (NSString *) className;

+ (NSString *) toFieldName: (NSString *) columnName;

+ (NSString *) toColumnName: (NSString *) fieldName;

+ (NSString *) toStringDouble: (double) value;

+ (NSString *) toStringInt: (int) value;

+ (NSString *) toStringFloat: (float) value;

+ (NSString *) toStringNumber: (NSNumber *)value;

+ (NSString *) addComma: (int) value;

+ (BOOL) contains: (NSString *)value keyword:(NSString *)keyword;

+ (NSString *) killNull: (NSString *) value;

@end
