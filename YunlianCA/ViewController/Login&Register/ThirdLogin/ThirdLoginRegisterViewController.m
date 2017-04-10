//
//  ThirdLoginRegisterViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/24.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ThirdLoginRegisterViewController.h"

#import "TabBarViewController.h"

#define CELL_HEIGHT WZ(50)

@interface ThirdLoginRegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_bigTableView;
    UITableView *_smallTableView;
    //是否已经点击获取验证码
    BOOL _isGetCode;
    NSTimer *_timer;
}

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,strong)UITextField *passwordTF;
@property(nonatomic,strong)UITextField *mobileTF;
@property(nonatomic,strong)UITextField *payPswTF;

@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *payPsw;
@property(nonatomic,strong)UIView *smallBgView;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *areaLabel;
@property(nonatomic,strong)UILabel *communityLabel;

@property(nonatomic,strong)NSMutableArray *addressArray;
@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *community;
@property(nonatomic,strong)NSString *provinceId;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *districtId;
@property(nonatomic,strong)NSString *areaId;
@property(nonatomic,strong)NSString *communityId;
@property(nonatomic,assign)NSInteger selectedRow;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *code;
@property(nonatomic,strong)UITextField *codeTF;
@property(nonatomic,strong)UIButton *yzmBtn;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,assign)BOOL cellHidden;
@property(nonatomic,strong)NSString *verifyCode;


@end

@implementation ThirdLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.verifyCode=@"";
    self.password=@"";
    self.state=@"";
    self.code=@"";
    self.token=@"";
    self.mobile=@"";
    self.payPsw=@"";
    self.address=@"";
    self.province=@"";
    self.city=@"";
    self.district=@"";
    self.area=@"";
    self.community=@"";
    self.provinceId=@"";
    self.cityId=@"";
    self.districtId=@"";
    self.areaId=@"";
    self.communityId=@"";
    
    _isGetCode=NO;
    self.cellHidden=NO;
    
    self.addressArray=[NSMutableArray array];
    self.areaArray=[NSMutableArray array];
    
    
    [self createNavigationBar];
    [self createBigTableView];
    
    
    
    
    
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
    [cancelBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [smallBgView addSubview:cancelBtn];
}

