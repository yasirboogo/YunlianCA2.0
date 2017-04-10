//
//  CollectionStoreVC.m
//  YunlianCA
//
//  Created by QinJun on 16/7/28.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "CollectionStoreVC.h"

#import "StoreDetailViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface CollectionStoreVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_blankLabel;
}

@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)NSMutableArray *storeArray;
@property(nonatomic,strong)CTCallCenter *callCenter;
@property(nonatomic,strong)NSString *callStoreId;
@property(nonatomic,strong)NSString *callNum;
@property(nonatomic,strong)UILabel *callLabel;

@property(nonatomic,strong)NSMutableArray *bigStoreArray;
@property(nonatomic,strong)NSMutableArray *bigStoreIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation CollectionStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum=1;
    self.bigStoreArray=[NSMutableArray array];
    self.bigStoreIdArray=[NSMutableArray array];
    
    self.callNum=@"0";
    self.callStoreId=@"";
    
    [self createTableView];
    [self callStore];
    
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    //获取话题收藏
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"3" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *storeArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *storeDict in storeArray)
            {
                NSString *storeId=[storeDict objectForKey:@"id"];
                
                if (![self.bigStoreIdArray containsObject:storeId])
                {
                    [self.bigStoreIdArray addObject:storeId];
                    [self.bigStoreArray addObject:storeDict];
                }
            }
            
            [self.tableView reloadData];
            [hud hide:YES];
            
            if (storeArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无店铺收藏~~";
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
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"3" pageNum:@"1" pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *storeArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *storeDict in storeArray)
            {
                NSString *storeId=[storeDict objectForKey:@"id"];
                
                if (![self.bigStoreIdArray containsObject:storeId])
                {
                    [self.bigStoreIdArray addObject:storeId];
                    [self.bigStoreArray addObject:storeDict];
                }
            }
            
            if (storeArray.count>0)
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
    
    [HTTPManager getUserCollectionListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"3" pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *storeArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            for (NSDictionary *storeDict in storeArray)
            {
                NSString *storeId=[storeDict objectForKey:@"id"];
                
                if (![self.bigStoreIdArray containsObject:storeId])
                {
                    [self.bigStoreIdArray addObject:storeId];
                    [self.bigStoreArray addObject:storeDict];
                }
            }
            
            if (storeArray.count>0)
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
    return self.bigStoreArray.count;;
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
    
    NSDictionary *storeDict=self.bigStoreArray[indexPath.row];
    self.callNum=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"callNum"]];
    NSString *content=[storeDict objectForKey:@"content"];
//    NSString *createtime=[storeDict objectForKey:@"createtime"];
    NSString *img=[storeDict objectForKey:@"img"];
    NSString *name=[storeDict objectForKey:@"name"];
    NSString *opentime=[storeDict objectForKey:@"opentime"];
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(60), WZ(60))];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentouxiang")];
    [cell.contentView addSubview:iconImageView];
    
    CGSize nameSize=[ViewController sizeWithString:name font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(20))];
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(20))];
    nameLabel.text=name;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR(146, 135, 187, 1);
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:nameLabel];
    
    NSString *shopHoursString=[NSString stringWithFormat:@"营业时间：%@",opentime];
    CGSize shopHoursSize=[ViewController sizeWithString:shopHoursString font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(15))];
    
    UILabel *shopHoursLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(6), shopHoursSize.width, WZ(15))];
    shopHoursLabel.text=shopHoursString;
    shopHoursLabel.font=FONT(12,10);
    shopHoursLabel.textColor=COLOR_LIGHTGRAY;
    //    shopHoursLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:shopHoursLabel];
    
    NSString *signString=content;
    CGSize signSize=[ViewController sizeWithString:signString font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(15))];
    
    UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), shopHoursLabel.bottom+WZ(3), signSize.width, WZ(15))];
    signLabel.text=signString;
    signLabel.font=FONT(12,10);
    //    signLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:signLabel];
    
    if (self.callNum==nil || [self.callNum isEqualToString:@""])
    {
        self.callNum=@"0";
    }
    
    NSString *callNumString=[NSString stringWithFormat:@"拨打%@次",self.callNum];
    CGSize callLabelSize=[ViewController sizeWithString:callNumString font:FONT(11,9) maxSize:CGSizeMake(WZ(100),WZ(20))];
    
    UILabel *callLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(12)-callLabelSize.width, WZ(50), callLabelSize.width, WZ(20))];
    callLabel.textAlignment=NSTextAlignmentCenter;
    callLabel.text=callNumString;
    callLabel.textColor=COLOR(166, 213, 157, 1);
    callLabel.font=FONT(11,9);
    [cell.contentView addSubview:callLabel];
    
    UIButton *callBtn=[[UIButton alloc]init];
    callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, callLabel.center.y-WZ(40));
    callBtn.size=CGSizeMake(WZ(30), WZ(30));
    [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
    callBtn.layer.cornerRadius=callBtn.width/2.0;
    callBtn.clipsToBounds=YES;
    callBtn.tag=indexPath.row;
    [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:callBtn];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *storeDict=self.bigStoreArray[indexPath.row];
    NSString *storeId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"objectId"]];
    NSLog(@"店铺id===%@",storeId);
    //跳转到店铺详情界面
    StoreDetailViewController *vc=[[StoreDetailViewController alloc]init];
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
        NSDictionary *storeDict=self.bigStoreArray[indexPath.row];
        NSString *collectionId=[storeDict objectForKey:@"id"];
        
        [HTTPManager deleteCollectionWithIds:collectionId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [tableView setEditing:NO animated:YES];
                
                [self.bigStoreArray removeObjectAtIndex:indexPath.row];
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



//打电话
-(void)callBtnClick:(UIButton*)button
{
    NSDictionary *storeDict=self.bigStoreArray[button.tag];
    NSString *mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"content"]];
    NSString *callStoreId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
    self.callStoreId=callStoreId;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


-(void)callStore
{
    __weak CollectionStoreVC *weakSelf=self;
    
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"挂断了电话咯Call has been disconnected");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"电话通了Call has just been connected");
            //电话接通之后调用拨打电话次数+1的方法
            [HTTPManager addCallNumberWithStoreId:weakSelf.callStoreId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    weakSelf.callNum=[NSString stringWithFormat:@"%ld",[weakSelf.callNum integerValue]+1];
                    weakSelf.callLabel.text=[NSString stringWithFormat:@"拨打%@次",weakSelf.callNum];
                    [weakSelf.tableView reloadData];
                }
                else
                {
                    
                }
            }];
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"来电话了Call is incoming");
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"正在播出电话call is dialing");
        }
        else
        {
            NSLog(@"嘛都没做Nothing is done");
        }
    };
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
