//
//  TiXianConfirmViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "TiXianConfirmViewController.h"

#import "TiXianOkViewController.h"

@interface TiXianConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    //是否已经点击获取验证码
    BOOL _isGetCode;
    NSTimer *_timer;
    
    
    
    
}

@property(nonatomic,strong)UIButton *getYzmBtn;
@property(nonatomic,strong)UITextField *mobileTF;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)NSString *code;


@end

@implementation TiXianConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.code=@"";
    _isGetCode=NO;
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
    
    
    
}

-(void)createNavigationBar
{
    self.title=@"提现";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_tableView];
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
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
    
    if (indexPath.row!=3)
    {
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"提现金额",@"手机号码",@"验证码", nil];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(90), WZ(50))];
        titleLabel.text=titleArray[indexPath.row];
        //        titleLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row==0)
        {
            UILabel *tiXianLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            tiXianLabel.text=self.tiXianMoney;
            tiXianLabel.font=FONT(17, 15);
            [cell.contentView addSubview:tiXianLabel];
        }
        if (indexPath.row==1)
        {
            UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            mobileTF.placeholder=@"请输入您的银行预留手机号";
            mobileTF.font=FONT(17, 15);
            mobileTF.keyboardType=UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:mobileTF];
            self.mobileTF=mobileTF;
        }
        if (indexPath.row==2)
        {
            CGSize yzmSize=[ViewController sizeWithString:@"获取验证码" font:FONT(13,11) maxSize:CGSizeMake(WZ(100),WZ(50))];
            
            UITextField *codeTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width-WZ(10)-yzmSize.width, WZ(50))];
            codeTF.placeholder=@"请输入验证码";
            codeTF.font=FONT(17, 15);
            codeTF.keyboardType=UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:codeTF];
            self.codeTF=codeTF;
            
            UIButton *getYzmBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-yzmSize.width, 0, yzmSize.width, WZ(50))];
            [getYzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [getYzmBtn setTitleColor:COLOR(146, 135, 187, 1) forState:UIControlStateNormal];
            getYzmBtn.titleLabel.font=FONT(13,11);
            [getYzmBtn addTarget:self action:@selector(getYzmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:getYzmBtn];
            self.getYzmBtn=getYzmBtn;
            
        }
    }
    if (indexPath.row==3)
    {
        UIButton *confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        confirmBtn.backgroundColor=COLOR(254, 167, 173, 1);
        confirmBtn.layer.cornerRadius=5.0;
        confirmBtn.clipsToBounds=YES;
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:confirmBtn];
        
        cell.backgroundColor=COLOR_HEADVIEW;
    }
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
    titleView.backgroundColor=COLOR_HEADVIEW;
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==3)
    {
        return WZ(110);
    }
    else
    {
        return WZ(50);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(15);
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确定提现
-(void)confirmBtnClick
{
    [self.mobileTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    
    if ([self.mobileTF.text isEqualToString:@""])
    {
        [self.view makeToast:@"手机号不能为空" duration:1.0];
    }
    else
    {
        if ([ViewController validateMobile:self.mobileTF.text]==NO)
        {
            [self.view makeToast:@"请输入正确的手机号" duration:1.0];
        }
        else
        {
            if ([self.codeTF.text isEqualToString:@""] || [self.code isEqualToString:@""])
            {
                [self.view makeToast:@"验证码不能为空" duration:1.0];
            }
            else
            {
                if (![self.code isEqualToString:self.codeTF.text])
                {
                    [self.view makeToast:@"请输入正确的验证码" duration:1.0];
                }
                else
                {
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"请求中..." detail:nil];
                    [hud show:YES];
                    [hud hide:YES afterDelay:20];
                    //提现
                    [HTTPManager commissionWithdrawWithUserId:[UserInfoData getUserInfoFromArchive].userId money:self.tiXianMoney bankUserName:self.khUserName bankCode:self.cardNumber bankName:self.bankName bankCity:self.city subBranch:self.zhihang complete:^(NSDictionary *resultDict) {
                        [hud hide:YES];
                        NSString *result=[resultDict objectForKey:@"result"];
                        if ([result isEqualToString:STATUS_SUCCESS])
                        {
                            TiXianOkViewController *vc=[[TiXianOkViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        else
                        {
                            [self.view makeToast:@"提现失败" duration:2];
                        }
                    }];
                }
            }
        }
    }
    
    
    
    
    
    
}

//验证码
-(void)getYzmBtnClick
{
    [self.mobileTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    
    if (_isGetCode==NO)
    {
        if ([self.mobileTF.text isEqualToString:@""])
        {
            [self.view makeToast:@"请先输入手机号" duration:1.0];
        }
        else
        {
            if ([ViewController validateMobile:self.mobileTF.text]==NO)
            {
                [self.view makeToast:@"请输入正确的手机号" duration:1.0];
            }
            else
            {
                //获取验证码
                [HTTPManager getVerifyCodeWithName:self.mobileTF.text type:@"embody" complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        self.code=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"code"]];
                        
                        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
                        _isGetCode=YES;
                    }
                    else
                    {
                        [self.view makeToast:@"获取验证码失败，请重试" duration:1.0];
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
        self.getYzmBtn.userInteractionEnabled=NO;
        [self.getYzmBtn setTitle:[NSString stringWithFormat:@"%lds后获取",(long)time] forState:UIControlStateNormal];
        [self.getYzmBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
    }
    if (time==0)
    {
        self.getYzmBtn.userInteractionEnabled=YES;
        [self.getYzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getYzmBtn setTitleColor:COLOR(146, 135, 187, 1) forState:UIControlStateNormal];
        
        [_timer invalidate];
        _isGetCode=NO;
        
        time=60;
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
