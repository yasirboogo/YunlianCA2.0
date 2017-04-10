//
//  MyOrderViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/15.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyOrderViewController.h"

#import "OrderTableViewCell.h"
#import "DetailOrderViewController.h"
#import "OrderCommentViewController.h"
#import "ApplyRefundViewController.h"
#import "RefundDetailViewController.h"
#import "RechargeViewController.h"


@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_lineView;
    UIView *_topView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,strong)NSString *orderType;
//@property(nonatomic,strong)OrderModel *orderModel;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)UITextField *passwordTF;
@property(nonatomic,strong)NSString *payOrderId;//支付订单id
@property(nonatomic,strong)NSDictionary *payOrderDict;//支付订单字典

@property(nonatomic,strong)NSMutableArray *bigOrderArray;
@property(nonatomic,strong)NSMutableArray *bigOrderIdArray;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger buttonIndex;
@property(nonatomic,assign)NSInteger selectRow;


@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bigOrderArray=[NSMutableArray array];
    self.bigOrderIdArray=[NSMutableArray array];
    self.topBtnArray=[NSMutableArray array];
    self.orderType=@"";
    self.buttonIndex=0;
    self.pageNum=1;
    
    [self createNavigationBar];
    [self createSubviews];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isCommentNotification:) name:@"isComment" object:nil];
    
    
    
}

-(void)isCommentNotification:(NSNotification*)notification
{
    NSDictionary *dict=[notification userInfo];
    NSString *isOK=[dict objectForKey:@"isOK"];
    if ([isOK isEqualToString:@"yes"])
    {
        [self.bigOrderArray removeObjectAtIndex:self.selectRow];
        [self.bigOrderIdArray removeObjectAtIndex:self.selectRow];
        [_tableView reloadData];
    }
}

