//
//  MyCollectionViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/15.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyCollectionViewController.h"

#import "CollectionArticleVC.h"
#import "CollectionGoodsVC.h"
#import "CollectionStoreVC.h"

@interface MyCollectionViewController ()
{
    UIView *_lineView;
    UIView *_topView;
    
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;



@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBtnArray=[NSMutableArray array];
    
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
    self.title=@"我的收藏";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
//    UIButton *editBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
//    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [editBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:editBtn];
//    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createSubviews
{
    _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
    [self.view addSubview:_topView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, _topView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [_topView addSubview:lineView];
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"话题",@"商品",@"店铺", nil];
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/3.0;
    CGFloat lineWidth=WZ(30);
    
    for (NSInteger i=0; i<3; i++)
    {
        UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+btnWidth*i, 0, btnWidth, _topView.height)];
        topBtn.tag=i;
        topBtn.titleLabel.font=FONT(17, 15);
        [topBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:topBtn];
        
        [self.topBtnArray addObject:topBtn];
        
        if (i==0)
        {
            [topBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        }
    }
    
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(leftMargin+(btnWidth-lineWidth)/2.0, _topView.bottom-WZ(10), lineWidth, 1)];
    _lineView.backgroundColor=COLOR_RED;
    [_topView addSubview:_lineView];
    
    CollectionArticleVC *articleVC=[[CollectionArticleVC alloc]init];
    [self addChildViewController:articleVC];
    
    CollectionGoodsVC *goodsVC=[[CollectionGoodsVC alloc]init];
    [self addChildViewController:goodsVC];
    
    CollectionStoreVC *storeVC=[[CollectionStoreVC alloc]init];
    [self addChildViewController:storeVC];
    
    //取出子控制器
    UIViewController * vc = self.childViewControllers[0];
    vc.view.x = 0;
    vc.view.y = _topView.bottom;
    vc.view.height = SCREEN_HEIGHT-_topView.height-64;
    [self.view addSubview:vc.view];
    
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

////编辑
//-(void)editBtnClick
//{
//    
//    
//    
//}
//

//话题 商品 店铺界面切换
-(void)topBtnClick:(UIButton*)button
{
    //取出子控制器
    UIViewController * vc = self.childViewControllers[button.tag];
    vc.view.x = 0;
    vc.view.y = _topView.bottom;
    vc.view.height = SCREEN_HEIGHT-_topView.height-64;
    [self.view addSubview:vc.view];
    
    CGFloat leftMargin=WZ(15);
    CGFloat btnWidth=(SCREEN_WIDTH-leftMargin*2)/3.0;
    CGFloat lineWidth=WZ(30);
    
    for (UIButton *btn in self.topBtnArray)
    {
        if (button.tag==btn.tag)
        {
            [btn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                _lineView.frame=CGRectMake(leftMargin+(btnWidth-lineWidth)/2.0+(lineWidth+(btnWidth-lineWidth))*button.tag, _topView.bottom-WZ(10), lineWidth, 1);
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
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
