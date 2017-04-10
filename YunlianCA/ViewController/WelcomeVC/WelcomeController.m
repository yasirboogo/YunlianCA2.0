//
//  WelcomeController.m
//  YunlianCA
//
//  Created by Wang on 16/9/3.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "WelcomeController.h"
#import "LoginViewController.h"

@interface WelcomeController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *imgArray;



@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_WHITE;
    
    _imgArray = @[@"Welcom1", @"Welcom2", @"Welcom3", @"Welcom4"];
    
    
    
    _scrollView = [[UIScrollView alloc] init];
    CGFloat scrollViewW = SCREEN_WIDTH;
    CGFloat scrollViewH = SCREEN_HEIGHT;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    _scrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.imgArray.count, SCREEN_HEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    
    [self.imgArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         UIImageView *imgView = [[UIImageView alloc] init];
         
         imgView.userInteractionEnabled = YES;
         CGFloat imgViewX = idx * SCREEN_WIDTH;
         CGFloat imgViewY = 0;
         CGFloat imgViewW = SCREEN_WIDTH;
         CGFloat imgViewH = SCREEN_HEIGHT;
         imgView.frame = CGRectMake(imgViewX, imgViewY, imgViewW, imgViewH);
         
         imgView.image = [UIImage imageNamed:self.imgArray[idx]];
         
         [_scrollView addSubview:imgView];
         
         if (idx == self.imgArray.count - 1)
         {
             
             UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
             [btn setTitle:@"立即体验" forState:UIControlStateNormal];
             btn.titleLabel.textColor =[UIColor whiteColor];
             
             CGFloat btnW = 80;
             CGFloat btnH = 20;
             CGFloat btnX = SCREEN_WIDTH/2 - btnW/2;
             CGFloat btnY = SCREEN_HEIGHT * 0.93;
             
             btn.backgroundColor =[UIColor clearColor];
             btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
             [imgView addSubview:btn];
             
             
             UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
             tapRecognizer.numberOfTapsRequired = 1;
             [btn addGestureRecognizer:tapRecognizer];

             
         }
         
     }];
    
    
   

    
    _pageControl = [[UIPageControl alloc] init];
    CGFloat pageW = 80;
    CGFloat pageH = 20;
    CGFloat pageX = SCREEN_WIDTH/2 - pageW/2;
    CGFloat pageY = SCREEN_HEIGHT * 0.93;
  
    _pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    _pageControl.numberOfPages = self.imgArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.hidden=NO;
        [self.view addSubview:_pageControl];

  
    

  
}

- (void)tapAction:(UITapGestureRecognizer*)tapGesture
{
    /* 进入登录页面 */
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    /* 设置导航条透明 */
    [nav.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}



#pragma - mark 滚动视图代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
        
    if (currentPage==self.imgArray.count-1) {
        _pageControl.hidden=YES;
    }else
    {
    
        _pageControl.hidden=NO;
        self.pageControl.currentPage = currentPage;

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
