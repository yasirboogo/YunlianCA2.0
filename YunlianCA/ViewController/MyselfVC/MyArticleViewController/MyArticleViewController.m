//
//  MyArticleViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/15.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyArticleViewController.h"

#import "DynamicDetailViewController.h"

@interface MyArticleViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_bottomView;
    UIButton *_deleteBtn;
    UIButton *_editBtn;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)UIButton *contentImageBtn;
@property(nonatomic,strong)UIButton *contentImageBtn0;
@property(nonatomic,strong)NSString *deleteString;
@property(nonatomic,strong)NSMutableArray *deleteArticleArray;

@property(nonatomic,strong)NSMutableArray *bigArticleArray;
@property(nonatomic,strong)NSMutableArray *bigArticleIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@property(nonatomic,strong)NSString *articleIdsString;

@end

@implementation MyArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigArticleArray=[NSMutableArray array];
    self.bigArticleIdArray=[NSMutableArray array];
    
    self.articleIdsString=@"";
    self.deleteString=@"删除(0)";
    self.deleteArticleArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    [self createBottomView];
    
    if (self.userId==nil || [self.userId isEqualToString:@""])
    {
        self.userId=[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId];
    }
    
    
    
    
}

-(void)getMyArticles
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    //我的发文列表
    [HTTPManager getMyArticleListWithUserId:self.userId pageNum:@"1" pageSize:@"20" complete:^(ArticleModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (model.articleArray.count>0)
            {
//                self.articleModel=model;
                NSMutableArray *articleArray=model.articleArray;
                
                for (NSDictionary *articleDict in articleArray)
                {
                    NSString *articleId=[articleDict objectForKey:@"id"];
                    
                    if (![self.bigArticleIdArray containsObject:articleId])
                    {
                        [self.bigArticleIdArray addObject:articleId];
                        [self.bigArticleArray addObject:articleDict];
                    }
                }
                
                [_tableView reloadData];
                [hud hide:YES];
            }
            else
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无发文~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
                [hud hide:YES];
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    self.articleIdsString=@"";
    [self getMyArticles];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"我的发文";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    if (self.userId==nil || [self.userId isEqualToString:@""])
    {
        _editBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.titleLabel.font=FONT(17, 15);
        
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
        self.navigationItem.rightBarButtonItem=rightItem;
    }
}

-(void)createBottomView
{
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(50), SCREEN_WIDTH, WZ(50))];
    _bottomView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_bottomView];
    _bottomView.hidden=YES;
    
    _deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _bottomView.width, _bottomView.height)];
    [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:COLOR(254, 167, 173, 1) forState:UIControlStateNormal];
    _deleteBtn.backgroundColor=COLOR_WHITE;
    _deleteBtn.titleLabel.font=FONT(17, 15);
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_deleteBtn];
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.allowsMultipleSelectionDuringEditing=YES;
    _tableView.tintColor=COLOR(254, 167, 173, 1);
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    self.articleIdsString=@"";
    _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _bottomView.hidden=YES;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    //下拉刷新的时候 清空文章数组
    [self.deleteArticleArray removeAllObjects];
    self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
    [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
    [_tableView setEditing:NO animated:NO];
    
    
    [HTTPManager getMyArticleListWithUserId:self.userId pageNum:@"1" pageSize:@"20" complete:^(ArticleModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (model.articleArray.count>0)
            {
                NSMutableArray *articleArray=model.articleArray;
                
                for (NSDictionary *articleDict in articleArray)
                {
                    NSString *articleId=[articleDict objectForKey:@"id"];
                    
                    if (![self.bigArticleIdArray containsObject:articleId])
                    {
                        [self.bigArticleIdArray addObject:articleId];
                        [self.bigArticleArray addObject:articleDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            
            //结束刷新
            [_tableView headerEndRefreshing];
            [_tableView reloadData];
        }
    }];
    
}

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    self.articleIdsString=@"";
    _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _bottomView.hidden=YES;
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    //上拉加载的时候 清空文章数组
    [self.deleteArticleArray removeAllObjects];
    self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
    [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
    [_tableView setEditing:NO animated:NO];
    
    
    [HTTPManager getMyArticleListWithUserId:self.userId pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(ArticleModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (model.articleArray.count>0)
            {
                NSMutableArray *articleArray=model.articleArray;
                
                for (NSDictionary *articleDict in articleArray)
                {
                    NSString *articleId=[articleDict objectForKey:@"id"];
                    
                    if (![self.bigArticleIdArray containsObject:articleId])
                    {
                        [self.bigArticleIdArray addObject:articleId];
                        [self.bigArticleArray addObject:articleDict];
                    }
                }
                
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
            
            //结束加载
            [_tableView footerEndRefreshing];
            [_tableView reloadData];
        }
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
    NSString *viewCount=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"browsecount"]];
    NSString *commentNum=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"commentNum"]];
    NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *createTime=[articleDict objectForKey:@"createtime"];
//    NSString *userId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
//    NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
    NSString *imgs=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"imgs"]];
    NSArray *imagesUrlArray=[imgs componentsSeparatedByString:@","];
