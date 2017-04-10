//
//  MyWalletViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/17.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyWalletViewController.h"

#import "TiXianViewController.h"
#import "BindBankCardViewController.h"
#import "RechargeViewController.h"

@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIView *_topView;
    UIView *_titleView;
    UIView *_statusView;
    UILabel *_blankLabel;
    
}


@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)NSMutableArray *titleBtnArray;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *yueLabel;
@property(nonatomic,strong)NSString *userMoney;

@property(nonatomic,strong)NSMutableArray *bigRecordArray;
@property(nonatomic,strong)NSMutableArray *bigRecordIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@property(nonatomic,strong)NSString *personId;
@property(nonatomic,strong)NSString *name;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=COLOR_HEADVIEW;
    self.userMoney=@"0.00";
    self.pageNum=1;
    self.personId=@"";
    self.name=@"";
    
    self.bigRecordArray=[NSMutableArray array];
    self.bigRecordIdArray=[NSMutableArray array];
    self.titleBtnArray=[NSMutableArray array];
        
    [self createNavigationBar];
    [self createTopView];
    [self createSubviews];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RechargeInfo:) name:@"recharge" object:nil];
    
}

-(void)RechargeInfo:(NSNotification*)notification
{
    NSDictionary *rechargeDict=[notification userInfo];
    NSString *money=[NSString stringWithFormat:@"%.2f",[[rechargeDict objectForKey:@"money"] floatValue]];
    self.yueLabel.text=money;
}

//获取账户余额
-(void)getAccountBalance
{
    [HTTPManager accountBalanceWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.userMoney=[NSString stringWithFormat:@"%.2f",[[resultDict objectForKey:@"userMoney"] floatValue]];
            self.yueLabel.text=self.userMoney;
            
            NSLog(@"账户余额===%@",self.userMoney);
        }
    }];
}

//获取充值明细
-(void)getPayRecords
{
    [HTTPManager getPayRecordWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userRechargeList=[resultDict objectForKey:@"userRechargeList"];
            NSMutableArray*recordArray=[[userRechargeList objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *recordDict in recordArray)
            {
                NSString *recordId=[recordDict objectForKey:@"id"];
                
                if (![self.bigRecordIdArray containsObject:recordId])
                {
                    [self.bigRecordIdArray addObject:recordId];
                    [self.bigRecordArray addObject:recordDict];
                }
            }
            
            if (recordArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), _titleView.bottom+WZ(100), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无充值记录~~";
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
            
            [_tableView reloadData];
        }
        
    }];
}

//获取支付端用户信息
-(void)getMerUserInfo
{
    [HTTPManager getMerUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userDict=[resultDict objectForKey:@"user"];
            self.personId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"personId"]];
            self.name=[userDict objectForKey:@"name"];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getAccountBalance];
    [self getPayRecords];
    [self getMerUserInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"好处吧";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+100), WZ(10), WZ(100), WZ(30))];
    [rightBtn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTopView
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(160))];
    topView.backgroundColor=COLOR(143, 131, 184, 1);
    [self.view addSubview:topView];
    self.topView=topView;
    
    UILabel *zzcLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15+60+10), WZ(15), SCREEN_WIDTH-WZ(15+60+10)*2, WZ(30))];
    zzcLabel.text=@"好处币总资产（元）";
    zzcLabel.font=FONT(17,15);
    zzcLabel.textColor=COLOR_WHITE;
    zzcLabel.textAlignment=NSTextAlignmentCenter;
    [topView addSubview:zzcLabel];
//    zzcLabel.backgroundColor=COLOR_CYAN;
    
    UIButton *refreshBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+60), WZ(18), WZ(60), WZ(25))];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    refreshBtn.titleLabel.font=FONT(15, 13);
    refreshBtn.clipsToBounds=YES;
    refreshBtn.layer.cornerRadius=3;
    refreshBtn.layer.borderColor=COLOR_WHITE.CGColor;
    refreshBtn.layer.borderWidth=1;
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:refreshBtn];
    
    UILabel *yueLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), zzcLabel.bottom+WZ(12), SCREEN_WIDTH-WZ(15*2), WZ(40))];
    yueLabel.text=self.userMoney;
    yueLabel.font=FONT(29,27);
    yueLabel.textColor=COLOR_WHITE;
    yueLabel.textAlignment=NSTextAlignmentCenter;
    [topView addSubview:yueLabel];
    self.yueLabel=yueLabel;
//    yueLabel.backgroundColor=COLOR_CYAN;
    
    UIButton *chongzhiBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(85), yueLabel.bottom+WZ(18), SCREEN_WIDTH-WZ(85*2), WZ(30))];
    chongzhiBtn.clipsToBounds=YES;
    chongzhiBtn.layer.cornerRadius=3.0;
    chongzhiBtn.layer.borderWidth=1;
    chongzhiBtn.layer.borderColor=COLOR_WHITE.CGColor;
    chongzhiBtn.titleLabel.font=FONT(17,15);
    [chongzhiBtn setTitle:@"充值" forState:UIControlStateNormal];
    [chongzhiBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [chongzhiBtn addTarget:self action:@selector(chongzhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:chongzhiBtn];
    
}

-(void)createSubviews
{
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, self.topView.bottom+WZ(15), SCREEN_WIDTH, WZ(44))];
    _titleView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_titleView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, SCREEN_WIDTH-WZ(15*2), _titleView.height)];
    titleLabel.text=@"充值明细";
    titleLabel.font=FONT(17, 15);
    [_titleView addSubview:titleLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [_titleView addSubview:lineView];
    
    _statusView=[[UIView alloc]initWithFrame:CGRectMake(0, _titleView.bottom, SCREEN_WIDTH, WZ(30))];
    _statusView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_statusView];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(70), _statusView.height)];
    timeLabel.text=@"时间";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
