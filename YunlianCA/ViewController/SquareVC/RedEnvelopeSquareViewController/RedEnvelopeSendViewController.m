//
//  RedEnvelopeSendViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/12/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RedEnvelopeSendViewController.h"
#import <SVProgressHUD.h>
#import <AlipaySDK/AlipaySDK.h>


@interface RedEnvelopeSendViewController ()<UITextFieldDelegate,YYTextViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableDictionary * _reqDic;
    NSInteger _totalPages;
}
@property(nonatomic,strong)UILabel *placeholderLabel0;
@property(nonatomic,strong)UILabel *placeholderLabel1;
@property(nonatomic,strong)UILabel *subMobileLabel;
@property(nonatomic,strong)UILabel *leftSubLabel;
@property(nonatomic,strong)UILabel *rightSubLabel;
@property(nonatomic,strong)YYTextView *mobileTV;
//@property(nonatomic,strong)UITextField *moneyTF;
@property(nonatomic,strong)YYTextView *moneyTV;
@property(nonatomic,strong)UITextField *detailTF;
@property(nonatomic,strong)UITextField *payPswTF;
@property(nonatomic,strong)UIButton *typeBtn0;
@property(nonatomic,strong)UIButton *typeBtn1;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *detail;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *payType;
@property(nonatomic,strong)NSMutableArray *recordsArray;
//@property(nonatomic,strong)UIView *bgView;
//@property(nonatomic,strong)UIView *smallView;
//@property(nonatomic,strong)UITextField *passwordTF;

@property(nonatomic,strong)NSString *firstMoney;
@property(nonatomic,assign)CGFloat merDiscount;
@property(nonatomic,assign)CGFloat rakeRate;
@property(nonatomic,assign)CGFloat hasUser;

@end

@implementation RedEnvelopeSendViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
    
    self.view.backgroundColor=COLOR_HEADVIEW;
    
    
    self.mobile=self.scanMobile;
    self.money=@"0";
    self.detail=[self.placeHolder stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self.detail length]<=0) {
        self.detail=@"恭喜发财，大吉大利！";
    }
    
    
    self.firstMoney=@"0";
    self.merDiscount=0;
    self.rakeRate=0;
    self.hasUser=0;//0：已注册 1：未注册
    self.password=@"";
    self.payType=@"0";//0：余额支付 1：支付宝支付 2：快钱支付 付款方式默认为余额支付,快钱忽略
    
    [self createTopView];
    
    [self initTableView];
    [self initSubviews];
    if (self.isMouth) {
        _recordsArray = [NSMutableArray array];
        _reqDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.objId,@"objId",self.type,@"type",@"1",@"pageNum",@"10",@"pageSize",nil];
        [self refreshData];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResultNotification:) name:@"PayResult" object:nil];
    
}
-(void)payResultNotification:(NSNotification *)notification{
    NSLog(@"notification==%@",notification.userInfo);
    NSDictionary * resoultDic = notification.userInfo;
    NSString * resoultStr = resoultDic[@"resoult"];
    if ([resoultStr isEqualToString:@"ali_success"]) {
        [self.view makeToast:@"红包已发出" duration:2];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(paySuccess) userInfo:nil repeats:NO];
       
    }else{
        [self.view makeToast:@"支付失败" duration:2];
    }
}
-(void)paySuccess{
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)initTableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-64)];
        _tableView.delegate=self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        _tableView.backgroundColor = COLOR_HEADVIEW;
        if (self.isMouth) {
            [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
            [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
        }
       

    }
}
-(void)refreshData{
    [_reqDic setObject:@"1" forKey:@"pageNum"];
    [self getInfo];
}
-(void)getMoreData{
    NSInteger pageNum =[_reqDic[@"pageNum"] integerValue];
    pageNum++;
    if (pageNum<=_totalPages) {
        [_reqDic setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"pageNum"];
        
        [self getInfo];
        
    }else{
        [self.view makeToast:@"没有更多数据" duration:1.0];
        [_tableView footerEndRefreshing];
    }
}
-(void)getParameter
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"" detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    [HTTPManager getParameterOfRedEnvelopeWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
//        NSString *result=[resultDict objectForKey:@"result"];
//        if ([result isEqualToString:STATUS_SUCCESS])
//        {
//            
//        }
        
        self.firstMoney=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"first"]];
        
        NSString *merDiscount1=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"merDiscount"]];
        NSString *merDiscount2=[NSString stringWithFormat:@"%.2f",[merDiscount1 floatValue]];
        self.merDiscount=[merDiscount2 floatValue];
        
        NSString *rakeRate1=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"rakeRate"]];
        NSString *rakeRate2=[NSString stringWithFormat:@"%.2f",[rakeRate1 floatValue]];
        self.rakeRate=[rakeRate2 floatValue];
        
        NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Ta若未注册，您发红包已为Ta注册，红包还加￥%@元，有短信通知Ta哦！",self.firstMoney]];
        [string addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(23, string.length-34)];
        self.subMobileLabel.attributedText=string;
        
        
        [hud hide:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    //去掉导航条下边的shadowImage，就可以正常显示了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    
    [self getParameter];
}

