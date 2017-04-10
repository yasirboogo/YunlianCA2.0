//
//  DynamicDetailViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "UIButton+ImageLocation.h"
#import "RedEnvelopeListViewController.h"
#import "RedEnvelopeSendViewController.h"
#import "SVProgressHUD.h"
#import "ShareView.h"
#import "TapImageView.h"
@interface DynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,TapImageViewDelegate>
{
    UITableView *_tableView;
    UIView *_bottomView;
    UIView * _lineView;
    BOOL _isEedEnD;
    NSMutableDictionary * _redEnListDic;
    NSInteger _totalPages[2];
    
}
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UITextView *commentTV;
@property(nonatomic,strong)UIButton *shoucangBtn;
@property(nonatomic,strong)UIButton *aNewBtn;
@property(nonatomic,strong)UIButton *aHotBtn;
@property(nonatomic,strong)TapImageView *contentImageBtn;
@property(nonatomic,strong)TapImageView *contentImageBtn0;
@property(nonatomic,strong)NSString *commentString;
//@property(nonatomic,strong)NSMutableArray *commentArray;
@property(nonatomic,strong)NSDictionary *articleDict;
@property(nonatomic,strong)UIButton *articlePraiseBtn;
@property(nonatomic,strong)UILabel *articlePraiseLabel;
@property(nonatomic,strong)UILabel *articleCommentLabel;
@property(nonatomic,strong)NSString *commentNum;
@property(nonatomic,strong)NSString *kissNum;
@property(nonatomic,strong)NSString *praiseCount;
@property(nonatomic,strong)NSString *isLike;
@property(nonatomic,assign)BOOL isNew;
@property(nonatomic,strong)NSString *objectId;
@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *pxType;
@property(nonatomic,strong)NSMutableArray *bigCommentArray;
@property(nonatomic,strong)NSMutableArray *bigCommentIdArray;
@property(nonatomic,assign)NSInteger pageNum;


@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pxType=@"1";
    self.isNew=YES;
    self.commentString=@"";
    self.objectId=self.articleId;
    self.parentId=@"";
    self.pageNum=1;
    self.bigCommentArray=[NSMutableArray array];
    self.bigCommentIdArray=[NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self createNavigationBar];
    [self createTableView];
    [self createBottomCommentView];
    [SVProgressHUD showWithStatus:@"加载中..."];
//    NSLog(@"帖子字典===%@",self.articleDict);
    [self getArticleDetailInfo];
    //[self getCommentDataWithPxType:self.pxType];
    _redEnListDic = [NSMutableDictionary dictionary];
    
}

//获取帖子详情
-(void)getArticleDetailInfo
{
    
    [HTTPManager getArticleDetailInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId articleId:self.articleId complete:^(NSDictionary *resultDict) {
        [SVProgressHUD dismiss];
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.articleDict=[resultDict objectForKey:@"article"];
            self.commentNum=[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"commentNum"]];
            self.praiseCount=[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"praisecount"]];
            self.isLike=[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"isLike"]];
            self.kissNum=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"kissNum"]==nil?@"0":[resultDict objectForKey:@"kissNum"]];
            NSString *isCollect=[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"iscollect"]];
            if ([isCollect isEqualToString:@"0"])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_hei") forState:UIControlStateNormal];
            }
            if ([isCollect isEqualToString:@"1"])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_huang") forState:UIControlStateNormal];
            }
            
            [_tableView reloadData];
        }
        else
        {
            NSString *error=[resultDict objectForKey:@"error"];
            [self.view makeToast:error duration:1.0];
        }
    }];
    
    
}

//获取帖子评论
-(void)getCommentDataWithPxType:(NSString*)pxType
{
    
        [HTTPManager getCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId objectId:self.articleId type:@"1" storeId:@"" pageNum:@"1" pageSize:@"10" pxType:pxType complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSMutableDictionary *listDict=[[resultDict objectForKey:@"list"] mutableCopy];
            NSMutableArray *commentArray=[[listDict objectForKey:@"data"] mutableCopy];
            _totalPages[_isEedEnD]= [listDict[@"totalPages"] integerValue];
            [self.bigCommentArray removeAllObjects];
            for (NSDictionary * dic in commentArray) {
                
                [self.bigCommentArray addObject:[dic mutableCopy]];
            }
            
            [_tableView reloadData];
            
//            for (NSMutableDictionary *dict in commentArray)
//            {
//                NSMutableDictionary *commentDict=[NSMutableDictionary dictionaryWithDictionary:dict];
//                NSString *commentId=[dict objectForKey:@"id"];
//                
//                if (![self.bigCommentIdArray containsObject:commentId])
//                {
//                    [self.bigCommentIdArray addObject:commentId];
//                    [self.bigCommentArray addObject:commentDict];
//                }
//            }
//            
//            [_tableView reloadData];
        }
    }];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    NSLog(@"键盘高度===%f",deltaY);
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _bottomView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-deltaY-WZ(50), SCREEN_WIDTH, WZ(50));
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _bottomView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-WZ(50), SCREEN_WIDTH, WZ(50));
    } completion:^(BOOL finished) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    keyManager.enable = NO;
    [self createBottomCommentView];
     [self getArticleDetailInfo];
    [self refreshData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    [SVProgressHUD dismiss];
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    keyManager.enable = YES;
    
    if (_bottomView)
    {
        [_bottomView removeFromSuperview];
    }
//    else
//    {
//        [self createBottomCommentView];
//    }
    
}

