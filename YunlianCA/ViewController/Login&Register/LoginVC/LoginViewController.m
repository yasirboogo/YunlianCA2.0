//
//  LoginViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "LoginViewController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"

#import<CoreText/CoreText.h>
#import "HyperlinksButton.h"
#import "TabBarViewController.h"
#import "RegisterViewController.h"
#import "ForgotPasswordViewController.h"
#import "ThirdLoginRegisterViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@interface LoginViewController ()
{
    
    
    
}

@property(nonatomic,copy)NSString *token;

@property(nonatomic,strong)UITextField *mobileTF;
@property(nonatomic,strong)UITextField *pswTF;
@property(nonatomic,strong)UIButton *rememberPswBtn;
@property(nonatomic,assign)BOOL isRemember;




@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *filePath0=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isRemember.plist"];
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath0])
    {
        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath0];
        NSString *string=[dict objectForKey:@"isRemember"];
        if ([string isEqualToString:@"yes"])
        {
            self.isRemember=YES;
        }
        else
        {
            self.isRemember=NO;
        }
    }
    else
    {
        self.isRemember=YES;
    }
    
    
    
    
    
    [self initSubviews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMobileNotification:) name:@"mobile" object:nil];
    
//    CGRectGetCenter
    
//    if (TARGET_IPHONE_SIMULATOR==1)
//    {
//        self.mobileTF.text=@"18565305463";
//        self.pswTF.text=@"123456";
//    }
//    else
//    {
//        self.mobileTF.text=@"13569404733";
//        self.pswTF.text=@"123456";
//    }
    
//    self.mobileTF.text=@"18565305463";
//    self.pswTF.text=@"123456";
//    //登录请求
//    [HTTPManager loginWithName:self.mobileTF.text password:self.pswTF.text complete:^(User *user) {
//        if ([user.result isEqualToString:STATUS_SUCCESS])
//        {
//            TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
//            self.navigationController.navigationBarHidden=NO;
//            [self.navigationController pushViewController:tabbarVC animated:NO];
//            
////            NSLog(@"用户信息==%@",[UserInfoData getUserInfoFromArchive].areaId);
//        }
//    }];
    
    
    
}

-(void)getMobileNotification:(NSNotification*)notification
{
    NSDictionary *mobileDict=[notification userInfo];
    NSString *mobile=[mobileDict objectForKey:@"mobile"];
    NSString *password=[mobileDict objectForKey:@"password"];
    self.mobileTF.text=mobile;
    self.pswTF.text=password;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

-(void)initSubviews
{
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
    NSDictionary *loginDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *mobile=[loginDict objectForKey:@"name"];
    NSString *password;
    if (self.isRemember==YES)
    {
        password=[loginDict objectForKey:@"password"];
    }
    else
    {
        password=@"";
    }
    
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImageView.image=IMAGE(@"login_bg");
    [self.view addSubview:bgImageView];
    
    UILabel *topLabel=[UILabel labelTextCenterWithFrame:CGRectMake(0, WZ(20), SCREEN_WIDTH, WZ(64)) text:@"登录" textColor:COLOR_WHITE font:FONT(19,17) textAlignment:NSTextAlignmentCenter backColor:COLOR_CLEAR];
    [self.view addSubview:topLabel];
    
    
    UIImageView *mobileIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(30),topLabel.bottom+WZ(50), WZ(20), WZ(25))];
    mobileIV.image=IMAGE(@"login_shoujihaoma");
//    mobileIV.backgroundColor=COLOR_CYAN;
    [self.view addSubview:mobileIV];
    
    UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(mobileIV.right+WZ(20), mobileIV.top, WZ(275), mobileIV.height)];
    mobileTF.font=FONT(17,15);
    mobileTF.textColor=COLOR_WHITE;
    mobileTF.text=mobile;
//    mobileTF.backgroundColor=COLOR_CYAN;
    mobileTF.keyboardType=UIKeyboardTypeNumberPad;
    mobileTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:mobileTF];
    self.mobileTF=mobileTF;
    
//    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
//    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
//    self.mobileTF.text=[dict objectForKey:@"name"];
    
    UIView *lineView1=[UIView lineViewWithFrame:CGRectMake(WZ(30), mobileTF.bottom+WZ(5), WZ(315), 1)];
    [self.view addSubview:lineView1];
    
    UIImageView *pswIV=[[UIImageView alloc]initWithFrame:CGRectMake(mobileIV.left, lineView1.bottom+WZ(40), mobileIV.width, mobileIV.height)];
    pswIV.image=IMAGE(@"login_mima");
