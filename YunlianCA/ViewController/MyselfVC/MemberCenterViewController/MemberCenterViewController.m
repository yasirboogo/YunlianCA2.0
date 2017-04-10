//
//  MemberCenterViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MemberCenterViewController.h"

#import "MyselfInfoViewController.h"
#import "TuiGuangViewController.h"
#import "MemberLevelUpgradeViewController.h"
#import "UserInfoViewController.h"
#import "BindBankCardViewController.h"
#import "TiXianRecordsViewController.h"
#import "YongJinMingXiVC.h"

@interface MemberCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    
}

//@property(nonatomic,assign)NSInteger memberCount;
@property(nonatomic,strong)NSDictionary *brokerageDict;
@property(nonatomic,strong)NSMutableArray *memberArray;
@property(nonatomic,strong)User *user;
@property(nonatomic,strong)NSString *totalItems;

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.memberCount=12;
    self.totalItems=@"0";
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
}

//我的会员
-(void)getMyMemberCenterData
{
    [HTTPManager myMemberCenterWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.memberArray=[[listDict objectForKey:@"data"] mutableCopy];
            self.totalItems=[NSString stringWithFormat:@"%@",[listDict objectForKey:@"totalItems"]];
            
            [_tableView reloadData];
        }
    }];
}

//我的佣金
-(void)getMyBrokerage
{
    [HTTPManager myBrokerageWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.brokerageDict=resultDict;
            
            [_tableView reloadData];
        }
    }];
}

-(void)getUserInfo
{
    //获取用户信息
    [HTTPManager getUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(User *user) {
        self.user=user;
        [UserInfoData saveUserInfoWithUser:user];
        [_tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getMyMemberCenterData];
    [self getMyBrokerage];
    [self getUserInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"会员中心";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+70), WZ(10), WZ(70), WZ(30))];
    [rightBtn setTitle:@"提现明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(15, 13);
    
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
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2)
    {
        return 2;
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
        static NSString *cellIdentifier0=@"Cell0";
        UITableViewCell *cell0=[tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
        if (!cell0)
        {
            cell0=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0];
        }
        else
        {
            while ([cell0.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell0.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(20), WZ(70), WZ(70))];
        headBtn.layer.borderColor=COLOR(255, 163, 173, 1).CGColor;
        headBtn.layer.borderWidth=2.0;
        headBtn.layer.cornerRadius=headBtn.width/2.0;
        headBtn.clipsToBounds=YES;
        
        NSString *imgUrlString=self.user.headImage;
        NSURL *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=[NSURL URLWithString:imgUrlString];
        }
        else
        {
            imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
        }
        [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        [cell0.contentView addSubview:headBtn];
        
        NSString *nickname=self.user.nickname;
        NSString *vipName=self.user.vipName;
        
        NSString *nameString=@"";
        if (![nickname isEqualToString:@""] && ![vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@（%@）",nickname,vipName];
        }
        if (![nickname isEqualToString:@""] && [vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@",nickname];
        }
        if ([nickname isEqualToString:@""] && ![vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@（%@）",nickname,vipName];
        }
        if ([nickname isEqualToString:@""] && [vipName isEqualToString:@""])
        {
            nameString=[NSString stringWithFormat:@"%@",nickname];
        }
        
//        NSString *nameString=[UserInfoData getUserInfoFromArchive].nickname;
        CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(17,15) maxSize:CGSizeMake(WZ(220), WZ(30))];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headBtn.right+WZ(10), headBtn.top, nameSize.width, WZ(30))];
        nameLabel.text=nameString;
        nameLabel.textColor=COLOR_BLACK;
        nameLabel.font=FONT(17,15);
        [cell0.contentView addSubview:nameLabel];
        
        NSString *cardNumString;
        if (self.user.ylCardNo==nil || [self.user.ylCardNo isEqualToString:@""])
        {
            cardNumString=@"";
        }
        else
        {
            cardNumString=[NSString stringWithFormat:@"会员卡号：%@",self.user.ylCardNo];
        }
        
        CGSize cardNumSize=[ViewController sizeWithString:cardNumString font:FONT(15,13) maxSize:CGSizeMake(WZ(250), WZ(40))];
        UILabel *cardNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(5), cardNumSize.width, WZ(40))];
        cardNumLabel.text=cardNumString;
        cardNumLabel.textColor=COLOR_LIGHTGRAY;
        cardNumLabel.font=FONT(15,13);
        cardNumLabel.numberOfLines=0;
        [cell0.contentView addSubview:cardNumLabel];
        
        
        
        cell0.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell0.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell0;
    }
    if (indexPath.section==1)
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
        
        NSString *ktxBrokerage=[NSString stringWithFormat:@"%.2f",[[self.brokerageDict objectForKey:@"ktxBrokerage"] floatValue]];
        NSString *totalBrokerage=[NSString stringWithFormat:@"%.2f",[[self.brokerageDict objectForKey:@"totalBrokerage"] floatValue]];
        NSString *ytxBrokerage=[NSString stringWithFormat:@"%.2f",[[self.brokerageDict objectForKey:@"ytxBrokerage"] floatValue]];
        NSString *totalBroIn=[NSString stringWithFormat:@"%.2f",[[self.brokerageDict objectForKey:@"totalBroIn"] floatValue]];
        NSString *totalHbIn=[NSString stringWithFormat:@"%.2f",[[self.brokerageDict objectForKey:@"totalHbIn"] floatValue]];
        
        
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
        iconIV.image=IMAGE(@"wode_wodeyongjin");
        [cell1.contentView addSubview:iconIV];
        
        UILabel *wdyjLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(15), WZ(10), WZ(150), WZ(30))];
        wdyjLabel.text=@"外快（红包）吧";
        wdyjLabel.font=FONT(17, 15);
        [cell1.contentView addSubview:wdyjLabel];
        
        UILabel *yjmxLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+100), WZ(10), WZ(100), WZ(30))];
        yjmxLabel.text=@"明细";
        yjmxLabel.textColor=COLOR_RED;
        yjmxLabel.textAlignment=NSTextAlignmentRight;
        yjmxLabel.font=FONT(15, 13);
        [cell1.contentView addSubview:yjmxLabel];
        
        UIButton *yjmxBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
        [yjmxBtn addTarget:self action:@selector(yjmxBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell1.contentView addSubview:yjmxBtn];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, wdyjLabel.bottom+WZ(10), SCREEN_WIDTH, 1)];
        lineView.backgroundColor=COLOR(236, 236, 236, 1);
        [cell1.contentView addSubview:lineView];
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15), lineView.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(190))];
        cellView.layer.borderColor=COLOR(227, 227, 227, 1).CGColor;
        cellView.layer.borderWidth=1.0;
        [cell1.contentView addSubview:cellView];
        
        UIView *tixianView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, cellView.width, WZ(115))];
        tixianView.backgroundColor=COLOR(143, 131, 184, 1);
        [cellView addSubview:tixianView];
        
        UILabel *ktxLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(5), WZ(15), (cellView.width-WZ(5*3))/2.0, WZ(25))];
        ktxLabel.text=@"可提现的外快";
        ktxLabel.textColor=COLOR_WHITE;
        ktxLabel.textAlignment=NSTextAlignmentCenter;
        ktxLabel.font=FONT(17, 15);
        [tixianView addSubview:ktxLabel];
