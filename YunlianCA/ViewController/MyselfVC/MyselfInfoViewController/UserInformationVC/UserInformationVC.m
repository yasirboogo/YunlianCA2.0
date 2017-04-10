//
//  UserInformationVC.m
//  YunlianCA
//
//  Created by QinJun on 2016/11/11.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "UserInformationVC.h"

@interface UserInformationVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
}

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;

@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *emailTF;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UIButton *certificateBtn;
@property(nonatomic,strong)UITextField *personIDTF;
@property(nonatomic,strong)UIButton *nanBtn;
@property(nonatomic,strong)UIButton *nvBtn;
@property(nonatomic,strong)UITextField *ylhIDTF;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *typeID;
@property(nonatomic,strong)NSString *personID;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *ylhID;





@end

@implementation UserInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEdit=NO;
    
    self.phone=@"";
    self.email=@"";
    self.name=@"";
    self.type=@"身份证";
    self.typeID=@"";
    self.personID=@"";
    self.sex=@"";
    self.ylhID=@"";
    
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
    
    
}

//获取支付端用户信息
-(void)getMerUserInfo
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    [HTTPManager getMerUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userDict=[resultDict objectForKey:@"user"];
            self.phone=[userDict objectForKey:@"phone"];
            self.email=[userDict objectForKey:@"email"];
            self.name=[userDict objectForKey:@"name"];
            self.typeID=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"personType"]];
            self.personID=[userDict objectForKey:@"personId"];
            self.sex=[userDict objectForKey:@"sex"];
            self.ylhID=[userDict objectForKey:@"ylhId"];
            
            if ([self.sex integerValue]==1)
            {
                self.nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
                [self.nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                self.nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
                [self.nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
            }
            if ([self.sex integerValue]==2)
            {
                self.nvBtn.backgroundColor=COLOR(254, 167, 173, 1);
                [self.nvBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                self.nanBtn.backgroundColor=COLOR(211, 211, 211, 1);
                [self.nanBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
            }
            
            if ([self.typeID integerValue]==1)
            {
                self.type=@"身份证";
            }
            if ([self.typeID integerValue]==2)
            {
                self.type=@"军官证";
            }
            if ([self.typeID integerValue]==3)
            {
                self.type=@"护照";
            }
            
            [hud hide:YES];
            [_tableView reloadData];
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:2.0];
        }
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getMerUserInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"用户资料";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitleColor:COLOR(254, 167, 173, 1) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    self.rightBtn=rightBtn;
    if (self.isEdit==NO)
    {
        [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    else
    {
        [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    
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
        return 5;
    }
    else
    {
        return 2;
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
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"手机号",@"邮箱",@"真实姓名",@"证件类型",@"证件号码", nil];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(100), WZ(30))];
        titleLabel.text=titleArray[indexPath.row];
        titleLabel.font=FONT(15, 13);
//        titleLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row==0)
        {
            UITextField *phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2+20)-titleLabel.width, WZ(30))];
            phoneTF.delegate=self;
            phoneTF.text=self.phone;
            phoneTF.font=FONT(15,13);
            phoneTF.placeholder=@"暂无手机号";
//            phoneTF.text=@"18565305463";
            phoneTF.textColor=COLOR_LIGHTGRAY;
            phoneTF.textAlignment=NSTextAlignmentRight;
            phoneTF.userInteractionEnabled=NO;
            [cell.contentView addSubview:phoneTF];
//            phoneTF.backgroundColor=COLOR_RED;
            self.phoneTF=phoneTF;
            
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        if (indexPath.row==1)
        {
            UITextField *emailTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2+20)-titleLabel.width, WZ(30))];
            emailTF.delegate=self;
            emailTF.text=self.email;
            emailTF.font=FONT(15,13);
            emailTF.placeholder=@"暂无邮箱";
//            emailTF.text=@"kingqinchn@163.com";
            emailTF.textColor=COLOR_LIGHTGRAY;
            emailTF.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:emailTF];
//            emailTF.backgroundColor=COLOR_RED;
            self.emailTF=emailTF;
            
            if (self.email.length>0)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        if (indexPath.row==2)
        {
            UITextField *nameTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2+20)-titleLabel.width, WZ(30))];
            nameTF.delegate=self;
            nameTF.text=self.name;
            nameTF.font=FONT(15,13);
            nameTF.placeholder=@"暂无真实姓名";
//            nameTF.text=@"秦军";
            nameTF.textColor=COLOR_LIGHTGRAY;
            nameTF.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:nameTF];
