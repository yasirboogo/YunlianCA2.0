//
//  TiXianOkViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/8.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "TiXianOkViewController.h"

#import "MemberCenterViewController.h"

@interface TiXianOkViewController ()
{
    UIScrollView *_bgScrollView;
    
    
}


@end

@implementation TiXianOkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createSubviews];
    
    
    
    
}

-(void)createNavigationBar
{
    self.title=@"佣金提现";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [leftBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createSubviews
{
    _bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    _bgScrollView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_bgScrollView];
    
    UIImageView *okIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(50))/2.0, WZ(35), WZ(50), WZ(50))];
    okIV.image=IMAGE(@"wode_bangdingchenggong");
    [_bgScrollView addSubview:okIV];
    
    UILabel *okLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), okIV.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    okLabel.text=@"提现成功";
    okLabel.textAlignment=NSTextAlignmentCenter;
    //    okLabel.backgroundColor=COLOR_CYAN;
    [_bgScrollView addSubview:okLabel];
}









#pragma mark ===buttonClick===
//左返回按钮
-(void)leftBtnClick
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[MemberCenterViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
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
