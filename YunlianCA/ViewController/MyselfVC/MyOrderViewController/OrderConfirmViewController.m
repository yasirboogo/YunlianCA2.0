//
//  OrderConfirmViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/25.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "OrderConfirmViewController.h"

#import "PaySuccessViewController.h"
#import "OrderCouponViewController.h"
#import "RechargeViewController.h"

@interface OrderConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_bottomView;
    
    
}

@property(nonatomic,strong)UILabel *totalPriceLabel;
@property(nonatomic,strong)NSString *totalPrice;
@property(nonatomic,strong)NSArray *goodsArray;
@property(nonatomic,strong)NSString *receiptAddress;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userPhone;
@property(nonatomic,strong)UILabel *couponLabel;
@property(nonatomic,strong)NSString *couponMoney;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)UIButton *buyBtn;
@property(nonatomic,strong)UITextField *passwordTF;
@property(nonatomic,strong)UILabel *zhekouLabel;
@property(nonatomic,strong)NSString *discount0;
@property(nonatomic,strong)NSString *discount;
@property(nonatomic,strong)NSString *sfmoney;//sfmoney只用来展示 不同于订单里面的sfMoney 后台做了折扣 这里只需展示

@property(nonatomic,strong)NSString *orderId;

@end

@implementation OrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.orderId=@"";
    self.discount=@"";
    self.discount0=@"";
    
    //@"¥ 0.00"
    self.totalPrice=[NSString stringWithFormat:@"%@",[self.orderDict objectForKey:@"money"]];
    self.sfmoney=self.totalPrice;
    self.goodsArray=[self.orderDict objectForKey:@"list"];
    self.couponMoney=@"- 0.00";
    
    [self createNavigationBar];
    [self createBottomView];
    [self createTableView];
    [self getReceiptAddress];
    [self getZhekouInfo];

        
    NSLog(@"商品数组===%@",self.goodsInfoArray);
    NSLog(@"订单字典===%@",self.orderDict);
    
    
}



//获取用户默认地址
-(void)getReceiptAddress
{
    [HTTPManager getUserDefaultShippingAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *addressDict=[resultDict objectForKey:@"receiptInfo"];
            NSString *city=[addressDict objectForKey:@"city"];
            NSString *address=[addressDict objectForKey:@"address"];
            NSString *addressId=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"id"]];
            [self.orderDict setValue:addressId forKey:@"receiptId"];
            self.userName=[addressDict objectForKey:@"username"];
            self.userPhone=[addressDict objectForKey:@"userphone"];
            self.receiptAddress=[NSString stringWithFormat:@"%@%@",city,address];
            
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:@"您还没有设置收货地址，请设置后购买" duration:2.0];
        }
    }];
}

//获取商家折扣
-(void)getZhekouInfo
{
    if (self.merchantId!=nil && ![self.merchantId isEqualToString:@""])
    {
        [HTTPManager getMerStoreDiscountWithMerId:self.merchantId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                self.discount0=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"saleRate"]];
                if ([self.discount0 isEqualToString:@"1"] || [self.discount0 isEqualToString:@"1.0"] || [self.discount0 isEqualToString:@"1.00"])
                {
                    self.discount=@"无折扣";
                }
                else
                {
                    CGFloat discount1=[self.discount0 floatValue]*10;
                    self.discount=[NSString stringWithFormat:@"%.1f折",discount1];
                }
                
                self.zhekouLabel.text=self.discount;
                self.sfmoney=[NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]*[self.discount0 floatValue]];
//                self.sfmoney=[NSString stringWithFormat:@"¥ %.2f",[self.totalPrice floatValue]*0.5];
                self.totalPriceLabel.text=self.sfmoney;
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:2.0];
                self.discount=@"";
                self.zhekouLabel.text=self.discount;
            }
        }];
    }
    else
    {
        self.discount=@"";
        self.zhekouLabel.text=self.discount;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
}

