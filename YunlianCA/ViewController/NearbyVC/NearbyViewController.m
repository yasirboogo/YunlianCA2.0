//
//  NearbyViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/12/19.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "NearbyViewController.h"
#import "TapImageView.h"
#import "DynamicDetailViewController.h"
#import "SquareViewController.h"
#import "MyselfInfoViewController.h"
#import "SVProgressHUD.h"
#import "StoreSearchViewController.h"
//#import "RedEnvelopeSendViewController.h"
#import "RedEnvelopeSendViewController.h"
@interface NearbyViewController ()<UITableViewDelegate,UITableViewDataSource,TapImageViewDelegate>
{
    UITableView *_tableView;
    BOOL _isShowBigImage;
    
}

@property(nonatomic,strong)User *user;
@property(nonatomic,strong)UIButton *headBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *signLabel;

@property(nonatomic,strong)NSMutableArray *bigArticleArray;
@property(nonatomic,strong)NSMutableArray *bigArticleIdArray;
@property(nonatomic,strong)NSMutableArray *isOpenArray;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,strong)TapImageView *contentImageBtn;
@property(nonatomic,strong)TapImageView *contentImageBtn0;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *addressId;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)NSMutableArray *addressArray;
@property(nonatomic,strong)NSMutableArray *addressIdArray;



@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden=NO;
    
    self.address=@"全国V";
    self.addressId=@"0";
    self.pageNum=1;
    self.bigArticleArray=[NSMutableArray array];
    self.bigArticleIdArray=[NSMutableArray array];
    self.isOpenArray=[NSMutableArray array];
    
    self.addressArray=[NSMutableArray array];
    self.addressIdArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    
    
    
}

//获取邻里圈地区
-(void)getAreaAddress
{
    [HTTPManager getAreaAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSString *provinceName=[resultDict objectForKey:@"provinceName"];
            NSString *provinceId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"provinceId"]];
            NSString *cityName=[resultDict objectForKey:@"cityName"];
            NSString *cityId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"cityId"]];
            NSString *qName=[resultDict objectForKey:@"qName"];
            NSString *qId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"qId"]];
            NSString *pqName=[resultDict objectForKey:@"pqName"];
            NSString *pqId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"pqId"]];
//            NSString *xqName=[resultDict objectForKey:@"xqName"];
//            NSString *xqId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"xqId"]];
            
            self.addressArray=[[NSMutableArray alloc]initWithObjects:@"全国",provinceName,cityName,qName,pqName, nil];
            self.addressIdArray=[[NSMutableArray alloc]initWithObjects:@"0",provinceId,cityId,qId,pqId, nil];
        }
        
        
        
    }];
}




//获取邻里圈文章列表
-(void)getNearbyListWithAddressId:(NSString*)addressId
{
//    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
//    [hud show:YES];
//    [hud hide:YES afterDelay:20];
    [HTTPManager getNearbySquareListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"20" areaId:addressId complete:^(Model *model) {
        [SVProgressHUD dismiss];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (model.articleListArray.count>0)
            {
                self.pageNum=1;
                [self.bigArticleArray removeAllObjects];
                [self.bigArticleIdArray removeAllObjects];
                [self.isOpenArray removeAllObjects];
                
                for (NSDictionary *dict in model.articleListArray)
                {
                    NSMutableDictionary *articleDict=[NSMutableDictionary dictionaryWithDictionary:dict];
                    NSString *articleId=[articleDict objectForKey:@"id"];
                    
                    if (![self.bigArticleIdArray containsObject:articleId])
                    {
                        [self.bigArticleIdArray addObject:articleId];
                        [self.bigArticleArray addObject:articleDict];
                        [self.isOpenArray addObject:@"0"];//0是收起状态 按钮显示展开 1是展开状态 按钮显示收起 默认收起状态
                    }
                }
                
                [_tableView reloadData];
            }
        }
//        [hud hide:YES];
    }];
}