-(void)createTopView
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
//    topView.backgroundColor=COLOR_CYAN;
    [self.view addSubview:topView];
    
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topView.width, topView.height)];
    bgIV.image=IMAGE(@"hongbao_send_topimage");
    [topView addSubview:bgIV];
    
    UIImageView *backIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), 20+WZ(10), WZ(14), WZ(25))];
    backIV.image=IMAGE(@"fanhui_bai");
    [topView addSubview:backIV];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(5), backIV.top, WZ(60), backIV.height)];
    //    backBtn.backgroundColor=COLOR_CYAN;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(backBtn.right+WZ(5), backIV.top, SCREEN_WIDTH-WZ(70*2), backIV.height)];
    if (self.isMouth) {
        titleLabel.text=@"外快嘴";
    }else{
        titleLabel.text=@"发红包";
    }
    
    titleLabel.textColor=COLOR_WHITE;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(19, 17);
    [topView addSubview:titleLabel];
    
}

-(void)initSubviews
{
    UIView * backView = [[UIView alloc]init];
    UIView *mobileView=[[UIView alloc]initWithFrame:CGRectMake(WZ(20), WZ(25), SCREEN_WIDTH-WZ(20*2), WZ(45))];
    mobileView.backgroundColor=COLOR_WHITE;
    [backView addSubview:mobileView];
    
    UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(5), WZ(80), WZ(35))];
    mobileLabel.text=@"收红包人";
    mobileLabel.font=FONT(15, 13);
//    mobileLabel.backgroundColor=COLOR_CYAN;
    [mobileView addSubview:mobileLabel];
    
    YYTextView *mobileTV=[[YYTextView alloc]initWithFrame:CGRectMake(mobileLabel.right+WZ(10), mobileLabel.top+WZ(2.5), mobileView.width-WZ(15+15+10)-mobileLabel.width, mobileLabel.height-WZ(2.5*2))];
    mobileTV.delegate=self;
    mobileTV.font=FONT(15, 13);
    mobileTV.textAlignment=NSTextAlignmentRight;
    mobileTV.keyboardType=UIKeyboardTypeNumberPad;
    [mobileView addSubview:mobileTV];
    mobileTV.inputAccessoryView = [self creatDoneView];
    self.mobileTV=mobileTV;
    
    UILabel *placeholderLabel0=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, mobileTV.width-5, mobileTV.height)];
    placeholderLabel0.text=@"请输入收红包人的手机号";
    placeholderLabel0.textColor=COLOR(200, 200, 200, 1);
    placeholderLabel0.font=FONT(15, 13);
    placeholderLabel0.textAlignment=NSTextAlignmentRight;
    [mobileTV addSubview:placeholderLabel0];
    self.placeholderLabel0=placeholderLabel0;
    
//    UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(mobileLabel.right+WZ(10), mobileLabel.top, mobileView.width-WZ(15+15+10)-mobileLabel.width, mobileLabel.height)];
//    mobileTF.delegate=self;
//    mobileTF.placeholder=@"请输入收红包人的手机号";
//    mobileTF.font=FONT(15, 13);
//    mobileTF.textAlignment=NSTextAlignmentRight;
//    mobileTF.keyboardType=UIKeyboardTypeNumberPad;
////    mobileTF.backgroundColor=COLOR_CYAN;
//    [mobileView addSubview:mobileTF];
//    self.mobileTF=mobileTF;
    
    if (![self.scanMobile isEqualToString:@""] && self.scanMobile!=nil)
    {
        mobileTV.userInteractionEnabled=NO;
        mobileTV.text=self.scanMobile;
    }
    
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Ta若未注册，您发红包已为Ta注册，红包还加￥%@元，有短信通知Ta哦！",self.firstMoney]];
    
    UILabel *subMobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(20), mobileView.bottom+WZ(2.5), SCREEN_WIDTH-WZ(20*2), WZ(20))];
    subMobileLabel.font=FONT(10, 8);
    subMobileLabel.textAlignment=NSTextAlignmentRight;
//    subMobileLabel.backgroundColor=COLOR_CYAN;
    [string addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(23, string.length-34)];
    subMobileLabel.attributedText=string;
    subMobileLabel.hidden=YES;
    [backView addSubview:subMobileLabel];
    self.subMobileLabel=subMobileLabel;
    
    
    UIView *moneyView=[[UIView alloc]initWithFrame:CGRectMake(mobileView.left, mobileView.bottom+WZ(25), mobileView.width, mobileView.height)];
    moneyView.backgroundColor=COLOR_WHITE;
    [backView addSubview:moneyView];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(5), WZ(60), WZ(35))];
    moneyLabel.text=@"金额";
    moneyLabel.font=FONT(15, 13);
