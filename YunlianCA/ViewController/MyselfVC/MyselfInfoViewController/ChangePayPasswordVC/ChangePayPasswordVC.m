//
//  ChangePayPasswordVC.m
//  YunlianCA
//
//  Created by QinJun on 16/10/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ChangePayPasswordVC.h"


#define CELL_HEIGHT WZ(50)

@interface ChangePayPasswordVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)UITextField *aOldPswTF;
@property(nonatomic,strong)UITextField *aNewPswTF;
@property(nonatomic,strong)NSString *aOldPsw;
@property(nonatomic,strong)NSString *aNewPsw;

@end

@implementation ChangePayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aOldPsw=@"";
    self.aNewPsw=@"";
    
    [self createNavigationBar];
    [self initSubviews];
    
    //点击推送alertView进入此界面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"changePsw"] isEqualToString:@"changePsw"])
    {
        [self.tabBarController.tabBar setHidden:YES];
        //给导航栏加一个返回按钮，便于将推送进入的页面返回出去，如果不是推送进入该页面，那肯定是通过导航栏进入的，则页面导航栏肯定会有导航栏自带的leftBarButtonItem返回上一个页面
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(rebackToRootViewAction)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    
}

- (void)rebackToRootViewAction
{
    //将标示条件置空，以防通过正常情况下导航栏进入该页面时无法返回上一级页面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"" forKey:@"changePsw"];
    [pushJudge synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.title=@"修改支付密码";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(10), WZ(20))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
        return 2;
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
        
        NSArray *titleArray=@[@"旧密码",@"新密码"];
        
        UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), CELL_HEIGHT) text:titleArray[indexPath.row] textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
        [cell0.contentView addSubview: titleLabel];
        
        if (indexPath.row==0)
        {
            UITextField *aOldPswTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
            aOldPswTF.tag=0;
            aOldPswTF.delegate=self;
            aOldPswTF.font=FONT(15,13);
            aOldPswTF.placeholder=@"请输入旧支付密码";
            aOldPswTF.text=self.aOldPsw;
            aOldPswTF.secureTextEntry=YES;
            [cell0.contentView addSubview:aOldPswTF];
            self.aOldPswTF=aOldPswTF;
        }
        if (indexPath.row==1)
        {
            UITextField *aNewPswTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
            aNewPswTF.tag=1;
            aNewPswTF.delegate=self;
            aNewPswTF.font=FONT(15,13);
            aNewPswTF.placeholder=@"请输入新支付密码";
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
        self.aOldPsw=textField.text;
    }
    if (textField.tag==1)
    {
        self.aNewPsw=textField.text;
    }
}

//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitBtnClick
{
    [_tableView endEditing:YES];
    
    if ([self.aOldPsw isEqualToString:@""])
    {
        [self.view makeToast:@"请输入旧密码" duration:1];
    }
    else
    {
        if (self.aOldPswTF.text.length<6 || self.aOldPswTF.text.length>12)
        {
            [self.view makeToast:@"密码为6-12位" duration:1];
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
                    [hud hide:YES afterDelay:20];
                    //修改支付密码
                    [HTTPManager changePayPasswordWithUserId:[UserInfoData getUserInfoFromArchive].userId oldPassword:self.aOldPswTF.text newPassword:self.aNewPswTF.text complete:^(NSDictionary *resultDict) {
                        [hud hide:YES];
                        NSString *result=[resultDict objectForKey:@"result"];
                        if ([result isEqualToString:STATUS_SUCCESS])
                        {
                            NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
                            if ([[pushJudge objectForKey:@"changePsw"] isEqualToString:@"changePsw"])
                            {
                                [self rebackToRootViewAction];
                            }
                            else
                            {
                                //修改支付密码成功返回上个界面
                                [self.navigationController popViewControllerAnimated:YES];
                                [self.view.window makeToast:@"修改成功" duration:2.0];
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
