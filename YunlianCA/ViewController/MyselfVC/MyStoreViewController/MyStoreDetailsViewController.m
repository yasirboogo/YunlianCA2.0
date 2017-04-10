//
//  MyStoreDetailsViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/18.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyStoreDetailsViewController.h"

@interface MyStoreDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_lineView;
    UIView *_topView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,strong)NSMutableArray *recordsArray;
@property(nonatomic,assign)NSInteger btnIndex;
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,strong)NSMutableArray *recordsIdArray;



@end

@implementation MyStoreDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex=1;
    self.btnIndex=0;
    self.topBtnArray=[NSMutableArray array];
    self.recordsIdArray=[NSMutableArray array];
    self.recordsArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createSubviews];
    [self createTableView];
    [self getIncomRecordsWithPageIndex:@"1"];
    
    
    
}

//获取店铺收入记录
-(void)getIncomRecordsWithPageIndex:(NSString*)pageIndex
{
    [HTTPManager getIncomeRecordsWithUserId:[UserInfoData getUserInfoFromArchive].userId pageIndex:pageIndex pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSMutableArray *listArray=[[resultDict objectForKey:@"list"] mutableCopy];
            if (listArray.count>0)
            {
                for (NSDictionary *recordsDict in listArray)
                {
                    NSString *recordsId=[recordsDict objectForKey:@"tradeId"];
                    
                    if (![self.recordsIdArray containsObject:recordsId])
                    {
                        [self.recordsIdArray addObject:recordsId];
                        [self.recordsArray addObject:recordsDict];
                    }
                }
                
                [_tableView reloadData];
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            else
            {
                if (self.recordsArray.count==0)
                {
                    if (!_blankLabel)
                    {
                        _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                        _blankLabel.text=@"暂无收入记录~~";
                        _blankLabel.font=FONT(17, 15);
                        _blankLabel.textAlignment=NSTextAlignmentCenter;
                        [self.view addSubview:_blankLabel];
                    }
                    else
                    {
                        _blankLabel.text=@"暂无收入记录~~";
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
        }
        else
        {
            [self.view makeToast:@"获取收入记录失败，请重试。" duration:1.0];
        }
    }];
}

//获取店铺提现记录
-(void)getWithdrawRecordsWithPageIndex:(NSString*)pageIndex
{
    [HTTPManager getWithdrawRecordsWithUserId:[UserInfoData getUserInfoFromArchive].userId pageIndex:pageIndex pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSMutableArray *listArray=[[resultDict objectForKey:@"list"] mutableCopy];
            if (listArray.count>0)
            {
                for (NSDictionary *recordsDict in listArray)
                {
                    NSString *recordsId=[recordsDict objectForKey:@"tradeId"];
                    
                    if (![self.recordsIdArray containsObject:recordsId])
                    {
                        [self.recordsIdArray addObject:recordsId];
                        [self.recordsArray addObject:recordsDict];
                    }
                }
                
                [_tableView reloadData];
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            else
            {
                if (self.recordsArray.count==0)
                {
                    if (!_blankLabel)
                    {
                        _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                        _blankLabel.text=@"暂无提现记录~~";
                        _blankLabel.font=FONT(17, 15);
                        _blankLabel.textAlignment=NSTextAlignmentCenter;
                        [self.view addSubview:_blankLabel];
                    }
                    else
                    {
                        _blankLabel.text=@"暂无提现记录~~";
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
        }
        else
        {
            [self.view makeToast:@"获取提现记录失败，请重试。" duration:1.0];
        }
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"明细";
    
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
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"收入记录",@"提现记录", nil];
    
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WZ(45), SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(45))];
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
    if (self.btnIndex==0)
    {
        //收入记录
        [self getIncomRecordsWithPageIndex:@"1"];
    }
    if (self.btnIndex==1)
    {
        //提现记录
        [self getWithdrawRecordsWithPageIndex:@"1"];
    }
    
    [_tableView headerEndRefreshing];
}

//上拉加载
-(void)getMoreData
{
    self.pageIndex=self.pageIndex+1;
    if (self.btnIndex==0)
    {
        //收入记录
        [self getIncomRecordsWithPageIndex:[NSString stringWithFormat:@"%ld",self.pageIndex]];
    }
    if (self.btnIndex==1)
    {
        //提现记录
        [self getWithdrawRecordsWithPageIndex:[NSString stringWithFormat:@"%ld",self.pageIndex]];
    }
    
    [_tableView footerEndRefreshing];
}


#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordsArray.count;
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
    
    NSDictionary *recordDict=self.recordsArray[indexPath.row];
    NSString *tradeId=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"tradeId"]];
    NSInteger flag=[[recordDict objectForKey:@"flag"] integerValue];
    NSString *money=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"money"]];
    NSString *date=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"date1"]];
    
    if ([date isEqualToString:@"(null)"] || [date isEqualToString:@""])
    {
        date=@"无";
    }
    
    NSString *flagString;
    if (self.btnIndex==0)
    {
        //收入
        if (flag==0)
        {
            flagString=@"正常";
        }
        if (flag==1)
        {
            flagString=@"已充值";
        }
        if (flag==2)
        {
            flagString=@"已退货";
        }
        if (flag==3)
        {
            flagString=@"已撤销";
        }
    }
    if (self.btnIndex==1)
    {
        if (flag==0)
        {
            flagString=@"未结算";
        }
        if (flag==1)
        {
            flagString=@"已结算";
        }
        if (flag==2)
        {
            flagString=@"申请中";
        }
    }
    
    UILabel *numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(130), WZ(30))];
    numberLabel.text=tradeId;
    numberLabel.font=FONT(11,9);
    numberLabel.textColor=COLOR_BLACK;
