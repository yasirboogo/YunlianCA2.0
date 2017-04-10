//
//  RedEnvelopeSquareViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/12/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RedEnvelopeSquareViewController.h"

#import "ScanViewController.h"
#import "RedEnvelopeOpenViewController.h"
#import "RedEnvelopeReceivedViewController.h"
#import "RedEnvelopeSendViewController.h"
#import "RedEnvelopeRecordsViewController.h"
#import "JPUSHService.h"
#import <SVProgressHUD.h>
@interface RedEnvelopeSquareViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSTimer *_timer;
    UITextField * _textField;
   
}

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSDictionary *redDict;

@end

@implementation RedEnvelopeSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArray=[NSMutableArray array];
    [self createTopView];
    [self createTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [SVProgressHUD showWithStatus:@"加载中..."];
   
}

-(void)getHongbao
{
    [self getRedEnvelopeList];
}

//获取红包列表
-(void)getRedEnvelopeList
{
    [HTTPManager getRedEnvelopeListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"100" complete:^(NSMutableArray *listArray) {
        if (listArray!=nil) {
            self.listArray=listArray;
            
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //去掉导航条下边的shadowImage，就可以正常显示了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    
    [self getRedEnvelopeList];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getHongbao) userInfo:nil repeats:YES];
    
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"yes",@"isHongbaoSquareVC", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hongbao" object:nil userInfo:dict];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    _timer=nil;
    [SVProgressHUD dismiss];
    //退出红包广场开启推送
    //系统推送
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    //极光推送
//    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    
//    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"no",@"isHongbaoSquareVC", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hongbao" object:nil userInfo:dict];
    
}

-(void)createTopView
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(160))];
    //    topView.backgroundColor=COLOR_CYAN;
    [self.view addSubview:topView];
    self.topView=topView;
    
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topView.width, topView.height)];
    bgIV.image=IMAGE(@"beijing_hongbao");
    [topView addSubview:bgIV];
    
    UIImageView *backIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), 20+WZ(5), WZ(14), WZ(25))];
    backIV.image=IMAGE(@"fanhui_bai");
    [topView addSubview:backIV];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(5), backIV.top, WZ(60), backIV.height)];
//    backBtn.backgroundColor=COLOR_CYAN;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(backBtn.right+WZ(5), backIV.top, SCREEN_WIDTH-WZ(70*2), backIV.height)];
    titleLabel.text=@"外快(红包)广场";
    titleLabel.textColor=COLOR_WHITE;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(19, 17);
    [topView addSubview:titleLabel];
    
    UIButton *mingxiBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(10+50), titleLabel.top, WZ(50), titleLabel.height)];
    [mingxiBtn setTitle:@"明细" forState:UIControlStateNormal];
    [mingxiBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    mingxiBtn.titleLabel.font=FONT(17, 15);
    [mingxiBtn addTarget:self action:@selector(mingxiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:mingxiBtn];
    
    NSArray *threeArray=[[NSArray alloc]initWithObjects:IMAGE(@"shequ_saoyisao"),IMAGE(@"fahongbao"),IMAGE(@"shequ_fukuanma"), nil];
    NSArray *titleArray=@[@"扫一扫",@"发红包",@"收红包"];
    
    CGFloat width=WZ(40);
    CGFloat height=width;
    CGFloat leftSpace=WZ(50);
    CGFloat space=(SCREEN_WIDTH-leftSpace*2-width*3)/2.0;
    
    for (NSInteger i=0; i<threeArray.count; i++)
    {
        UIButton *threeBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftSpace+(width+space)*(i%3), titleLabel.bottom+WZ(25), width, height)];
        //        threeBtn.backgroundColor=COLOR_CYAN;
        threeBtn.tag=i;
        [threeBtn setBackgroundImage:threeArray[i] forState:UIControlStateNormal];
        [threeBtn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:threeBtn];
//        self.threeBtn=threeBtn;
        
        UILabel *threeLabel=[UILabel labelTextCenterWithFrame:CGRectMake(threeBtn.left-WZ(10), threeBtn.bottom+WZ(5), threeBtn.width+WZ(10*2), WZ(25)) text:titleArray[i] textColor:COLOR_WHITE font:FONT(13,11) textAlignment:NSTextAlignmentCenter backColor:COLOR_CLEAR];
        [topView addSubview:threeLabel];
    }
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.topView.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=COLOR_HEADVIEW;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
//    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
//    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}





