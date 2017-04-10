//
//  EditNicknameVC.m
//  YunlianCA
//
//  Created by QinJun on 16/6/15.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "EditNicknameVC.h"

@interface EditNicknameVC ()<YYTextViewDelegate>


@property(nonatomic,strong)YYTextView *nicknameTV;
@property(nonatomic,strong)NSString *content;


@end

@implementation EditNicknameVC

- (void)viewDidLoad {
//    [super viewDidLoad];
    
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
    if (self.isNickname==YES)
    {
        self.title=@"设置昵称";
    }
    if (self.isSign==YES)
    {
        self.title=@"设置签名";
    }
    if (self.isAge) {
        self.title = @"设置年龄";
    }
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createSubviews
{
    self.view.backgroundColor=COLOR_HEADVIEW;
    
    UIView *aView=[[UIView alloc]init];
    aView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:aView];
    if (self.isNickname==YES||self.isAge)
    {
        aView.frame=CGRectMake(0, WZ(20), SCREEN_WIDTH, WZ(50));
    }
    if (self.isSign==YES)
    {
        aView.frame=CGRectMake(0, WZ(20), SCREEN_WIDTH, WZ(150));
    }
    
    
    YYTextView *nicknameTV=[[YYTextView alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), aView.height)];
    nicknameTV.font=FONT(17, 15);
    nicknameTV.delegate=self;
    [aView addSubview:nicknameTV];
    self.nicknameTV=nicknameTV;
    
    if (self.isNickname==YES)
    {
        if (self.nickname==nil)
        {
            self.nickname=@"";
        }
        nicknameTV.placeholderText=@"请输入昵称";
        nicknameTV.text=self.nickname;
        
        NSString *detailString=@"昵称由2-10个字符组成，支持汉字/英文/数字";
        UILabel *detailLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), aView.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(50)) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50)) text:detailString textColor:COLOR_LIGHTGRAY bgColor:COLOR_CLEAR font:FONT(13,11) textAlignment:NSTextAlignmentLeft];
        [self.view addSubview:detailLabel];
    }
    if (self.isSign==YES)
    {
        if (self.sign==nil)
        {
            self.sign=@"";
        }
        
        nicknameTV.placeholderText=@"设置签名";
        nicknameTV.text=self.sign;
    }
    if (self.isAge) {
        
        if ([self.age isEqualToString:@"(null)"]||self.age==nil) {
            nicknameTV.placeholderText=@"请输入年龄";
        }else{
            nicknameTV.text=self.age;
        }
        
        nicknameTV.keyboardType = UIKeyboardTypeNumberPad;
        nicknameTV.inputAccessoryView = [self creatDoneView];
        nicknameTV.frame = CGRectMake(WZ(15), 10, SCREEN_WIDTH-WZ(15*2), aView.height-20);
        
    }
    
    
    
    
}

-(void)textViewDidChange:(YYTextView *)textView
{
    self.content=textView.text;
    NSLog(@"签名:%@",self.content);
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存
-(void)rightBtnClick
{
    NSLog(@"保存");
    [self.view endEditing:YES];
    
    NSLog(@"点击保存后的签名:%@",self.content);
    
    NSMutableDictionary *dict;
    if (self.isNickname==YES)
    {
        if (self.nicknameTV.text.length>=2 && self.nicknameTV.text.length<=10)
        {
            dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.content,@"nickname", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"content" object:nil userInfo:dict];
        }
        else
        {
            [self.view makeToast:@"请输入符合规则的昵称" duration:2.0];
        }
    }
    if (self.isSign==YES)
    {
        dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.content,@"sign", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"content" object:nil userInfo:dict];
    }
    if (self.isAge) {
        dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.content,@"age", nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"content" object:nil userInfo:dict];
        
    }
    
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
