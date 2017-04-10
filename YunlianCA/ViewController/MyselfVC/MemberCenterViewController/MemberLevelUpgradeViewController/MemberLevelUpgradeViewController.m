//
//  MemberLevelUpgradeViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MemberLevelUpgradeViewController.h"

@interface MemberLevelUpgradeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)NSMutableArray *purchaseBtnArray;
@property(nonatomic,strong)NSMutableArray *vipArray;
@property(nonatomic,strong)NSString *vipId;
@property(nonatomic,strong)UITextField *payPswTF;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)NSString *password;


@end

@implementation MemberLevelUpgradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.password=@"";
    self.vipId=@"";
    self.purchaseBtnArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
}

-(void)getVIPList
{
    [HTTPManager getVIPListWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.vipArray=[[resultDict objectForKey:@"list"] mutableCopy];
            
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"error"] duration:1.0];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getVIPList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"会员升级";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createTableView
{
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(30))];
    topLabel.text=@"(实际付款94折)";
    topLabel.textColor=COLOR_RED;
    topLabel.font=FONT(17, 15);
    topLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:topLabel];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,topLabel.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-64-topLabel.height)];
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
    return self.vipArray.count;
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
    
    NSDictionary *vipDict=self.vipArray[indexPath.row];
    NSString *name=[vipDict objectForKey:@"name"];
    NSString *money=[NSString stringWithFormat:@"￥ %.2f",[[vipDict objectForKey:@"money"] floatValue]];
    NSInteger status=[[NSString stringWithFormat:@"%@",[vipDict objectForKey:@"status"]] integerValue];
    
    CGSize titleSize=[ViewController sizeWithString:name font:FONT(17, 15) maxSize:CGSizeMake(WZ(150), WZ(60))];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, titleSize.width, WZ(60))];
    titleLabel.text=name;
    titleLabel.font=FONT(17, 15);
    [cell.contentView addSubview:titleLabel];
    
    CGSize priceSize=[ViewController sizeWithString:money font:FONT(17, 15) maxSize:CGSizeMake(WZ(100), WZ(60))];
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(60), titleLabel.top, priceSize.width, titleLabel.height)];
    priceLabel.text=money;
    priceLabel.textColor=COLOR_ORANGE;
    priceLabel.font=FONT(17, 15);
    [cell.contentView addSubview:priceLabel];
    
    NSString *btnString;
    if (status==0)
    {
        btnString=@"已购买";
    }
    if (status==1)
    {
        btnString=@"不可购买";
    }
    if (status==2)
    {
        btnString=@"购买";
    }
    
    CGSize btnSize=[ViewController sizeWithString:btnString font:FONT(15, 13) maxSize:CGSizeMake(WZ(150), WZ(30))];
    UIButton *purchaseBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-btnSize.width-WZ(20), WZ(15), btnSize.width+WZ(20), WZ(30))];
    purchaseBtn.tag=indexPath.row;
    [purchaseBtn setTitle:btnString forState:UIControlStateNormal];
    [purchaseBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    purchaseBtn.titleLabel.font=FONT(15, 13);
    purchaseBtn.clipsToBounds=YES;
    purchaseBtn.layer.cornerRadius=5.0;
    [purchaseBtn addTarget:self action:@selector(purchaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:purchaseBtn];
    
    if (status==0 || status==1)
    {
        purchaseBtn.backgroundColor=COLOR(210, 210, 210, 1);
        purchaseBtn.userInteractionEnabled=NO;
    }
    if (status==2)
    {
        purchaseBtn.backgroundColor=COLOR(253, 153, 160, 1);
        purchaseBtn.userInteractionEnabled=YES;
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(60);
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//购买会员
-(void)purchaseBtnClick:(UIButton*)button
{
//    NSLog(@"购买会员Tag值===%ld",(long)button.tag);
    NSDictionary *vipDict=self.vipArray[button.tag];
    NSString *vipName=[vipDict objectForKey:@"name"];
    self.vipId=[vipDict objectForKey:@"id"];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否购买%@会员?",vipName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=0;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0)
    {
        if (buttonIndex==1)
        {
            //弹出支付密码框
            [self createBackgroundViewWithSmallViewTitle:@"" detail:@"请输入支付密码："];
        }
    }
    
}

//创建背景View
-(void)createBackgroundViewWithSmallViewTitle:(NSString *)title detail:(NSString*)detail
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    
    UIView *parentView = [[UIView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].windows[0];
    if (window.subviews.count > 0)
    {
        parentView = [window.subviews objectAtIndex:0];
    }
    [parentView addSubview:bgView];
    self.bgView=bgView;
    
    CGFloat spaceToBorder=WZ(20);
    CGFloat smallViewWidth=SCREEN_WIDTH-WZ(30*2);
    
    CGSize titleSize=[ViewController sizeWithString:title font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(30))];
    CGSize detailSize=[ViewController sizeWithString:detail font:FONT(17, 15) maxSize:CGSizeMake(smallViewWidth-WZ(spaceToBorder*2), WZ(60))];
    
    CGFloat smallViewHeight=WZ(15*4+20)+titleSize.height+detailSize.height+WZ(35)+WZ(35);
    
    UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(WZ(30), WZ(180), smallViewWidth, smallViewHeight)];
    smallView.backgroundColor=COLOR_WHITE;
    smallView.clipsToBounds=YES;
    smallView.layer.cornerRadius=5;
    [self.bgView addSubview:smallView];
    self.smallView=smallView;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), 0)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    titleLabel.text=title;
    titleLabel.textColor=COLOR_BLACK;
    titleLabel.font=FONT(17, 15);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [smallView addSubview:titleLabel];
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, titleLabel.bottom+WZ(15), smallView.width-WZ(spaceToBorder*2), detailSize.height)];
    //    titleLabel.backgroundColor=COLOR_CYAN;
    detailLabel.text=detail;
    //    detailLabel.textColor=COLOR_LIGHTGRAY;
    detailLabel.font=FONT(17, 15);
    detailLabel.numberOfLines=0;
    detailLabel.textAlignment=NSTextAlignmentLeft;
    [smallView addSubview:detailLabel];
    
    UITextField *passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(spaceToBorder, detailLabel.bottom+WZ(20), smallView.width-WZ(spaceToBorder*2), WZ(45))];
    //    passwordTF.placeholder=@"请输入支付密码";
    passwordTF.delegate=self;
    passwordTF.secureTextEntry=YES;
    passwordTF.clipsToBounds=YES;
    passwordTF.layer.cornerRadius=5;
    passwordTF.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    passwordTF.layer.borderWidth=1.0;
    [smallView addSubview:passwordTF];
    self.payPswTF=passwordTF;
    
    NSArray *qxqdArray=[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];
    
    CGFloat buttonWidth=WZ(100);
    CGFloat buttonHeight=WZ(35);
    CGFloat buttonSpace=smallViewWidth-buttonWidth*2-spaceToBorder*2;
    
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *qxqdBtn=[[UIButton alloc]initWithFrame:CGRectMake(spaceToBorder+(buttonWidth+buttonSpace)*(i%2), smallViewHeight-buttonHeight-WZ(20), buttonWidth, buttonHeight)];
        [qxqdBtn setTitle:qxqdArray[i] forState:UIControlStateNormal];
        qxqdBtn.titleLabel.font=FONT(17, 15);
        qxqdBtn.clipsToBounds=YES;
        qxqdBtn.layer.cornerRadius=5;
        qxqdBtn.tag=i;
        [qxqdBtn addTarget:self action:@selector(qxqdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:qxqdBtn];
        
        if (i==0)
        {
            [qxqdBtn setTitleColor:COLOR(98, 99, 100, 1) forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(230, 235, 235, 1);
        }
        if (i==1)
        {
            [qxqdBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(254, 153, 160, 1);
        }
    }
}

//取消确定按钮
-(void)qxqdBtnClick:(UIButton*)button
{
    [self.payPswTF resignFirstResponder];
    
    if (button.tag==0)
    {
        //取消，移除bgView，退出注册界面
        [self.bgView removeFromSuperview];
    }
    if (button.tag==1)
    {
        [self.bgView removeFromSuperview];
        //确定 购买VIP
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在购买..." detail:nil];
        [hud show:YES];
        [HTTPManager buyVIPWithUserId:[UserInfoData getUserInfoFromArchive].userId usergradeId:self.vipId password:self.password complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"购买成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                
                [self.payPswTF resignFirstResponder];
                [self getVIPList];
            }
            if ([result isEqualToString:@"error"])
            {
                [self.view makeToast:[resultDict objectForKey:@"msg"] duration:2.0];
            }
            [hud hide:YES];
        }];
        [hud hide:YES afterDelay:20];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.password=textField.text;
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
