//
//  AddShippingAddressViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AddShippingAddressViewController.h"

//#import "MapViewController.h"

@interface AddShippingAddressViewController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    UITextField *_nameTF;
    UITextField *_mobileTF;
//    UIButton *_addressBtn;
    UITextField *_addressTF;
    YYTextView *_detailTV;
}

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *pca;
@property(nonatomic,strong)NSString *detail;
@property(nonatomic,assign)BOOL isDefault;
@property(nonatomic,strong)NSString *addressId;


@end

@implementation AddShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isAddAddress==YES)
    {
        self.name=@"";
        self.mobile=@"";
        self.pca=@"";
        self.detail=@"";
        self.isDefault=YES;
        self.addressId=@"";
    }
    if (self.isEditAddress==YES)
    {
        self.name=[self.addressDict objectForKey:@"username"];
        self.mobile=[self.addressDict objectForKey:@"userphone"];
        self.pca=[self.addressDict objectForKey:@"city"];
        self.detail=[self.addressDict objectForKey:@"address"];
        self.addressId=[NSString stringWithFormat:@"%@",[self.addressDict objectForKey:@"id"]];
        
        NSString *defaultStr=[NSString stringWithFormat:@"%@",[self.addressDict objectForKey:@"status"]];
        if ([defaultStr isEqualToString:@"0"])
        {
            self.isDefault=NO;
        }
        if ([defaultStr isEqualToString:@"1"])
        {
            self.isDefault=YES;
        }
    }
    
    [self createNavigationBar];
    [self createTableView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddressNotification:) name:@"address" object:nil];
    
    
    
}

//-(void)getAddressNotification:(NSNotification*)notification
//{
//    NSDictionary *addressDict=[notification userInfo];
//    NSString *pcaAddress=[addressDict objectForKey:@"pca"];
//    NSString *detailAddress=[addressDict objectForKey:@"street"];
//    self.pca=pcaAddress;
//    self.detail=detailAddress;
//    
//    [_tableView reloadData];
//}



