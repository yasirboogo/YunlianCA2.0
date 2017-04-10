//
//  MessagePraiseVC.m
//  YunlianCA
//
//  Created by QinJun on 16/7/19.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MessagePraiseVC.h"

#import "DynamicDetailViewController.h"

@interface MessagePraiseVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
    
}

//@property(nonatomic,strong)NSMutableArray *praiseArray;
@property(nonatomic,strong)NSMutableArray *bigPraiseArray;
@property(nonatomic,strong)NSMutableArray *bigPraiseIdArray;
@property(nonatomic,assign)NSInteger pageNum;


@end

@implementation MessagePraiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigPraiseArray=[NSMutableArray array];
    self.bigPraiseIdArray=[NSMutableArray array];
    
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
}

//获取点赞信息
-(void)getPraiseData
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *praiseListDict=[resultDict objectForKey:@"praiseList"];
            NSMutableArray *praiseArray=[[praiseListDict objectForKey:@"data"] mutableCopy];
            
            if (praiseArray.count>0)
            {
                for (NSDictionary *praiseDict in praiseArray)
                {
                    NSString *praiseId=[praiseDict objectForKey:@"userMesid"];
                    
                    if (![self.bigPraiseIdArray containsObject:praiseId])
                    {
                        [self.bigPraiseIdArray addObject:praiseId];
                        [self.bigPraiseArray addObject:praiseDict];
                    }
                }
            }
            
            [_tableView reloadData];
            [hud hide:YES];
            
            if (praiseArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无点赞~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
            }
            else
            {
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getPraiseData];
}

