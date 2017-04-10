//
//  RegisterViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RegisterViewController.h"
#import <SVProgressHUD.h>

#define CELL_HEIGHT WZ(50)

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_bigTableView;
    UITableView *_smallTableView;
    
    //是否已经点击获取验证码
    BOOL _isGetCode;
    NSTimer *_timer;
    
    
    
}

@property(nonatomic,strong)IQKeyboardReturnKeyHandler *returnKeyHandler;

@property(nonatomic,strong)UITextField *mobileTF;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)UITextField *loginPswTF;
//@property(nonatomic,strong)UITextField *payPswTF;
@property(nonatomic,strong)UITextField *tuijianTF;
@property(nonatomic,strong)UITextField *passwordTF;
@property(nonatomic,strong)NSString *password;//验证密码

@property(nonatomic,strong)UIButton *yzmBtn;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *loginPsw;
//@property(nonatomic,strong)NSString *payPsw;
@property(nonatomic,strong)NSString *tuijianma;
@property(nonatomic,strong)UIView *smallBgView;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *areaLabel;
@property(nonatomic,strong)UILabel *communityLabel;

@property(nonatomic,strong)NSMutableArray *addressArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *community;
@property(nonatomic,strong)NSString *provinceId;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *districtId;
@property(nonatomic,strong)NSString *areaId;
@property(nonatomic,strong)NSString *communityId;

@property(nonatomic,assign)NSInteger selectedRow;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *verifyCode;
//@property(nonatomic,assign)BOOL cellHidden;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    
    _isGetCode=NO;
//    self.cellHidden=NO;
    
    if (self.phone==nil)
    {
        self.mobile=@"";
    }
    else
    {
        self.mobile=self.phone;
    }
    self.password=@"";
    self.verifyCode=@"";
    self.state=@"";
    self.code=@"";
    self.loginPsw=@"";
//    self.payPsw=@"";
    self.tuijianma=@"";
    self.address=@"";
    self.province=@"";
    self.city=@"";
    self.district=@"";
    self.area=@"";
    self.community=@"";
    self.provinceId=@"";
    self.cityId=@"";
    self.districtId=@"";
    self.areaId=@"";
    self.communityId=@"0";
    
    self.addressArray=[NSMutableArray array];
    self.areaArray=[NSMutableArray array];
    
    
    [self createNavigationBar];
    [self createBigTableView];
    
    //云联惠存在，后台不存在，跳到注册界面，需要支付密码确认
    //云联惠和后台都不存在，跳到注册界面，新注册
}

//创建背景View
-(void)createBackgroundViewWithSmallViewTitle:(NSString *)title detail:(NSString*)detail
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    
    UIView *parentView = [[UIView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].windows[0];
    if (window.subviews.count > 0)
    {
        parentView = [window.subviews objectAtIndex:0];
    }
    [parentView addSubview:bgView];
    self.bgView=bgView;
    
    CGFloat spaceToBorder=WZ(20);
    CGFloat smallViewWidth=SCREEN_WIDTH-WZ(30*2);
    
    CGSize titleSize=[ViewController sizeWithString:title font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(30))];
    CGSize detailSize=[ViewController sizeWithString:detail font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(60))];
    
    CGFloat smallViewHeight=WZ(15*4+20)+titleSize.height+detailSize.height+WZ(35)+WZ(35);
    
    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(WZ(30), WZ(180), smallViewWidth, smallViewHeight)];
    smallView.backgroundColor=COLOR_WHITE;
    smallView.clipsToBounds=YES;
    smallView.layer.cornerRadius=5;
    [self.bgView addSubview:smallView];
    self.smallView=smallView;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), 0)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    titleLabel.text=title;
    titleLabel.textColor=COLOR_BLACK;
    titleLabel.font=FONT(17, 15);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [smallView addSubview:titleLabel];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, titleLabel.bottom+WZ(15), smallView.width-WZ(spaceToBorder*2), detailSize.height)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    detailLabel.text=detail;
//    detailLabel.textColor=COLOR_LIGHTGRAY;
    detailLabel.font=FONT(17, 15);
    detailLabel.numberOfLines=0;
    detailLabel.textAlignment=NSTextAlignmentLeft;
    [smallView addSubview:detailLabel];
    
    UITextField *passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(spaceToBorder, detailLabel.bottom+WZ(20), smallView.width-WZ(spaceToBorder*2), WZ(45))];
//    passwordTF.placeholder=@"请输入支付密码";
    passwordTF.tag=5;
    passwordTF.delegate=self;
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
    [self.passwordTF resignFirstResponder];
    
    if (button.tag==0)
    {
        //取消，移除bgView，退出注册界面
        [self.bgView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag==1)
    {
        if ([self.state isEqualToString:@"2"])
        {
            //确定 验证密码 成功则移除bgView
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在验证..." detail:nil];
            [hud show:YES];
            [HTTPManager ifPayPassword02ExistWithPassword:self.password phone:self.mobile token:@"" complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    //密码验证成功 移除self.bgView 继续填写信息提交
                    [self.bgView removeFromSuperview];
                    [self.view makeToast:@"密码验证成功" duration:2.0];
                    self.verifyCode=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"code"]];
                }
                else
                {
                    [self.bgView removeFromSuperview];
                    [self createBackgroundViewWithSmallViewTitle:@"" detail:@"支付密码错误，请输入支付密码验证："];
                }
                [hud hide:YES];
            }];
            [hud hide:YES afterDelay:20];
        }
        
        
    }
}

