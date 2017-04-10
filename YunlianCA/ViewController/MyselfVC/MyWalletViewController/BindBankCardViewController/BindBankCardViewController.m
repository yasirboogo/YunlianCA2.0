//
//  BindBankCardViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "BindBankCardViewController.h"

#import "BindBankCardConfirmViewController.h"
#import "TiXianViewController.h"

@interface BindBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)NSMutableArray *bankListArray;//银行卡列表
@property(nonatomic,strong)NSString *cardId;//需要解绑的银行卡id
@property(nonatomic,assign)NSInteger indexRow;//解绑的第几个银行卡

@end

@implementation BindBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardId=@"";
    self.bankListArray=[NSMutableArray array];
    
    [self createNavigationBar];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //获取已绑定银行卡列表
    [HTTPManager getBindBankCardListWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSMutableArray *mutableArray) {
        self.bankListArray=mutableArray;
        
        [self createTableView];
    }];
}

-(void)createNavigationBar
{
    if (self.isMemberCenter==YES)
    {
        self.title=@"可提现银行卡";
    }
    else
    {
        self.title=@"绑定银行卡";
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
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
    _tableView.backgroundColor=COLOR_HEADVIEW;
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
        return self.bankListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
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
        
        CGFloat addIVWidth=WZ(20);
        CGSize yhkSize=[ViewController sizeWithString:@"银行卡" font:FONT(17,15) maxSize:CGSizeMake(WZ(100), WZ(50))];
        CGFloat allWidth=addIVWidth+WZ(10)+yhkSize.width;
        
        UIImageView *addIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-allWidth)/2.0, WZ(15), WZ(20), WZ(20))];
        addIV.image=IMAGE(@"wode_tianjiayinhangka");
        [cell.contentView addSubview:addIV];
        
        UILabel *yhkLabel=[[UILabel alloc]initWithFrame:CGRectMake(addIV.right+WZ(10), 0, yhkSize.width, WZ(50))];
        yhkLabel.text=@"银行卡";
        yhkLabel.font=FONT(17,15);
        [cell.contentView addSubview:yhkLabel];
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        NSDictionary *bankDict=self.bankListArray[indexPath.row];
        NSString *bankName=[bankDict objectForKey:@"bankName"];
        NSString *khUserName=[bankDict objectForKey:@"khUserName"];
        NSString *cardNumber=[bankDict objectForKey:@"cardNumber"];
        NSString *cardNum=[NSString stringWithFormat:@"尾号%@",[cardNumber substringFromIndex:cardNumber.length-4]];
        NSInteger status=[[bankDict objectForKey:@"status"] integerValue];
        NSString *statusString=@"";
        if (status==0)
        {
            statusString=@"审核中";
        }
        if (status==1)
        {
            statusString=@"已审核";
        }
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(WZ(10), WZ(10), SCREEN_WIDTH-WZ(10*2), WZ(80))];
        cellView.backgroundColor=COLOR(254, 167, 173, 1);
        cellView.clipsToBounds=YES;
        cellView.layer.cornerRadius=5.0;
        [cell.contentView addSubview:cellView];
        
//        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(50), WZ(50))];
//        iconIV.image=IMAGE(@"head_img01");
//        iconIV.clipsToBounds=YES;
//        iconIV.layer.cornerRadius=iconIV.width/2.0;
//        [cellView addSubview:iconIV];
        
        UILabel *bankNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(8), WZ(150), WZ(25))];
        bankNameLabel.text=bankName;
        bankNameLabel.textColor=COLOR_WHITE;
        [cellView addSubview:bankNameLabel];
//        bankNameLabel.backgroundColor=COLOR_CYAN;
        
        CGSize userNameSize=[ViewController sizeWithString:khUserName font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(25))];
        
        UILabel *userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(bankNameLabel.left, bankNameLabel.bottom, userNameSize.width, WZ(20))];
        userNameLabel.text=khUserName;
        userNameLabel.textColor=COLOR_WHITE;
        userNameLabel.font=FONT(13,11);
        [cellView addSubview:userNameLabel];
