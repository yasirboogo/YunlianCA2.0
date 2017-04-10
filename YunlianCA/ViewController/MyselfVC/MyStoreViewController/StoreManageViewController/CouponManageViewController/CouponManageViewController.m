//
//  CouponManageViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "CouponManageViewController.h"

#import "MyCouponCell.h"
#import "AddCouponViewController.h"

@interface CouponManageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)StoreModel *storeModel;




@end

@implementation CouponManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [HTTPManager getStoreCouponListWithStoreId:self.storeId pageNum:@"1" pageSize:@"50" complete:^(StoreModel *storeModel) {
        self.storeModel=storeModel;
        [_tableView reloadData];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"优惠券";
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        return self.storeModel.storeCouponArray.count;
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
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
        label.text=@"添加优惠券";
        label.font=FONT(17, 15);
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=COLOR(146, 135, 187, 1);
        [cell.contentView addSubview:label];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"MyCouponCell";
        MyCouponCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell=[[MyCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSDictionary *couponDict=self.storeModel.storeCouponArray[indexPath.row];
        NSString *amountString=[NSString stringWithFormat:@"%@",[couponDict objectForKey:@"amount"]];
        NSInteger amount=[amountString integerValue];
        
        NSString *status=[NSString stringWithFormat:@"%@",[couponDict objectForKey:@"status"]];
        if ([status isEqualToString:@"1"])
        {
            cell.bgIV.image=IMAGE(@"wode_youhuiquan_keyong");
        }
        if ([status isEqualToString:@"0"])
        {
            cell.bgIV.image=IMAGE(@"wode_youhuiquan_yiyong");
        }
        if ([status isEqualToString:@"2"])
        {
            cell.bgIV.image=IMAGE(@"wode_youhuiquan_guoqi");
        }
        
//        cell.bgIV.image=IMAGE(@"wode_youhuiquan_keyong");
        cell.titleLabel.text=@"优惠券";
        cell.tjLabel.text=[NSString stringWithFormat:@"满%@元可使用",[couponDict objectForKey:@"minMoney"]];
        cell.yxqLabel.text=[NSString stringWithFormat:@"%@至%@",[couponDict objectForKey:@"yxStartTime"],[couponDict objectForKey:@"yxEndTime"]];
        cell.yhjgLabel.text=[NSString stringWithFormat:@"¥ %@",[couponDict objectForKey:@"money"]];
        
        NSInteger repertory=amount-[[couponDict objectForKey:@"amountYLQ"] integerValue];
        cell.zcsjLabel.text=[NSString stringWithFormat:@"数量：%@/%ld",[NSString stringWithFormat:@"%ld",(long)repertory],(long)amount];
        
        
        
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        //跳转到添加优惠券界面
        AddCouponViewController *vc=[[AddCouponViewController alloc]init];
        vc.storeId=self.storeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(20))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(60))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), SCREEN_WIDTH, WZ(50))];
        aView.backgroundColor=COLOR_WHITE;
        [titleView addSubview:aView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), aView.height)];
        titleLabel.text=@"已添加的优惠券";
        titleLabel.textColor=COLOR_LIGHTGRAY;
        titleLabel.font=FONT(15,13);
        [aView addSubview:titleLabel];
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(50);
    }
    else
    {
        return WZ(130);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return WZ(20);
    }
    else
    {
        return WZ(60);
    }
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