//            nameTF.backgroundColor=COLOR_RED;
            self.nameTF=nameTF;
            
            if (self.name.length>0)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        if (indexPath.row==3)
        {
            UIButton *certificateBtn=[[UIButton alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2+20)-titleLabel.width, WZ(30))];
            [certificateBtn setTitle:self.type forState:UIControlStateNormal];
//            [certificateBtn setTitle:@"身份证" forState:UIControlStateNormal];
            [certificateBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
            certificateBtn.titleLabel.font=FONT(15, 13);
            certificateBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
            certificateBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);//上左下右
            [certificateBtn addTarget:self action:@selector(certificateBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:certificateBtn];
            self.certificateBtn=certificateBtn;
//            certificateBtn.backgroundColor=COLOR_RED;
            
            if (self.personID.length>0)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        if (indexPath.row==4)
        {
            UITextField *personIDTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2+20)-titleLabel.width, WZ(30))];
            personIDTF.delegate=self;
            personIDTF.text=self.personID;
            personIDTF.font=FONT(15,13);
            personIDTF.placeholder=@"暂无证件号码";
            personIDTF.textColor=COLOR_LIGHTGRAY;
            personIDTF.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:personIDTF];
            self.personIDTF=personIDTF;
            
            if (self.personID.length>0)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        
        if (self.isEdit==NO)
        {
            self.emailTF.userInteractionEnabled=NO;
            self.nameTF.userInteractionEnabled=NO;
            self.certificateBtn.userInteractionEnabled=NO;
            self.personIDTF.userInteractionEnabled=NO;
        }
        else
        {
            self.nameTF.userInteractionEnabled=YES;
            
            if (self.email.length>0)
            {
                self.emailTF.userInteractionEnabled=NO;
            }
            else
            {
                self.emailTF.userInteractionEnabled=YES;
            }
            
            if (self.name.length>0)
            {
                self.nameTF.userInteractionEnabled=NO;
            }
            else
            {
                self.nameTF.userInteractionEnabled=YES;
            }
            
            if (self.personID.length>0)
            {
                self.certificateBtn.userInteractionEnabled=NO;
                self.personIDTF.userInteractionEnabled=NO;
            }
            else
            {
                self.certificateBtn.userInteractionEnabled=YES;
                self.personIDTF.userInteractionEnabled=YES;
            }
            
            
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
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"性别",@"云联惠ID", nil];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(100), WZ(30))];
        titleLabel.text=titleArray[indexPath.row];
        titleLabel.font=FONT(15, 13);