//    pswIV.backgroundColor=COLOR_CYAN;
    [self.view addSubview:pswIV];
    
    UITextField *pswTF=[[UITextField alloc]initWithFrame:CGRectMake(mobileTF.left, pswIV.top, mobileTF.width, mobileTF.height)];
    pswTF.font=FONT(17,15);
    pswTF.textColor=COLOR_WHITE;
    pswTF.secureTextEntry=YES;
    pswTF.text=password;
//    pswTF.backgroundColor=COLOR_CYAN;
    pswTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:pswTF];
    self.pswTF=pswTF;
    
    UIView *lineView2=[UIView lineViewWithFrame:CGRectMake(lineView1.left, pswTF.bottom+WZ(5), lineView1.width, 1)];
    [self.view addSubview:lineView2];
    
    UIButton *rememberPswBtn=[[UIButton alloc]initWithFrame:CGRectMake(mobileIV.left, lineView2.bottom+WZ(10), WZ(17), WZ(17))];
//    rememberPswBtn.selected=YES;
    [rememberPswBtn addTarget:self action:@selector(rememberPswBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    rememberPswBtn.backgroundColor=COLOR_WHITE;
    [self.view addSubview:rememberPswBtn];
    self.rememberPswBtn=rememberPswBtn;
    
    if (self.isRemember==YES)
    {
        [rememberPswBtn setBackgroundImage:IMAGE(@"xuanze_xz") forState:UIControlStateNormal];
    }
    else
    {
        [rememberPswBtn setBackgroundImage:IMAGE(@"xuanze_wxz") forState:UIControlStateNormal];
    }
    
    UILabel *rememberPswLabel=[UILabel aLabelWithFrame:CGRectMake(rememberPswBtn.right+WZ(10), rememberPswBtn.top, WZ(100), rememberPswBtn.height) labelSize:CGSizeMake(WZ(150), WZ(20)) text:@"记住密码" textColor:COLOR_WHITE bgColor:COLOR_CLEAR font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:rememberPswLabel];
    
    CGSize forgotPswBtnSize=[ViewController sizeWithString:@"忘记密码？" font:FONT(15,13) maxSize:CGSizeMake(WZ(150), WZ(20))];
    UIButton *forgotPswBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-forgotPswBtnSize.width-WZ(30), rememberPswLabel.top, forgotPswBtnSize.width, rememberPswLabel.height)];
    [forgotPswBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgotPswBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    forgotPswBtn.titleLabel.font=FONT(15,13);
//    forgotPswBtn.backgroundColor=COLOR_CYAN;
    [forgotPswBtn addTarget:self action:@selector(forgotPswBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPswBtn];
    
    UIButton *loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(30), rememberPswLabel.bottom+WZ(40), SCREEN_WIDTH-WZ(30*2), WZ(50))];
    loginBtn.backgroundColor=COLOR(254, 167, 173, 1);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    loginBtn.clipsToBounds=YES;
    loginBtn.layer.cornerRadius=5.0;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIView *aView=[ViewController lineLabelviewWithFrame:CGRectMake(WZ(30), loginBtn.bottom+WZ(44), SCREEN_WIDTH-WZ(30*2), WZ(25)) labelString:@"使用其他账户登录" font:FONT(15,13) textColor:COLOR_WHITE backgroundColor:COLOR_CLEAR];
    [self.view addSubview:aView];
    
    NSArray *imageArray=[[NSArray alloc]initWithObjects:IMAGE(@"login_wx"),IMAGE(@"login_qq"),IMAGE(@"login_wb"), nil];
    
    for (NSInteger i=0; i<3; i++)
    {
        UIButton *wxqqwbBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(60)+WZ(45+60)*(i%3), aView.bottom+WZ(25), WZ(45), WZ(45))];
        wxqqwbBtn.tag=i;
        wxqqwbBtn.clipsToBounds=YES;
        wxqqwbBtn.layer.cornerRadius=wxqqwbBtn.width/2.0;
