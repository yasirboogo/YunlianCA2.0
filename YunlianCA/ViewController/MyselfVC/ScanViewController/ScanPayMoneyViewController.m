//
//  ScanPayMoneyViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/11/1.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ScanPayMoneyViewController.h"

#import "ScanPaySuccessViewController.h"

@interface ScanPayMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YYTextViewDelegate>
{
    UITableView *_tableView;
    UILabel * _bottomLabel;
    UITextField * _moneyTField;
    
    
}

@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *payPassword;
@property(nonatomic,strong)YYTextView *moneyTV;
@property(nonatomic,strong)UITextField *payPasswordTF;
@property(nonatomic,strong)UILabel *storeLabel;
@property(nonatomic,strong)UILabel *zhekouLabel;
@property(nonatomic,strong)UILabel *sfLabel;

@property(nonatomic,strong)NSString *storeName;
//@property(nonatomic,strong)NSString *discount;
@property(nonatomic,strong)NSString *discount0;
@property(nonatomic,strong)NSString *sfMoney;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;



@end

@implementation ScanPayMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sfMoney=@"0.00";
    self.money=@"";
    self.payPassword=@"";
    self.storeName=@"";
    //self.discount=@"";
    self.discount0=@"";
    
    [self createNavigationBar];
    [self createTableView];
    
    [self creatTableHeadView];
}

-(void)getStoreName
{
    if (self.merId!=nil && ![self.merId isEqualToString:@""])
    {
        [HTTPManager getStoreNameWithMerId:self.merId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                self.storeName=[resultDict objectForKey:@"merName"];
                self.storeLabel.text=self.storeName;
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:2.0];
                self.storeName=@"";
                self.storeLabel.text=self.storeName;
            }
        }];
    }
    else
    {
        self.storeName=@"";
        self.storeLabel.text=self.storeName;
    }
}

-(void)getZhekouInfo
{
    if (self.merId!=nil && ![self.merId isEqualToString:@""])
    {
        [HTTPManager getMerStoreDiscountWithUserId:[UserInfoData getUserInfoFromArchive].userId merId:self.merId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                self.discount0=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"merDiscount"]];
                NSInteger grade= [[resultDict objectForKey:@"grade"] integerValue];
                self.zhekouLabel.text= [NSString stringWithFormat:@"%ld",(long)grade];
                
    
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:2.0];
               
                self.zhekouLabel.text=@"0";
            }
        }];
    }
    else
    {
        //self.discount=@"";
        self.zhekouLabel.text=@"0";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getStoreName];
    [self getZhekouInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}
