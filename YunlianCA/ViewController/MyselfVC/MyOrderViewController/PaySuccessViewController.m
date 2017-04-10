//
//  PaySuccessViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/3.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "PaySuccessViewController.h"

#import "MyOrderDetailViewController.h"
#import "DetailOrderViewController.h"
#import "StoreDetailViewController.h"
#import "Type03ViewController.h"
#import "MyOrderViewController.h"
#import "GoodsDetailViewController.h"

@interface PaySuccessViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}



@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"支付成功";
    
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
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    NSDictionary *orderInfoDict=[self.orderDict objectForKey:@"payInfo"];
    NSString *orderNumber=[NSString stringWithFormat:@"%@",[orderInfoDict objectForKey:@"orderNum"]];
    NSString *sfMoney=[NSString stringWithFormat:@"%@",[orderInfoDict objectForKey:@"sfMoney"]];
    //        NSString *money=[NSString stringWithFormat:@"%@",[orderInfoDict objectForKey:@"money"]];
    
    UIImageView *okIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(50))/2.0, WZ(35), WZ(50), WZ(50))];
    okIV.image=IMAGE(@"wode_bangdingchenggong");
    [cell.contentView addSubview:okIV];
    
    UILabel *okLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okIV.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    okLabel.text=@"支付成功";
    okLabel.textAlignment=NSTextAlignmentCenter;
    //        okLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:okLabel];
    
    CGSize ddbhSize=[ViewController sizeWithString:@"订单编号：" font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(20))];
    CGSize orderNumSize=[ViewController sizeWithString:orderNumber font:FONT(13,11) maxSize:CGSizeMake(WZ(150), WZ(20))];
    
    UILabel *ddbhLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15)+(SCREEN_WIDTH-WZ(15*2)-ddbhSize.width-orderNumSize.width)/2, okLabel.bottom+WZ(30), ddbhSize.width, WZ(20))];
    ddbhLabel.text=@"订单编号：";
    ddbhLabel.textColor=COLOR_LIGHTGRAY;
    ddbhLabel.font=FONT(13,11);
    //    ddbhLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:ddbhLabel];
    
    UILabel *orderNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(ddbhLabel.right, ddbhLabel.top, orderNumSize.width, WZ(20))];
    orderNumLabel.text=orderNumber;
    orderNumLabel.textColor=COLOR_LIGHTGRAY;
    orderNumLabel.font=FONT(13,11);
    //    orderNumLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:orderNumLabel];
    
    CGSize paySize=[ViewController sizeWithString:@"实付金额：" font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(20))];
    CGSize moneySize=[ViewController sizeWithString:[NSString stringWithFormat:@"%.2f元",[sfMoney floatValue]] font:FONT(13,11) maxSize:CGSizeMake(WZ(150), WZ(20))];
    
    UILabel *payLabel=[[UILabel alloc]initWithFrame:CGRectMake(ddbhLabel.left, ddbhLabel.bottom+WZ(10), paySize.width, WZ(20))];
    payLabel.text=@"实付金额：";
    payLabel.textColor=COLOR_LIGHTGRAY;
    payLabel.font=FONT(13,11);
    //    payLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:payLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(payLabel.right, payLabel.top, moneySize.width, WZ(20))];
    moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[sfMoney floatValue]];
    moneyLabel.textColor=COLOR_ORANGE;
    moneyLabel.font=FONT(13,11);
    //    moneyLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:moneyLabel];
    
    
    CGSize btnSize=[ViewController sizeWithString:@"查看订单" font:FONT(13,11) maxSize:CGSizeMake(WZ(150), WZ(25))];
    CGFloat btnWidth=btnSize.width+WZ(20);
    CGFloat btnHeight=WZ(25);
    CGFloat leftMargin=(SCREEN_WIDTH-btnWidth*2)/3.0;
    CGFloat space=leftMargin;
    
    UIButton *orderBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin, payLabel.bottom+WZ(30), btnWidth, btnHeight)];
    [orderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    [orderBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    orderBtn.titleLabel.font=FONT(13,11);
    orderBtn.clipsToBounds=YES;
    orderBtn.layer.cornerRadius=3;
    orderBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    orderBtn.layer.borderWidth=1;
    [orderBtn addTarget:self action:@selector(orderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:orderBtn];
    
    UIButton *buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+btnWidth+space, orderBtn.top, btnWidth, btnHeight)];
    [buyBtn setTitle:@"继续购物" forState:UIControlStateNormal];
    [buyBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    buyBtn.titleLabel.font=FONT(13,11);
    buyBtn.clipsToBounds=YES;
    buyBtn.layer.cornerRadius=3;
    buyBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    buyBtn.layer.borderWidth=1;
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:buyBtn];
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT;
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    if (self.isMyOrderVC==YES)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[MyOrderViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    if (self.isOrderDetailVC==YES)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[MyOrderDetailViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    if (self.isStoreDetailVC==YES)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[StoreDetailViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    if (self.isGoodsDetailVC==YES)
    {
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[GoodsDetailViewController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

//查看订单
-(void)orderBtnClick
{
    NSDictionary *orderDict=[self.orderDict objectForKey:@"payInfo"];
    
    DetailOrderViewController *vc=[[DetailOrderViewController alloc]init];
    vc.orderDict=orderDict;
    vc.isPaySuccessVC=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//继续购物
-(void)buyBtnClick
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[Type03ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
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
