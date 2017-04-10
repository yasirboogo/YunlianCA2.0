//
//  GroupDetailViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "GroupDetailViewController.h"

#import "AllMembersViewController.h"
#import "UserInfoViewController.h"
#import "RCConversationDetailsVC.h"
#import "NeighbourViewController.h"
#import "ReportGroupViewController.h"


@interface GroupDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)NSDictionary *groupInfoDict;
@property(nonatomic,strong)NSMutableArray *memberArray;
@property(nonatomic,assign)NSInteger ifInGroup;
@property(nonatomic,assign)BOOL ifNotify;
@property(nonatomic,assign)BOOL ifTop;

@end

@implementation GroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
}

//获取群详情
-(void)getGroupInfo
{
    [HTTPManager groupInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:self.groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.groupInfoDict=[resultDict objectForKey:@"imGroup"];
            self.ifInGroup=[[self.groupInfoDict objectForKey:@"userIsin"] integerValue];
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.memberArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            [_tableView reloadData];
        }
    }];
}

//消息免打扰状态
-(void)conversationIfNotify
{
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId success:^(RCConversationNotificationStatus nStatus) {
        if (nStatus==0)
        {
            //免打扰
            self.ifNotify=NO;
        }
        if (nStatus==1)
        {
            //正常接收消息
            self.ifNotify=YES;
        }
    } error:^(RCErrorCode status) {
        
    }];
    
}

//消息是否置顶
-(void)conversationIfTop
{
    RCConversation *conversation=[[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:self.groupId];
    if (conversation.isTop==YES)
    {
        self.ifTop=YES;
    }
    if (conversation.isTop==NO)
    {
        self.ifTop=NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
    [self getGroupInfo];
    [self conversationIfNotify];
    [self conversationIfTop];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"详情";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.ifInGroup==0)
    {
        return 3;
    }
    else
    {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ifInGroup==0)
    {
        if (section==1)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        if (section==0 || section==4)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellIdentifier=@"Cell0";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        NSString *name=[self.groupInfoDict objectForKey:@"name"];
        NSString *img=[self.groupInfoDict objectForKey:@"img"];
        NSString *des=[self.groupInfoDict objectForKey:@"des"];
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(200))];
        cellView.backgroundColor=COLOR(255, 63, 94, 1);
        [cell.contentView addSubview:cellView];
        
        UIImageView *headIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(70))/2.0, WZ(15), WZ(70), WZ(70))];
        [headIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentupian")];
        headIV.layer.cornerRadius=headIV.width/2.0;
        headIV.clipsToBounds=YES;
        headIV.layer.borderColor=COLOR(254, 167, 173, 1).CGColor;
        headIV.layer.borderWidth=2;
        [cellView addSubview:headIV];
        
        UILabel *groupNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headIV.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), WZ(25))];
        groupNameLabel.text=name;
        groupNameLabel.textColor=COLOR_WHITE;
        groupNameLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:groupNameLabel];
        
        NSString *sign=[NSString stringWithFormat:@"群简介：%@",des];
        UILabel *groupIntroLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), groupNameLabel.bottom+WZ(5), SCREEN_WIDTH-WZ(15*2), WZ(40))];
        groupIntroLabel.text=sign;
        groupIntroLabel.textColor=COLOR(255, 168, 174, 1);
        groupIntroLabel.textAlignment=NSTextAlignmentCenter;
        groupIntroLabel.font=FONT(15,13);
        groupIntroLabel.numberOfLines=2;
