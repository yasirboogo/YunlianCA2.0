//
//  DetailOrderViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "DetailOrderViewController.h"

#import "DetailOrderTopCell.h"
#import "DetailOrderGoodsCell.h"
#import "ApplyRefundViewController.h"
#import "OrderCommentViewController.h"
#import "PaySuccessViewController.h"

@interface DetailOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)NSDictionary *orderInfoDict;
@property(nonatomic,strong)NSDictionary *buyerInfoDict;
@property(nonatomic,strong)NSArray *goodsArray;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,assign)NSInteger orderStatus;
@property(nonatomic,strong)NSString *userCoupon;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)UITextField *passwordTF;

@end

@implementation DetailOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userCoupon=@"0";
    //此界面原本无需判断订单状态为4、5（退货中、退货完成）的情况 但为防止后续状态变化所以加了判断
    
    self.orderId=[NSString stringWithFormat:@"%@",[self.orderDict objectForKey:@"id"]];
    self.orderStatus=[[self.orderDict objectForKey:@"status"] integerValue];
    
    [self createNavigationBar];
    [self createTableView];
    
    if (self.isMyOrderVC==YES || self.isPaySuccessVC==YES || self.isOrderDetailVC==YES)
    {
        if (self.orderStatus!=1 && self.orderStatus!=4 && self.orderStatus!=5)
        {
            [self createBottomView];
        }
    }
    if (self.isReceivedOrderVC==YES)
    {
        if (self.orderStatus!=2 && self.orderStatus!=3 && self.orderStatus!=5 && self.orderStatus!=6)
        {
            [self createBottomView];
        }
    }
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getOrderDetail];
}

//获取订单详情
-(void)getOrderDetail
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [HTTPManager getOrderDetailWithOrderId:self.orderId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [hud hide:YES];
            self.orderInfoDict=[resultDict objectForKey:@"payInfo"];
            self.buyerInfoDict=[resultDict objectForKey:@"receiptInfo"];
            self.goodsArray=[self.orderInfoDict objectForKey:@"orderItemSet"];
            self.userCoupon=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"userCoupon"]];
            
            [_tableView reloadData];
        }
        else
        {
            [hud hide:YES];
            [self.view makeToast:@"加载数据失败，请重试。" duration:2.0];
        }
    }];
    [hud hide:YES afterDelay:20];
}