//    moneyLabel.backgroundColor=COLOR_CYAN;
    [moneyView addSubview:moneyLabel];
    
    UILabel *yuanLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyView.width-WZ(15*2), WZ(5), WZ(15*2), WZ(35))];
    yuanLabel.text=@"元";
    yuanLabel.font=FONT(15, 13);
//    yuanLabel.backgroundColor=COLOR_CYAN;
    [moneyView addSubview:yuanLabel];
    
//    UITextField *moneyTF=[[UITextField alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), moneyLabel.top, mobileView.width-WZ(15+15*2+10*2)-moneyLabel.width, moneyLabel.height)];
//    moneyTF.delegate=self;
//    moneyTF.font=FONT(15, 13);
//    moneyTF.placeholder=@"单个红包上限为200元";
//    moneyTF.textAlignment=NSTextAlignmentRight;
//    moneyTF.keyboardType=UIKeyboardTypeDecimalPad;
////    moneyTF.backgroundColor=COLOR_CYAN;
//    [moneyView addSubview:moneyTF];
//    self.moneyTF=moneyTF;
    
    YYTextView *moneyTV=[[YYTextView alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), moneyLabel.top+WZ(2.5), mobileView.width-WZ(15+15*2+10*2)-moneyLabel.width, moneyLabel.height-WZ(2.5*2))];
    moneyTV.delegate=self;
    moneyTV.font=FONT(15, 13);
    moneyTV.textAlignment=NSTextAlignmentRight;
    moneyTV.keyboardType=UIKeyboardTypeDecimalPad;
    [moneyView addSubview:moneyTV];
    moneyTV.inputAccessoryView = [self creatDoneView];
    self.moneyTV=moneyTV;
//    moneyTV.backgroundColor=COLOR_CYAN;
    
    UILabel *placeholderLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, moneyTV.width-5, moneyTV.height)];
    if (self.isMouth) {
        placeholderLabel1.text=@"单个外快上限为200元";
    }else{
        placeholderLabel1.text=@"单个红包上限为200元";
    }
    
    placeholderLabel1.textColor=COLOR(200, 200, 200, 1);
    placeholderLabel1.font=FONT(15, 13);
    placeholderLabel1.textAlignment=NSTextAlignmentRight;
    [moneyTV addSubview:placeholderLabel1];
    self.placeholderLabel1=placeholderLabel1;
    
    NSMutableAttributedString *sfString=[[NSMutableAttributedString alloc]initWithString:@"您只要实付￥0.00元"];
    UILabel *leftSubLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyView.left, moneyView.bottom+WZ(5), WZ(120), WZ(20))];
    leftSubLabel.font=FONT(10, 8);
    [sfString addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(6, sfString.length-7)];
    leftSubLabel.attributedText=sfString;
//    leftSubLabel.backgroundColor=COLOR_CYAN;
    [backView addSubview:leftSubLabel];
    self.leftSubLabel=leftSubLabel;
    
    NSMutableAttributedString *sdString=[[NSMutableAttributedString alloc]initWithString:@"而您的朋友收到的现金红包为￥0.00元"];
    UILabel *rightSubLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftSubLabel.right+WZ(10), leftSubLabel.top, SCREEN_WIDTH-WZ(20*2+10)-leftSubLabel.width, leftSubLabel.height)];
    [sdString addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(14, sdString.length-15)];
    rightSubLabel.attributedText=sdString;
    rightSubLabel.font=FONT(10, 8);
    rightSubLabel.textAlignment=NSTextAlignmentRight;
//    rightSubLabel.backgroundColor=COLOR_CYAN;
    [backView addSubview:rightSubLabel];
    self.rightSubLabel=rightSubLabel;
    
    UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(mobileView.left, moneyView.bottom+WZ(45), mobileView.width, mobileView.height)];
    detailView.backgroundColor=COLOR_WHITE;
    [backView addSubview:detailView];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(5), WZ(60), WZ(35))];
    detailLabel.text=@"留言";
    detailLabel.font=FONT(15, 13);
//    detailLabel.backgroundColor=COLOR_CYAN;
    [detailView addSubview:detailLabel];
    
    UITextField *detailTF=[[UITextField alloc]initWithFrame:CGRectMake(detailLabel.right+WZ(10), detailLabel.top, detailView.width-WZ(15+15+10)-detailLabel.width, detailLabel.height)];
    detailTF.delegate=self;
    if ([self.detail length]>10) {
        self.detail = [self.detail stringByReplacingCharactersInRange:NSMakeRange(10, [self.detail length]-10) withString:@"..."];;
    }
    detailTF.placeholder=self.detail;
    detailTF.font=FONT(15, 13);
    detailTF.textAlignment=NSTextAlignmentRight;
    detailTF.inputAccessoryView = [self creatDoneView];