//    numberLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:numberLabel];
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(numberLabel.right+WZ(10), 0, WZ(45), WZ(30))];
    statusLabel.font=FONT(11,9);
    statusLabel.text=flagString;
    statusLabel.textColor=COLOR_BLACK;
//    statusLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:statusLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(statusLabel.right+WZ(10), 0, WZ(75), WZ(30))];
    jineLabel.text=[NSString stringWithFormat:@"¥ %.2f",[money floatValue]];
    jineLabel.font=FONT(11,9);
    jineLabel.textColor=COLOR_BLACK;
//    jineLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:jineLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), 0, WZ(70), WZ(30))];
    timeLabel.text=date;
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_BLACK;
//    timeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:timeLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(30))];
    statusView.backgroundColor=COLOR_WHITE;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, statusView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [statusView addSubview:lineView];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(130), statusView.height)];
    timeLabel.text=@"流水号";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
//    timeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:timeLabel];
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right+WZ(10), 0, WZ(45), statusView.height)];
    typeLabel.font=FONT(15,13);
    typeLabel.text=@"状态";
    typeLabel.textColor=COLOR_LIGHTGRAY;
//    typeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:typeLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), 0, WZ(75), statusView.height)];
    jineLabel.text=@"金额";
    jineLabel.font=FONT(15,13);
    jineLabel.textColor=COLOR_LIGHTGRAY;
//    jineLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:jineLabel];
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), 0, WZ(70), statusView.height)];
    statusLabel.text=@"交易时间";
    statusLabel.font=FONT(15,13);
    statusLabel.textColor=COLOR_LIGHTGRAY;
//    statusLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:statusLabel];
    
    return statusView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(30);
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//收入记录 提现记录界面切换
-(void)topBtnClick:(UIButton*)button
{
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
    
    if (self.btnIndex!=button.tag)
    {
        [self.recordsArray removeAllObjects];
        [self.recordsIdArray removeAllObjects];
        
        if (button.tag==0)
        {
            [self getIncomRecordsWithPageIndex:@"1"];
        }
        if (button.tag==1)
        {
            [self getWithdrawRecordsWithPageIndex:@"1"];
        }
    }
    
    self.btnIndex=button.tag;
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
