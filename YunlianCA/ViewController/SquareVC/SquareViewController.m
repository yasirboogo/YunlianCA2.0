//
//  SquareViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "SquareViewController.h"

#import "Type01ViewController.h"
#import "Type02ViewController.h"
#import "Type03ViewController.h"
#import "Type04ViewController.h"
#import "Type05ViewController.h"
#import "ScanViewController.h"
#import "PaymentQRCodeViewController.h"
#import "PaySuccessViewController.h"
#import "SystemMessageViewController.h"
#import "AdViewController.h"
#import "TuiGuangViewController.h"
#import "MyWalletViewController.h"
#import "RedEnvelopeSquareViewController.h"
#import "ChangePayPasswordVC.h"

@interface SquareViewController ()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    ImagePlayerView *_playerView;
    UITableView *_smallTableView;
    BOOL _isSelect;
    
}
@property(nonatomic,strong)UIButton *xiaoxiBtn;
@property(nonatomic,assign)NSInteger xtRemind;
@property(nonatomic,assign)NSInteger plRemind;
@property(nonatomic,assign)NSInteger dzRemind;

@property(nonatomic,strong)ImagePlayerView *playerView;
@property(nonatomic,strong)NSArray *moduleListArray;
@property(nonatomic,strong)Model *adModel;
@property(nonatomic,strong)UIButton *threeBtn;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSArray *adIVArray;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)NSString *addressString;
@property(nonatomic,strong)UIButton *addressBtn;
@property(nonatomic,strong)UILabel *topLabel;
@property(nonatomic,strong)UIImageView *xsjIV;

@property(nonatomic,strong)NSString *provinceId;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *districtId;
@property(nonatomic,strong)NSString *areaId;
@property(nonatomic,strong)NSString *communityId;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *community;
@property(nonatomic,strong)NSMutableArray *addressArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)UIView *smallBgView;
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,strong)UIButton *hongbaoBtn;
@property(nonatomic,strong)UIButton *tuiguangBtn;
@property(nonatomic,strong)UIImageView *backIV;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)UIView *topView;

@end

@implementation SquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.xtRemind=0;
    self.plRemind=0;
    self.dzRemind=0;
    
    self.provinceId=@"";
    self.cityId=@"";
    self.districtId=@"";
    self.areaId=@"";
    self.communityId=@"";
    self.province=@"";
    self.city=@"";
    self.district=@"";
    self.area=@"";
    self.community=@"";
    self.addressString=@"未定位";
    
    self.addressArray=[NSMutableArray array];
    self.areaArray=[NSMutableArray array];
    
    self.moduleListArray=[NSMutableArray array];
    
    if (self.isNearbyVC==NO)
    {
        [self ifPayPswEqualLoginPsw];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(casAddressNotification:) name:@"casAddress" object:nil];
    
//    NSLog(@"邻里圈传来的片区ID===%@",self.nearbyAreaId);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nearbyVCNotification:) name:@"nearby" object:nil];
    
    [self initSubviews];
//    NSLog(@"用户id===%@\n片区id===%@",[UserInfoData getUserInfoFromArchive].userId,[UserInfoData getUserInfoFromArchive].areaId);
}

-(void)nearbyVCNotification:(NSNotification*)notification
{
    NSDictionary *nearbyDict=[notification userInfo];
    NSString *isNearbyVC=[nearbyDict objectForKey:@"isNearbyVC"];
    NSString *areaId=[nearbyDict objectForKey:@"areaId"];
    NSString *areaName=[nearbyDict objectForKey:@"areaName"];
    
    if ([isNearbyVC isEqualToString:@"YES"])
    {
        self.isNearbyVC=YES;
    }
    else
    {
        self.isNearbyVC=NO;
    }
    
    self.nearbyAreaId=areaId;
    self.nearbyAreaName=areaName;
    
    if (self.topView && _tableView)
    {
        [self.topView removeFromSuperview];
        [_tableView removeFromSuperview];
        
        [self initSubviews];
    }
    
}