//        titleLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row==0)
        {
            UIButton *nanBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(24)-WZ(20)-WZ(24), WZ(13), WZ(24), WZ(24))];
            nanBtn.clipsToBounds=YES;
            nanBtn.layer.cornerRadius=nanBtn.width/2.0;
            nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
            nanBtn.titleLabel.font=FONT(13,11);
            [nanBtn setTitle:@"男" forState:UIControlStateNormal];
            [nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            [nanBtn addTarget:self action:@selector(nanBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nanBtn];
            self.nanBtn=nanBtn;
            
            UIButton *nvBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(24), WZ(13), WZ(24), WZ(24))];
            nvBtn.clipsToBounds=YES;
            nvBtn.layer.cornerRadius=nvBtn.width/2.0;
            nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
            nvBtn.titleLabel.font=FONT(13,11);
            [nvBtn setTitle:@"女" forState:UIControlStateNormal];
            [nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
            [nvBtn addTarget:self action:@selector(nvBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:nvBtn];
            self.nvBtn=nvBtn;
            
            if ([self.sex isEqualToString:@"1"])
            {
                nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
                [nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
                [nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
            }
            if ([self.sex isEqualToString:@"2"])
            {
                nvBtn.backgroundColor=COLOR(254, 167, 173, 1);
                [nvBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                nanBtn.backgroundColor=COLOR(211, 211, 211, 1);
                [nanBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
            }
            
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        if (indexPath.row==1)
        {
            UITextField *ylhIDTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, WZ(10), SCREEN_WIDTH-WZ(15*2+20)-titleLabel.width, WZ(30))];
            ylhIDTF.delegate=self;
            ylhIDTF.text=self.ylhID;
            ylhIDTF.font=FONT(15,13);
            ylhIDTF.placeholder=@"暂无云联惠ID";
            ylhIDTF.textColor=COLOR_LIGHTGRAY;
            ylhIDTF.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:ylhIDTF];
            self.ylhIDTF=ylhIDTF;
        }
        
        if (self.isEdit==NO)
        {
            self.nanBtn.userInteractionEnabled=NO;
            self.nvBtn.userInteractionEnabled=NO;
            self.ylhIDTF.userInteractionEnabled=NO;
        }
        else
        {
            self.nanBtn.userInteractionEnabled=YES;
            self.nvBtn.userInteractionEnabled=YES;
            self.ylhIDTF.userInteractionEnabled=YES;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
    headView.backgroundColor=COLOR_HEADVIEW;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(10);
}

//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.phoneTF==textField)
    {
        self.phone=textField.text;
    }
    if (self.emailTF==textField)
    {
        self.email=textField.text;
    }
    if (self.nameTF==textField)
    {
        self.name=textField.text;
    }
    if (self.personIDTF==textField)
    {
        self.personID=textField.text;
    }
    if (self.ylhIDTF==textField)
    {
        self.ylhID=textField.text;
    }
}



#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑用户信息
-(void)rightBtnClick
{
    if (self.isEdit==NO)
    {
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        //所有右边控件开启交互
        [self.nameTF becomeFirstResponder];
        
        self.emailTF.userInteractionEnabled=NO;
        self.nameTF.userInteractionEnabled=NO;
        self.certificateBtn.userInteractionEnabled=NO;
        self.personIDTF.userInteractionEnabled=NO;
        self.nanBtn.userInteractionEnabled=NO;
        self.nvBtn.userInteractionEnabled=NO;
        self.ylhIDTF.userInteractionEnabled=NO;
        
        self.isEdit=!self.isEdit;
        [_tableView reloadData];
    }
    else
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        if ([ViewController validateEmail:self.emailTF.text]==NO)
        {
            [self.view makeToast:@"邮箱格式不正确" duration:2.0];
        }
        else
        {
            if ([ViewController validateIdentityCard:self.personIDTF.text]==NO)
            {
                [self.view makeToast:@"身份证格式不正确" duration:2.0];
            }
            else
            {
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"修改中..." detail:nil];
                [hud show:YES];
                [hud hide:YES afterDelay:20];
                [HTTPManager changeMerUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId phone:self.phone email:self.email name:self.name personType:self.typeID personId:self.personID sex:self.sex birthday:@"" areaId:@"" address:@"" tjPhone:@"" ylhId:self.ylhID complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
                        //所有右边控件关闭交互 发送修改信息请求
                        if (self.email.length>0)
                        {
                            self.emailTF.userInteractionEnabled=NO;
                        }
                        else
                        {
                            self.emailTF.userInteractionEnabled=YES;
                        }
                        
                        if (self.name.length>0)
                        {
                            self.nameTF.userInteractionEnabled=NO;
                        }
                        else
                        {
                            self.nameTF.userInteractionEnabled=YES;
                        }
                        
                        if (self.personID.length>0)
                        {
                            self.certificateBtn.userInteractionEnabled=NO;
                            self.personIDTF.userInteractionEnabled=NO;
                        }
                        else
                        {
                            self.certificateBtn.userInteractionEnabled=YES;
                            self.personIDTF.userInteractionEnabled=YES;
                        }
                        
                        self.nameTF.userInteractionEnabled=YES;
                        self.nanBtn.userInteractionEnabled=YES;
                        self.nvBtn.userInteractionEnabled=YES;
                        self.ylhIDTF.userInteractionEnabled=YES;
                        
                        self.isEdit=!self.isEdit;
                        [_tableView reloadData];
                        
                        [self.view makeToast:@"修改成功" duration:2.0];
                    }
                    else
                    {
                        NSString *msg=[resultDict objectForKey:@"msg"];
                        [self.view makeToast:msg duration:2.0];
                    }
                    [hud hide:YES];
                }];
            }
            
        }
        
        
        
    }
    
}