-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    if (self.isAddAddress==YES)
    {
        self.title=@"新增地址";
    }
    if (self.isEditAddress==YES)
    {
        self.title=@"编辑地址";
    }
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
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
        return 4;
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
        
        if (indexPath.row==0)
        {
            _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            _nameTF.delegate=self;
            _nameTF.text=self.name;
            _nameTF.placeholder=@"收货人姓名";
            _nameTF.font=FONT(17,15);
            [cell.contentView addSubview:_nameTF];
        }
        if (indexPath.row==1)
        {
            _mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            _mobileTF.delegate=self;
            _mobileTF.text=self.mobile;
            _mobileTF.placeholder=@"收货人手机";
            _mobileTF.keyboardType=UIKeyboardTypeNumberPad;
            _mobileTF.font=FONT(17,15);
            [cell.contentView addSubview:_mobileTF];
        }
        if (indexPath.row==2)
        {
            _addressTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            _addressTF.delegate=self;
            _addressTF.text=self.pca;
            _addressTF.placeholder=@"收货地址（包含省市区）";
            _addressTF.font=FONT(17,15);
            [cell.contentView addSubview:_addressTF];
            
//            UILabel *cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2+10+10), WZ(50))];
//            cityLabel.text=self.pca;
//            cityLabel.font=FONT(17,15);
//            [cell.contentView addSubview:cityLabel];
//            
//            if ([self.pca isEqualToString:@"选择省市区"])
//            {
//                cityLabel.textColor=COLOR(200, 200, 200, 1);
//            }
//            
//            
//            UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10), WZ(15), WZ(10), WZ(20))];
//            //        jiantouIV.backgroundColor=COLOR_CYAN;
//            jiantouIV.image=IMAGE(@"youjiantou_hei");
//            [cell.contentView addSubview:jiantouIV];
//            
//            _addressBtn=[[UIButton alloc]initWithFrame:CGRectMake(cityLabel.left, 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
//            [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:_addressBtn];
        }
        if (indexPath.row==3)
        {
            _detailTV=[[YYTextView alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            _detailTV.delegate=self;
            _detailTV.text=self.detail;
            _detailTV.placeholderText=@"详细街道地址";
            _detailTV.placeholderTextColor=COLOR(200, 200, 200, 1);
            _detailTV.placeholderFont=FONT(17,15);
            _detailTV.font=FONT(17,15);
            [cell.contentView addSubview:_detailTV];
        }
        
        
        
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
        
        cell.textLabel.text=@"设置为默认地址";
        
        UISwitch *aSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(50), WZ(10), WZ(50), WZ(30))];
        aSwitch.onTintColor=COLOR(254, 153, 160, 1);
        [aSwitch addTarget:self action:@selector(aSwitchChange) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=aSwitch;
        
        if (self.isDefault==YES)
        {
            aSwitch.on=YES;
        }
        if (self.isDefault==NO)
        {
            aSwitch.on=NO;
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
    headView.backgroundColor=COLOR_HEADVIEW;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(15);
}

- (void)textViewDidChange:(YYTextView *)textView
{
    self.detail=textView.text;
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_nameTF)
    {
        self.name=textField.text;
    }
    if (textField==_mobileTF)
    {
        self.mobile=textField.text;
    }
    if (textField==_addressTF)
    {
        self.pca=textField.text;
    }
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存地址
-(void)rightBtnClick
{
    NSLog(@"保存地址");
    
    [_nameTF resignFirstResponder];
    [_mobileTF resignFirstResponder];
    [_addressTF resignFirstResponder];
    [_detailTV resignFirstResponder];
    
    if ([_nameTF.text isEqualToString:@""])
    {
        [self.view makeToast:@"收货人姓名不能为空" duration:2.0];
    }
    else
    {
        if ([_mobileTF.text isEqualToString:@""])
        {
            [self.view makeToast:@"手机号码不能为空" duration:2.0];
        }
        else
        {
            if ([ViewController validateMobile:_mobileTF.text]==NO)
            {
                [self.view makeToast:@"手机号码不正确" duration:2.0];
            }
            else
            {
                if ([self.pca isEqualToString:@""])
                {
                    [self.view makeToast:@"未填写省市区" duration:2.0];
                }
                else
                {
                    if ([self.detail isEqualToString:@""])
                    {
                        [self.view makeToast:@"未填写详细地址" duration:2.0];
                    }
                    else
                    {
                        NSString *status;
                        if (self.isDefault==YES)
                        {
                            status=@"1";
                        }
                        if (self.isDefault==NO)
                        {
                            status=@"0";
                        }
                        
                        //保存地址
                        [HTTPManager addOrEditShippingAddressWidhUserId:[UserInfoData getUserInfoFromArchive].userId userName:_nameTF.text userPhone:_mobileTF.text city:self.pca address:self.detail addressId:self.addressId status:status complete:^(NSDictionary *resultDict) {
                            NSString *result=[resultDict objectForKey:@"result"];
                            
                            if ([result isEqualToString:STATUS_SUCCESS])
                            {
                                if (self.isEditAddress==YES)
                                {
                                    [self.view.window makeToast:@"修改地址成功" duration:2.0];
                                }
                                if (self.isAddAddress==YES)
                                {
                                    [self.view.window makeToast:@"新增地址成功" duration:2.0];
                                }
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            if ([result isEqualToString:STATUS_FAILURE])
                            {
                                NSString *error=[resultDict objectForKey:@"error"];
                                [self.view makeToast:error duration:2.0];
                            }
                            
                            
                        }];
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
    
}

////选择省市区
//-(void)addressBtnClick
//{
//    MapViewController *vc=[[MapViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

//是否设为默认地址
-(void)aSwitchChange
{
    self.isDefault=!self.isDefault;
    
    if (self.isDefault==YES)
    {
        NSLog(@"设为了默认地址");
    }
    if (self.isDefault==NO)
    {
        NSLog(@"不设为默认地址");
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