//    detailTF.backgroundColor=COLOR_CYAN;
    [detailView addSubview:detailTF];
    self.detailTF=detailTF;
    
    UIView *payPswView=[[UIView alloc]initWithFrame:CGRectMake(detailView.left, detailView.bottom+WZ(25), detailView.width, detailView.height)];
    payPswView.backgroundColor=COLOR_WHITE;
    [backView addSubview:payPswView];
    
    UILabel *payPswLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(5), WZ(80), WZ(35))];
    payPswLabel.text=@"支付密码";
    payPswLabel.font=FONT(15, 13);
    //    payPswLabel.backgroundColor=COLOR_CYAN;
    [payPswView addSubview:payPswLabel];
    
    UITextField *payPswTF=[[UITextField alloc]initWithFrame:CGRectMake(payPswLabel.right+WZ(10), payPswLabel.top, payPswView.width-WZ(15+15+10)-payPswLabel.width, payPswLabel.height)];
    payPswTF.delegate=self;
    payPswTF.placeholder=@"请输入支付密码";
    payPswTF.font=FONT(15, 13);
    payPswTF.secureTextEntry=YES;
    payPswTF.textAlignment=NSTextAlignmentRight;
    payPswTF.inputAccessoryView = [self creatDoneView];
    //    payPswTF.backgroundColor=COLOR_CYAN;
    [payPswView addSubview:payPswTF];
    self.payPswTF=payPswTF;
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(payPswView.left+WZ(15), payPswView.bottom+WZ(15), WZ(80), WZ(30))];
    typeLabel.text=@"支付方式";
    typeLabel.font=FONT(15, 13);
//    typeLabel.backgroundColor=COLOR_CYAN;
    [backView addSubview:typeLabel];
    
    UIButton *typeBtn0=[[UIButton alloc]initWithFrame:CGRectMake(typeLabel.right, typeLabel.top+WZ(5), WZ(20), WZ(20))];
    typeBtn0.layer.cornerRadius=typeBtn0.width/2.0;
    typeBtn0.clipsToBounds=YES;
    [typeBtn0 setTitle:@"√" forState:UIControlStateNormal];
    [typeBtn0 setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    typeBtn0.titleLabel.font=FONT(15, 13);
    typeBtn0.backgroundColor=COLOR(255, 40, 59, 1);
    [typeBtn0 addTarget:self action:@selector(typeBtn0Click) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:typeBtn0];
    self.typeBtn0=typeBtn0;
    
    UILabel *typeLabel0=[[UILabel alloc]initWithFrame:CGRectMake(typeBtn0.right+WZ(3), typeBtn0.top, WZ(80), typeBtn0.height)];
    typeLabel0.text=@"好处币支付";
    typeLabel0.font=FONT(15, 13);
//    typeLabel0.backgroundColor=COLOR_CYAN;
    [backView addSubview:typeLabel0];
    
    UIButton *typeBtn1=[[UIButton alloc]initWithFrame:CGRectMake(typeLabel0.right+WZ(20), typeLabel.top+WZ(5), WZ(20), WZ(20))];
    typeBtn1.layer.cornerRadius=typeBtn1.width/2.0;
    typeBtn1.clipsToBounds=YES;
    typeBtn1.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    typeBtn1.layer.borderWidth=1;
    typeBtn1.backgroundColor=COLOR_WHITE;
    typeBtn1.titleLabel.font=FONT(15, 13);
    [typeBtn1 addTarget:self action:@selector(typeBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:typeBtn1];
    self.typeBtn1=typeBtn1;
    
    UILabel *typeLabel1=[[UILabel alloc]initWithFrame:CGRectMake(typeBtn1.right+WZ(3), typeBtn1.top, WZ(90), typeBtn1.height)];
    typeLabel1.text=@"支付宝支付";
    typeLabel1.font=FONT(15, 13);
//    typeLabel1.backgroundColor=COLOR_CYAN;
    [backView addSubview:typeLabel1];
    CGFloat hight = WZ(40);
    if (!self.isMouth) {
        hight = WZ(60);
        _tableView.scrollEnabled = NO;
        
    }
    UIButton *putBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), CGRectGetMaxY(typeLabel.frame)+hight, SCREEN_WIDTH-WZ(20*2), WZ(50))];
    putBtn.backgroundColor=COLOR(255, 40, 59, 1);
    putBtn.clipsToBounds=YES;
    putBtn.layer.cornerRadius=5;
    if (self.isMouth) {
        [putBtn setTitle:@"嘴一嘴" forState:UIControlStateNormal];
    }else{
        [putBtn setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    }
    
    [putBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    putBtn.titleLabel.font=FONT(16, 14);
    [putBtn addTarget:self action:@selector(putBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:putBtn];
    backView.backgroundColor = COLOR_HEADVIEW;
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(putBtn.frame)+WZ(20));
    _tableView.tableHeaderView = backView;
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isMouth) return 1;
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WZ(40)+WZ(30);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40)+WZ(30))];
    statusView.backgroundColor=COLOR_WHITE;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, WZ(30))];
    titleLabel.font =FONT(17, 15);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"TA的外快记录";
    [statusView addSubview:titleLabel];
    UIView * titleLine = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(titleLabel.frame)-1, WZ(40), 1)];
    titleLine.backgroundColor=COLOR_RED;
    [statusView addSubview:titleLine];
    
   
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), CGRectGetMaxY(titleLabel.frame), WZ(120), WZ(40))];
    nameLabel.text=@"用户";
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR_LIGHTGRAY;
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+WZ(10), CGRectGetMaxY(titleLabel.frame), WZ(90), WZ(40))];
    moneyLabel.text=@"金额";
    moneyLabel.textAlignment=NSTextAlignmentCenter;
    moneyLabel.font=FONT(15,13);
    moneyLabel.textColor=COLOR_LIGHTGRAY;
    //    moneyLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH-WZ(12)*3-WZ(120)-WZ(90), WZ(40))];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text=@"时间";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    //    timeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:timeLabel];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(statusView.frame)-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [statusView addSubview:lineView];
    return statusView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame)-1, SCREEN_WIDTH, 1)];
    //    lineView.backgroundColor = COLOR_HEADVIEW;
    //    [cell.contentView addSubview:lineView];
    NSDictionary *dict=self.recordsArray[indexPath.row];
    NSString *nickName=[dict objectForKey:@"nickname"];
    NSString *time=[NSString stringWithFormat:@"%@",[dict objectForKey:@"createTime"]];
    NSString *money=[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"money"] floatValue]];
    NSInteger isAdmin=[[dict objectForKey:@"isAdmin"] integerValue];
    NSString *imgUrlString=[dict objectForKey:@"headimg"];
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
    jineLabel.textAlignment = NSTextAlignmentCenter;
    jineLabel.text=[NSString stringWithFormat:@"￥ %@",money];
    jineLabel.font=FONT(11,9);
    jineLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:jineLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), userBtn.top, WZ(120), userBtn.height)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text=[NSString stringWithFormat:@"%@",time];
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:timeLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField==self.moneyTF)
//    {
//        // 当前输入的字符是'.'
//        if ([string isEqualToString:@"."])
//        {
//            // 已输入的字符串中已经包含了'.'或者""
//            if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""])
//            {
//                return NO;
//            }
//            else
//            {
//                return YES;
//            }
//        }
//        else
//        {
//            // 当前输入的不是'.'
//            // 第一个字符是0时, 第二个不能再输入0
//            if (textField.text.length == 1)
//            {
//                unichar str = [textField.text characterAtIndex:0];
//                if (str == '0' && [string isEqualToString:@"0"])
//                {
//                    return NO;
//                }
//            }
//            // 已输入的字符串中包含'.'
//            if ([textField.text rangeOfString:@"."].location != NSNotFound)
//            {
//                NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
//                [str insertString:string atIndex:range.location];
//                if (str.length >= [str rangeOfString:@"."].location + 4)
//                {
//                    return NO;
//                }
////                NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
//            }
//            else
//            {
//                if (textField.text.length > 2)
//                {
//                    return range.location < 3;
//                }
//            }
//        }
//        
////        NSLog(@"输入的金额===%@",textField.text);
//    
//        return YES;
//    }
//    return YES;
//}