-(void)createNavigationBar
{
    self.title=@"详情";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(70), WZ(10), WZ(70), WZ(25))];
    
    UIButton *shoucangBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(25), WZ(25))];
    [shoucangBtn addTarget:self action:@selector(shoucangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shoucangBtn];
    self.shoucangBtn=shoucangBtn;
    
    if ([self.iscollect isEqualToString:@"0"])
    {
        [shoucangBtn setBackgroundImage:IMAGE(@"shoucang_hei") forState:UIControlStateNormal];
    }
    if ([self.iscollect isEqualToString:@"1"])
    {
        [shoucangBtn setBackgroundImage:IMAGE(@"shoucang_huang") forState:UIControlStateNormal];
    }
    
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(25), 0, WZ(20), WZ(25))];
    [shareBtn setBackgroundImage:IMAGE(@"fenxiang") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareBtn];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createBottomCommentView
{
    
    UIView *parentView = [[UIView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].windows[0];
//    if (window.subviews.count > 0)
//    {
//        parentView = [window.subviews objectAtIndex:0];
//        
//    }
    if (!_bottomView) {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-WZ(50), SCREEN_WIDTH, WZ(50))];
        UITextView *commentTV=[[UITextView alloc]initWithFrame:CGRectMake(WZ(15), WZ(8), SCREEN_WIDTH-WZ(15*2), WZ(50)-WZ(8*2))];
        commentTV.backgroundColor=COLOR_WHITE;
        commentTV.returnKeyType=UIReturnKeySend;
        commentTV.delegate=self;
        commentTV.font=FONT(17, 15);
        commentTV.clipsToBounds=YES;
        commentTV.layer.cornerRadius=3;
        commentTV.layer.borderWidth=1.0;
        commentTV.layer.borderColor=COLOR(234, 234, 234, 1).CGColor;
        [_bottomView addSubview:commentTV];
        self.commentTV=commentTV;
        
        self.textLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15+5), WZ(8), SCREEN_WIDTH-WZ(20*2), WZ(50)-WZ(8*2))];
        self.textLabel.text=@"写评论";
        self.textLabel.textColor=COLOR(158, 158, 158, 1);
        self.textLabel.font=FONT(17, 15);
        self.textLabel.layer.cornerRadius=3;
        self.textLabel.layer.borderWidth=1.0;
        self.textLabel.layer.borderColor=COLOR_CLEAR.CGColor;
        [_bottomView addSubview:self.textLabel];
    }
    
    _bottomView.backgroundColor=COLOR(245, 246, 247, 1);
    [window addSubview:_bottomView];
    
    
//    self.textLabel=textLabel;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        if (self.commentString==nil||[self.commentString isEqualToString:@""]) {
            [self.view makeToast:@"请输入评论内容" duration:1.5];
            return YES;
        }
        NSString *comment=[self.commentString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //添加评论
        [HTTPManager addCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId userName:[UserInfoData getUserInfoFromArchive].username payInfoId:@"" objectId:self.objectId parentId:self.parentId type:@"1" storeId:@"" content:comment star:@"" imageArray:nil complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                self.commentString=@"";
                self.commentTV.text=@"";
                _isEedEnD = NO;
                
                [self getCommentDataWithPxType:self.pxType];
                
                self.commentNum=[NSString stringWithFormat:@"%ld",[self.commentNum integerValue]+1];
                self.articleCommentLabel.text=self.commentNum;
            }
            else
            {
                [self.view makeToast:@"评论失败" duration:1.0];
            }
        }];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.commentString=textView.text;
    
    if (textView.text.length>0)
    {
        [self.textLabel setHidden:YES];
    }
    if (textView.text.length==0)
    {
        [self.textLabel setHidden:NO];
    }
    
}


