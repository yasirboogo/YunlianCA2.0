//
//  SettingDetailViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "SettingDetailViewController.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"


@interface SettingDetailViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}

@end

@implementation SettingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createWebView];
    
    _hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [_hud show:YES];
    [_hud hide:YES afterDelay:20];
    
    
    
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
//    if (self.isHotLines==YES)
//    {
//        self.title=@"客服热线";
//    }
    if (self.isService==YES)
    {
        self.title=@"服务条款";
    }
    if (self.isHelp==YES)
    {
        self.title=@"使用帮助";
    }
    if (self.isAboutUs==YES)
    {
        self.title=@"关于我们";
    }
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createWebView
{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _webView.delegate=self;
    _webView.opaque=NO;
    _webView.scalesPageToFit=YES;
    _webView.backgroundColor=COLOR_WHITE;
    //    [_webView loadHTMLString:[NSString stringWithFormat:@"%@share/loadAd.api?id=%@",HOST,self.adId] baseURL:nil];
    [self.view addSubview:_webView];
    
    //云服务器地址
//#define HOST @"http://app.ylsqlm.com/shequ/app/"
//#define HOSTIMAGE @"http://app.ylsqlm.com:8080/"
    
    //创建并加载远程网页
    NSString *url;
//    if (self.isHotLines==YES)
//    {
//        url=[NSString stringWithFormat:@"%@user/cusPhone.api",HOST];
////        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@user/cusPhone.api",HOST]];
//    }
    if (self.isService==YES)
    {
        url=[NSString stringWithFormat:@"%@user/sysService.api",HOST];
//        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@user/sysService.api",HOST]];
    }
    if (self.isHelp==YES)
    {
        url=[NSString stringWithFormat:@"%@user/sysHelp.api",HOST];
//        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@user/sysHelp.api",HOST]];
    }
    if (self.isAboutUs==YES)
    {
        url=[NSString stringWithFormat:@"%@user/aboutUs.api",HOST];
//        url= [NSURL URLWithString:[NSString stringWithFormat:@"%@user/aboutUs.api",HOST]];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSString *string;
//            if (self.isHotLines==YES)
//            {
//                string=[responseObject objectForKey:@"cusPhone"];
//            }
            if (self.isService==YES)
            {
                string=[responseObject objectForKey:@"service"];
            }
            if (self.isHelp==YES)
            {
                string=[responseObject objectForKey:@"help"];
            }
            if (self.isAboutUs==YES)
            {
                string=[responseObject objectForKey:@"aboutUs"];
            }
            
            [_webView loadHTMLString:string baseURL:nil];
        }
        else
        {
            [_hud hide:YES];
            NSString *msg=[responseObject objectForKey:@"msg"];
            [self.view makeToast:msg duration:2.0];
        }
        
        NSLog(@"网页数据===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取网页数据失败====%@",error.localizedDescription);
    }];
    
//    if (self.isHotLines==YES)
//    {
//        url= [NSURL URLWithString:@"http://192.168.1.228/shequ/app/user/cusPhone.api"];
//    }
//    if (self.isService==YES)
//    {
//        url= [NSURL URLWithString:@"http://192.168.1.228/shequ/app/user/sysService.api"];
//    }
//    if (self.isHelp==YES)
//    {
//        url= [NSURL URLWithString:@"http://192.168.1.228/shequ/app/user/sysHelp.api"];
//    }
//    if (self.isAboutUs==YES)
//    {
//        url= [NSURL URLWithString:@"http://192.168.1.228/shequ/app/user/aboutUs.api"];
//    }
    
    
//    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_hud hide:YES];
    [self.view makeToast:@"加载失败，请重试。" duration:2.0];
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
