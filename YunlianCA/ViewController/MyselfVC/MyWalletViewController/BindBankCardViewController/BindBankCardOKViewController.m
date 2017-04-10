//
//  BindBankCardOKViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "BindBankCardOKViewController.h"

#import "TiXianViewController.h"
#import "BindBankCardViewController.h"



@interface BindBankCardOKViewController ()
{
    UIScrollView *_bgScrollView;
    
    
}

@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *cardNumber;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *zhihang;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *idCard;
@property(nonatomic,strong)NSString *khUserName;
@property(nonatomic,strong)NSString *phone;
//@property(nonatomic,assign)CGFloat userMoney;

@end

@implementation BindBankCardOKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.bankName=[self.bankDict objectForKey:@"bankName"];
    self.cardNumber=[NSString stringWithFormat:@"%@",[self.bankDict objectForKey:@"cardNumber"]];
    self.city=[self.bankDict objectForKey:@"bankCity"];
    self.zhihang=[self.bankDict objectForKey:@"subBranch"];
    self.createTime=[self.bankDict objectForKey:@"createTime"];
    self.idCard=[NSString stringWithFormat:@"%@",[self.bankDict objectForKey:@"idCard"]];
    self.khUserName=[self.bankDict objectForKey:@"khUserName"];
    self.phone=[NSString stringWithFormat:@"%@",[self.bankDict objectForKey:@"phone"]];
    
    
    [self createNavigationBar];
    [self createSubviews];
    
    
    
}

-(void)createNavigationBar
{
    self.title=@"绑定银行卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [leftBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createSubviews
{
    _bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    _bgScrollView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_bgScrollView];
    
    UIImageView *okIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(50))/2.0, WZ(35), WZ(50), WZ(50))];
    okIV.image=IMAGE(@"wode_bangdingchenggong");
    [_bgScrollView addSubview:okIV];
    
    UILabel *okLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okIV.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    okLabel.text=@"绑定成功";
    okLabel.textAlignment=NSTextAlignmentCenter;
//    okLabel.backgroundColor=COLOR_CYAN;
    [_bgScrollView addSubview:okLabel];
    
    UILabel *bankNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okLabel.bottom+WZ(40), SCREEN_WIDTH-WZ(15*2), WZ(20))];
    bankNameLabel.text=[NSString stringWithFormat:@"银行名称：%@",self.bankName];
    bankNameLabel.textColor=COLOR_LIGHTGRAY;
    bankNameLabel.font=FONT(13,11);
    bankNameLabel.textAlignment=NSTextAlignmentCenter;
//    bankNameLabel.backgroundColor=COLOR_CYAN;
    [_bgScrollView addSubview:bankNameLabel];
    
    UILabel *cardNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), bankNameLabel.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), WZ(20))];
    cardNumberLabel.text=[NSString stringWithFormat:@"银行卡号：%@",self.cardNumber];
    cardNumberLabel.textColor=COLOR_LIGHTGRAY;
    cardNumberLabel.font=FONT(13,11);
    cardNumberLabel.textAlignment=NSTextAlignmentCenter;
//    timeLabel.backgroundColor=COLOR_CYAN;
    [_bgScrollView addSubview:cardNumberLabel];
    
    CGFloat leftMargin=WZ(100);
    CGFloat space=WZ(45);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2-WZ(45))/2.0;
    CGFloat btnHeight=WZ(25);
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(100), cardNumberLabel.bottom+WZ(40), btnWidth, btnHeight)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    backBtn.titleLabel.font=FONT(15,13);
    backBtn.clipsToBounds=YES;
    backBtn.layer.cornerRadius=3;
    backBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    backBtn.layer.borderWidth=1;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:backBtn];
    
    UIButton *tixianBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(100)+btnWidth+space, backBtn.top, btnWidth, btnHeight)];
    [tixianBtn setTitle:@"提现" forState:UIControlStateNormal];
    [tixianBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    tixianBtn.titleLabel.font=FONT(15,13);
    tixianBtn.clipsToBounds=YES;
    tixianBtn.layer.cornerRadius=3;
    tixianBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    tixianBtn.layer.borderWidth=1;
    [tixianBtn addTarget:self action:@selector(tixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:tixianBtn];
    
}









#pragma mark ===buttonClick===
//左返回按钮
-(void)leftBtnClick
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[BindBankCardViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

//返回
-(void)backBtnClick
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[BindBankCardViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

//提现
-(void)tixianBtnClick
{
    //提现之前先获取佣金 看余额是否超过100元
    [HTTPManager myBrokerageWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            CGFloat ktxBrokerage=[[resultDict objectForKey:@"ktxBrokerage"] floatValue];
            if (ktxBrokerage>=100)
            {
                TiXianViewController *vc=[[TiXianViewController alloc]init];
                vc.ktxBrokerage=[NSString stringWithFormat:@"%.2f",ktxBrokerage];
                vc.bankDict=self.bankDict;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                [self.view makeToast:@"可提现佣金不足100元，无法提现。" duration:1.0];
            }
        }
        else
        {
            [self.view makeToast:@"佣金获取失败，请重试。" duration:1.0];
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
