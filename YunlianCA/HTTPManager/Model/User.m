//
//  User.m
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "User.h"

@implementation User

+(User*)user
{
    User *user=[[User alloc]init];
    return user;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.randCode forKey:@"randCode"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.sign forKey:@"sign"];
    [aCoder encodeObject:self.acceptAddress forKey:@"acceptAddress"];
    [aCoder encodeObject:self.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.headImage forKey:@"headImage"];
    [aCoder encodeObject:self.result forKey:@"result"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.areaId forKey:@"areaId"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.explain forKey:@"explain"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.mark forKey:@"mark"];
    [aCoder encodeObject:self.supId forKey:@"supId"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.xqId forKey:@"xqId"];
    [aCoder encodeObject:self.error forKey:@"error"];
    [aCoder encodeObject:self.brokerage forKey:@"brokerage"];
    [aCoder encodeObject:self.userMoney forKey:@"userMoney"];
    [aCoder encodeObject:self.areaName forKey:@"areaName"];
    [aCoder encodeObject:self.smaAreaName forKey:@"smaAreaName"];
    [aCoder encodeObject:self.isMerchant forKey:@"isMerchant"];
    [aCoder encodeObject:self.ylToken forKey:@"ylToken"];
    [aCoder encodeObject:self.ylCardNo forKey:@"ylCardNo"];
    [aCoder encodeObject:self.ylPayPass forKey:@"ylPayPass"];
    [aCoder encodeObject:self.ylTime forKey:@"ylTime"];
    [aCoder encodeObject:self.merchantId forKey:@"merchantId"];
    [aCoder encodeObject:self.msg forKey:@"msg"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.isPush forKey:@"isPush"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.vipName forKey:@"vipName"];
    [aCoder encodeObject:self.isChangeArea forKey:@"isChangeArea"];
    [aCoder encodeObject:self.changeAreaName forKey:@"changeAreaName"];
    [aCoder encodeObject:self.changeXqName forKey:@"changeXqName"];
    [aCoder encodeObject:self.referrer forKey:@"referrer"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self)
    {
        self.mobile=[aDecoder decodeObjectForKey:@"mobile"];
        self.nickname=[aDecoder decodeObjectForKey:@"nickname"];
        self.randCode=[aDecoder decodeObjectForKey:@"randCode"];
        self.password=[aDecoder decodeObjectForKey:@"password"];
        self.userId=[aDecoder decodeObjectForKey:@"userId"];
        self.sex=[aDecoder decodeObjectForKey:@"sex"];
        self.sign=[aDecoder decodeObjectForKey:@"sign"];
        self.acceptAddress=[aDecoder decodeObjectForKey:@"acceptAddress"];
        self.longitude=[aDecoder decodeObjectForKey:@"longitude"];
        self.latitude=[aDecoder decodeObjectForKey:@"latitude"];
        self.headImage=[aDecoder decodeObjectForKey:@"headImage"];
        self.result=[aDecoder decodeObjectForKey:@"result"];
        self.address=[aDecoder decodeObjectForKey:@"address"];
        self.areaId=[aDecoder decodeObjectForKey:@"areaId"];
        self.code=[aDecoder decodeObjectForKey:@"code"];
        self.createTime=[aDecoder decodeObjectForKey:@"createTime"];
        self.explain=[aDecoder decodeObjectForKey:@"explain"];
        self.username=[aDecoder decodeObjectForKey:@"username"];
        self.mark=[aDecoder decodeObjectForKey:@"mark"];
        self.supId=[aDecoder decodeObjectForKey:@"supId"];
        self.type=[aDecoder decodeObjectForKey:@"type"];
        self.token=[aDecoder decodeObjectForKey:@"token"];
        self.xqId=[aDecoder decodeObjectForKey:@"xqId"];
        self.error=[aDecoder decodeObjectForKey:@"error"];
        self.brokerage=[aDecoder decodeObjectForKey:@"brokerage"];
        self.userMoney=[aDecoder decodeObjectForKey:@"userMoney"];
        self.areaName=[aDecoder decodeObjectForKey:@"areaName"];
        self.smaAreaName=[aDecoder decodeObjectForKey:@"smaAreaName"];
        self.isMerchant=[aDecoder decodeObjectForKey:@"isMerchant"];
        self.ylToken=[aDecoder decodeObjectForKey:@"ylToken"];
        self.ylCardNo=[aDecoder decodeObjectForKey:@"ylCardNo"];
        self.ylPayPass=[aDecoder decodeObjectForKey:@"ylPayPass"];
        self.ylTime=[aDecoder decodeObjectForKey:@"ylTime"];
        self.merchantId=[aDecoder decodeObjectForKey:@"merchantId"];
        self.msg=[aDecoder decodeObjectForKey:@"msg"];
        self.status=[aDecoder decodeObjectForKey:@"status"];
        self.isPush=[aDecoder decodeObjectForKey:@"isPush"];
        self.state=[aDecoder decodeObjectForKey:@"state"];
        self.vipName=[aDecoder decodeObjectForKey:@"vipName"];
        self.isChangeArea=[aDecoder decodeObjectForKey:@"isChangeArea"];
        self.changeAreaName=[aDecoder decodeObjectForKey:@"changeAreaName"];
        self.changeXqName=[aDecoder decodeObjectForKey:@"changeXqName"];
        self.referrer=[aDecoder decodeObjectForKey:@"referrer"];
        
        
    }
    return self;
    
}


@end
