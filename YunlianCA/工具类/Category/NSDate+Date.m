//
//  NSDate+Date.m
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)


/// 1.1 获取一个自定义的时间
+ (NSDate *)getDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    return date;
}
+ (NSDate *)getDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    return date;
}

/// 获取指定格式的显示时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)getStringFromDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}



//程序中使用的，将日期显示成  2011年4月4日 星期一
- (NSString *)Date2Str
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
    dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
    return [dateFormatter stringFromDate:self];
}
// 程序中使用的，将日期显示成  2011-4-4
- (NSString *)Date3Str
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self];
}

/// 获取当前日期的字符串： yyyyMMddHHmmss
+ (NSString *)dateFormatString_Type02
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyyMMddHHmmss";
    NSString *time = [dateFormat stringFromDate:date];
    
    return time;
}

/// 获取当前日期的字符串： yyyy-MM-dd HH:mm:ss
+ (NSString *)dateFormatString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [dateFormat stringFromDate:date];
    
    return time;
}








@end