-(void)casAddressNotification:(NSNotification*)notification
{
    NSDictionary *cityDict=[notification userInfo];
    NSString *casAddress=[cityDict objectForKey:@"address"];
    if (casAddress==nil || [casAddress isEqualToString:@""])
    {
        self.addressString=@"未定位";
        self.addressLabel.text=@"未定位";
        self.addressLabel.textColor=COLOR_WHITE;
    }
    else
    {
        self.addressString=casAddress;
        self.addressLabel.text=casAddress;
        self.addressLabel.textColor=COLOR_WHITE;
    }
    
    CGSize addressLabelSize=[ViewController sizeWithString:self.addressString font:FONT(13, 11) maxSize:CGSizeMake(SCREEN_WIDTH-self.topLabel.left-WZ(10), WZ(60))];
    self.addressLabel.frame=CGRectMake(self.topLabel.left, self.topLabel.bottom+WZ(5), addressLabelSize.width, addressLabelSize.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    //去掉导航条下边的shadowImage，就可以正常显示了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    
    //主目录
    NSString *path = NSHomeDirectory();
    NSLog(@"沙盒目录:\n%@",path);
    
    [self getSquareData];
    [self getAdData];
    [self getMessageCount];
    [self ifReceiveNewRedEnvelope];
    
    NSString *imgUrlString=[UserInfoData getUserInfoFromArchive].headImage;
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[UserInfoData getUserInfoFromArchive].headImage]];
    }
    [self.iconIV sd_setImageWithURL:imgUrl placeholderImage:IMAGE(@"morentouxiang")];
    if (!self.isNearbyVC&&!_isSelect) {
         [self getAreaAddress];
    }
    
}
//获取用户信息
-(void)getAreaAddress
{
    [HTTPManager getAreaAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
            NSString *pqName=[resultDict objectForKey:@"pqName"];
            NSString *pqId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"pqId"]];
            
            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
            NSDictionary *areaDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
            [areaDict setValue:pqName forKey:@"area"];
            [areaDict setValue:pqId forKey:@"areaId"];
            [areaDict writeToFile:filePath atomically:YES];
            if (self.topView) {
                [self.topView removeFromSuperview];
            }
            if (_tableView) {
                [_tableView removeFromSuperview];
            }
            
            
            [self initSubviews];
            if (![pqId isEqualToString:[UserInfoData getUserInfoFromArchive].areaId]) {
                [self getUserInfo];
            }
           
            
        }
        
    }];
}
-(void)getUserInfo
{
    [HTTPManager getUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(User *user) {
        
        [UserInfoData saveUserInfoWithUser:user];

    }];
}
//判断用户支付密码是否和登录密码相同
-(void)ifPayPswEqualLoginPsw
{
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *password=[dict objectForKey:@"password"];
    [HTTPManager ifPayPswEqualLoginPswWithPhone:[UserInfoData getUserInfoFromArchive].username pwd:password complete:^(NSDictionary *resultDict) {
        
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSInteger isEqual=[[resultDict objectForKey:@"isEq"] integerValue];
            if (isEqual==1)
            {
                //密码相同
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的初始支付密码为登录密码，为了您的账户安全，请去修改支付密码！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
                [alertView show];
            }
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (buttonIndex==1)
    {
        //这个东西是一个辨别标示，在跳转到指定页面后拿到[pushJudge setObject:@"push" forKey:@"push"];从而可以知道是通过推送消息跳转过来的还是正常情况下通过导航栏导航过来的！
        NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@"changePsw" forKey:@"changePsw"];
        [pushJudge synchronize];
        
        //跳转到修改支付密码界面
        ChangePayPasswordVC *vc=[[ChangePayPasswordVC alloc]init];
        UINavigationController *pushNav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.view.window.rootViewController presentViewController:pushNav animated:YES completion:^{
            
        }];
    }
}

//首页下面很多栏目
-(void)getSquareData
{
    NSString *areaId=@"";
    if (self.nearbyAreaId==nil || [self.nearbyAreaId isEqualToString:@""])
    {
        areaId=[UserInfoData getUserInfoFromArchive].areaId;
    }
    else
    {
        areaId=self.nearbyAreaId;
    }
    
    [HTTPManager getSquareDataWithUserId:[UserInfoData getUserInfoFromArchive].userId areaId:areaId complete:^(NSMutableArray *mutableArray) {
        self.moduleListArray=mutableArray;
        [_tableView reloadData];
    }];
}

//广告列表
-(void)getAdData
{
    
    [HTTPManager getAdWithModuleId:@"1" pageNum:@"1" pageSize:@"4" complete:^(Model *model) {
        
        if (model.adListArray.count>0)
        {
            self.adModel=model;
            [self createAdView];
            [_tableView reloadData];
        }
        else
        {
            self.adModel.adListArray=[NSMutableArray array];
        }
    }];
}

