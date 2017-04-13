//
//  MyselfViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyselfViewController.h"

#import "SettingViewController.h"
#import "MyselfInfoViewController.h"
#import "MyCollectionViewController.h"
#import "MyArticleViewController.h"
#import "MyOrderViewController.h"
#import "MyOrderDetailViewController.h"
#import "MyRedEnvelopeListViewController.h"
#import "MyCouponViewController.h"
#import "MyWalletViewController.h"
#import "ScanViewController.h"
#import "MemberCenterViewController.h"
#import "MyStoreViewController.h"
#import "AddFriendViewController.h"
#import "SignInTodayViewController.h"
#import "ReceivedOrderViewController.h"
#import "SystemMessageViewController.h"
//#import "RegisterStoreViewController.h"
#import "VerifyStoreViewController.h"
#import "SuggestionViewController.h"
#import "MyUrlViewController.h"

@interface MyselfViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)UIButton *xiaoxiBtn;
@property(nonatomic,strong)UIButton *headBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *signLabel;

@property(nonatomic,strong)UIView *addFriendView;
@property(nonatomic,assign)BOOL isAddSelect;

@property(nonatomic,strong)StoreModel *storeModel;
@property(nonatomic,strong)User *user;

@property(nonatomic,assign)NSInteger xtRemind;
@property(nonatomic,assign)NSInteger plRemind;
@property(nonatomic,assign)NSInteger dzRemind;


@end

@implementation MyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.xtRemind=0;
    self.plRemind=0;
    self.dzRemind=0;
    self.isAddSelect=NO;
    
    [self createNavigationBar];
    [self createTableView];
//    [self createSubviews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getContentNotification:) name:@"content" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getHeadImageNotification:) name:@"headImage" object:nil];
    
    
    
    
}

-(void)getContentNotification:(NSNotification*)notification
{
    NSDictionary *dict=[notification userInfo];
    NSString *nickname=[dict objectForKey:@"nickname"];
    NSString *sign=[dict objectForKey:@"sign"];
    
    if (nickname!=nil)
    {
        self.nameLabel.text=nickname;
    }
    if (sign!=nil)
    {
        self.signLabel.text=sign;
    }
}

-(void)getHeadImageNotification:(NSNotification*)notification
{
    NSDictionary *dict=[notification userInfo];
    NSString *headImage=[dict objectForKey:@"headImage"];
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImage]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
    [self getUserInfo];
    [self messageCount];
    
}

//获取用户信息
-(void)getUserInfo
{
    //获取用户信息
    [HTTPManager getUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(User *user) {
        self.user=user;
        [UserInfoData saveUserInfoWithUser:user];
        [_tableView reloadData];
    }];
}

//我的信息提醒
-(void)messageCount
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

-(void)viewWillDisappear:(BOOL)animated
{
    self.isAddSelect=NO;
    self.addFriendView.hidden=YES;
    [_tableView reloadData];
}

