//
//  CollectionArticleVC.m
//  YunlianCA
//
//  Created by QinJun on 16/7/28.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "CollectionArticleVC.h"

#import "DynamicDetailViewController.h"

@interface CollectionArticleVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
}

//@property(nonatomic,strong)NSMutableArray *articleArray;
@property(nonatomic,strong)NSMutableArray *bigArticleArray;
@property(nonatomic,strong)NSMutableArray *bigArticleIdArray;
@property(nonatomic,assign)NSInteger pageNum;


@end

@implementation CollectionArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigArticleArray=[NSMutableArray array];
    self.bigArticleIdArray=[NSMutableArray array];
    
    [self createTableView];
    
    
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    //获取话题收藏
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *articleArray=[[listDict objectForKey:@"data"] mutableCopy];
            
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
            
            if (articleArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无话题收藏~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
            }
            else
            {
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
        }
        else
        {
            NSString *error=[resultDict objectForKey:@"error"];
            [self.view makeToast:error duration:1.0];
        }
    }];
    
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(45))];
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
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *articleArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *articleDict in articleArray)
            {
                NSString *articleId=[articleDict objectForKey:@"id"];
                
                if (![self.bigArticleIdArray containsObject:articleId])
                {
                    [self.bigArticleIdArray addObject:articleId];
                    [self.bigArticleArray addObject:articleDict];
                }
            }
            
            if (articleArray.count>0)
            {
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
    
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *articleArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *articleDict in articleArray)
            {
                NSString *articleId=[articleDict objectForKey:@"id"];
                
                if (![self.bigArticleIdArray containsObject:articleId])
                {
                    [self.bigArticleIdArray addObject:articleId];
                    [self.bigArticleArray addObject:articleDict];
                }
            }
            
            if (articleArray.count>0)
            {
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
//    NSString *img=[articleDict objectForKey:@"img"];
    NSString *name=[articleDict objectForKey:@"name"];
    NSString *content=[[articleDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *imgUrlString=[articleDict objectForKey:@"img"];
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
    }
    
    UIImageView *headIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(40), WZ(40))];
    [headIV sd_setImageWithURL:imgUrl placeholderImage:IMAGE(@"morentouxiang")];
    headIV.clipsToBounds=YES;
    headIV.layer.cornerRadius=headIV.width/2.0;
    [cell.contentView addSubview:headIV];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headIV.right+WZ(10), headIV.top, SCREEN_WIDTH-WZ(15*2+10)-headIV.width, WZ(20))];
    nameLabel.text=name;
    nameLabel.textColor=COLOR_LIGHTGRAY;
    nameLabel.font=FONT(14,12);
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:nameLabel];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, WZ(20))];
    subLabel.text=content;
    subLabel.textColor=COLOR_BLACK;
    subLabel.font=FONT(12,10);
    //    subLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:subLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
    NSString *articleId=[NSString stringWithFormat:@"%@",[articleDict objectForKey:@"objectId"]];
    //跳转详情界面
    DynamicDetailViewController *vc=[[DynamicDetailViewController alloc]init];
    vc.isLinLiVC=NO;
    vc.articleId=articleId;
    vc.iscollect=@"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(70);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSDictionary *articleDict=self.bigArticleArray[indexPath.row];
        NSString *collectionId=[articleDict objectForKey:@"id"];
        
        [HTTPManager deleteCollectionWithIds:collectionId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [tableView setEditing:NO animated:YES];
                
                [self.bigArticleArray removeObjectAtIndex:indexPath.row];
//                [tableView deleteRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                [_tableView reloadData];
                [self.view makeToast:@"取消收藏成功" duration:1.0];
            }
            else
            {
                [self.view makeToast:[resultDict objectForKey:@"error"] duration:1.0];
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