//我的信息提醒
-(void)getMessageCount
{
  
    
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.xtRemind=[[resultDict objectForKey:@"xtRemind"] integerValue];
            self.plRemind=[[resultDict objectForKey:@"plRemind"] integerValue];
            self.dzRemind=[[resultDict objectForKey:@"dzRemind"] integerValue];
            
            NSInteger totalCount=self.xtRemind+self.plRemind+self.dzRemind;
            if (totalCount==0)
            {
                [self.xiaoxiBtn setBackgroundImage:IMAGE(@"xiaoxi_w") forState:UIControlStateNormal];
            }
            if (totalCount>0)
            {
                [self.xiaoxiBtn setBackgroundImage:IMAGE(@"xiaoxi_y") forState:UIControlStateNormal];
            }
        }
    }];
}

//是否收到新红包
-(void)ifReceiveNewRedEnvelope
{
   
    [HTTPManager ifReceiveNewRedEnvelopeWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSInteger isPacket=[[resultDict objectForKey:@"isPacket"] integerValue];
            
            if (isPacket==0)
            {
                [self.hongbaoBtn setBackgroundImage:IMAGE(@"hongbao_shouye_w") forState:UIControlStateNormal];
            }
            if (isPacket==1)
            {
                [self.hongbaoBtn setBackgroundImage:IMAGE(@"hongbao_shouye_y") forState:UIControlStateNormal];
            }
        }
    }];
}


-(ImagePlayerView*)createAdView
{
    ImagePlayerView *playerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(175))];
    playerView.imagePlayerViewDelegate=self;
    playerView.scrollInterval=3;
    [playerView reloadData];
    self.playerView=playerView;
    
    return playerView;
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [_playerView stopTimer];
}

