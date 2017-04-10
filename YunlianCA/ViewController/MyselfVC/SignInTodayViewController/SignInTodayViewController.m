//
//  SignInTodayViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "SignInTodayViewController.h"

#import "FDCalendar.h"

@interface SignInTodayViewController ()

@end

@implementation SignInTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=COLOR_HEADVIEW;
    
    [self createNavigationBar];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    //获取签到日期
    [HTTPManager getSignInRecordWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        
        [hud hide:YES];
        
        NSString *result=[resultDict objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSArray *listArray=[resultDict objectForKey:@"list"];
            
            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"signIn.plist"];
            [listArray writeToFile:filePath atomically:YES];
            
            [self createCalendar];
        }
        
    }];
    [hud hide:YES afterDelay:20];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(60), WZ(10), SCREEN_WIDTH-WZ(60*2), WZ(30))];
    titleLabel.font=FONT(19,17);
    titleLabel.text=@"今日签到";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createCalendar
{
    UIScrollView *bgSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    bgSV.backgroundColor=COLOR_HEADVIEW;
    bgSV.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    [self.view addSubview:bgSV];
    
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    calendar.frame=CGRectMake(0, 0, SCREEN_WIDTH, 400);
    [bgSV addSubview:calendar];
    
//    UILabel *ruleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), calendar.bottom+WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(20))];
//    ruleLabel.text=@"签到规则";
//    ruleLabel.textColor=COLOR(146, 135, 187, 1);
//    ruleLabel.font=FONT(15,13);
//    [bgSV addSubview:ruleLabel];
//    
//    UILabel *label0=[[UILabel alloc]initWithFrame:CGRectMake(ruleLabel.left, ruleLabel.bottom+WZ(10), ruleLabel.width, WZ(20))];
//    label0.text=@"签到可获得积分";
//    label0.textColor=COLOR_LIGHTGRAY;
//    label0.font=FONT(15,13);
//    [bgSV addSubview:label0];
//    
//    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(ruleLabel.left, label0.bottom+WZ(5), ruleLabel.width, WZ(20))];
//    label1.text=@"连续签到有机会获得优惠券";
//    label1.textColor=COLOR_LIGHTGRAY;
//    label1.font=FONT(15,13);
//    [bgSV addSubview:label1];
    
}

















#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
