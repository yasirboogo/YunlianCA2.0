//
//  CollectionGoodsVC.m
//  YunlianCA
//
//  Created by QinJun on 16/7/28.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "CollectionGoodsVC.h"

#import "GoodsDetailViewController.h"

@interface CollectionGoodsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
}

//@property(nonatomic,strong)NSMutableArray *goodsArray;
@property(nonatomic,strong)NSMutableArray *bigGoodsArray;
@property(nonatomic,strong)NSMutableArray *bigGoodsIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation CollectionGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigGoodsArray=[NSMutableArray array];
    self.bigGoodsIdArray=[NSMutableArray array];
    
    [self createTableView];
    
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    //获取商品收藏
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *goodsArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *goodsDict in goodsArray)
            {
                NSString *goodsId=[goodsDict objectForKey:@"id"];
                
                if (![self.bigGoodsIdArray containsObject:goodsId])
                {
                    [self.bigGoodsIdArray addObject:goodsId];
                    [self.bigGoodsArray addObject:goodsDict];
                }
            }
            
            [_tableView reloadData];
            [hud hide:YES];
            
            if (goodsArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无商品收藏~~";
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
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *goodsArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *goodsDict in goodsArray)
            {
                NSString *goodsId=[goodsDict objectForKey:@"id"];
                
                if (![self.bigGoodsIdArray containsObject:goodsId])
                {
                    [self.bigGoodsIdArray addObject:goodsId];
                    [self.bigGoodsArray addObject:goodsDict];
                }
            }
            
            if (goodsArray.count>0)
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
    
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *goodsArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *goodsDict in goodsArray)
            {
                NSString *goodsId=[goodsDict objectForKey:@"id"];
                
                if (![self.bigGoodsIdArray containsObject:goodsId])
                {
                    [self.bigGoodsIdArray addObject:goodsId];
                    [self.bigGoodsArray addObject:goodsDict];
                }
            }
            
            if (goodsArray.count>0)
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
    return self.bigGoodsArray.count;
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
    
    NSDictionary *goodsDict=self.bigGoodsArray[indexPath.row];
    NSString *img=[goodsDict objectForKey:@"img"];
    NSString *name=[goodsDict objectForKey:@"name"];
    NSString *price=[goodsDict objectForKey:@"content"];
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(80), WZ(60))];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentouxiang")];
//    iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:iconImageView];
    
    NSString *nameString=name;
    CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(17,15) maxSize:CGSizeMake(WZ(255), WZ(25))];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(25))];
    nameLabel.text=nameString;
    nameLabel.font=FONT(17,15);
    nameLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:nameLabel];
    
    NSString *priceString=[NSString stringWithFormat:@"¥ %@",price];
    CGSize priceSize=[ViewController sizeWithString:priceString font:FONT(17,15) maxSize:CGSizeMake(WZ(255), WZ(25))];
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(10), priceSize.width, WZ(25))];
    priceLabel.text=priceString;
    priceLabel.font=FONT(17,15);
    priceLabel.textColor=COLOR_ORANGE;
    [cell.contentView addSubview:priceLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *goodsDict=self.bigGoodsArray[indexPath.row];
//    NSLog(@"goodsDict===%@",goodsDict);
    
    NSString *goodsId=[goodsDict objectForKey:@"objectId"];
    NSString *storeId=[goodsDict objectForKey:@"storeId"];
    //跳转商品详情界面
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    vc.goodsId=goodsId;
    vc.storeId=storeId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(90);
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
        NSDictionary *goodsDict=self.bigGoodsArray[indexPath.row];
        NSString *collectionId=[goodsDict objectForKey:@"id"];
        
        [HTTPManager deleteCollectionWithIds:collectionId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [tableView setEditing:NO animated:YES];
                
                [self.bigGoodsArray removeObjectAtIndex:indexPath.row];
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
