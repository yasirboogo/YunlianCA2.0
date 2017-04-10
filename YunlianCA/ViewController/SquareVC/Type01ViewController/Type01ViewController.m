//
//  Type01ViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "Type01ViewController.h"

#import "DynamicDetailViewController.h"
#import "AdViewController.h"
#import "RedEnvelopeSendViewController.h"
#import "RedEnvelopeListViewController.h"
#import "SVProgressHUD.h"
@class ArticlePraiseLabel;

#define TOP_SV_HEIGHT WZ(35)

@interface Type01ViewController ()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    UIScrollView *_topScrollView;
    
    CGFloat _buttonWidth;
    UIView *_lineView;
    UIView *_topView;
}

@property(nonatomic,strong)ImagePlayerView *playerView;
@property(nonatomic,strong)Model *adModel;
//@property(nonatomic,strong)Model *articleModel;
@property(nonatomic,strong)Model *firstModel;
@property(nonatomic,strong)UIButton *contentImageBtn;
@property(nonatomic,strong)UIButton *contentImageBtn0;
@property(nonatomic,strong)NSString *moduleId;
@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,assign)NSInteger titleCount;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,assign)NSInteger buttonIndex;

@property(nonatomic,strong)NSMutableArray *bigArticleArray;
@property(nonatomic,strong)NSMutableArray *bigArticleIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@property(nonatomic,strong)NSMutableArray *isOpenArray;


@end

@implementation Type01ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.buttonIndex=0;
    self.titleCount=0;
    self.topBtnArray=[NSMutableArray array];
    self.bigArticleArray=[NSMutableArray array];
    self.bigArticleIdArray=[NSMutableArray array];
    self.isOpenArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    
    NSLog(@"模块儿信息===%@",self.moduleDict);
    
}

