//
//  UserInfoData.h
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface UserInfoData : NSObject

+(User*)getUserInfoFromArchive;
+(void)saveUserInfoWithUser:(User*)user;

@end