//        wxqqwbBtn.backgroundColor=COLOR_CYAN;
        [wxqqwbBtn setBackgroundImage:imageArray[i] forState:UIControlStateNormal];
        [wxqqwbBtn addTarget:self action:@selector(wxqqwbBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:wxqqwbBtn];
    }
    
    CGSize registerLabelSize=[ViewController sizeWithString:@"您还没有注册？" font:FONT(17,15) maxSize:CGSizeMake(WZ(150),WZ(25))];
    CGSize registerBtnSize=[ViewController sizeWithString:@"马上注册" font:FONT(17,15) maxSize:CGSizeMake(WZ(150),WZ(25))];
    
    UILabel *registerLabel=[UILabel aLabelWithFrame:CGRectMake((SCREEN_WIDTH-registerBtnSize.width-registerLabelSize.width)/2.0, aView.bottom+WZ(25+45+40), registerLabelSize.width, WZ(25)) labelSize:CGSizeMake(WZ(150), WZ(25)) text:@"您还没有注册？" textColor:COLOR_WHITE bgColor:COLOR_CLEAR font:FONT(15,13) textAlignment:NSTextAlignmentRight];
    [self.view addSubview:registerLabel];
    
    HyperlinksButton *registerBtn=[[HyperlinksButton alloc]initWithFrame:CGRectMake(registerLabel.right, registerLabel.top, registerBtnSize.width, WZ(25))];
    registerBtn.titleLabel.font=FONT(15,13);
    [registerBtn setTitle:@"马上注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    [registerBtn setColor:COLOR_ORANGE];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
}

-(void)loginBtnClick
{
    [self.mobileTF resignFirstResponder];
    [self.pswTF resignFirstResponder];
    
    if ([self.mobileTF.text isEqualToString:@""])
    {
        [self.view makeToast:@"手机号不能为空" duration:2.0];
    }
    else
    {
        if ([ViewController validateMobile:self.mobileTF.text]==NO)
        {
            [self.view makeToast:@"请输入正确的手机号" duration:2.0];
        }
        else
        {
            if ([self.pswTF.text isEqualToString:@""])
            {
                [self.view makeToast:@"密码不能为空" duration:2.0];
            }
            else
            {
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在登录..." detail:nil];
                [hud show:YES];
                [hud hide:YES afterDelay:20];
                //登录请求
                [HTTPManager loginWithName:self.mobileTF.text password:self.pswTF.text complete:^(User *user) {
                    if ([user.result isEqualToString:STATUS_SUCCESS])
                    {
                        [hud hide:YES];
                        
                        if ([user.state isEqualToString:@"1"])
                        {
                            //直接登录
                            NSString *string;
                            if (self.isRemember==YES)
                            {
                                string=@"yes";
                            }
                            else
                            {
                                string=@"no";
                            }
                            //是否记住密码
                            NSString *filePath0=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isRemember.plist"];
                            NSMutableDictionary *loginDict0=[[NSMutableDictionary alloc]initWithObjectsAndKeys:string,@"isRemember", nil];
                            [loginDict0 writeToFile:filePath0 atomically:YES];
                            
                            //手机号和密码
                            NSString *filePath1=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
                            NSMutableDictionary *loginDict1=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.mobileTF.text,@"name",self.pswTF.text,@"password", nil];
                            [loginDict1 writeToFile:filePath1 atomically:YES];
                            
                            //是否登录
                            NSString *filePath2=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ifLogin.plist"];
                            NSMutableDictionary *loginDict2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"L",@"ifLogin", nil];
                            [loginDict2 writeToFile:filePath2 atomically:YES];
                            
                            NSString *filePath3=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
                            NSMutableDictionary *dict3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.areaName,@"area",user.areaId,@"areaId", nil];
                            [dict3 writeToFile:filePath3 atomically:YES];
                            
                            self.token=user.token;
                            //保存融云用户id和token
                            NSString *path = [[NSBundle mainBundle] pathForResource:@"rongyunToken" ofType:@"plist"];
                            NSMutableDictionary *rongyunDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.userId,@"userId",user.token,@"token", nil];
                            [rongyunDict writeToFile:path atomically:YES];
                            
                            
                            [self connectRongYunServer];
                            
                            TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                            self.navigationController.navigationBarHidden=NO;
                            [self.navigationController pushViewController:tabbarVC animated:NO];
                            
                            //保存是否第三方登录信息
                            NSString *path0=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
                            NSMutableDictionary *isThirdLoginDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"否",@"isThird", nil];
                            [isThirdLoginDict writeToFile:path0 atomically:YES];
                            
                            
                            //极光推送相关
                            //获取极光registrationID
                            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                                NSLog(@"登录获取极光registrationID===%@",registrationID);
                                
                                NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"registrationID.plist"];
                                NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:registrationID,@"registrationID", nil];
                                [dict writeToFile:filePath atomically:YES];
                                
                                if ([UserInfoData getUserInfoFromArchive].userId!=nil && ![[UserInfoData getUserInfoFromArchive].userId isEqualToString:@""])
                                {
                                    //极光推送绑定设备号
                                    [HTTPManager uploadDeviceTokenUserId:[UserInfoData getUserInfoFromArchive].userId jgCode:registrationID complete:^(NSDictionary *resultDict) {
                                        
                                    }];
                                }
                            }];
                            
                        }
                        else
                        {
                            //云联惠存在，后台不存在，跳到注册界面，需要支付密码确认
                            RegisterViewController *registerVC=[[RegisterViewController alloc]init];
                            registerVC.phone=self.mobileTF.text;
                            __weak LoginViewController * weakSelf = self;
                            registerVC.block = ^(NSString * phone,NSString * password){
                                
                                weakSelf.mobileTF.text = phone;
                                weakSelf.pswTF.text = password;
                                [weakSelf loginBtnClick];
                            };
                            self.navigationController.navigationBarHidden=NO;
                            [self.navigationController pushViewController:registerVC animated:YES];
                        }
                    }
                    else
                    {
                        [hud hide:YES];
                        [self.view makeToast:user.msg duration:2.0];
                    }
                }];
            }
        }
    }
    
}


