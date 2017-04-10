
//
//  Model.m
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (id)model
{
    return [[self alloc] init];
}

+ (id)modelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        
        
        
    }
    return self;
}

@end
