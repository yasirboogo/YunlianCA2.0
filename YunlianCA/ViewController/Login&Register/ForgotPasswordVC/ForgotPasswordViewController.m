//
//  ForgotPasswordViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/7.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ForgotPasswordViewController.h"


#define CELL_HEIGHT WZ(50)

@interface ForgotPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    //是否已经点击获取验证码
    BOOL _isGetCode;
    NSTimer *_timer;
    
}

@property(nonatomic,strong)UIButton *yzmBtn;

@property(nonatomic,strong)UITextField *mobileTF;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)UITextField *aNewPswTF;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)NSString *aNewPsw;
@property(nonatomic,strong)NSString *theCode;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isGetCode=NO;
    self.mobile=@"";
    self.code=@"";
    self.aNewPsw=@"";
    
    [self createNavigationBar];
    [self initSubviews];
    
    
    
    
    
}

-(void)createNavigationBar
{
    self.title=@"忘记密码";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(10), WZ(20))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor=COLOR_CYAN;
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)initSubviews
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
        
        NSArray *titleArray=@[@"手机号",@"验证码",@"新密码"];
        
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
            
            UIButton *yzmBtn=[[UIButton alloc]initWithFrame:CGRectMake(codeTF.right+WZ(10), 0, yzmBtnStringSize.width, CELL_HEIGHT)];
            [yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [yzmBtn setTitleColor:COLOR(153, 142, 190, 1) forState:UIControlStateNormal];
            yzmBtn.titleLabel.font=FONT(15,13);
            [yzmBtn addTarget:self action:@selector(yzmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell0.contentView addSubview:yzmBtn];
            self.yzmBtn=yzmBtn;
        }
        if (indexPath.row==2)
        {
            UITextField *aNewPswTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
            aNewPswTF.tag=2;
            aNewPswTF.delegate=self;
            aNewPswTF.font=FONT(15,13);
            aNewPswTF.placeholder=@"请输入新密码";
            aNewPswTF.text=self.aNewPsw;
            aNewPswTF.secureTextEntry=YES;
            [cell0.contentView addSubview:aNewPswTF];
            self.aNewPswTF=aNewPswTF;
        }
        
        
        cell0.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell0;
    }
    else
    {
        static NSString *cellIdentifier1=@"Cell1";
        UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (!cell1)
        {
            cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
        }
        else
        {
            while ([cell1.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell1.contentView.subviews lastObject] removeFromSuperview];
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
        [cell1.contentView addSubview:submitBtn];
        
        
        
        
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell1;
    }
}

#pragma mark ===UITableViewDelegate===

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(20))];
    aView.backgroundColor=COLOR(241, 241, 241, 1);
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        return WZ(100);
    }
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(20);
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
        self.aNewPsw=textField.text;
    }
    
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
-(void)yzmBtnClick
{
    [self.mobileTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.aNewPswTF resignFirstResponder];
    
    if (_isGetCode==NO)
    {
        if ([self.mobile isEqualToString:@""])
        {
            [self.view makeToast:@"请先输入手机号" duration:1.0];
        }
        else
        {
            if ([ViewController validateMobile:self.mobile]==NO)
            {
                [self.view makeToast:@"请输入正确的手机号" duration:1.0];
            }
            else
            {
                [HTTPManager getVerifyCodeWithName:self.mobile type:@"forgetPSW" complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        self.theCode=[resultDict objectForKey:@"code"];
                        
                        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
                        _isGetCode=YES;
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
        [self.yzmBtn setTitle:[NSString stringWithFormat:@"%lds后获取",(long)time] forState:UIControlStateNormal];
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

-(void)submitBtnClick
{
    [self.mobileTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.aNewPswTF resignFirstResponder];
    
    if ([self.mobile isEqualToString:@""])
    {
        [self.view makeToast:@"手机号不能为空" duration:1];
    }
    else
    {
        if ([ViewController validateMobile:self.mobile]==NO)
        {
            [self.view makeToast:@"请输入正确的手机号" duration:1];
        }
        else
        {
            if ([self.code isEqualToString:@""])
            {
                [self.view makeToast:@"验证码不能为空" duration:1];
            }
            else
            {
                if (![self.code isEqualToString:self.theCode])
                {
                    [self.view makeToast:@"请输入正确的验证码" duration:1];
                }
                else
                {
                    if ([self.aNewPsw isEqualToString:@""])
                    {
                        [self.view makeToast:@"请输入新密码" duration:1];
                    }
                    else
                    {
                        if (self.aNewPswTF.text.length<6 || self.aNewPswTF.text.length>12)
                        {
                            [self.view makeToast:@"密码为6-12位" duration:1];
                        }
                        else
                        {
                            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"重设密码中..." detail:nil];
                            [hud show:YES];
                            //重设密码
                            [HTTPManager forgotPswWithName:self.mobile password:self.aNewPsw complete:^(NSDictionary *resultDict) {
                                NSString *result=[resultDict objectForKey:@"result"];
                                if ([result isEqualToString:@"success"])
                                {
                                    [hud hide:YES];
                                    NSMutableDictionary *mobileDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.mobileTF.text,@"mobile",self.aNewPswTF.text,@"password", nil];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"mobile" object:nil userInfo:mobileDict];
                                    
                                    [self.view.window makeToast:@"重设密码成功" duration:2];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else
                                {
                                    [hud hide:YES];
                                    [self.view makeToast:[resultDict objectForKey:@"msg"] duration:2];
                                }
                            }];
                            [hud hide:YES afterDelay:20];
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