#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    NSDictionary *listDict=self.listArray[indexPath.row];
    NSString *imgUrlString=[listDict objectForKey:@"userImg"];
    NSString *nickname=[listDict objectForKey:@"nickName"];
    NSString *theme=[listDict objectForKey:@"theme"]==nil?@"":[[listDict objectForKey:@"theme"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *time=[listDict objectForKey:@"time"];
    NSInteger isAdmin=[[listDict objectForKey:@"isAdmin"] integerValue];//1、后台 0、用户
    NSInteger isOwn=[[listDict objectForKey:@"isOwn"] integerValue];//1、自己发的 0、别人发的
    NSInteger status=[[listDict objectForKey:@"status"] integerValue];
    NSString *statusString=@"";
    
    if (status==0)
    {
        statusString=@"未领取";
    }
    if (status==1)
    {
        statusString=@"已领取";
    }
    if (status==2)
    {
        statusString=@"已过期";
    }
    if (status==3)
    {
        statusString=@"已领完";
    }
    
    UIImage *hongbaoImage;
    if (isOwn==1)
    {
        hongbaoImage=IMAGE(@"hongbao_you_huang");
    }
    if (isOwn==0)
    {
        hongbaoImage=IMAGE(@"hongbao_zuo_huang");
        
//        if (status==0 || status==1)
//        {
//            hongbaoImage=IMAGE(@"hongbao_zuo_huang");
//        }
//        if (status==2 || status==3)
//        {
//            hongbaoImage=IMAGE(@"hongbao_zuo_hui");
//        }
    }
    
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[listDict objectForKey:@"userImg"]]];
    }
    
    UIButton *headBtn=[[UIButton alloc]init];
    headBtn.layer.cornerRadius=headBtn.width/2.0;
    headBtn.clipsToBounds=YES;
    [cell.contentView addSubview:headBtn];
    if (isAdmin==0)
    {
        [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    }
    if (isAdmin==1)
    {
        [headBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
    }
    
    UILabel *headLabel=[[UILabel alloc]init];
    headLabel.text=nickname;
    headLabel.textAlignment=NSTextAlignmentCenter;
    headLabel.font=FONT(13, 11);
//    headLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:headLabel];
    
    UIView *cellView=[[UIView alloc]init];
    cellView.backgroundColor=COLOR_HEADVIEW;
    [cell.contentView addSubview:cellView];
    
    if (isOwn==1)//自己发的
    {
        headBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(20+45), WZ(20), WZ(45), WZ(45));
        headLabel.frame=CGRectMake(headBtn.left-WZ(17), headBtn.bottom+WZ(3), headBtn.width+WZ(17*2), WZ(20));
        cellView.frame=CGRectMake(SCREEN_WIDTH-WZ(20+45+20+5+230), WZ(10), WZ(230), WZ(90));
    }
    if (isOwn==0)//别人发的
    {
        headBtn.frame=CGRectMake(WZ(20), WZ(20), WZ(45), WZ(45));
        headLabel.frame=CGRectMake(headBtn.left-WZ(17), headBtn.bottom+WZ(3), headBtn.width+WZ(17*2), WZ(20));
        cellView.frame=CGRectMake(headLabel.right+WZ(5), WZ(10), WZ(230), WZ(90));
    }
    
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cellView.width, cellView.height)];
    bgIV.image=hongbaoImage;
    [cellView addSubview:bgIV];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(55), WZ(15), WZ(160), WZ(20))];
    titleLabel.text=theme;
    titleLabel.textColor=COLOR_WHITE;
    titleLabel.font=FONT(15, 13);
//    titleLabel.backgroundColor=COLOR_CYAN;
    [cellView addSubview:titleLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+WZ(3), titleLabel.width, WZ(17))];
    timeLabel.text=time;
    timeLabel.textColor=COLOR_WHITE;
    timeLabel.font=FONT(13, 11);
//    timeLabel.backgroundColor=COLOR_CYAN;
    [cellView addSubview:timeLabel];
    
    UILabel *ifGetLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(13), cellView.height-WZ(18), WZ(100), WZ(18))];
    ifGetLabel.text=statusString;
    ifGetLabel.textColor=COLOR_LIGHTGRAY;
    ifGetLabel.font=FONT(13, 11);