-(void)creatTableHeadView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    headView.backgroundColor = COLOR_HEADVIEW;
    self.storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WZ(30), SCREEN_WIDTH, WZ(50))];
    self.storeLabel.text = @"五仁餐饮店";
    self.storeLabel.textAlignment = NSTextAlignmentCenter;
    self.storeLabel.font = FONT(17, 15);
    [headView addSubview:self.storeLabel];
    
    self.zhekouLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(55))/2.0, CGRectGetMaxY(self.storeLabel.frame), WZ(55), WZ(55))];
    self.zhekouLabel.textAlignment = NSTextAlignmentCenter;
    self.zhekouLabel.text = @"8.0";
    self.zhekouLabel.textColor = COLOR_RED;
    self.zhekouLabel.font = FONT(25, 23);
    self.zhekouLabel.clipsToBounds = YES;
    self.zhekouLabel.layer.cornerRadius = 5.0f;
    self.zhekouLabel.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.zhekouLabel.layer.borderWidth = 1.0f;
    self.zhekouLabel.backgroundColor = [UIColor whiteColor];
    [headView addSubview:self.zhekouLabel];
    
    UILabel * headLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(self.zhekouLabel.frame), (SCREEN_WIDTH-WZ(55))/2.0-20, CGRectGetHeight(self.zhekouLabel.frame))];
    headLabel.textAlignment = NSTextAlignmentRight;
    headLabel.font = FONT(17, 15);
    headLabel.text = @"好处";
    [headView addSubview:headLabel];
    
    UILabel * footLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.zhekouLabel.frame)+10, CGRectGetMinY(self.zhekouLabel.frame), (SCREEN_WIDTH-WZ(55))/2.0-20, CGRectGetHeight(self.zhekouLabel.frame))];
    footLabel.textAlignment = NSTextAlignmentLeft;
    footLabel.font = FONT(17, 15);
    footLabel.text = @"段（点）";
    [headView addSubview:footLabel];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(WZ(15), CGRectGetMaxY(footLabel.frame)+WZ(50), SCREEN_WIDTH-WZ(15)*2, WZ(115))];
    backView.backgroundColor = [UIColor whiteColor];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 5.0f;
    backView.layer.borderWidth = 1.0f;
    backView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    [headView addSubview:backView];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, WZ(80), CGRectGetWidth(backView.frame), 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [backView addSubview:lineView];
    
    
    UILabel * titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WZ(75), WZ(80))];
    titleLabel2.font = FONT(18, 16);
    titleLabel2.text = @"金额(¥)：";
    [backView addSubview:titleLabel2];
    _moneyTField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel2.frame), 0, CGRectGetWidth(backView.frame)-CGRectGetMaxX(titleLabel2.frame), WZ(80))];
    _moneyTField.delegate = self;
    _moneyTField.font = FONT(24, 22);
    _moneyTField.placeholder = @"请输入付款金额";
    _moneyTField.inputAccessoryView = [self creatDoneView];
    _moneyTField.keyboardType = UIKeyboardTypeDecimalPad;
    [backView addSubview:_moneyTField];
    _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(backView.frame), CGRectGetMaxY(backView.frame), CGRectGetWidth(backView.frame), WZ(45))];
    _bottomLabel.font =FONT(18, 16);
    _bottomLabel.textColor = [UIColor grayColor];
    //_bottomLabel.text = @"好处币支付¥0元，再省¥0元";
    [self changeMoney:@"0.0"];
    _bottomLabel.textAlignment = NSTextAlignmentRight;
    [headView addSubview:_bottomLabel];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(WZ(15),CGRectGetMaxY(_bottomLabel.frame)+WZ(40), SCREEN_WIDTH-WZ(15)*2, WZ(50))];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    button.backgroundColor = COLOR_RED;
    [button setTitle:@"付款" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(SendPayMoneyToTABtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];
    _tableView.tableHeaderView = headView;
}
-(void)SendPayMoneyToTABtnClicked{
    [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@"输入支付密码完成充值"];
   
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
    passwordTF.font=FONT(16, 14);
    passwordTF.secureTextEntry=YES;
    passwordTF.clipsToBounds=YES;
    passwordTF.layer.cornerRadius=5;
    passwordTF.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    passwordTF.layer.borderWidth=1.0;
    [smallView addSubview:passwordTF];
    self.payPasswordTF=passwordTF;
    
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
-(void)qxqdBtnClick:(UIButton *)button{
    [self.bgView removeFromSuperview];
    [self.smallView removeFromSuperview];
    if (button.tag==1) {
        
        if ([self.payPasswordTF.text length]>0) {
            self.payPassword = self.payPasswordTF.text;
           
            [self okBtnClick];
        }else{
            [self.view makeToast:@"请输入支付密码" duration:1.0];
        }
        
    }
}
-(void)createNavigationBar
{
    self.title=@"好处币付款";
    
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
    return 0;
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
    
    if (indexPath.row==0)
    {
        UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), WZ(50)) text:@"收款商户:" textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
        [cell.contentView addSubview: titleLabel];
        
        UILabel *storeLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, WZ(50))];
        storeLabel.text=self.storeName;
        storeLabel.font=FONT(17, 15);
        [cell.contentView addSubview: storeLabel];
        self.storeLabel=storeLabel;
    }
    if (indexPath.row==1)
    {
        UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), WZ(50)) text:@"商家优惠:" textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
        [cell.contentView addSubview: titleLabel];
        
        UILabel *zhekouLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, WZ(50))];
        zhekouLabel.text=self.discount0;
        zhekouLabel.textColor=COLOR_RED;
        zhekouLabel.font=FONT(17, 15);
        [cell.contentView addSubview: zhekouLabel];
        self.zhekouLabel=zhekouLabel;
    }
    if (indexPath.row==2)
    {
        UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), WZ(50)) text:@"金额(元):" textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview: titleLabel];
        
        YYTextView *moneyTV=[[YYTextView alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2)-titleLabel.width, WZ(30))];
        moneyTV.delegate=self;
        moneyTV.font=FONT(17,15);
        moneyTV.placeholderText=@"请输入金额";
        moneyTV.text=self.money;
        moneyTV.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        [cell.contentView addSubview:moneyTV];
        self.moneyTV=moneyTV;
    }
    if (indexPath.row==3)
    {
        UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), WZ(50)) text:@"实付(元):" textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
        [cell.contentView addSubview: titleLabel];
        
        UILabel *sfLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, WZ(50))];
        sfLabel.text=self.storeName;
        sfLabel.textColor=COLOR_RED;
        sfLabel.font=FONT(17, 15);
        [cell.contentView addSubview:sfLabel];
        self.sfLabel=sfLabel;
    }
    if (indexPath.row==4)
    {
        UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), WZ(50)) text:@"支付密码:" textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
        [cell.contentView addSubview: titleLabel];
        
        UITextField *payPasswordTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, WZ(50))];
        payPasswordTF.tag=1;
        payPasswordTF.delegate=self;
        payPasswordTF.font=FONT(17,15);
        payPasswordTF.secureTextEntry=YES;
        payPasswordTF.placeholder=@"请输入支付密码";
        payPasswordTF.text=self.payPassword;
        [cell.contentView addSubview:payPasswordTF];
        self.payPasswordTF=payPasswordTF;
    }
    if (indexPath.row==5)
    {
        UIButton *okBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(50), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        okBtn.titleLabel.font=FONT(17,15);
        okBtn.layer.cornerRadius=5.0;
        okBtn.clipsToBounds=YES;
        okBtn.backgroundColor=COLOR(244, 170, 172, 1);
        [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:okBtn];
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okBtn.bottom+WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(60))];
        detailLabel.numberOfLines=3;
        detailLabel.text=@"温馨提示：本平台主做本地社区当面在线或线下交易，您确认该商户是您熟悉、信任的商家才可以支付。";
        detailLabel.textAlignment=NSTextAlignmentCenter;
        detailLabel.font=FONT(15, 13);
        [cell.contentView addSubview:detailLabel];
        
        cell.backgroundColor=COLOR_HEADVIEW;
    }
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
    headView.backgroundColor=COLOR_HEADVIEW;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5)
    {
        return SCREEN_HEIGHT-64-WZ(50*5+10);
    }
    else
    {
        return WZ(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(10);
}

-(void)topUpTFDonBtnClicked{
    [_moneyTField resignFirstResponder];
}
//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_tableView endEditing:YES];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * textStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if ([textField.text length]==1&&[string isEqualToString:@""]) {
        textStr = @"0";
    }
    [self changeMoney:textStr];
    return YES;
}

