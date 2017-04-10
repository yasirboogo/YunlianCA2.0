//
//  StoreSearchViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "StoreSearchViewController.h"

#import "StoreSearchResultsViewController.h"

@interface StoreSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_historyTableView;
    
    UITextField *_searchTF;
}

@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSMutableArray *historyArray;

@end

@implementation StoreSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyword=@"";
    
    [self createNavigationBar];
    [self createHistoryTableView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    //取出本地历史记录
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.historyArray=[[NSMutableArray alloc]initWithArray:[defaults arrayForKey:@"storeHistory"]];
    [_historyTableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(10), WZ(20))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIView *naviView=[[UIView alloc]initWithFrame:CGRectMake(15, 10, WZ(260), 30)];
    naviView.backgroundColor=COLOR(244, 244, 244, 1);
    naviView.layer.cornerRadius=5;
    naviView.clipsToBounds=YES;
    
    self.navigationItem.titleView=naviView;
    
    UIImageView *searchIV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    searchIV.image=IMAGE(@"sousuo_hui");
    [naviView addSubview:searchIV];
    
    _searchTF=[[UITextField alloc]initWithFrame:CGRectMake(searchIV.right+10, 0, naviView.width-searchIV.width-10*2, 30)];
    _searchTF.placeholder=@"搜索店铺";
    _searchTF.font=FONT(15,13);
    _searchTF.delegate=self;
    [naviView addSubview:_searchTF];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    
    
    
}

-(void)createHistoryTableView
{
    _historyTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _historyTableView.delegate=self;
    _historyTableView.dataSource=self;
    _historyTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_historyTableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.historyArray==nil)
    {
        return 0;
    }
    else
    {
        return self.historyArray.count;
    }
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
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
    titleLabel.text=self.historyArray[indexPath.row];
    titleLabel.textColor=COLOR_LIGHTGRAY;
    titleLabel.font=FONT(15, 13);
    [cell.contentView addSubview:titleLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyword=self.historyArray[indexPath.row];
    _searchTF.text=keyword;
    self.keyword=keyword;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
    aView.backgroundColor=COLOR_WHITE;
    
    UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, (aView.width-WZ(15*2))/2.0, aView.height)];
    leftLabel.text=@"搜索历史";
    leftLabel.font=FONT(15,13);
    [aView addSubview:leftLabel];
    
    CGSize clearBtnSize=[ViewController sizeWithString:@"清空记录" font:FONT(15,13) maxSize:CGSizeMake(WZ(200),aView.height)];
    
    UIButton *clearBtn=[[UIButton alloc]initWithFrame:CGRectMake(aView.width-WZ(15)-clearBtnSize.width, 0, clearBtnSize.width, aView.height)];
    [clearBtn setTitle:@"清空记录" forState:UIControlStateNormal];
    [clearBtn setTitleColor:COLOR(0, 153, 227, 1) forState:UIControlStateNormal];
    clearBtn.titleLabel.font=FONT(15,13);
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:clearBtn];
    
    
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(40);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_searchTF.text.length>0)
    {
        [_searchTF resignFirstResponder];
    }
    
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//搜索
-(void)searchBtnClick
{
    [_searchTF resignFirstResponder];
    //    NSLog(@"搜索的关键字===%@\n模块id===%@\n片区id===%@",self.keyword,self.moduleId,[UserInfoData getUserInfoFromArchive].areaId);
    
    if ([self.keyword isEqualToString:@""])
    {
        [self.view makeToast:@"请输入搜索关键字" duration:1.0];
    }
    else
    {
        
//        NSString *keyword=[self.keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在搜索..." detail:nil];
        [hud show:YES];
        
        NSString *lng=[NSString stringWithFormat:@"%f",self.longitude];
        NSString *lat=[NSString stringWithFormat:@"%f",self.latitude];
        
        [HTTPManager getStoreListWithModuleId:self.moduleId areaId:[UserInfoData getUserInfoFromArchive].areaId lng:lng lat:lat pxType:@"" pageNum:@"1" pageSize:@"100" keyword:self.keyword complete:^(StoreModel *model) {
            if ([model.result isEqualToString:STATUS_SUCCESS])
            {
                [hud hide:YES];
                NSLog(@"搜索结果===%@",model.storeListArray);
                
                if (model.storeListArray.count>0)
                {
                    //有搜索结果 跳转搜索结果界面
                    StoreSearchResultsViewController *vc=[[StoreSearchResultsViewController alloc]init];
                    vc.resultsArray=model.storeListArray;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    [self.view makeToast:@"无搜索结果" duration:1.0];
                }
                
                //保存搜索记录到本地(只能保存不可变数据) 首先取出以前存的历史记录
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSMutableArray *historyArray=[[NSMutableArray alloc]initWithArray:[defaults arrayForKey:@"storeHistory"]];
                if (historyArray==nil)
                {
                    //如果没有以前的历史记录 就创建数组 把搜索数据存到数组里 然后把数组写入本地
                    historyArray=[NSMutableArray array];
                    [historyArray addObject:self.keyword];
                }
                else if (![historyArray containsObject:self.keyword])
                {
                    //如果有以前的搜索记录 并且以前搜索记录里不包含本次搜索关键字 把关键字存入数组
                    [historyArray addObject:self.keyword];
                }
                
                NSArray *historyArr=[NSArray arrayWithArray:historyArray];
                [defaults setObject:historyArr forKey:@"storeHistory"];
                [defaults synchronize];
                
                //取出本地历史记录
                NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
                self.historyArray=[[NSMutableArray alloc]initWithArray:[defa arrayForKey:@"storeHistory"]];
                [_historyTableView reloadData];
            }
            else
            {
                [hud hide:YES];
            }
        }];
        [hud hide:YES afterDelay:20.0];
        
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.keyword=textField.text;
}

//清空记录
-(void)clearBtnClick
{
    NSLog(@"清空记录");
    //清空数据
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSArray alloc]init] forKey:@"storeHistory"];
    
    //取出数据 刷新tableview
    NSUserDefaults *defa=[NSUserDefaults standardUserDefaults];
    self.historyArray=[[NSMutableArray alloc]initWithArray:[defa arrayForKey:@"storeHistory"]];
    [_historyTableView reloadData];
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
