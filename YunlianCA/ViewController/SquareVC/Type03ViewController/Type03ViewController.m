//
//  Type03ViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "Type03ViewController.h"

#import "StoreDetailViewController.h"
#import "StoreSearchViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <SVProgressHUD.h>

#define TOP_SV_HEIGHT WZ(45)

@interface Type03ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_topScrollView;
    CGFloat _buttonWidth;
    UIView *_lineView;
    UILabel *_blankLabel;
    BOOL _isFirst;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)CTCallCenter *callCenter;
@property(nonatomic,strong)NSString *callStoreId;
@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,assign)NSInteger titleCount;
@property(nonatomic,strong)NSMutableArray *moduleIdArray;
@property(nonatomic,strong)NSString *callNum;
@property(nonatomic,strong)UILabel *callLabel;
@property(nonatomic,strong)NSMutableArray *moduleListArray;
@property(nonatomic,strong)NSMutableArray *moduleList1Array;
@property(nonatomic,strong)NSMutableArray *pxTypeArray;
@property(nonatomic,strong)NSMutableArray *topTitleArray;


@property(nonatomic,assign)NSInteger buttonIndex;
@property(nonatomic,strong)NSMutableArray *bigStoreArray;
@property(nonatomic,strong)NSMutableArray *bigStoreIdArray;
@property(nonatomic,assign)NSInteger pageNum;

@end

@implementation Type03ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buttonIndex=0;
    self.pageNum=1;
    self.callNum=@"0";
    self.callStoreId=@"";
    self.moduleIdArray=[NSMutableArray array];
    self.topBtnArray=[NSMutableArray array];
    self.bigStoreArray=[NSMutableArray array];
    self.bigStoreIdArray=[NSMutableArray array];
    self.pxTypeArray=[NSMutableArray array];
    self.topTitleArray=[NSMutableArray array];
    self.moduleListArray=[NSMutableArray array];
    self.moduleList1Array=[NSMutableArray array];
    
    [self createNavigationBar];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSString *moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
    NSString *lng=[NSString stringWithFormat:@"%f",self.longitude];
    NSString *lat=[NSString stringWithFormat:@"%f",self.latitude];
    _isFirst = YES;
    [HTTPManager getStoreListWithModuleId:moduleId areaId:self.areaId lng:lng lat:lat pxType:@"" pageNum:@"1" pageSize:@"20" keyword:nil complete:^(StoreModel *model) {
        [SVProgressHUD dismiss];
        //model.moduleList1Array为空 则为家家淘宝那种栏目不为空的
        if (model.moduleList1Array==nil)
        {
            self.titleCount=model.moduleListArray.count;
            self.moduleListArray=model.moduleListArray;
            self.moduleList1Array=nil;
            
            for (NSInteger i=0; i<model.moduleListArray.count; i++)
            {
                NSDictionary *dict=model.moduleListArray[i];
                NSString *moduleId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                NSString *topTitle=[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                
                [self.moduleIdArray addObject:moduleId];
                [self.topTitleArray addObject:topTitle];
            }
        }
        //model.moduleListArray为空 则为云超市那种栏目为空的
        if (model.moduleListArray==nil)
        {
            self.titleCount=model.moduleList1Array.count;
            self.moduleList1Array=model.moduleList1Array;
            self.moduleListArray=nil;
            
            for (NSInteger i=0; i<model.moduleList1Array.count; i++)
            {
                NSArray *moduleArray=model.moduleList1Array[i];
                NSString *pxType=[moduleArray firstObject];
                NSString *topTitle=[moduleArray lastObject];
                
                [self.pxTypeArray addObject:pxType];
                [self.topTitleArray addObject:topTitle];
            }
        }
        
        for (NSDictionary *storeDict in model.storeListArray)
        {
            NSString *storeId=[storeDict objectForKey:@"id"];
            
            if (![self.bigStoreArray containsObject:storeId])
            {
                [self.bigStoreIdArray addObject:storeId];
                [self.bigStoreArray addObject:storeDict];
            }
        }
        
        if (self.bigStoreArray.count==0)
        {
            
            if (!_blankLabel)
            {
                _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                _blankLabel.text=@"此栏目暂无商家入驻~~";
                _blankLabel.font=FONT(17, 15);
                _blankLabel.textAlignment=NSTextAlignmentCenter;
               
            }
             [self.view addSubview:_blankLabel];
        }else{
            [self createTableView];
        }
        
        [self createTopView];
        
    }];
    
//    NSLog(@"self.moduleDict===%@",self.moduleDict);
    
    //添加拨打电话的监听
    [self callStore];
    
    /**
     *  此界面代码重复率过高 有时间再整合
     */
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    if (!_isFirst) {
        [self refreshData];
    }
    if (_isFirst) {
        _isFirst = NO;
    }
    
}