//    ifGetLabel.backgroundColor=COLOR_CYAN;
    [cellView addSubview:ifGetLabel];
    
    UIButton *hongbaoBtn=[[UIButton alloc]initWithFrame:cellView.frame];
    hongbaoBtn.tag=indexPath.row;
    [hongbaoBtn addTarget:self action:@selector(hongbaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:hongbaoBtn];
    
    
    
    
    
    
    
    
    
    
    cell.backgroundColor=COLOR_HEADVIEW;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(110);
}

#pragma mark ===按钮点击方法===
//返回
-(void)backBtnClick
{
    //点击推送alertView进入此界面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"hongbao"] isEqualToString:@"hongbao"])
    {
        [self.tabBarController.tabBar setHidden:YES];
        
        //将标示条件置空，以防通过正常情况下导航栏进入该页面时无法返回上一级页面
        NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@"" forKey:@"hongbao"];
        [pushJudge synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//红包明细
-(void)mingxiBtnClick
{
    RedEnvelopeRecordsViewController *vc=[[RedEnvelopeRecordsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//扫一扫 发红包 收红包三个按钮
-(void)threeBtnClick:(UIButton*)button
{
    if (button.tag==0)
    {
        //扫描界面
        ScanViewController *vc=[[ScanViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag==1)
    {
        //发红包
        RedEnvelopeSendViewController *vc=[[RedEnvelopeSendViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag==2)
    {
        //收红包
        RedEnvelopeReceivedViewController *vc=[[RedEnvelopeReceivedViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//领取红包
-(void)hongbaoBtnClick:(UIButton*)button
{
    self.redDict=self.listArray[button.tag];
    NSInteger status=[[self.redDict objectForKey:@"status"] integerValue];
    NSInteger isOwn=[[self.redDict objectForKey:@"isOwn"] integerValue];//1、自己发的 0、别人发的
    if (isOwn==1)
    {
        //自己发的红包直接跳转红包详情界面
        RedEnvelopeOpenViewController *vc=[[RedEnvelopeOpenViewController alloc]init];
        vc.redDict=self.redDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (isOwn==0)
    {
        if (status==0)
        {
            [self createOpenHongbaoView];
        }
        else
        {
            //已领取 已过期 已领完 的红包直接跳转详情界面
            RedEnvelopeOpenViewController *vc=[[RedEnvelopeOpenViewController alloc]init];
            vc.redDict=self.redDict;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
//    if (status==0)
//    {
//        statusString=@"未领取";
//    }
//    if (status==1)
//    {
//        statusString=@"已领取";
//    }
//    if (status==2)
//    {
//        statusString=@"已过期";
//    }
//    if (status==3)
//    {
//        statusString=@"已领完";
//    }
    
    
    
}

//领取红包弹出界面
-(void)createOpenHongbaoView
{
    NSString *imgUrlString=[self.redDict objectForKey:@"userImg"];
    NSString *nickname=[self.redDict objectForKey:@"nickName"];
    NSString *theme=[[self.redDict objectForKey:@"theme"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger isAdmin=[[self.redDict objectForKey:@"isAdmin"] integerValue];
//    NSInteger status=[[self.redDict objectForKey:@"status"] integerValue];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view.window addSubview:bgView];
    self.bgView=bgView;
    
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(80), WZ(100), WZ(40), WZ(40))];
    [closeBtn setBackgroundImage:IMAGE(@"hongbao_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeHongbaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    UIImageView *hongbaoIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(50), WZ(120), SCREEN_WIDTH-WZ(50*2), SCREEN_HEIGHT-WZ(120+150))];
    hongbaoIV.image=IMAGE(@"hongbao_open");
    [bgView addSubview:hongbaoIV];
    
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[self.redDict objectForKey:@"userImg"]]];
    }
    UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake((hongbaoIV.width-WZ(50))/2.0, WZ(130), WZ(50), WZ(50))];
   
    [hongbaoIV addSubview:headBtn];
    NSInteger onetomanyTypeId=[self.redDict[@"onetomanyTypeId"] integerValue];
    NSString *command = self.redDict[@"command"];
    
    if (onetomanyTypeId==3) {
        headBtn.frame = CGRectMake((hongbaoIV.width-WZ(100))/2.0, WZ(130), WZ(100), WZ(30));
        [headBtn setTitleColor:COLOR(255, 231, 192, 1) forState:UIControlStateNormal];
        headBtn.titleLabel.font = FONT(16, 14);
        [headBtn setTitle:@"口令红包" forState:UIControlStateNormal];
        hongbaoIV.userInteractionEnabled =YES;
    }else{
        headBtn.frame = CGRectMake((hongbaoIV.width-WZ(50))/2.0, WZ(130), WZ(50), WZ(50));
        headBtn.layer.cornerRadius=headBtn.width/2.0;
        headBtn.clipsToBounds=YES;
        if (isAdmin==0)
        {
            [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        }
        if (isAdmin==1)
        {
            [headBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
        }
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(headBtn.left-WZ(40), headBtn.bottom+WZ(3), headBtn.width+WZ(40*2), WZ(25))];
        headLabel.text=nickname;
        headLabel.textColor=COLOR(255, 231, 192, 1);
        headLabel.textAlignment=NSTextAlignmentCenter;
        headLabel.font=FONT(15, 13);
        //    headLabel.backgroundColor=COLOR_CYAN;
        [hongbaoIV addSubview:headLabel];
    }
    
    
    UILabel *titleLabel=[[UILabel alloc]init];
   if (onetomanyTypeId==3) {
       titleLabel.frame = CGRectMake(WZ(10), headBtn.bottom-WZ(10), hongbaoIV.width-WZ(10*2), WZ(50));
   }else{
       titleLabel.frame = CGRectMake(WZ(10), headBtn.bottom+WZ(30), hongbaoIV.width-WZ(10*2), WZ(50));
   }
    if (onetomanyTypeId==3) {
        titleLabel.text=command;
    }else{
        titleLabel.text=theme;
    }
    
    titleLabel.textColor=COLOR(255, 231, 192, 1);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(17, 15);
    titleLabel.numberOfLines=2;
    //    titleLabel.backgroundColor=COLOR_CYAN;
    [hongbaoIV addSubview:titleLabel];
    if (onetomanyTypeId==3) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(WZ(20), CGRectGetMaxY(titleLabel.frame)+WZ(10), hongbaoIV.width-WZ(20)*2, WZ(40))];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _textField.placeholder = @"输入红包口令";
        _textField.inputAccessoryView = [self creatDoneView];
        
        [hongbaoIV addSubview:_textField];
    }
    UIButton *openBtn=[[UIButton alloc]initWithFrame:CGRectMake(hongbaoIV.left+WZ(40), hongbaoIV.bottom-WZ(95), hongbaoIV.width-WZ(40*2), WZ(55))];
    [openBtn setBackgroundImage:IMAGE(@"hongbao_chaikai") forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openBtn];
    
}
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    CGRect textRect = [_textField convertRect:_textField.bounds toView:self.bgView];
    NSLog(@"键盘高度===%f",deltaY);
   
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.bgView.frame=CGRectMake(0, deltaY-CGRectGetMaxY(textRect), SCREEN_WIDTH,SCREEN_HEIGHT);
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
         self.bgView.frame=CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)topUpTFDonBtnClicked{
    [_textField resignFirstResponder];
}

//关闭红包
-(void)closeHongbaoBtnClick
{
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
    }
}

//打开红包
-(void)openBtnClick
{
    NSString *command = self.redDict[@"command"];
    
    if ([command length]>0) {
        if (![_textField.text isEqualToString:command]) {
            [self.bgView makeToast:@"红包口令错误" duration:2];
            return;
        }
    }
    NSString *isAdmin=[self.redDict objectForKey:@"isAdmin"];//1、后台 0、用户
    [HTTPManager openRedEnvelopeWithUserId:[UserInfoData getUserInfoFromArchive].userId packetId:[self.redDict objectForKey:@"id"] type:isAdmin complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            if (self.bgView)
            {
                [self.bgView removeFromSuperview];
                RedEnvelopeOpenViewController *vc=[[RedEnvelopeOpenViewController alloc]init];
                vc.redDict=self.redDict;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else
        {
            [self.bgView removeFromSuperview];
            NSInteger msg=[[resultDict objectForKey:@"msg"] integerValue];//msg 2已过期 3已领完
            if (msg==2 || msg==3||msg==1)
            {
                if (self.bgView)
                {
                    
                    RedEnvelopeOpenViewController *vc=[[RedEnvelopeOpenViewController alloc]init];
                    vc.redDict=self.redDict;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (msg==4){
                [self.view makeToast:@"性别不符合" duration:2];
            }else if (msg==5){
                [self.view makeToast:@"年龄不符合" duration:2];
            }
        }
    }];
    
    
    
    
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