-(void)createNavigationBar
{
    self.title=@"注册";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(10), WZ(20))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createBigTableView
{
    _bigTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bigTableView.delegate=self;
    _bigTableView.dataSource=self;
    _bigTableView.tableFooterView=[[UIView alloc]init];
    _bigTableView.scrollEnabled=NO;
    [self.view addSubview:_bigTableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_bigTableView)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_bigTableView)
    {
        if (section==0)
        {
            return 4;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return self.addressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_bigTableView)
    {
        if (indexPath.section==0)
        {
            static NSString *cellIdentifier0=@"Cell0";
            UITableViewCell *cell0=[tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
            if (!cell0)
            {
                cell0=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0];
            }
            else
            {
                while ([cell0.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell0.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            NSArray *titleArray=@[@"手机号",@"验证码",@"登录密码",@"推荐码"];
            
            UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), CELL_HEIGHT) text:titleArray[indexPath.row] textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
            [cell0.contentView addSubview: titleLabel];
            
            if (indexPath.row==0)
            {
                UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
                mobileTF.tag=0;
                mobileTF.delegate=self;
                mobileTF.font=FONT(15,13);
                mobileTF.placeholder=@"请输入手机号";
                mobileTF.text=self.mobile;
                mobileTF.keyboardType=UIKeyboardTypeNumberPad;
                [cell0.contentView addSubview:mobileTF];
                self.mobileTF=mobileTF;
            }
            if (indexPath.row==1)
            {
                CGSize yzmBtnStringSize=[ViewController sizeWithString:@"获取验证码" font:FONT(15,13) maxSize:CGSizeMake(WZ(120),WZ(50))];
                
                UITextField *codeTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width-yzmBtnStringSize.width-WZ(10), CELL_HEIGHT)];
                codeTF.tag=1;
                codeTF.delegate=self;
                codeTF.font=FONT(15,13);
                codeTF.placeholder=@"请输入验证码";
                codeTF.text=self.code;
                codeTF.keyboardType=UIKeyboardTypeNumberPad;
                [cell0.contentView addSubview:codeTF];
                self.codeTF=codeTF;
//                if (self.yzmBtn) {
//                    [self.yzmBtn removeFromSuperview];
//                    self.yzmBtn= nil;
//                }
                UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(codeTF.right+WZ(10), 0, yzmBtnStringSize.width, CELL_HEIGHT)];
                self.yzmBtn=button;
                [self.yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.yzmBtn setTitleColor:COLOR(153, 142, 190, 1) forState:UIControlStateNormal];
                self.yzmBtn.titleLabel.font=FONT(15,13);
                [self.yzmBtn addTarget:self action:@selector(registYzmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell0.contentView addSubview:button];
                
            }
            if (indexPath.row==2)
            {
                UITextField *loginPswTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
                loginPswTF.tag=2;
                loginPswTF.delegate=self;
                loginPswTF.font=FONT(15,13);
                loginPswTF.placeholder=@"请输入登录密码";
                loginPswTF.text=self.loginPsw;
                loginPswTF.secureTextEntry=YES;
                [cell0.contentView addSubview:loginPswTF];
                self.loginPswTF=loginPswTF;
            }
            if (indexPath.row==3)
            {
                UITextField *tuijianTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
                tuijianTF.tag=4;
                tuijianTF.delegate=self;
                tuijianTF.font=FONT(15,13);
                tuijianTF.placeholder=@"请输入推荐码或者手机号码";
                tuijianTF.text=self.tuijianma;
                tuijianTF.keyboardType=UIKeyboardTypeNumberPad;
                [cell0.contentView addSubview:tuijianTF];
                self.tuijianTF=tuijianTF;
            }
            
            cell0.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell0;
        }
        else
        {
            static NSString *cellIdentifier2=@"Cell2";
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (!cell2)
            {
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            }
            else
            {
                while ([cell2.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell2.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            submitBtn.titleLabel.font=FONT(17,15);
            submitBtn.layer.cornerRadius=5.0;
            submitBtn.clipsToBounds=YES;
            submitBtn.backgroundColor=COLOR(244, 170, 172, 1);
            [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell2.contentView addSubview:submitBtn];
            
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell2;
        }
    }
    return nil;
}

#pragma mark ===UITableViewDelegate===
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_bigTableView)
    {
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        aView.backgroundColor=COLOR(241, 241, 241, 1);
        return aView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_bigTableView)
    {
        if (indexPath.section==0)
        {
            UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            if (cell.hidden==YES)
            {
                return 0;
            }
            else
            {
                return CELL_HEIGHT;
            }
        }
        else
        {
            return WZ(100);
        }
    }
    else
    {
        return CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_bigTableView)
    {
        return WZ(10);
    }
    else
    {
        return 0;
    }
}