-(void)getUserInfo
{
    //获取用户信息
    [HTTPManager getUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(User *user) {
        self.user=user;
        [UserInfoData saveUserInfoWithUser:user];
        
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
        [self.headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        
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
        self.nameLabel.text=nameString;
        
        self.signLabel.text=self.user.sign;;
        
        [_tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    self.navigationController.navigationBarHidden=YES;
    if (_isShowBigImage) {
        _isShowBigImage = NO;
    }else{
        [self getUserInfo];
        [self getNearbyListWithAddressId:self.addressId];
        [self getAreaAddress];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    self.navigationController.navigationBarHidden=NO;
}

-(void)createNavigationBar
{
//    self.title=@"邻里圈";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
//    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIView *naviView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    naviView.backgroundColor=COLOR_NAVIGATION;
    [self.view addSubview:naviView];
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(10+120), 20+WZ(5), WZ(120), WZ(35))];
    [rightBtn setTitle:self.address forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);//上左下右
    rightBtn.titleLabel.font=FONT(15, 13);
//    rightBtn.backgroundColor=COLOR_CYAN;
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:rightBtn];
    self.rightBtn=rightBtn;
    
    UIButton *leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(10), 20+WZ(5), WZ(120), WZ(35))];
    [leftBtn setImage:IMAGE(@"sousuo_hei") forState:UIControlStateNormal];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);//上左下右
    leftBtn.titleLabel.font=FONT(15, 13);
    //    rightBtn.backgroundColor=COLOR_CYAN;
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:leftBtn];
    self.leftBtn=leftBtn;
    
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(130), 20+WZ(5), SCREEN_WIDTH-WZ(130*2), WZ(35))];
    titleLabel.text=@"邻里圈";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(19, 17);
    [naviView addSubview:titleLabel];
//    titleLabel.backgroundColor=COLOR_CYAN;
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    [HTTPManager getNearbySquareListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.addressId complete:^(Model *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (model.articleListArray.count>0)
            {
                for (NSDictionary *dict in model.articleListArray)
                {
                    NSMutableDictionary *articleDict=[NSMutableDictionary dictionaryWithDictionary:dict];
                    NSString *articleId=[articleDict objectForKey:@"id"];
                    
                    if (![self.bigArticleIdArray containsObject:articleId])
                    {
                        [self.bigArticleIdArray addObject:articleId];
                        [self.bigArticleArray addObject:articleDict];
                        [self.isOpenArray addObject:@"0"];
                    }
                }
            }
        }
        //结束刷新
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
    }];
}

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    [HTTPManager getNearbySquareListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.addressId complete:^(Model *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (model.articleListArray.count>0)
            {
                for (NSDictionary *dict in model.articleListArray)
                {
                    NSMutableDictionary *articleDict=[NSMutableDictionary dictionaryWithDictionary:dict];
                    NSString *articleId=[articleDict objectForKey:@"id"];
                    
                    if (![self.bigArticleIdArray containsObject:articleId])
                    {
                        [self.bigArticleIdArray addObject:articleId];
                        [self.bigArticleArray addObject:articleDict];
                        [self.isOpenArray addObject:@"0"];
                    }
                }
            }
        }
        //结束刷新
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
    }];
}



