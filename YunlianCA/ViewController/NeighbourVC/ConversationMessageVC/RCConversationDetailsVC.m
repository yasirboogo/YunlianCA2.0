//
//  RCConversationDetailsVC.m
//  YunlianCA
//
//  Created by QinJun on 16/7/26.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RCConversationDetailsVC.h"

#import "MyselfViewController.h"
#import "UserInfoViewController.h"
#import "GroupDetailViewController.h"
#import "NeighbourViewController.h"

@interface RCConversationDetailsVC ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource,RCIMGroupMemberDataSource>//
{
    NSMutableDictionary * _groupUserInfoDic;
}
@end

@implementation RCConversationDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加清除历史消息的监听者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearConversation) name:@"clearConversation" object:nil];
    
    if (self.isGroup==YES)
    {
        //群组信息提供者
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupUserInfoDataSource:self];
    }
    else
    {
        //用户信息提供者代理
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    }
    
    
    [self createNavigationBar];
    

}

-(void)clearConversation
{
    [self.conversationDataRepository removeAllObjects];
    //刷新界面
    [self.conversationMessageCollectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
}

-(void)createNavigationBar
{
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+22), WZ(10), WZ(22), WZ(24))];
    [rightBtn setBackgroundImage:IMAGE(@"linju_qunxiangqing") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    NSLog(@"聊天界面用户id===%@",userId);
    if (![userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
    {
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
                RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:user.userId name:user.nickname portrait:imgUrl];
                completion(userInfo);
            }
        }];
    }else{
        User *myUserInfo=[UserInfoData getUserInfoFromArchive];
        NSString *imgUrlString=myUserInfo.headImage;
        NSString *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=imgUrlString;
        }
        else
        {
            imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
        }
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:myUserInfo.userId name:myUserInfo.nickname portrait:imgUrl];
        completion(userInfo);
    }
    
}

- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    if (!_groupUserInfoDic) {
        [self getGroupInfoWithgroupId:groupId complete:^(NSMutableDictionary *resultDict) {
             NSDictionary * dic = [_groupUserInfoDic objectForKey:userId];
            if (dic) {
                RCUserInfo* userInfo= [self getUserInfoWithDic:dic];
                completion(userInfo);
            }else{
                [self.view makeToast:@"获取成员信息失败，请退出聊天界面重新尝试" duration:2];
            }
        }];
        
    }else if(_groupUserInfoDic.count>0){
        NSDictionary * dic = [_groupUserInfoDic objectForKey:userId];
        if (dic) {
            RCUserInfo* userInfo= [self getUserInfoWithDic:dic];
            completion(userInfo);
        }else{
             [self getGroupInfoWithgroupId:groupId complete:^(NSMutableDictionary *resultDict) {
                  NSDictionary * dic = [_groupUserInfoDic objectForKey:userId];
                 if (dic) {
                     RCUserInfo* userInfo= [self getUserInfoWithDic:dic];
                     completion(userInfo);
                 }else{
                     [self.view makeToast:@"获取成员信息失败，请退出聊天界面重新尝试" duration:2];
                 }
             }];
        }
       
    }
    NSLog(@"测试请求基本==%@",userId);
    
//    if (![userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
//    {
//        
//       
//    }else{
//        User *myUserInfo=[UserInfoData getUserInfoFromArchive];
//        NSString *imgUrlString=myUserInfo.headImage;
//        NSString *imgUrl;
//        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
//        {
//            imgUrl=imgUrlString;
//        }
//        else
//        {
//            imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
//        }
//        
//        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:myUserInfo.userId name:myUserInfo.nickname portrait:imgUrl];
//        completion(userInfo);
//    }
    
}
-(void)getGroupInfoWithgroupId:(NSString *)groupId complete:(void (^)(NSMutableDictionary *resultDict))complete1{
    _groupUserInfoDic = [NSMutableDictionary dictionary];
    [HTTPManager groupInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        //_isGetGroupInfo = NO;
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSArray *userArray=[listDict objectForKey:@"data"];
            
            for (NSInteger i=0; i<userArray.count; i++)
            {
                NSDictionary *userDict=userArray[i];
                NSString *groupuserId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
                [_groupUserInfoDic setObject:userDict forKey:groupuserId];
                
            }
            
            complete1(_groupUserInfoDic);
        }
    }];

}
-(RCUserInfo *)getUserInfoWithDic:(NSDictionary *)userDict{
    NSString *nickname=[userDict objectForKey:@"nickname"];
    NSString *headimg=[userDict objectForKey:@"headimg"];
    NSString *groupuserId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
//    NSLog(@"userId===%@=nickname===%@=headimg===%@",groupuserId,nickname,headimg);
    NSString *imgUrlString=headimg;
    NSString *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
            imgUrl=imgUrlString;
    }else{
            imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
    }

    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:groupuserId name:nickname portrait:imgUrl];
    return userInfo;
   
}
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion
{
    
    [HTTPManager groupInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *groupInfoDict=[resultDict objectForKey:@"imGroup"];
            NSString *groupId=[NSString stringWithFormat:@"%@",[groupInfoDict objectForKey:@"id"]];
            NSString *groupName=[groupInfoDict objectForKey:@"name"];
            NSString *groupImg=[groupInfoDict objectForKey:@"img"];
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            if (!_groupUserInfoDic) {
                NSArray *userArray=[listDict objectForKey:@"data"];
                _groupUserInfoDic = [NSMutableDictionary dictionary];
                for (NSInteger i=0; i<userArray.count; i++)
                {
                    NSDictionary *userDict=userArray[i];
                    NSString *groupuserId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
                    [_groupUserInfoDic setObject:userDict forKey:groupuserId];
                }
            }
            

            RCGroup *groupInfo=[[RCGroup alloc]initWithGroupId:groupId groupName:groupName portraitUri:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,groupImg]];
            
            completion(groupInfo);
        }
    }];
}

//点击头像跳转
- (void)didTapCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
    {
        //如果点击的自己的头像跳转到我的界面
        MyselfViewController *vc=[[MyselfViewController alloc]init];
        vc.isChatVC=YES;
        vc.hidesBottomBarWhenPushed=NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //否则跳转到其他用户界面
        UserInfoViewController *vc=[[UserInfoViewController alloc]init];
        vc.userId=userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    if (self.isCreateGroup==YES)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[NeighbourViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//个人或群详情
-(void)rightBtnClick
{
    if (self.isGroup==YES)
    {
        //群详情
        GroupDetailViewController *vc=[[GroupDetailViewController alloc]init];
        vc.groupId=self.targetId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (self.isPerson==YES)
    {
        //个人详情
        UserInfoViewController *vc=[[UserInfoViewController alloc]init];
        vc.userId=self.targetId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
