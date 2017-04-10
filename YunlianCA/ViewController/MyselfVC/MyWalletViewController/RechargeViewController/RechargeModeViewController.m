//
//  RechargeModeViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/9/5.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RechargeModeViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "MyWalletViewController.h"
#import "ScanDetailViewController.h"

@interface RechargeModeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)NSMutableArray *modeNameArray;
@property(nonatomic,strong)NSMutableArray *modeDescArray;
@property(nonatomic,strong)NSMutableArray *modeIdArray;
@property(nonatomic,assign)NSInteger cellRow;
@property(nonatomic,strong)NSMutableArray *cellViewArray;
@property(nonatomic,strong)NSMutableArray *checkIVArray;
@property(nonatomic,strong)NSString *chooseModeId;
@property(nonatomic,strong)NSMutableArray *heightArray;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)UITextField *passwordTF;

@end

@implementation RechargeModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellRow=0;
    self.cellViewArray=[NSMutableArray array];
    self.checkIVArray=[NSMutableArray array];
    self.heightArray=[NSMutableArray array];
    
    [self createNavigationBar];
    
    
    
    
}

-(void)createCellView
{
    for (NSInteger i=0; i<self.modeNameArray.count; i++)
    {
        CGSize nameSize=[ViewController sizeWithString:self.modeNameArray[i] font:FONT(17, 15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*3+20), WZ(40))];
        CGSize descSize=[ViewController sizeWithString:self.modeDescArray[i] font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*3+20), WZ(150))];
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(5*3)+nameSize.height+descSize.height)];
        cellView.backgroundColor=COLOR_WHITE;
        [self.cellViewArray addObject:cellView];
        [self.heightArray addObject:[NSString stringWithFormat:@"%f",cellView.height]];
        
        UILabel *modeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(5), SCREEN_WIDTH-WZ(15*3+20), nameSize.height)];
        modeNameLabel.text=self.modeNameArray[i];
        modeNameLabel.textColor=COLOR_BLACK;
        modeNameLabel.font=FONT(17, 15);
        [cellView addSubview:modeNameLabel];
//        modeNameLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *modeDescLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), modeNameLabel.bottom+WZ(5), SCREEN_WIDTH-WZ(15*3+20), descSize.height)];
        modeDescLabel.text=self.modeDescArray[i];
        modeDescLabel.textColor=COLOR_LIGHTGRAY;
        modeDescLabel.font=FONT(15, 13);
        modeDescLabel.numberOfLines=0;
        [cellView addSubview:modeDescLabel];
//        modeDescLabel.backgroundColor=COLOR_CYAN;
        
        UIImageView *checkIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+20), (cellView.height-WZ(16))/2.0, WZ(20), WZ(16))];
        checkIV.image=IMAGE(@"");
        [cellView addSubview:checkIV];
        [self.checkIVArray addObject:checkIV];
    }
}

//充值模式
-(void)getRechargeMode
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在加载..." detail:nil];
    [hud show:YES];
    [HTTPManager rechargeModeWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.modeNameArray=[NSMutableArray array];
            self.modeIdArray=[NSMutableArray array];
            self.modeDescArray=[NSMutableArray array];
            
            NSArray *modeArray=[resultDict objectForKey:@"list"];
            if (modeArray.count>0)
            {
                [self.rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
                self.rightBtn.userInteractionEnabled=YES;
                
                for (NSInteger i=0; i<modeArray.count; i++)
                {
                    NSDictionary *modeDict=modeArray[i];
                    NSString *modeName=[modeDict objectForKey:@"modeName"];
                    NSString *modeId=[modeDict objectForKey:@"modeId"];
                    NSString *modeDesc=[modeDict objectForKey:@"modeDesc"];
                    [self.modeNameArray addObject:modeName];
                    [self.modeIdArray addObject:modeId];
                    [self.modeDescArray addObject:modeDesc];
                    
                    if (i==0)
                    {
                        self.chooseModeId=modeId;
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
                
                [self createCellView];
                [self createTableView];
            }
            else
            {
                
                [self.rightBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
                self.rightBtn.userInteractionEnabled=NO;
            }
        }
        else
        {
            [self.view makeToast:@"获取充值模式失败" duration:2.0];
        }
        [hud hide:YES];
    }];
    [hud hide:YES afterDelay:20];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getRechargeMode];
}