#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bigArticleArray.count;
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
    
    NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
    NSLog(@"articleDict==%@",articleDict);
    NSString *title=[[articleDict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger isTop=[[articleDict objectForKey:@"istop"] integerValue];
    
    if (isTop==1)
    {
        //置顶帖子
        UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(7.5), WZ(30), WZ(20))];
        zhidingLabel.text=@"置顶";
        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
        zhidingLabel.textColor=COLOR_WHITE;
        zhidingLabel.font=FONT(11,9);
        zhidingLabel.textAlignment=NSTextAlignmentCenter;
        zhidingLabel.layer.cornerRadius=3;
        zhidingLabel.clipsToBounds=YES;
        [cell.contentView addSubview:zhidingLabel];
        
        UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(zhidingLabel.right+WZ(10), 0, SCREEN_WIDTH-zhidingLabel.right-WZ(10+15), WZ(35))];
        biaotiLabel.backgroundColor=COLOR_WHITE;
        biaotiLabel.text=title;
        biaotiLabel.font=FONT(17, 15);
        [cell.contentView addSubview:biaotiLabel];
    }
    if (isTop==0)
    {
        //未置顶帖子
        UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(60))];
        [cell.contentView addSubview:headView];
        
        NSString *imgUrlString=[articleDict objectForKey:@"userHeadImg"];
        NSURL *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=[NSURL URLWithString:imgUrlString];
        }
        else
        {
            imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[articleDict objectForKey:@"userHeadImg"]]];
        }
        
        [headView.headImageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        headView.nameLabel.text=[articleDict objectForKey:@"userName"];
        headView.timeLabel.text=[articleDict objectForKey:@"createtime"];
        headView.addressLabel.text=[articleDict objectForKey:@"areaName"];
        
        NSString *createUser=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
        if ([createUser isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
        {
            headView.addFriendBtn.hidden=YES;
            headView.goBtn.hidden=YES;
        }
        else
        {
            headView.goBtn.tag=indexPath.row;
            [headView.goBtn addTarget:self action:@selector(goBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"isFriend"]] isEqualToString:@"0"])
            {
                //未添加好友
                [headView.addFriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
                [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                headView.addFriendBtn.dict=articleDict;
                [headView.addFriendBtn addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                headView.addFriendBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
                headView.addFriendBtn.layer.borderWidth=1;
            }
            if ([[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"isFriend"]] isEqualToString:@"1"])
            {
                //已添加好友
                [headView.addFriendBtn setTitle:@"已添加" forState:UIControlStateNormal];
                [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                headView.addFriendBtn.backgroundColor=COLOR_HEADVIEW;
            }
        }
        
        UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, 0, 0)];
        zhidingLabel.text=@"置顶";
        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
        zhidingLabel.textColor=COLOR_WHITE;
        zhidingLabel.font=FONT(11, 9);
        zhidingLabel.textAlignment=NSTextAlignmentCenter;
        zhidingLabel.layer.cornerRadius=3;
        zhidingLabel.clipsToBounds=YES;
        [cell.contentView addSubview:zhidingLabel];
        
        UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, SCREEN_WIDTH-WZ(15*2), WZ(20))];
        biaotiLabel.text=title;
        biaotiLabel.font=FONT(17, 15);
        [cell.contentView addSubview:biaotiLabel];
        
        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(45))];
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), biaotiLabel.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
        contentLabel.text=content;
        contentLabel.font=FONT(15, 13);
        contentLabel.numberOfLines=2;
        [cell.contentView addSubview:contentLabel];
        //            contentLabel.backgroundColor=COLOR_CYAN;
        
        CGSize openSize=[ViewController sizeWithString:@"收起图片" font:FONT(13,11) maxSize:CGSizeMake(WZ(100), WZ(20))];
        UIButton *openBtn=[[UIButton alloc]initWithFrame:CGRectMake(contentLabel.left, contentLabel.bottom+WZ(5), openSize.width, WZ(20))];
        openBtn.tag=indexPath.row;
        [openBtn setTitleColor:COLOR(0, 125, 235, 1) forState:UIControlStateNormal];
        openBtn.titleLabel.font=FONT(13, 11);
        //        openBtn.backgroundColor=COLOR_CYAN;
        [openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:openBtn];
        
        if ([self.isOpenArray[indexPath.row] isEqualToString:@"0"])
        {
            //是收起状态 需要展开
            [openBtn setTitle:@"展开图片" forState:UIControlStateNormal];
            openBtn.selected=NO;
        }
        if ([self.isOpenArray[indexPath.row] isEqualToString:@"1"])
        {
            //是展开状态 需要收起
            [openBtn setTitle:@"收起图片" forState:UIControlStateNormal];
            openBtn.selected=YES;
        }
        
        NSArray *contentImageArray=[[articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
        if (contentImageArray.count>0)
        {
            if (contentImageArray.count==1)
            {
                TapImageView *contentImageBtn=[[TapImageView alloc]initWithFrame:CGRectMake(WZ(15), openBtn.bottom+WZ(10), WZ(250), WZ(250))];
                
                contentImageBtn.t_delegate = self;

                contentImageBtn.imageBtnArray=contentImageArray;
                [contentImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]]  placeholderImage:IMAGE(@"morentupian")];
                NSLog(@"imageUrl=====%@",[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]);
                [cell.contentView addSubview:contentImageBtn];
                self.contentImageBtn=contentImageBtn;
                
                if ([self.isOpenArray[indexPath.row] isEqualToString:@"0"])
                {
                    //是收起状态 需要展开
                    contentImageBtn.hidden=YES;
                }
                if ([self.isOpenArray[indexPath.row] isEqualToString:@"1"])
                {
                    //是展开状态 需要收起
                    contentImageBtn.hidden=NO;
                }
            }
            else
            {
                for (NSInteger i=0; i<contentImageArray.count; i++)
                {
                    TapImageView *contentImageBtn=[[TapImageView alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), openBtn.bottom+WZ(10)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
                    contentImageBtn.t_delegate = self;
                  
                    contentImageBtn.imageBtnArray=contentImageArray;
                    contentImageBtn.tag=i;
                    [contentImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,contentImageArray[i]]]  placeholderImage:IMAGE(@"morentupian")];

                    [cell.contentView addSubview:contentImageBtn];
                    self.contentImageBtn=contentImageBtn;
                    
                    if ([self.isOpenArray[indexPath.row] isEqualToString:@"0"])
                    {
                        //是收起状态 需要展开
                        contentImageBtn.hidden=YES;
                    }
                    if ([self.isOpenArray[indexPath.row] isEqualToString:@"1"])
                    {
                        //是展开状态 需要收起
                        contentImageBtn.hidden=NO;
                    }
                }
            }
        }
        else
        {
            [openBtn removeFromSuperview];
        }
        
        ArticleBottomView *bottomView=[[ArticleBottomView alloc]init];
        //        bottomView.backgroundColor=COLOR_CYAN;
        if (contentImageArray.count>0)
        {
            if ([self.isOpenArray[indexPath.row] isEqualToString:@"0"])
            {
                //是收起状态 需要展开
                bottomView.frame=CGRectMake(0, openBtn.bottom, SCREEN_WIDTH, WZ(30));
            }
            if ([self.isOpenArray[indexPath.row] isEqualToString:@"1"])
            {
                //是展开状态 需要收起
                bottomView.frame=CGRectMake(0, self.contentImageBtn.bottom, SCREEN_WIDTH, WZ(30));
            }
        }
        else
        {
            bottomView.frame=CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(30));
        }
        
        [cell.contentView addSubview:bottomView];
        bottomView.tag=1000;
        
        bottomView.pageViewLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"browsecount"]];
        bottomView.praiseLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"praisecount"]];
        bottomView.praiseLabel.tag=10000;
        [bottomView.praiseBtn addTarget:self action:@selector(aiticlePraiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bottomView.praiseBtn.tag=indexPath.row;
        bottomView.commentLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"commentNum"]];
        
        NSString *isLike=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"isLike"]];
        if ([isLike isEqualToString:@"0"])
        {
            [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hui") forState:UIControlStateNormal];
        }
        if ([isLike isEqualToString:@"1"])
        {
            [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
        }
        bottomView.zuiBtn.tag=indexPath.row;
        [bottomView.zuiBtn addTarget:self action:@selector(nearbyZuiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        bottomView.zuiLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"kissNum"]==nil?@"0":[articleDict objectForKey:@"kissNum"]];
        NSString * userId =[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
        if ([userId isEqualToString:[UserInfoData getUserInfoFromArchive].userId]) {
            bottomView.zuiIV.image = IMAGE(@"zuichun_fen");
        }else{
            bottomView.zuiIV.image = IMAGE(@"zuichun");
        }
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)nearbyZuiButtonClicked:(UIButton *)button{
    NSDictionary *articleDict=self.bigArticleArray[button.tag];
    NSLog(@"articleDict===%@",articleDict);
    NSString * userId =[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
    if ([userId isEqualToString:[UserInfoData getUserInfoFromArchive].userId]) {
        [self.view makeToast:@"亲，不能嘴自己的哟！" duration:1.0];
        return;
    }
    if ([articleDict objectForKey:@"name"]==nil) {
        [self.view makeToast:@"暂不能发送红包给该用户" duration:1.0];
        return;
    }else{
        RedEnvelopeSendViewController * vc = [[RedEnvelopeSendViewController alloc]init];
        vc.type = @"1";
        vc.objId = [articleDict objectForKey:@"id"];
        vc.scanMobile = [articleDict objectForKey:@"name"];
        vc.placeHolder = [articleDict objectForKey:@"title"];
        vc.isMouth = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

//        RedEnvelopeListViewController * vc = [[RedEnvelopeListViewController alloc]init];
//        vc.objId = [articleDict objectForKey:@"id"];
//        vc.type = @"1";
//        vc.phoneNum =[articleDict objectForKey:@"name"];
//        vc.hidesBottomBarWhenPushed = YES;
//        //vc.scanMobile = @"185390129058";
//        [self.navigationController pushViewController:vc animated:YES];
    }

}
#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
    NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
    NSString *iscollect=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"iscollect"]];
    //跳转详情界面
    DynamicDetailViewController *vc=[[DynamicDetailViewController alloc]init];
    //        vc.articleDict=articleDict;
    vc.isLinLiVC=YES;
    vc.articleId=articleId;
    vc.iscollect=iscollect;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(100))];
        headView.backgroundColor=COLOR_WHITE;
        
        UIImageView *bgIV=[[UIImageView alloc]initWithFrame:headView.frame];
        bgIV.image=IMAGE(@"beijing_linliquan");
        [headView addSubview:bgIV];
        
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
        
        UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(70), WZ(70))];
        headBtn.layer.borderColor=COLOR(255, 163, 173, 1).CGColor;
        headBtn.layer.borderWidth=2.0;
        headBtn.layer.cornerRadius=headBtn.width/2.0;
        headBtn.clipsToBounds=YES;
        [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
//        [headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:headBtn];
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
        [headView addSubview:nameLabel];
        self.nameLabel=nameLabel;
        
        NSString *signString=self.user.sign;
        CGSize signSize=[ViewController sizeWithString:signString font:FONT(15,13) maxSize:CGSizeMake(WZ(250), WZ(40))];
        UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, signSize.width, WZ(40))];
        signLabel.text=signString;
        signLabel.textColor=COLOR_WHITE;
        signLabel.font=FONT(15,13);
        signLabel.numberOfLines=2;
        [headView addSubview:signLabel];
        self.signLabel=signLabel;
        
        UIButton *userInfoBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headView.width, headView.height)];
        userInfoBtn.backgroundColor=COLOR_CLEAR;
        [userInfoBtn addTarget:self action:@selector(userInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:userInfoBtn];
        
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
    NSInteger isTop=[[articleDict objectForKey:@"istop"] integerValue];
    
    if (isTop==1)
    {
        return WZ(35);
    }
    else
    {
        NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(45))];
        CGSize openSize=[ViewController sizeWithString:@"收起图片" font:FONT(13,11) maxSize:CGSizeMake(WZ(100), WZ(20))];
        
        UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(60+20)+WZ(10), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(45)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
        contentLabel.numberOfLines=2;
        UIButton *openBtn=[[UIButton alloc]initWithFrame:CGRectMake(contentLabel.left, contentLabel.bottom+WZ(5), openSize.width, WZ(20))];
        
        NSArray *contentImageArray=[[articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
        
        if (contentImageArray.count>0)
        {
            if (contentImageArray.count==1)
            {
                TapImageView *contentImageBtn=[[TapImageView alloc]init];
                contentImageBtn.t_delegate =self;
                contentImageBtn.frame=CGRectMake(WZ(15), openBtn.bottom+WZ(10), WZ(250), WZ(250));
                self.contentImageBtn0=contentImageBtn;
            }
            else
            {
                for (NSInteger i=0; i<contentImageArray.count; i++)
                {
                    TapImageView *contentImageBtn=[[TapImageView alloc]init];
                    contentImageBtn.t_delegate =self;
                    contentImageBtn.frame=CGRectMake(WZ(15)+WZ(110+7)*(i%3), openBtn.bottom+WZ(10)+WZ(110+7)*(i/3), WZ(110), WZ(110));
                    
                    self.contentImageBtn0=contentImageBtn;
                }
            }
            
            if ([self.isOpenArray[indexPath.row] isEqualToString:@"0"])
            {
                //是收起状态
                return openBtn.bottom+WZ(30);
            }
            else
            {
                //是展开状态
                return self.contentImageBtn0.bottom+WZ(30);
            }
        }
        else
        {
            return contentLabel.bottom+WZ(30);
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return WZ(100);
    }
    return 0;
}







#pragma mark ===点击按钮的方法
//选择地区
-(void)rightBtnClick
{
    [self createAddressView];
}
//搜索
-(void)leftBtnClick{
    StoreSearchViewController *vc = [[StoreSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}
//地区选择界面
-(void)createAddressView
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view.window addSubview:bgView];
    self.bgView=bgView;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgView)];
    [bgView addGestureRecognizer:tap];
    
    CGFloat height=WZ(45);
    
    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(WZ(60), WZ(120), SCREEN_WIDTH-WZ(60*2), height*(self.addressIdArray.count+1))];
    smallView.backgroundColor=COLOR_WHITE;
    [bgView addSubview:smallView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), 0, smallView.width-WZ(10*2), height)];
