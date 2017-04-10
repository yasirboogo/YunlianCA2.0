//
//  TiXianViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/17.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "TiXianViewController.h"

#import "TiXianConfirmViewController.h"



@interface TiXianViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)UILabel *yueLabel;
@property(nonatomic,strong)UILabel *ckrLabel;
@property(nonatomic,strong)UILabel *kahaoLabel;
@property(nonatomic,strong)UILabel *cityLabel;
@property(nonatomic,strong)UILabel *zhihangLabel;
@property(nonatomic,strong)UITextField *tiXianTF;

@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *cardNumber;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *zhihang;
@property(nonatomic,strong)NSString *khUserName;
@property(nonatomic,strong)NSString *tiXianMoney;

@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tiXianMoney=@"";
    
    if ([self.bankDict isEqual:[NSNull null]])
    {
        self.bankName=@"";
        self.khUserName=@"";
        self.cardNumber=@"";
        self.city=@"";
        self.zhihang=@"";
    }
    else
    {
        self.bankName=[self.bankDict objectForKey:@"bankName"];
        self.cardNumber=[NSString stringWithFormat:@"%@",[self.bankDict objectForKey:@"cardNumber"]];
        self.city=[self.bankDict objectForKey:@"bankCity"];
        self.zhihang=[self.bankDict objectForKey:@"subBranch"];
        self.khUserName=[self.bankDict objectForKey:@"khUserName"];
    }
    
    
    
    
    
    
    [self createNavigationBar];
    [self createTableView];
    
    
}




-(void)createNavigationBar
{
    self.title=@"提现";
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_tableView];
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 6;
    }
    else
    {
        return 1;
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
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"账号余额",@"持卡人",@"开户银行",@"银行卡号",@"开户城市",@"支行名称", nil];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(90), WZ(50))];
        titleLabel.text=titleArray[indexPath.row];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row==0)
        {
            UILabel *yueLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            yueLabel.text=[NSString stringWithFormat:@"¥ %@",self.ktxBrokerage];
            [cell.contentView addSubview:yueLabel];
            self.yueLabel=yueLabel;
        }
        if (indexPath.row==1)
        {
            UILabel *ckrLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            ckrLabel.text=self.khUserName;
            ckrLabel.font=FONT(17, 15);
            //            ckrLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:ckrLabel];
            self.ckrLabel=ckrLabel;
        }
        if (indexPath.row==2)
        {
            UILabel *ckrLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            ckrLabel.text=self.bankName;
//            ckrLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:ckrLabel];
            
//            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==3)
        {
            UILabel *kahaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            kahaoLabel.text=self.cardNumber;
            kahaoLabel.font=FONT(17, 15);
//            kahaoLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:kahaoLabel];
            self.kahaoLabel=kahaoLabel;
        }
        if (indexPath.row==4)
        {
            UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            cityLabel.text=self.city;
            //            ckrLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:cityLabel];
            self.cityLabel=cityLabel;
            //            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==5)
        {
            UILabel *zhihangLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
            zhihangLabel.text=self.zhihang;
            zhihangLabel.font=FONT(17, 15);
            //            kahaoLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:zhihangLabel];
            self.zhihangLabel=zhihangLabel;
        }
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
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
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(90), WZ(50))];
        titleLabel.text=@"提现金额";
        [cell.contentView addSubview:titleLabel];
        
        UITextField *tiXianTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
        tiXianTF.delegate=self;
        tiXianTF.placeholder=@"请输入提现金额";
        tiXianTF.text=self.tiXianMoney;
        tiXianTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        [cell.contentView addSubview:tiXianTF];
        self.tiXianTF=tiXianTF;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"Cell2";
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
        
        UIButton *nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        nextBtn.backgroundColor=COLOR(254, 167, 173, 1);
        nextBtn.layer.cornerRadius=5.0;
        nextBtn.clipsToBounds=YES;
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:nextBtn];
        
        cell.backgroundColor=COLOR_HEADVIEW;
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
    if (section==1)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, titleView.width-WZ(15*2), titleView.height)];
        noticeLabel.text=@"提现金额转入银行卡";
        noticeLabel.textColor=COLOR_LIGHTGRAY;
        noticeLabel.font=FONT(13,11);
        noticeLabel.textAlignment=NSTextAlignmentRight;
        [titleView addSubview:noticeLabel];
        
        return titleView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2)
    {
        return WZ(110);
    }
    else
    {
        return WZ(50);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return WZ(15);
    }
    if (section==1)
    {
        return WZ(40);
    }
    else
    {
        return 0;
    }
    
}

//textField代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tiXianMoney=textField.text;
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//下一步
-(void)nextBtnClick
{
    [self.tiXianTF resignFirstResponder];
    
    CGFloat tixian=[[NSString stringWithFormat:@"%.2f",[self.tiXianMoney floatValue]] floatValue];
    
    if (tixian<10)
    {
        [self.view makeToast:@"温馨提示:10元以上才可提现" duration:2.0];
    }
    else
    {
        if (tixian>[self.ktxBrokerage floatValue])
        {
            [self.view makeToast:@"提现金额不能超过可提现总额!" duration:2.0];
        }
        else
        {
            TiXianConfirmViewController *vc=[[TiXianConfirmViewController alloc]init];
            vc.bankName=self.bankName;
            vc.cardNumber=self.cardNumber;
            vc.khUserName=self.khUserName;
            vc.city=self.city;
            vc.zhihang=self.zhihang;
            vc.tiXianMoney=[NSString stringWithFormat:@"%.2f",tixian];
            [self.navigationController pushViewController:vc animated:YES];
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