-(void)createNavigationBar
{
    self.title=[self.moduleDict objectForKey:@"name"];
    self.navigationController.navigationBar.barTintColor=COLOR(251, 250, 252, 1);
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+24), WZ(10), WZ(24), WZ(24))];
    [rightBtn setBackgroundImage:IMAGE(@"sousuo_hei") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTopView
{
    if (self.titleCount<=4)
    {
        _buttonWidth=(SCREEN_WIDTH-WZ(15*2))/self.titleCount;
    }
    if (self.titleCount>=4)
    {
        _buttonWidth=WZ(86.25);
    }
    
    _topScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_SV_HEIGHT)];
    _topScrollView.delegate=self;
    _topScrollView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_topScrollView];
    
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15)+(_buttonWidth-WZ(30))/2.0, TOP_SV_HEIGHT-WZ(5), WZ(30), 1)];
    _lineView.backgroundColor=COLOR_RED;
    [_topScrollView addSubview:_lineView];
    
    if (self.titleCount<=4)
    {
        _topScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, TOP_SV_HEIGHT);
    }
    if (self.titleCount>=4)
    {
        _topScrollView.contentSize=CGSizeMake(_buttonWidth*self.titleCount+WZ(15*2), TOP_SV_HEIGHT);
    }
    
    for (NSInteger i=0; i<self.titleCount; i++)
    {
        
        UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)+_buttonWidth*i, 0, _buttonWidth, TOP_SV_HEIGHT)];
        topBtn.tag=i;
        topBtn.titleLabel.font=FONT(17, 15);
        [topBtn setTitle:self.topTitleArray[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:topBtn];
        [self.topBtnArray addObject:topBtn];
        
        if (i==0)
        {
            [topBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        }
    }
    
}

-(void)createTableView
{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, TOP_SV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_SV_HEIGHT-64)];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    
    [self.tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.tableView addFooterWithTarget:self action:@selector(getMoreData)];
}

//下拉刷新
-(void)refreshData
{
    NSString *lng=[NSString stringWithFormat:@"%f",self.longitude];
    NSString *lat=[NSString stringWithFormat:@"%f",self.latitude];
    NSString *moduleId;
    NSString *pxType;
    //家家淘宝
    if (self.moduleList1Array==nil)
    {
        moduleId=self.moduleIdArray[self.buttonIndex];
        pxType=@"";
    }
    //云超市
    if (self.moduleListArray==nil)
    {
        moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
        pxType=self.pxTypeArray[self.buttonIndex];
    }
   
    [HTTPManager getStoreListWithModuleId:moduleId areaId:self.areaId lng:lng lat:lat pxType:pxType pageNum:@"1" pageSize:@"20" keyword:nil complete:^(StoreModel *model) {
        [self.bigStoreIdArray removeFirstObject];
        [self.bigStoreArray removeFirstObject];
        for (NSDictionary *storeDict in model.storeListArray)
        {
            NSString *storeId=[storeDict objectForKey:@"id"];
            
            if (![self.bigStoreIdArray containsObject:storeId])
            {
                [self.bigStoreIdArray addObject:storeId];
                [self.bigStoreArray addObject:storeDict];
            }
        }
        
        //结束刷新
        [_tableView headerEndRefreshing];
        [_tableView reloadData];
        
        if (model.storeListArray.count>0)
        {
            if (_blankLabel)
            {
                [_blankLabel removeFromSuperview];
                _blankLabel=nil;
            }
        }
    }];
}

