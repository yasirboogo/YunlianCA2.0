//
//  RedEnvelopeRecordsViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/12/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RedEnvelopeRecordsViewController.h"

@interface RedEnvelopeRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_lineView;
    UIView *_topView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,strong)NSMutableArray *recordsArray;
@property(nonatomic,strong)NSMutableArray *recordsIdArray;
@property(nonatomic,assign)NSInteger btnIndex;
@property(nonatomic,assign)NSInteger pageIndex;






@end

@implementation RedEnvelopeRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    self.pageIndex=1;
    self.btnIndex=0;
    self.topBtnArray=[NSMutableArray array];
    self.recordsIdArray=[NSMutableArray array];
    self.recordsArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createSubviews];
    [self createTableView];
    
    
    
    
    
}

//获取红包收入记录
-(void)getIncomRecordsWithPageIndex:(NSString*)pageIndex
{
    [HTTPManager ReceivedRedEnvelopeListUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:pageIndex pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *dataArray=[[listDict objectForKey:@"data"] mutableCopy];
            if (dataArray.count>0)
            {
                for (NSDictionary *recordsDict in dataArray)
                {
                    NSString *recordsId=[recordsDict objectForKey:@"id"];
                    
                    if (![self.recordsIdArray containsObject:recordsId])
                    {
                        [self.recordsIdArray addObject:recordsId];
                        [self.recordsArray addObject:recordsDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            else
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂没收到红包~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
                else
                {
                    _blankLabel.text=@"暂没收到红包~~";
                }
                
//                if (self.recordsArray.count==0)
//                {
//                    
//                }
//                else
//                {
//                    if (_blankLabel)
//                    {
//                        [_blankLabel removeFromSuperview];
//                        _blankLabel=nil;
//                    }
//                }
            }
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:2.0];
        }
        
        [_tableView reloadData];
    }];
    
}

