//
//  NeighbourViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "NeighbourViewController.h"

#import "AddFriendViewController.h"
#import "FindGroupViewController.h"
#import "ChooseFriendViewController.h"
#import "ConversationMessageVC.h"
#import "RCConversationDetailsVC.h"
#import "CreateGroupViewController.h"


@interface NeighbourViewController ()<UITableViewDelegate,UITableViewDataSource,RCIMReceiveMessageDelegate>
{
    UIScrollView *_bottomScrollView;
    UIView *_lineView;
    UIView *_topView;
    ConversationMessageVC *_conversationVC;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *tableViewArray;
@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,strong)NSMutableArray *friendsArray;
//@property(nonatomic,strong)NSMutableArray *neighborArray;

@property(nonatomic,strong)NSMutableArray *bigNeighborArray;
@property(nonatomic,strong)NSMutableArray *bigNeighborIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation NeighbourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigNeighborArray=[NSMutableArray array];
    self.bigNeighborIdArray=[NSMutableArray array];
    self.tableViewArray=[NSMutableArray array];
    self.topBtnArray=[NSMutableArray array];
    
    [self childVC];
    [self createNavigationBar];
    [self createSubviews];
    
   // [RCIM sharedRCIM].receiveMessageDelegate=self;
    
    
    
    
}


-(void)getFriendsList
{
    //获取好友列表
    [HTTPManager getMyFriendsListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"200" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.friendsArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            if (self.tableViewArray.count>0)
            {
                UITableView *tableView=[self.tableViewArray firstObject];
                [tableView reloadData];
            }
        }
    }];
}

//我的邻居
-(void)getNeighborList
{
    [HTTPManager myNeighborWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *neighborArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *neighborDict in neighborArray)
            {
                NSString *neighborId=[neighborDict objectForKey:@"id"];
                
                if (![self.bigNeighborIdArray containsObject:neighborId])
                {
                    [self.bigNeighborIdArray addObject:neighborId];
                    [self.bigNeighborArray addObject:neighborDict];
                }
            }
            
            if (self.tableViewArray.count>0)
            {
                UITableView *tableView=[self.tableViewArray lastObject];
                [tableView reloadData];
            }
        }
    }];
}


-(void)childVC
{
    _conversationVC=[[ConversationMessageVC alloc]init];
    [self addChildViewController:_conversationVC];
}

//#pragma mark - 收到消息监听
//- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self notifyUpdateUnreadMessageCount];
//    });
//    
//}
//
//- (void)notifyUpdateUnreadMessageCount
//{
//    [self updateBadgeValueForTabBarItem];
//}

- (void)updateBadgeValueForTabBarItem
{
    __weak typeof(self) __weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[[NSNumber numberWithInt:ConversationType_PRIVATE],[NSNumber numberWithInt:ConversationType_GROUP]]];
        if (count>0) {
            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        }else
        {
            __weakSelf.tabBarItem.badgeValue = nil;
        }
        
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
//    self.navigationController.navigationBarHidden=NO;
    
    [self updateBadgeValueForTabBarItem];
    [self getFriendsList];
    [self getNeighborList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"邻居";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+25), WZ(10), WZ(25), WZ(25))];
    [rightBtn setBackgroundImage:IMAGE(@"linju_liaotian") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)createSubviews
{
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
    [self.view addSubview:_topView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [_topView addSubview:lineView];
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"消息",@"好友",@"邻居", nil];
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/3.0;
    CGFloat lineWidth=WZ(30);
    
    for (NSInteger i=0; i<3; i++)
    {
        UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+btnWidth*i, 0, btnWidth, _topView.height)];
        topBtn.tag=i;
        [topBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        topBtn.titleLabel.font=FONT(17, 15);
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:topBtn];
        
        [self.topBtnArray addObject:topBtn];
        
        if (i==0)
        {
            [topBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        }
    }
    
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(leftMargin+(btnWidth-lineWidth)/2.0, _topView.bottom-WZ(10), lineWidth, 1)];
    _lineView.backgroundColor=COLOR_RED;
    [_topView addSubview:_lineView];
    
    _bottomScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, _topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_topView.height-64-49)];
    _bottomScrollView.delegate=self;
    _bottomScrollView.pagingEnabled=YES;
    _bottomScrollView.scrollEnabled=NO;
    _bottomScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT-_topView.height-64);
    [self.view addSubview:_bottomScrollView];
    
    _conversationVC.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, _bottomScrollView.height);
    [_bottomScrollView addSubview:_conversationVC.view];
    
    for (NSInteger i=0; i<2; i++)
    {
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*(i+1), 0, SCREEN_WIDTH, _bottomScrollView.height)];
        tableView.tag=i;
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.tableFooterView=[[UIView alloc]init];
        [_bottomScrollView addSubview:tableView];
        
        [self.tableViewArray addObject:tableView];
        
        if (i==1)
        {
            [tableView addHeaderWithTarget:self action:@selector(refreshData)];
            [tableView addFooterWithTarget:self action:@selector(getMoreData)];
        }
    }
    
    
    
}

