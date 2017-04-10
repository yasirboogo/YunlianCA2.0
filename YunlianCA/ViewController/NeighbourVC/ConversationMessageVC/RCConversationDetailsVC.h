//
//  RCConversationDetailsVC.h
//  YunlianCA
//
//  Created by QinJun on 16/7/26.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCConversationDetailsVC : RCConversationViewController

@property(nonatomic,assign)BOOL isGroup;
@property(nonatomic,assign)BOOL isPerson;
@property(nonatomic,assign)BOOL isCreateGroup;

@property(nonatomic,strong)NSString *groupId;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *groupImg;


@end
