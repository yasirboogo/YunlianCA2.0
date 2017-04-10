//
//  SuggestionViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/25.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()<UIScrollViewDelegate,YYTextViewDelegate>
{
    YYTextView *_textView;
}

@property(nonatomic,strong)NSString *content;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.content=@"";
    
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
    if (self.isMyselfVC==YES)
    {
        self.title=@"申请开放社区";
    }
    if (self.isSettingVC==YES)
    {
        self.title=@"意见反馈";
    }
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createSubviews
{
    UIScrollView *bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    [self.view addSubview:bgScrollView];
    
    _textView=[[YYTextView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(200))];
    _textView.placeholderFont=FONT(17, 15);
    _textView.font=FONT(17, 15);
    _textView.delegate=self;
    _textView.layer.cornerRadius=5;
    _textView.clipsToBounds=YES;
    _textView.layer.borderColor=COLOR_HEADVIEW.CGColor;
    _textView.layer.borderWidth=1.0;
    [bgScrollView addSubview:_textView];
    
    if (self.isMyselfVC==YES)
    {
        _textView.placeholderText=@"说说申请理由^_^";
    }
    if (self.isSettingVC==YES)
    {
        _textView.placeholderText=@"您的意见是我们前进的动力^_^";
    }
}

- (void)textViewDidChange:(YYTextView *)textView
{
    self.content=_textView.text;
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
-(void)rightBtnClick
{
    [_textView resignFirstResponder];
    
    if ([self.content isEqualToString:@""])
    {
        [self.view makeToast:@"说点什么吧..." duration:1.0];
    }
    else
    {
        if (self.isMyselfVC==YES)
        {
            //申请开放社区
            [HTTPManager applyAreaWithUserId:[UserInfoData getUserInfoFromArchive].userId content:self.content complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"提交申请成功" duration:1.0];
                }
                else
                {
                    [self.view makeToast:@"提交申请失败，请重试。" duration:1.0];
                }
            }];
        }
        if (self.isSettingVC==YES)
        {
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在提交..." detail:nil];
            [hud show:YES];
            //意见反馈
            [HTTPManager addSuggestionWithUserId:[UserInfoData getUserInfoFromArchive].userId content:self.content complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"反馈成功" duration:1.0];
                }
                else
                {
                    [self.view makeToast:@"提交意见反馈失败，请重试。" duration:1.0];
                }
                [hud hide:YES];
            }];
            [hud hide:YES afterDelay:20];
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