-(void)changeMoney:(NSString *)moneyStr{
    CGFloat money = [moneyStr floatValue];
    CGFloat discount = [self.discount0 floatValue];
    CGFloat  payMoney = money * discount;
    CGFloat saveMoney = money-payMoney;
    NSString * value =[NSString stringWithFormat:@"好处币实付¥%.2f元，再省¥%.2f元",payMoney,saveMoney];
    self.money = moneyStr;
    self.sfMoney = [NSString stringWithFormat:@"%f",payMoney];
    NSRange range1 = [value rangeOfString:[NSString stringWithFormat:@"¥%.2f",payMoney]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:value];
    [str  addAttribute:NSFontAttributeName value:FONT(18, 16) range:range1];
    NSRange range2 = [value rangeOfString:[NSString stringWithFormat:@"¥%.2f",saveMoney] options:NSBackwardsSearch];
    
    [str  addAttribute:NSFontAttributeName value:FONT(18, 16) range:range2];
    [str  addAttribute:NSForegroundColorAttributeName value:COLOR_RED range:range1];
    [str  addAttribute:NSForegroundColorAttributeName value:COLOR_RED range:range2];
    _bottomLabel.attributedText = str;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==1)
    {
        self.payPassword=textField.text;
    }
}

-(void)textViewDidChange:(YYTextView *)textView
{
    self.money=textView.text;
    self.sfMoney=[NSString stringWithFormat:@"%.2f",[textView.text floatValue]*[self.discount0 floatValue]];
    self.sfLabel.text=self.sfMoney;
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 确定支付
 */
-(void)okBtnClick
{
    [self.moneyTV resignFirstResponder];
    [self.payPasswordTF resignFirstResponder];
    
    if ([self.money isEqualToString:@""])
    {
        [self.view makeToast:@"金额不能为0" duration:2.0];
    }
    else
    {
        if ([self.payPassword isEqualToString:@""])
        {
            [self.view makeToast:@"请输入支付密码" duration:2.0];
            
        }
        else
        {
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"付款中..." detail:nil];
            [hud show:YES];
            [hud hide:YES afterDelay:20];
            //发送付款请求
            [HTTPManager scanQRCodePayWithUserId:[UserInfoData getUserInfoFromArchive].userId merId:self.merId termId:self.termId money:self.money sfMoney:self.sfMoney ymlPayPass:self.payPassword complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    NSDictionary *payInfoDict=[resultDict objectForKey:@"payInfo"];
                    NSString *merchantName=[payInfoDict objectForKey:@"merchantName"];
                    NSString *money=[NSString stringWithFormat:@"%.2f",[[payInfoDict objectForKey:@"money"] floatValue]];
                    NSString *sfMoney=[NSString stringWithFormat:@"%.2f",[[payInfoDict objectForKey:@"sfMoney"] floatValue]];
                    
                    //付款成功跳转付款成功界面
                    ScanPaySuccessViewController *vc=[[ScanPaySuccessViewController alloc]init];
                    vc.sfMoney=sfMoney;
                    vc.money=money;
                    vc.merchantName=merchantName;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    NSString *msg=[resultDict objectForKey:@"msg"];
                    [self.view makeToast:msg duration:2.0];
                }
                [hud hide:YES];
            }];
            
            
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