-(void)createNavigationBar
{
    self.title=@"云联社区联盟";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(10), WZ(20))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createBigTableView
{
    _bigTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bigTableView.delegate=self;
    _bigTableView.dataSource=self;
    //    _bigTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _bigTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_bigTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_bigTableView)
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
    if (tableView==_bigTableView)
    {
        if (section==0)
        {
            return 3;
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
        return self.addressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_bigTableView)
    {
        if (indexPath.section==0)
        {
            static NSString *cellIdentifier0=@"Cell0";
            UITableViewCell *cell0=[tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
            if (!cell0)
            {
                cell0=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0];
            }
            else
            {
                while ([cell0.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell0.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            NSArray *titleArray=@[@"手机号",@"验证码",@"支付密码"];
            
            UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), CELL_HEIGHT) text:titleArray[indexPath.row] textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
            [cell0.contentView addSubview: titleLabel];
            
            if (indexPath.row==0)
            {
                UITextField *mobileTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
                mobileTF.tag=0;
                mobileTF.delegate=self;
                mobileTF.font=FONT(15,13);
                mobileTF.placeholder=@"请输入手机号";
                mobileTF.text=self.mobile;
                mobileTF.keyboardType=UIKeyboardTypeNumberPad;
                [cell0.contentView addSubview:mobileTF];
                self.mobileTF=mobileTF;
            }
            if (indexPath.row==1)
            {
                CGSize yzmBtnStringSize=[ViewController sizeWithString:@"获取验证码" font:FONT(15,13) maxSize:CGSizeMake(WZ(120),WZ(50))];
                
                UITextField *codeTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width-yzmBtnStringSize.width-WZ(10), CELL_HEIGHT)];
                codeTF.tag=1;
                codeTF.delegate=self;
                codeTF.font=FONT(15,13);
                codeTF.placeholder=@"请输入验证码";
                codeTF.text=self.code;
                codeTF.keyboardType=UIKeyboardTypeNumberPad;
                [cell0.contentView addSubview:codeTF];
                self.codeTF=codeTF;
                
                UIButton *yzmBtn=[[UIButton alloc]initWithFrame:CGRectMake(codeTF.right+WZ(10), 0, yzmBtnStringSize.width, CELL_HEIGHT)];
                [yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [yzmBtn setTitleColor:COLOR(153, 142, 190, 1) forState:UIControlStateNormal];
                yzmBtn.titleLabel.font=FONT(15,13);
                [yzmBtn addTarget:self action:@selector(yzmBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [cell0.contentView addSubview:yzmBtn];
                self.yzmBtn=yzmBtn;
            }
            if (indexPath.row==2)
            {
                cell0.hidden=self.cellHidden;
                
                UITextField *payPswTF=[[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width, CELL_HEIGHT)];
                payPswTF.tag=2;
                payPswTF.delegate=self;
                payPswTF.font=FONT(15,13);
                payPswTF.placeholder=@"请输入支付密码";
                payPswTF.text=self.payPsw;
                payPswTF.secureTextEntry=YES;
                [cell0.contentView addSubview:payPswTF];
                self.payPswTF=payPswTF;
                
            }
            
            
            
            cell0.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell0;
        }
        if (indexPath.section==1)
        {
            static NSString *cellIdentifier1=@"Cell1";
            UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (!cell1)
            {
                cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
            }
            else
            {
                while ([cell1.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell1.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            NSArray *titleArray=@[@"城市",@"片区",@"小区"];
            
            UILabel *titleLabel=[UILabel labelTextCenterWithFrame:CGRectMake(WZ(15), 0, WZ(80), CELL_HEIGHT) text:titleArray[indexPath.row] textColor:COLOR_BLACK font:FONT(17,15) textAlignment:NSTextAlignmentLeft backColor:COLOR_WHITE];
            [cell1.contentView addSubview: titleLabel];
            
            UIButton *xsjBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(10+15), WZ(15), WZ(10), WZ(20))];
            [xsjBtn setBackgroundImage:IMAGE(@"youjiantou_hei") forState:UIControlStateNormal];
            [cell1.contentView addSubview:xsjBtn];
            
            if (indexPath.row==0)
            {
                UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width-WZ(10+10+15), CELL_HEIGHT)];
                addressLabel.text=self.address;
                addressLabel.font=FONT(15,13);
                addressLabel.tag=indexPath.row;
                [cell1.contentView addSubview:addressLabel];
                self.addressLabel=addressLabel;
            }
            if (indexPath.row==1)
            {
                UILabel *areaLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width-WZ(10+10+15), CELL_HEIGHT)];
                areaLabel.text=self.area;
                areaLabel.font=FONT(15,13);
                areaLabel.tag=indexPath.row;
                [cell1.contentView addSubview:areaLabel];
                self.areaLabel=areaLabel;
            }
            if (indexPath.row==2)
            {
                UILabel *communityLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right, 0, SCREEN_WIDTH-WZ(15*2)-titleLabel.width-WZ(10+10+15), CELL_HEIGHT)];
                communityLabel.text=self.community;
                communityLabel.font=FONT(15,13);
                communityLabel.tag=indexPath.row;
                [cell1.contentView addSubview:communityLabel];
                self.communityLabel=communityLabel;
            }
            
            
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell1;
        }
        else
        {
            static NSString *cellIdentifier2=@"Cell2";
            UITableViewCell *cell2=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (!cell2)
            {
                cell2=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
            }
            else
            {
                while ([cell2.contentView.subviews lastObject] != nil)
                {
                    [(UIView *)[cell2.contentView.subviews lastObject] removeFromSuperview];
                }
            }
            
            UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            [submitBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            submitBtn.titleLabel.font=FONT(17,15);
            submitBtn.layer.cornerRadius=5.0;
            submitBtn.clipsToBounds=YES;
            submitBtn.backgroundColor=COLOR(244, 170, 172, 1);
            [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell2.contentView addSubview:submitBtn];
            
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell2;
        
        }
    }
    else
    {
        static NSString *cellIdentifier3=@"Cell3";
        UITableViewCell *cell3=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (!cell3)
        {
            cell3=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
        }
        else
        {
            while ([cell3.contentView.subviews lastObject] != nil)
            {
                [(UIView *)[cell3.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
        titleLabel.text=[self.addressArray[indexPath.row] objectForKey:@"name"];
        [cell3.contentView addSubview:titleLabel];
        
        
        cell3.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell3;
    }
}

#pragma mark ===UITableViewDelegate===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_bigTableView)
    {
        [_bigTableView reloadData];
        if (indexPath.section==1)
        {
            self.selectedRow=indexPath.row;
            
            if (indexPath.row==0)
            {
                self.provinceId=@"";
                self.cityId=@"";
                self.districtId=@"";
                self.areaId=@"";
                self.address=@"";
                self.addressLabel.text=@"";
                self.area=@"";
                self.areaLabel.text=@"";
                self.community=@"";
                self.communityLabel.text=@"";
                //省数据
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                [hud show:YES];
                [HTTPManager chooseCityWithParentId:@"" complete:^(NSMutableArray *array) {
                    if (array.count>0)
                    {
                        [self.addressArray removeAllObjects];
                        self.addressArray=array;
                        
                        [self createSmallTableView];
                    }
                    else
                    {
                        [self.view makeToast:@"暂无省份数据" duration:2.0];
                    }
                    [hud hide:YES];
                }];
                [hud hide:YES afterDelay:30];
            }
            if (indexPath.row==1)
            {
                if ([self.address isEqualToString:@""])
                {
                    [self.view makeToast:@"请先选择省市" duration:2.0];
                }
                else
                {
                    //请求片区数据的时候如果上级数据没区id 就传市id
                    if ([self.districtId isEqualToString:@""])
                    {
                        self.districtId=self.cityId;
                    }
                    
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                    [hud show:YES];
                    //请求片区数据 id在选择区的时候已取出
                    [HTTPManager chooseAreaWithParentId:self.districtId complete:^(NSMutableArray *array) {
                        if (array.count>0)
                        {
                            self.addressArray=array;
                            [self createSmallTableView];
                        }
                        else
                        {
                            [self.view makeToast:@"暂无片区数据" duration:2.0];
                        }
                        [hud hide:YES];
                    }];
                    [hud hide:YES afterDelay:30];
                }
            }
            if (indexPath.row==2)
            {
                if ([self.address isEqualToString:@""])
                {
                    [self.view makeToast:@"请先选择省市" duration:2.0];
                }
                else
                {
                    if ([self.area isEqualToString:@""])
                    {
                        [self.view makeToast:@"请先选择片区" duration:2.0];
                    }
                    else
                    {
                        
                        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                        [hud show:YES];
                        //请求小区数据 id在选择片区的时候已取出
                        [HTTPManager chooseCommunityWithParentId:self.areaId complete:^(NSMutableArray *array) {
                            if (array.count>0)
                            {
                                self.addressArray=array;
                                [self createSmallTableView];
                            }
                            else
                            {
                                [self.view makeToast:@"暂无小区数据" duration:2.0];
                            }
                            [hud hide:YES];
                        }];
                        [hud hide:YES afterDelay:30];
                    }
                }
            }
            
        }
    }
    else
    {
        if (self.selectedRow==0)
        {
            //先判断现在是选择的省份还是市
            if ([self.provinceId isEqualToString:@""])
            {
                //如果省份id为空 则是选省份
                self.province=[self.addressArray[indexPath.row] objectForKey:@"name"];
                //选择省份之后请求当前省下的市
                self.provinceId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                [hud show:YES];
                [HTTPManager chooseCityWithParentId:self.provinceId complete:^(NSMutableArray *array) {
                    if (array.count>0)
                    {
                        //首先清除地址数组里面的省份数据
                        [self.addressArray removeAllObjects];
                        //然后给数组赋值于市数组
                        self.addressArray=array;
                        //刷新tableview
                        [_smallTableView reloadData];
                    }
                    else
                    {
                        [self.addressArray removeAllObjects];
                        self.address=self.province;
                        self.addressLabel.text=self.address;
                        self.addressLabel.textColor=COLOR_BLACK;
                        
                        [self.smallBgView removeFromSuperview];
                        [self.view makeToast:@"暂无市数据" duration:2.0];
                    }
                    [hud hide:YES];
                }];
                [hud hide:YES afterDelay:30];
            }
            else
            {
                if ([self.cityId isEqualToString:@""])
                {
                    //如果省份id不为空 市id为空 取出上次请求的市数据 此时self.addressArray里的数据已经变成了区
                    self.city=[self.addressArray[indexPath.row] objectForKey:@"name"];
                    self.cityId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                    
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                    [hud show:YES];
                    [HTTPManager chooseCityWithParentId:self.cityId complete:^(NSMutableArray *array) {
                        if (array.count>0)
                        {
                            //首先清除地址数组里面的市数据
                            [self.addressArray removeAllObjects];
                            //然后给数组赋值于区数组
                            self.addressArray=array;
                            //刷新tableview
                            [_smallTableView reloadData];
                        }
                        else
                        {
                            [self.addressArray removeAllObjects];
                            self.address=[NSString stringWithFormat:@"%@-%@",self.province,self.city];
                            self.addressLabel.text=self.address;
                            self.addressLabel.textColor=COLOR_BLACK;
                            
                            [self.smallBgView removeFromSuperview];
                            //                            [self.view makeToast:@"暂无区数据" duration:2.0];
                        }
                        [hud hide:YES];
                    }];
                    [hud hide:YES afterDelay:30];
                }
                else
                {
                    if ([self.districtId isEqualToString:@""])
                    {
                        //如果省份id不为空 市id不为空 区id为空 点击某一行取出上次请求得到的区数据
                        self.district=[self.addressArray[indexPath.row] objectForKey:@"name"];
                        self.districtId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                        //取出区之后 删除数组里的区数据 以便下次重新选择 然后拼接省市区数据显示
                        [self.addressArray removeAllObjects];
                        self.address=[NSString stringWithFormat:@"%@-%@-%@",self.province,self.city,self.district];
                        self.addressLabel.text=self.address;
                        self.addressLabel.textColor=COLOR_BLACK;
                        //隐藏tableview
                        [_smallTableView reloadData];
                        [self.smallBgView removeFromSuperview];
                    }
                }
                
            }
            
            //选择的是省市区行 而且以前已经选择过地址了
            if (![self.address isEqualToString:@""])
            {
                //把以前选择的地址置空
                self.area=@"";
                self.areaLabel.text=@"";
                self.community=@"";
                self.communityLabel.text=@"";
            }
            
        }
        if (self.selectedRow==1)
        {
            //选择片区
            self.area=[self.addressArray[indexPath.row] objectForKey:@"name"];
            self.areaId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
            //取出片区之后 删除数组里的片区数据 以便下次重新选择
            [self.addressArray removeAllObjects];
            self.areaLabel.text=self.area;
            self.areaLabel.textColor=COLOR_BLACK;
            //移除弹出视图
            [_smallTableView reloadData];
            [self.smallBgView removeFromSuperview];
            
            self.community=@"";
            self.communityLabel.text=@"";
        }
        if (self.selectedRow==2)
        {
            //选择小区
            self.community=[self.addressArray[indexPath.row] objectForKey:@"name"];
            self.communityId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
            //取出片区之后 删除数组里的片区数据 以便下次重新选择
            [self.addressArray removeAllObjects];
            self.communityLabel.text=self.community;
            self.communityLabel.textColor=COLOR_BLACK;
            //移除弹出视图
            [_smallTableView reloadData];
            [self.smallBgView removeFromSuperview];
        }
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_bigTableView)
    {
        if (indexPath.section==0)
        {
            UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            if (cell.hidden==YES)
            {
                return 0;
            }
            else
            {
                return CELL_HEIGHT;
            }
        }
        if (indexPath.section==2)
        {
            return WZ(100);
        }
        else
        {
            return CELL_HEIGHT;
        }
    }
    else
    {
        return CELL_HEIGHT;
    }
}

//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_bigTableView endEditing:YES];
    [_smallBgView endEditing:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        self.mobile=textField.text;
    }
    if (textField.tag==1)
    {
        self.code=textField.text;
    }
    if (textField.tag==2)
    {
        self.payPsw=textField.text;
    }
    if (textField.tag==3)
    {
        self.password=textField.text;
    }
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
-(void)yzmBtnClick
{
    [_bigTableView endEditing:YES];
    
//    [self.passwordTF resignFirstResponder];
//    [self.mobileTF resignFirstResponder];
//    [self.codeTF resignFirstResponder];
//    [self.payPswTF resignFirstResponder];
    
    if (_isGetCode==NO)
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
                [HTTPManager getVerifyCodeWithName:self.mobile type:@"register" complete:^(NSDictionary *resultDict) {
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        self.verifyCode=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"code"]];
                        self.state=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"state"]];
                        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daoJiShi) userInfo:nil repeats:YES];
                        _isGetCode=YES;
                        
                        if ([self.state isEqualToString:@"1"])
                        {
                            //为1 用户在支付系统和后台都已存在 此时需要验证用户支付密码 正确则跳转首页 不正确继续验证
                            [self createBackgroundViewWithSmallViewTitle:@"" detail:@"此用户已存在，请输入支付密码验证："];
                        }
                        if ([self.state isEqualToString:@"2"])
                        {
                            UITableViewCell *cell = [_bigTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                            cell.hidden=YES;
                            self.cellHidden=YES;
                            cell.contentView.height=0;
                            [_bigTableView reloadData];
//                            NSLog(@"cell===%@",cell.contentView.subviews);
                            
                            //为2 用户在支付系统存在 在后台不存在 此时隐藏cell的支付密码 弹出支付密码验证框 18872230344
                            [self createBackgroundViewWithSmallViewTitle:@"" detail:@"此用户已存在，请输入支付密码验证："];
                        }
                        if ([self.state isEqualToString:@"3"])
                        {
                            UITableViewCell *cell = [_bigTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                            
                            if (cell.hidden==YES)
                            {
                                cell.hidden=NO;
                                self.cellHidden=NO;
                                cell.contentView.height=CELL_HEIGHT;
                                [_bigTableView reloadData];
                            }
                        }
                    }
                    else
                    {
                        NSString *msg=[resultDict objectForKey:@"msg"];
                        [self.view makeToast:msg duration:2.0];
                    }
                    
                }];
            }
        }
    }
    
}

