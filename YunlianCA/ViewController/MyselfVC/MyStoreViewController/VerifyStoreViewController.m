//
//  VerifyStoreViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/9/26.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "VerifyStoreViewController.h"

#import "MyStoreViewController.h"
#import "RegisterStoreViewController.h"

@interface VerifyStoreViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *mobileTF;
@property(nonatomic,strong)NSString *mobile;

@end

@implementation VerifyStoreViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
    
    self.mobile=[UserInfoData getUserInfoFromArchive].username;
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
    self.title=@"商户注册";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createSubviews
{
    self.view.backgroundColor=COLOR_HEADVIEW;
    
    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(20), SCREEN_WIDTH, WZ(50))];
    smallView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:smallView];
    
    UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), smallView.height)];
    mobileTF.delegate=self;
    mobileTF.text=self.mobile;
//    mobileTF.placeholder=@"验证手机号";
    mobileTF.textAlignment=NSTextAlignmentCenter;
    mobileTF.font=FONT(17, 15);
    mobileTF.userInteractionEnabled=NO;
    [smallView addSubview:mobileTF];
    self.mobileTF=mobileTF;
    
    UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), smallView.bottom+WZ(50), SCREEN_WIDTH-WZ(15*2), WZ(50))];
    submitBtn.backgroundColor=COLOR(254, 167, 173, 1);
    submitBtn.layer.cornerRadius=5;
    submitBtn.clipsToBounds=YES;
    submitBtn.titleLabel.font=FONT(17, 15);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mobile=textField.text;
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交手机号验证
-(void)submitBtnClick
{
    [self.mobileTF resignFirstResponder];
    
    if ([self.mobile isEqualToString:@""])
    {
        [self.view makeToast:@"请输入手机号" duration:2.0];
    }
    else
    {
        if ([ViewController validateMobile:self.mobileTF.text]==NO)
        {
            [self.view makeToast:@"请输入正确的手机号" duration:2.0];
        }
        else
        {
            //提交验证商户
            [HTTPManager ifMerchantExistWithUserId:[UserInfoData getUserInfoFromArchive].userId phone:self.mobile complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.view.window makeToast:@"验证成功" duration:2.0];
                    
                    NSInteger state=[[resultDict objectForKey:@"state"] integerValue];
                    if (state==0)
                    {
                        //state:0 无商户 跳去商户注册界面
                        RegisterStoreViewController *vc=[[RegisterStoreViewController alloc]init];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if (state==1)
                    {
                        //state:1 有商户 跳转我的店铺列表界面
                        User *user=[UserInfoData getUserInfoFromArchive];
                        user.merchantId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"merchantId"]];
                        [UserInfoData saveUserInfoWithUser:user];
                        
                        MyStoreViewController *vc=[[MyStoreViewController alloc]init];
                        vc.hidesBottomBarWhenPushed=YES;
                        //                    vc.isVerifyStoreVC=YES;
                        [self.navigationController pushViewController:vc animated:YES];
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
