//
//  DateTimeUtil.h
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtil : NSObject

+ (NSDate *) getDate:(double)millis;
+ (NSDate *) getDateFromYYYYMMDD: (NSString *) yyyymmdd;
    
+ (NSString *) getYYYYMD:(NSDate *) date;
+ (NSString *) getMD:(NSDate *) date;
+ (NSString *) getD:(NSDate *) date;

+ (NSString *) getYYYYMD_HHMMSS:(NSDate *) date;

+ (NSDate *)adjustTime:(NSDate *)date endDay:(bool) endDay;


+ (BOOL) d1_gt_d2:(NSDate *) date1 date2:(NSDate *)date2;

+ (BOOL) d1_ge_d2:(NSDate *) date1 date2:(NSDate *)date2;

+ (BOOL) d1_lt_d2:(NSDate *) date1 date2:(NSDate *)date2;

+ (BOOL) d1_le_d2:(NSDate *) date1 date2:(NSDate *)date2;

@end
