//
//  ScanPaySuccessViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/11/1.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ScanPaySuccessViewController.h"

#import "SquareViewController.h"

@interface ScanPaySuccessViewController ()
{
    UIScrollView *_scrollView;
    
}


@end

@implementation ScanPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavigationBar];
    [self createSubviews];
    
    
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
    self.title=@"支付成功";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createSubviews
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_scrollView];
    
    UIImageView *okIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(50))/2.0, WZ(35), WZ(50), WZ(50))];
    okIV.image=IMAGE(@"wode_bangdingchenggong");
    [_scrollView addSubview:okIV];
    
    UILabel *okLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okIV.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    okLabel.text=@"支付成功";
    okLabel.textAlignment=NSTextAlignmentCenter;
    [_scrollView addSubview:okLabel];
    
    NSMutableAttributedString *money=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"支付金额：￥%@",self.money]];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okLabel.bottom+WZ(50), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    moneyLabel.font=FONT(15, 13);
    moneyLabel.textAlignment=NSTextAlignmentCenter;
//    moneyLabel.backgroundColor=COLOR_LIGHTGRAY;
    [money addAttributes:@{NSFontAttributeName:FONT(15, 13),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(5, money.length-5)];
    moneyLabel.attributedText=money;
    [_scrollView addSubview:moneyLabel];
    
    NSMutableAttributedString *sfMoney=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付金额：￥%@",self.sfMoney]];
    
    UILabel *sfMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), moneyLabel.bottom+WZ(5), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    sfMoneyLabel.font=FONT(15, 13);
    sfMoneyLabel.textAlignment=NSTextAlignmentCenter;
    //    moneyLabel.backgroundColor=COLOR_LIGHTGRAY;
    [sfMoney addAttributes:@{NSFontAttributeName:FONT(15, 13),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(5, sfMoney.length-5)];
    sfMoneyLabel.attributedText=sfMoney;
    [_scrollView addSubview:sfMoneyLabel];
    
    NSMutableAttributedString *store=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"收款商户：%@",self.merchantName]];
    
    UILabel *storeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), sfMoneyLabel.bottom+WZ(5), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    storeLabel.font=FONT(15, 13);
    storeLabel.textAlignment=NSTextAlignmentCenter;
    //    storeLabel.backgroundColor=COLOR_LIGHTGRAY;
    [store addAttributes:@{NSFontAttributeName:FONT(15, 13),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(5, store.length-5)];
    storeLabel.attributedText=store;
    [_scrollView addSubview:storeLabel];
    
}





#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[SquareViewController class]])
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
