//
//  NSDate+Date.h
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date)


/// 获取一个自定义的时间
+ (NSDate *)getDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;
+ (NSDate *)getDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second;

/// 获取指定格式的显示时间 yyyy-MM-dd HH:mm:ss
+ (NSString *)getStringFromDate:(NSDate *)date format:(NSString *)format;


/// 1.2程序中使用的，将日期显示成  2011年4月4日 星期一
- (NSString *)Date2Str;

/// 程序中使用的，将日期显示成  2011-4-4
- (NSString *)Date3Str;

/// 获取当前日期的字符串： yyyyMMddHHmmss
+ (NSString *)dateFormatString_Type02;

/// 获取当前日期的字符串： yyyy-MM-dd HH:mm:ss
+ (NSString *)dateFormatString;









@end
