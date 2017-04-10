//
//  ZYContact.m
//  AddressBook 分组 排序
//
//  Created by Shuaiqi Xue on 14-9-11.
//  Copyright (c) 2014年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYContact.h"

@implementation ZYContact

- (NSComparisonResult)compare:(ZYContact *)contact
{
    if (self.name.length>contact.name.length)
    {
        return NSOrderedAscending;
    }
    else if (self.name.length < contact.name.length)
    {
        return NSOrderedDescending;
    }
    else
        return NSOrderedSame;
}

@end
