//
//  UserInfoData.m
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "UserInfoData.h"

@implementation UserInfoData

//获取用户信息
+(User*)getUserInfoFromArchive
{
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userInfo.plist"];
    
    NSData *data=[NSData dataWithContentsOfFile:filePath];
    //根据读出的本地data创建反序列化器
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    //反序列化器解码data
    User *user=[unarchiver decodeObject];
    //结束解码
    [unarchiver finishDecoding];
    
    return user;
}

//存储用户信息
+(void)saveUserInfoWithUser:(User*)user
{
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
    //创建一个序列化器
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //开始编码文件
    [archiver encodeObject:user];
    //结束编码
    [archiver finishEncoding];
    
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userInfo.plist"];
    [data writeToFile:filePath atomically:YES];
    
}





@end