//上拉加载
-(void)getMoreData
{
    self.pageNum=self.pageNum+1;
    
    NSString *lng=[NSString stringWithFormat:@"%f",self.longitude];
    NSString *lat=[NSString stringWithFormat:@"%f",self.latitude];
    NSString *moduleId;
    NSString *pxType;
    //家家淘宝
    if (self.moduleList1Array==nil)
    {
        moduleId=self.moduleIdArray[self.buttonIndex];
        pxType=@"";
    }
    //云超市
    if (self.moduleListArray==nil)
    {
        moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
        pxType=self.pxTypeArray[self.buttonIndex];
    }
    
    [HTTPManager getStoreListWithModuleId:moduleId areaId:self.areaId lng:lng lat:lat pxType:pxType pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20" keyword:nil complete:^(StoreModel *model) {
        
        for (NSDictionary *storeDict in model.storeListArray)
        {
            NSString *storeId=[storeDict objectForKey:@"id"];
            
            if (![self.bigStoreIdArray containsObject:storeId])
            {
                [self.bigStoreIdArray addObject:storeId];
                [self.bigStoreArray addObject:storeDict];
            }
        }
        
        //结束刷新
        [_tableView footerEndRefreshing];
        [_tableView reloadData];
        
        if (model.storeListArray.count>0)
        {
            if (_blankLabel)
            {
                [_blankLabel removeFromSuperview];
                _blankLabel=nil;
            }
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
    return self.bigStoreArray.count;
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
    NSString *explains=[storeDict objectForKey:@"explains"];
    NSString *headImg=[storeDict objectForKey:@"headImg"];
    if (headImg==nil) {
        headImg = [storeDict objectForKey:@"img"];
    }
    
//    NSString *storeId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
//    NSString *mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"mobile"]];
    NSString *name=[storeDict objectForKey:@"name"];
    NSString *opentime=[storeDict objectForKey:@"opentime"];
    
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(60), WZ(60))];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]] placeholderImage:IMAGE(@"morentupian")];
    [cell.contentView addSubview:iconImageView];
    
    CGSize nameSize=[ViewController sizeWithString:name font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(20))];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top-WZ(10), nameSize.width, WZ(20))];
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
    
    CGSize signSize=[ViewController sizeWithString:explains font:FONT(12,10) maxSize:CGSizeMake(WZ(220), WZ(30))];
    
    UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), shopHoursLabel.bottom+WZ(3), signSize.width, WZ(30))];
    signLabel.text=explains;
    signLabel.font=FONT(12,10);
    signLabel.numberOfLines=2;
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
    callLabel.adjustsFontSizeToFitWidth = YES;
    callLabel.textColor=COLOR(166, 213, 157, 1);
    callLabel.font=FONT(11,9);
    callLabel.tag = 1000;
    [cell.contentView addSubview:callLabel];
    self.callLabel=callLabel;
    
    UIButton *callBtn=[[UIButton alloc]init];
    callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, callLabel.center.y-WZ(40));
    callBtn.size=CGSizeMake(WZ(30), WZ(30));
//    callBtn.backgroundColor=COLOR(166, 213, 157, 1);
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
    //跳转到店铺详情界面
    StoreDetailViewController *vc=[[StoreDetailViewController alloc]init];
    vc.storeId=[self.bigStoreArray[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(90);
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索店铺
-(void)rightBtnClick
{
    NSString *moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
    StoreSearchViewController *searchVC=[[StoreSearchViewController alloc]init];
    searchVC.moduleId=moduleId;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//点击顶部button
-(void)topBtnClick:(UIButton*)button
{
    self.buttonIndex=button.tag;
    
    for (UIButton *btn in self.topBtnArray)
    {
        if (button.tag==btn.tag)
        {
            [btn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGFloat width=(_buttonWidth-WZ(30))/2.0;
                _lineView.frame=CGRectMake(WZ(15)+width+(WZ(30)+(_buttonWidth-WZ(30)))*button.tag, TOP_SV_HEIGHT-WZ(5), WZ(30), 1);
                
                [_tableView reloadData];
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
    }
    
    NSString *lng=[NSString stringWithFormat:@"%f",self.longitude];
    NSString *lat=[NSString stringWithFormat:@"%f",self.latitude];
    
    NSString *moduleId;
    NSString *pxType;
    //家家淘宝
    if (self.moduleList1Array==nil)
    {
        //发送获取店铺请求 这里的moduleId不同于第一次进界面时的moduleId 第一次进来用的是主页大的moduleId 这里是进来的那个大项下面的小栏目的moduleId
        moduleId=self.moduleIdArray[button.tag];
        pxType=@"";
    }
    //云超市
    if (self.moduleListArray==nil)
    {
        moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
        pxType=self.pxTypeArray[button.tag];
    }
    
    [HTTPManager getStoreListWithModuleId:moduleId areaId:self.areaId lng:lng lat:lat pxType:pxType pageNum:@"1" pageSize:@"20" keyword:nil complete:^(StoreModel *model) {
        
        self.pageNum=1;
        [self.bigStoreArray removeAllObjects];
        [self.bigStoreIdArray removeAllObjects];
        
        for (NSDictionary *storeDict in model.storeListArray)
        {
            NSString *storeId=[storeDict objectForKey:@"id"];
            
            if (![self.bigStoreArray containsObject:storeId])
            {
                [self.bigStoreIdArray addObject:storeId];
                [self.bigStoreArray addObject:storeDict];
            }
        }
        [_tableView reloadData];
        
        if (model.storeListArray.count<=0)
        {
            if (!_blankLabel)
            {
                _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                _blankLabel.text=@"此栏目暂无商家入驻~~";
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
    }];
    
}

//打电话
-(void)callBtnClick:(UIButton*)button
{
    NSDictionary *storeDict=self.bigStoreArray[button.tag];
    NSString *mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"mobile"]];
    NSString *callStoreId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
    self.callStoreId=callStoreId;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    self.callLabel = [cell.contentView viewWithTag:1000];
    self.callNum=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"callNum"]];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)callStore
{
    __weak Type03ViewController *weakSelf=self;
    
    
    _callCenter = [[CTCallCenter alloc] init];
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
                    //[weakSelf.tableView reloadData];
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