-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView==self.moneyTV)
    {
        // 当前输入的字符是'.'
        if ([text isEqualToString:@"."])
        {
            // 已输入的字符串中已经包含了'.'或者""
            if ([textView.text rangeOfString:@"."].location != NSNotFound || [textView.text isEqualToString:@""])
            {
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else
        {
            // 当前输入的不是'.'
            // 第一个字符是0时, 第二个不能再输入0
            if (textView.text.length == 1)
            {
                unichar str = [textView.text characterAtIndex:0];
                if (str == '0' && [text isEqualToString:@"0"])
                {
                    return NO;
                }
            }
            // 已输入的字符串中包含'.'
            if ([textView.text rangeOfString:@"."].location != NSNotFound)
            {
                NSMutableString *str = [[NSMutableString alloc] initWithString:textView.text];
                [str insertString:text atIndex:range.location];
                if (str.length >= [str rangeOfString:@"."].location + 4)
                {
                    return NO;
                }
                //                NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
            }
            else
            {
                if (textView.text.length > 2)
                {
                    return range.location < 3;
                }
            }
        }
        
        //        NSLog(@"输入的金额===%@",textField.text);
        
        return YES;
    }
    if (textView==self.mobileTV)
    {
        if (textView.text.length>10)
        {
            return range.location < 11;
        }
        return YES;
    }
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    if (textField==self.mobileTF)
//    {
//        self.mobile=textField.text;
//    }
//    if (textField==self.moneyTF)
//    {
//        self.money=textField.text;
//    }
    if (textField==self.detailTF)
    {
        self.detail=textField.text;
    }
    if (textField==self.payPswTF)
    {
        self.password=textField.text;
    }
}

-(void)textViewDidChange:(YYTextView *)textView
{
    if (self.mobileTV==textView)
    {
        if (textView.text.length>0)
        {
            self.placeholderLabel0.hidden=YES;
        }
        else
        {
            self.placeholderLabel0.hidden=NO;
        }
        
        self.mobile=textView.text;
        
        if ([ViewController validateMobile:self.mobile])
        {
            if (self.mobile.length==11)
            {
                [HTTPManager ifUserMobileExistWithPhone:self.mobile complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        self.hasUser=[[resultDict objectForKey:@"hasUser"] integerValue];
                        if (self.hasUser==0)
                        {
                            //已注册
                            self.subMobileLabel.hidden=YES;
                        }
                        if (self.hasUser==1)
                        {
                            //未注册
                            self.subMobileLabel.hidden=NO;
                        }
                    }
                    else
                    {
                        NSString *msg=[resultDict objectForKey:@"msg"];
                        [self.view makeToast:msg duration:2.0];
                    }
                }];
            }
            else
            {
                self.subMobileLabel.hidden=YES;
            }
        }
        else
        {
            self.subMobileLabel.hidden=YES;
        }
        
    }
    if (self.moneyTV==textView)
    {
        if (textView.text.length>0)
        {
            self.placeholderLabel1.hidden=YES;
        }
        else
        {
            self.placeholderLabel1.hidden=NO;
        }
        
        self.money=textView.text;
        
        CGFloat sfMoney=0.00;
        if ([self.payType isEqualToString:@"0"])
        {
            //如果是余额支付
            sfMoney=[self.money floatValue]*self.merDiscount;
        }
        if ([self.payType isEqualToString:@"1"])
        {
            //如果是支付宝支付
            sfMoney=[self.money floatValue]*(self.merDiscount-0.08);
        }
        
        NSMutableAttributedString *sfMoneyString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您只要实付￥%.2f元",sfMoney]];
        [sfMoneyString addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(6, sfMoneyString.length-7)];
        self.leftSubLabel.attributedText=sfMoneyString;
        
        CGFloat sdMoney=0.00;
        if (self.hasUser==0)
        {
            //已注册
            sdMoney=[self.money floatValue]*self.merDiscount*(1-self.rakeRate);
        }
        if (self.hasUser==1)
        {
            //未注册
            sdMoney=[self.money floatValue]*self.merDiscount*(1-self.rakeRate)+[self.firstMoney floatValue];
        }
        NSMutableAttributedString *sdMoneyString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"而您的朋友收到的现金红包为￥%.2f元",sdMoney]];//对方未注册时需+[self.firstMoney floatValue]
        [sdMoneyString addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(14, sdMoneyString.length-15)];
        self.rightSubLabel.attributedText=sdMoneyString;
        
        //    NSLog(@"实付金额===%@",sfMoney);
    }
    
}