//        ktxLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *ktxjeLabel=[[UILabel alloc]initWithFrame:CGRectMake(ktxLabel.left, ktxLabel.bottom+WZ(20), ktxLabel.width, WZ(30))];
        ktxjeLabel.text=[NSString stringWithFormat:@"¥ %@",ktxBrokerage];
        ktxjeLabel.textColor=COLOR_WHITE;
        ktxjeLabel.textAlignment=NSTextAlignmentCenter;
        ktxjeLabel.font=FONT(23,21);
        [tixianView addSubview:ktxjeLabel];
//        ktxjeLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *ytxLabel=[[UILabel alloc]initWithFrame:CGRectMake(ktxLabel.right+WZ(5), ktxLabel.top, ktxLabel.width, ktxLabel.height)];
        ytxLabel.text=@"已提现的外快";
        ytxLabel.textColor=COLOR_WHITE;
        ytxLabel.textAlignment=NSTextAlignmentCenter;
        ytxLabel.font=FONT(17, 15);
        [tixianView addSubview:ytxLabel];
//        ytxLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *ytxjeLabel=[[UILabel alloc]initWithFrame:CGRectMake(ytxLabel.left, ytxLabel.bottom+WZ(20), ytxLabel.width, WZ(30))];
        ytxjeLabel.text=[NSString stringWithFormat:@"¥ %@",ytxBrokerage];
        ytxjeLabel.textColor=COLOR_WHITE;
        ytxjeLabel.textAlignment=NSTextAlignmentCenter;
        ytxjeLabel.font=FONT(23,21);
        [tixianView addSubview:ytxjeLabel];
