//
//  MessageSystemVC.m
//  YunlianCA
//
//  Created by QinJun on 16/7/19.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MessageSystemVC.h"

@interface MessageSystemVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
    
}

@property(nonatomic,strong)NSMutableArray *bigMessageArray;
@property(nonatomic,strong)NSMutableArray *bigMessageIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation MessageSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigMessageArray=[NSMutableArray array];
    self.bigMessageIdArray=[NSMutableArray array];
    
    
    [self createNavigationBar];
    [self createTableView];
    
    
    //点击推送alertView进入此界面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"system"] isEqualToString:@"system"])
    {
        [self.tabBarController.tabBar setHidden:YES];
        //给导航栏加一个返回按钮，便于将推送进入的页面返回出去，如果不是推送进入该页面，那肯定是通过导航栏进入的，则页面导航栏肯定会有导航栏自带的leftBarButtonItem返回上一个页面
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(rebackToRootViewAction)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
}

- (void)rebackToRootViewAction
{
    //将标示条件置空，以防通过正常情况下导航栏进入该页面时无法返回上一级页面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"" forKey:@"system"];
    [pushJudge synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//获取系统信息
-(void)getSystemData
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"0" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *messageListDict=[resultDict objectForKey:@"xtList"];
            NSMutableArray *messageArray=[[messageListDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *messageDict in messageArray)
            {
                NSString *messageId=[messageDict objectForKey:@"id"];
                
                if (![self.bigMessageIdArray containsObject:messageId])
                {
                    [self.bigMessageIdArray addObject:messageId];
                    [self.bigMessageArray addObject:messageDict];
                }
            }
            
            [_tableView reloadData];
            [hud hide:YES];
            
            if (messageArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无系统消息~~";
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
    
    [self getSystemData];
}

-(void)createNavigationBar
{
    self.title=@"系统消息";
    
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
    _tableView.backgroundColor=COLOR_HEADVIEW;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"0" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *messageListDict=[resultDict objectForKey:@"xtList"];
            NSMutableArray *messageArray=[[messageListDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *messageDict in messageArray)
            {
                NSString *messageId=[messageDict objectForKey:@"id"];
                
                if (![self.bigMessageIdArray containsObject:messageId])
                {
                    [self.bigMessageIdArray addObject:messageId];
                    [self.bigMessageArray addObject:messageDict];
                }
            }
            
            if (messageArray.count>0)
            {
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
    
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"0" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *messageListDict=[resultDict objectForKey:@"xtList"];
            NSMutableArray *messageArray=[[messageListDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *messageDict in messageArray)
            {
                NSString *messageId=[messageDict objectForKey:@"id"];
                
                if (![self.bigMessageIdArray containsObject:messageId])
                {
                    [self.bigMessageIdArray addObject:messageId];
                    [self.bigMessageArray addObject:messageDict];
                }
            }
            
            if (messageArray.count>0)
            {
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
    return self.bigMessageArray.count;
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
    
    NSDictionary *messageDict=self.bigMessageArray[indexPath.row];
    NSString *content=[[messageDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *date=[messageDict objectForKey:@"createTime"];
    NSString *title=[messageDict objectForKey:@"title"];
    
    CGSize dateSize=[ViewController sizeWithString:date font:FONT(15, 13) maxSize:CGSizeMake(WZ(100), WZ(30))];
    CGSize titleSize=[ViewController sizeWithString:title font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2)-WZ(10*2)-dateSize.width, WZ(60))];
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(14, 12) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2), WZ(3000))];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2), titleSize.height+contentSize.height+WZ(20))];
    bgView.backgroundColor=COLOR_WHITE;
    bgView.clipsToBounds=YES;
    bgView.layer.cornerRadius=7;
    bgView.layer.borderColor=COLOR(200, 200, 200, 1).CGColor;
    bgView.layer.borderWidth=1.0;
    [cell.contentView addSubview:bgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), WZ(5), titleSize.width, titleSize.height)];
    titleLabel.font=FONT(15, 13);
    titleLabel.text=title;
//    titleLabel.textColor=COLOR_LIGHTGRAY;
    [bgView addSubview:titleLabel];
    
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(bgView.width-WZ(10)-dateSize.width, WZ(5), dateSize.width, dateSize.height)];
    dateLabel.font=FONT(15, 13);
    dateLabel.text=date;
    dateLabel.textColor=COLOR_LIGHTGRAY;
    [bgView addSubview:dateLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(WZ(10), titleLabel.bottom+WZ(5), bgView.width-WZ(10*2), 1)];
    lineView.backgroundColor=COLOR(220, 220, 220, 1);
    [bgView addSubview:lineView];
    
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), titleLabel.bottom+WZ(10), contentSize.width, contentSize.height)];
    contentLabel.font=FONT(14, 12);
    contentLabel.text=content;
    contentLabel.textColor=COLOR_LIGHTGRAY;
    contentLabel.numberOfLines=0;
    [bgView addSubview:contentLabel];
    
    
    
    cell.backgroundColor=COLOR_HEADVIEW;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *commemtDict=self.messageArray[indexPath.row];
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
    NSDictionary *messageDict=self.bigMessageArray[indexPath.row];
    NSString *content=[[messageDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *date=[messageDict objectForKey:@"createTime"];
    NSString *title=[messageDict objectForKey:@"title"];
    
    CGSize dateSize=[ViewController sizeWithString:date font:FONT(15, 13) maxSize:CGSizeMake(WZ(100), WZ(30))];
    CGSize titleSize=[ViewController sizeWithString:title font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2)-WZ(10*2)-dateSize.width, WZ(60))];
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2), WZ(3000))];
    
    return titleSize.height+contentSize.height+WZ(20)+WZ(20);
    
    
    
//    NSDictionary *commemtDict=self.messageArray[indexPath.row];
//    NSString *userConent=[[commemtDict objectForKey:@"userContent"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *img=[commemtDict objectForKey:@"img"];
//    NSString *beanConent=[[commemtDict objectForKey:@"beanContent"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    CGSize commentSize=[ViewController sizeWithString:userConent font:FONT(17, 15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(2000))];
//    
//    if (img==nil || [img isEqualToString:@""])
//    {
//        CGSize titleSize=[ViewController sizeWithString:beanConent font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2)-WZ(10*2), WZ(40))];
//        return WZ(70+10+10+10)+commentSize.height+WZ(5)+WZ(20)+WZ(5)+titleSize.height+WZ(5);
//    }
//    else
//    {
//        return WZ(70+10+10+10)+commentSize.height+WZ(75);
//    }
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
        NSDictionary *messageDict=self.bigMessageArray[indexPath.row];
        NSString *messageId=[messageDict objectForKey:@"id"];
        [HTTPManager deleteMessageWithIds:messageId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [tableView setEditing:NO animated:YES];
                [self.bigMessageArray removeObjectAtIndex:indexPath.row];
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