#pragma mark ===按钮点击方法===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//余额支付
-(void)typeBtn0Click
{
    self.payType=@"0";
    
    [self.typeBtn0 setTitle:@"√" forState:UIControlStateNormal];
    [self.typeBtn0 setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    self.typeBtn0.titleLabel.font=FONT(15, 13);
    self.typeBtn0.backgroundColor=COLOR(255, 40, 59, 1);
    
    self.typeBtn1.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    self.typeBtn1.layer.borderWidth=1;
    self.typeBtn1.backgroundColor=COLOR_WHITE;
    
    //如果是余额支付
    CGFloat sfMoney=[self.money floatValue]*self.merDiscount;
    
    NSMutableAttributedString *sfMoneyString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您只要实付￥%.2f元",sfMoney]];
    [sfMoneyString addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(6, sfMoneyString.length-7)];
    self.leftSubLabel.attributedText=sfMoneyString;
}

//支付宝支付
-(void)typeBtn1Click
{
    self.payType=@"1";
    
    [self.typeBtn1 setTitle:@"√" forState:UIControlStateNormal];
    [self.typeBtn1 setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    self.typeBtn1.titleLabel.font=FONT(15, 13);
    self.typeBtn1.backgroundColor=COLOR(255, 40, 59, 1);
    
    self.typeBtn0.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    self.typeBtn0.layer.borderWidth=1;
    self.typeBtn0.backgroundColor=COLOR_WHITE;
    
    //如果是支付宝支付
    CGFloat sfMoney=[self.money floatValue]*(self.merDiscount-0.08);
    
    NSMutableAttributedString *sfMoneyString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您只要实付￥%.2f元",sfMoney]];
    [sfMoneyString addAttributes:@{NSFontAttributeName:FONT(10, 8),NSForegroundColorAttributeName:COLOR_RED} range:NSMakeRange(6, sfMoneyString.length-7)];
    self.leftSubLabel.attributedText=sfMoneyString;
}

//塞钱进红包
-(void)putBtnClick
{
    [self.view endEditing:YES];
    [self.mobileTV resignFirstResponder];
    [self.moneyTV resignFirstResponder];
    [self.detailTF resignFirstResponder];
    [self.payPswTF resignFirstResponder];
    
    if ([ViewController validateMobile:self.mobile]==NO)
    {
        [self.view makeToast:@"手机号码错误" duration:2.0];
    }
    else
    {
        if ([self.money floatValue]<1)
        {
            [self.view makeToast:@"红包金额不能少于1元" duration:2.0];
        }
        else
        {
            if ([self.money floatValue]>200)
            {
                [self.view makeToast:@"单个红包金额不能超过200元" duration:2.0];
            }
            else
            {
                if ([self.payPswTF.text isEqualToString:@""])
                {
                    [self.view makeToast:@"请输入支付密码" duration:2.0];
                }
                else
                {
                    //发红包
                    if ([self.detail isEqualToString:@""])
                    {
                        self.detail=@"恭喜发财，大吉大利！";
                    }
                    
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"发送中..." detail:nil];
                    [hud show:YES];
                    [hud hide:YES afterDelay:20];
                    
                    [HTTPManager sendRedEnvelopeOneToOneWithUserId:[UserInfoData getUserInfoFromArchive].userId money:self.money toPhone:self.mobile theme:[self.detail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] password:self.payPswTF.text payType:self.payType type:self.type objId:self.objId  complete:^(NSDictionary *resultDict) {
                        NSString *result=[resultDict objectForKey:@"result"];
                        if ([result isEqualToString:STATUS_SUCCESS])
                        {
                            if ([self.payType isEqualToString:@"0"])
                            {
                                //如果余额支付 直接支付
                                if (self.isMouth) {
                                    [self.view.window makeToast:@"外快已发送成功" duration:2.0];
                                }else{
                                   [self.view.window makeToast:@"红包已送出" duration:2.0];
                                }
                                
                                [self backBtnClick];
                            }
                            if ([self.payType isEqualToString:@"1"])
                            {
                                //如果支付宝支付
                                NSString *aliParams=[resultDict objectForKey:@"aliParams"];
                                NSString *appScheme = @"Yunlian";
                                  
                                //调用支付结果开始支付
                                [[AlipaySDK defaultService] payOrder:aliParams fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                    NSLog(@"resultDic===%@",resultDic);
                                    
                                    NSString * code = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                                    if ([code isEqualToString:@"9000"]) {
                                         [self.view makeToast:@"红包已发出" duration:2];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }else {
                                        [self.view makeToast:@"支付失败" duration:2];
                                    }

                                }];
                            }
                        }
                        else
                        {
                            NSString *msg=[resultDict objectForKey:@"msg"];
                            [self.view makeToast:msg duration:2.0];
                        }
                        [hud hide:YES];
                    }];
                }
                
//                //弹出输入支付密码界面
//                [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@"输入支付密码确定发送红包"];
            }
        }
        
    }
    
    
}