-(void)createNavigationBar
{
    self.title=@"充值模式";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    self.rightBtn=rightBtn;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [self creatTableFootView];
}
-(void)creatTableFootView{
    UIView * footView = [[UIView alloc]init];
    if (self.modeNameArray.count==0) {
        if (!_blankLabel)
        {
            _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
            _blankLabel.text=@"暂无充值模式~~";
            _blankLabel.font=FONT(17, 15);
            _blankLabel.textAlignment=NSTextAlignmentCenter;
            [footView addSubview:_blankLabel];
        }
    }
    UILabel * footTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_blankLabel.frame), SCREEN_WIDTH-20, WZ(100))];
    footTitle.text = @"注：若充值模式不齐，请您先完善相关平台ID资料：APP->我的->会员->会员卡->用户资料->编辑后保存";
    footTitle.numberOfLines = 0;
    footTitle.font = FONT(12, 10);
    footTitle.textColor = COLOR_RED;
    [footView addSubview:footTitle];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(footTitle.frame)+10);
    _tableView.tableFooterView = footView;
}
#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modeNameArray.count;
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
    
    UIView *cellView=self.cellViewArray[indexPath.row];
    [cell.contentView addSubview:cellView];
    
    if (self.cellRow==indexPath.row)
    {
        UIImageView *checkIV=self.checkIVArray[indexPath.row];
        checkIV.image=IMAGE(@"linju_xuanze");
    }
    else
    {
        UIImageView *checkIV=self.checkIVArray[indexPath.row];
        checkIV.image=IMAGE(@"");
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellRow=indexPath.row;
    self.chooseModeId=self.modeIdArray[indexPath.row];
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=[self.heightArray[indexPath.row] floatValue];
    
    return height;
}




#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//充值
-(void)rightBtnClick
{
    if (self.modeNameArray.count>0)
    {
        if ([self.payType isEqualToString:@"1"] || [self.payType isEqualToString:@"2"])
        {
            //backType:self.chooseModeId
            [HTTPManager rechargeWithUserId:[UserInfoData getUserInfoFromArchive].userId money:self.money payType:self.payType backType:self.chooseModeId password:@"" complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    if ([self.payType isEqualToString:@"2"])
                    {
                        //支付宝支付
                        NSString *aliParams=[resultDict objectForKey:@"aliParams"];
                        NSString *appScheme = @"Yunlian";
                        //调用支付结果开始支付
                        [[AlipaySDK defaultService] payOrder:aliParams fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            
                        }];
                        
                        NSMutableDictionary *rechargeDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.money,@"money", nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"recharge" object:nil userInfo:rechargeDict];
                    }
                    if ([self.payType isEqualToString:@"1"])
                    {
                        //微信支付
                        PayReq *req=[[PayReq alloc] init];
                        NSMutableDictionary *dict=[resultDict objectForKey:@"wxParams"];
                        req.openID              = [dict objectForKey:@"appid"];
                        req.partnerId           = [dict objectForKey:@"partnerid"];
                        req.prepayId            = [dict objectForKey:@"prepayid"];
                        req.nonceStr            = [dict objectForKey:@"noncestr"];
                        req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
                        req.package             = [dict objectForKey:@"package"];
                        req.sign                = [dict objectForKey:@"sign"];
                        //调起支付（**参数有一个错误，将不能完成调起**）
                        [WXApi sendReq:req];
                        
                        NSMutableDictionary *rechargeDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.money,@"money", nil];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"recharge" object:nil userInfo:rechargeDict];
                    }
                }
                else
                {
                    [self.view makeToast:[resultDict objectForKey:@"msg"] duration:1.0];
                }
                
            }];
        }
        if ([self.payType isEqualToString:@"4"])
        {
            //佣金充值 弹出支付密码框
            [self createBackgroundViewWithSmallViewTitle:@"支付密码" detail:@"输入支付密码完成充值"];
        }
        if ([self.payType isEqualToString:@"5"])
        {
            //快钱支付
            [HTTPManager rechargeWithUserId:[UserInfoData getUserInfoFromArchive].userId money:self.money payType:self.payType backType:self.chooseModeId password:@"" complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    NSString *html=[resultDict objectForKey:@"kqParams"];
                    ScanDetailViewController *vc=[[ScanDetailViewController alloc]init];
                    vc.isKuaiqian=YES;
                    vc.name=@"快钱充值";
                    vc.html=html;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [self.view makeToast:[resultDict objectForKey:@"msg"] duration:2.0];
                }
            }];
            
        }
    }
    else
    {
        [self.view makeToast:@"请选择充值模式" duration:2.0];
    }
    
    
}