////获取文章列表
//-(void)getArticleListWithModuleId:(NSString*)moduleId
//{
//    [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:moduleId pxType:@"zxfb" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
//        
//        for (NSDictionary *dict in model.articleListArray)
//        {
//            NSMutableDictionary *articleDict=[NSMutableDictionary dictionaryWithDictionary:dict];
//            NSString *articleId=[articleDict objectForKey:@"id"];
//            
//            if (![self.bigArticleIdArray containsObject:articleId])
//            {
//                [self.bigArticleIdArray addObject:articleId];
//                [self.bigArticleArray addObject:articleDict];
//            }
//        }
//        
//        //结束刷新
//        [_tableView headerEndRefreshing];
//        [_tableView reloadData];
//    }];
//}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    if (self.buttonIndex==0)
    {
        [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:[self.moduleDict objectForKey:@"id"] pxType:@"zxfb" pageNum:@"1" pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
            [SVProgressHUD dismiss];
            self.firstModel=model;
            
            self.titleArray=[NSMutableArray array];
            for (NSInteger i=0; i<model.smallModuleArray.count; i++)
            {
                NSString *title=[model.smallModuleArray[i] objectForKey:@"name"];
                [self.titleArray addObject:title];
            }
            
            self.titleCount=self.titleArray.count;
            if (self.titleCount>0)
            {
                NSDictionary *moduleDict=[model.smallModuleArray firstObject];
                self.moduleId=[moduleDict objectForKey:@"id"];
//                NSLog(@"第一个子栏目id===%@",self.moduleId);
            }
            else
            {
                self.moduleId=[self.moduleDict objectForKey:@"id"];
            }
            
//            NSLog(@"文章数量===%ld\n按钮数量===%ld",self.bigArticleArray.count,self.isOpenArray.count);
            
//            if (self.bigArticleArray.count!=self.isOpenArray.count)
//            {
//                [self.isOpenArray removeAllObjects];
//            }
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
            
            //结束刷新
            [_tableView headerEndRefreshing];
            [_tableView reloadData];
        }];
    }
    else
    {
        NSDictionary *moduleDict=self.firstModel.smallModuleArray[self.buttonIndex];
        self.moduleId=[moduleDict objectForKey:@"id"];
        [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:self.moduleId pxType:@"zxfb" pageNum:@"1" pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
            if (model.articleListArray.count>0)
            {
                [SVProgressHUD dismiss];
                NSLog(@"文章数量===%ld\n按钮数量===%ld",self.bigArticleArray.count,self.isOpenArray.count);
//                if (self.bigArticleArray.count!=self.isOpenArray.count)
//                {
//                    [self.isOpenArray removeAllObjects];
//                }
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
                        [self.isOpenArray addObject:@"0"];
                    }
                }
                //结束刷新
                [_tableView headerEndRefreshing];
                [_tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    
    //广告列表
    [HTTPManager getAdWithModuleId:[self.moduleDict objectForKey:@"id"] pageNum:@"1" pageSize:@"4" complete:^(Model *model) {
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
    
    //    [_playerView startTimer];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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



-(void)createNavigationBar
{
    self.title=[self.moduleDict objectForKey:@"name"];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(70), WZ(10), WZ(70), WZ(25))];
//    rightView.backgroundColor=COLOR_GREEN;
    
    UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(28), WZ(25))];
    [fabuBtn setBackgroundImage:IMAGE(@"fabutiezi") forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(fabuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:fabuBtn];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(25), 0, WZ(25), WZ(25))];
    [searchBtn setBackgroundImage:IMAGE(@"sousuo_hei") forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchBtn];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
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
    if (self.buttonIndex==0)
    {
        [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:[self.moduleDict objectForKey:@"id"] pxType:@"zxfb" pageNum:@"1" pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
            
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
            
            //结束刷新
            [_tableView headerEndRefreshing];
            [_tableView reloadData];
        }];
    }
    else
    {
        NSDictionary *moduleDict=self.firstModel.smallModuleArray[self.buttonIndex];
        self.moduleId=[moduleDict objectForKey:@"id"];
        
        [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:self.moduleId pxType:@"zxfb" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
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
                
                //结束刷新
                [_tableView headerEndRefreshing];
//                [_tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
                [_tableView reloadData];
            }
        }];
    }
}

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    if (self.buttonIndex==0)
    {
        [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:[self.moduleDict objectForKey:@"id"] pxType:@"zxfb" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
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
                
                //结束刷新
                [_tableView footerEndRefreshing];
                [_tableView reloadData];
            }
        }];
    }
    else
    {
        NSDictionary *moduleDict=self.firstModel.smallModuleArray[self.buttonIndex];
        self.moduleId=[moduleDict objectForKey:@"id"];
        
        [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:self.moduleId pxType:@"zxfb" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
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
                
                //结束刷新
                [_tableView footerEndRefreshing];
//                [_tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
                [_tableView reloadData];
            }
        }];
    }
    
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    if (section==1)
    {
        return 0;
    }
    else
    {
        return self.bigArticleArray.count;
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
        
        [cell.contentView addSubview:self.playerView];
        
//        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(150)-WZ(40), SCREEN_WIDTH, WZ(40))];
//        titleView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
//        [cell.contentView addSubview:titleView];
//        
//        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, titleView.width-WZ(15*2), titleView.height)];
//        titleLabel.text=@"夏威夷考艾岛的漩涡";
//        titleLabel.textColor=COLOR_WHITE;
//        titleLabel.backgroundColor=COLOR_CLEAR;
//        titleLabel.font=FONT(17,15);
//        [titleView addSubview:titleLabel];
//        
//        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(150))];
//        imageView.image=IMAGE(@"test_ad01");
//        [cell.contentView addSubview:imageView];
        
        
        
        cell.backgroundColor=COLOR(241, 241, 241, 1);
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
        
        UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(30), WZ(20))];
        zhidingLabel.text=@"置顶";
        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
        zhidingLabel.textColor=COLOR_WHITE;
        zhidingLabel.font=FONT(11,9);
        zhidingLabel.textAlignment=NSTextAlignmentCenter;
        zhidingLabel.layer.cornerRadius=3;
        zhidingLabel.clipsToBounds=YES;
        [cell.contentView addSubview:zhidingLabel];
        
        NSArray *biaotiArray=[[NSArray alloc]initWithObjects:@"云联社区网址大全",@"云联社区常备聚会地点", nil];
        
        UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(zhidingLabel.right+WZ(10), 0, SCREEN_WIDTH-zhidingLabel.right-WZ(10+15), WZ(50))];
        biaotiLabel.backgroundColor=COLOR_WHITE;
        biaotiLabel.text=biaotiArray[indexPath.row];
        [cell.contentView addSubview:biaotiLabel];
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
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
            headView.lineView.hidden=YES;
            headView.addressLabel.hidden=YES;
            headView.goBtn.hidden=YES;
            
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
            
            NSString *createUser=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
            if ([createUser isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
            {
                headView.addFriendBtn.hidden=YES;
            }
            else
            {
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
                    Type01ImageBtn *contentImageBtn=[Type01ImageBtn buttonWithType:UIButtonTypeCustom];
                    contentImageBtn.frame=CGRectMake(WZ(15), openBtn.bottom+WZ(10), WZ(250), WZ(250));
                    contentImageBtn.imageBtnArray=contentImageArray;
                    [contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                    //                [contentImageBtn setContentMode:UIViewContentModeCenter];
                    //                contentImageBtn.imageView.contentMode=UIViewContentModeCenter;
                    //                contentImageBtn.clipsToBounds=YES;
                    [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
                        Type01ImageBtn *contentImageBtn=[Type01ImageBtn buttonWithType:UIButtonTypeCustom];
                        contentImageBtn.frame=CGRectMake(WZ(15)+WZ(110+7)*(i%3), openBtn.bottom+WZ(10)+WZ(110+7)*(i/3), WZ(110), WZ(110));
                        contentImageBtn.imageBtnArray=contentImageArray;
                        contentImageBtn.tag=i;
                        [contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,contentImageArray[i]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                        //                    [contentImageBtn setContentMode:UIViewContentModeCenter];
                        //                    contentImageBtn.imageView.contentMode=UIViewContentModeCenter;
                        //                    contentImageBtn.clipsToBounds=YES;
                        [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
            [bottomView.zuiBtn addTarget:self action:@selector(aiticleZuiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            bottomView.zuiLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"kissNum"]==nil?@"0":[articleDict objectForKey:@"kissNum"]];
            NSString * userId =[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
            if ([userId isEqualToString:[UserInfoData getUserInfoFromArchive].userId]) {
                bottomView.zuiIV.image = IMAGE(@"zuichun_fen");
            }else{
                bottomView.zuiIV.image = IMAGE(@"zuichun");
            }
//            if ([[articleDict objectForKey:@"isAdmin"] boolValue]) {
//                headView.addFriendBtn.hidden = YES;
////                bottomView.zuiBtn.hidden = YES;
////                bottomView.zuiIV.hidden = YES;
////                bottomView.zuiLabel.hidden = YES;
//            }else{
////                bottomView.zuiBtn.hidden = NO;
////                bottomView.zuiIV.hidden = NO;
////                bottomView.zuiLabel.hidden = NO;
//                headView.addFriendBtn.hidden = NO;
//            }
        }
        
//        NSLog(@"文章字典===%@",articleDict);
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
//亲嘴button
-(void)aiticleZuiButtonClicked:(UIButton *)button{
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
        //vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

//        RedEnvelopeListViewController * vc = [[RedEnvelopeListViewController alloc]init];
//        vc.objId = [articleDict objectForKey:@"id"];
//        vc.phoneNum = [articleDict objectForKey:@"name"];
//        vc.type = @"1";
//        //vc.scanMobile = @"185390129058";
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
}
#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        //点击广告图跳转
        
        
        
    }
    if (indexPath.section==2)
    {
        NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
        NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
        NSString *iscollect=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"iscollect"]];
        //跳转详情界面
        DynamicDetailViewController *vc=[[DynamicDetailViewController alloc]init];
//        vc.articleDict=articleDict;
        vc.isLinLiVC=NO;
        vc.articleId=articleId;
        vc.iscollect=iscollect;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
//        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(35))];
//        aView.backgroundColor=COLOR_WHITE;
//        
//        CGSize paixuBtnSize=[ViewController sizeWithString:@"智能排序" font:FONT(13,11) maxSize:CGSizeMake(WZ(150),aView.height)];
//        
//        UIButton *paixuBtn=[[UIButton alloc]initWithFrame:CGRectMake(aView.width-WZ(15)-paixuBtnSize.width, 0, paixuBtnSize.width, aView.height)];
//        [paixuBtn setTitle:@"智能排序" forState:UIControlStateNormal];
//        [paixuBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
//        paixuBtn.titleLabel.font=FONT(13,11);
//        [paixuBtn addTarget:self action:@selector(paixuBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [aView addSubview:paixuBtn];
//        
//        UIImageView *paixuIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-paixuBtn.width-WZ(15)-WZ(5)-WZ(15), WZ(10), WZ(15), WZ(15))];
//        paixuIV.image=IMAGE(@"zhinengpaixu");
//        [aView addSubview:paixuIV];
        
        return nil;
    }
    if (section==2)
    {
        if (!_topView)
        {
            _topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_SV_HEIGHT)];
            _topView.backgroundColor=COLOR_HEADVIEW;
            
            //        NSLog(@"self.titleCount===%ld",(long)self.titleCount);
            
            if (self.titleCount<=4)
            {
                _buttonWidth=(SCREEN_WIDTH-WZ(15*2))/self.titleCount;
            }
            if (self.titleCount>=4)
            {
                _buttonWidth=WZ(86.25);
            }
            
            _topScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _topView.width, _topView.height)];
            _topScrollView.delegate=self;
            //        _topScrollView.backgroundColor=COLOR_WHITE;
            [_topView addSubview:_topScrollView];
            
            //CGRectMake(WZ(15)+width+(WZ(30)+(_buttonWidth-WZ(30)))*button.tag, TOP_SV_HEIGHT-WZ(5), WZ(30), 1)
            CGFloat width=(_buttonWidth-WZ(30))/2.0;
            _lineView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15)+width+(WZ(30)+(_buttonWidth-WZ(30)))*self.buttonIndex, TOP_SV_HEIGHT-WZ(5), WZ(30), 1)];
            _lineView.backgroundColor=COLOR_RED;
            [_topScrollView addSubview:_lineView];
            
            if (self.titleCount<=4)
            {
                _topScrollView.contentSize=CGSizeMake(_topView.width, _topView.height);
            }
            if (self.titleCount>=4)
            {
                _topScrollView.contentSize=CGSizeMake(_buttonWidth*self.titleCount+WZ(15*2), _topView.height);
            }
            
            for (NSInteger i=0; i<self.titleCount; i++)
            {
                UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)+_buttonWidth*i, 0, _buttonWidth, TOP_SV_HEIGHT)];
                topBtn.tag=i;
                topBtn.titleLabel.font=FONT(15, 13);
                [topBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
                [topBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_topScrollView addSubview:topBtn];
                [self.topBtnArray addObject:topBtn];
                
                if (i==self.buttonIndex)
                {
                    [topBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
                }
            }
        }