//        groupIntroLabel.backgroundColor=COLOR_CYAN;
        [cellView addSubview:groupIntroLabel];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
    {
        static NSString *cellIdentifier=@"Cell1";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        NSInteger memberCount=(NSInteger)[self.memberArray count];
//        NSLog(@"群成员人数===%ld",(long)memberCount);
        
        if (indexPath.row==0)
        {
            CGFloat space=WZ(20);
            CGFloat btnWidth=(SCREEN_WIDTH-space*6)/5;
            
            if (memberCount>5)
            {
                for (NSInteger i=0; i<5; i++)
                {
                    NSDictionary *memberDict=self.memberArray[i];
                    NSString *nickname=[memberDict objectForKey:@"nickname"];
                    NSString *headimg=[memberDict objectForKey:@"headimg"];
                    
                    UIButton *memberHeadBtn=[[UIButton alloc]initWithFrame:CGRectMake(space+(btnWidth+space)*(i%5), WZ(15)+(btnWidth+WZ(40))*(i/5), btnWidth, btnWidth)];
                    memberHeadBtn.tag=i;
                    [memberHeadBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
                    memberHeadBtn.clipsToBounds=YES;
                    memberHeadBtn.layer.cornerRadius=btnWidth/2.0;
                    [memberHeadBtn addTarget:self action:@selector(memberHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:memberHeadBtn];
                    
                    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(memberHeadBtn.left-WZ(8), memberHeadBtn.bottom+WZ(5), btnWidth+WZ(8*2), WZ(25))];
                    nameLabel.text=nickname;
                    nameLabel.textAlignment=NSTextAlignmentCenter;
                    nameLabel.font=FONT(13,11);
                    //            nameLabel.backgroundColor=COLOR_CYAN;
                    [cell.contentView addSubview:nameLabel];
                }
            }
            if (memberCount>0 && memberCount<=5)
            {
                for (NSInteger i=0; i<memberCount; i++)
                {
                    NSDictionary *memberDict=self.memberArray[i];
                    NSString *nickname=[memberDict objectForKey:@"nickname"];
                    NSString *headimg=[memberDict objectForKey:@"headimg"];
                    
                    UIButton *memberHeadBtn=[[UIButton alloc]initWithFrame:CGRectMake(space+(btnWidth+space)*(i%5), WZ(15)+(btnWidth+WZ(40))*(i/5), btnWidth, btnWidth)];
                    memberHeadBtn.tag=i;
                    [memberHeadBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
                    memberHeadBtn.clipsToBounds=YES;
                    memberHeadBtn.layer.cornerRadius=btnWidth/2.0;
                    [memberHeadBtn addTarget:self action:@selector(memberHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:memberHeadBtn];
                    
                    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(memberHeadBtn.left-WZ(8), memberHeadBtn.bottom+WZ(5), btnWidth+WZ(8*2), WZ(25))];
                    nameLabel.text=nickname;
                    nameLabel.textAlignment=NSTextAlignmentCenter;
                    nameLabel.font=FONT(13,11);
                    //            nameLabel.backgroundColor=COLOR_CYAN;
                    [cell.contentView addSubview:nameLabel];
                }
            }
        }
        if (indexPath.row==1)
        {
            cell.textLabel.text=@"群名称";
            
            NSString *name=[self.groupInfoDict objectForKey:@"name"];
            
            UILabel *groupNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(150), 0, WZ(150), WZ(50))];
            groupNameLabel.text=name;
            groupNameLabel.textAlignment=NSTextAlignmentRight;
            groupNameLabel.font=FONT(15,13);
            [cell.contentView addSubview:groupNameLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if (self.ifInGroup==0)
        {
            static NSString *cellIdentifier=@"Cell4";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            else
            {
                while ([cell.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            UIButton *bottomBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
            bottomBtn.backgroundColor=COLOR(254, 167, 173, 1);
            bottomBtn.layer.cornerRadius=5.0;
            bottomBtn.clipsToBounds=YES;
            [bottomBtn setTitle:@"加入群" forState:UIControlStateNormal];
            [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:bottomBtn];
            
            
            cell.backgroundColor=COLOR_HEADVIEW;
            
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            if (indexPath.section==2)
            {
                static NSString *cellIdentifier=@"Cell2";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell)
                {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                else
                {
                    while ([cell.contentView.subviews lastObject] != nil)
                    {
                        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                    }
                }
                
                NSArray *titleArray=[[NSArray alloc]initWithObjects:@"消息免打扰",@"置顶聊天", nil];
                cell.textLabel.text=titleArray[indexPath.row];
                
                if (indexPath.row==0)
                {
                    UISwitch *mdrSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(50), WZ(10), WZ(50), WZ(30))];
                    mdrSwitch.onTintColor=COLOR(254, 153, 160, 1);
                    cell.accessoryView=mdrSwitch;
                    [mdrSwitch addTarget:self action:@selector(mdrSwitchClick:) forControlEvents:UIControlEventValueChanged];
                    
                    if (self.ifNotify==YES)
                    {
                        [mdrSwitch setOn:NO];
                    }
                    if (self.ifNotify==NO)
                    {
                        [mdrSwitch setOn:YES];
                    }
                    
                }
                if (indexPath.row==1)
                {
                    UISwitch *zdSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(50), WZ(10), WZ(50), WZ(30))];
                    zdSwitch.onTintColor=COLOR(254, 153, 160, 1);
                    cell.accessoryView=zdSwitch;
                    [zdSwitch addTarget:self action:@selector(zdSwitchClick:) forControlEvents:UIControlEventValueChanged];
                    
                    if (self.ifTop==YES)
                    {
                        [zdSwitch setOn:YES];
                    }
                    if (self.ifTop==NO)
                    {
                        [zdSwitch setOn:NO];
                    }
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            if (indexPath.section==3)
            {
                static NSString *cellIdentifier=@"Cell3";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell)
                {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                else
                {
                    while ([cell.contentView.subviews lastObject] != nil)
                    {
                        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                    }
                }
                
                NSArray *titleArray=[[NSArray alloc]initWithObjects:@"清空聊天记录",@"举报", nil];
                cell.textLabel.text=titleArray[indexPath.row];
                
                if (indexPath.row==1)
                {
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                
                
                
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
            else
            {
                static NSString *cellIdentifier=@"Cell4";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (!cell)
                {
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                else
                {
                    while ([cell.contentView.subviews lastObject] != nil)
                    {
                        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
                    }
                }
                
                UIButton *bottomBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
                bottomBtn.backgroundColor=COLOR(254, 167, 173, 1);
                bottomBtn.layer.cornerRadius=5.0;
                bottomBtn.clipsToBounds=YES;
                [bottomBtn setTitle:@"退出群" forState:UIControlStateNormal];
                [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:bottomBtn];
                
                
                cell.backgroundColor=COLOR_HEADVIEW;
                
                
                
                
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ifInGroup==1)
    {
        if (indexPath.section==3)
        {
            if (indexPath.row==0)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清除所有聊天信息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag=1;
                [alertView show];
                
            }
            if (indexPath.row==1)
            {
                //举报
                ReportGroupViewController *vc=[[ReportGroupViewController alloc]init];
                vc.groupId=self.groupId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.ifInGroup==0)
    {
        if (section==0 || section==2)
        {
            return nil;
        }
        else
        {
            UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
            titleView.backgroundColor=COLOR_HEADVIEW;
            
            NSString *memberCount=[NSString stringWithFormat:@"%lu",(unsigned long)[self.memberArray count]];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(200), WZ(30))];
            label.text=[NSString stringWithFormat:@"全部成员(%@)",memberCount];
            label.textColor=COLOR_LIGHTGRAY;
            label.font=FONT(15,13);
            [titleView addSubview:label];
            
            UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10), WZ(15), WZ(10), WZ(20))];
            jiantouIV.image=IMAGE(@"youjiantou_hei");
            [titleView addSubview:jiantouIV];
            
            UIButton *allMemberBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleView.height)];
            [allMemberBtn addTarget:self action:@selector(allMemberBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [titleView addSubview:allMemberBtn];
            
            return titleView;
        }
    }
    else
    {
        if (section==0 || section==4)
        {
            return nil;
        }
        if (section==1)
        {
            UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
            titleView.backgroundColor=COLOR_HEADVIEW;
            
            NSString *memberCount=[NSString stringWithFormat:@"%lu",(unsigned long)[self.memberArray count]];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(200), WZ(30))];
            label.text=[NSString stringWithFormat:@"全部成员(%@)",memberCount];
            label.textColor=COLOR_LIGHTGRAY;
            label.font=FONT(15,13);
            [titleView addSubview:label];
            
            UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10), WZ(15), WZ(10), WZ(20))];
            jiantouIV.image=IMAGE(@"youjiantou_hei");
            [titleView addSubview:jiantouIV];
            
            UIButton *allMemberBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleView.height)];
            [allMemberBtn addTarget:self action:@selector(allMemberBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [titleView addSubview:allMemberBtn];
            
            return titleView;
        }
        else
        {
            UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
            titleView.backgroundColor=COLOR_HEADVIEW;
            
            return titleView;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ifInGroup==0)
    {
        if (indexPath.section==0)
        {
            return WZ(170);
        }
        if (indexPath.section==1)
        {
            if (indexPath.row==0)
            {
                return WZ(100);
            }
            else
            {
                return WZ(50);
            }
        }
        else
        {
            return WZ(110);
        }
    }
    else
    {
        if (indexPath.section==0)
        {
            return WZ(170);
        }
        if (indexPath.section==1)
        {
            if (indexPath.row==0)
            {
                return WZ(100);
            }
            else
            {
                return WZ(50);
            }
        }
        if (indexPath.section==4)
        {
            return WZ(110);
        }
        else
        {
            return WZ(50);
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.ifInGroup==0)
    {
        if (section==0 || section==2)
        {
            return 0;
        }
        else
        {
            return WZ(45);
        }
    }
    if (section==1)
    {
        return WZ(45);
    }
    if (section==0 || section==4)
    {
        return 0;
    }
    else
    {
        return WZ(15);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0)
    {
        scrollView.scrollEnabled=NO;
    }
    else
    {
        scrollView.scrollEnabled=YES;
    }
}



#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击用户头像查看用户信息
-(void)memberHeadBtn:(UIButton*)button
{
    NSDictionary *memberDict=self.memberArray[button.tag];
    NSString *userId=[NSString stringWithFormat:@"%@",[memberDict objectForKey:@"id"]];
    
    UserInfoViewController *vc=[[UserInfoViewController alloc]init];
    vc.userId=userId;
    [self.navigationController pushViewController:vc animated:YES];
}

//底部按钮 加入群组或者删除并退出群组
-(void)bottomBtnClick
{
    NSString *message;
    if (self.ifInGroup==0)
    {
        NSLog(@"加入群组");
        message=[NSString stringWithFormat:@"是否加入%@?",[self.groupInfoDict objectForKey:@"name"]];
    }
    else
    {
        NSLog(@"退出群组");
        message=[NSString stringWithFormat:@"是否退出%@?",[self.groupInfoDict objectForKey:@"name"]];
    }
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=0;
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0)
    {
        //退出或者加入群组
        if (self.ifInGroup==0)
        {
            if (buttonIndex==1)
            {
                //未加入此群时点确认是加入群
                NSString *groupId=[NSString stringWithFormat:@"%@",[self.groupInfoDict objectForKey:@"id"]];
                NSString *groupName=[self.groupInfoDict objectForKey:@"name"];
                [HTTPManager joinGroupWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId groupName:groupName complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        [self.view.window makeToast:@"加群成功，开始聊天吧~~" duration:1.5];
                        
                        RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
                        conversationVC.conversationType=ConversationType_GROUP;
                        conversationVC.targetId = groupId;
                        conversationVC.title = groupName;
                        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
                        conversationVC.enableUnreadMessageIcon=YES;
                        conversationVC.hidesBottomBarWhenPushed=YES;
                        conversationVC.isGroup=YES;
                        [self.navigationController pushViewController:conversationVC animated:YES];
                    }
                    else
                    {
                        [self.view makeToast:@"加群失败，请重试。" duration:1.5];
                    }
                    
                }];
            }
        }
        else
        {
            if (buttonIndex==1)
            {
                //已加入此群时点确认是退出群 不考虑解散群
                NSString *groupId=[NSString stringWithFormat:@"%@",[self.groupInfoDict objectForKey:@"id"]];
                [HTTPManager exitGroupWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        [self.view.window makeToast:@"退群成功" duration:1.5];
                        
                        for (UIViewController *controller in self.navigationController.viewControllers)
                        {
                            if ([controller isKindOfClass:[NeighbourViewController class]])
                            {
                                [self.navigationController popToViewController:controller animated:YES];
                            }
                        }
                    }
                    else
                    {
                        [self.view makeToast:@"退群失败，请重试。" duration:1.5];
                    }
                }];
            }
        }
    }
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            //清空聊天记录
            BOOL isClear=[[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.groupId];
            if (isClear==YES)
            {
                //成功清除聊天记录 发送通知 聊天界面刷新界面
                [[NSNotificationCenter defaultCenter]postNotificationName:@"clearConversation" object:nil];
                [self.view makeToast:@"清除成功" duration:1.5];
            }
            if (isClear==NO)
            {
                [self.view makeToast:@"清除失败，请重试。" duration:1.5];
            }
        }
        
    }
}

