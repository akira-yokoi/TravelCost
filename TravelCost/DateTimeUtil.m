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

+ (NSDate *) getDateFromYYYYMMDD: (NSString *) yyyymmdd{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy/M/d"];
    return [formatter dateFromString:yyyymmdd];
}

+ (NSString *) getYYYYMD:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy/M/d"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getYYYYM:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy/M"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getYYYYM_JP:(NSDate *) date{
    NSDateFormatter *formatter = [DateTimeUtil createFormatter:@"yyyy年M月"];
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

+ (NSDate *)getFirstDayOfMonth:(NSDate *) date{
    // 月初の日付のNSDateを作成する
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components
    = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                  fromDate:date];
    components.day = 1;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

+ (NSDate *) getLastDayOfMonth:(NSDate *) date{
    // 月末の日付のNSDateを作成する
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    int lastDay =  range.length;
    
    NSDateComponents *components
    = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                  fromDate:date];
    components.day = lastDay;
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *) adjustMonth:(NSDate *)date monthCnt:(int) monthCnt{
    // 月初の日付のNSDateを作成する
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components
    = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit
                  fromDate:date];
    components.month += monthCnt;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)adjustTime:(NSDate *)date endDay:(bool) endDay{
    // 月末の日付のNSDateを作成する
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    return [calendar dateFromComponents:components];
}

+ (BOOL) d1_gt_d2:(NSDate *) date1 date2:(NSDate *)date2{
    NSComparisonResult result = [date1 compare:date2];
    
    if( result == NSOrderedDescending){
        return YES;
    }
    return NO;
}

+ (BOOL) d1_ge_d2:(NSDate *) date1 date2:(NSDate *)date2{
    NSComparisonResult result = [date1 compare:date2];
    
    if( result == NSOrderedDescending || result == NSOrderedSame){
        return YES;
    }
    return NO;
}

+ (BOOL) d1_lt_d2:(NSDate *) date1 date2:(NSDate *)date2{
    NSComparisonResult result = [date1 compare:date2];
    
    if( result == NSOrderedAscending){
        return YES;
    }
    return NO;
}

+ (BOOL) d1_le_d2:(NSDate *) date1 date2:(NSDate *)date2{
    NSComparisonResult result = [date1 compare:date2];
    
    if( result == NSOrderedAscending || result == NSOrderedSame){
        return YES;
    }
    return NO;
}

+ (NSDateFormatter *) createFormatter:(NSString *) format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    return formatter;
}

@end