////创建背景输入支付密码View
//-(void)createBackgroundViewWithSmallViewTitle:(NSString *)title detail:(NSString*)detail
//{
//    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
//    [self.view.window addSubview:bgView];
//    self.bgView=bgView;
//    
//    CGFloat spaceToBorder=WZ(20);
//    CGFloat smallViewWidth=SCREEN_WIDTH-WZ(30*2);
//    
//    CGSize titleSize=[ViewController sizeWithString:title font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(30))];
//    CGSize detailSize=[ViewController sizeWithString:detail font:FONT(15, 13) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(100))];
//    
//    CGFloat smallViewHeight=WZ(15*4+20)+titleSize.height+detailSize.height+WZ(35)+WZ(35);
//    
//    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(WZ(30), WZ(180), smallViewWidth, smallViewHeight)];
//    smallView.backgroundColor=COLOR_WHITE;
//    smallView.clipsToBounds=YES;
//    smallView.layer.cornerRadius=5;
//    [self.bgView addSubview:smallView];
//    self.smallView=smallView;
//    
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), titleSize.height)];
//    //    titleLabel.backgroundColor=COLOR_CYAN;
//    titleLabel.text=title;
//    titleLabel.textColor=COLOR_BLACK;
//    titleLabel.font=FONT(17, 15);
//    titleLabel.textAlignment=NSTextAlignmentCenter;
//    [smallView addSubview:titleLabel];
//    
//    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, titleLabel.bottom+WZ(15), smallView.width-WZ(spaceToBorder*2), detailSize.height)];
//    //    titleLabel.backgroundColor=COLOR_CYAN;
//    detailLabel.text=detail;
//    detailLabel.textColor=COLOR_LIGHTGRAY;
//    detailLabel.font=FONT(15, 13);
//    detailLabel.numberOfLines=0;
//    detailLabel.textAlignment=NSTextAlignmentLeft;
//    [smallView addSubview:detailLabel];
//    
//    UITextField *passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(spaceToBorder, detailLabel.bottom+WZ(10), smallView.width-WZ(spaceToBorder*2), WZ(35))];
//    passwordTF.delegate=self;
//    passwordTF.font=FONT(16, 14);
//    passwordTF.placeholder=@"请输入支付密码";
//    passwordTF.secureTextEntry=YES;
//    passwordTF.clipsToBounds=YES;
//    passwordTF.layer.cornerRadius=5;
//    passwordTF.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
//    passwordTF.layer.borderWidth=1.0;
//    [smallView addSubview:passwordTF];
//    self.passwordTF=passwordTF;
//    
//    NSArray *qxqdArray=[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];
//    
//    CGFloat buttonWidth=WZ(100);
//    CGFloat buttonHeight=WZ(35);
//    CGFloat buttonSpace=smallViewWidth-buttonWidth*2-spaceToBorder*2;
//    
//    for (NSInteger i=0; i<2; i++)
//    {
//        UIButton *qxqdBtn=[[UIButton alloc]initWithFrame:CGRectMake(spaceToBorder+(buttonWidth+buttonSpace)*(i%2), smallViewHeight-buttonHeight-WZ(20), buttonWidth, buttonHeight)];
//        [qxqdBtn setTitle:qxqdArray[i] forState:UIControlStateNormal];
//        qxqdBtn.titleLabel.font=FONT(17, 15);
//        qxqdBtn.clipsToBounds=YES;
//        qxqdBtn.layer.cornerRadius=5;
//        qxqdBtn.tag=i;
//        [qxqdBtn addTarget:self action:@selector(qxqdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [smallView addSubview:qxqdBtn];
//        
//        if (i==0)
//        {
//            [qxqdBtn setTitleColor:COLOR(98, 99, 100, 1) forState:UIControlStateNormal];
//            qxqdBtn.backgroundColor=COLOR(230, 235, 235, 1);
//        }
//        if (i==1)
//        {
//            [qxqdBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
//            qxqdBtn.backgroundColor=COLOR(254, 153, 160, 1);
//        }
//    }
//}
//
////取消确定按钮
//-(void)qxqdBtnClick:(UIButton*)button
//{
//    if (button.tag==0)
//    {
//        //取消 移除bgView
//        [self.bgView removeFromSuperview];
//    }
//    if (button.tag==1)
//    {
//        //确定支付 移除bgView
//        [self.bgView removeFromSuperview];
//        
//        if ([self.passwordTF.text isEqualToString:@""])
//        {
//            [self.view makeToast:@"请输入支付密码" duration:2.0];
//        }
//        else
//        {
//            if ([self.detail isEqualToString:@""])
//            {
//                self.detail=@"恭喜发财，大吉大利！";
//            }
//            
//            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"发送中..." detail:nil];
//            [hud show:YES];
//            [hud hide:YES afterDelay:20];
//            [HTTPManager sendRedEnvelopeOneToOneWithUserId:[UserInfoData getUserInfoFromArchive].userId money:self.money toPhone:self.mobile theme:self.detail password:self.passwordTF.text complete:^(NSDictionary *resultDict) {
//                NSString *result=[resultDict objectForKey:@"result"];
//                if ([result isEqualToString:STATUS_SUCCESS])
//                {
//                    [self.view.window makeToast:@"红包已送出" duration:2.0];
//                    [self backBtnClick];
//                }
//                else
//                {
//                    NSString *msg=[resultDict objectForKey:@"msg"];
//                    [self.view makeToast:msg duration:2.0];
//                }
//                [hud hide:YES];
//            }];
//
//            NSLog(@"红包金额：%@",self.money);
//        }
//        
//        
//    }
//}