//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_bigTableView endEditing:YES];
    [_smallBgView endEditing:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        self.mobile=textField.text;
    }
    if (textField.tag==1)
    {
        self.code=textField.text;
    }
    if (textField.tag==2)
    {
        self.loginPsw=textField.text;
    }
    if (textField.tag==4)
    {
        self.tuijianma=textField.text;
    }
    if (textField.tag==5)
    {
        self.password=textField.text;
    }
    
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
-(void)registYzmBtnClick:(UIButton *)button
{
    //[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.yzmBtn = button;
    //[button setTitle:@"怎么不变" forState:UIControlStateNormal];
    [_bigTableView endEditing:YES];
    
    if (_isGetCode==NO)
    {
        if ([self.mobile isEqualToString:@""])
        {
            [self.view makeToast:@"请先输入手机号" duration:2.0];
        }
        else
        {
            if ([ViewController validateMobile:self.mobile]==NO)
            {
                [self.view makeToast:@"请输入正确的手机号" duration:2.0];
            }
            else
            {
                [SVProgressHUD showWithStatus:@"提交中..."];
                [HTTPManager getVerifyCodeWithName:self.mobile type:@"register" complete:^(NSDictionary *resultDict) {
                    [SVProgressHUD dismiss];
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        self.verifyCode=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"code"]];
                        self.state=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"state"]];
                        
                        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
                        _isGetCode=YES;
                        
                        if ([self.state isEqualToString:@"1"])
                        {
                            [self.view.window makeToast:@"用户已注册，请直接登录。" duration:2.0];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        if ([self.state isEqualToString:@"2"])
                        {
                            [self createBackgroundViewWithSmallViewTitle:@"" detail:@"此用户支付系统已存在，请输入支付密码验证："];
                        }
                        if ([self.state isEqualToString:@"3"])
                        {
                            
                        }
                        
                        
                    }
                    else
                    {
                        NSString *msg=[resultDict objectForKey:@"msg"];
                        [self.view makeToast:msg duration:2.0];
                    }
                    
                }];
            }
            
        }
        
    }
    
    
}

//获取验证码倒计时
-(void)daoJiShi
{
    static NSInteger time=60;
    time--;
    
    if (time>0)
    {
        self.yzmBtn.userInteractionEnabled=NO;
        [self.yzmBtn setTitle:[NSString stringWithFormat:@"%lds后获取",time] forState:UIControlStateNormal];
        [self.yzmBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
    }
    if (time==0)
    {
        self.yzmBtn.userInteractionEnabled=YES;
        [self.yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.yzmBtn setTitleColor:COLOR(146, 135, 187, 1) forState:UIControlStateNormal];
        
        [_timer invalidate];
        _isGetCode=NO;
        
        time=60;
    }
}

//提交注册
-(void)submitBtnClick
{
    [_bigTableView endEditing:YES];
    
    if ([self.mobile isEqualToString:@""])
    {
        [self.view makeToast:@"手机号不能为空" duration:2.0];
    }
    else
    {
        if ([ViewController validateMobile:self.mobile]==NO)
        {
            [self.view makeToast:@"请输入正确的手机号" duration:2.0];
        }
        else
        {
            if ([self.code isEqualToString:@""])
            {
                [self.view makeToast:@"验证码不能为空" duration:2.0];
            }
            else
            {
                if (![self.code isEqualToString:self.verifyCode])
                {
                    [self.view makeToast:@"验证码不正确" duration:2.0];
                }
                else
                {
                    if ([self.loginPsw isEqualToString:@""])
                    {
                        [self.view makeToast:@"登录密码不能为空" duration:2.0];
                    }
                    else
                    {
                        if (self.loginPsw.length<6 || self.loginPsw.length>12)
                        {
                            [self.view makeToast:@"密码为6-12位" duration:2.0];
                        }
                        else
                        {
                            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在注册..." detail:nil];
                            [hud show:YES];
                            [hud hide:YES afterDelay:20];
                            //提交注册
                            [HTTPManager registerWithName:self.mobile password:self.loginPsw ylPayPass:self.loginPsw areaId:self.areaId inviteCode:self.tuijianma provinceId:self.provinceId cityId:self.cityId qyId:self.districtId xqId:self.communityId complete:^(NSDictionary *resultDict) {
                                NSString *result=[resultDict objectForKey:@"result"];
                                if ([result isEqualToString:STATUS_SUCCESS])
                                {
                                    NSMutableDictionary *mobileDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.mobileTF.text,@"mobile",self.loginPswTF.text,@"password", nil];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"mobile" object:nil userInfo:mobileDict];
                                    
                                    if (self.block) {
                                        _block(self.mobile,self.loginPsw);
                                    }
                                    [self.navigationController popViewControllerAnimated:NO];
                                }
                                else
                                {
                                    NSString *msg=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"msg"]];
                                    [self.view makeToast:msg duration:1.0];
                                }
                                [hud hide:YES];
                            }];
                        }
                    }
                    
                    
                }
            }
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
