//
//  MyCouponViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/17.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyCouponViewController.h"

#import "MyCouponCell.h"

@interface MyCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_lineView;
    UIView *_topView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;
//@property(nonatomic,strong)NSMutableArray *couponArray;

@property(nonatomic,strong)NSMutableArray *bigCouponArray;
@property(nonatomic,strong)NSMutableArray *bigCouponIdArray;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger buttonIndex;
@property(nonatomic,strong)NSString *couponType;


@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonIndex=0;
    self.couponType=@"1";
    self.pageNum=1;
    self.bigCouponArray=[NSMutableArray array];
    self.bigCouponIdArray=[NSMutableArray array];
    self.topBtnArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createSubviews];
    [self createTableView];
    
}

-(void)getStoreCoupon
{
    //获取商家优惠券列表
    [HTTPManager getUserCouponListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:self.couponType pageNum:@"1" pageSize:@"50" amount:@"" storeId:@"" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *couponArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *couponDict in couponArray)
            {
                NSString *couponId=[couponDict objectForKey:@"id"];
                
                if (![self.bigCouponIdArray containsObject:couponId])
                {
                    [self.bigCouponIdArray addObject:couponId];
                    [self.bigCouponArray addObject:couponDict];
                }
            }
            
            if (couponArray.count==0)
            {
                _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                _blankLabel.text=@"暂无商家优惠券~~";
                _blankLabel.font=FONT(17, 15);
                _blankLabel.textAlignment=NSTextAlignmentCenter;
                [self.view addSubview:_blankLabel];
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
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"msg"] duration:1.0];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    self.navigationController.navigationBarHidden = NO;
    [self getStoreCoupon];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
}

-(void)createNavigationBar
{
    self.title=@"优惠券";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createSubviews
{
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
    [self.view addSubview:_topView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [_topView addSubview:lineView];
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"商家",@"平台", nil];
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/2.0;
    CGFloat lineWidth=WZ(30);
    
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+btnWidth*i, 0, btnWidth, _topView.height)];
        topBtn.tag=i;
        topBtn.titleLabel.font=FONT(17, 15);
        [topBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
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
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _topView.height, SCREEN_WIDTH, SCREEN_HEIGHT-64-_topView.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    if (self.buttonIndex==0)
    {
        self.couponType=@"1";
    }
    if (self.buttonIndex==1)
    {
        self.couponType=@"0";
    }
    
    [HTTPManager getUserCouponListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:self.couponType pageNum:@"1" pageSize:@"50" amount:@"" storeId:@"" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *couponArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *couponDict in couponArray)
            {
                NSString *couponId=[couponDict objectForKey:@"id"];
                
                if (![self.bigCouponIdArray containsObject:couponId])
                {
                    [self.bigCouponIdArray addObject:couponId];
                    [self.bigCouponArray addObject:couponDict];
                }
            }
            
            //结束刷新
            [_tableView headerEndRefreshing];
            [_tableView reloadData];
            
            if (couponArray.count>0)
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

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    if (self.buttonIndex==0)
    {
        self.couponType=@"1";
    }
    if (self.buttonIndex==1)
    {
        self.couponType=@"0";
    }
    
    [HTTPManager getUserCouponListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:self.couponType pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"50" amount:@"" storeId:@"" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *couponArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *couponDict in couponArray)
            {
                NSString *couponId=[couponDict objectForKey:@"id"];
                
                if (![self.bigCouponIdArray containsObject:couponId])
                {
                    [self.bigCouponIdArray addObject:couponId];
                    [self.bigCouponArray addObject:couponDict];
                }
            }
            
            //结束刷新
            [_tableView footerEndRefreshing];
            [_tableView reloadData];
            
            if (couponArray.count>0)
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

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bigCouponArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"MyCouponCell";
    MyCouponCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[MyCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *couponDict=self.bigCouponArray[indexPath.row];
    NSInteger status=[[couponDict objectForKey:@"status"] integerValue];
    
    NSString *tjString=[couponDict objectForKey:@"name"];
    NSString *yxqString=[couponDict objectForKey:@"yxq"];
    NSString *zcsjString=[couponDict objectForKey:@"zcsj"]==nil?@"":[couponDict objectForKey:@"zcsj"];
    NSString *moneyString=[couponDict objectForKey:@"money"];
    
    //status 1未使用 2已使用 3已过期
    cell.titleLabel.text=@"优惠券";
    cell.tjLabel.text=tjString;
    cell.yxqLabel.text=yxqString;
    if ([zcsjString length]>0) {
        cell.zcsjLabel.text=zcsjString;
    }
    
    cell.yhjgLabel.text=[NSString stringWithFormat:@"¥ %@",moneyString];
    
    if (status==1)
    {
        //未使用
        cell.bgIV.image=IMAGE(@"wode_youhuiquan_keyong");
    }
    if (status==2)
    {
        //已使用
        cell.bgIV.image=IMAGE(@"wode_youhuiquan_yiyong");
    }
    if (status==3)
    {
        //已过期
        cell.bgIV.image=IMAGE(@"wode_youhuiquan_guoqi");
    }
    
    
    
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0)
    {
        return WZ(130);
    }
    else
    {
        return WZ(130);
    }
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//商家 平台界面切换
-(void)topBtnClick:(UIButton*)button
{
    self.buttonIndex=button.tag;
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/2.0;
    CGFloat lineWidth=WZ(30);
    
    for (UIButton *btn in self.topBtnArray)
    {
        if (button.tag==btn.tag)
        {
            [btn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _lineView.frame=CGRectMake(leftMargin+(btnWidth-lineWidth)/2.0+(lineWidth+(btnWidth-lineWidth))*button.tag, _topView.bottom-WZ(10), lineWidth, 1);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
    }
    
    if (button.tag==0)
    {
        self.couponType=@"1";
    }
    if (button.tag==1)
    {
        self.couponType=@"0";
    }
    
    //获取优惠券
    [HTTPManager getUserCouponListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:self.couponType pageNum:@"1" pageSize:@"50" amount:@"" storeId:@"" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.pageNum=1;
            [self.bigCouponArray removeAllObjects];
            [self.bigCouponIdArray removeAllObjects];
            
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *couponArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *couponDict in couponArray)
            {
                NSString *couponId=[couponDict objectForKey:@"id"];
                
                if (![self.bigCouponIdArray containsObject:couponId])
                {
                    [self.bigCouponIdArray addObject:couponId];
                    [self.bigCouponArray addObject:couponDict];
                }
            }
            
            if (couponArray.count>0)
            {
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            else
            {
                if (_blankLabel)
                {
                    if (button.tag==0)
                    {
                        _blankLabel.text=@"暂无商家优惠券~~";
                    }
                    if (button.tag==1)
                    {
                        _blankLabel.text=@"暂无平台优惠券~~";
                    }
                }
            }
            
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"msg"] duration:2.0];
        }
    }];

    
    
    
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