-(void)createNavigationBar
{
    self.title=@"我的";
    
    if (self.isChatVC==YES)
    {
        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
        [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem=leftItem;
    }
    
    UIButton *xiaoxiBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(30), WZ(10), WZ(30), WZ(25))];
    [xiaoxiBtn setBackgroundImage:IMAGE(@"xiaoxi_w") forState:UIControlStateNormal];
    [xiaoxiBtn addTarget:self action:@selector(xiaoxiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.xiaoxiBtn=xiaoxiBtn;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:xiaoxiBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
//    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(70), WZ(10), WZ(70), WZ(25))];
//    
//    UIButton *addFriendBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(25), WZ(25))];
//    [addFriendBtn setBackgroundImage:IMAGE(@"wode_tianjiahaoyou") forState:UIControlStateNormal];
//    [addFriendBtn addTarget:self action:@selector(addFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:addFriendBtn];
//    
//    UIButton *xiaoxiBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(30), 0, WZ(30), WZ(25))];
//    [xiaoxiBtn setBackgroundImage:IMAGE(@"xiaoxi") forState:UIControlStateNormal];
//    [xiaoxiBtn addTarget:self action:@selector(xiaoxiBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:xiaoxiBtn];
//    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
//    self.navigationItem.rightBarButtonItem=rightItem;
    
    
}

//-(void)createSubviews
//{
//    UIView *addFriendView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(60)-WZ(120), WZ(10), WZ(120), WZ(100))];
//    addFriendView.backgroundColor=COLOR(102, 102, 102, 1);
//    addFriendView.clipsToBounds=YES;
//    addFriendView.layer.cornerRadius=5;
//    [self.view addSubview:addFriendView];
//    addFriendView.hidden=YES;
//    self.addFriendView=addFriendView;
//    
//    UIImageView *saoIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
//    saoIV.image=IMAGE(@"wode_saoyisao");
//    [addFriendView addSubview:saoIV];
//    
//    UILabel *saoLabel=[[UILabel alloc]initWithFrame:CGRectMake(saoIV.right+WZ(10), saoIV.top, WZ(60), saoIV.height)];
//    saoLabel.text=@"扫一扫";
//    saoLabel.font=FONT(15,13);
//    saoLabel.textColor=COLOR_WHITE;
//    [addFriendView addSubview:saoLabel];
//    
//    UIImageView *addIV=[[UIImageView alloc]initWithFrame:CGRectMake(saoIV.left, saoIV.bottom+WZ(30), saoIV.width, saoIV.height)];
//    addIV.image=IMAGE(@"wode_tianjiahaoyou");
//    [addFriendView addSubview:addIV];
//    
//    UILabel *addLabel=[[UILabel alloc]initWithFrame:CGRectMake(saoLabel.left, addIV.top, saoLabel.width, saoLabel.height)];
//    addLabel.text=@"添加好友";
//    addLabel.font=FONT(15,13);
//    addLabel.textColor=COLOR_WHITE;
////    addLabel.backgroundColor=COLOR_CYAN;
//    [addFriendView addSubview:addLabel];
//    
//    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15), saoIV.bottom+WZ(15), addFriendView.width-WZ(15*2), 1)];
//    lineView.backgroundColor=COLOR_WHITE;
//    [addFriendView addSubview:lineView];
//    
//    for (NSInteger i=0; i<2; i++)
//    {
//        UIButton *saoBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, WZ(50)*i, addFriendView.width, WZ(50))];
//        saoBtn.tag=i;
//        [saoBtn addTarget:self action:@selector(saoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [addFriendView addSubview:saoBtn];
//    }
//    
//    
//}


-(void)createTableView
{
    _tableView=[[UITableView alloc]init];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    if (self.isChatVC==YES)
    {
        _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    else
    {
        _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    }
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2)
    {
        return 2;
    }
    else if (section == 3){
        return 5;
    }
    else
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellIdentifier=@"Cell0";
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
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(105))];
        cellView.backgroundColor=COLOR(255, 63, 94, 1);
        [cell.contentView addSubview:cellView];
        
        NSString *imgUrlString=[UserInfoData getUserInfoFromArchive].headImage;
        NSURL *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=[NSURL URLWithString:imgUrlString];
        }
        else
        {
            imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
        }
        
        UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(20), WZ(70), WZ(70))];
        headBtn.layer.borderColor=COLOR(255, 163, 173, 1).CGColor;
        headBtn.layer.borderWidth=2.0;
        headBtn.layer.cornerRadius=headBtn.width/2.0;
        headBtn.clipsToBounds=YES;
        [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        [headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:headBtn];
        self.headBtn=headBtn;
        
//        NSLog(@"头像路径===%@",self.user.headImage);
        NSString *nameString=@"";
        if (![self.user.nickname isEqualToString:@""] && ![self.user.vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@（%@）",self.user.nickname,self.user.vipName];
        }
        if (![self.user.nickname isEqualToString:@""] && [self.user.vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@",self.user.nickname];
        }
        if ([self.user.nickname isEqualToString:@""] && ![self.user.vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@（%@）",self.user.nickname,self.user.vipName];
        }
        if ([self.user.nickname isEqualToString:@""] && [self.user.vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@",self.user.nickname];
        }
        
        CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(17,15) maxSize:CGSizeMake(WZ(220), WZ(30))];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headBtn.right+WZ(10), headBtn.top, nameSize.width, WZ(30))];
        nameLabel.text=nameString;
        nameLabel.textColor=COLOR_WHITE;
        nameLabel.font=FONT(17,15);
        [cellView addSubview:nameLabel];
        self.nameLabel=nameLabel;
//        nameLabel.backgroundColor=COLOR_CYAN;
        
        NSString *signString=self.user.sign;
        CGSize signSize=[ViewController sizeWithString:signString font:FONT(15,13) maxSize:CGSizeMake(WZ(250), WZ(40))];
        UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, signSize.width, WZ(40))];
        signLabel.text=signString;
        signLabel.textColor=COLOR_WHITE;
        signLabel.font=FONT(15,13);
        signLabel.numberOfLines=2;
        [cellView addSubview:signLabel];
        self.signLabel=signLabel;
