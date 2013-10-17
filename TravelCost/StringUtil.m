//
//  StringUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/06.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

static NSString * const COLUMN_NAME_SEPARATOR  = @"_";
static NSString * const LARGE_ALPHABET = @"ABCDEFGHIJKLMNOPQRSTUVXWYZ";

+ (BOOL) isEmpty:(NSString *)value{
    if( !value || value.length == 0){
        return YES;
    }
    return NO;
}

+ (BOOL)equals: (NSString *)str1 str2:(NSString *) str2{
    return [str1 isEqualToString:str2];
}


+ (NSString *) toFieldName: (NSString *) columnName{
    NSInteger length = [columnName length];
    
    NSMutableArray *tokens = [[ NSMutableArray alloc] init];
    
    NSUInteger location = 0;

    // "_"で区切って配列につめる
    while( true){
        NSUInteger searchLength = length - location;
        NSRange tokenRange = [ columnName rangeOfString:COLUMN_NAME_SEPARATOR options:0 range:NSMakeRange( location, searchLength)];

        // 見つからなかった場合
        if( tokenRange.location == NSNotFound ){
            // 現在の位置から最後までを追加
            [tokens addObject: [columnName substringWithRange: NSMakeRange(location, length - location)]];
            break;
        }
        else{
            NSRange substringRange = NSMakeRange( location, tokenRange.location - location);
            // 現在のトークンを切り出す
            [tokens addObject: [columnName substringWithRange: substringRange]];
            // 次の検索開始位置を設定
            location = tokenRange.location + tokenRange.length;
        }
    }

    
    // 配列の先頭を大文字にして結合
    NSMutableString *fieldName = [[NSMutableString alloc] init];
    for( int cnt = 0; cnt < [tokens count]; cnt++){
        NSString *token = tokens[ cnt];
        // 0番目はそのまま
        if( cnt == 0){
            [fieldName appendString:token];
        }
        // 2つめ以降は先頭を大文字にして追加
        else{
            [fieldName appendString:[ token capitalizedString]];
        }
    }
     
    return fieldName;
}

+ (NSString *) toTableName: (NSString *) className{
    NSString *classNameWithoutModel = [className stringByReplacingOccurrencesOfString:@"Model" withString:@""];

    NSInteger length = [classNameWithoutModel length];
    
    NSMutableString *tableName = [[NSMutableString alloc] init];
    for( int cnt = 0;cnt < length; cnt++){
        NSRange range = NSMakeRange( cnt, 1);
        NSString *str = [classNameWithoutModel substringWithRange:range];
        
        if( cnt == 0){
            [tableName appendString:[str lowercaseString]];
        }
        else{
            // 大文字かどうかの判定
            BOOL isLarge = [StringUtil contains:LARGE_ALPHABET keyword:str];
            if( isLarge){
                // 大文字だった場合は"_"を追加して、小文字にする
                [tableName appendString:COLUMN_NAME_SEPARATOR];
            }
            [tableName appendString:[str lowercaseString]];
        }
    }
    return tableName;
}

+ (NSString *) toColumnName: (NSString *) fieldName{
    NSInteger length = [fieldName length];

    NSMutableString *columnName = [[NSMutableString alloc] init];
    for( int cnt = 0;cnt < length; cnt++){
        NSRange range = NSMakeRange( cnt, 1);
        NSString *str = [fieldName substringWithRange:range];
        // 大文字かどうかの判定
        BOOL isLarge = [StringUtil contains:LARGE_ALPHABET keyword:str];
        if( !isLarge || cnt == 0){
            [columnName appendString:str];
        }
        else{
            // 大文字だった場合は"_"を追加して、小文字にする
            [columnName appendString:COLUMN_NAME_SEPARATOR];
            [columnName appendString:[str lowercaseString]];
        }
        
    }
    return columnName;
}

+ (NSString *) toStringDouble: (double) value{
    return [NSString stringWithFormat:@"%g", value];
}

+ (NSString *) toStringInt: (int) value{
    return [NSString stringWithFormat:@"%d", value];
}

+ (NSString *) toStringFloat: (float) value{
    return [NSString stringWithFormat:@"%g", value];
}

+ (NSString *) toStringNumber: (NSNumber *)value{
    return [value stringValue];
}

+ (NSString *) addComma:(int) value{
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    [format setGroupingSeparator:@","];
    [format setGroupingSize:3];
    return [format stringForObjectValue:[NSNumber numberWithInt:value]];
}

+ (BOOL) contains:(NSString *)value keyword:(NSString *)keyword{
    if([value rangeOfString:keyword].location == NSNotFound){
        return NO;
    }else{
        return YES;
    }
}

+ (NSString *) killNull: (NSString *) value{
    if( value == nil || [value isEqual:[NSNull null]]){
        return @"";
    }
    return value;
}

@end