//        ytxjeLabel.backgroundColor=COLOR_CYAN;
        
//        UILabel *ytxzeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), ktxjeLabel.bottom+WZ(10), cellView.width-WZ(15*2), WZ(20))];
//        ytxzeLabel.text=[NSString stringWithFormat:@"已提现外快：¥ %@",ytxBrokerage];
//        ytxzeLabel.textColor=COLOR_WHITE;
//        ytxzeLabel.font=FONT(15,13);
//        [tixianView addSubview:ytxzeLabel];
//        ytxzeLabel.backgroundColor=COLOR_CYAN;
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"总金额",@"佣金总额",@"红包总额", nil];
        NSArray *moneyArray=[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"¥%@",totalBrokerage],[NSString stringWithFormat:@"¥%@",totalBroIn],[NSString stringWithFormat:@"¥%@",totalHbIn], nil];
        
        CGFloat space=WZ(15);
        CGFloat labelWidth=(cellView.width-WZ(15*4))/3.0;
        CGFloat labelheight=WZ(25);
        
        for (NSInteger i=0; i<3; i++)
        {
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(space+(labelWidth+space)*(i%3), tixianView.bottom+WZ(15), labelWidth, labelheight)];
            titleLabel.text=titleArray[i];
            titleLabel.textColor=COLOR_LIGHTGRAY;
            titleLabel.font=FONT(17, 15);
            titleLabel.textAlignment=NSTextAlignmentCenter;
            [cellView addSubview:titleLabel];
//            titleLabel.backgroundColor=COLOR_CYAN;
            
            UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, labelWidth, labelheight)];
            moneyLabel.text=moneyArray[i];
            moneyLabel.font=FONT(15, 13);
            moneyLabel.textAlignment=NSTextAlignmentCenter;
            [cellView addSubview:moneyLabel];