-(void)initSubviews
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(160))];
    //    topView.backgroundColor=COLOR_CYAN;
    [self.view addSubview:topView];
    self.topView=topView;
    
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, topView.width, topView.height)];
    bgIV.image=IMAGE(@"guangchang_topcellbg");
    [topView addSubview:bgIV];
    
    //回家
    UIImageView *backIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(10), 20+WZ(10+3), WZ(13), WZ(19))];
    backIV.image=IMAGE(@"fanhui_bai");
    [topView addSubview:backIV];
    self.backIV=backIV;
    
    CGSize backSize=[ViewController sizeWithString:@"回家 V" font:FONT(15,13) maxSize:CGSizeMake(WZ(100), WZ(25))];
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(backIV.right+WZ(3), 20+WZ(10), backSize.width, WZ(25))];
//    backBtn.backgroundColor=COLOR_CYAN;
    [backBtn setTitle:@"回家 V" forState:UIControlStateNormal];
    [backBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    backBtn.titleLabel.font=FONT(15,13);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    self.backBtn=backBtn;
    
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
    if (self.isNearbyVC==YES)
    {
        NSDictionary *areaDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
        [areaDict setValue:self.nearbyAreaName forKey:@"area"];
        [areaDict setValue:self.nearbyAreaId forKey:@"areaId"];
        [areaDict writeToFile:filePath atomically:YES];
    }
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *areaName;
    if ([manager fileExistsAtPath:filePath])
    {
        NSDictionary *areaDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
        areaName=[areaDict objectForKey:@"area"];
    }
    else
    {
        areaName=[UserInfoData getUserInfoFromArchive].areaName;
    }
    
    CGSize addressSize;
    if (areaName==nil || [areaName isEqualToString:@""])
    {
        addressSize=[ViewController sizeWithString:@"无片区" font:FONT(15,13) maxSize:CGSizeMake(WZ(130), WZ(25))];
    }
    else
    {
        addressSize=[ViewController sizeWithString:areaName font:FONT(15,13) maxSize:CGSizeMake(WZ(130), WZ(25))];
    }
    
    UIButton *addressBtn=[[UIButton alloc]init];
    //    addressBtn.backgroundColor=COLOR_CYAN;
    [addressBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    addressBtn.titleLabel.font=FONT(15,13);
    [addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:addressBtn];
    self.addressBtn=addressBtn;
    
    if (areaName==nil || [areaName isEqualToString:@""])
    {
        [addressBtn setTitle:@"无片区" forState:UIControlStateNormal];
    }
    else
    {
        [addressBtn setTitle:areaName forState:UIControlStateNormal];
    }
    
    UIImageView *xsjIV=[[UIImageView alloc]initWithFrame:CGRectMake(addressBtn.right+WZ(5), addressBtn.top+WZ(7), WZ(18), WZ(10))];
    xsjIV.image=IMAGE(@"xiasanjiao");
    [topView addSubview:xsjIV];
    self.xsjIV=xsjIV;
    
    if (self.isNearbyVC==YES)
    {
        backIV.hidden=NO;
        backBtn.hidden=NO;
        xsjIV.hidden=YES;
        addressBtn.userInteractionEnabled=NO;
        
        addressBtn.frame=CGRectMake(backBtn.right, 20+WZ(10), addressSize.width, WZ(25));
        xsjIV.frame=CGRectMake(addressBtn.right+WZ(5), addressBtn.top+WZ(7), WZ(18), WZ(10));
    }
    else
    {
        backIV.hidden=YES;
        backBtn.hidden=YES;
        
        addressBtn.frame=CGRectMake(WZ(15), 20+WZ(10), addressSize.width, WZ(25));
        xsjIV.frame=CGRectMake(addressBtn.right+WZ(5), addressBtn.top+WZ(7), WZ(18), WZ(10));
    }
    
    UIButton *xiaoxiBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+28), self.addressBtn.top+WZ(1), WZ(28), WZ(23))];
    [xiaoxiBtn setBackgroundImage:IMAGE(@"xiaoxi_w") forState:UIControlStateNormal];
    [xiaoxiBtn addTarget:self action:@selector(xiaoxiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:xiaoxiBtn];
    self.xiaoxiBtn=xiaoxiBtn;
    
    UIButton *hongbaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15*2+28*2), self.addressBtn.top, WZ(28), WZ(23))];
    [hongbaoBtn setBackgroundImage:IMAGE(@"hongbao_shouye_w") forState:UIControlStateNormal];
    [hongbaoBtn addTarget:self action:@selector(hongbaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:hongbaoBtn];
    self.hongbaoBtn=hongbaoBtn;
    
    UIButton *tuiguangBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15*3+28*3), self.addressBtn.top, WZ(28), WZ(23))];
    [tuiguangBtn setBackgroundImage:IMAGE(@"tuijian_shouye") forState:UIControlStateNormal];
    [tuiguangBtn addTarget:self action:@selector(tuiguangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:tuiguangBtn];
    self.tuiguangBtn=tuiguangBtn;
    
    NSArray *threeArray=[[NSArray alloc]initWithObjects:IMAGE(@"shequ_saoyisao"),IMAGE(@"shequ_fukuanma"),IMAGE(@"shequ_xiaofeicaifu"), nil];
    NSArray *titleArray=@[@"扫一扫",@"收款码",@"好处吧"];
    
    for (NSInteger i=0; i<3; i++)
    {
        UIButton *threeBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20)+WZ(38+25)*(i%3), self.addressBtn.bottom+WZ(20), WZ(38), WZ(38))];
        //        threeBtn.backgroundColor=COLOR_CYAN;
        threeBtn.tag=i;
        [threeBtn setBackgroundImage:threeArray[i] forState:UIControlStateNormal];
        [threeBtn addTarget:self action:@selector(threeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:threeBtn];
        self.threeBtn=threeBtn;
        
        UILabel *threeLabel=[UILabel labelTextCenterWithFrame:CGRectMake(threeBtn.left-WZ(10), threeBtn.bottom+WZ(15), threeBtn.width+WZ(10*2), WZ(25)) text:titleArray[i] textColor:COLOR_WHITE font:FONT(13,11) textAlignment:NSTextAlignmentCenter backColor:COLOR_CLEAR];
        [topView addSubview:threeLabel];
    }
    
    NSString *imgUrlString=[UserInfoData getUserInfoFromArchive].headImage;
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[UserInfoData getUserInfoFromArchive].headImage]];
    }
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(self.threeBtn.right+WZ(20), self.threeBtn.top, WZ(50), WZ(50))];
    [iconIV sd_setImageWithURL:imgUrl placeholderImage:IMAGE(@"morentouxiang")];
    iconIV.clipsToBounds=YES;
    iconIV.layer.cornerRadius=iconIV.width/2.0;
    [topView addSubview:iconIV];
    self.iconIV=iconIV;
    
    NSString *smaAreaName=[UserInfoData getUserInfoFromArchive].smaAreaName;
    UILabel *topLabel=[UILabel aLabelWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(10+15), WZ(25)) labelSize:CGSizeMake(SCREEN_WIDTH-iconIV.right-WZ(10+15), WZ(25)) text:smaAreaName textColor:COLOR_WHITE bgColor:COLOR_CLEAR font:FONT(14,12) textAlignment:NSTextAlignmentLeft];
    [topView addSubview:topLabel];
    self.topLabel=topLabel;
    
    CGSize addressLabelSize=[ViewController sizeWithString:self.addressString font:FONT(13, 11) maxSize:CGSizeMake(SCREEN_WIDTH-topLabel.left-WZ(10), WZ(60))];
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(topLabel.left, topLabel.bottom+WZ(5), addressLabelSize.width, addressLabelSize.height)];
    addressLabel.text=self.addressString;
    addressLabel.font=FONT(13, 11);
    addressLabel.textColor=COLOR_WHITE;
    addressLabel.numberOfLines=0;
    [topView addSubview:addressLabel];
    self.addressLabel=addressLabel;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, topView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-topView.height-49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_tableView)
    {
        return 2;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        return 1;
    }
    else
    {
        return self.addressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
    {
        if (indexPath.section==0)
        {
            static NSString *cellIdentifier1=@"Cell1";
            UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (!cell1)
            {
                cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
            }
            else
            {
                while ([cell1.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell1.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            [cell1.contentView addSubview:self.playerView];
            
//            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(175))];
//            imageView.image=IMAGE(@"test_ad01");
//            [cell1.contentView addSubview:imageView];
            
            
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell1;
        }
        else
        {
            static NSString *cellIdentifier2=@"Cell2";
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (!cell2)
            {
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            }
            else
            {
                while ([cell2.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell2.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            for (NSInteger i=0; i<self.moduleListArray.count; i++)
            {
                NSDictionary *dict=self.moduleListArray[i];
                NSString *name=[dict objectForKey:@"name"];
                NSString *img=[dict objectForKey:@"img"];
                NSInteger update=[[dict objectForKey:@"update"] integerValue];
//                NSLog(@"dict===%@",dict);
                
                UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(WZ(27.5)+WZ(75+47.5)*(i%3), WZ(20)+WZ(75+50)*(i/3), WZ(75), WZ(75))];
                button.tag=i;
                //            button.backgroundColor=COLOR_CYAN;
                button.clipsToBounds=YES;
                button.layer.cornerRadius=button.width/2.0;
                [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell2.contentView addSubview:button];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(button.left-WZ(20), button.bottom+WZ(10), button.width+WZ(40), WZ(25))];
                //            label.backgroundColor=COLOR_CYAN;
                label.text=name;
                label.font=FONT(13,11);
                label.textAlignment=NSTextAlignmentCenter;
                [cell2.contentView addSubview:label];
                
                UIImageView *redIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(102.5)+WZ(75+47.5)*(i%3), WZ(20)+WZ(75+50)*(i/3), WZ(10), WZ(10))];
                redIV.image=IMAGE(@"xiaohongdian");
                [cell2.contentView addSubview:redIV];
                
                if (update>0)
                {
                    redIV.hidden=NO;
                }
                if (update==0)
                {
                    redIV.hidden=YES;
                }
            }
            
            
            
            
            
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell2;
        }
    }
    else
    {
        static NSString *cellIdentifier3=@"Cell3";
        UITableViewCell *cell3=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (!cell3)
        {
            cell3=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        }
        else
        {
            while ([cell3.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell3.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
        titleLabel.text=[self.addressArray[indexPath.row] objectForKey:@"name"];
        titleLabel.font=FONT(17, 15);
        [cell3.contentView addSubview:titleLabel];
        
        
        cell3.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell3;
    }
}

#pragma mark ===UITableViewDelegate===

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        aView.backgroundColor=COLOR(241, 241, 241, 1);
        return aView;
    }
    else
    {
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(20))];
        aView.backgroundColor=COLOR(241, 241, 241, 1);
        return aView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
    {
        if (indexPath.section==1)
        {
            for (NSInteger i=0; i<self.moduleListArray.count; i++)
            {
                UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(WZ(27.5)+WZ(75+47.5)*(i%3), WZ(20)+WZ(75+50)*(i/3), WZ(75), WZ(75))];
                self.button=button;
            }
            
            return self.button.bottom+WZ(50);
        }
        else
        {
            return WZ(175);
        }
    }
    else
    {
        return WZ(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        return WZ(10);
    }
    else
    {
        return WZ(20);
    }
}

#pragma mark ===循环滚动条
- (NSInteger)numberOfItems
{
    return self.adModel.adListArray.count;
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    NSDictionary *dict=self.adModel.adListArray[index];
    NSString *img=[dict objectForKey:@"img"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentupian")];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    //点击跳转到下个界面
    NSDictionary *dict=self.adModel.adListArray[index];
    NSString *explain=[dict objectForKey:@"explain"];
    NSString *adId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    AdViewController *vc=[[AdViewController alloc]init];
    vc.adId=adId;
    vc.explain=explain;
    vc.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ===按钮点击方法
//切换片区
-(void)addressBtnClick
{
    self.provinceId=@"";
    self.cityId=@"";
    self.districtId=@"";
    self.areaId=@"";
    
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:30];
    [HTTPManager chooseCityWithParentId:@"" complete:^(NSMutableArray *array) {
        if (array.count>0)
        {
            [self.addressArray removeAllObjects];
            self.addressArray=array;
            
            [self createSmallTableView];
        }
        else
        {
            [self.view makeToast:@"暂无省份数据" duration:2.0];
        }
        [hud hide:YES];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_smallTableView)
    {
        //先判断现在是选择的省份还是市
        if ([self.provinceId isEqualToString:@""])
        {
            //如果省份id为空 则是选省份
            self.province=[self.addressArray[indexPath.row] objectForKey:@"name"];
            //选择省份之后请求当前省下的市
            self.provinceId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
            
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
            [hud show:YES];
            [hud hide:YES afterDelay:20];
            [HTTPManager chooseCityWithParentId:self.provinceId complete:^(NSMutableArray *array) {
                if (array.count>0)
                {
                    //首先清除地址数组里面的省份数据
                    [self.addressArray removeAllObjects];
                    //然后给数组赋值于市数组
                    self.addressArray=array;
                    //刷新tableview
                    [_smallTableView reloadData];
                }
                else
                {
                    [self.smallBgView removeFromSuperview];
                    [self.view makeToast:@"暂无市数据" duration:2.0];
                }
                [hud hide:YES];
            }];
        }
        else
        {
            if ([self.cityId isEqualToString:@""])
            {
                //如果省份id不为空 市id为空 取出上个请求里的市id请求区数据
                self.city=[self.addressArray[indexPath.row] objectForKey:@"name"];
                self.cityId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                [hud show:YES];
                [hud hide:YES afterDelay:30];
                [HTTPManager chooseCityWithParentId:self.cityId complete:^(NSMutableArray *array) {
                    if (array.count>0)
                    {
                        //首先清除地址数组里面的市数据
                        [self.addressArray removeAllObjects];
                        //然后给数组赋值于区数组
                        self.addressArray=array;
                        //刷新tableview
                        [_smallTableView reloadData];
                        //                        NSLog(@"数据===%@",self.addressArray);
                    }
                    else
                    {
                        [self.view makeToast:@"暂无区数据" duration:2.0];
                        [self.smallBgView removeFromSuperview];
                    }
                    [hud hide:YES];
                }];
            }
            else
            {
                if ([self.districtId isEqualToString:@""])
                {
                    //如果省份id不为空 市id不为空 区id为空 取出上个请求里的区id 根据区id请求片区数据
                    self.district=[self.addressArray[indexPath.row] objectForKey:@"name"];
                    self.districtId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                    //                    NSLog(@"数据===%@",self.district);
                    
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                    [hud show:YES];
                    [hud hide:YES afterDelay:30];
                    [HTTPManager chooseAreaWithParentId:self.districtId complete:^(NSMutableArray *array) {
                        if (array.count>0)
                        {
                            //首先清除地址数组里面的区数据
                            [self.addressArray removeAllObjects];
                            //然后给数组赋值于片区数组
                            self.addressArray=array;
                            //刷新tableview
                            [_smallTableView reloadData];
                            //                            NSLog(@"数据===%@",self.addressArray);
                        }
                        else
                        {
                            [self.smallBgView removeFromSuperview];
                            [self.view.window makeToast:@"暂无片区数据" duration:2.0];
                        }
                        [hud hide:YES];
                    }];
                }
                else
                {
                    if ([self.areaId isEqualToString:@""])
                    {
                        //如果省份id不为空 市id不为空 区id不为空 片区id为空 则是选片区 此时self.addressArray里的数据已经变成了片区
                        self.area=[self.addressArray[indexPath.row] objectForKey:@"name"];
                        self.areaId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                        //取出片区之后 删除数组里的区数据 以便下次重新选择
                        [self.addressArray removeAllObjects];
                        
                        
                        CGSize addressSize=[ViewController sizeWithString:self.area font:FONT(15,13) maxSize:CGSizeMake(WZ(130), WZ(25))];
                        [self.addressBtn setTitle:self.area forState:UIControlStateNormal];
                        if (self.isNearbyVC==YES)
                        {
                            self.addressBtn.frame=CGRectMake(self.backBtn.right, 20+WZ(10), addressSize.width, WZ(25));
                            self.xsjIV.frame=CGRectMake(self.addressBtn.right+WZ(5), self.addressBtn.top+WZ(7), WZ(18), WZ(10));
                        }
                        else
                        {
                            self.addressBtn.frame=CGRectMake(WZ(15), 20+WZ(10), addressSize.width, WZ(25));
                            self.xsjIV.frame=CGRectMake(self.addressBtn.right+WZ(5), self.addressBtn.top+WZ(7), WZ(18), WZ(10));
                        }
                        
                        
                        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
                        NSMutableDictionary *areaDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.area,@"area",self.areaId,@"areaId", nil];
                        [areaDict writeToFile:filePath atomically:YES];
                        _isSelect = YES;
                        User *user=[UserInfoData getUserInfoFromArchive];
                        user.areaId=self.areaId;
                        user.areaName=self.area;
                        [UserInfoData saveUserInfoWithUser:user];
                        
                        //隐藏tableview
                        [_smallTableView reloadData];
                        [self.smallBgView removeFromSuperview];
                    }
                }
            }
        }
        
        
    }
    
    
    
    

}

-(void)createSmallTableView
{
    UIView *smallBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    smallBgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    [self.view.window addSubview:smallBgView];
    self.smallBgView=smallBgView;
    
    _smallTableView=[[UITableView alloc]initWithFrame:CGRectMake(WZ(30), 64, SCREEN_WIDTH-WZ(30*2), SCREEN_HEIGHT-64-49-WZ(50))];
    _smallTableView.delegate=self;
    _smallTableView.dataSource=self;
    _smallTableView.tableFooterView=[[UIView alloc]init];
    [smallBgView addSubview:_smallTableView];
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(30), SCREEN_HEIGHT-49-WZ(50), SCREEN_WIDTH-WZ(30*2), WZ(50))];
    cancelBtn.backgroundColor=COLOR_LIGHTGRAY;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [smallBgView addSubview:cancelBtn];
}

//取消选择地址
-(void)cancelBtnClick
{
    [self.smallBgView removeFromSuperview];
    self.smallBgView=nil;
}

//新消息界面
-(void)xiaoxiBtnClick
{
    SystemMessageViewController *vc=[[SystemMessageViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
}

//红包广场
-(void)hongbaoBtnClick
{
    RedEnvelopeSquareViewController *vc=[[RedEnvelopeSquareViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
}

//我的推广
-(void)tuiguangBtnClick
{
    TuiGuangViewController *vc=[[TuiGuangViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
}


////搜索帖子新鲜事界面
//-(void)sousuoBtnClick
//{
//    SearchViewController *searchVC=[[SearchViewController alloc]init];
//    self.navigationController.navigationBarHidden=NO;
//    searchVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:searchVC animated:YES];
//}

//扫一扫 付款码 好处吧三个按钮
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
        //付款码
        PaymentQRCodeViewController *vc=[[PaymentQRCodeViewController alloc]init];
        self.navigationController.navigationBarHidden=NO;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag==2)
    {
        //好处吧
        MyWalletViewController *vc=[[MyWalletViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        self.navigationController.navigationBarHidden=NO;
        [self.navigationController pushViewController:vc animated:YES];
        
        
//        ConsumptionOfWealthVC *vc=[[ConsumptionOfWealthVC alloc]init];
//        vc.hidesBottomBarWhenPushed=YES;
//        self.navigationController.navigationBarHidden=NO;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

//主页各分类 新鲜事儿 邻里论坛 生日节日等
-(void)buttonClick:(UIButton*)button
{
    NSDictionary *dict=self.moduleListArray[button.tag];
    NSString *status=[NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
    NSString *lowercount=[NSString stringWithFormat:@"%@",[dict objectForKey:@"lowercount"]];
    NSString *moduleId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    
    NSString *areaId=@"";
    if (self.nearbyAreaId==nil || [self.nearbyAreaId isEqualToString:@""])
    {
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
        NSDictionary *areaDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
        areaId=areaDict[@"areaId"];
        
    }
    else
    {
        areaId=self.nearbyAreaId;
    }
    //更新小红点
    [HTTPManager hongdianWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:moduleId areaId:areaId complete:^(NSDictionary *resultDict) {
        
    }];
    
    
    
    //如果不是门店
    if ([status isEqualToString:@"1"])
    {
        Type01ViewController *type01VC=[[Type01ViewController alloc]init];
        type01VC.moduleDict=dict;
        type01VC.areaId=areaId;
        self.navigationController.navigationBarHidden=NO;
        type01VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:type01VC animated:YES];
        
//        NSLog(@"主页帖子类点击传进去的数据===%@",dict);
        
//        //如果子栏目==0
//        if ([lowercount isEqualToString:@"0"])
//        {
//            Type01ViewController *type01VC=[[Type01ViewController alloc]init];
//            type01VC.moduleDict=dict;
//            self.navigationController.navigationBarHidden=NO;
//            type01VC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:type01VC animated:YES];
//        }
//        else
//        {
//            
//            
//            
//            
//            
//        }
        
        
    }
    if ([status isEqualToString:@"0"])
    {
        
        Type03ViewController *type03VC=[[Type03ViewController alloc]init];
        type03VC.moduleDict=dict;
        type03VC.areaId=areaId;
        self.navigationController.navigationBarHidden=NO;
        type03VC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:type03VC animated:YES];
        
//        NSLog(@"主页门店点击传进去的数据===%@",dict);
    }
    
    
    
    
//    NSString *title=self.zhutiArray[button.tag];
    
//    if (button.tag==0)
//    {
//        Type01ViewController *type01VC=[[Type01ViewController alloc]init];
//        type01VC.titleString=title;
//        self.navigationController.navigationBarHidden=NO;
//        type01VC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:type01VC animated:YES];
//    }
//    if (button.tag==1)
//    {
//        Type02ViewController *type02VC=[[Type02ViewController alloc]init];
//        type02VC.titleString=title;
//        self.navigationController.navigationBarHidden=NO;
//        type02VC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:type02VC animated:YES];
//    }
    
//    if (button.tag==5 || button.tag==14)
//    {
//        Type03ViewController *type03VC=[[Type03ViewController alloc]init];
//        type03VC.titleString=title;
//        self.navigationController.navigationBarHidden=NO;
//        type03VC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:type03VC animated:YES];
//    }
//    else
//    {
//        Type01ViewController *type01VC=[[Type01ViewController alloc]init];
//        type01VC.titleString=title;
//        self.navigationController.navigationBarHidden=NO;
//        type01VC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:type01VC animated:YES];
//    }
    
//    Type01ViewController *type01VC=[[Type01ViewController alloc]init];
//    type01VC.titleString=title;
//    self.navigationController.navigationBarHidden=NO;
//    type01VC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:type01VC animated:YES];
}

//回家
-(void)backBtnClick
{
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
    NSDictionary *areaDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
    [areaDict setValue:[UserInfoData getUserInfoFromArchive].areaName forKey:@"area"];
    [areaDict setValue:[UserInfoData getUserInfoFromArchive].areaId forKey:@"areaId"];
    [areaDict writeToFile:filePath atomically:YES];
    
    //回家时把串门的片区id置空
    self.nearbyAreaId=nil;
    
    self.isNearbyVC=NO;
    
    self.backIV.hidden=YES;
    self.backBtn.hidden=YES;
    [self.backIV removeFromSuperview];
    [self.backBtn removeFromSuperview];
    
    self.addressBtn.userInteractionEnabled=YES;
    self.xsjIV.hidden=NO;
    
    [self.addressBtn setTitle:[UserInfoData getUserInfoFromArchive].areaName forState:UIControlStateNormal];
    CGSize addressSize=[ViewController sizeWithString:[UserInfoData getUserInfoFromArchive].areaName font:FONT(15,13) maxSize:CGSizeMake(WZ(130), WZ(25))];
    self.addressBtn.frame=CGRectMake(WZ(15), 20+WZ(10), addressSize.width, WZ(25));
    self.xsjIV.frame=CGRectMake(self.addressBtn.right+WZ(5), self.addressBtn.top+WZ(7), WZ(18), WZ(10));
    
    
    [self getSquareData];
    [self getAdData];
    [self getMessageCount];
    
    
    
    
    
//    self.tabBarController.selectedIndex=2;
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