-(void)createNavigationBar
{
    self.title=@"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createBottomView
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(50), SCREEN_WIDTH, WZ(50))];
    bottomView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:bottomView];
    
    OrderDetailRightBtn *rightBtn=[[OrderDetailRightBtn alloc]init];
    rightBtn.backgroundColor=COLOR(254, 167, 173, 1);
    [rightBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    rightBtn.titleLabel.font=FONT(15,13);
    rightBtn.clipsToBounds=YES;
    rightBtn.layer.cornerRadius=5.0;
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightBtn];
    
    OrderDetailLeftBtn *leftBtn=[[OrderDetailLeftBtn alloc]init];
    [leftBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    leftBtn.titleLabel.font=FONT(15,13);
    leftBtn.clipsToBounds=YES;
    leftBtn.layer.cornerRadius=5.0;
    leftBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    leftBtn.layer.borderWidth=1;
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftBtn];
    
    if (self.isMyOrderVC==YES || self.isPaySuccessVC==YES || self.isOrderDetailVC==YES)
    {
        if (self.orderStatus==0)
        {
            rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
            [rightBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            
            leftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(90*2+15*2), WZ(5), WZ(90), WZ(40));
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        }
        if (self.orderStatus==2)
        {
            rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
            [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            leftBtn.frame=CGRectMake(0, 0, 0, 0);
        }
        if (self.orderStatus==3)
        {
            rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
            [rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
            
            leftBtn.frame=CGRectMake(0, 0, 0, 0);
//            leftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(90*2+15*2), WZ(5), WZ(90), WZ(40));
//            [leftBtn setTitle:@"退货" forState:UIControlStateNormal];
        }
        if (self.orderStatus==6)
        {
            rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
            [rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
            
            leftBtn.frame=CGRectMake(0, 0, 0, 0);
        }
    }
    if (self.isReceivedOrderVC==YES)
    {
        if (self.orderStatus==1)
        {
            rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
            [rightBtn setTitle:@"确认发货" forState:UIControlStateNormal];
            
            leftBtn.frame=CGRectMake(0, 0, 0, 0);
        }
        if (self.orderStatus==4)
        {
//            rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
//            [rightBtn setTitle:@"确认退款" forState:UIControlStateNormal];
            bottomView.frame=CGRectMake(0, 0, 0, 0);
            leftBtn.frame=CGRectMake(0, 0, 0, 0);
        }
        if (self.orderStatus==0)// ||self.orderStatus==6
        {
            leftBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(90), WZ(5), WZ(90), WZ(40));
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            
            rightBtn.frame=CGRectMake(0, 0, 0, 0);
        }
    }
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    if (self.isMyOrderVC==YES || self.isPaySuccessVC==YES || self.isOrderDetailVC==YES)
    {
        if (self.orderStatus!=1 && self.orderStatus!=4 && self.orderStatus!=5)
        {
            _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(50));
        }
        else
        {
            _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
    }
    if (self.isReceivedOrderVC==YES)
    {
        if (self.orderStatus!=2 && self.orderStatus!=3 && self.orderStatus!=5 && self.orderStatus!=6)
        {
            _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(50));
        }
        else
        {
            _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
    }
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    if (section==1)
    {
        return self.goodsArray.count;
    }
    else
    {
        NSInteger userCoupon=[self.userCoupon integerValue];
        if (userCoupon>0)
        {
            return 3;
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
        if (self.isMyOrderVC==YES || self.isPaySuccessVC==YES || self.isOrderDetailVC==YES)
        {
            static NSString *cellIdentifier=@"DetailOrderTopCell";
            DetailOrderTopCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[DetailOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            NSString *orderNum=[NSString stringWithFormat:@"%@",[self.orderInfoDict objectForKey:@"orderNum"]];
            NSString *tradeNum0=[NSString stringWithFormat:@"%@",[self.orderInfoDict objectForKey:@"tradeId"]];
            NSString *tradeNum=@"";
            if ([tradeNum0 isEqualToString:@"(null)"])
            {
                tradeNum=@"流水编号：无";
            }
            else
            {
                tradeNum=[NSString stringWithFormat:@"流水编号：%@",tradeNum0];
            }
            
            NSString *createtime=[self.orderInfoDict objectForKey:@"createtime"];
            NSInteger status=[[self.orderInfoDict objectForKey:@"status"] integerValue];
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
                    ztString=@"已关闭";//去评价
                    break;
                default:
                    break;
            }
            
            NSString *username=[self.buyerInfoDict objectForKey:@"username"];
            NSString *userphone=[NSString stringWithFormat:@"%@",[self.buyerInfoDict objectForKey:@"userphone"]];
            NSString *address=[self.buyerInfoDict objectForKey:@"address"];
            NSString *city=[self.buyerInfoDict objectForKey:@"city"];
            NSString *detailAddress=[NSString stringWithFormat:@"%@%@",city,address];
            
            cell.statusLabel.text=ztString;
            cell.orderNumLabel.text=orderNum;
            cell.tradeNumLabel.text=tradeNum;
            cell.orderTimeLabel.text=createtime;
            cell.consigneeLabel.text=username;
            cell.mobileLabel.text=userphone;
            
            NSString *addressString=detailAddress;
            CGSize addressSize=[ViewController sizeWithString:addressString font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-cell.addressIV.right-WZ(15*2+10), WZ(40))];
            cell.addressLabel.text=addressString;
            cell.addressLabel.frame=CGRectMake(cell.addressIV.right+WZ(10), cell.consigneeLabel.bottom+WZ(10), addressSize.width, WZ(40));
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (self.isReceivedOrderVC==YES)
        {
            static NSString *cellIdentifier=@"DetailOrderTopCell";
            DetailOrderTopCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[DetailOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            NSString *orderNum=[NSString stringWithFormat:@"%@",[self.orderInfoDict objectForKey:@"orderNum"]];
            NSString *tradeNum0=[NSString stringWithFormat:@"%@",[self.orderInfoDict objectForKey:@"tradeId"]];
            NSString *tradeNum=@"";
            if ([tradeNum0 isEqualToString:@"(null)"])
            {
                tradeNum=@"流水编号：无";
            }
            else
            {
                tradeNum=[NSString stringWithFormat:@"流水编号：%@",tradeNum0];
            }
            NSString *createtime=[self.orderInfoDict objectForKey:@"createtime"];
            NSInteger status=[[self.orderInfoDict objectForKey:@"status"] integerValue];
            NSString *ztString;
            switch (status)
            {
                case 0:
                    ztString=@"未处理";//删除
                    break;
                case 1:
                    ztString=@"未处理";//删除 确认订单
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
            
            NSString *username=[self.buyerInfoDict objectForKey:@"username"];
            NSString *userphone=[NSString stringWithFormat:@"%@",[self.buyerInfoDict objectForKey:@"userphone"]];
            NSString *address=[self.buyerInfoDict objectForKey:@"address"];
            NSString *city=[self.buyerInfoDict objectForKey:@"city"];
            NSString *detailAddress=[NSString stringWithFormat:@"%@%@",city,address];
            
            cell.statusLabel.text=ztString;
            cell.orderNumLabel.text=orderNum;
            cell.tradeNumLabel.text=tradeNum;
            cell.orderTimeLabel.text=createtime;
            cell.consigneeLabel.text=username;
            cell.mobileLabel.text=userphone;
            
            NSString *addressString=detailAddress;
            CGSize addressSize=[ViewController sizeWithString:addressString font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-cell.addressIV.right-WZ(15*2+10), WZ(40))];
            cell.addressLabel.text=addressString;
            cell.addressLabel.frame=CGRectMake(cell.addressIV.right+WZ(10), cell.consigneeLabel.bottom+WZ(10), addressSize.width, WZ(40));
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
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
        
        NSDictionary *goodsDict=self.goodsArray[indexPath.row];
        NSString *goodsName=[goodsDict objectForKey:@"itemName"];
        NSString *goodsImg=[goodsDict objectForKey:@"itemImg"];
        NSString *goodsPrice=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"itemPrice"]];
        NSString *goodsCount=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"count"]];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(50), WZ(50))];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentouxiang")];
        iconIV.layer.cornerRadius=3;
        iconIV.clipsToBounds=YES;
        [cell.contentView addSubview:iconIV];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10)-iconIV.width, WZ(25))];
        nameLabel.text=goodsName;
        nameLabel.font=FONT(17,15);
        [cell.contentView addSubview:nameLabel];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(5), nameLabel.width, WZ(20))];
        priceLabel.text=[NSString stringWithFormat:@"￥ %@ x %@",goodsPrice,goodsCount];
        priceLabel.font=FONT(15,13);
        priceLabel.textColor=COLOR_LIGHTGRAY;
        [cell.contentView addSubview:priceLabel];
        
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        NSInteger userCoupon=[self.userCoupon integerValue];
        if (userCoupon>0)
        {
            NSString *money=[NSString stringWithFormat:@"￥ %@",[self.orderInfoDict objectForKey:@"money"]];
            NSString *sfMoney=[NSString stringWithFormat:@"￥ %@",[self.orderInfoDict objectForKey:@"sfMoney"]];
            NSString *coupon=[NSString stringWithFormat:@"-￥ %@",self.userCoupon];
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"订单金额：",@"优惠券：",@"实付金额：", nil];
            
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            NSArray *jiageArray=[[NSArray alloc]initWithObjects:money,coupon,sfMoney, nil];
            
            UILabel *jiageLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(200), 0, WZ(200), WZ(50))];
            jiageLabel.text=jiageArray[indexPath.row];
            jiageLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:jiageLabel];
            
            if (indexPath.row==2)
            {
                jiageLabel.textColor=COLOR_ORANGE;
            }
        }
        else
        {
            NSString *money=[NSString stringWithFormat:@"￥ %.2f",[[self.orderInfoDict objectForKey:@"money"] floatValue]];
            NSString *sfMoney=[NSString stringWithFormat:@"￥ %.2f",[[self.orderInfoDict objectForKey:@"sfMoney"] floatValue]];
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"订单金额：",@"实付金额：", nil];
            
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            NSArray *jiageArray=[[NSArray alloc]initWithObjects:money,sfMoney, nil];
            
            UILabel *jiageLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(200), 0, WZ(200), WZ(50))];
            jiageLabel.text=jiageArray[indexPath.row];
            jiageLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:jiageLabel];
            
            if (indexPath.row==1)
            {
                jiageLabel.textColor=COLOR_ORANGE;
            }
        }
        
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    if (section==1)
    {
        NSString *storeName=[self.orderInfoDict objectForKey:@"storeName"];
        
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), SCREEN_WIDTH, WZ(30))];
        bgView.backgroundColor=COLOR_WHITE;
        [titleView addSubview:bgView];
        
        UILabel *storeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(30))];
        storeNameLabel.text=storeName;
        storeNameLabel.font=FONT(15,13);
        [bgView addSubview:storeNameLabel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, bgView.bottom, SCREEN_WIDTH, 1)];
        lineView.backgroundColor=COLOR_HEADVIEW;
        [titleView addSubview:lineView];
        
        return titleView;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(210);
    }
    if (indexPath.section==1)
    {
        return WZ(80);
    }
    else
    {
        return WZ(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    if (section==1)
    {
        return WZ(40);
    }
    else
    {
        return WZ(10);
    }
    
}





#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//底部左边按钮
-(void)leftBtnClick
{
    NSLog(@"");
    if (self.isMyOrderVC==YES || self.isPaySuccessVC==YES || self.isOrderDetailVC==YES)
    {
        if (self.orderStatus==0)
        {
            //删除订单
            NSString *orderId=[self.orderInfoDict objectForKey:@"id"];
            [HTTPManager deleteOrderWithOrderId:orderId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"删除订单成功" duration:1.0];
                }
                else
                {
                    NSString *msg=[resultDict objectForKey:@"msg"];
                    [self.view makeToast:msg duration:1.0];
                }
            }];
        }
        if (self.orderStatus==3)
        {
            //退货
            ApplyRefundViewController *vc=[[ApplyRefundViewController alloc]init];
            vc.orderDict=self.orderInfoDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (self.isReceivedOrderVC==YES)
    {
        if (self.orderStatus==0 || self.orderStatus==6)
        {
            //删除订单
            NSString *orderId=[self.orderInfoDict objectForKey:@"id"];
            [HTTPManager deleteOrderWithOrderId:orderId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"删除订单成功" duration:1.0];
                }
                else
                {
                    NSString *msg=[resultDict objectForKey:@"msg"];
                    [self.view makeToast:msg duration:1.0];
                }
            }];
        }
    }
}