//男
-(void)nanBtnClick
{
    self.nanBtn.userInteractionEnabled = NO;
    self.nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
    [self.nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    self.nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
    [self.nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
    
    self.sex=@"1";
    NSLog(@"选择男");
}

//女
-(void)nvBtnClick
{
    self.nvBtn.backgroundColor=COLOR(254, 167, 173, 1);
    [self.nvBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    self.nanBtn.backgroundColor=COLOR(211, 211, 211, 1);
    [self.nanBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
    
    self.sex=@"2";
    
    NSLog(@"选择女");
}

//证件类型
-(void)certificateBtnClick
{
    NSLog(@"证件类型");
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    //1、身份证 2、军官证 3、护照
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"证件类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"身份证",@"军官证",@"护照", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.typeID=[NSString stringWithFormat:@"%ld",buttonIndex+1];
    if (buttonIndex==0)
    {
        self.type=@"身份证";
    }
    if (buttonIndex==1)
    {
        self.type=@"军官证";
    }
    if (buttonIndex==2)
    {
        self.type=@"护照";
    }
    
    [self.certificateBtn setTitle:self.type forState:UIControlStateNormal];
    
}

////生日
//-(void)birthdayBtnClick
//{
//    NSLog(@"生日");
//    
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    
//    CGFloat viewWidth=SCREEN_WIDTH-WZ(30*2);
//    CGFloat viewHeight=SCREEN_WIDTH-WZ(30*2);
//    
//    [self createBackgroundViewWithSmallViewFrame:CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight) titleString:@"选择生日" datePickerMode:1];
//}
//
////创建背景View
//-(void)createBackgroundViewWithSmallViewFrame:(CGRect)frame titleString:(NSString *)titleString datePickerMode:(NSInteger)datePickerMode
//{
//    CGFloat spaceToBorder=WZ(20);
//    
//    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
//    [self.view.window addSubview:bgView];
//    self.bgView=bgView;
//    
//    UIView *smallView=[[UIView alloc]initWithFrame:frame];//CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight)
//    smallView.backgroundColor=COLOR_WHITE;
//    smallView.clipsToBounds=YES;
//    smallView.layer.cornerRadius=5;
//    [self.bgView addSubview:smallView];
//    self.smallView=smallView;
//    
//    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(WZ(20), WZ(40)+WZ(10), self.smallView.width-WZ(20*2), WZ(200))];
//    //    datePicker.frame=CGRectMake(-WZ(20), WZ(40)+WZ(10), self.smallView.width+WZ(20), WZ(200));
//    //    datePicker.backgroundColor=COLOR_CYAN;
//    NSDate *currentTime=[NSDate date];
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//    [datePicker setDate:currentTime animated:YES];
//    [datePicker setMaximumDate:currentTime];
//    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
//    [datePicker setDatePickerMode:datePickerMode];
//    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [self.smallView addSubview:datePicker];
//    
////    if ([titleString isEqualToString:@"有效期开始时间"])
////    {
////        [datePicker setMinimumDate:currentTime];
////    }
////    if ([titleString isEqualToString:@"有效期结束时间"])
////    {
////        [datePicker setMinimumDate:[NSDate dateWithTimeInterval:86400 sinceDate:currentTime]];
////    }
//    
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), WZ(30))];
//    titleLabel.text=titleString;
//    titleLabel.textColor=COLOR_LIGHTGRAY;
//    titleLabel.font=FONT(17, 15);
//    titleLabel.textAlignment=NSTextAlignmentCenter;
//    [smallView addSubview:titleLabel];
//    
//    NSArray *qxqdArray=[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];
//    
//    CGFloat buttonWidth=WZ(100);
//    CGFloat buttonHeight=WZ(35);
//    CGFloat buttonSpace=frame.size.width-buttonWidth*2-spaceToBorder*2;
//    
//    for (NSInteger i=0; i<2; i++)
//    {
//        UIButton *qxqdBtn=[[UIButton alloc]initWithFrame:CGRectMake(spaceToBorder+(buttonWidth+buttonSpace)*(i%2), frame.size.height-buttonHeight-WZ(20), buttonWidth, buttonHeight)];
//        [qxqdBtn setTitle:qxqdArray[i] forState:UIControlStateNormal];
//        qxqdBtn.titleLabel.font=FONT(17, 15);
//        qxqdBtn.clipsToBounds=YES;
//        qxqdBtn.layer.cornerRadius=5;
//        qxqdBtn.tag=i;
//        [qxqdBtn addTarget:self action:@selector(qxqdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [smallView addSubview:qxqdBtn];
//        
//        if (i==0)
//        {
//            [qxqdBtn setTitleColor:COLOR(98, 99, 100, 1) forState:UIControlStateNormal];
//            qxqdBtn.backgroundColor=COLOR(230, 235, 235, 1);
//        }
//        if (i==1)
//        {
//            [qxqdBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
//            qxqdBtn.backgroundColor=COLOR(254, 167, 173, 1);
//        }
//        
//        
//        
//    }
//    
//    
//}
//
////选择时间的方法
//-(void)datePickerValueChanged:(UIDatePicker *)datePicker
//{
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    self.birthday = [formatter stringFromDate:datePicker.date];
//}
//
////选择日期时间View的取消和确定按钮
//-(void)qxqdBtnClick:(UIButton *)button
//{
//    if (button.tag==0)
//    {
//        [self.bgView removeFromSuperview];
//    }
//    else
//    {
//        [self.bgView removeFromSuperview];
//        [self.birthdayBtn setTitle:self.birthday forState:UIControlStateNormal];
//    }
//}







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
