//
//  OrderCouponViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "OrderCouponViewController.h"
#import <SVProgressHUD.h>
#import "MyCouponCell.h"

@interface OrderCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)NSMutableArray *couponArray;
@property(nonatomic,strong)NSString *storeId;
@property(nonatomic,strong)NSString *money;

@end

@implementation OrderCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavigationBar];
    [self createTableView];
    
    self.storeId=[self.orderDict objectForKey:@"storeId"];
    self.money=[self.orderDict objectForKey:@"money"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self getStoreCoupon];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [SVProgressHUD dismiss];
}
-(void)getStoreCoupon
{
    //获取商家优惠券列表
    [HTTPManager getUserCouponListWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"1" pageNum:@"1" pageSize:@"100" amount:self.money storeId:self.storeId complete:^(NSDictionary *resultDict) {
        [SVProgressHUD dismiss];
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.couponArray=[[listDict objectForKey:@"data"] mutableCopy];
            [_tableView reloadData];
            
            if (self.couponArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无可用优惠券~~";
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
            [self.view makeToast:[resultDict objectForKey:@"error"] duration:2.0];
        }
    }];
}

-(void)createNavigationBar
{
    self.title=@"选择优惠券";
    
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
    return [self.couponArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"MyCouponCell";
    MyCouponCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[MyCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *couponDict=self.couponArray[indexPath.row];
    
    NSString *tjString=[couponDict objectForKey:@"name"];
    NSString *yxqString=[couponDict objectForKey:@"yxq"];
    NSString *zcsjString=[couponDict objectForKey:@"zcsj"];
    NSString *moneyString=[couponDict objectForKey:@"money"];
    
    cell.bgIV.image=IMAGE(@"wode_youhuiquan_keyong");
    cell.titleLabel.text=@"优惠券";
    cell.tjLabel.text=tjString;
    cell.yxqLabel.text=yxqString;
    cell.zcsjLabel.text=zcsjString;
    cell.yhjgLabel.text=[NSString stringWithFormat:@"¥ %@",moneyString];
    
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *couponDict=self.couponArray[indexPath.row];
//    NSString *money=[NSString stringWithFormat:@"%@",[couponDict objectForKey:@"money"]];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"chooseCoupon" object:nil userInfo:couponDict];
    
    if (self.block) {
        self.block(couponDict);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(130);
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