//        signLabel.backgroundColor=COLOR_CYAN;
        
        UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10), cellView.height/2.0-WZ(10), WZ(10), WZ(20))];
        //        jiantouIV.backgroundColor=COLOR_CYAN;
        jiantouIV.image=IMAGE(@"youjiantou_bai");
        [cellView addSubview:jiantouIV];
        
        UIButton *bigBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, cellView.width, cellView.height)];
        [bigBtn addTarget:self action:@selector(bigBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:bigBtn];
        
//        NSArray *firstCellBtnImageArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_jinriqiandao"),IMAGE(@"wode_wodedianpu"),IMAGE(@"wode_huiyuanzhongxin"),IMAGE(@"wode_wodejifen"), nil];
//        NSArray *btnLabelArray=[[NSArray alloc]initWithObjects:@"今日签到",@"我的店铺",@"外快(红包)吧",@"我的积分", nil];
//        
//        CGFloat btnWidth=WZ(35);
//        CGFloat btnHeight=WZ(35);
//        CGFloat space=WZ(55);
//        CGFloat leftMargin=(SCREEN_WIDTH-btnWidth*4-space*3)/2.0;
        
        NSArray *firstCellBtnImageArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_jinriqiandao"),IMAGE(@"wode_wodedianpu"),IMAGE(@"wode_huiyuanzhongxin"), nil];
        NSArray *btnLabelArray=[[NSArray alloc]initWithObjects:@"今日签到",@"我的店铺",@"会员中心", nil];
        
        CGFloat btnWidth=WZ(35);
        CGFloat btnHeight=WZ(35);
        CGFloat space=WZ(65);
        CGFloat leftMargin=(SCREEN_WIDTH-btnWidth*3-space*2)/2.0;
        
        for (NSInteger i=0; i<3; i++)
        {
            UIButton *firstCellBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+(btnWidth+space)*(i%4), cellView.bottom+WZ(15), btnWidth, btnHeight)];
            firstCellBtn.tag=i;