//创建背景View
-(void)createBackgroundViewWithSmallViewTitle:(NSString *)title detail:(NSString*)detail
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self.view.window addSubview:bgView];
//    UIView *parentView = [[UIView alloc]init];
//    UIWindow *window=[UIApplication sharedApplication].windows[0];
//    if (window.subviews.count > 0)
//    {
//        parentView = [window.subviews objectAtIndex:0];
//    }
//    [parentView addSubview:bgView];
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
    passwordTF.tag=3;
    passwordTF.delegate=self;
    passwordTF.secureTextEntry=YES;
    passwordTF.clipsToBounds=YES;
    passwordTF.layer.cornerRadius=5;
    passwordTF.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    passwordTF.layer.borderWidth=1.0;
    [smallView addSubview:passwordTF];
    self.passwordTF=passwordTF;
    
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
    [self.view.window endEditing:YES];
//    [self.passwordTF resignFirstResponder];
//    [self.mobileTF resignFirstResponder];
//    [self.codeTF resignFirstResponder];
//    [self.payPswTF resignFirstResponder];
    
    if (button.tag==0)
    {
        //取消，移除bgView，退出绑定信息界面
        [self.bgView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag==1)
    {
        //取出第三方信息token
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
        NSDictionary *thirdDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *uid=[thirdDict objectForKey:@"uid"];
        NSLog(@"取出uid===%@",uid);
        
        if ([self.state isEqualToString:@"1"])
        {
            //state为1
            //确定 验证密码 成功则移除bgView
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在验证..." detail:nil];
            [hud show:YES];
            
            [HTTPManager ifPayPassword01ExistWithPassword:self.password phone:self.mobile token:uid complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    //密码验证成功 移除self.bgView 保存用户信息（请求方法里面保存的） 跳转首页
                    [self.bgView removeFromSuperview];
                    [self.view.window makeToast:@"密码验证成功" duration:2.0];
                    
                    TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                    self.navigationController.navigationBarHidden=NO;
                    [self.navigationController pushViewController:tabbarVC animated:NO];
                }
                else
                {
                    [self.bgView removeFromSuperview];
                    [self createBackgroundViewWithSmallViewTitle:@"" detail:@"支付密码错误，请输入支付密码验证："];
                }
                [hud hide:YES];
            }];
            [hud hide:YES afterDelay:20];
        }
        if ([self.state isEqualToString:@"2"])
        {
            //state为2
            //确定 验证密码 成功则移除bgView
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在验证..." detail:nil];
            [hud show:YES];
            
            [HTTPManager ifPayPassword02ExistWithPassword:self.password phone:self.mobile token:uid complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    //密码验证成功 移除self.bgView 继续填写信息提交
                    [self.bgView removeFromSuperview];
                    [self.view.window makeToast:@"密码验证成功" duration:2.0];
                }
                else
                {
                    [self.bgView removeFromSuperview];
                    [self createBackgroundViewWithSmallViewTitle:@"" detail:@"支付密码错误，请输入支付密码验证："];
                }
                [hud hide:YES];
            }];
            [hud hide:YES afterDelay:20];
        }
        
    }
}

