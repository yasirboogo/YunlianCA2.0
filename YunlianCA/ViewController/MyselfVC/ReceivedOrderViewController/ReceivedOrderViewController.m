//
//  ReceivedOrderViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/1.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ReceivedOrderViewController.h"

#import "OrderTableViewCell.h"
#import "RefundDetailViewController.h"
#import "DetailOrderViewController.h"


@interface ReceivedOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIScrollView *_bottomScrollView;
    UIView *_lineView;
    UIView *_topView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,strong)NSString *orderType;//订单类型

@property(nonatomic,strong)NSMutableArray *bigOrderArray;
@property(nonatomic,strong)NSMutableArray *bigOrderIdArray;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger buttonIndex;

@end

@implementation ReceivedOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonIndex=0;
    self.pageNum=1;
    self.orderType=@"0";
    self.topBtnArray=[NSMutableArray array];
    self.bigOrderArray=[NSMutableArray array];
    self.bigOrderIdArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createSubviews];
    [self createTableView];
    
    
    
    
}

//获取收到的订单数据
-(void)getReceivedOrderData
{
    [HTTPManager getOrderListOfStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:@"1" pageSize:@"20" complete:^(OrderModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            for (NSDictionary *orderDict in model.orderListArray)
            {
                NSString *orderId=[orderDict objectForKey:@"id"];
                
                if (![self.bigOrderIdArray containsObject:orderId])
                {
                    [self.bigOrderIdArray addObject:orderId];
                    [self.bigOrderArray addObject:orderDict];
                }
            }
            
            [_tableView reloadData];
            
            if (model.orderListArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无订单~~";
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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getReceivedOrderData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"收到的订单";
    
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
    
//    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"未处理",@"已确认",@"已完成",@"已关闭",@"退款处理", nil];
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"待发货",@"已确认",@"已完成",@"已关闭", nil];
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/4.0;
    CGFloat lineWidth=WZ(30);
    
    for (NSInteger i=0; i<titleArray.count; i++)
    {
        UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+btnWidth*i, 0, btnWidth, _topView.height)];
        topBtn.tag=i;
        topBtn.titleLabel.font=FONT(15,13);
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-64-_topView.height)];
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
    switch (self.buttonIndex)
    {
        case 0:
            self.orderType=@"0";
            break;
        case 1:
            self.orderType=@"1";
            break;
        case 2:
            self.orderType=@"3";
            break;
        case 3:
            self.orderType=@"4";
            break;
        case 4:
            self.orderType=@"5";
            break;
        default:
            break;
    }
    
    [HTTPManager getOrderListOfStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:@"1" pageSize:@"20" complete:^(OrderModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            for (NSDictionary *orderDict in model.orderListArray)
            {
                NSString *orderId=[orderDict objectForKey:@"id"];
                
                if (![self.bigOrderIdArray containsObject:orderId])
                {
                    [self.bigOrderIdArray addObject:orderId];
                    [self.bigOrderArray addObject:orderDict];
                }
            }
            
            //结束刷新
            [_tableView headerEndRefreshing];
            [_tableView reloadData];
            
            if (model.orderListArray.count>0)
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
    
    switch (self.buttonIndex)
    {
        case 0:
            self.orderType=@"0";
            break;
        case 1:
            self.orderType=@"1";
            break;
        case 2:
            self.orderType=@"3";
            break;
        case 3:
            self.orderType=@"4";
            break;
        case 4:
            self.orderType=@"5";
            break;
        default:
            break;
    }
    
    [HTTPManager getOrderListOfStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(OrderModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            for (NSDictionary *orderDict in model.orderListArray)
            {
                NSString *orderId=[orderDict objectForKey:@"id"];
                
                if (![self.bigOrderIdArray containsObject:orderId])
                {
                    [self.bigOrderIdArray addObject:orderId];
                    [self.bigOrderArray addObject:orderDict];
                }
            }
            
            //结束刷新
            [_tableView footerEndRefreshing];
            [_tableView reloadData];
            
            if (model.orderListArray.count>0)
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
    return self.bigOrderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *orderDict=self.bigOrderArray[indexPath.row];
    NSString *orderNum=[NSString stringWithFormat:@"%@",[orderDict objectForKey:@"orderNum"]];
    NSString *tradeNum=[NSString stringWithFormat:@"%@",[orderDict objectForKey:@"tradeId"]];
    NSInteger isOnline=[[orderDict objectForKey:@"isOnline"] integerValue];//0线上 1线下
    NSString *merchantName=[orderDict objectForKey:@"merchantName"];
    
    if ([tradeNum isEqualToString:@"(null)"])
    {
        tradeNum=@"无";
    }
    NSArray *goodsArray=[orderDict objectForKey:@"orderItemSet"];
    NSString *goodsImg;
    NSString *goodsName;
    NSString *goodsCount;
    NSString *goodsPrice;
    if (goodsArray.count>0)
    {
        NSDictionary *goodsDict=[goodsArray firstObject];
        goodsImg=[goodsDict objectForKey:@"itemImg"];
        goodsName=[goodsDict objectForKey:@"itemName"];
        goodsCount=[goodsDict objectForKey:@"count"];
        goodsPrice=[goodsDict objectForKey:@"amount"];
    }
    NSString *money=[NSString stringWithFormat:@"%.2f",[[orderDict objectForKey:@"sfMoney"] floatValue]];
    
    NSInteger status=[[orderDict objectForKey:@"status"] integerValue];
    NSString *ztString;
    switch (status)
    {
        case 0:
            ztString=@"待收货";//删除
            break;
        case 1:
            ztString=@"未处理";//确认订单
            break;
        case 2:
            ztString=@"已确认";//无按钮
            break;
        case 3:
            ztString=@"已完成";//无按钮
            break;
        case 4:
            ztString=@"申请退款";//确认退款
            break;
        case 5:
            ztString=@"确认退款";//无按钮
            break;
        case 6:
            ztString=@"已关闭";//删除
        default:
            break;
    }
    
    if (isOnline==1)
    {
        //线下订单
        static NSString *cellIdentifier=@"OrderTableViewCell7";
        OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
        cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
        cell.bgView.frame=CGRectMake(0, cell.ddhLabel.bottom+cell.lsLabel.height+WZ(5), SCREEN_WIDTH, WZ(30));
        cell.skrLabel.frame=CGRectMake(WZ(15), cell.ddhLabel.bottom+cell.lsLabel.height+WZ(5), SCREEN_WIDTH-WZ(15*2), WZ(30));
        cell.skrLabel.text=[NSString stringWithFormat:@"收款人：%@",merchantName];
        
        NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
        CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
        cell.sfLabel.text=sfString;
        cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
        
        cell.ztLabel.text=ztString;
        
        UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.sfLabel.bottom, SCREEN_WIDTH, WZ(10))];
        smallView.backgroundColor=COLOR_HEADVIEW;
        [cell.contentView addSubview:smallView];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if (status==0)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell0";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            [cell.orderLeftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            cell.orderLeftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), lineView.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderLeftBtn.orderDict=orderDict;
            [cell.orderLeftBtn addTarget:self action:@selector(shanChuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.orderLeftBtn.bottom+WZ(10), SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (status==1)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell1";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            [cell.orderRightBtn setTitle:@"确认发货" forState:UIControlStateNormal];
            cell.orderRightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), cell.sfLabel.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderRightBtn.orderDict=orderDict;
            [cell.orderRightBtn addTarget:self action:@selector(queRenDingDanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.orderRightBtn.bottom+WZ(10), SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (status==2)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell2";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (status==3)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell3";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (status==4)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell4";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            [cell.orderRightBtn setTitle:@"确认退款" forState:UIControlStateNormal];
            cell.orderRightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), cell.sfLabel.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderRightBtn.orderDict=orderDict;
            [cell.orderRightBtn addTarget:self action:@selector(queRenTuiKuanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.orderRightBtn.bottom+WZ(10), SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (status==5)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell5";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            static NSString *cellIdentifier=@"OrderTableViewCell6";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            cell.lsLabel.text=[NSString stringWithFormat:@"流水号：%@",tradeNum];
            [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
            cell.nameLabel.text=goodsName;
            cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsPrice,goodsCount];
            
            NSString *sfString=[NSString stringWithFormat:@"实付:¥ %@",money];
            CGSize sfSize=[ViewController sizeWithString:sfString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.sfLabel.text=sfString;
            cell.sfLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-sfSize.width, cell.bgView.bottom, sfSize.width, WZ(40));
            
            NSString *slString=[NSString stringWithFormat:@"共%lu件商品",(unsigned long)goodsArray.count];
            CGSize slSize=[ViewController sizeWithString:slString font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(40))];
            cell.slLabel.text=slString;
            cell.slLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-slSize.width-WZ(10)-sfSize.width, cell.sfLabel.top, slSize.width, WZ(40));
            
            cell.ztLabel.text=ztString;
            
            UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), cell.sfLabel.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
            [cell.contentView addSubview:lineView];
            
            //        [cell.orderLeftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            //        cell.orderLeftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), lineView.bottom+WZ(10), WZ(90), WZ(40));
            //        cell.orderLeftBtn.orderDict=orderDict;
            //        [cell.orderLeftBtn addTarget:self action:@selector(shanChuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, WZ(10))];
            smallView.backgroundColor=COLOR_HEADVIEW;
            [cell.contentView addSubview:smallView];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
    
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *orderDict=self.bigOrderArray[indexPath.row];
    NSInteger status=[[orderDict objectForKey:@"status"] integerValue];
    NSInteger isOnline=[[orderDict objectForKey:@"isOnline"] integerValue];//0线上 1线下
    
    if (isOnline==0)
    {
        if (status==4 || status==5)
        {
            //如果是退款订单 跳转到退款情况界面
            RefundDetailViewController *vc=[[RefundDetailViewController alloc]init];
            vc.orderDict=orderDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //订单详情界面
            DetailOrderViewController *vc=[[DetailOrderViewController alloc]init];
            vc.orderDict=orderDict;
            vc.isReceivedOrderVC=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *orderDict=self.bigOrderArray[indexPath.row];
    NSInteger status=[[orderDict objectForKey:@"status"] integerValue];
    NSInteger isOnline=[[orderDict objectForKey:@"isOnline"] integerValue];//0线上 1线下
    
    if (isOnline==1)
    {
        return WZ(130+10);
    }
    else
    {
        if (status==0 || status==1 || status==4)// || status==6
        {
            return WZ(175+60+10);
        }
        else
        {
            return WZ(175+10);
        }
    }
    
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//各类型订单切换
-(void)topBtnClick:(UIButton*)button
{
    self.buttonIndex=button.tag;
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/4.0;
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
    
    switch (button.tag)
    {
        case 0:
            self.orderType=@"0";
            break;
        case 1:
            self.orderType=@"1";
            break;
        case 2:
            self.orderType=@"3";
            break;
        case 3:
            self.orderType=@"4";
            break;
//        case 4:
//            self.orderType=@"5";
//            break;
        default:
            break;
    }
    
    [HTTPManager getOrderListOfStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:@"1" pageSize:@"20" complete:^(OrderModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            self.pageNum=1;
            [self.bigOrderArray removeAllObjects];
            [self.bigOrderIdArray removeAllObjects];
            
            for (NSDictionary *orderDict in model.orderListArray)
            {
                NSString *orderId=[orderDict objectForKey:@"id"];
                
                if (![self.bigOrderIdArray containsObject:orderId])
                {
                    [self.bigOrderIdArray addObject:orderId];
                    [self.bigOrderArray addObject:orderDict];
                }
            }
            
            [_tableView reloadData];
            
            if (model.orderListArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无订单~~";
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

//删除
-(void)shanChuBtnClick:(OrderLeftBtn*)leftBtn
{
    NSString *orderId=[leftBtn.orderDict objectForKey:@"id"];
    [HTTPManager deleteOrderWithOrderId:orderId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.bigOrderArray removeObject:leftBtn.orderDict];
            [_tableView reloadData];
            [self.view makeToast:@"删除订单成功" duration:1.0];
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:1.0];
        }
    }];
}

//确认订单
-(void)queRenDingDanBtnClick:(OrderRightBtn*)rightBtn
{
    NSString *orderId=[rightBtn.orderDict objectForKey:@"id"];
    [HTTPManager confirmSendOutWithPayInfoId:orderId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.bigOrderArray removeObject:rightBtn.orderDict];
            [_tableView reloadData];
            [self.view makeToast:@"已确认订单" duration:1.0];
        }
        else
        {
            [self.view makeToast:@"确认订单失败，请重试。" duration:1.0];
        }
    }];
}

//确认退款
-(void)queRenTuiKuanBtnClick:(OrderRightBtn*)rightBtn
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