//            firstCellBtn.backgroundColor=COLOR_RED;
            [firstCellBtn setBackgroundImage:firstCellBtnImageArray[i] forState:UIControlStateNormal];
            [firstCellBtn addTarget:self action:@selector(firstCellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:firstCellBtn];
            
            UILabel *btnLabel=[[UILabel alloc]initWithFrame:CGRectMake(firstCellBtn.left-WZ(30), firstCellBtn.bottom+WZ(10), firstCellBtn.width+WZ(30*2), WZ(20))];
//            btnLabel.backgroundColor=COLOR_CYAN;
            btnLabel.text=btnLabelArray[i];
            btnLabel.textColor=COLOR_LIGHTGRAY;
            btnLabel.font=FONT(13,11);
            btnLabel.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:btnLabel];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
    {
        static NSString *cellIdentifier=@"Cell1";
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
        
//        NSArray *dingdanBtnImageArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_daifukuan"),IMAGE(@"wode_daishouhuo"),IMAGE(@"wode_daipingjia"),IMAGE(@"wode_tuikuan"), nil];
//        NSArray *btnLabelArray=[[NSArray alloc]initWithObjects:@"待付款",@"待收货",@"待评价",@"退款", nil];
        
        NSArray *dingdanBtnImageArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_daifukuan"),IMAGE(@"wode_daishouhuo"),IMAGE(@"wode_daipingjia"), nil];
        NSArray *btnLabelArray=[[NSArray alloc]initWithObjects:@"待付款",@"待收货",@"待评价", nil];
        
        CGFloat btnWidth=WZ(30);
        CGFloat btnHeight=WZ(30);
        CGFloat space=WZ(71.25);//50
        CGFloat leftMargin=(SCREEN_WIDTH-btnWidth*3-space*2)/2.0;
        
        for (NSInteger i=0; i<3; i++)
        {
            UIButton *dingdanBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+(btnWidth+space)*(i%3), WZ(15), btnWidth, btnHeight)];
            dingdanBtn.tag=i;
            [dingdanBtn setBackgroundImage:dingdanBtnImageArray[i] forState:UIControlStateNormal];
            [dingdanBtn addTarget:self action:@selector(dingdanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:dingdanBtn];
            
            UILabel *btnLabel=[[UILabel alloc]initWithFrame:CGRectMake(dingdanBtn.left-WZ(20), dingdanBtn.bottom+WZ(10), dingdanBtn.width+WZ(20*2), WZ(20))];
            //            btnLabel.backgroundColor=COLOR_CYAN;
            btnLabel.text=btnLabelArray[i];
            btnLabel.textColor=COLOR_LIGHTGRAY;
            btnLabel.font=FONT(13,11);
            btnLabel.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:btnLabel];
        }
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2)
    {
        static NSString *cellIdentifier=@"Cell2";
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
        NSArray *imageArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_wodedingdan"),IMAGE(@"wode_wodedingdan"), nil];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
        imageView.image=imageArray[indexPath.row];
        //        imageView.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+WZ(15), 0, WZ(120), WZ(50))];
        titleLabel.font=FONT(17,15);
        //        titleLabel.backgroundColor=COLOR_CYAN;
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"收到的订单",@"红包列表", nil];
        titleLabel.text=titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(8), WZ(17.5), WZ(8), WZ(15))];
        //        jiantouIV.backgroundColor=COLOR_CYAN;
        jiantouIV.image=IMAGE(@"youjiantou_hei");
        [cell.contentView addSubview:jiantouIV];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==3)
    {
        static NSString *cellIdentifier=@"Cell3";
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
        
        NSArray *imageArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_daifukuan"),IMAGE(@"wode_tuikuan"),IMAGE(@"wode_wodeshoucang"),IMAGE(@"wode_wodefawen"),IMAGE(@"wode_wodewailian"), nil];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
        imageView.image=imageArray[indexPath.row];
        [cell.contentView addSubview:imageView];
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"好处吧",@"我的优惠",@"我的收藏",@"我的发文",@"我的外链", nil];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+WZ(15), 0, WZ(120), WZ(50))];
        titleLabel.font=FONT(17,15);
        titleLabel.text=titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(8), WZ(17.5), WZ(8), WZ(15))];
        //        jiantouIV.backgroundColor=COLOR_CYAN;
        jiantouIV.image=IMAGE(@"youjiantou_hei");
        [cell.contentView addSubview:jiantouIV];
        
        NSArray *detailArray=[[NSArray alloc]initWithObjects:@"",@"后台制定相关规则",@"话题/商品/商家",@"说说有趣的事情",@"", nil];
        
        CGSize detailSize=[ViewController sizeWithString:detailArray[indexPath.row] font:FONT(12,10) maxSize:CGSizeMake(WZ(180), WZ(50))];
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10)-WZ(5)-detailSize.width, 0, detailSize.width, WZ(50))];
        detailLabel.text=detailArray[indexPath.row];
        detailLabel.font=FONT(12,10);
        detailLabel.textColor=COLOR_LIGHTGRAY;
        [cell.contentView addSubview:detailLabel];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==4)
    {
        static NSString *cellIdentifier=@"Cell4";
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
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
        imageView.image=IMAGE(@"wode_shenqingshequ");
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+WZ(15), 0, WZ(200), WZ(50))];
        titleLabel.font=FONT(17,15);
        titleLabel.text=@"申请开放社区";
        [cell.contentView addSubview:titleLabel];
        