-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(50))];
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
    [self.bigCommentIdArray removeAllObjects];
    [self.bigCommentArray  removeAllObjects];
    if (_isEedEnD) {
        _redEnListDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.articleId,@"objId",@"1",@"type",@"1",@"pageNum",@"10",@"pageSize",nil];
        [self getRedEnvelopeList];
    }else{
        self.pageNum = 1;
        [HTTPManager getCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId objectId:self.articleId type:@"1" storeId:@"" pageNum:@"1" pageSize:@"10" pxType:self.pxType complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                NSMutableDictionary *listDict=[[resultDict objectForKey:@"list"] mutableCopy];
                NSMutableArray *commentArray=[[listDict objectForKey:@"data"] mutableCopy];
                _totalPages[_isEedEnD]= [listDict[@"totalPages"] integerValue];
                [self.bigCommentArray removeAllObjects];
                for (NSDictionary * dic in commentArray) {
                    
                    [self.bigCommentArray addObject:[dic mutableCopy]];
                }

                [_tableView reloadData];
//                for (NSMutableDictionary *dict in commentArray)
//                {
//                    NSMutableDictionary *commentDict=[NSMutableDictionary dictionaryWithDictionary:dict];
//                    NSString *commentId=[dict objectForKey:@"id"];
//                   
//                    if (![self.bigCommentIdArray containsObject:commentId])
//                    {
//                        [self.bigCommentIdArray addObject:commentId];
//                        [self.bigCommentArray addObject:commentDict];
//                    }
//                }
                
                //结束刷新
                [_tableView headerEndRefreshing];
                //[_tableView reloadData];
                
            }
        }];

    }
    
    
}
-(void)getRedEnvelopeList{
    
    [HTTPManager getRedEnvelopeListWithReqDic:_redEnListDic WithUrl:@"v3/kissReCordList.api" complete:^(NSDictionary *resultDict) {
        NSLog(@"resultDict==%@",resultDict);
        NSInteger pageNum = [_redEnListDic[@"pageNum"] integerValue];
        if (pageNum==1) {
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
           
            NSMutableDictionary *listDict=[[resultDict objectForKey:@"list"] mutableCopy];
            _totalPages[_isEedEnD]= [listDict[@"totalPages"] integerValue];
            NSMutableArray *commentArray=[[listDict objectForKey:@"data"] mutableCopy];
            if (pageNum==1) {
                self.bigCommentArray =commentArray;
                [_tableView reloadData];
            }else{
                NSMutableArray * indexArray = [self changeIndexWithFirstCount:self.bigCommentArray.count Section:2 lastCount:self.bigCommentArray.count+commentArray.count];
               [self.bigCommentArray addObjectsFromArray:commentArray];
                [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
        
        
    }];

}
-(NSMutableArray*)changeIndexWithFirstCount:(NSInteger)firstCount  Section:(NSInteger)section lastCount:(NSInteger)lastCount{
    NSMutableArray* indexArray = [NSMutableArray array];
    for (NSInteger i=firstCount; i<lastCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexArray addObject:indexPath];
    }
    return indexArray;
}

//上拉加载
-(void)getMoreData
{
    if (_isEedEnD) {
        NSInteger pageNum = [_redEnListDic[@"pageNum"] integerValue];
        pageNum++;
        if (pageNum>_totalPages[_isEedEnD]) {
           [self.view makeToast:@"没有更多数据" duration:1.0];
            [_tableView footerEndRefreshing];
            return;
        }
        [_redEnListDic setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"pageNum"];
        [self getRedEnvelopeList];
    }else{
        self.pageNum=self.pageNum+1;
        if (self.pageNum>_totalPages[_isEedEnD]) {
             [self.view makeToast:@"没有更多数据" duration:1.0];
            [_tableView footerEndRefreshing];
            return;
        }
        [HTTPManager getCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId objectId:self.articleId type:@"1" storeId:@"" pageNum:[NSString stringWithFormat:@"%ld",(long)self.pageNum] pageSize:@"10" pxType:self.pxType complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                NSMutableDictionary *listDict=[[resultDict objectForKey:@"list"] mutableCopy];
                NSMutableArray *commentArray=[[listDict objectForKey:@"data"] mutableCopy];
                 _totalPages[_isEedEnD]= [listDict[@"totalPages"] integerValue];
                
                NSMutableArray * indexArray = [self changeIndexWithFirstCount:self.bigCommentArray.count Section:2 lastCount:self.bigCommentArray.count+commentArray.count];
                for (NSDictionary * dic in commentArray) {
                    
                    [self.bigCommentArray addObject:[dic mutableCopy]];
                }

                [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                
                //结束加载
                [_tableView footerEndRefreshing];
                //[_tableView reloadData];
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
    if (section==0 || section==1)
    {
        return 1;
    }
    else
    {
        return self.bigCommentArray.count;
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
        
        NSInteger isTop=[[self.articleDict objectForKey:@"istop"] integerValue];
        
        UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
        [cell.contentView addSubview:headView];
        
        if (self.isLinLiVC==NO)
        {
            headView.lineView.hidden=YES;
            headView.addressLabel.hidden=YES;
            headView.goBtn.hidden=YES;
        }
        
        headView.addressLabel.text=[self.articleDict objectForKey:@"areaName"];
        
        NSString *imgUrlString=[self.articleDict objectForKey:@"userHeadImg"];
        NSURL *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=[NSURL URLWithString:imgUrlString];
        }
        else
        {
            imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[self.articleDict objectForKey:@"userHeadImg"]]];
        }
        [headView.headImageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        headView.nameLabel.text=[self.articleDict objectForKey:@"userName"];
        headView.timeLabel.text=[self.articleDict objectForKey:@"createtime"];
        headView.goBtn.hidden=YES;
        
        NSString *createUser=[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"createuser"]];
        if ([createUser isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
        {
            headView.addFriendBtn.hidden=YES;
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"isFriend"]] isEqualToString:@"0"])
            {
                //未添加好友
                [headView.addFriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
                [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                headView.addFriendBtn.dict=self.articleDict;
                [headView.addFriendBtn addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                headView.addFriendBtn.layer.borderColor=COLOR(154, 154, 154, 1).CGColor;
                headView.addFriendBtn.layer.borderWidth=1;
            }
            if ([[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"isFriend"]] isEqualToString:@"1"])
            {
                //已添加好友
                [headView.addFriendBtn setTitle:@"已添加" forState:UIControlStateNormal];
                [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                headView.addFriendBtn.backgroundColor=COLOR_HEADVIEW;
            }
        }
        
        UILabel *zhidingLabel=[[UILabel alloc]init];
        zhidingLabel.text=@"置顶";
        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
        zhidingLabel.textColor=COLOR_WHITE;
        zhidingLabel.font=FONT(11, 9);
        zhidingLabel.textAlignment=NSTextAlignmentCenter;
        zhidingLabel.layer.cornerRadius=3;
        zhidingLabel.clipsToBounds=YES;
        [cell.contentView addSubview:zhidingLabel];
        
        NSString *title=[[self.articleDict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        UILabel *biaotiLabel=[[UILabel alloc]init];
        biaotiLabel.text=title;
        biaotiLabel.font=FONT(17, 15);
        [cell.contentView addSubview:biaotiLabel];
        
        if (isTop==1)
        {
            zhidingLabel.frame=CGRectMake(WZ(15), headView.bottom, WZ(30), WZ(20));
            biaotiLabel.frame=CGRectMake(zhidingLabel.right+WZ(5), headView.bottom, SCREEN_WIDTH-WZ(15*2+5+30), WZ(20));
        }
        if (isTop==0)
        {
            zhidingLabel.frame=CGRectMake(WZ(15), headView.bottom, 0, 0);
            biaotiLabel.frame=CGRectMake(WZ(15), headView.bottom, SCREEN_WIDTH-WZ(15*2), WZ(20));
        }
        
        NSString *content=[[self.articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), biaotiLabel.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
        contentLabel.text=content;
        contentLabel.font=FONT(15, 13);
        contentLabel.numberOfLines=0;
        [cell.contentView addSubview:contentLabel];
        
        NSArray *contentImageArray=[[self.articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
        
        //        NSLog(@"图片数组===%@",contentImageArray);
        
        if (contentImageArray.count>0)
        {
            if (contentImageArray.count==1)
            {
                TapImageView *contentImageBtn=[[TapImageView alloc]initWithFrame:CGRectMake(WZ(15), contentLabel.bottom+WZ(15), WZ(250), WZ(250))];
                contentImageBtn.t_delegate = self;
                contentImageBtn.imageBtnArray=contentImageArray;
                [contentImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]]  placeholderImage:IMAGE(@"morentupian")];
                //[contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                //contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
                //contentImageBtn.clipsToBounds=YES;
                //[contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:contentImageBtn];
                self.contentImageBtn=contentImageBtn;
            }
            else
            {
                for (NSInteger i=0; i<contentImageArray.count; i++)
                {
                    TapImageView *contentImageBtn=[[TapImageView alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
                    [contentImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,contentImageArray[i]]]  placeholderImage:IMAGE(@"morentupian")];
                    contentImageBtn.imageBtnArray=contentImageArray;
                    contentImageBtn.tag=i;
                    contentImageBtn.t_delegate = self;
                    //[contentImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,contentImageArray[i]]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentupian")];
                    //contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
                    //contentImageBtn.clipsToBounds=YES;
                    //[contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:contentImageBtn];
                    self.contentImageBtn=contentImageBtn;
                }
            }
        }
        
        ArticleBottomView *bottomView=[[ArticleBottomView alloc]init];
//        bottomView.backgroundColor=COLOR_CYAN;
        if (contentImageArray.count>0)
        {
            bottomView.frame=CGRectMake(0, self.contentImageBtn.bottom, SCREEN_WIDTH, WZ(45));
        }
        else
        {
            bottomView.frame=CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(45));
        }
        [cell.contentView addSubview:bottomView];
        
        bottomView.pageViewLabel.text=[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"browsecount"]];
        bottomView.praiseLabel.text=self.praiseCount;
        self.articlePraiseLabel=bottomView.praiseLabel;
        bottomView.commentLabel.text=self.commentNum;
        self.articleCommentLabel=bottomView.commentLabel;
        
        [bottomView.praiseBtn addTarget:self action:@selector(aiticlePraiseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.articlePraiseBtn=bottomView.praiseBtn;
        
        
        if ([self.isLike isEqualToString:@"0"])
        {
            [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hui") forState:UIControlStateNormal];
        }
        if ([self.isLike isEqualToString:@"1"])
        {
            [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
        }
        bottomView.zuiLabel.text = self.kissNum;
        [bottomView.zuiBtn addTarget:self action:@selector(DynamucBottonZuiButton) forControlEvents:UIControlEventTouchUpInside];
        NSString * createuser =[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"createuser"]];
        if ([createuser isEqualToString:[UserInfoData getUserInfoFromArchive].userId]) {
            bottomView.zuiIV.image = IMAGE(@"zuichun_fen");
        }else{
            bottomView.zuiIV.image = IMAGE(@"zuichun");
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
        
        CGFloat space=WZ(10);
        CGFloat btnWidth=WZ(30);
        CGFloat btnHeight=btnWidth;
        CGFloat leftMargin=(SCREEN_WIDTH-btnWidth*8-space*7)/2.0;
        
        
//        for (NSInteger i=0; i<8; i++)
//        {
//            UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+(btnWidth+space)*(i%8), WZ(20), btnWidth, btnHeight)];
//            headBtn.tag=i;
//            headBtn.clipsToBounds=YES;
//            headBtn.layer.cornerRadius=btnWidth/2.0;
//            [headBtn setBackgroundImage:IMAGE(@"head_img01") forState:UIControlStateNormal];
//            [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:headBtn];
//        }
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        if (_isEedEnD) {
            static NSString *cellIdentifier=@"Cell3";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            NSDictionary *commentDict;
            if (indexPath.row<self.bigCommentArray.count) {
                commentDict=self.bigCommentArray[indexPath.row];
            }
            
            UIImageView * headImageView = [cell.contentView viewWithTag:100];
            if (!headImageView) {
                headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), (WZ(70)-WZ(60))/2.0, WZ(60),  WZ(60))];
                headImageView.clipsToBounds = YES;
                headImageView.layer.cornerRadius = WZ(60)/2.0;
                //headImageView.backgroundColor = [UIColor redColor];
                headImageView.tag = 100;
                [cell.contentView addSubview:headImageView];
            }
            NSString *headImg=[commentDict objectForKey:@"headimg"];
            NSString *imgUrlString=headImg;
            NSURL *imgUrl;
            if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
            {
                imgUrl=[NSURL URLWithString:imgUrlString];
            }
            else
            {
                imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]];
            }
            
            [headImageView sd_setImageWithURL:imgUrl placeholderImage:IMAGE(@"morentouxiang")];
            UILabel * nameLabel = [cell.contentView viewWithTag:200];
          
            
            if (!nameLabel) {
                nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WZ(15)+CGRectGetMaxX(headImageView.frame), (WZ(70)-WZ(60))/2.0, WZ(100),WZ(60)/2.0)];
                nameLabel.font = FONT(17, 15);
                //nameLabel.backgroundColor = [UIColor blueColor];
                nameLabel.tag = 200;
                [cell.contentView addSubview:nameLabel];
            }
            nameLabel.text =[commentDict objectForKey:@"nickname"]==nil?@"":[commentDict objectForKey:@"nickname"];
            
            UILabel * timeLabel = [cell.contentView viewWithTag:300];
            if (!timeLabel) {
                timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WZ(15)+CGRectGetMaxX(headImageView.frame), CGRectGetMaxY(nameLabel.frame), WZ(100),WZ(60)/2.0)];
                timeLabel.font = FONT(14, 12);
                timeLabel.textColor = COLOR_LIGHTGRAY;
                //timeLabel.backgroundColor = [UIColor blueColor];
                timeLabel.tag = 300;
                [cell.contentView addSubview:timeLabel];
            }
             timeLabel.text =[commentDict objectForKey:@"createtime"]==nil?@"":[commentDict objectForKey:@"createtime"];
            DynDetailImageBtn * kissBtn = [cell.contentView viewWithTag:400];
            if (!kissBtn) {
                kissBtn = [[DynDetailImageBtn alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(50)-10, 0, WZ(40), WZ(70))];
                [kissBtn setImage:[UIImage imageNamed:@"zuichun"] forState:UIControlStateNormal];
                kissBtn.tag = 400;
                [cell.contentView addSubview:kissBtn];
            }
            kissBtn.indexPath = indexPath;
            NSString * name =[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"name"]];
            if ([name isEqualToString:[UserInfoData getUserInfoFromArchive].username]) {
                
                [kissBtn setImage:[UIImage imageNamed:@"zuichun_fen"] forState:UIControlStateNormal];
            }else{
               [kissBtn setImage:[UIImage imageNamed:@"zuichun"] forState:UIControlStateNormal];
            }
            [kissBtn addTarget:self action:@selector(redFootKissBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel * numLabel = [cell.contentView viewWithTag:500];
            if (!numLabel) {
                numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 0, CGRectGetMinX(kissBtn.frame)-CGRectGetMaxX(nameLabel.frame),WZ(70))];
                numLabel.font = FONT(17, 15);
                numLabel.textAlignment = NSTextAlignmentCenter;
                numLabel.tag = 500;
                [cell.contentView addSubview:numLabel];
            }
            
            NSString * kissNum =[commentDict objectForKey:@"money"]==nil?@"0.00元":[NSString stringWithFormat:@"%@元",[commentDict objectForKey:@"money"]];
            numLabel.text = kissNum;
           
            
           
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
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
            NSDictionary *commentDict;
            if (indexPath.row<self.bigCommentArray.count) {
                commentDict=self.bigCommentArray[indexPath.row];
            }
            
            NSString *content=[[commentDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *createtime=[commentDict objectForKey:@"createtime"];
            NSString *headImg=[commentDict objectForKey:@"headImg"];
            NSString *isLike=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"isLike"]];
            NSString *praisecount=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"praisecount"]];
            NSString *userName=[commentDict objectForKey:@"userName"];
            NSString *ofUserName=[commentDict objectForKey:@"ofUserName"];
            
            UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
            [cell.contentView addSubview:headView];
            headView.goBtn.hidden=YES;
            
            NSString *imgUrlString=headImg;
            NSURL *imgUrl;
            if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
            {
                imgUrl=[NSURL URLWithString:imgUrlString];
            }
            else
            {
                imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]];
            }
            
            [headView.headImageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
            headView.nameLabel.text=userName;
            headView.timeLabel.text=createtime;
            headView.timeLabel.textColor=COLOR_LIGHTGRAY;
            
            [headView.addFriendBtn setTitle:[NSString stringWithFormat:@"%ld楼",indexPath.row+1] forState:UIControlStateNormal];
            [headView.addFriendBtn setTitleColor:COLOR(193, 226, 186, 1) forState:UIControlStateNormal];
            [headView.addFriendBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            
            NSString *contentString;
            if (ofUserName==nil || [ofUserName isEqualToString:@""])
            {
                contentString=content;
            }
            else
            {
                contentString=[NSString stringWithFormat:@"回复 %@：%@",ofUserName,content];
            }
            
            CGSize contentSize=[ViewController sizeWithString:contentString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
            UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.headImageBtn.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
            contentLabel.text=contentString;
            contentLabel.font=FONT(15, 13);
            contentLabel.numberOfLines=0;
            [cell.contentView addSubview:contentLabel];
            
            ArticleBottomView *bottomView=[[ArticleBottomView alloc]initWithFrame:CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(45))];
            //        bottomView.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:bottomView];
            
            bottomView.pageViewIV.frame=CGRectMake(0, 0, 0, 0);
            bottomView.praiseLabel.text=praisecount;
            bottomView.praiseLabel.tag=indexPath.row;
            bottomView.commentLabel.text=@"回复";
            
            bottomView.praiseBtn.tag=indexPath.row;
            [bottomView.praiseBtn addTarget:self action:@selector(commentPraiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([isLike isEqualToString:@"0"])
            {
                [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hui") forState:UIControlStateNormal];
            }
            if ([isLike isEqualToString:@"1"])
            {
                [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
            }
            
            NSString *kissNum=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"kissNum"]==nil?@"0":[commentDict objectForKey:@"kissNum"]];
            bottomView.zuiLabel.text =kissNum;
            bottomView.zuiBtn.tag = indexPath.row;
            [bottomView.zuiBtn addTarget:self action:@selector(dynamicZuiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSString * userPhone =[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"userPhone"]];
            NSLog(@"userPhone==%@===%@",userPhone,[UserInfoData getUserInfoFromArchive].username);
            if ([userPhone isEqualToString:[UserInfoData getUserInfoFromArchive].username]) {
                bottomView.zuiIV.image = IMAGE(@"zuichun_fen");
            }else{
                bottomView.zuiIV.image = IMAGE(@"zuichun");
            }

            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
             return cell;
        }
        
    }
}
//文章详情底部的👄button
-(void)DynamucBottonZuiButton{
    NSString * userId =[NSString stringWithFormat:@"%@",[self.articleDict objectForKey:@"createuser"]];
    if ([userId isEqualToString:[UserInfoData getUserInfoFromArchive].userId]) {
        [self.view makeToast:@"亲，不能嘴自己的哟！" duration:1.0];
        return;
    }
    if ([self.articleDict objectForKey:@"name"]==nil) {
        [self.view makeToast:@"暂不能发送外快给该用户" duration:1.0];
        return;
    }else{
        RedEnvelopeSendViewController * vc = [[RedEnvelopeSendViewController alloc]init];
        vc.scanMobile = [self.articleDict objectForKey:@"name"];
        vc.type = @"1";
        vc.objId = [self.articleDict objectForKey:@"id"];
        vc.placeHolder = [self.articleDict objectForKey:@"title"];
        vc.isMouth = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//红包列表的👄button
-(void)redFootKissBtnClicked:(DynDetailImageBtn *)button{
    NSDictionary *articleDict=self.bigCommentArray[button.indexPath.row];
    NSString * username =[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"name"]];
    if ([username isEqualToString:[UserInfoData getUserInfoFromArchive].username]){
        [self.view makeToast:@"亲，不能嘴自己的哟！" duration:1.0];
        return;
    }
    NSLog(@"articleDict===%@",articleDict);
    NSString * name = [NSString stringWithFormat:@"%@",[articleDict objectForKey:@"name"]];
    if ([articleDict objectForKey:@"name"]==nil) {
        [self.view makeToast:@"暂不能发送红包给该用户" duration:1.0];
        return;
    }else{
        RedEnvelopeSendViewController * vc = [[RedEnvelopeSendViewController alloc]init];
        vc.scanMobile =name;

        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//评论👄btn
-(void)dynamicZuiButtonClicked:(UIButton *)button{
     NSDictionary *commentDict=self.bigCommentArray[button.tag];
    NSString * userPhone =[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"userPhone"]];
    NSLog(@"userPhone==%@===%@",userPhone,[UserInfoData getUserInfoFromArchive].username);
    if ([userPhone isEqualToString:[UserInfoData getUserInfoFromArchive].username]) {
        [self.view makeToast:@"亲，不能嘴自己的哟！" duration:1.0];
        return;
        
    }
    NSLog(@"commentDict==%@",commentDict);
    //RedEnvelopeListViewController *vc=[[RedEnvelopeListViewController alloc]init];
    RedEnvelopeSendViewController * vc = [[RedEnvelopeSendViewController alloc]init];
    vc.type = @"2";
    vc.objId = [NSString stringWithFormat:@"%@",commentDict[@"id"]];
    vc.scanMobile = [NSString stringWithFormat:@"%@",commentDict[@"userPhone"]];
    vc.placeHolder = [commentDict objectForKey:@"content"];
    vc.isMouth = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    vc.objId = [NSString stringWithFormat:@"%@",commentDict[@"id"]];
//    vc.type = @"2";
//    vc.phoneNum = [NSString stringWithFormat:@"%@",commentDict[@"userPhone"]];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        [self.commentTV becomeFirstResponder];
        //如果点击的是第一个区 则为评论当前帖子
        self.objectId=self.articleId;
        self.parentId=@"";
        self.commentString=@"";
        self.textLabel.text=@"写评论";
        self.textLabel.textColor=COLOR(158, 158, 158, 1);
    }
    if (indexPath.section==2)
    {
        if (!_isEedEnD) {
            //如果点击的是第三个区 则是回复其他用户的评论
            NSDictionary *commentDict=self.bigCommentArray[indexPath.row];
            NSLog(@"评论字典===%@",commentDict);
            NSString *commentId=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"id"]];
            NSString *userName=[commentDict objectForKey:@"userName"];
            self.commentString=@"";
            [self.commentTV becomeFirstResponder];
            self.textLabel.text=[NSString stringWithFormat:@"回复:%@",userName];
            self.textLabel.textColor=COLOR(158, 158, 158, 1);
            self.objectId=self.articleId;
            self.parentId=commentId;
            [_tableView reloadData];
        }
        
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
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        aView.backgroundColor=COLOR_HEADVIEW;
        return aView;
    }
    else
    {
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
        aView.backgroundColor=COLOR_WHITE;
        
        UIButton *titleLabel=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(50), aView.height)];
        titleLabel.titleLabel.font =FONT(15,13);
        [titleLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleLabel.tag = 100;
        [titleLabel addTarget:self action:@selector(dynamicTableHeadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleLabel setTitle:@"评论" forState:UIControlStateNormal];
        
        [aView addSubview:titleLabel];
        
        if (!_lineView) {
            _lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame),aView.height-2, CGRectGetWidth(titleLabel.frame), 2)];
            _lineView.backgroundColor = COLOR(255, 150, 158, 1);
            
        }
        [aView addSubview:_lineView];
        UIButton *titleLabel2=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)*2+CGRectGetWidth(titleLabel.frame), 0, WZ(50), aView.height)];
        titleLabel2.titleLabel.font =FONT(15,13);
        [titleLabel2 setTitle:@"外快" forState:UIControlStateNormal];
        titleLabel2.tag = 200;
        [titleLabel2 addTarget:self action:@selector(dynamicTableHeadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleLabel2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [aView addSubview:titleLabel2];
        
        if (!_isEedEnD) {
            CGSize hotSize=[ViewController sizeWithString:@"最热" font:FONT(13,11) maxSize:CGSizeMake(WZ(100), aView.height)];
            UIButton *aHotBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-hotSize.width, 0, hotSize.width, aView.height)];
            [aHotBtn setTitle:@"最热" forState:UIControlStateNormal];
            aHotBtn.titleLabel.font=FONT(13,11);
            [aHotBtn addTarget:self action:@selector(aHotBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:aHotBtn];
            self.aHotBtn=aHotBtn;
            
            CGSize xieSize=[ViewController sizeWithString:@"/" font:FONT(13,11) maxSize:CGSizeMake(WZ(100), aView.height)];
            UILabel *xieLabel=[[UILabel alloc]initWithFrame:CGRectMake(aHotBtn.left-xieSize.width, aHotBtn.top, xieSize.width, aHotBtn.height)];
            xieLabel.text=@"/";
            xieLabel.font=FONT(13,11);
            xieLabel.textAlignment=NSTextAlignmentCenter;
            [aView addSubview:xieLabel];
            
            CGSize newSize=[ViewController sizeWithString:@"最新" font:FONT(13,11) maxSize:CGSizeMake(WZ(100), aView.height)];
            UIButton *aNewBtn=[[UIButton alloc]initWithFrame:CGRectMake(xieLabel.left-newSize.width, 0, newSize.width, aView.height)];
            [aNewBtn setTitle:@"最新" forState:UIControlStateNormal];
            aNewBtn.titleLabel.font=FONT(13,11);
            [aNewBtn addTarget:self action:@selector(aNewBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:aNewBtn];
            self.aNewBtn=aNewBtn;
            
            if (self.isNew==YES)
            {
                [aNewBtn setTitleColor:COLOR(31, 200, 194, 1) forState:UIControlStateNormal];
                [aHotBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
            }
            if (self.isNew==NO)
            {
                [aNewBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                [aHotBtn setTitleColor:COLOR(31, 200, 194, 1) forState:UIControlStateNormal];
            }
            
           
            _lineView.frame =CGRectMake(CGRectGetMinX(titleLabel.frame),aView.height-2, CGRectGetWidth(titleLabel.frame), 2);
        }else{
            _lineView.frame =CGRectMake(CGRectGetMinX(titleLabel2.frame),aView.height-2, CGRectGetWidth(titleLabel2.frame), 2);
        }
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15), aView.bottom, SCREEN_WIDTH-WZ(15*2), 1)];
        lineView.backgroundColor=COLOR(236, 236, 236, 1);
        [aView addSubview:lineView];
        
        return aView;
    }
}
-(void)dynamicTableHeadButtonClicked:(UIButton *)button{
    _lineView.frame = CGRectMake(CGRectGetMinX(button.frame),CGRectGetMinY(_lineView.frame), CGRectGetWidth(button.frame), 2);
    if (button.tag==100) {
        //评论
        _isEedEnD = NO;
        
    }else{
        //红包
        _isEedEnD = YES;
    }
    [self refreshData];
    NSIndexSet * set = [NSIndexSet indexSetWithIndex:2];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        NSString *content=[[self.articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
        
        UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70+20)+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
        
        NSArray *contentImageArray=[[self.articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
        
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
            return self.contentImageBtn0.bottom+WZ(30);
        }
        else
        {
            return contentLabel.bottom+WZ(30);
        }
    }
    if (indexPath.section==2)
    {
        if (_isEedEnD) {
            return WZ(70);
        }else{
            NSDictionary *commentDict;
            if (indexPath.row<self.bigCommentArray.count) {
                commentDict=self.bigCommentArray[indexPath.row];
            }
            
            NSString *content=[[commentDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
            
            UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
            
            return contentLabel.bottom+WZ(30);
        }
       
    }
    else
    {
        return 0;
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
        return WZ(10);
    }
    else
    {
        return WZ(40);
    }
}

//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    if (_bottomView)
    {
        [_bottomView removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//收藏帖子
-(void)shoucangBtnClick
{
    if (![self.articleDict isEqual:[NSNull null]])
    {
        [HTTPManager addUserCollectionWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" objectid:[self.articleDict objectForKey:@"id"] complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_huang") forState:UIControlStateNormal];
                [self.view makeToast:@"收藏成功" duration:1.0];
            }
            else
            {
                [self.view makeToast:[resultDict objectForKey:@"result"] duration:1.0];
            }
        }];
    }
}

//分享
-(void)shareBtnClick
{
    NSArray *contentImageArray=[[self.articleDict objectForKey:@"imgs"] componentsSeparatedByString:@","];
    NSURL *imageUrl;
    if (contentImageArray.count>0)
    {
        imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[contentImageArray firstObject]]];
    }
    else
    {
        imageUrl=[NSURL URLWithString:@""];
    }
    [ShareView sharedInstance].isShowAdjacent = NO;
    [[ShareView sharedInstance] shareWithImageUrlArray:@[imageUrl] title:[[self.articleDict objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] content:[[self.articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] url:[NSString stringWithFormat:@"%@share/articleInfo.api?id=%@&userId=%@",HOST,[self.articleDict objectForKey:@"id"],[UserInfoData getUserInfoFromArchive].userId]];
    
}

//加好友
-(void)addFriendBtnClick:(UHVAddFriendBtn*)button
{
    NSDictionary *dict=button.dict;
    
    if (![dict isEqual:[NSNull null]])
    {
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
    }
}

//最新评论
-(void)aNewBtnClick
{
    self.pxType=@"1";
    self.isNew=YES;
    [self.aNewBtn setTitleColor:COLOR(31, 200, 194, 1) forState:UIControlStateNormal];
    [self.aHotBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    
    [self getCommentDataWithPxType:@"1"];
}

//最热评论
-(void)aHotBtnClick
{
    self.pxType=@"2";
    self.isNew=NO;
    [self.aNewBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [self.aHotBtn setTitleColor:COLOR(31, 200, 194, 1) forState:UIControlStateNormal];
    
    [self getCommentDataWithPxType:@"2"];
}

//点击图片全屏浏览
- (void) tappedWithObject:(id) sender{
    TapImageView * imageView =(TapImageView *) sender;
    [ViewController photoBrowserWithImages:imageView.imageBtnArray photoIndex:imageView.tag];
}
//-(void)contentImageBtnClick:(DynDetailImageBtn*)button
//{
//    NSLog(@"点击的图片tag值===%ld",(long)button.tag);
//    
//    [ViewController photoBrowserWithImages:button.imageBtnArray photoIndex:button.tag];
//}

//点击头像
-(void)headBtnClick:(UIButton*)button
{
    
    
    
}

//帖子点赞
-(void)aiticlePraiseBtnClick
{
    if (self.articleId!=nil && ![self.articleId isEqualToString:@""])
    {
        [HTTPManager addPraiseWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" objectId:self.articleId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.articlePraiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
                
                self.praiseCount=[NSString stringWithFormat:@"%ld",[self.praiseCount integerValue]+1];
                self.articlePraiseLabel.text=self.praiseCount;
                
                //点赞成功的话 就把islike状态改为1
                self.isLike=@"1";
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:1.0];
            }
        }];
    }
}

//评论点赞
-(void)commentPraiseBtnClick:(UIButton*)button
{
    NSMutableDictionary *commentDict=self.bigCommentArray[button.tag];
    if (![commentDict isEqual:[NSNull null]])
    {
        NSString *commentId=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"id"]];
        
        [HTTPManager addPraiseWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" objectId:commentId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [commentDict setValue:@"1" forKey:@"isLike"];
                NSInteger praisecount=[[commentDict objectForKey:@"praisecount"] integerValue];
                [commentDict setValue:[NSString stringWithFormat:@"%ld",praisecount+1] forKey:@"praisecount"];
                
                [_tableView reloadData];
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:1.0];
            }
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

@implementation DynDetailImageBtn

@synthesize imageBtnArray;

@end