//获取红包发出记录
-(void)getWithdrawRecordsWithPageIndex:(NSString*)pageIndex
{
    [HTTPManager sendRedEnvelopeListUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:pageIndex pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *dataArray=[[listDict objectForKey:@"data"] mutableCopy];
            if (dataArray.count>0)
            {
                for (NSDictionary *recordsDict in dataArray)
                {
                    NSString *recordsId=[recordsDict objectForKey:@"id"];
                    
                    if (![self.recordsIdArray containsObject:recordsId])
                    {
                        [self.recordsIdArray addObject:recordsId];
                        [self.recordsArray addObject:recordsDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            else
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂没发出红包~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
                else
                {
                    _blankLabel.text=@"暂没发出红包~~";
                }
                
//                if (self.recordsArray.count==0)
//                {
//                    
//                }
//                else
//                {
//                    if (_blankLabel)
//                    {
//                        [_blankLabel removeFromSuperview];
//                        _blankLabel=nil;
//                    }
//                }
                
                
            }
            
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:2.0];
        }
        
        [_tableView reloadData];
    }];
}
//获取红包退款明细记录
-(void)getWithRefundRecordsWithPageIndex:(NSString*)pageIndex
{
    [HTTPManager ReceivedRedEnvelopeRefundDetailsUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:pageIndex pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *dataArray=[[listDict objectForKey:@"data"] mutableCopy];
            if (dataArray.count>0)
            {
                for (NSDictionary *recordsDict in dataArray)
                {
                    NSString *recordsId=[recordsDict objectForKey:@"id"];
                    
                    if (![self.recordsIdArray containsObject:recordsId])
                    {
                        [self.recordsIdArray addObject:recordsId];
                        [self.recordsArray addObject:recordsDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            else
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂没红包退款~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
                else
                {
                    _blankLabel.text=@"暂没红包退款~~";
                }
                
                //                if (self.recordsArray.count==0)
                //                {
                //
                //                }
                //                else
                //                {
                //                    if (_blankLabel)
                //                    {
                //                        [_blankLabel removeFromSuperview];
                //                        _blankLabel=nil;
                //                    }
                //                }
                
                
            }
            
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:2.0];
        }
        
        [_tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getIncomRecordsWithPageIndex:@"1"];
}

-(void)createNavigationBar
{
    self.title=@"红包明细";
    
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
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"收到的红包",@"发出的红包",@"红包退款", nil];
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/3.0;
    CGFloat lineWidth=WZ(30);
    
    for (NSInteger i=0; i<titleArray.count; i++)
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
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    if (self.btnIndex==0)
    {
        //收到记录
        [self getIncomRecordsWithPageIndex:@"1"];
    }
    if (self.btnIndex==1)
    {
        //发出记录
        [self getWithdrawRecordsWithPageIndex:@"1"];
    }
    if (self.btnIndex==2)
    {
        //红包退款的记录
        [self getWithRefundRecordsWithPageIndex:@"1"];
    }
    [_tableView headerEndRefreshing];
}

//上拉加载
-(void)getMoreData
{
    self.pageIndex=self.pageIndex+1;
    if (self.btnIndex==0)
    {
        //收到记录
        [self getIncomRecordsWithPageIndex:[NSString stringWithFormat:@"%ld",self.pageIndex]];
    }
    if (self.btnIndex==1)
    {
        //发出记录
        [self getWithdrawRecordsWithPageIndex:[NSString stringWithFormat:@"%ld",self.pageIndex]];
    }
    if (self.btnIndex==2)
    {
        //红包退款的记录
        [self getWithRefundRecordsWithPageIndex:[NSString stringWithFormat:@"%ld",self.pageIndex]];
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
    
    NSDictionary *dict=self.recordsArray[indexPath.row];
    NSString *nickName=[dict objectForKey:@"nickName"];
    NSString *time=[NSString stringWithFormat:@"%@",[dict objectForKey:@"time"]];
    NSString *money=[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"money"] floatValue]];
    NSInteger isAdmin=[[dict objectForKey:@"isAdmin"] integerValue];
    NSString *imgUrlString=[dict objectForKey:@"userImg"];
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
    }
    
    UIButton *userBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(12), WZ(5), WZ(30), WZ(30))];
    userBtn.layer.cornerRadius=userBtn.width/2.0;
    userBtn.clipsToBounds=YES;
    [cell.contentView addSubview:userBtn];
    if (isAdmin==0)
    {
        [userBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    }
    if (isAdmin==1)
    {
        [userBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
    }
    
    UILabel *userLabel=[[UILabel alloc]initWithFrame:CGRectMake(userBtn.right+WZ(5), userBtn.top, WZ(120-5)-userBtn.width, userBtn.height)];
    userLabel.text=nickName;
    userLabel.font=FONT(11,9);
    userLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:userLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(userLabel.right+WZ(10), userBtn.top, WZ(90), userBtn.height)];
    jineLabel.text=[NSString stringWithFormat:@"￥ %@",money];
    jineLabel.font=FONT(11,9);
    jineLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:jineLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), userBtn.top, WZ(120), userBtn.height)];
    timeLabel.text=[NSString stringWithFormat:@"%@",time];
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_BLACK;
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
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(120), statusView.height)];
    nameLabel.text=@"用户";
//  nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR_LIGHTGRAY;
//    nameLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+WZ(10), 0, WZ(90), statusView.height)];
    moneyLabel.text=@"金额";
//    moneyLabel.textAlignment=NSTextAlignmentCenter;
    moneyLabel.font=FONT(15,13);
    moneyLabel.textColor=COLOR_LIGHTGRAY;
//    moneyLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), 0, WZ(120), statusView.height)];
//    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text=@"时间";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
//    timeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:timeLabel];
    
    return statusView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(40);
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

//收到记录 发送记录界面切换
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
                
                _lineView.frame=CGRectMake(leftMargin+btnWidth*button.tag+(btnWidth-lineWidth)/2.0, _topView.bottom-WZ(10), lineWidth, 1);
                
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
        if (button.tag==2)
        {
            [self getWithRefundRecordsWithPageIndex:@"1"];
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