//跳转查看所有群组成员
-(void)allMemberBtnClick
{
    AllMembersViewController *vc=[[AllMembersViewController alloc]init];
    vc.memberArray=self.memberArray;
    [self.navigationController pushViewController:vc animated:YES];
}

//消息免打扰
-(void)mdrSwitchClick:(UISwitch*)aSwitch
{
    if (self.ifNotify==YES)
    {
        //开启消息免打扰
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
            if (nStatus==0)
            {
                //免打扰
                [aSwitch setOn:YES];
                self.ifNotify=NO;
            }
            if (nStatus==1)
            {
                //依旧正常接收消息
                [self.view makeToast:@"开启消息免打扰失败，请重试。" duration:1.0];
            }
        } error:^(RCErrorCode status) {
            
        }];
    }
    if (self.ifNotify==NO)
    {
        //关闭消息免打扰
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
            if (nStatus==0)
            {
                //依旧处于免打扰状态
                [self.view makeToast:@"关闭消息免打扰失败，请重试。" duration:1.0];
                
            }
            if (nStatus==1)
            {
                //成功关闭免打扰
                [aSwitch setOn:NO];
                self.ifNotify=YES;
            }
        } error:^(RCErrorCode status) {
            
        }];
    }
    
    
    
    
    
}

//置顶聊天
-(void)zdSwitchClick:(UISwitch*)aSwitch
{
    if (self.ifTop==YES)
    {
        BOOL isTop=[[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:self.groupId isTop:NO];
        
        if (isTop==NO)
        {
            [aSwitch setOn:NO];
            self.ifTop=NO;
        }
//        if (isTop==YES)
//        {
//            [self.view makeToast:@"取消置顶失败，请重试。" duration:1.0];
//        }
    }
    if (self.ifTop==NO)
    {
        BOOL isTop=[[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:self.groupId isTop:YES];
        
        if (isTop==YES)
        {
            [aSwitch setOn:YES];
            self.ifTop=YES;
        }
        if (isTop==NO)
        {
            [self.view makeToast:@"置顶失败，请重试。" duration:1.0];
        }
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