-(void)getInfo{
    
    [HTTPManager getRedEnvelopeListWithReqDic:_reqDic WithUrl:@"v3/kissReCordList.api" complete:^(NSDictionary *resultDict) {
        NSLog(@"resultDict==%@",resultDict);
        
        NSInteger pageNum =[_reqDic[@"pageNum"] integerValue];
        if (pageNum==1) {
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary * listDic = resultDict[@"list"];
            if ([listDic isKindOfClass:[NSDictionary class]]) {
                NSArray * dataArray =listDic[@"data"];
                if ([dataArray isKindOfClass:[NSArray class]]) {
                    if (pageNum==1) {
                        [_recordsArray removeAllObjects];
                        [_recordsArray addObjectsFromArray:dataArray];
                        
                        if (_recordsArray.count>0) {
                            _tableView.tableFooterView = nil;
                            [_tableView reloadData];
                        }else{
                            [self creatTableFootView];
                        }
                        
                    }else{
                        NSMutableArray * indexArray = [self changeIndexWithFirstCount:_recordsArray.count Section:0 lastCount:_recordsArray.count+dataArray.count];
                        [_recordsArray addObjectsFromArray:dataArray];
                        [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                    }
                }else{
                    
                }
                
            }
            
        }
        
    }];
}
-(void)creatTableFootView{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(100))];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(17, 15);
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"暂无外快记录";
    _tableView.tableFooterView = titleLabel;
}
-(NSMutableArray*)changeIndexWithFirstCount:(NSInteger)firstCount  Section:(NSInteger)section lastCount:(NSInteger)lastCount{
    NSMutableArray* indexArray = [NSMutableArray array];
    for (NSInteger i=firstCount; i<lastCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexArray addObject:indexPath];
    }
    return indexArray;
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