//连接融云服务器
-(void)connectRongYunServer
{
    [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId) {
        
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"登陆的错误码为:%ld", (long)status);
        
    } tokenIncorrect:^{
        
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"融云token错误");
    }];
}

//记住密码
-(void)rememberPswBtnClick
{
    if (self.isRemember==YES)
    {
        self.pswTF.text=@"";
        [self.rememberPswBtn setBackgroundImage:IMAGE(@"xuanze_wxz") forState:UIControlStateNormal];
        
        NSString *filePath0=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isRemember.plist"];
        NSDictionary *loginDict0=[NSDictionary dictionaryWithContentsOfFile:filePath0];
        [loginDict0 setValue:@"no" forKey:@"isRemember"];
        [loginDict0 writeToFile:filePath0 atomically:YES];
    }
    else
    {
        [self.rememberPswBtn setBackgroundImage:IMAGE(@"xuanze_xz") forState:UIControlStateNormal];
        
        NSString *filePath0=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isRemember.plist"];
        NSDictionary *loginDict0=[NSDictionary dictionaryWithContentsOfFile:filePath0];
        [loginDict0 setValue:@"yes" forKey:@"isRemember"];
        [loginDict0 writeToFile:filePath0 atomically:YES];
    }
    self.isRemember=!self.isRemember;
}

//注册
-(void)registerBtnClick
{
    RegisterViewController *registerVC=[[RegisterViewController alloc]init];
    __weak LoginViewController * weakSelf = self;
    registerVC.block = ^(NSString * phone,NSString * password){
        
        weakSelf.mobileTF.text = phone;
        weakSelf.pswTF.text = password;
        [weakSelf loginBtnClick];
    };

    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:registerVC animated:YES];
}

//忘记密码
-(void)forgotPswBtnClick
{
    ForgotPasswordViewController *forgotVC=[[ForgotPasswordViewController alloc]init];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:forgotVC animated:YES];
}