//底部右边按钮
-(void)rightBtnClick
{
    NSLog(@"");
    
    if (self.isMyOrderVC==YES || self.isPaySuccessVC==YES || self.isOrderDetailVC==YES)
    {
        if (self.orderStatus==0)
        {
            //立即支付
            [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@""];
            
        }
        if (self.orderStatus==2)
        {
            //确认收货
            NSString *orderId=[self.orderInfoDict objectForKey:@"id"];
            [HTTPManager confirmReceivingWithPayInfoId:orderId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"已确认收货" duration:1.0];
                }
                else
                {
                    [self.view makeToast:@"确认收货失败，请重试。" duration:1.0];
                }
            }];
            
        }
        if (self.orderStatus==3 || self.orderStatus==6)
        {
            //去评价
            OrderCommentViewController *vc=[[OrderCommentViewController alloc]init];
            vc.orderDict=self.orderInfoDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (self.isReceivedOrderVC==YES)
    {
        if (self.orderStatus==1)
        {
            NSString *orderId=[self.orderInfoDict objectForKey:@"id"];
            [HTTPManager confirmSendOutWithPayInfoId:orderId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view makeToast:@"已确认订单" duration:1.0];
                }
                else
                {
                    [self.view makeToast:@"确认订单失败，请重试。" duration:1.0];
                }
            }];
        }
        if (self.orderStatus==4)
        {
            //确认退款
            
            
            
        }
    }
    
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
        
        if (self.orderId==nil)
        {
            self.orderId=@"";
        }
        
        //确认支付
        [HTTPManager payOrderWithPayInfoId:self.orderId ymlPayPass:self.passwordTF.text complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                PaySuccessViewController *vc=[[PaySuccessViewController alloc]init];
                vc.orderDict=resultDict;
                vc.isOrderDetailVC=self.isOrderDetailVC;
                vc.isMyOrderVC=self.isMyOrderVC;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:1.0];
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

@implementation OrderDetailLeftBtn

@synthesize orderDict;

@end

@implementation OrderDetailRightBtn

@synthesize orderDict;

@end
