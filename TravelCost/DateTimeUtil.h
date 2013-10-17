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

+ (NSString *) getYYYYMD:(NSDate *) date;
+ (NSString *) getMD:(NSDate *) date;
+ (NSString *) getD:(NSDate *) date;

+ (NSString *) getYYYYMD_HHMMSS:(NSDate *) date;

+ (NSDate *)adjustTime:(NSDate *)date endDay:(bool) endDay;

@end