//下拉刷新
-(void)refreshData
{
    [HTTPManager myNeighborWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *neighborArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *neighborDict in neighborArray)
            {
                NSString *neighborId=[neighborDict objectForKey:@"id"];
                
                if (![self.bigNeighborIdArray containsObject:neighborId])
                {
                    [self.bigNeighborIdArray addObject:neighborId];
                    [self.bigNeighborArray addObject:neighborDict];
                }
            }
            
            if (self.tableViewArray.count>0)
            {
                UITableView *tableView=[self.tableViewArray lastObject];
                [tableView reloadData];
                //结束刷新
                [tableView headerEndRefreshing];
            }
        }
    }];
    
}

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    [HTTPManager myNeighborWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *neighborArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *neighborDict in neighborArray)
            {
                NSString *neighborId=[neighborDict objectForKey:@"id"];
                
                if (![self.bigNeighborIdArray containsObject:neighborId])
                {
                    [self.bigNeighborIdArray addObject:neighborId];
                    [self.bigNeighborArray addObject:neighborDict];
                }
            }
            
            if (self.tableViewArray.count>0)
            {
                UITableView *tableView=[self.tableViewArray lastObject];
                [tableView reloadData];
                //结束刷新
                [tableView footerEndRefreshing];
            }
        }
    }];
    
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==0)
    {
        if (section==0)
        {
            return 3;
        }
        else
        {
            return self.friendsArray.count;
        }
    }
    else
    {
        return self.bigNeighborArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0)
    {
        //好友
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
            
            NSArray *iconArray=[[NSArray alloc]initWithObjects:IMAGE(@"linju_jiahaoyou"),IMAGE(@"linju_chuangjianqun"),IMAGE(@"linju_faxianqun"), nil];
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"加好友",@"创建群",@"发现群", nil];
            
            UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
            iconIV.image=iconArray[indexPath.row];
            [cell.contentView addSubview:iconIV];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+10), iconIV.height)];
            titleLabel.text=titleArray[indexPath.row];
            [cell.contentView addSubview:titleLabel];
            
            
            
            
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
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
            
            NSDictionary *friendDict=self.friendsArray[indexPath.row];
            NSString *headimg=[friendDict objectForKey:@"headimg"];
            NSString *nickname=[friendDict objectForKey:@"nickname"];
//            NSLog(@"好友列表字典===%@",friendDict);
            
            
            UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
            [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] placeholderImage:IMAGE(@"morentouxiang")];
            iconIV.clipsToBounds=YES;
            iconIV.layer.cornerRadius=iconIV.width/2.0;
            [cell.contentView addSubview:iconIV];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+10), iconIV.height)];
            titleLabel.text=nickname;
            titleLabel.font=FONT(15,13);
            [cell.contentView addSubview:titleLabel];
            
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        //邻居
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
        
        NSDictionary *neighborDict=self.bigNeighborArray[indexPath.row];
        NSString *headimg=[neighborDict objectForKey:@"headimg"];
        NSString *nickname=[neighborDict objectForKey:@"nickname"];
        NSString *sign=[neighborDict objectForKey:@"sign"];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(40), WZ(40))];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] placeholderImage:IMAGE(@"morentouxiang")];
        iconIV.clipsToBounds=YES;
        iconIV.layer.cornerRadius=iconIV.width/2.0;
        [cell.contentView addSubview:iconIV];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top-WZ(5), SCREEN_WIDTH-WZ(15*2+40+10), WZ(20))];
        nameLabel.text=nickname;
        nameLabel.textColor=COLOR(146, 135, 187, 1);
        nameLabel.font=FONT(15,13);
        [cell.contentView addSubview:nameLabel];
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, SCREEN_WIDTH-WZ(15*2+40+10), WZ(40))];
        subLabel.text=sign;
        subLabel.textColor=COLOR_LIGHTGRAY;
        subLabel.font=FONT(13,11);
        subLabel.numberOfLines=2;
        [cell.contentView addSubview:subLabel];
        