-(void)createNavigationBar
{
    self.title=@"订单确认";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createBottomView
{
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(50), SCREEN_WIDTH, WZ(50))];
    _bottomView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_bottomView];
    
    CGSize hjSize=[ViewController sizeWithString:@"实付金额：" font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(30))];
    UILabel *hjLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), hjSize.width, WZ(30))];
    hjLabel.text=@"实付金额：";
    hjLabel.font=FONT(15,13);
    [_bottomView addSubview:hjLabel];
    
    UILabel *totalPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(hjLabel.right, hjLabel.top, WZ(200), WZ(30))];
    totalPriceLabel.text=self.sfmoney;
    totalPriceLabel.font=FONT(15,13);
    [_bottomView addSubview:totalPriceLabel];
    self.totalPriceLabel=totalPriceLabel;
    
    CGSize buySize=[ViewController sizeWithString:@"立即购买" font:FONT(17,15) maxSize:CGSizeMake(WZ(200), WZ(30))];
    UIButton *buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-buySize.width-WZ(30), 0, buySize.width+WZ(30), _bottomView.height)];
    buyBtn.titleLabel.font=FONT(17, 15);
    buyBtn.backgroundColor=COLOR(254, 153, 160, 1);
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:buyBtn];
    self.buyBtn=buyBtn;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-_bottomView.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
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
    if (section==2)
    {
        return 2;
    }
    else
    {
        return self.goodsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        UIImageView *bgIV=[[UIImageView alloc]init];
        bgIV.image=IMAGE(@"wode_shouhuodizhi");
        [cell.contentView addSubview:bgIV];
        
        NSString *shrString=@"收货人：";
        CGSize shrSize=[ViewController sizeWithString:shrString font:FONT(17,15) maxSize:CGSizeMake(WZ(120), WZ(25))];
        UILabel *shrLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), shrSize.width, WZ(25))];
        shrLabel.text=shrString;
        shrLabel.font=FONT(17,15);
        [cell.contentView addSubview:shrLabel];
        
        UILabel *consigneeLabel=[[UILabel alloc]initWithFrame:CGRectMake(shrLabel.right, shrLabel.top, WZ(150), WZ(25))];
        consigneeLabel.text=self.userName;
        consigneeLabel.font=FONT(17,15);
        [cell.contentView addSubview:consigneeLabel];
//        self.consigneeLabel=consigneeLabel;
        
        UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(150), shrLabel.top, WZ(150), WZ(25))];
        mobileLabel.text=self.userPhone;
        mobileLabel.font=FONT(17,15);
        mobileLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:mobileLabel];
//        self.mobileLabel=mobileLabel;
        
        UIImageView *addressIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), shrLabel.bottom+WZ(10), WZ(17), WZ(20))];
        addressIV.image=IMAGE(@"dingwei");
        [cell.contentView addSubview:addressIV];
//        self.addressIV=addressIV;
        
        CGSize addressSize=[ViewController sizeWithString:self.receiptAddress font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2+10)-addressIV.width, WZ(25))];
        UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(addressIV.right+WZ(10), shrLabel.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2+10+20), addressSize.height)];
        addressLabel.text=self.receiptAddress;
        addressLabel.font=FONT(13,11);
        addressLabel.numberOfLines=0;
        [cell.contentView addSubview:addressLabel];
//        self.addressLabel=addressLabel;
        
        bgIV.frame=CGRectMake(0, 0, SCREEN_WIDTH, addressLabel.bottom+WZ(15));
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
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
        
        NSDictionary *goodsDict=self.goodsInfoArray[indexPath.row];
        NSString *priceZH=[goodsDict objectForKey:@"amount"];
        NSString *goodsImg=[goodsDict objectForKey:@"img"];
        NSString *goodsName=[goodsDict objectForKey:@"name"];
        NSString *goodsCount=[goodsDict objectForKey:@"count"];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(50), WZ(50))];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentupian")];
        iconIV.layer.cornerRadius=3;
        iconIV.clipsToBounds=YES;
        [cell.contentView addSubview:iconIV];
//        self.iconIV=iconIV;
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10)-iconIV.width, WZ(25))];
        nameLabel.text=goodsName;
        nameLabel.font=FONT(17,15);
        [cell.contentView addSubview:nameLabel];
//        self.nameLabel=nameLabel;
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(5), nameLabel.width, WZ(20))];
        priceLabel.text=[NSString stringWithFormat:@"￥ %@ x %@",priceZH,goodsCount];
        priceLabel.font=FONT(15,13);
        priceLabel.textColor=COLOR_LIGHTGRAY;
        [cell.contentView addSubview:priceLabel];
//        self.priceLabel=priceLabel;
        
        
        
