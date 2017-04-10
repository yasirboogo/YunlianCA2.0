//
//  MyStoreViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyStoreViewController.h"

#import "CreateStoreViewController.h"
#import "MyStoreDetailsViewController.h"
#import "StoreManageViewController.h"
#import "MyselfViewController.h"

@interface MyStoreViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
}

@property(nonatomic,strong)StoreModel *storeModel;



@end

@implementation MyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    [self createBottomView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=COLOR_WHITE;
    
    //获取我的店铺列表
    [HTTPManager getMyStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(StoreModel *storeModel) {
        if (storeModel.myStoreArray.count>0)
        {
            self.storeModel=storeModel;
            [_tableView reloadData];
            
            if (_blankLabel)
            {
                [_blankLabel removeFromSuperview];
                _blankLabel=nil;
            }
        }
        else
        {
            if (!_blankLabel)
            {
                _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                _blankLabel.text=@"暂无店铺~~";
                _blankLabel.font=FONT(17, 15);
                _blankLabel.textAlignment=NSTextAlignmentCenter;
                [self.view addSubview:_blankLabel];
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(60), WZ(10), SCREEN_WIDTH-WZ(60*2), WZ(30))];
    titleLabel.font=FONT(19,17);
    titleLabel.text=@"我的店铺";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(80+10), WZ(10), WZ(80), WZ(30))];
//    rightView.backgroundColor=COLOR_CYAN;
    
    UIButton *txBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(40), WZ(30))];
    txBtn.titleLabel.font=FONT(15, 13);
    [txBtn setTitle:@"提现" forState:UIControlStateNormal];
    [txBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [txBtn addTarget:self action:@selector(txBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:txBtn];
    
    UIButton *mxBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(40), 0, WZ(40), WZ(30))];
    mxBtn.titleLabel.font=FONT(15, 13);
    [mxBtn setTitle:@"明细" forState:UIControlStateNormal];
    [mxBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [mxBtn addTarget:self action:@selector(mxBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:mxBtn];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)createBottomView
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(50), SCREEN_WIDTH, WZ(50))];
    bottomView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:bottomView];
    
    UIButton *addStoreBtn=[[UIButton alloc]initWithFrame:CGRectMake((bottomView.width-bottomView.height)/2.0, 0, bottomView.height, bottomView.height)];
    addStoreBtn.layer.cornerRadius=addStoreBtn.width/2.0;
    addStoreBtn.clipsToBounds=YES;
    [addStoreBtn setBackgroundImage:IMAGE(@"wode_tianjiadianpu") forState:UIControlStateNormal];
    [addStoreBtn addTarget:self action:@selector(addStoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addStoreBtn];
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-WZ(50))];
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
    return self.storeModel.myStoreArray.count;
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
    
    NSDictionary *storeDict=self.storeModel.myStoreArray[indexPath.row];
    NSString *explains=[storeDict objectForKey:@"explains"];
    NSString *headImg=[storeDict objectForKey:@"headImg"];
    NSString *storeName=[storeDict objectForKey:@"name"];
    NSString *opentime=[storeDict objectForKey:@"opentime"];
    
//    NSString *address=[storeDict objectForKey:@"address"];
//    NSString *areaId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"address"]];
//    NSString *createtime=[storeDict objectForKey:@"createtime"];
//    NSString *storeId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
//    NSArray *storeImages=[storeDict objectForKey:@"imgset"];
//    NSString *latitude=[storeDict objectForKey:@"latitude"];
//    NSString *longitude=[storeDict objectForKey:@"longitude"];
//    NSString *mobile=[storeDict objectForKey:@"mobile"];
//    NSString *moduleId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"moduleId"]];
//    NSString *userId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"userId"]];
//    NSString *username=[storeDict objectForKey:@"username"];
    
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(60), WZ(60))];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]] placeholderImage:IMAGE(@"morentupian")];
    [cell.contentView addSubview:iconImageView];
    
    CGSize nameSize=[ViewController sizeWithString:storeName font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(20))];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(20))];
    nameLabel.text=storeName;
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
    
    CGSize signSize=[ViewController sizeWithString:explains font:FONT(12,10) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2+10)-iconImageView.width, WZ(15))];
    
    UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), shopHoursLabel.bottom+WZ(3), signSize.width, WZ(15))];
    signLabel.text=explains;
    signLabel.font=FONT(12,10);
    //    signLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:signLabel];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *storeDict=self.storeModel.myStoreArray[indexPath.row];
    NSString *storeId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
    
    //跳到店铺预览界面
    StoreManageViewController *vc=[[StoreManageViewController alloc]init];
    vc.isMyStoreVC=YES;
    vc.storeId=storeId;
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSLog(@"店铺id===%@",storeId);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(90);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[MyselfViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

//店铺提现
-(void)txBtnClick
{
    NSLog(@"店铺提现");
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"每笔提现手续费为2元，是否提现？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=101;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101)
    {
        if (buttonIndex==1)
        {
            //确认提现
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"申请中..." detail:nil];
            [hud show:YES];
            [hud hide:YES afterDelay:20];
            [HTTPManager getStoreMoneyWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
                [hud hide:YES];
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    //您申请的提现已提交成功，款项会在T+1天（工作日）内到账。
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您申请的提现已提交成功，款项会在T+1天（工作日）内到账。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    alertView.tag=102;
                    [alertView show];
                    
                } else {
                    NSString *msg=[resultDict objectForKey:@"msg"];
                    [self.view makeToast:msg duration:2.0];
                }
            }];
        }
    }
}

//店铺明细
-(void)mxBtnClick
{
    NSLog(@"店铺明细");
    
    MyStoreDetailsViewController *vc=[[MyStoreDetailsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//添加店铺
-(void)addStoreBtnClick
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        CreateStoreViewController *vc=[[CreateStoreViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag=100;
        [alertView show];
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
