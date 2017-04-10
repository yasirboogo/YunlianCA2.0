//
//  AllMembersViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AllMembersViewController.h"

#import "UserInfoViewController.h"

@interface AllMembersViewController ()
{
    UIScrollView *_scrollView;
    
    
}

@property(nonatomic,assign)NSInteger memberCount;

@end

@implementation AllMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.memberCount=[self.memberArray count];
    
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
    self.title=@"全部成员";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createSubviews
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:_scrollView];
    
    CGFloat space=WZ(20);
    CGFloat btnWidth=(SCREEN_WIDTH-space*6)/5;
    
    if (self.memberCount%5>0)
    {
        NSInteger hangShu=self.memberCount/5+1;
        _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, WZ(15)+(btnWidth+WZ(40))*hangShu+WZ(5));
    }
    else
    {
        NSInteger hangShu=self.memberCount/5;
        _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, WZ(15)+(btnWidth+WZ(40))*hangShu+WZ(5));
    }
    
    for (NSInteger i=0; i<self.memberCount; i++)
    {
        NSDictionary *memberDict=self.memberArray[i];
        NSString *nickname=[memberDict objectForKey:@"nickname"];
        NSString *headimg=[memberDict objectForKey:@"headimg"];
        
        UIButton *memberHeadBtn=[[UIButton alloc]initWithFrame:CGRectMake(space+(btnWidth+space)*(i%5), WZ(15)+(btnWidth+WZ(40))*(i/5), btnWidth, btnWidth)];
        memberHeadBtn.tag=i;
        [memberHeadBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        memberHeadBtn.clipsToBounds=YES;
        memberHeadBtn.layer.cornerRadius=btnWidth/2.0;
        [memberHeadBtn addTarget:self action:@selector(memberHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:memberHeadBtn];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(memberHeadBtn.left-WZ(8), memberHeadBtn.bottom+WZ(5), btnWidth+WZ(8*2), WZ(25))];
        nameLabel.text=nickname;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.font=FONT(13,11);
        //            nameLabel.backgroundColor=COLOR_CYAN;
        [_scrollView addSubview:nameLabel];
    }
    
    
    
    
    
    
}




#pragma mark ===点击按钮的方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//成员员头像点击
-(void)memberHeadBtn:(UIButton*)button
{
    NSDictionary *memberDict=self.memberArray[button.tag];
    NSString *userId=[NSString stringWithFormat:@"%@",[memberDict objectForKey:@"id"]];
    
    UserInfoViewController *vc=[[UserInfoViewController alloc]init];
    vc.userId=userId;
    [self.navigationController pushViewController:vc animated:YES];
    
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