//    timeLabel.backgroundColor=COLOR_CYAN;
    [_statusView addSubview:timeLabel];
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right+WZ(10), 0, WZ(100), _statusView.height)];
    typeLabel.font=FONT(15,13);
    typeLabel.text=@"充值方式";
    typeLabel.textColor=COLOR_LIGHTGRAY;
//    typeLabel.backgroundColor=COLOR_CYAN;
    [_statusView addSubview:typeLabel];
    self.typeLabel=typeLabel;
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), 0, WZ(100), _statusView.height)];
    jineLabel.text=@"金额";
    jineLabel.font=FONT(15,13);
    jineLabel.textColor=COLOR_LIGHTGRAY;
//    jineLabel.backgroundColor=COLOR_CYAN;
    [_statusView addSubview:jineLabel];
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), 0, WZ(50), _statusView.height)];
    statusLabel.text=@"状态";
    statusLabel.font=FONT(15,13);
    statusLabel.textColor=COLOR_LIGHTGRAY;
//    statusLabel.backgroundColor=COLOR_CYAN;
    [_statusView addSubview:statusLabel];
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _titleView.bottom+WZ(30), SCREEN_WIDTH, SCREEN_HEIGHT-_statusView.bottom-64)];
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
    [HTTPManager getPayRecordWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userRechargeList=[resultDict objectForKey:@"userRechargeList"];
            NSMutableArray*recordArray=[[userRechargeList objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *recordDict in recordArray)
            {
                NSString *recordId=[recordDict objectForKey:@"id"];
                
                if (![self.bigRecordIdArray containsObject:recordId])
                {
                    [self.bigRecordIdArray addObject:recordId];
                    [self.bigRecordArray addObject:recordDict];
                }
            }
            
            if (recordArray.count>0)
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
    
    [HTTPManager getPayRecordWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userRechargeList=[resultDict objectForKey:@"userRechargeList"];
            NSMutableArray*recordArray=[[userRechargeList objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *recordDict in recordArray)
            {
                NSString *recordId=[recordDict objectForKey:@"id"];
                
                if (![self.bigRecordIdArray containsObject:recordId])
                {
                    [self.bigRecordIdArray addObject:recordId];
                    [self.bigRecordArray addObject:recordDict];
                }
            }
            
            if (recordArray.count>0)
            {
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            
            //结束刷新
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
    return self.bigRecordArray.count;
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
    
    NSDictionary *recordDict=self.bigRecordArray[indexPath.row];
    NSString *time=[recordDict objectForKey:@"createTime"];
    NSString *money=[NSString stringWithFormat:@"%.2f",[[recordDict objectForKey:@"money"] floatValue]];
    NSInteger payType=[[recordDict objectForKey:@"payType"] integerValue];
    NSString *payTypeString;
    if (payType==1)
    {
        payTypeString=@"微信支付";
    }
    if (payType==2)
    {
        payTypeString=@"支付宝支付";
    }
    if (payType==4)
    {
        payTypeString=@"好处币支付";
    }
    if (payType==5)
    {
        payTypeString=@"快钱支付";
    }
    
    NSInteger status=[[recordDict objectForKey:@"status"] integerValue];
    NSString *statusString;
    if (status==0)
    {
        statusString=@"结算中";
    }
    if (status==1)
    {
        statusString=@"已完成";
    }
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(70), WZ(30))];
    timeLabel.text=time;
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    //        timeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:timeLabel];
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right+WZ(10), 0, WZ(100), WZ(30))];
    typeLabel.font=FONT(11,9);
    typeLabel.text=payTypeString;
    typeLabel.textColor=COLOR_LIGHTGRAY;
    //        typeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:typeLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), 0, WZ(100), WZ(30))];
    jineLabel.text=[NSString stringWithFormat:@"¥%@",money];
    jineLabel.font=FONT(11,9);
    jineLabel.textColor=COLOR_LIGHTGRAY;
    //        jineLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:jineLabel];
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), 0, WZ(50), WZ(30))];
    statusLabel.text=statusString;
    statusLabel.font=FONT(11,9);
    statusLabel.textColor=COLOR_LIGHTGRAY;
    //        statusLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:statusLabel];
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(30);
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//刷新数据 包括余额和充值明细
-(void)refreshBtnClick
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"刷新中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:2.5];
    [self getAccountBalance];
    [self refreshData];
}

//绑定银行卡
-(void)rightBtnClick
{
    BindBankCardViewController *vc=[[BindBankCardViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//充值
-(void)chongzhiBtnClick
{
    //充值首先判断是否在充值时间 再判断是否已绑定身份证信息
    BOOL isOK=[ViewController isBetweenFromHour:9 FromMinute:00 toHour:23 toMinute:30];
    if (isOK==YES)
    {
        if (self.name.length>0 & self.personId.length>0)
        {
            RechargeViewController *vc=[[RechargeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您在个人信息中完善实名资料。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag=100;
            [alertView show];
        }
    }
    else
    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"充值开放时间为09：00-21：30" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.tag=101;
//        [alertView show];
        //晚上21：30到早上09：00为小额充值时间 充值金额限制小于或等于300元
        RechargeViewController *vc=[[RechargeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==1)
        {
            RechargeViewController *vc=[[RechargeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
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
