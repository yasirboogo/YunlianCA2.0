//
//  RechargeViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/10.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RechargeViewController.h"

#import "RechargeModeViewController.h"

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)NSMutableArray *cellViewArray;
@property(nonatomic,strong)NSMutableArray *checkIVArray;
@property(nonatomic,assign)NSInteger cellRow;
@property(nonatomic,strong)NSString *payType;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)UITextField *moneyTF;




@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payType=@"5";
    self.money=@"";
    self.cellViewArray=[NSMutableArray array];
    self.checkIVArray=[NSMutableArray array];
    self.cellRow=0;
    
    [self createNavigationBar];
    [self createCellView];
    [self createTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"充值";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createCellView
{
//    NSArray *iconArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_zhifu_zhifubao"),IMAGE(@"wode_zhifu_weixin"),IMAGE(@"wode_zhifu_yinlian"), nil];
//    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"支付宝充值",@"微信充值",@"银联充值", nil];
//    NSArray *subArray=[[NSArray alloc]initWithObjects:@"推荐有支付宝的用户使用",@"操作简单易用，支持大额支付",@"使用银行卡快捷支付", nil];
    
    NSArray *iconArray=[[NSArray alloc]initWithObjects:IMAGE(@"kuaiqianzhifu"),IMAGE(@"yongjinzhifu"),IMAGE(@"wode_zhifu_zhifubao"),IMAGE(@"wode_zhifu_weixin"), nil];
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"快钱充值",@"外快充值",@"支付宝充值",@"微信充值", nil];
    NSArray *subArray=[[NSArray alloc]initWithObjects:@"银行卡（信用卡）快捷支付",@"外快充值到好处币",@"推荐有支付宝的用户使用",@"操作简单易用", nil];
    
//    NSArray *iconArray=[[NSArray alloc]initWithObjects:IMAGE(@"wode_zhifu_zhifubao"), nil];
//    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"支付宝充值",nil];
//    NSArray *subArray=[[NSArray alloc]initWithObjects:@"推荐有支付宝的用户使用", nil];
    
    for (NSInteger i=0; i<titleArray.count; i++)
    {
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(60))];
        cellView.backgroundColor=COLOR_WHITE;
        [self.cellViewArray addObject:cellView];
        
        UIImageView *checkIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+20), WZ(17), WZ(20), WZ(16))];
        checkIV.image=IMAGE(@"");
        [cellView addSubview:checkIV];
        [self.checkIVArray addObject:checkIV];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(40), WZ(40))];
        iconIV.image=iconArray[i];
        [cellView addSubview:iconIV];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10*2)-iconIV.width-checkIV.width, WZ(20))];
        titleLabel.text=titleArray[i];
        titleLabel.font=FONT(15,13);
        [cellView addSubview:titleLabel];
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), titleLabel.bottom, titleLabel.width, WZ(20))];
        subLabel.text=subArray[i];
        subLabel.textColor=COLOR_LIGHTGRAY;
        subLabel.font=FONT(13,11);
        [cellView addSubview:subLabel];
    }
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
        return 4;
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
        
        cell.textLabel.text=@"充值金额：";
        cell.textLabel.font=FONT(17, 15);
        
        UITextField *moneyTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(250), 0, WZ(250), WZ(50))];
        moneyTF.text=self.money;
        moneyTF.placeholder=@"请输入充值金额";
        moneyTF.font=FONT(17, 15);
        moneyTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        [cell.contentView addSubview:moneyTF];
        self.moneyTF=moneyTF;
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        UIView *cellView=self.cellViewArray[indexPath.row];
        [cell.contentView addSubview:cellView];
        
        if (self.cellRow==indexPath.row)
        {
            UIImageView *checkIV=self.checkIVArray[indexPath.row];
            checkIV.image=IMAGE(@"linju_xuanze");
        }
        else
        {
            UIImageView *checkIV=self.checkIVArray[indexPath.row];
            checkIV.image=IMAGE(@"");
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        self.cellRow=indexPath.row;
        [self.moneyTF resignFirstResponder];
        self.money=self.moneyTF.text;
        [_tableView reloadData];
        
        if (indexPath.row==0)
        {
            //快钱
            self.payType=@"5";
        }
        if (indexPath.row==1)
        {
            //外快
            self.payType=@"4";
        }
        if (indexPath.row==2)
        {
            //支付宝
            self.payType=@"2";
        }
        if (indexPath.row==3)
        {
            //微信
            self.payType=@"1";
        }
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
        return WZ(60);
    }
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确定
-(void)rightBtnClick
{
    [self.moneyTF resignFirstResponder];
    self.money=self.moneyTF.text;
    
    if ([self.payType isEqualToString:@"5"])
    {
        if ([self.moneyTF.text floatValue]<1 || self.moneyTF.text==nil)
        {
            [self.view makeToast:@"充值金额不能少于1元" duration:2.0];
        }
        else
        {
            if ([self.moneyTF.text floatValue]>4999.99 || self.moneyTF.text==nil)
            {
                [self.view makeToast:@"充值金额不能超过4999.99元" duration:2.0];
            }
            else
            {
                //跳转充值模式界面
                RechargeModeViewController *vc=[[RechargeModeViewController alloc]init];
                vc.money=self.money;
                vc.payType=self.payType;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else
    {
        if ([self.moneyTF.text floatValue]==0 || self.moneyTF.text==nil)
        {
            [self.view makeToast:@"充值金额不能为0元" duration:2.0];
        }
        else
        {
            if ([self.moneyTF.text floatValue]>4999.99 || self.moneyTF.text==nil)
            {
                [self.view makeToast:@"充值金额不能超过4999.99元" duration:2.0];
            }
            else
            {
                //跳转充值模式界面
                RechargeModeViewController *vc=[[RechargeModeViewController alloc]init];
                vc.money=self.money;
                vc.payType=self.payType;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
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
