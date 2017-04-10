//
//  BindBankCardConfirmViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "BindBankCardConfirmViewController.h"

#import "BindBankCardOKViewController.h"


@interface BindBankCardConfirmViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITableView *_smallTableView;

    
}

@property(nonatomic,strong)UILabel *bankLabel;
@property(nonatomic,strong)UITextField *kahaoTF;
@property(nonatomic,strong)UITextField *cityTF;
@property(nonatomic,strong)UITextField *zhihangTF;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *idCardTF;
@property(nonatomic,strong)UITextField *mobileTF;

@property(nonatomic,strong)UIView *smallBgView;
@property(nonatomic,strong)NSMutableArray *bankListArray;
@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *bankId;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *zhihang;
@property(nonatomic,strong)NSString *bankCardNum;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *idCardNum;
@property(nonatomic,strong)NSString *mobile;





@end

@implementation BindBankCardConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bankName=@"选择银行";
    self.bankId=@"";
    self.bankCardNum=@"";
    self.city=@"";
    self.zhihang=@"";
    self.userName=@"";
    self.idCardNum=@"";
    self.mobile=@"";
    
    self.bankListArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
}

-(void)createNavigationBar
{
    self.title=@"绑定银行卡";
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
    if (tableView==_tableView)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        if (section==0)
        {
            return 4;
        }
        if (section==1)
        {
            return 3;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return self.bankListArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"开户银行",@"银行卡号",@"开户城市",@"支行名称", nil];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(90), WZ(50))];
            titleLabel.text=titleArray[indexPath.row];
            titleLabel.font=FONT(17, 15);
            //        titleLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:titleLabel];
            
            if (indexPath.row==0)
            {
                UILabel *bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                bankLabel.text=self.bankName;
                bankLabel.textColor=COLOR_LIGHTGRAY;
                bankLabel.font=FONT(17, 15);
                //            bankLabel.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:bankLabel];
                self.bankLabel=bankLabel;
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==1)
            {
                UITextField *kahaoTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                kahaoTF.delegate=self;
                kahaoTF.tag=0;
                kahaoTF.text=self.bankCardNum;
                kahaoTF.font=FONT(17, 15);
                kahaoTF.placeholder=@"请输入银行卡号";
                kahaoTF.keyboardType=UIKeyboardTypeNumberPad;
                //            kahaoTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:kahaoTF];
                self.kahaoTF=kahaoTF;
            }
            if (indexPath.row==2)
            {
                UITextField *cityTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                cityTF.delegate=self;
                cityTF.tag=1;
                cityTF.text=self.city;
                cityTF.font=FONT(17, 15);
                cityTF.placeholder=@"请输入开户行所在城市";
                //            cityTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:cityTF];
                self.cityTF=cityTF;
            }
            if (indexPath.row==3)
            {
                UITextField *zhihangTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                zhihangTF.delegate=self;
                zhihangTF.tag=2;
                zhihangTF.text=self.zhihang;
                zhihangTF.font=FONT(17, 15);
                zhihangTF.placeholder=@"请输入支行名称";
                //            zhihangTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:zhihangTF];
                self.zhihangTF=zhihangTF;
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"姓名",@"身份证号",@"手机号", nil];
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(90), WZ(50))];
            titleLabel.text=titleArray[indexPath.row];
            titleLabel.font=FONT(17, 15);
            //        titleLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:titleLabel];
            
            if (indexPath.row==0)
            {
                UITextField *nameTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                nameTF.delegate=self;
                nameTF.tag=3;
                nameTF.text=self.userName;
                nameTF.placeholder=@"请输入姓名";
                nameTF.font=FONT(17, 15);
                //            nameTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:nameTF];
                self.nameTF=nameTF;
            }
            if (indexPath.row==1)
            {
                UITextField *idCardTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                idCardTF.delegate=self;
                idCardTF.tag=4;
                idCardTF.text=self.idCardNum;
                idCardTF.placeholder=@"请输入身份证号";
                idCardTF.font=FONT(17, 15);
                idCardTF.keyboardType=UIKeyboardTypeAlphabet;
                //            idCardTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:idCardTF];
                self.idCardTF=idCardTF;
            }
            if (indexPath.row==2)
            {
                UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10)-titleLabel.width, WZ(50))];
                mobileTF.delegate=self;
                mobileTF.tag=5;
                mobileTF.text=self.mobile;
                mobileTF.font=FONT(17, 15);
                mobileTF.placeholder=@"请输入手机号";
                mobileTF.keyboardType=UIKeyboardTypeNumberPad;
                //            mobileTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:mobileTF];
                self.mobileTF=mobileTF;
            }
            
            
            
            
            
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
            
            UIButton *confirmBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
            confirmBtn.backgroundColor=COLOR(254, 167, 173, 1);
            confirmBtn.layer.cornerRadius=5.0;
            confirmBtn.clipsToBounds=YES;
            [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
            [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:confirmBtn];
            
            CGSize labelSize=[ViewController sizeWithString:@"绑定表示同意" font:FONT(13,11) maxSize:CGSizeMake(WZ(150), WZ(20))];
            
            UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(confirmBtn.left, confirmBtn.bottom+WZ(15), labelSize.width, WZ(20))];
            detailLabel.text=@"绑定表示同意";
            detailLabel.font=FONT(13,11);
            detailLabel.textColor=COLOR_LIGHTGRAY;
            [cell.contentView addSubview:detailLabel];
            
            CGSize btnSize=[ViewController sizeWithString:@"《银行卡支付服务协议》" font:FONT(13,11) maxSize:CGSizeMake(WZ(180), WZ(20))];
            
            UIButton *detailBtn=[[UIButton alloc]initWithFrame:CGRectMake(detailLabel.right, detailLabel.top, btnSize.width, WZ(20))];
            [detailBtn setTitle:@"《银行卡支付服务协议》" forState:UIControlStateNormal];
            [detailBtn setTitleColor:COLOR(146, 135, 187, 1) forState:UIControlStateNormal];
            detailBtn.titleLabel.font=FONT(13,11);
            [detailBtn addTarget:self action:@selector(detailBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:detailBtn];
            
            
            
            
            
            cell.backgroundColor=COLOR_HEADVIEW;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        static NSString *cellIdentifier=@"Cell3";
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
        NSString *bankId=[NSString stringWithFormat:@"%@",[bankDict objectForKey:@"id"]];
        NSString *bankName=[bankDict objectForKey:@"name"];
        
        UILabel *bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15), WZ(50))];
        bankLabel.text=bankName;
        bankLabel.font=FONT(17, 15);
        [cell.contentView addSubview:bankLabel];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (tableView==_tableView)
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"获取中..." detail:nil];
                [hud show:YES];
                [hud hide:YES afterDelay:20];
                //获取开户银行数据
                [HTTPManager getOpeningBankList:^(NSMutableArray *mutableArray) {
                    self.bankListArray=mutableArray;
                    
                    [hud hide:YES];
                    [self createSmallTableView];
                }];
                
                
            }
        }
    }
    else
    {
        //选定开户银行
        NSDictionary *bankDict=self.bankListArray[indexPath.row];
        self.bankId=[NSString stringWithFormat:@"%@",[bankDict objectForKey:@"id"]];
        self.bankName=[bankDict objectForKey:@"name"];
        self.bankLabel.text=self.bankName;
        self.bankLabel.textColor=COLOR_BLACK;
        [self.smallBgView removeFromSuperview];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        if (section==0)
        {
            UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(25))];
            titleView.backgroundColor=COLOR_HEADVIEW;
            
            return titleView;
        }
        if (section==1)
        {
            UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
            titleView.backgroundColor=COLOR_HEADVIEW;
            
            return titleView;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
    {
        if (indexPath.section==2)
        {
            return WZ(120);
        }
        else
        {
            return WZ(50);
        }
    }
    else
    {
        return WZ(50);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        if (section==0)
        {
            return WZ(25);
        }
        if (section==1)
        {
            return WZ(15);
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        self.bankCardNum=textField.text;
    }
    if (textField.tag==1)
    {
        self.city=textField.text;
    }
    if (textField.tag==2)
    {
        self.zhihang=textField.text;
    }
    if (textField.tag==3)
    {
        self.userName=textField.text;
    }
    if (textField.tag==4)
    {
        self.idCardNum=textField.text;
    }
    if (textField.tag==5)
    {
        self.mobile=textField.text;
    }
}

-(void)createSmallTableView
{
    UIView *smallBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    smallBgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    [self.view.window addSubview:smallBgView];
    self.smallBgView=smallBgView;
    
    _smallTableView=[[UITableView alloc]initWithFrame:CGRectMake(WZ(30), 64, SCREEN_WIDTH-WZ(30*2), SCREEN_HEIGHT-64-49-WZ(50))];
    _smallTableView.delegate=self;
    _smallTableView.dataSource=self;
    _smallTableView.tableFooterView=[[UIView alloc]init];
    [smallBgView addSubview:_smallTableView];
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(30), SCREEN_HEIGHT-49-WZ(50), SCREEN_WIDTH-WZ(30*2), WZ(50))];
    cancelBtn.backgroundColor=COLOR_LIGHTGRAY;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=FONT(17, 15);
    [cancelBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [smallBgView addSubview:cancelBtn];
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//确定绑定银行卡
-(void)confirmBtnClick
{
//    NSLog(@"绑定银行卡");
    
    
    [self.kahaoTF resignFirstResponder];
    [self.cityTF resignFirstResponder];
    [self.zhihangTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.idCardTF resignFirstResponder];
    [self.mobileTF resignFirstResponder];
    
    if ([self.bankName isEqualToString:@"选择银行"])
    {
        [self.view makeToast:@"请选择开户银行" duration:2.0];
    }
    else
    {
        if ([self.bankCardNum isEqualToString:@""])
        {
            [self.view makeToast:@"银行卡号不能为空" duration:2.0];
        }
        else
        {
            if ([ViewController validateBankCardNumber:self.bankCardNum]==NO)
            {
                [self.view makeToast:@"请输入正确的银行卡号" duration:2.0];
            }
            else
            {
                if ([self.city isEqualToString:@""])
                {
                    [self.view makeToast:@"开户行所在城市不能为空" duration:2.0];
                }
                else
                {
                    if ([self.zhihang isEqualToString:@""])
                    {
                        [self.view makeToast:@"支行名称不能为空" duration:2.0];
                    }
                    else
                    {
                        if ([self.userName isEqualToString:@""])
                        {
                            [self.view makeToast:@"姓名不能为空" duration:2.0];
                        }
                        else
                        {
                            if ([self.idCardNum isEqualToString:@""])
                            {
                                [self.view makeToast:@"身份证号不能为空" duration:2.0];
                            }
                            else
                            {
                                if ([ViewController validateIdentityCard:self.idCardNum]==NO)
                                {
                                    [self.view makeToast:@"请输入正确的身份证号" duration:2.0];
                                }
                                else
                                {
                                    if ([self.mobile isEqualToString:@""])
                                    {
                                        [self.view makeToast:@"手机号不能为空" duration:2.0];
                                    }
                                    else
                                    {
                                        if ([ViewController validateMobile:self.mobile]==NO)
                                        {
                                            [self.view makeToast:@"请输入正确的手机号" duration:2.0];
                                        }
                                        else
                                        {
                                            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"绑定中..." detail:nil];
                                            [hud show:YES];
                                            [hud hide:YES afterDelay:20];
                                            //满足以上条件 发起绑定银行卡请求
                                            [HTTPManager bindBankCardWithBankName:self.bankName cardNumber:self.bankCardNum bankCity:self.city subBranch:self.zhihang khUserName:self.userName phone:self.mobile idCard:self.idCardNum userId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
                                                if ([[resultDict objectForKey:@"result"] isEqualToString:STATUS_SUCCESS])
                                                {
                                                    NSDictionary *userBankDict=[resultDict objectForKey:@"userbank"];
                                                    
                                                    //绑定成功之后跳转绑定成功界面
                                                    BindBankCardOKViewController *vc=[[BindBankCardOKViewController alloc]init];
                                                    vc.bankDict=userBankDict;
                                                    [self.navigationController pushViewController:vc animated:YES];
                                                    
                                                    self.bankLabel.text=@"";
                                                    self.kahaoTF.text=@"";
                                                    self.cityTF.text=@"";
                                                    self.zhihangTF.text=@"";
                                                    self.nameTF.text=@"";
                                                    self.idCardTF.text=@"";
                                                    self.mobileTF.text=@"";
                                                    self.bankName=@"";
                                                    self.city=@"";
                                                    self.zhihang=@"";
                                                    self.bankCardNum=@"";
                                                    self.userName=@"";
                                                    self.mobile=@"";
                                                    self.idCardNum=@"";
                                                }
                                                else
                                                {
                                                    NSString *error=[resultDict objectForKey:@"error"];
                                                    [self.view makeToast:error duration:2.0];
                                                }
                                                [hud hide:YES];
                                            }];
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
}

//银行卡支付服务协议
-(void)detailBtn
{
    
    NSLog(@"银行卡支付服务协议");
    
}

//取消选择地址
-(void)cancelBtnClick
{
    [self.smallBgView removeFromSuperview];
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
