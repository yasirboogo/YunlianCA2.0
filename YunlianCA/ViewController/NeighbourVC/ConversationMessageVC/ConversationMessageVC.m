//
//  ConversationMessageVC.m
//  ZZQ
//
//  Created by QinJun on 16/5/25.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ConversationMessageVC.h"

#import "RCConversationDetailsVC.h"

@interface ConversationMessageVC ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource>





@end

@implementation ConversationMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupUserInfoDataSource:self];
    
    
    //设置在列表中需要显示的会话类型
    [self setDisplayConversationTypes:@[[NSNumber numberWithInt:ConversationType_PRIVATE],[NSNumber numberWithInt:ConversationType_GROUP]]];
    
    self.conversationListTableView.tableFooterView=[[UIView alloc]init];
    
    //自定义空会话的背景View。当会话列表为空时，将显示该View
    UIView *blankView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blankView.backgroundColor=COLOR_WHITE;
    self.emptyConversationView=blankView;
    
    UILabel *blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(150), SCREEN_WIDTH-WZ(15*2), WZ(30))];
    blankLabel.text=@"暂无聊天信息";
    blankLabel.textColor=COLOR_LIGHTGRAY;
    blankLabel.textAlignment=NSTextAlignmentCenter;
    blankLabel.font=FONT(17, 15);
    [blankView addSubview:blankLabel];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    keyManager.enable = NO;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL)
    {
        RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
        conversationVC.conversationType=model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        conversationVC.enableUnreadMessageIcon=YES;
        conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        if (model.conversationType==ConversationType_GROUP)
        {
            conversationVC.isGroup=YES;
        }
        if (model.conversationType==ConversationType_PRIVATE)
        {
            conversationVC.isPerson=YES;
        }
        
    }
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion
{
//    NSLog(@"消息列表的用户id===%@",userId);
    //判断是否为自己用户ID
    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
    {
        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
        userInfo.userId = [NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId];
        userInfo.name = [UserInfoData getUserInfoFromArchive].nickname;
        
        NSString *imgUrlString=[UserInfoData getUserInfoFromArchive].headImage;
        NSString *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=imgUrlString;
        }
        else
        {
            imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
        }
        userInfo.portraitUri=imgUrl;
        
        completion(userInfo);
        return ;
    }
    else
    {
        //此处根据userid获取用户昵称和头像
        [HTTPManager getUserInfoWithUserId:userId complete:^(User *user) {
            if ([user.result isEqualToString:STATUS_SUCCESS])
            {
                NSString *imgUrlString=user.headImage;
                NSString *imgUrl;
                if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
                {
                    imgUrl=imgUrlString;
                }
                else
                {
                    imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
                }
                
                RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:user.nickname portrait:imgUrl];
                if (userInfo)
                {
                    completion(userInfo);
                }
                else
                {
                    completion(nil);
                }
            }
        }];
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion
{
//    NSLog(@"消息列表的群id===%@",groupId);
    [HTTPManager groupInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *groupInfoDict=[resultDict objectForKey:@"imGroup"];
            NSString *groupId=[NSString stringWithFormat:@"%@",[groupInfoDict objectForKey:@"id"]];
            NSString *groupName=[groupInfoDict objectForKey:@"name"];
            NSString *groupImg=[groupInfoDict objectForKey:@"img"];
            
            RCGroup *groupInfo=[[RCGroup alloc]initWithGroupId:groupId groupName:groupName portraitUri:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,groupImg]];
            
            completion(groupInfo);
        }
    }];
}

- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *userInfo))completion
{
    if (![userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
    {
        [HTTPManager groupInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                NSDictionary *listDict=[resultDict objectForKey:@"list"];
                NSArray *userArray=[listDict objectForKey:@"data"];
                
                for (NSInteger i=0; i<userArray.count; i++)
                {
                    NSDictionary *userDict=userArray[i];
                    NSString *userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
                    NSString *nickname=[userDict objectForKey:@"nickname"];
                    NSString *headimg=[userDict objectForKey:@"headimg"];
                    
                    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:nickname portrait:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]];
                    completion(userInfo);
                }
            }
        }];
    }
    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
    {
        User *myUserInfo=[UserInfoData getUserInfoFromArchive];
        
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:myUserInfo.userId name:myUserInfo.nickname portrait:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,myUserInfo.headImage]];
        completion(userInfo);
    }
}




-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(70);
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