//            moneyLabel.backgroundColor=COLOR_CYAN;
        }
        
        
        UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), cellView.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(20))];
        noticeLabel.text=@"温馨提示：满10元才可提现，每笔提现手续费为2元。";
        noticeLabel.font=FONT(13,11);
        [cell1.contentView addSubview:noticeLabel];
        
        UIButton *tixianBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), noticeLabel.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        tixianBtn.titleLabel.font=FONT(17, 15);
        [tixianBtn setTitle:@"我要提现" forState:UIControlStateNormal];
        [tixianBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        tixianBtn.clipsToBounds=YES;
        tixianBtn.layer.cornerRadius=5;
        tixianBtn.backgroundColor=COLOR(254, 167, 173, 1);
        [tixianBtn addTarget:self action:@selector(tixianBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell1.contentView addSubview:tixianBtn];
        
        UILabel *tjrPhoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), tixianBtn.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), WZ(25))];
        tjrPhoneLabel.font=FONT(15,13);
        [cell1.contentView addSubview:tjrPhoneLabel];
        
        if (self.user.referrer==nil || [self.user.referrer isEqualToString:@""])
        {
            tjrPhoneLabel.text=@"我的推荐人联系方式：";
        }
        else
        {
            tjrPhoneLabel.text=[NSString stringWithFormat:@"我的推荐人联系方式：%@",self.user.referrer];
        }
        
        UIButton *callBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+31), tixianBtn.bottom+WZ(7), WZ(31), WZ(31))];
        callBtn.clipsToBounds=YES;
        callBtn.layer.cornerRadius=callBtn.width/2.0;
        [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell1.contentView addSubview:callBtn];
        
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell1;
    }
    if (indexPath.section==3)
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
        
        CGFloat space=WZ(20);
        CGFloat btnWidth=(SCREEN_WIDTH-space*6)/5;
        
        NSInteger count=0;
        if (self.memberArray.count>100)
        {
            count=100;
        }
        else
        {
            count=self.memberArray.count;
        }
        
        for (NSInteger i=0; i<count; i++)
        {
            NSDictionary *memberDict=self.memberArray[i];
            NSString *headimg=[memberDict objectForKey:@"headimg"];
            NSString *nickname=[memberDict objectForKey:@"nickname"];
            
            UIButton *memberHeadBtn=[[UIButton alloc]initWithFrame:CGRectMake(space+(btnWidth+space)*(i%5), WZ(15)+(btnWidth+WZ(40))*(i/5), btnWidth, btnWidth)];
            memberHeadBtn.tag=i;
            [memberHeadBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
            memberHeadBtn.clipsToBounds=YES;
            memberHeadBtn.layer.cornerRadius=btnWidth/2.0;
            [memberHeadBtn addTarget:self action:@selector(memberHeadBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell2.contentView addSubview:memberHeadBtn];
            
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(memberHeadBtn.left-WZ(8), memberHeadBtn.bottom+WZ(5), btnWidth+WZ(8*2), WZ(25))];
            nameLabel.text=nickname;
            nameLabel.textAlignment=NSTextAlignmentCenter;
            nameLabel.font=FONT(13,11);
            [cell2.contentView addSubview:nameLabel];
        }
        
        
        
        
        
        
        cell2.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell2;
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
        
        if (indexPath.row==0)
        {
            UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
            iconIV.image=IMAGE(@"wode_woyaotuiguang");
//            iconIV.backgroundColor=COLOR_CYAN;
            [cell3.contentView addSubview:iconIV];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(15), 0, SCREEN_WIDTH-iconIV.right-WZ(15*2+10*2), WZ(50))];
            titleLabel.text=@"我要推广";
            titleLabel.font=FONT(17, 15);
            [cell3.contentView addSubview:titleLabel];
        }
        if (indexPath.row==1)
        {
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2+10*2), WZ(50))];
            titleLabel.text=@"如何提升会员等级?";
            titleLabel.font=FONT(17, 15);
            [cell3.contentView addSubview:titleLabel];
        }
        
        
        
        
        cell3.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell3.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell3;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        //跳转用户信息界面
        MyselfInfoViewController *vc=[[MyselfInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            //跳转我要推广界面
            TuiGuangViewController *vc=[[TuiGuangViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==1)
        {
            //跳转到会员升级界面
            MemberLevelUpgradeViewController *vc=[[MemberLevelUpgradeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    if (section==3)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(30))];
        label.text=[NSString stringWithFormat:@"我的会员(%@)",self.totalItems];
        label.textColor=COLOR_LIGHTGRAY;
        label.font=FONT(15,13);
        [titleView addSubview:label];
        
        return titleView;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(105);
    }
    if (indexPath.section==1)
    {
        return WZ(405);
    }
    if (indexPath.section==3)
    {
        NSInteger memberCount=[self.memberArray count];
        CGFloat space=WZ(20);
        CGFloat btnWidth=(SCREEN_WIDTH-space*6)/5;
        
        if (memberCount%5>0)
        {
            NSInteger hangShu=memberCount/5+1;
            return WZ(15)+(btnWidth+WZ(40))*hangShu+WZ(5);
        }
        else
        {
            NSInteger hangShu=memberCount/5;
            return WZ(15)+(btnWidth+WZ(40))*hangShu+WZ(5);
        }
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
    if (section==3)
    {
        return WZ(45);
    }
    else
    {
        return WZ(15);
    }
}





#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//明细 佣金提现记录
-(void)rightBtnClick
{
//    NSLog(@"佣金提现记录");
    
    TiXianRecordsViewController *vc=[[TiXianRecordsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


/**
 佣金明细
 */
-(void)yjmxBtnClick
{
    YongJinMingXiVC *vc=[[YongJinMingXiVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


//我要提现
-(void)tixianBtnClick
{
    CGFloat ktxBrokerage=[[NSString stringWithFormat:@"%@",[self.brokerageDict objectForKey:@"ktxBrokerage"]] floatValue];
    if (ktxBrokerage>=10)
    {
        BindBankCardViewController *vc=[[BindBankCardViewController alloc]init];
        vc.ktxBrokerage=[NSString stringWithFormat:@"%.2f",ktxBrokerage];
        vc.isMemberCenter=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"满10元才可提现，每笔提现手续费为2元。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
}

//我的会员头像点击
-(void)memberHeadBtn:(UIButton*)button
{
    NSDictionary *memberDict=self.memberArray[button.tag];
    NSString *userId=[NSString stringWithFormat:@"%@",[memberDict objectForKey:@"id"]];
    
    UserInfoViewController *vc=[[UserInfoViewController alloc]init];
    vc.userId=userId;
    [self.navigationController pushViewController:vc animated:YES];
}

//联系我的推荐人
-(void)callBtnClick
{
    NSString *mobile=@"";
    if (self.user.referrer==nil || [self.user.referrer isEqualToString:@""])
    {
        mobile=@"";
    }
    else
    {
        mobile=self.user.referrer;
    }
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