-(void)getOrderData
{
    [HTTPManager getOrderListOfUserWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:@"1" pageSize:@"20" complete:^(OrderModel *model) {
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
            
            [_tableView reloadData];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getOrderData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"我的订单";
    
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
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"全部",@"待付款",@"待收货",@"待评价",@"已完成", nil];
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/5.0;
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
            self.orderType=@"";
            break;
        case 1:
            self.orderType=@"0";
            break;
        case 2:
            self.orderType=@"1";
            break;
        case 3:
            self.orderType=@"3";
            break;
        case 4:
            self.orderType=@"4";
            break;
        case 5:
            self.orderType=@"5";
            break;
        default:
            break;
    }
    
    [HTTPManager getOrderListOfUserWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:@"1" pageSize:@"20" complete:^(OrderModel *model) {
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
            self.orderType=@"";
            break;
        case 1:
            self.orderType=@"0";
            break;
        case 2:
            self.orderType=@"1";
            break;
        case 3:
            self.orderType=@"3";
            break;
        case 4:
            self.orderType=@"4";
            break;
        case 5:
            self.orderType=@"5";
            break;
        default:
            break;
    }
    
    [HTTPManager getOrderListOfUserWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(OrderModel *model) {
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
//    NSLog(@"流水号===%@",tradeNum);
    
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
            ztString=@"未支付";//删除订单和立即支付
            break;
        case 1:
            ztString=@"待收货";//无按钮
            break;
        case 2:
            ztString=@"待收货";//确认收货
            break;
        case 3:
            ztString=@"已完成";//待评价和退货
            break;
        case 4:
            ztString=@"退货中";//无按钮
            break;
        case 5:
            ztString=@"退货完成";//无按钮
            break;
        case 6:
            ztString=@"已完成";//去评价
            break;
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
            
            [cell.orderRightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            cell.orderRightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), cell.sfLabel.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderRightBtn.orderDict=orderDict;
            [cell.orderRightBtn addTarget:self action:@selector(zhiFuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.orderLeftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            cell.orderLeftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15+90+15+90), cell.orderRightBtn.top, WZ(90), WZ(40));
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
            //        cell.lsLabel.frame=CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20));
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
        if (status==2)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell2";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            //        cell.lsLabel.frame=CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20));
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
            
            [cell.orderRightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            cell.orderRightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), cell.sfLabel.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderRightBtn.orderDict=orderDict;
            [cell.orderRightBtn addTarget:self action:@selector(shouHuoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.orderRightBtn.bottom+WZ(10), SCREEN_WIDTH, WZ(10))];
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
            //        cell.lsLabel.frame=CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20));
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
            
            [cell.orderRightBtn setTitle:@"去评价" forState:UIControlStateNormal];
            cell.orderRightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), cell.sfLabel.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderRightBtn.orderDict=orderDict;
            [cell.orderRightBtn addTarget:self action:@selector(pingJiaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            //        [cell.orderLeftBtn setTitle:@"退货" forState:UIControlStateNormal];
            //        cell.orderLeftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15+90+15+90), cell.orderRightBtn.top, WZ(90), WZ(40));
            //        cell.orderLeftBtn.orderDict=orderDict;
            //        [cell.orderLeftBtn addTarget:self action:@selector(tuiHuoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.orderRightBtn.bottom+WZ(10), SCREEN_WIDTH, WZ(10))];
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
            //        cell.lsLabel.frame=CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20));
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
        if (status==5)
        {
            static NSString *cellIdentifier=@"OrderTableViewCell5";
            OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[OrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.ddhLabel.text=[NSString stringWithFormat:@"订单号：%@",orderNum];
            //        cell.lsLabel.frame=CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20));
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
            //        cell.lsLabel.frame=CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20));
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
            
            [cell.orderRightBtn setTitle:@"去评价" forState:UIControlStateNormal];
            cell.orderRightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), cell.sfLabel.bottom+WZ(10), WZ(90), WZ(40));
            cell.orderRightBtn.orderDict=orderDict;
            [cell.orderRightBtn addTarget:self action:@selector(pingJiaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, cell.orderRightBtn.bottom+WZ(10), SCREEN_WIDTH, WZ(10))];
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
    self.selectRow=indexPath.row;
    
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
            vc.isMyOrderVC=YES;
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
        //    if (status==0)
        //    {
        //        return WZ(160+60+10);
        //    }
        if (status==1 || status==4 || status==5)
        {
            return WZ(175+10);
        }
        else
        {
            return WZ(175+60+10);
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
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/5.0;
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
    
    switch (button.tag)
    {
        case 0:
            self.orderType=@"";//全部
            break;
        case 1:
            self.orderType=@"0";//待付款
            break;
        case 2:
            self.orderType=@"1";//待收货
            break;
        case 3:
            self.orderType=@"5";//待评价
            break;
        case 4:
            self.orderType=@"3";//已完成
            break;
//        case 5:
//            self.orderType=@"4";//退款
//            break;
        default:
            break;
    }
    
    [HTTPManager getOrderListOfUserWithUserId:[UserInfoData getUserInfoFromArchive].userId status:self.orderType pageNum:@"1" pageSize:@"20" complete:^(OrderModel *model) {
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

//退货
-(void)tuiHuoBtnClick:(OrderLeftBtn*)leftBtn
{
    NSLog(@"退货订单信息===%@",leftBtn.orderDict);
    
    ApplyRefundViewController *vc=[[ApplyRefundViewController alloc]init];
    vc.orderDict=leftBtn.orderDict;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

//去评价
-(void)pingJiaBtnClick:(OrderRightBtn*)rightBtn
{
    //跳转商品评价界面
    OrderCommentViewController *vc=[[OrderCommentViewController alloc]init];
    vc.orderDict=rightBtn.orderDict;
    [self.navigationController pushViewController:vc animated:YES];
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
            [self.view makeToast:@"删除订单失败，请重试。" duration:1.0];
        }
    }];
}

//支付
-(void)zhiFuBtnClick:(OrderRightBtn*)rightBtn
{
    self.payOrderDict=rightBtn.orderDict;
    self.payOrderId=[rightBtn.orderDict objectForKey:@"id"];
    
    [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@""];
}

//确认收货
-(void)shouHuoBtnClick:(OrderRightBtn*)rightBtn
{
    NSString *orderId=[rightBtn.orderDict objectForKey:@"id"];
    [HTTPManager confirmReceivingWithPayInfoId:orderId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.bigOrderArray removeObject:rightBtn.orderDict];
            [_tableView reloadData];
            [self.view makeToast:@"已确认收货" duration:1.0];
        }
        else
        {
            [self.view makeToast:@"确认收货失败，请重试。" duration:1.0];
        }
    }];
}


//创建背景View
-(void)createBackgroundViewWithSmallViewTitle:(NSString *)title detail:(NSString*)detail
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self.view.window addSubview:bgView];
    self.bgView=bgView;
    
    CGFloat spaceToBorder=WZ(20);
    CGFloat smallViewWidth=SCREEN_WIDTH-WZ(30*2);
    
    CGSize titleSize=[ViewController sizeWithString:title font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(30))];
    CGSize detailSize=[ViewController sizeWithString:detail font:FONT(15, 13) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(100))];
    
    CGFloat smallViewHeight=WZ(15*4+20)+titleSize.height+detailSize.height+WZ(35)+WZ(35);
    
    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(WZ(30), WZ(180), smallViewWidth, smallViewHeight)];
    smallView.backgroundColor=COLOR_WHITE;
    smallView.clipsToBounds=YES;
    smallView.layer.cornerRadius=5;
    [self.bgView addSubview:smallView];
    self.smallView=smallView;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), titleSize.height)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    titleLabel.text=title;
    titleLabel.textColor=COLOR_BLACK;
    titleLabel.font=FONT(17, 15);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [smallView addSubview:titleLabel];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, titleLabel.bottom+WZ(15), smallView.width-WZ(spaceToBorder*2), detailSize.height)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    detailLabel.text=detail;
    detailLabel.textColor=COLOR_LIGHTGRAY;
    detailLabel.font=FONT(15, 13);
    detailLabel.numberOfLines=0;
    detailLabel.textAlignment=NSTextAlignmentLeft;
    [smallView addSubview:detailLabel];
    
    UITextField *passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(spaceToBorder, detailLabel.bottom+WZ(10), smallView.width-WZ(spaceToBorder*2), WZ(35))];
    passwordTF.placeholder=@"请输入支付密码";
    passwordTF.secureTextEntry=YES;
    passwordTF.clipsToBounds=YES;
    passwordTF.layer.cornerRadius=5;
    passwordTF.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    passwordTF.layer.borderWidth=1.0;
    [smallView addSubview:passwordTF];
    self.passwordTF=passwordTF;
    
    NSArray *qxqdArray=[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];
    
    CGFloat buttonWidth=WZ(100);
    CGFloat buttonHeight=WZ(35);
    CGFloat buttonSpace=smallViewWidth-buttonWidth*2-spaceToBorder*2;
    
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *qxqdBtn=[[UIButton alloc]initWithFrame:CGRectMake(spaceToBorder+(buttonWidth+buttonSpace)*(i%2), smallViewHeight-buttonHeight-WZ(20), buttonWidth, buttonHeight)];
        [qxqdBtn setTitle:qxqdArray[i] forState:UIControlStateNormal];
        qxqdBtn.titleLabel.font=FONT(17, 15);
        qxqdBtn.clipsToBounds=YES;
        qxqdBtn.layer.cornerRadius=5;
        qxqdBtn.tag=i;
        [qxqdBtn addTarget:self action:@selector(qxqdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:qxqdBtn];
        
        if (i==0)
        {
            [qxqdBtn setTitleColor:COLOR(98, 99, 100, 1) forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(230, 235, 235, 1);
        }
        if (i==1)
        {
            [qxqdBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(254, 153, 160, 1);
        }
    }
}

#warning 判断余额是否足够
//取消确定按钮
-(void)qxqdBtnClick:(UIButton*)button
{
    if (button.tag==0)
    {
        //取消 移除bgView
        [self.bgView removeFromSuperview];
    }
    if (button.tag==1)
    {
        //确定 移除bgView
        [self.bgView removeFromSuperview];
        
        if (self.payOrderId==nil)
        {
            self.payOrderId=@"";
        }
        
        //确认支付
        [HTTPManager payOrderWithPayInfoId:self.payOrderId ymlPayPass:self.passwordTF.text complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.bigOrderArray removeObject:self.payOrderDict];
                [_tableView reloadData];
                [self.view makeToast:@"订单支付成功" duration:1.0];
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:1.0];
                
                //如果余额不足 跳转充值界面
                if ([msg containsString:@"余额不足"])
                {
                    RechargeViewController *vc=[[RechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
        
        
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