//        cell.backgroundColor=COLOR(250, 250, 250, 1);
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
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row==0)
        {
            CGSize titleSize=[ViewController sizeWithString:@"优惠券(最多使用一张)" font:FONT(17,15) maxSize:CGSizeMake(SCREEN_WIDTH/2.0, WZ(50))];
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, titleSize.width, WZ(50))];
            titleLabel.text=@"优惠券(最多使用一张)";
            titleLabel.textColor=COLOR_LIGHTGRAY;
            titleLabel.font=FONT(17,15);
            [cell.contentView addSubview:titleLabel];
            
            CGSize couponSize=[ViewController sizeWithString:self.couponMoney font:FONT(17,15) maxSize:CGSizeMake(WZ(120), WZ(50))];
            UILabel *couponLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10*2)-couponSize.width, 0, couponSize.width, WZ(50))];
            couponLabel.adjustsFontSizeToFitWidth = YES;
            couponLabel.text=self.couponMoney;
            couponLabel.textColor=COLOR_ORANGE;
            couponLabel.textAlignment=NSTextAlignmentRight;
            couponLabel.font=FONT(17,15);
            [cell.contentView addSubview:couponLabel];
            self.couponLabel=couponLabel;
        }
        if (indexPath.row==1)
        {
            cell.textLabel.text=@"商家折扣";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            cell.textLabel.font=FONT(17, 15);
            
            UILabel *zhekouLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(100), 0, WZ(100), WZ(50))];
            zhekouLabel.text=self.discount;
            zhekouLabel.textAlignment=NSTextAlignmentRight;
            zhekouLabel.font=FONT(17,15);
            [cell.contentView addSubview:zhekouLabel];
            self.zhekouLabel=zhekouLabel;
            
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        //跳转到修改收货地址界面
        
        
    }
    if (indexPath.section==2)
    {
        //跳转到优惠券界面
        OrderCouponViewController *vc=[[OrderCouponViewController alloc]init];
        vc.orderDict=self.orderDict;
        __weak OrderConfirmViewController * weakSelf = self;
        vc.block = ^(NSDictionary * couponDic){
            [weakSelf chooseCouponInfo:couponDic];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//选择的优惠券
-(void)chooseCouponInfo:(NSDictionary*)couponDict
{
    NSLog(@"couponDict==%@",couponDict);
    //NSDictionary *couponDict=[notification userInfo];
    NSString *money=[NSString stringWithFormat:@"%.2f",[[couponDict objectForKey:@"money"] floatValue]];
    NSString *couponId=[NSString stringWithFormat:@"%@",[couponDict objectForKey:@"id"]];
    self.couponMoney=[NSString stringWithFormat:@"- %@",money];
    self.couponLabel.text=self.couponMoney;
    
    CGFloat totalMoney=[[self.orderDict objectForKey:@"sfMoney"] floatValue]-[[couponDict objectForKey:@"money"] floatValue];
    self.sfmoney=[NSString stringWithFormat:@"%.2f",totalMoney*[self.discount0 floatValue]];
    
    
    //NSString *totalMoneyString=[NSString stringWithFormat:@"%.2f",totalMoney];
    //[self.orderDict setValue:totalMoneyString forKey:@"sfMoney"];
    [self.orderDict setObject:couponId forKey:@"couponId"];
    
    self.totalPriceLabel.text=self.sfmoney;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1 || section==2)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        CGSize addressSize=[ViewController sizeWithString:self.receiptAddress font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2+10+20), WZ(25))];
        
        return WZ(15+25+10)+addressSize.height+WZ(15);
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

//购买
-(void)buyBtnClick
{
    if ([self.buyBtn.titleLabel.text isEqualToString:@"立即购买"])
    {
        [self.orderDict setValue:self.sfmoney forKey:@"sfMoney"];
        NSString *orderJsonString=[self.orderDict JSONString];
        
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"创建订单..." detail:nil];
        [hud show:YES];
        [hud hide:YES afterDelay:20];
        //发送订单
        [HTTPManager addOrderWithOrderData:orderJsonString complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                NSDictionary *orderInfoDict=[resultDict objectForKey:@"orderInfo"];
                self.orderId=[NSString stringWithFormat:@"%@",[orderInfoDict objectForKey:@"id"]];
                [self.buyBtn setTitle:@"立即支付" forState:UIControlStateNormal];
                //创建订单成功之后弹出支付密码框
                [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@"您已成功创建订单，请输入支付密码完成支付。"];
            }
            else
            {
                NSString *error=[resultDict objectForKey:@"error"];
                [self.view makeToast:error duration:1.0];
            }
            [hud hide:YES];
        }];
    }
    if ([self.buyBtn.titleLabel.text isEqualToString:@"立即支付"])
    {
        //如果立即购买变成了立即支付 弹出支付密码框
        [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@"您已成功创建订单，请输入支付密码完成支付。"];
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
        
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在支付..." detail:nil];
        [hud show:YES];
        [hud hide:YES afterDelay:20];
        //确认支付
        [HTTPManager payOrderWithPayInfoId:self.orderId ymlPayPass:self.passwordTF.text complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                PaySuccessViewController *vc=[[PaySuccessViewController alloc]init];
                vc.orderDict=resultDict;
                vc.isStoreDetailVC=self.isStoreDetailVC;
                vc.isGoodsDetailVC=self.isGoodsDetailVC;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:2.0];
                
                //如果余额不足 跳转充值界面
                if ([msg containsString:@"余额不足"])
                {
                    RechargeViewController *vc=[[RechargeViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
            [hud hide:YES];
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
