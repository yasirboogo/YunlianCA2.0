//
//  ArticleSearchResultsViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ArticleSearchResultsViewController.h"

#import "DynamicDetailViewController.h"
#import "RedEnvelopeSendViewController.h"
@interface ArticleSearchResultsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)UIButton *contentImageBtn;
@property(nonatomic,strong)UIButton *contentImageBtn0;

@end

@implementation ArticleSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"搜索结果";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
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
    
    NSDictionary *articleDict=self.resultsArray[indexPath.row];
    NSString *title=[[articleDict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSLog(@"文章字典===%@",articleDict);
    
    UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
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
    headView.goBtn.hidden = YES;
    NSString *createUser=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
    if ([createUser isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
    {
        headView.addFriendBtn.frame=CGRectMake(0, 0, 0, 0);
    }
    else
    {
        if ([[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"isFriend"]] isEqualToString:@"0"])
        {
            //未添加好友
            [headView.addFriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
            [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
            headView.addFriendBtn.layer.borderColor=COLOR(154, 154, 154, 1).CGColor;
            headView.addFriendBtn.layer.borderWidth=1;
            headView.addFriendBtn.tag = indexPath.row;
            [headView.addFriendBtn addTarget:self action:@selector(searchResoultAddFriendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"isFriend"]] isEqualToString:@"1"])
        {
            //已添加好友
            [headView.addFriendBtn setTitle:@"已添加" forState:UIControlStateNormal];
            [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
            headView.addFriendBtn.backgroundColor=COLOR_HEADVIEW;
        }
        
    }
    
    //        UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, WZ(30), WZ(20))];
    //        zhidingLabel.text=@"置顶";
    //        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
    //        zhidingLabel.textColor=COLOR_WHITE;
    //        zhidingLabel.font=FONT(11);
    //        zhidingLabel.textAlignment=NSTextAlignmentCenter;
    //        zhidingLabel.layer.cornerRadius=3;
    //        zhidingLabel.clipsToBounds=YES;
    //        [cell.contentView addSubview:zhidingLabel];
    
    UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, SCREEN_WIDTH-WZ(15*2), WZ(20))];
    //        biaotiLabel.backgroundColor=COLOR_CYAN;
    biaotiLabel.text=title;
    [cell.contentView addSubview:biaotiLabel];
    
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000))];
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), biaotiLabel.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
    contentLabel.text=content;
    contentLabel.font=FONT(15, 13);
    contentLabel.numberOfLines=0;
    [cell.contentView addSubview:contentLabel];
    
    NSArray *contentImageArray=[[articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
    if (contentImageArray.count>0)
    {
        if (contentImageArray.count==1)
        {
            ArticleSearchResultImageBtn *contentImageBtn=[[ArticleSearchResultImageBtn alloc]initWithFrame:CGRectMake(WZ(15), contentLabel.bottom+WZ(15), WZ(250), WZ(250))];
            contentImageBtn.imageBtnArray=contentImageArray;
            [contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
            contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
            [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:contentImageBtn];
            self.contentImageBtn=contentImageBtn;
        }
        else
        {
            for (NSInteger i=0; i<contentImageArray.count; i++)
            {
                ArticleSearchResultImageBtn *contentImageBtn=[[ArticleSearchResultImageBtn alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
                contentImageBtn.imageBtnArray=contentImageArray;
                contentImageBtn.tag=i;
                [contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,contentImageArray[i]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
                [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:contentImageBtn];
                self.contentImageBtn=contentImageBtn;
            }
        }
    }
    
    
    //    ArticleBottomView *bottomView=[[ArticleBottomView alloc]initWithFrame:CGRectMake(0, self.contentImageBtn.bottom, SCREEN_WIDTH, WZ(30+18))];
    //    [cell.contentView addSubview:bottomView];
    //
    //    bottomView.pageViewLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"browsecount"]];
    //    bottomView.praiseLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"praisecount"]];
    //    bottomView.commentLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"commentNum"]];
    
    ArticleBottomView *bottomView=[[ArticleBottomView alloc]init];
    [cell.contentView addSubview:bottomView];
    bottomView.tag=1000;
    
    if (contentImageArray.count>0)
    {
        bottomView.frame=CGRectMake(0, self.contentImageBtn.bottom, SCREEN_WIDTH, WZ(45));
    }
    else
    {
        bottomView.frame=CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(45));
    }
    
    bottomView.pageViewLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"browsecount"]];
    bottomView.praiseLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"praisecount"]];
    bottomView.praiseLabel.tag=1;
    
    bottomView.commentLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"commentNum"]];
    [bottomView.praiseBtn addTarget:self action:@selector(aiticlePraiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomView.praiseBtn.tag=indexPath.row;
    
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
    [bottomView.zuiBtn addTarget:self action:@selector(searchResoultZuiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomView.zuiLabel.text=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"kissNum"]==nil?@"0":[articleDict objectForKey:@"kissNum"]];
    NSString * userId =[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"createuser"]];
    if ([userId isEqualToString:[UserInfoData getUserInfoFromArchive].userId]) {
        bottomView.zuiIV.image = IMAGE(@"zuichun_fen");
    }else{
        bottomView.zuiIV.image = IMAGE(@"zuichun");
    }

    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)searchResoultAddFriendBtnClicked:(UIButton *)button{
    NSDictionary *friendDict=self.resultsArray[button.tag];
    NSLog(@"friendDict==%@",friendDict);
    NSString *userId=[friendDict objectForKey:@"createuser"];
    if (!userId) {
         [self.view makeToast:@"无法加该用户为好友" duration:1.0];
        return;
    }
    [HTTPManager addFriendRequestWithUserId:[UserInfoData getUserInfoFromArchive].userId toUserId:userId complete:^(NSDictionary *resultDict) {
        
        
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view makeToast:@"已发送好友请求" duration:1.0];
        }
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"error"] duration:1.0];
        }
    }];
}
-(void)searchResoultZuiButtonClicked:(UIButton *)button{
    NSDictionary *articleDict=self.resultsArray[button.tag];
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
    NSDictionary *articleDict=self.resultsArray[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *articleDict=self.resultsArray[indexPath.row];
    NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000))];
    
    UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70+20)+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
    
    NSArray *contentImageArray=[[articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
    
    if (contentImageArray.count>0)
    {
        if (contentImageArray.count==1)
        {
            UIButton *contentImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), contentLabel.bottom+WZ(15), WZ(250), WZ(250))];
            self.contentImageBtn0=contentImageBtn;
        }
        else
        {
            for (NSInteger i=0; i<contentImageArray.count; i++)
            {
                UIButton *contentImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
                
                self.contentImageBtn0=contentImageBtn;
            }
        }
        return self.contentImageBtn0.bottom+WZ(15)+WZ(45);
    }
    else
    {
        return contentLabel.bottom+WZ(45);
    }
}