//        UILabel *shenqingLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+60), WZ(13), WZ(60), WZ(24))];
//        shenqingLabel.text=@"申请";
//        shenqingLabel.font=FONT(15,13);
//        shenqingLabel.textColor=COLOR(255, 149, 154, 1);
//        shenqingLabel.textAlignment=NSTextAlignmentCenter;
//        shenqingLabel.layer.cornerRadius=3;
//        shenqingLabel.clipsToBounds=YES;
//        shenqingLabel.layer.borderColor=COLOR(255, 149, 154, 1).CGColor;
//        shenqingLabel.layer.borderWidth=1;
//        [cell.contentView addSubview:shenqingLabel];
        
        UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(8), WZ(17.5), WZ(8), WZ(15))];
        //        jiantouIV.backgroundColor=COLOR_CYAN;
        jiantouIV.image=IMAGE(@"youjiantou_hei");
        [cell.contentView addSubview:jiantouIV];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"Cell5";
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
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
        imageView.image=IMAGE(@"wode_shezhi");
//        imageView.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+WZ(15), 0, WZ(120), WZ(50))];
        titleLabel.font=FONT(17,15);
        titleLabel.text=@"设置";
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(8), WZ(17.5), WZ(8), WZ(15))];
        //        jiantouIV.backgroundColor=COLOR_CYAN;
        jiantouIV.image=IMAGE(@"youjiantou_hei");
        [cell.contentView addSubview:jiantouIV];
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2)
    {
        if (indexPath.row == 0) {
            //收到的订单
            ReceivedOrderViewController *vc=[[ReceivedOrderViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==1)
        {
            //红包列表
            MyRedEnvelopeListViewController *vc=[[MyRedEnvelopeListViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    if (indexPath.section==3)
    {
        if (indexPath.row==0)
        {
            //我的钱包
            MyWalletViewController *vc=[[MyWalletViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==1)
        {
            //我的优惠
            MyCouponViewController *vc=[[MyCouponViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if (indexPath.row==2)
        {
            //我的收藏
            MyCollectionViewController *vc=[[MyCollectionViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==3)
        {
            //我的发文
            MyArticleViewController *vc=[[MyArticleViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==4)
        {
            //我的外链
            MyUrlViewController *vc=[[MyUrlViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==4)
    {
        //可申请开放社区
        SuggestionViewController *vc=[[SuggestionViewController alloc]init];
        vc.isMyselfVC=YES;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==5)
    {
        //设置
        SettingViewController *vc=[[SettingViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    if (section==1)
    {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(60))];
        bgView.backgroundColor=COLOR(241, 241, 241, 1);
        
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), SCREEN_WIDTH, bgView.height-WZ(10))];
        titleView.backgroundColor=COLOR_WHITE;
        [bgView addSubview:titleView];
        
        UIImageView *dingdanIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
//        dingdanIV.backgroundColor=COLOR_CYAN;
        dingdanIV.image=IMAGE(@"wode_wodedingdan");
        [titleView addSubview:dingdanIV];
        
        UILabel *dingdanLabel=[[UILabel alloc]initWithFrame:CGRectMake(dingdanIV.right+WZ(15), 0, WZ(120), titleView.height)];
        dingdanLabel.text=@"我的订单";
        dingdanLabel.font=FONT(17,15);
        [titleView addSubview:dingdanLabel];
        
        UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(8), WZ(17.5), WZ(8), WZ(15))];
        //        jiantouIV.backgroundColor=COLOR_CYAN;
        jiantouIV.image=IMAGE(@"youjiantou_hei");
        [titleView addSubview:jiantouIV];
        
        CGSize detailSize=[ViewController sizeWithString:@"查看全部订单" font:FONT(12,10) maxSize:CGSizeMake(WZ(150), titleView.height)];
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10)-WZ(5)-detailSize.width, 0, detailSize.width, titleView.height)];
        detailLabel.text=@"查看全部订单";
        detailLabel.font=FONT(12,10);
        detailLabel.textColor=COLOR_LIGHTGRAY;
        [titleView addSubview:detailLabel];
        
        UIButton *dingdanBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height)];
        dingdanBtn.backgroundColor=COLOR_CLEAR;
        [dingdanBtn addTarget:self action:@selector(dingdanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:dingdanBtn];
        
        return bgView;
    }
    else
    {
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        bgView.backgroundColor=COLOR(241, 241, 241, 1);
        
        return bgView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(200);
    }
    if (indexPath.section==1)
    {
        return WZ(80);
    }
    else
    {
        return WZ(50);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    if (section==1)
    {
        return WZ(60);
    }
    else
    {
        return WZ(10);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0)
    {
        scrollView.scrollEnabled=NO;
    }
    else
    {
        scrollView.scrollEnabled=YES;
    }
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加好友
-(void)addFriendBtnClick
{
    if (self.isAddSelect==NO)
    {
        self.addFriendView.hidden=NO;
    }
    else
    {
        self.addFriendView.hidden=YES;
    }
    
    self.isAddSelect=!self.isAddSelect;
}

//查看消息
-(void)xiaoxiBtnClick
{
    SystemMessageViewController *vc=[[SystemMessageViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

////扫一扫和添加好友
//-(void)saoBtnClick:(UIButton*)button
//{
//    if (button.tag==0)
//    {
//        //扫描界面
//        ScanViewController *vc=[[ScanViewController alloc]init];
//        vc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    if (button.tag==1)
//    {
//        //添加好友
//        AddFriendViewController *vc=[[AddFriendViewController alloc]init];
//        vc.isMyselfVC=YES;
//        vc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    
//}

//查看个人信息
-(void)bigBtnClick
{
    MyselfInfoViewController *vc=[[MyselfInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//全部订单
-(void)dingdanBtnClick
{
    MyOrderViewController *vc=[[MyOrderViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//更换头像
-(void)headBtnClick
{
    
    
    
}

//今日签到 我的店铺 外快(红包)吧 我的积分
-(void)firstCellBtnClick:(UIButton*)button
{
    if (button.tag==0)
    {
        //今日签到
        SignInTodayViewController *vc=[[SignInTodayViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (button.tag==1)
    {
        //我的店铺
        BOOL ifArea=[ViewController ifRegisterArea];
        if (ifArea==YES)
        {
            [HTTPManager ifAddStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    NSInteger isMerchant=[[resultDict objectForKey:@"isMerchant"] integerValue];
                    if (isMerchant==0)
                    {
                        //isMerchant：0 未添加商户 跳转到商户验证界面
                        VerifyStoreViewController *vc=[[VerifyStoreViewController alloc]init];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if (isMerchant==1)
                    {
                        //isMerchant：1 商户审核中 提示
                        [self.view makeToast:@"商户审核中，请耐心等待。" duration:2.0];
                    }
                    if (isMerchant==2)
                    {
                        //isMerchant：2 商户审核通过 跳转到店铺列表界面
                        User *user=[UserInfoData getUserInfoFromArchive];
                        user.merchantId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"merchantId"]];
                        [UserInfoData saveUserInfoWithUser:user];
                        
                        MyStoreViewController *vc=[[MyStoreViewController alloc]init];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    if (isMerchant==3)
                    {
                        //isMerchant：3 商户审核不通过 跳转到商户验证界面
                        VerifyStoreViewController *vc=[[VerifyStoreViewController alloc]init];
                        vc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能注册商户！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
    if (button.tag==2)
    {
        //外快(红包)吧
        MemberCenterViewController *vc=[[MemberCenterViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag==3)
    {
        //我的积分
        
        
        
    }
    
    
}

//待付款 待收货 待评价 退款
-(void)dingdanBtnClick:(UIButton*)button
{
    if (button.tag==0)
    {
        //待付款
        MyOrderDetailViewController *vc=[[MyOrderDetailViewController alloc]init];
        vc.titleString=@"待付款";
        vc.orderStatus=@"0";
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (button.tag==1)
    {
        //待收货
        MyOrderDetailViewController *vc=[[MyOrderDetailViewController alloc]init];
        vc.titleString=@"待收货";
        vc.orderStatus=@"1";
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    if (button.tag==2)
    {
        //待评价
        MyOrderDetailViewController *vc=[[MyOrderDetailViewController alloc]init];
        vc.titleString=@"待评价";
        vc.orderStatus=@"3";
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    if (button.tag==3)
    {
        //退款
        MyOrderDetailViewController *vc=[[MyOrderDetailViewController alloc]init];
        vc.titleString=@"退款/退货";
        vc.orderStatus=@"4";
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
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