//创建背景View
-(void)createBackgroundViewWithSmallViewTitle:(NSString *)title detail:(NSString*)detail
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self.view.window addSubview:bgView];
    self.bgView=bgView;
    
    CGFloat spaceToBorder=WZ(20);
    CGFloat smallViewWidth=SCREEN_WIDTH-WZ(30*2);
    
    CGSize titleSize=[ViewController sizeWithString:title font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(30))];
    CGSize detailSize=[ViewController sizeWithString:detail font:FONT(15, 13) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(100))];
    
    CGFloat smallViewHeight=WZ(15*4+20)+titleSize.height+detailSize.height+WZ(35)+WZ(35);
    
    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(WZ(30), WZ(180), smallViewWidth, smallViewHeight)];
    smallView.backgroundColor=COLOR_WHITE;
    smallView.clipsToBounds=YES;
    smallView.layer.cornerRadius=5;
    [self.bgView addSubview:smallView];
    self.smallView=smallView;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), titleSize.height)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    titleLabel.text=title;
    titleLabel.textColor=COLOR_BLACK;
    titleLabel.font=FONT(17, 15);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [smallView addSubview:titleLabel];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, titleLabel.bottom+WZ(15), smallView.width-WZ(spaceToBorder*2), detailSize.height)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    detailLabel.text=detail;
    detailLabel.textColor=COLOR_LIGHTGRAY;
    detailLabel.font=FONT(15, 13);
    detailLabel.numberOfLines=0;
    detailLabel.textAlignment=NSTextAlignmentLeft;
    [smallView addSubview:detailLabel];
    
    UITextField *passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(spaceToBorder, detailLabel.bottom+WZ(10), smallView.width-WZ(spaceToBorder*2), WZ(35))];
    passwordTF.placeholder=@"请输入支付密码";
    passwordTF.font=FONT(16, 14);
    passwordTF.secureTextEntry=YES;
    passwordTF.clipsToBounds=YES;
    passwordTF.layer.cornerRadius=5;
    passwordTF.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    passwordTF.layer.borderWidth=1.0;
    [smallView addSubview:passwordTF];
    self.passwordTF=passwordTF;
    
    NSArray *qxqdArray=[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];
    
    CGFloat buttonWidth=WZ(100);
    CGFloat buttonHeight=WZ(35);
    CGFloat buttonSpace=smallViewWidth-buttonWidth*2-spaceToBorder*2;
    
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *qxqdBtn=[[UIButton alloc]initWithFrame:CGRectMake(spaceToBorder+(buttonWidth+buttonSpace)*(i%2), smallViewHeight-buttonHeight-WZ(20), buttonWidth, buttonHeight)];
        [qxqdBtn setTitle:qxqdArray[i] forState:UIControlStateNormal];
        qxqdBtn.titleLabel.font=FONT(17, 15);
        qxqdBtn.clipsToBounds=YES;
        qxqdBtn.layer.cornerRadius=5;
        qxqdBtn.tag=i;
        [qxqdBtn addTarget:self action:@selector(qxqdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:qxqdBtn];
        
        if (i==0)
        {
            [qxqdBtn setTitleColor:COLOR(98, 99, 100, 1) forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(230, 235, 235, 1);
        }
        if (i==1)
        {
            [qxqdBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(254, 153, 160, 1);
        }
    }
}

//取消确定按钮
-(void)qxqdBtnClick:(UIButton*)button
{
    if (button.tag==0)
    {
        //取消 移除bgView
        [self.bgView removeFromSuperview];
    }
    if (button.tag==1)
    {
        //确定 移除bgView
        [self.bgView removeFromSuperview];
        
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"充值中..." detail:nil];
        [hud show:YES];
        [hud hide:YES afterDelay:20];
        //backType:self.chooseModeId
        [HTTPManager rechargeWithUserId:[UserInfoData getUserInfoFromArchive].userId money:self.money payType:self.payType backType:self.chooseModeId password:self.passwordTF.text complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                //佣金支付
                for (UIViewController *controller in self.navigationController.viewControllers)
                {
                    if ([controller isKindOfClass:[MyWalletViewController class]])
                    {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                
                [self.view.window makeToast:@"充值成功" duration:2.0];
            }
            else
            {
                [self.view makeToast:[resultDict objectForKey:@"msg"] duration:2.0];
            }
            [hud hide:YES];
        }];
        
        
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