#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)contentImageBtnClick:(ArticleSearchResultImageBtn*)button
{
    NSLog(@"点击的图片tag值===%ld",(long)button.tag);
    NSMutableArray *urlArray=[NSMutableArray array];
    for (NSInteger i=0; i<button.imageBtnArray.count; i++)
    {
        NSString *url=button.imageBtnArray[i];
        [urlArray addObject:url];
    }
    
    //    NSLog(@"urlArray===%@",urlArray);
    
    [ViewController photoBrowserWithImages:urlArray photoIndex:button.tag];
}

//帖子点赞
-(void)aiticlePraiseBtnClick:(UIButton*)button
{
    NSDictionary *articleDict=self.resultsArray[button.tag];
    NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"id"]];
    
    [HTTPManager addPraiseWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" objectId:articleId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [button setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
            
            UITableViewCell *cell = [_tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:2]];
            ArticleBottomView *bottomView=[cell viewWithTag:1000];
            ArticlePraiseLabel *praiseLabel=[bottomView viewWithTag:1];
            praiseLabel.text=[NSString stringWithFormat:@"%ld",[[articleDict objectForKey:@"praisecount"] integerValue]+1];
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:1.0];
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

@implementation ArticleSearchResultImageBtn

@synthesize imageBtnArray;

@end