//第三方登录
-(void)wxqqwbBtnClick:(UIButton*)button
{
    if (button.tag==0)
    {
        //微信登录
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
            
            NSDictionary *infoData=user.rawData;
            NSString *uid=user.uid;
            NSString *nickname=[infoData objectForKey:@"nickname"];
            NSString *headimgurl=[infoData objectForKey:@"headimgurl"];
            NSString *sex=[NSString stringWithFormat:@"%@",[infoData objectForKey:@"sex"]];
            NSString *token=user.credential.token;
            
            //把第三方登录信息存入本地
            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
            NSMutableDictionary *loginInfoDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:uid,@"uid",nickname,@"nickname",headimgurl,@"icon",sex,@"sex",uid,@"uid",token,@"token", nil];
            [loginInfoDict writeToFile:filePath atomically:YES];
            
            //查看是否是第一次第三方登陆
            [HTTPManager ifFirstThirdLoginWithName:uid complete:^(User *user) {
                if ([user.result isEqualToString:STATUS_SUCCESS])
                {
                    NSInteger status=[user.status integerValue];
                    if (status==1)
                    {
                        //第一次登录 跳转绑定界面
                        ThirdLoginRegisterViewController *vc=[[ThirdLoginRegisterViewController alloc]init];
                        self.navigationController.navigationBarHidden=NO;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        //不是第一次登录 直接跳转登录 同时连接融云服务器
                        TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                        self.navigationController.navigationBarHidden=NO;
                        [self.navigationController pushViewController:tabbarVC animated:NO];
                        
                        self.token=user.token;
                        [self connectRongYunServer];
                    }
                }
                else
                {
                    
                }
            }];
            
        } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
            
        }];
        
    }
    if (button.tag==1)
    {
        //QQ登录
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
            
            NSDictionary *infoData=user.rawData;
            NSString *uid=user.uid;
            NSString *nickname=[infoData objectForKey:@"nickname"];
            NSString *headimgurl=[infoData objectForKey:@"figureurl_qq_2"];
            NSString *sex=[NSString stringWithFormat:@"%@",[infoData objectForKey:@"gender"]];
            NSString *token=user.credential.token;
            NSString *province=[infoData objectForKey:@"province"];
            NSString *city=[infoData objectForKey:@"city"];
            
            //                 NSLog(@"token===%@",token);
            //                 NSLog(@"uid=%@",user.uid);
            //                 NSLog(@"nickname=%@",user.nickname);
            //                 NSLog(@"icon=%@",user.icon);
            //                 NSLog(@"授权凭证%@",user.credential.rawData);
            //                 NSLog(@"openid=%@",[user.credential.rawData objectForKey:@"openid"]);
            
            //把第三方登录信息存入本地
            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
            NSMutableDictionary *loginInfoDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:uid,@"uid",nickname,@"nickname",headimgurl,@"icon",sex,@"sex",token,@"token",province,@"province",city,@"city", nil];
            [loginInfoDict writeToFile:filePath atomically:YES];
            
            //查看是否是第一次第三方登陆
            [HTTPManager ifFirstThirdLoginWithName:uid complete:^(User *user) {
                if ([user.result isEqualToString:STATUS_SUCCESS])
                {
                    NSInteger status=[user.status integerValue];
                    if (status==1)
                    {
                        //第一次登录 跳转绑定界面
                        ThirdLoginRegisterViewController *vc=[[ThirdLoginRegisterViewController alloc]init];
                        self.navigationController.navigationBarHidden=NO;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        //不是第一次登录 直接跳转登录
                        TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                        self.navigationController.navigationBarHidden=NO;
                        [self.navigationController pushViewController:tabbarVC animated:NO];
                        
                        self.token=user.token;
                        [self connectRongYunServer];
                    }
                }
                else
                {
                    
                }
            }];
            
            
            
        } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
            
        }];
    }
    if (button.tag==2)
    {
        //微博登录
        [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
            
            NSString *nickname=user.nickname;
            NSString *headimgurl=user.icon;
            NSString *uid=user.uid;
            NSString *token=user.credential.token;
            
//            NSLog(@"infoData===%@",infoData);
//            NSLog(@"授权凭证%@",user.credential);
//            NSLog(@"uid=%@",user.uid);
//            NSLog(@"nickname=%@",user.nickname);
//            NSLog(@"icon=%@",user.icon);
//            NSLog(@"token=%@",user.credential.token);
            
            //把第三方登录信息存入本地
            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
            NSMutableDictionary *loginInfoDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:uid,@"uid",nickname,@"nickname",headimgurl,@"icon",token,@"token", nil];
            [loginInfoDict writeToFile:filePath atomically:YES];
            
            //查看是否是第一次第三方登陆
            [HTTPManager ifFirstThirdLoginWithName:uid complete:^(User *user) {
                if ([user.result isEqualToString:STATUS_SUCCESS])
                {
                    NSInteger status=[user.status integerValue];
                    if (status==1)
                    {
                        //第一次登录 跳转绑定界面
                        ThirdLoginRegisterViewController *vc=[[ThirdLoginRegisterViewController alloc]init];
                        self.navigationController.navigationBarHidden=NO;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        //不是第一次登录 直接跳转登录
                        TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                        self.navigationController.navigationBarHidden=NO;
                        [self.navigationController pushViewController:tabbarVC animated:NO];
                        
                        self.token=user.token;
                        [self connectRongYunServer];
                    }
                }
                else
                {
                    
                }
            }];
            
            
            
        } onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
            
        }];
    }
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