//        NSLog(@"顶部子栏目===%@",self.topBtnArray);
        
        return _topView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(185);
    }
    if (indexPath.section==1)
    {
        return WZ(50);
    }
    else
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
                    Type01ImageBtn *contentImageBtn=[Type01ImageBtn buttonWithType:UIButtonTypeCustom];
                    contentImageBtn.frame=CGRectMake(WZ(15), openBtn.bottom+WZ(10), WZ(250), WZ(250));
                    self.contentImageBtn0=contentImageBtn;
                }
                else
                {
                    for (NSInteger i=0; i<contentImageArray.count; i++)
                    {
                        Type01ImageBtn *contentImageBtn=[Type01ImageBtn buttonWithType:UIButtonTypeCustom];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        //return WZ(35);
        return 0;
    }
    if (section==2)
    {
        if (self.titleCount>0)
        {
            return TOP_SV_HEIGHT;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
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
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ===点击按钮的方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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

//发布新鲜事儿
-(void)fabuBtnClick
{
    NSLog(@"发布新鲜事儿");
    
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        EditNewArticleViewController *vc=[[EditNewArticleViewController alloc]init];
//        vc.moduleId=self.moduleId;
        vc.lanmuCount=self.titleCount;
        vc.moduleDict=self.moduleDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

//搜索帖子
-(void)searchBtnClick
{
//    NSLog(@"搜索帖子");
//    NSString *moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
    ArticleSearchViewController *searchVC=[[ArticleSearchViewController alloc]init];
    searchVC.moduleId=self.moduleId;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//切换子栏目
-(void)topBtnClick:(UIButton*)button
{
    self.buttonIndex=button.tag;
    for (UIButton *btn in self.topBtnArray)
    {
        if (button.tag==btn.tag)
        {
            [button setTitleColor:COLOR_RED forState:UIControlStateNormal];
            CGFloat width=(_buttonWidth-WZ(30))/2.0;
            _lineView.frame=CGRectMake(WZ(15)+width+(WZ(30)+(_buttonWidth-WZ(30)))*button.tag, TOP_SV_HEIGHT-WZ(5), WZ(30), 1);
            
//            [UIView animateWithDuration:0.3 animations:^{
//                
//            } completion:^(BOOL finished) {
//                
//            }];
        }
        else
        {
            [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
    }
    
    
    
    NSDictionary *moduleDict=self.firstModel.smallModuleArray[button.tag];
    self.moduleId=[moduleDict objectForKey:@"id"];
    
    [HTTPManager getArticleListWithUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:self.moduleId pxType:@"zxfb" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" areaId:self.areaId keyword:nil complete:^(Model *model) {
        
        self.pageNum=1;
        [self.bigArticleArray removeAllObjects];
        [self.bigArticleIdArray removeAllObjects];
        
        for (NSDictionary *dict in model.articleListArray)
        {
            NSMutableDictionary *articleDict=[NSMutableDictionary dictionaryWithDictionary:dict];
            NSString *articleId=[articleDict objectForKey:@"id"];
            
            if (![self.bigArticleIdArray containsObject:articleId])
            {
                [self.bigArticleIdArray addObject:articleId];
                [self.bigArticleArray addObject:articleDict];
            }
        }
        
        [_tableView reloadData];
//        [_tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
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

//智能排序
-(void)paixuBtnClick
{
    NSLog(@"智能排序");
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"最近发表",@"最近回复",@"近期最热",@"全网最热", nil];
    [sheet showInView:self.view];
}

//排序
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        NSLog(@"最近发表");
    }
    if (buttonIndex==1)
    {
        NSLog(@"最近回复");
    }
    if (buttonIndex==2)
    {
        NSLog(@"近期最热");
    }
    else
    {
        NSLog(@"全网最热");
    }
}



- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews)
    {
        if ([subViwe isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
    }
}

//点击图片全屏浏览
-(void)contentImageBtnClick:(Type01ImageBtn*)button
{
    NSLog(@"点击的图片tag值===%ld",(long)button.tag);
    NSMutableArray *urlArray=[NSMutableArray array];
    for (NSInteger i=0; i<button.imageBtnArray.count; i++)
    {
        NSString *url=button.imageBtnArray[i];
        if ([url containsString:@"_500"])
        {
            url=[url stringByReplacingOccurrencesOfString:@"_500" withString:@""];
        }
        
        [urlArray addObject:url];
    }
    
//    NSLog(@"urlArray===%@",urlArray);
    
    [ViewController photoBrowserWithImages:urlArray photoIndex:button.tag];
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

@implementation Type01ImageBtn

@synthesize imageBtnArray;

@end