//获取验证码倒计时
-(void)daoJiShi
{
    static NSInteger time=60;
    time--;
    
    if (time>0)
    {
        self.yzmBtn.userInteractionEnabled=NO;
        [self.yzmBtn setTitle:[NSString stringWithFormat:@"%lds后获取",(long)time] forState:UIControlStateNormal];
        [self.yzmBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
    }
    if (time==0)
    {
        self.yzmBtn.userInteractionEnabled=YES;
        [self.yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.yzmBtn setTitleColor:COLOR(146, 135, 187, 1) forState:UIControlStateNormal];
        
        [_timer invalidate];
        _isGetCode=NO;
        
        time=60;
    }
}

//提交注册
-(void)submitBtnClick
{
    [self.mobileTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.payPswTF resignFirstResponder];
    
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
            if ([self.code isEqualToString:@""])
            {
                [self.view makeToast:@"请输入验证码" duration:2.0];
            }
            else
            {
                if (![self.code isEqualToString:self.verifyCode])
                {
                    [self.view makeToast:@"验证码不正确" duration:2.0];
                }
                else
                {
                    if ([self.state isEqualToString:@"2"])
                    {
                        if ([self.address isEqualToString:@""])
                        {
                            [self.view makeToast:@"请选择城市" duration:2.0];
                        }
                        else
                        {
                            if ([self.area isEqualToString:@""])
                            {
                                [self.view makeToast:@"请选择片区" duration:2.0];
                            }
                            else
                            {
                                //取出第三方信息
                                NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
                                NSDictionary *thirdDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                NSString *nickname=[thirdDict objectForKey:@"nickname"];
                                NSString *name=[thirdDict objectForKey:@"uid"];
                                NSString *img=[thirdDict objectForKey:@"icon"];
                                
                                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在注册..." detail:nil];
                                [hud show:YES];
                                //绑定第三方信息
                                [HTTPManager firstThirdLoginWithNickname:nickname name:name img:img areaId:self.areaId xqId:self.communityId phone:self.mobile payPassword:self.payPsw complete:^(User *user) {
                                    [hud hide:YES];
                                    if ([user.result isEqualToString:STATUS_SUCCESS])
                                    {
                                        //第三方信息绑定成功 跳转首页
                                        TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                                        self.navigationController.navigationBarHidden=NO;
                                        [self.navigationController pushViewController:tabbarVC animated:NO];
                                        
                                        self.token=user.token;
                                        [self connectRongYunServer];
                                        
                                        //保存是否第三方登录信息
                                        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isThird.plist"];
                                        NSMutableDictionary *isThirdLoginDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"是",@"isThird", nil];
                                        [isThirdLoginDict writeToFile:path atomically:YES];
                                    }
                                    else
                                    {
                                        [self.view makeToast:user.msg duration:2.0];
                                    }
                                }];
                                [hud hide:YES afterDelay:2.0];
                            }
                        }
                    }
                    if ([self.state isEqualToString:@"3"])
                    {
                        if ([self.payPsw isEqualToString:@""])
                        {
                            [self.view makeToast:@"支付密码不能为空" duration:2.0];
                        }
                        else
                        {
                            if ([self.address isEqualToString:@""])
                            {
                                [self.view makeToast:@"请选择城市" duration:2.0];
                            }
                            else
                            {
                                if ([self.area isEqualToString:@""])
                                {
                                    [self.view makeToast:@"请选择片区" duration:2.0];
                                }
                                else
                                {
                                    //取出第三方信息
                                    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"thirdLoginInfo.plist"];
                                    NSDictionary *thirdDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
                                    NSString *nickname=[thirdDict objectForKey:@"nickname"];
                                    NSString *name=[thirdDict objectForKey:@"uid"];
                                    NSString *img=[thirdDict objectForKey:@"icon"];
                                    
                                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在注册..." detail:nil];
                                    [hud show:YES];
                                    //绑定第三方信息
                                    [HTTPManager firstThirdLoginWithNickname:nickname name:name img:img areaId:self.areaId xqId:self.communityId phone:self.mobile payPassword:self.payPsw complete:^(User *user) {
                                        [hud hide:YES];
                                        if ([user.result isEqualToString:STATUS_SUCCESS])
                                        {
                                            //第三方信息绑定成功 跳转首页
                                            TabBarViewController *tabbarVC=[[TabBarViewController alloc]init];
                                            self.navigationController.navigationBarHidden=NO;
                                            [self.navigationController pushViewController:tabbarVC animated:NO];
                                            
                                            self.token=user.token;
                                            [self connectRongYunServer];
                                            
                                            //保存是否第三方登录信息
                                            NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isThird.plist"];
                                            NSMutableDictionary *isThirdLoginDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"是",@"isThird", nil];
                                            [isThirdLoginDict writeToFile:path atomically:YES];
                                        }
                                        else
                                        {
                                            [self.view makeToast:user.msg duration:2.0];
                                        }
                                    }];
                                    [hud hide:YES afterDelay:2.0];
                                }
                            }
                        }
                    }
                    
                }
            }
            
            
            
            
        }
        
    }
    
    
    
    
    
}

//取消选择地址
-(void)cancelBtnClick
{
    [self.smallBgView removeFromSuperview];
}

//连接融云服务器
-(void)connectRongYunServer
{
    [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId) {
        
        NSLog(@"融云服务器连接成功。当前登录的用户ID：%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"融云服务器连接失败的错误码为:%ld", (long)status);
        
    } tokenIncorrect:^{
        
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
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
