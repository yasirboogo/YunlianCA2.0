//
//  AdViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}


@end

@implementation AdViewController

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
    if (!self.isURL) {
        if (self.explain==nil || [self.explain isEqualToString:@""]){
            self.title=@"广告详情";
        }else{
            self.title=self.explain;
        }
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
    NSURL *url;
    if (self.isURL) {
        url = [NSURL URLWithString:self.explain];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@share/loadAd.api?id=%@",HOST,self.adId]];
    }
    //创建并加载远程网页
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.isURL) {
        NSString * string2 = [webView  stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title=string2;
    }
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