//    titleLabel.backgroundColor=COLOR_CYAN;
    titleLabel.text=@"请选择";
    titleLabel.font=FONT(15, 13);
    [smallView addSubview:titleLabel];
    
    for (NSInteger i=0; i<self.addressArray.count; i++)
    {
        UIButton *addressBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, titleLabel.bottom+height*i, smallView.width, height)];
        addressBtn.tag=i;
        addressBtn.titleLabel.font=FONT(15, 13);
        [addressBtn setTitle:self.addressArray[i] forState:UIControlStateNormal];
        [addressBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        [addressBtn addTarget:self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:addressBtn];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, addressBtn.top, smallView.width, 1)];
        lineView.backgroundColor=COLOR_HEADVIEW;
        [smallView addSubview:lineView];
    }
    
}

//点击展开关闭图片
-(void)openBtnClick:(UIButton*)button
{
    if (button.selected==NO)
    {
        [self.isOpenArray replaceObjectAtIndex:button.tag withObject:@"1"];
    }
    if (button.selected==YES)
    {
        [self.isOpenArray replaceObjectAtIndex:button.tag withObject:@"0"];
    }
    
    [_tableView beginUpdates];
    [_tableView reloadData];
    [_tableView endUpdates];
}

//加好友
-(void)addFriendBtnClick:(UHVAddFriendBtn*)button
{
    NSDictionary *dict=button.dict;
    NSString *createUserId=[dict objectForKey:@"createuser"];
    
    [HTTPManager addFriendRequestWithUserId:[UserInfoData getUserInfoFromArchive].userId toUserId:createUserId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view makeToast:@"已发送好友请求" duration:1.0];
        }
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"msg"] duration:1.0];
        }
    }];
    