//    NSString *isTop=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"istop"]];
//    NSString *moduleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"moduleId"]];
    NSString *praiseCount=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"praisecount"]];
    NSString *title=[[articleDict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *userHeadImg=[articleDict objectForKey:@"userHeadImg"];
    NSString *userName=[[articleDict objectForKey:@"userName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
    [cell.contentView addSubview:headView];
    headView.lineView.hidden=YES;
    headView.addressLabel.hidden=YES;
    headView.goBtn.hidden=YES;
    headView.addFriendBtn.hidden=YES;
    
    NSString *imgUrlString=userHeadImg;
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,userHeadImg]];
    }
    [headView.headImageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    headView.nameLabel.text=userName;
    headView.timeLabel.text=createTime;
    
//    UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, WZ(30), WZ(20))];
//    zhidingLabel.text=@"置顶";
//    zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
//    zhidingLabel.textColor=COLOR_WHITE;
//    zhidingLabel.font=FONT(11,9);
//    zhidingLabel.textAlignment=NSTextAlignmentCenter;
//    zhidingLabel.layer.cornerRadius=3;
//    zhidingLabel.clipsToBounds=YES;
//    [cell.contentView addSubview:zhidingLabel];
    
    UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, SCREEN_WIDTH-WZ(15*2), WZ(20))];
    //        biaotiLabel.backgroundColor=COLOR_CYAN;
    biaotiLabel.text=title;
    [cell.contentView addSubview:biaotiLabel];
    
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100))];
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), biaotiLabel.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
    contentLabel.text=content;
    contentLabel.font=FONT(15, 13);
    contentLabel.numberOfLines=0;
    [cell.contentView addSubview:contentLabel];
    
    if (imagesUrlArray.count>0)
    {
        if (imagesUrlArray.count==1)
        {
            MyArticleImageBtn *contentImageBtn=[[MyArticleImageBtn alloc]initWithFrame:CGRectMake(WZ(15), contentLabel.bottom+WZ(15), WZ(250), WZ(250))];
            contentImageBtn.imageBtnArray=imagesUrlArray;
            [contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[imagesUrlArray firstObject]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
            contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
            [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:contentImageBtn];
            self.contentImageBtn=contentImageBtn;
        }
        else
        {
            for (NSInteger i=0; i<imagesUrlArray.count; i++)
            {
                NSString *imgUrl=imagesUrlArray[i];
                MyArticleImageBtn *contentImageBtn=[[MyArticleImageBtn alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
                contentImageBtn.tag=i;
                contentImageBtn.imageBtnArray=imagesUrlArray;
                [contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrl]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
                [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:contentImageBtn];
                self.contentImageBtn=contentImageBtn;
            }
        }
    }
    
    ArticleBottomView *bottomView=[[ArticleBottomView alloc]init];
    if (imagesUrlArray.count>0)
    {
        bottomView.frame=CGRectMake(0, self.contentImageBtn.bottom, SCREEN_WIDTH, WZ(45));
    }
    else
    {
        bottomView.frame=CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(45));
    }
//    bottomView.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:bottomView];
    
    bottomView.pageViewLabel.text=viewCount;
    bottomView.praiseLabel.text=praiseCount;
    bottomView.commentLabel.text=commentNum;
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing==NO)
    {
        NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
        NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
        NSString *iscollect=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"iscollect"]];
        //跳转详情界面
        DynamicDetailViewController *vc=[[DynamicDetailViewController alloc]init];
        //    vc.articleDict=articleDict;
        vc.isLinLiVC=NO;
        vc.articleId=articleId;
        vc.iscollect=iscollect;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (tableView.isEditing==YES)
    {
        NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
        [self.deleteArticleArray addObject:articleDict];
        
        self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
        [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
        
//        NSLog(@"选择的帖子列表(选中)===%@",self.deleteArticleArray);
    }
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing==YES)
    {
        NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
        [self.deleteArticleArray removeObject:articleDict];
        
        self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
        [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
//        NSLog(@"选择的帖子列表(取消选中)===%@",self.deleteArticleArray);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
    NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *imgs=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"imgs"]];
    NSArray *imagesUrlArray=[imgs componentsSeparatedByString:@","];
    
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100))];
    
    UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70+20)+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
    
    if (imagesUrlArray.count>0)
    {
        if (imagesUrlArray.count==1)
        {
            MyArticleImageBtn *contentImageBtn=[[MyArticleImageBtn alloc]initWithFrame:CGRectMake(WZ(15), contentLabel.bottom+WZ(15), WZ(250), WZ(250))];
            self.contentImageBtn0=contentImageBtn;
        }
        else
        {
            for (NSInteger i=0; i<imagesUrlArray.count; i++)
            {
                MyArticleImageBtn *contentImageBtn=[[MyArticleImageBtn alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
                self.contentImageBtn0=contentImageBtn;
            }
        }
        
        return self.contentImageBtn0.bottom+WZ(45);
    }
    else
    {
        return contentLabel.bottom+WZ(45);
    }
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑
-(void)editBtnClick:(UIButton*)button
{
    self.articleIdsString=@"";
    
    if (_tableView.isEditing==NO)
    {
        _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(50));
        _bottomView.hidden=NO;
        [button setTitle:@"取消" forState:UIControlStateNormal];
        
        self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
        [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
    }
    if (_tableView.isEditing==YES)
    {
        _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _bottomView.hidden=YES;
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        
        //退出编辑模式的时候 清空文章数组
        [self.deleteArticleArray removeAllObjects];
        
        self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
        [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
    }
    [_tableView setEditing:!_tableView.isEditing animated:YES];
}

//点击删除帖子
-(void)deleteBtnClick
{
    if (self.deleteArticleArray.count<=0)
    {
        [self.view makeToast:@"未选中任何帖子" duration:1.0];
    }
    else
    {
        NSMutableArray *articleIdsArray=[NSMutableArray array];
        for (NSDictionary *articleDict in self.deleteArticleArray)
        {
            NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
            [articleIdsArray addObject:articleId];
        }
        self.articleIdsString=[articleIdsArray componentsJoinedByString:@","];
//        NSLog(@"将要删除的帖子id===%@",self.articleIdsString);
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除帖子？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [HTTPManager deleteArticlesWithIds:self.articleIdsString complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                for (NSDictionary *articleDict in self.deleteArticleArray)
                {
                    [self.bigArticleArray removeObject:articleDict];
                }
                
                if (self.bigArticleArray.count>0)
                {
                    //说明还有剩余帖子
                    self.articleIdsString=@"";
                    [self.deleteArticleArray removeAllObjects];
                    self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
                    [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
                }
                else
                {
                    //说明没有剩余帖子了
                    self.articleIdsString=@"";
                    _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
                    _bottomView.hidden=YES;
                    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
                    [_tableView setEditing:NO animated:YES];
                    //删除所有数组数据
                    [self.deleteArticleArray removeAllObjects];
                    self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
                    [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
                    
                    if (!_blankLabel)
                    {
                        _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                        _blankLabel.text=@"暂无发文~~";
                        _blankLabel.font=FONT(17, 15);
                        _blankLabel.textAlignment=NSTextAlignmentCenter;
                        [self.view addSubview:_blankLabel];
                    }
                }
                
                [_tableView reloadData];
            }
            else
            {
                [self.view makeToast:@"删除帖子失败，请重试。" duration:1.0];
            }
        }];
    }
    
}

//点击图片全屏浏览
-(void)contentImageBtnClick:(MyArticleImageBtn*)button
{
    NSLog(@"点击的图片tag值===%ld",(long)button.tag);
    self.articleIdsString=@"";
    
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
    
    [ViewController photoBrowserWithImages:urlArray photoIndex:button.tag];
    
    if (_tableView.isEditing==YES)
    {
        //点击图片之后退出编辑模式
        _tableView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _bottomView.hidden=YES;
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_tableView setEditing:!_tableView.isEditing animated:YES];
        //删除所有数组数据
        [self.deleteArticleArray removeAllObjects];
        self.deleteString=[NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.deleteArticleArray.count];
        [_deleteBtn setTitle:self.deleteString forState:UIControlStateNormal];
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

@implementation MyArticleImageBtn

@synthesize imageBtnArray;

@end