//        CGSize juliSize=[ViewController sizeWithString:@"10.5km" font:FONT(11,9) maxSize:CGSizeMake(WZ(60), WZ(20))];
//        UILabel *juliLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-juliSize.width, nameLabel.top, juliSize.width, nameLabel.height)];
//        juliLabel.text=@"10.5km";
//        juliLabel.textColor=COLOR_LIGHTGRAY;
//        juliLabel.font=FONT(11,9);
//        [cell.contentView addSubview:juliLabel];
//        
//        UIImageView *juliIV=[[UIImageView alloc]initWithFrame:CGRectMake(juliLabel.left-WZ(5+10), juliLabel.top+WZ(5), WZ(10), WZ(12))];
//        juliIV.image=IMAGE(@"linju_juli");
//        [cell.contentView addSubview:juliIV];
//        
//        UIButton *hiBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(20+30), juliLabel.bottom, WZ(20), WZ(20))];
//        [hiBtn setBackgroundImage:IMAGE(@"linju_hi") forState:UIControlStateNormal];
//        [hiBtn addTarget:self action:@selector(hiBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:hiBtn];
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0)
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                //加好友
                AddFriendViewController *vc=[[AddFriendViewController alloc]init];
                vc.isNeighbourVC=YES;
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.row==1)
            {
                //创建群
                CreateGroupViewController *vc=[[CreateGroupViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.row==2)
            {
                //发现群
                FindGroupViewController *vc=[[FindGroupViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else
        {
            //跳转到聊天界面
            NSDictionary *friendDict=self.friendsArray[indexPath.row];
            NSString *userId=[NSString stringWithFormat:@"%@",[friendDict objectForKey:@"id"]];
            NSString *nickname=[friendDict objectForKey:@"nickname"];
            
//            NSLog(@"好友列表传到聊天界面的userId===%@",userId);
            
            RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
            conversationVC.conversationType=ConversationType_PRIVATE;
            conversationVC.targetId = userId;
            conversationVC.title = nickname;
            conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
            conversationVC.enableUnreadMessageIcon=YES;
            conversationVC.hidesBottomBarWhenPushed=YES;
            conversationVC.isPerson=YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }
    }
    else
    {
        //邻居聊天
        NSDictionary *neighborDict=self.bigNeighborArray[indexPath.row];
        NSString *userId=[NSString stringWithFormat:@"%@",[neighborDict objectForKey:@"id"]];
        NSString *nickname=[neighborDict objectForKey:@"nickname"];
        
//        NSLog(@"邻居列表传到聊天界面的userId===%@",userId);
        
        RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
        conversationVC.conversationType=ConversationType_PRIVATE;
        conversationVC.targetId = userId;
        conversationVC.title = nickname;
        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        conversationVC.enableUnreadMessageIcon=YES;
        conversationVC.hidesBottomBarWhenPushed=YES;
        conversationVC.isPerson=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==0)
    {
        if (section==0)
        {
            return nil;
        }
        else
        {
            UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
            titleView.backgroundColor=COLOR_HEADVIEW;
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(30))];
            label.text=@"好友列表";
            label.font=FONT(15,13);
            [titleView addSubview:label];
            
            return titleView;
        }
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0)
    {
        return WZ(50);
    }
    else
    {
        return WZ(70);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==0)
    {
        if (section==0)
        {
            return 0;
        }
        else
        {
            return WZ(45);
        }
    }
    else
    {
        return 0;
    }
}


#pragma mark ===按钮点击方法
//发起聊天
-(void)rightBtnClick
{
    NSLog(@"发起聊天");
    ChooseFriendViewController *vc=[[ChooseFriendViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//话题 商品 店铺界面切换
-(void)topBtnClick:(UIButton*)button
{
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/3.0;
    CGFloat lineWidth=WZ(30);
    
    for (UIButton *btn in self.topBtnArray)
    {
        if (button.tag==btn.tag)
        {
            [btn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _bottomScrollView.contentOffset=CGPointMake(SCREEN_WIDTH*button.tag, 0);
                _lineView.frame=CGRectMake(leftMargin+(btnWidth-lineWidth)/2.0+(lineWidth+(btnWidth-lineWidth))*button.tag, _topView.bottom-WZ(10), lineWidth, 1);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
    }
}

//向邻居打招呼
-(void)hiBtnClick
{
    
    
    
    
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
