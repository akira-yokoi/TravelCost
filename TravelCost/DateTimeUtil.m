//
//  DateTimeUtil.m
//  TravelCost
//
//  Created by 横井朗 on 2013/10/05.
//  Copyright (c) 2013年 akira yokoi. All rights reserved.
//

#import "DateTimeUtil.h"

@implementation DateTimeUtil

+ (NSDate *) getDate:(double)millis {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: millis];
    return date;
}


+ (NSString *) getYYYYMD:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy/M/d"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getMD:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"M/d"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getD:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"d"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getYYYYMD_HHMMSS:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy/M/d HH:mm:ss"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)adjustTime:(NSDate *)date endDay:(bool) endDay{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy/M/d"];
	NSString *dateStr = [formatter stringFromDate:date];
	NSDate *adjusDate = [formatter dateFromString:dateStr];
    if( endDay){
        // 23:59:59
        NSTimeInterval interval = 60 * 60 * 24 - 1;
        adjusDate = [adjusDate initWithTimeInterval:(interval) sinceDate:adjusDate];
    }
    return adjusDate;
}

+ (NSDateFormatter *) createFormatter:(NSString *) format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    return formatter;
}

@end
