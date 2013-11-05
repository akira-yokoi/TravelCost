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

+ (BOOL)isIntNumber: (NSString *)strNumber;

+ (NSString *) toTableName: (NSString *) className;

+ (NSString *) toFieldName: (NSString *) columnName;

+ (NSString *) toColumnName: (NSString *) fieldName;

+ (NSNumber *) toInteger: (NSString *) str;

+ (NSString *) toStringDouble: (double) value;

+ (NSString *) toStringInt: (int) value;

+ (NSString *) toStringLong: (long) value;

+ (NSString *) toStringFloat: (float) value;

+ (NSString *) toStringNumber: (NSNumber *)value;

+ (NSString *) addComma: (int) value;

+ (NSString *) addComma: (double) value decimalLength:(int)decimalLength;

+ (NSString *) addCommaToString:(NSString *) str;

+ (NSString *) addCommaToString:(NSString *) value decimalLength:(int)decimalLength;

+ (NSString *) removeComma: (NSString *) str;

+ (NSString *) replaceAll: (NSString *) target oldStr:(NSString *)oldStr newStr:(NSString *)newStr;

+ (BOOL) contains: (NSString *)value keyword:(NSString *)keyword;

+ (NSString *) killNull: (NSString *) value;

+ (NSArray *) parseCSV: (NSString *) csv;

@end
