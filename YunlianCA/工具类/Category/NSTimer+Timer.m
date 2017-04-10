//
//  NSTimer+Timer.m
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "NSTimer+Timer.h"

@implementation NSTimer (Timer)


-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}




@end