//        userNameLabel.backgroundColor=COLOR_CYAN;
        
        UIView *shuView=[[UIView alloc]initWithFrame:CGRectMake(userNameLabel.right+WZ(5), userNameLabel.top+WZ(5), 1, WZ(15))];
        shuView.backgroundColor=COLOR_WHITE;
        [cellView addSubview:shuView];
        
        CGSize weihaoSize=[ViewController sizeWithString:cardNum font:FONT(13,11) maxSize:CGSizeMake(WZ(80), WZ(25))];
        
        UILabel *weihaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(shuView.right+WZ(5), userNameLabel.top, weihaoSize.width, WZ(20))];
        weihaoLabel.text=cardNum;
        weihaoLabel.textColor=COLOR_WHITE;
        weihaoLabel.font=FONT(13,11);
        [cellView addSubview:weihaoLabel];
//        weihaoLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(bankNameLabel.left, userNameLabel.bottom, WZ(150), WZ(20))];
        statusLabel.text=statusString;
        statusLabel.textColor=COLOR_WHITE;
        statusLabel.font=FONT(13,11);
        [cellView addSubview:statusLabel];
//        statusLabel.backgroundColor=COLOR_CYAN;
        
        if (status==1)
        {
            UIButton *jiebangBtn=[[UIButton alloc]initWithFrame:CGRectMake(cellView.width-WZ(15)-WZ(50), WZ(27.5), WZ(50), WZ(25))];
            jiebangBtn.tag=indexPath.row;
            [jiebangBtn setTitle:@"解绑" forState:UIControlStateNormal];
            [jiebangBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            jiebangBtn.titleLabel.font=FONT(14,12);
            jiebangBtn.clipsToBounds=YES;
            jiebangBtn.layer.cornerRadius=5;
            jiebangBtn.layer.borderColor=COLOR_WHITE.CGColor;
            jiebangBtn.layer.borderWidth=1;
            [jiebangBtn addTarget:self action:@selector(jiebangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:jiebangBtn];
        }
        
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        //跳转到绑定银行卡界面
        BindBankCardConfirmViewController *vc=[[BindBankCardConfirmViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if (self.isMemberCenter==YES)
        {
            NSDictionary *bankDict=self.bankListArray[indexPath.row];
            NSInteger status=[[bankDict objectForKey:@"status"] integerValue];
            
            if (status==0)
            {
                [self.view makeToast:@"银行卡审核中..." duration:2.0];
            }
            if (status==1)
            {
                //跳转到提现界面
                TiXianViewController *vc=[[TiXianViewController alloc]init];
                vc.ktxBrokerage=self.ktxBrokerage;
                vc.bankDict=bankDict;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(25))];
    titleView.backgroundColor=COLOR_HEADVIEW;
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(50);
    }
    else
    {
        return WZ(100);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(25);
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//解绑银行卡
-(void)jiebangBtnClick:(UIButton*)button
{
    self.indexRow=button.tag;
    NSDictionary *bankDict=self.bankListArray[button.tag];
    NSString *cardNumber=[bankDict objectForKey:@"cardNumber"];
    NSString *cardNum=[NSString stringWithFormat:@"尾号为%@",[cardNumber substringFromIndex:cardNumber.length-4]];
    self.cardId=[NSString stringWithFormat:@"%@",[bankDict objectForKey:@"id"]];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否解绑%@的银行卡?",cardNum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"解绑中..." detail:nil];
        [hud show:YES];
        [hud hide:YES afterDelay:20];
        //调用解绑银行卡接口
        [HTTPManager deleteBindingBankCardWithBankCardId:self.cardId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.view makeToast:@"解绑成功" duration:1.0];
                [self.bankListArray removeObjectAtIndex:self.indexRow];
                [_tableView reloadData];
            }
            else
            {
                [self.view makeToast:@"解绑失败，请重试。" duration:1.0];
            }
            [hud hide:YES];
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