//    BOOL ifArea=[ViewController ifRegisterArea];
//    if (ifArea==YES)
//    {
//        
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//    }
}

//帖子点赞
-(void)aiticlePraiseBtnClick:(UIButton*)button
{
    NSMutableDictionary *articleDict=self.bigArticleArray[button.tag];
    NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
    
    [HTTPManager addPraiseWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" objectId:articleId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [button setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
            
            UITableViewCell *cell = [_tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:2]];
            ArticleBottomView *bottomView=[cell viewWithTag:1000];
            ArticlePraiseLabel *praiseLabel=[bottomView viewWithTag:10000];
            praiseLabel.text=[NSString stringWithFormat:@"%ld",[[articleDict objectForKey:@"praisecount"] integerValue]+1];
            
            [articleDict setValue:@"1" forKey:@"isLike"];
            NSInteger praisecount=[[articleDict objectForKey:@"praisecount"] integerValue];
            [articleDict setValue:[NSString stringWithFormat:@"%ld",praisecount+1] forKey:@"praisecount"];
            
            [_tableView reloadData];
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:1.0];
        }
    }];
    
//    BOOL ifArea=[ViewController ifRegisterArea];
//    if (ifArea==YES)
//    {
//
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//    }
    
    
    
}

//点击图片全屏浏览