-(void)createNavigationBar
{
    self.title=@"点赞";
    
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
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *praiseListDict=[resultDict objectForKey:@"praiseList"];
            NSMutableArray *praiseArray=[[praiseListDict objectForKey:@"data"] mutableCopy];
            
            if (praiseArray.count>0)
            {
                for (NSDictionary *praiseDict in praiseArray)
                {
                    NSString *praiseId=[praiseDict objectForKey:@"userMesid"];
                    
                    if (![self.bigPraiseIdArray containsObject:praiseId])
                    {
                        [self.bigPraiseIdArray addObject:praiseId];
                        [self.bigPraiseArray addObject:praiseDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            
            //结束刷新
            [_tableView headerEndRefreshing];
            [_tableView reloadData];
        }
    }];
}

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *praiseListDict=[resultDict objectForKey:@"praiseList"];
            NSMutableArray *praiseArray=[[praiseListDict objectForKey:@"data"] mutableCopy];
            
            if (praiseArray.count>0)
            {
                for (NSDictionary *praiseDict in praiseArray)
                {
                    NSString *praiseId=[praiseDict objectForKey:@"userMesid"];
                    
                    if (![self.bigPraiseIdArray containsObject:praiseId])
                    {
                        [self.bigPraiseIdArray addObject:praiseId];
                        [self.bigPraiseArray addObject:praiseDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            
            //结束加载
            [_tableView footerEndRefreshing];
            [_tableView reloadData];
        }
    }];
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bigPraiseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
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
    
    NSDictionary *praiseDict=self.bigPraiseArray[indexPath.row];
    NSString *beanConent=[[praiseDict objectForKey:@"beanContent"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *beanImg=[praiseDict objectForKey:@"beanImg"];
    NSString *beanName=[praiseDict objectForKey:@"beanName"];
    NSString *createTime=[praiseDict objectForKey:@"createTime"];
    NSString *userHeadImg=[praiseDict objectForKey:@"userHeadImg"];
    NSString *userNickName=[praiseDict objectForKey:@"userNickName"];
    
//    NSLog(@"beanName===%@    userNickname===%@",beanName,userNickName);
    
    UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
    [cell.contentView addSubview:headView];
    headView.goBtn.hidden=YES;
    
    NSString *imgUrlString=userHeadImg;
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,userHeadImg]];
    }
    [headView.headImageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    headView.nameLabel.text=userNickName;
    headView.timeLabel.text=createTime;
    headView.timeLabel.textColor=COLOR_LIGHTGRAY;
    headView.addFriendBtn.frame=CGRectMake(0, 0, 0, 0);
    
    CGSize commentSize=[ViewController sizeWithString:[NSString stringWithFormat:@"%@赞了你",userNickName] font:FONT(16, 14) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(2000))];
    UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2),commentSize.height)];
    commentLabel.text=[NSString stringWithFormat:@"%@赞了你",userNickName];
    commentLabel.font=FONT(16, 14);
    commentLabel.numberOfLines=0;
    [cell.contentView addSubview:commentLabel];
    
    UIView *bgView=[[UIView alloc]init];
    bgView.backgroundColor=COLOR_HEADVIEW;
    [cell.contentView addSubview:bgView];
    
    UILabel *userNameLabel=[[UILabel alloc]init];
    userNameLabel.text=beanName;
    userNameLabel.textColor=COLOR(146, 135, 187, 1);
    userNameLabel.font=FONT(14, 12);
    [bgView addSubview:userNameLabel];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.text=beanConent;
    titleLabel.textColor=COLOR_LIGHTGRAY;
    titleLabel.font=FONT(15, 13);
    titleLabel.numberOfLines=2;
    [bgView addSubview:titleLabel];
    
    UIImageView *imageView=[[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,beanImg]] placeholderImage:IMAGE(@"morentupian")];
    [bgView addSubview:imageView];
    
    if (beanImg==nil || [beanImg isEqualToString:@""])
    {
        userNameLabel.frame=CGRectMake(WZ(10), WZ(5), SCREEN_WIDTH-WZ(15*2)-WZ(10*2), WZ(20));
        CGSize titleSize=[ViewController sizeWithString:beanConent font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2), WZ(40))];
        titleLabel.frame=CGRectMake(userNameLabel.left, userNameLabel.bottom+WZ(5), SCREEN_WIDTH-WZ(15*2)-WZ(10*2), titleSize.height);
        bgView.frame=CGRectMake(WZ(15), commentLabel.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), WZ(5)+userNameLabel.height+WZ(5)+titleLabel.height+WZ(5));
    }
    else
    {
        imageView.frame=CGRectMake( 0, 0, WZ(75), WZ(75));
        userNameLabel.frame=CGRectMake(WZ(75)+WZ(10), WZ(5), SCREEN_WIDTH-WZ(15*2)-WZ(10*2)-WZ(75), WZ(20));
        CGSize titleSize=[ViewController sizeWithString:beanConent font:FONT(15, 13) maxSize:CGSizeMake(userNameLabel.width, WZ(40))];
        titleLabel.frame=CGRectMake(WZ(75)+WZ(10), userNameLabel.bottom+WZ(5), userNameLabel.width, titleSize.height);
        bgView.frame=CGRectMake(WZ(15), commentLabel.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), WZ(75));
    }
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *commemtDict=self.bigPraiseArray[indexPath.row];
//    NSString *beanId=[NSString stringWithFormat:@"%@",[commemtDict objectForKey:@"beanId"]];
//    
//    //跳转详情界面
//    DynamicDetailViewController *vc=[[DynamicDetailViewController alloc]init];
//    vc.isLinLiVC=NO;
//    vc.articleId=beanId;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *praiseDict=self.bigPraiseArray[indexPath.row];
//    NSString *userConent=[[praiseDict objectForKey:@"userContent"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *beanImg=[praiseDict objectForKey:@"beanImg"];
    NSString *beanConent=[[praiseDict objectForKey:@"beanContent"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *userNickName=[praiseDict objectForKey:@"userNickName"];
    
    CGSize commentSize=[ViewController sizeWithString:[NSString stringWithFormat:@"%@赞了你",userNickName] font:FONT(17, 15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(2000))];
    
    if (beanImg==nil || [beanImg isEqualToString:@""])
    {
        CGSize titleSize=[ViewController sizeWithString:beanConent font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2), WZ(40))];
        return WZ(70+10+10+10)+commentSize.height+WZ(5)+WZ(20)+WZ(5)+titleSize.height+WZ(5);
    }
    else
    {
        return WZ(70+10+10+10)+commentSize.height+WZ(75);
    }
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSDictionary *messageDict=self.bigPraiseArray[indexPath.row];
        NSString *messageId=[messageDict objectForKey:@"id"];
        [HTTPManager deleteMessageWithIds:messageId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [tableView setEditing:NO animated:YES];
                [self.bigPraiseArray removeObjectAtIndex:indexPath.row];
                [_tableView reloadData];
            }
            else
            {
                [self.view makeToast:result duration:1.0];
            }
        }];
    }
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