- (void) tappedWithObject:(id) sender{
    TapImageView * imageView =(TapImageView *) sender;
    NSMutableArray *urlArray=[NSMutableArray array];
    for (NSInteger i=0; i<imageView.imageBtnArray.count; i++)
    {
        NSString *url=imageView.imageBtnArray[i];
        if ([url containsString:@"_500"])
        {
            url=[url stringByReplacingOccurrencesOfString:@"_500" withString:@""];
        }
        
        [urlArray addObject:url];
    }
    
    _isShowBigImage = YES;
    
    [ViewController photoBrowserWithImages:urlArray photoIndex:imageView.tag];
}
//-(void)contentImageBtnClick:(NearbyImageBtn*)button
//{
//    NSLog(@"点击的图片tag值===%ld",(long)button.tag);
//   
//}

//地区选择
-(void)addressBtnClick:(UIButton*)button
{
    self.address=[NSString stringWithFormat:@"%@V",self.addressArray[button.tag]];
    [self.rightBtn setTitle:self.address forState:UIControlStateNormal];
    
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
    }
    
    if (button.tag==0)
    {
        //全国id为0
        self.addressId=@"0";
    }
    else
    {
        //取出省市区的id
        self.addressId=[NSString stringWithFormat:@"%@",self.addressIdArray[button.tag]];
    }
    
    [self getNearbyListWithAddressId:self.addressId];
}

//串门
-(void)goBtnClick:(UIButton*)button
{
    NSDictionary *articleDict=self.bigArticleArray[button.tag];
    NSString *areaId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"areaId"]];
    NSString *areaName=[articleDict objectForKey:@"areaName"];
    
//    SquareViewController *vc=[[SquareViewController alloc]init];
//    vc.isNearbyVC=YES;
//    vc.nearbyAreaId=areaId;
//    vc.nearbyAreaName=areaName;
//    [self.navigationController pushViewController:vc animated:NO];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"YES",@"isNearbyVC",areaId,@"areaId",areaName,@"areaName", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nearby" object:nil userInfo:dict];
    
    self.tabBarController.selectedIndex=2;
}

//点击跳转用户信息修改界面
-(void)userInfoBtnClick
{
    MyselfInfoViewController *vc=[[MyselfInfoViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击关闭地区选择界面
-(void)removeBgView
{
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
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

//@implementation NearbyImageBtn
//
//@synthesize imageBtnArray;
//
//@end
