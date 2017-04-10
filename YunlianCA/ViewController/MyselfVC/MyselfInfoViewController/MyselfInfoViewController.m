//
//  MyselfInfoViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/15.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyselfInfoViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "EditNicknameVC.h"
#import "ShippingAddressViewController.h"
#import "ChangePayPasswordVC.h"
#import "RegisterStoreViewController.h"
#import "UserInformationVC.h"
#import <SVProgressHUD.h>
@interface MyselfInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *_tableView;
    UIButton *_nanBtn;
    UIButton *_nvBtn;
    UITableView *_smallTableView;
    NSString * _pqName;
    NSString * _xqName;
}

@property(nonatomic,strong)User *userInfo;

@property(nonatomic,strong)UILabel *communityLabel;
@property(nonatomic,strong)UIImageView *headIV;
@property(nonatomic,strong)UIImage *headImage;
@property(nonatomic,strong)UILabel *nicknameLabel;
@property(nonatomic,strong)UILabel *diquLabel;
@property(nonatomic,strong)UILabel *dizhiLabel;
@property(nonatomic,strong)UILabel *qianmingLabel;
@property(nonatomic,strong)NSData *headData;
@property(nonatomic,strong)UIView *smallBgView;
@property(nonatomic,strong)NSMutableArray *addressArray;
@property(nonatomic,strong)NSString *provinceId;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *districtId;
@property(nonatomic,strong)NSString *areaId;
@property(nonatomic,strong)NSString *communityId;
@property(nonatomic,strong)NSString *district;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *community;
@property(nonatomic,strong)NSString *receiptAddress;

@end

@implementation MyselfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.provinceId=@"";
    self.cityId=@"";
    self.districtId=@"";
    self.areaId=@"";
    self.communityId=@"";
    self.province=@"";
    self.city=@"";
    self.district=@"";
    self.area=@"";
    self.community=@"";
    _pqName =@"";
    _xqName = @"";
    self.receiptAddress=@"";
    
    self.addressArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getContentNotification:) name:@"content" object:nil];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self getUserInfo];
   
    
    
    
    
    
}

-(void)getAddress
{
    [HTTPManager getUserDefaultShippingAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *receiptInfo=[resultDict objectForKey:@"receiptInfo"];
            NSString *city=[receiptInfo objectForKey:@"city"];
            NSString *address=[receiptInfo objectForKey:@"address"];
            
            if ([city isEqualToString:@"(null)"] || [city isEqualToString:@""] || city==nil)
            {
                city=@"";
            }
            if ([address isEqualToString:@"(null)"] || [address isEqualToString:@""] || address==nil)
            {
                address=@"";
            }
            
            if ([city isEqualToString:@""] || [address isEqualToString:@""])
            {
                self.receiptAddress=@"暂无收货地址";
            }
            else
            {
                self.receiptAddress=[NSString stringWithFormat:@"%@%@",city,address];
            }
            
        }
        
    }];
}

-(void)getUserInfo
{
    [HTTPManager getUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(User *user) {
        self.userInfo=user;
        [SVProgressHUD dismiss];
        [UserInfoData saveUserInfoWithUser:user];
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.headImage,@"headImage", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"headImage" object:nil userInfo:dict];
        
        [_tableView reloadData];
    }];
}

-(void)getContentNotification:(NSNotification*)notification
{
    NSDictionary *dict=[notification userInfo];
    NSString *nickname=[dict objectForKey:@"nickname"];
    NSString *sign=[dict objectForKey:@"sign"];
    NSString *age=[dict objectForKey:@"age"];
    if (nickname!=nil)
    {
        self.userInfo.nickname=nickname;
    }
    if (sign!=nil)
    {
        self.userInfo.sign=sign;
    }
    if (age!=nil)
    {
        self.userInfo.age=age;
    }
    
    [SVProgressHUD showWithStatus:@"提交中..."];
    [HTTPManager updateUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId nickname:self.userInfo.nickname sex:self.userInfo.sex age:self.userInfo.age address:self.userInfo.address sign:self.userInfo.sign img:self.headData complete:^(NSDictionary *resultDict) {
        [SVProgressHUD dismiss];
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            if (nickname!=nil)
            {
                self.nicknameLabel.text=nickname;
            }
            if (sign!=nil)
            {
                self.qianmingLabel.text=sign;
            }
            UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
            [window makeToast:@"修改成功" duration:2];
            [self getUserInfo];
        }else{
            NSString *msg=[resultDict objectForKey:@"msg"];
            if ([msg length]>0) {
                [self.view makeToast:msg duration:2];
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    
    [self getAddress];
    [self getAreaAddress];
}
-(void)getAreaAddress
{
    [HTTPManager getAreaAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
            NSString *pqName=[resultDict objectForKey:@"pqName"];
            NSString *xqName=[resultDict objectForKey:@"xqName"];
            
            _pqName =pqName;
            _xqName =xqName;
            
            NSIndexPath * path = [NSIndexPath indexPathForRow:3 inSection:1];
            [_tableView reloadRowAtIndexPath:path withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    [SVProgressHUD dismiss];
}

-(void)createNavigationBar
{
    self.title=@"个人信息";
    
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
    [self.view addSubview:_tableView];
    
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_tableView)
    {
        return 2;
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
            return 2;
        }
        else
        {
            return 8;
        }
    }
    else
    {
        return self.addressArray.count;
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"头像",@"昵称", nil];
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.font=FONT(17, 15);
            
            if (indexPath.row==0)
            {
                UIImageView *headIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(50), WZ(10), WZ(50), WZ(50))];
                //            headIV.backgroundColor=COLOR_CYAN;
                headIV.clipsToBounds=YES;
                headIV.layer.cornerRadius=headIV.width/2.0;
                [cell.contentView addSubview:headIV];
                self.headIV=headIV;
                
                if (![self.userInfo.headImage isEqualToString:@""] || self.userInfo.headImage!=nil)
                {
                    NSString *imgUrlString=self.userInfo.headImage;
                    NSURL *imgUrl;
                    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
                    {
                        imgUrl=[NSURL URLWithString:imgUrlString];
                    }
                    else
                    {
                        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
                    }
                    [headIV sd_setImageWithURL:imgUrl placeholderImage:IMAGE(@"tabbar_wode_nor")];
                }
                if (self.headImage!=nil)
                {
                    headIV.image=self.headImage;
                }
                
            }
            else
            {
                UILabel *nicknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(250), 0, WZ(250), WZ(50))];
                nicknameLabel.text=self.userInfo.nickname;
                nicknameLabel.textColor=COLOR_LIGHTGRAY;
                nicknameLabel.font=FONT(15,13);
                nicknameLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:nicknameLabel];
                self.nicknameLabel=nicknameLabel;
            }
            
            
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"性别",@"年龄",@"修改支付密码",@"修改小区",@"收货地址",@"个性签名",@"用户资料",@"商户资料", nil];
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.font=FONT(17, 15);
            
            if (indexPath.row==0)
            {
                _nanBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(24)-WZ(20)-WZ(24), WZ(13), WZ(24), WZ(24))];
                _nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
                _nanBtn.clipsToBounds=YES;
                _nanBtn.layer.cornerRadius=_nanBtn.width/2.0;
                _nanBtn.titleLabel.font=FONT(13,11);
                [_nanBtn setTitle:@"男" forState:UIControlStateNormal];
                [_nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                [_nanBtn addTarget:self action:@selector(nanBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_nanBtn];
                
                _nvBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(24), WZ(13), WZ(24), WZ(24))];
                _nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
                _nvBtn.clipsToBounds=YES;
                _nvBtn.layer.cornerRadius=_nvBtn.width/2.0;
                _nvBtn.titleLabel.font=FONT(13,11);
                [_nvBtn setTitle:@"女" forState:UIControlStateNormal];
                [_nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
                [_nvBtn addTarget:self action:@selector(nvBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:_nvBtn];
                
                if ([self.userInfo.sex isEqualToString:@"男"])
                {
                    _nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
                    [_nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                    _nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
                    [_nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
                }
                if ([self.userInfo.sex isEqualToString:@"女"])
                {
                    _nvBtn.backgroundColor=COLOR(254, 167, 173, 1);
                    [_nvBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                    _nanBtn.backgroundColor=COLOR(211, 211, 211, 1);
                    [_nanBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
                }
                
                if (self.userInfo.sex==nil || [self.userInfo.sex isEqualToString:@""])
                {
                    self.userInfo.sex=@"男";
                }
                
            }
            if (indexPath.row==1) {
                UILabel *ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(250), 0, WZ(250), WZ(50))];
                if (self.userInfo.age==nil||[self.userInfo.age isEqualToString:@"(null)"]) {
                   ageLabel.text=@"请填写年龄";
                }else{
                   ageLabel.text=self.userInfo.age;
                }
                
                ageLabel.textColor=COLOR_LIGHTGRAY;
                ageLabel.font=FONT(15,13);
                ageLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:ageLabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==2)
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==3)
            {
                UILabel *communityLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(250), 0, WZ(250), WZ(50))];
                
                communityLabel.textColor=COLOR_LIGHTGRAY;
                communityLabel.font=FONT(15,13);
                communityLabel.textAlignment=NSTextAlignmentRight;
                communityLabel.numberOfLines=2;
                [cell.contentView addSubview:communityLabel];
                self.communityLabel=communityLabel;
                
                if ([self.userInfo.isChangeArea isEqualToString:@"0"])
                {
                    communityLabel.text=[NSString stringWithFormat:@"%@-%@",_pqName,_xqName];
                }
                if ([self.userInfo.isChangeArea isEqualToString:@"1"])
                {
                    communityLabel.text=[NSString stringWithFormat:@"%@-%@(审核中)",self.userInfo.changeAreaName,self.userInfo.changeXqName];
                }
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==4)
            {
//                CGSize dizhiSize=[ViewController sizeWithString:self.userInfo.acceptAddress font:FONT(15, 13) maxSize:CGSizeMake(WZ(250), WZ(50))];
                
                UILabel *dizhiLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(250), 0, WZ(250), WZ(50))];
                dizhiLabel.text=self.receiptAddress;
                dizhiLabel.textColor=COLOR_LIGHTGRAY;
                dizhiLabel.font=FONT(15,13);
                dizhiLabel.numberOfLines=2;
                dizhiLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:dizhiLabel];
                self.dizhiLabel=dizhiLabel;
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==5)
            {
                CGSize qianmingSize=[ViewController sizeWithString:self.userInfo.sign font:FONT(15, 13) maxSize:CGSizeMake(WZ(250), WZ(50))];
                
                UILabel *qianmingLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-qianmingSize.width, 0, qianmingSize.width, WZ(50))];
                //            qianmingLabel.backgroundColor=COLOR_CYAN;
                qianmingLabel.text=self.userInfo.sign;
                qianmingLabel.textColor=COLOR_LIGHTGRAY;
                qianmingLabel.font=FONT(15,13);
                qianmingLabel.numberOfLines=2;
                qianmingLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:qianmingLabel];
                self.qianmingLabel=qianmingLabel;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==6)
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==7)
            {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
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
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
        titleLabel.text=[self.addressArray[indexPath.row] objectForKey:@"name"];
        [cell.contentView addSubview:titleLabel];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                //选择头像
                [self changeHeadImage];
            }
            else
            {
                if (self.userInfo.nickname==nil)
                {
                    self.userInfo.nickname=@"";
                }
                //修改昵称
                EditNicknameVC *vc=[[EditNicknameVC alloc]init];
                vc.isNickname=YES;
                vc.nickname=self.userInfo.nickname;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (indexPath.section==1)
        {
            if (indexPath.row==1) {
                EditNicknameVC *vc=[[EditNicknameVC alloc]init];
                vc.isAge=YES;
                vc.age=self.userInfo.age==nil?@"":self.userInfo.age;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.row==2)
            {
                //跳到修改支付密码界面
                ChangePayPasswordVC *vc=[[ChangePayPasswordVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.row==3)
            {
                //修改片区
                if ([self.userInfo.isChangeArea isEqualToString:@"0"])
                {
                    //省数据
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                    [hud show:YES];
                    [HTTPManager chooseCityWithParentId:@"" complete:^(NSMutableArray *array) {
                        if (array.count>0)
                        {
                            self.addressArray=array;
                            
                            [self createSmallTableView];
                        }
                        else
                        {
                            [self.view makeToast:@"暂无省份数据" duration:2.0];
                        }
                        [hud hide:YES];
                    }];
                    [hud hide:YES afterDelay:20];
                }
                if ([self.userInfo.isChangeArea isEqualToString:@"1"])
                {
                    [self.view makeToast:@"片区审核中..." duration:2.0];
                }
                
            }
            if (indexPath.row==4)
            {
                //收货地址
                ShippingAddressViewController *vc=[[ShippingAddressViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            if (indexPath.row==5)
            {
                if (self.userInfo.sign==nil)
                {
                    self.userInfo.sign=@"";
                }
                //个性签名
                EditNicknameVC *vc=[[EditNicknameVC alloc]init];
                vc.isSign=YES;
                vc.sign=self.userInfo.sign;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            if (indexPath.row==6)
            {
                //用户资料
                UserInformationVC *vc=[[UserInformationVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.row==7)
            {
                //商户资料
                if ([self.userInfo.merchantId isEqualToString:@"0"])
                {
                    [self.view makeToast:@"该用户没有商户!" duration:2.0];
                }
                else
                {
                    RegisterStoreViewController *vc=[[RegisterStoreViewController alloc]init];
                    vc.isMyselfInfoVC=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
        }
    }
    else
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
            [hud hide:YES afterDelay:20];
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
                    [self.smallBgView removeFromSuperview];
                    [self.view makeToast:@"暂无市数据" duration:2.0];
                }
                [hud hide:YES];
            }];
        }
        else
        {
            if ([self.cityId isEqualToString:@""])
            {
                //如果省份id不为空 市id为空 取出上个请求里的市id请求区数据
                self.city=[self.addressArray[indexPath.row] objectForKey:@"name"];
                self.cityId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                [hud show:YES];
                [hud hide:YES afterDelay:20];
                [HTTPManager chooseCityWithParentId:self.cityId complete:^(NSMutableArray *array) {
                    if (array.count>0)
                    {
                        //首先清除地址数组里面的市数据
                        [self.addressArray removeAllObjects];
                        //然后给数组赋值于区数组
                        self.addressArray=array;
                        //刷新tableview
                        [_smallTableView reloadData];
                        //                        NSLog(@"数据===%@",self.addressArray);
                    }
                    else
                    {
                        [self.view makeToast:@"暂无区数据" duration:2.0];
                        [self.smallBgView removeFromSuperview];
                    }
                    [hud hide:YES];
                }];
            }
            else
            {
                if ([self.districtId isEqualToString:@""])
                {
                    //如果省份id不为空 市id不为空 区id为空 取出上个请求里的区id 根据区id请求片区数据
                    self.district=[self.addressArray[indexPath.row] objectForKey:@"name"];
                    self.districtId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                    //                    NSLog(@"数据===%@",self.district);
                    
                    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                    [hud show:YES];
                    [hud hide:YES afterDelay:20];
                    [HTTPManager chooseAreaWithParentId:self.districtId complete:^(NSMutableArray *array) {
                        if (array.count>0)
                        {
                            //首先清除地址数组里面的区数据
                            [self.addressArray removeAllObjects];
                            //然后给数组赋值于片区数组
                            self.addressArray=array;
                            //刷新tableview
                            [_smallTableView reloadData];
                            //                            NSLog(@"数据===%@",self.addressArray);
                        }
                        else
                        {
                            [self.smallBgView removeFromSuperview];
                            [self.view.window makeToast:@"暂无片区数据" duration:2.0];
                        }
                        [hud hide:YES];
                    }];
                }
                else
                {
                    if ([self.areaId isEqualToString:@""])
                    {
                        //如果省份id不为空 市id不为空 区id不为空 片区id为空 取出上个请求里的片区id 根据片区id请求小区数据
                        self.area=[self.addressArray[indexPath.row] objectForKey:@"name"];
                        self.areaId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                        
                        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
                        [hud show:YES];
                        [hud hide:YES afterDelay:20];
                        [HTTPManager chooseCommunityWithParentId:self.areaId complete:^(NSMutableArray *array) {
                            if (array.count>0)
                            {
                                //首先清除地址数组里面的片区数据
                                [self.addressArray removeAllObjects];
                                //然后给数组赋值于小区数组
                                self.addressArray=array;
                                //刷新tableview
                                [_smallTableView reloadData];
                                //                            NSLog(@"数据===%@",self.addressArray);
                            }
                            else
                            {
                                [self.smallBgView removeFromSuperview];
                                [self.view.window makeToast:@"暂无小区数据，无法修改小区。" duration:2.0];
                                
                                //无小区数据无法修改 清空以前选择的全部数据
                                self.provinceId=@"";
                                self.cityId=@"";
                                self.districtId=@"";
                                self.areaId=@"";
                                self.communityId=@"";
                                self.province=@"";
                                self.city=@"";
                                self.district=@"";
                                self.area=@"";
                                self.community=@"";
                            }
                            [hud hide:YES];
                        }];
                    }
                    else
                    {
                        if ([self.communityId isEqualToString:@""])
                        {
                            //如果省份id不为空 市id不为空 区id不为空 片区id不为空 取出上个请求里的小区id 此时最后一层数据已取到
                            self.community=[self.addressArray[indexPath.row] objectForKey:@"name"];
                            self.communityId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
                            //取出片区之后 删除数组里的小区数据 以便下次重新选择
                            [self.addressArray removeAllObjects];
                            //隐藏tableview
                            [_smallTableView reloadData];
                            [self.smallBgView removeFromSuperview];
                            
                            //调用请求修改小区
                            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"提交申请..." detail:nil];
                            [hud show:YES];
                            [hud hide:YES afterDelay:20];
                            [HTTPManager changeUserCommunityWithUserId:[UserInfoData getUserInfoFromArchive].userId areaId:self.areaId xqId:self.communityId complete:^(NSDictionary *resultDict) {
                                NSString *result=[resultDict objectForKey:@"result"];
                                if ([result isEqualToString:STATUS_SUCCESS])
                                {
                                    [self.view makeToast:@"申请已提交" duration:2.0];
                                    self.communityLabel.text=[NSString stringWithFormat:@"%@-%@",self.userInfo.changeAreaName,self.userInfo.changeXqName];
                                }
                                else
                                {
                                    NSString *msg=[resultDict objectForKey:@"msg"];
                                    [self.view makeToast:msg duration:2.0];
                                }
                                
                                [hud hide:YES];
                                
                                [self getUserInfo];
                                //修改之后 无论成功与否 都要清空全部数据
                                self.provinceId=@"";
                                self.cityId=@"";
                                self.districtId=@"";
                                self.areaId=@"";
                                self.communityId=@"";
                                self.province=@"";
                                self.city=@"";
                                self.district=@"";
                                self.area=@"";
                                self.community=@"";
                                
                            }];
                            
                            
                        }
                    }
                }
            }
        }
        
        
//        //先判断现在是选择的省份还是市
//        if ([self.provinceId isEqualToString:@""])
//        {
//            //如果省份id为空 市id为空 则是选省份
//            self.province=[self.addressArray[indexPath.row] objectForKey:@"name"];
//            //选择省份之后请求当前省下的市
//            self.provinceId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
//            
//            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"正在加载..." detail:nil];
//            [hud show:YES];
//            [HTTPManager chooseCityWithParentId:self.provinceId complete:^(NSMutableArray *array) {
//                if (array.count>0)
//                {
//                    //首先清除地址数组里面的省份数据
//                    [self.addressArray removeAllObjects];
//                    //然后给数组赋值于市数组
//                    self.addressArray=array;
//                    //刷新tableview
//                    [_smallTableView reloadData];
//                }
//                else
//                {
//                    [self.view makeToast:@"暂无市数据" duration:2.0];
//                }
//                [hud hide:YES];
//            }];
//            [hud hide:YES afterDelay:20];
//        }
//        else
//        {
//            if ([self.cityId isEqualToString:@""])
//            {
//                //如果省份id不为空 市id为空 则是选市 此时self.addressArray里的数据已经变成了市
//                self.city=[self.addressArray[indexPath.row] objectForKey:@"name"];
//                self.cityId=[NSString stringWithFormat:@"%@",[self.addressArray[indexPath.row] objectForKey:@"id"]];
//                //取出市之后 删除数组里的市数据 以便下次重新选择 然后拼接省市数据显示
//                [self.addressArray removeAllObjects];
//                NSString *address=[NSString stringWithFormat:@"%@-%@",self.province,self.city];
//                self.dizhiLabel.text=address;
//                //隐藏tableview
//                [_smallTableView reloadData];
//                [self.smallBgView removeFromSuperview];
//                
//                self.provinceId=@"";
//                self.cityId=@"";
//                
//                //选择完省市之后 更新用户信息 然后重新请求用户信息数据
//                [HTTPManager updateUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId nickname:self.userInfo.nickname sex:self.userInfo.sex address:address sign:self.userInfo.sign img:self.headData complete:^(NSDictionary *resultDict) {
//                    NSString *result=[resultDict objectForKey:@"result"];
//                    if ([result isEqualToString:STATUS_SUCCESS])
//                    {
//                        [self getUserInfo];
//                    }
//                }];
//                
//            }
//            
//        }
        
        
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableView)
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
    {
        if (indexPath.section==0)
        {
            if (indexPath.row==0)
            {
                return WZ(75);
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
    else
    {
        return WZ(50);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        return WZ(15);
    }
    else
    {
        return 0;
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

//女
-(void)nvBtnClick
{
    self.userInfo.sex=@"女";
    _nvBtn.userInteractionEnabled = NO;
    _nanBtn.userInteractionEnabled = NO;
    _nvBtn.backgroundColor=COLOR(254, 167, 173, 1);
    [_nvBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    _nanBtn.backgroundColor=COLOR(211, 211, 211, 1);
    [_nanBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
    [SVProgressHUD showWithStatus:@"提交中..."];
    [HTTPManager updateUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId nickname:self.userInfo.nickname sex:self.userInfo.sex age:self.userInfo.age address:self.userInfo.address sign:self.userInfo.sign img:self.headData complete:^(NSDictionary *resultDict) {
        
        
        _nvBtn.userInteractionEnabled = YES;
        _nanBtn.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view makeToast:@"修改成功" duration:2];
            [self getUserInfo];
        }else{
            NSString *msg=[resultDict objectForKey:@"msg"];
            if ([msg length]>0) {
                [self.view makeToast:msg duration:2];
            }
        }
    }];
}

//男
-(void)nanBtnClick
{
    _nanBtn.userInteractionEnabled = NO;
    _nvBtn.userInteractionEnabled = NO;
    self.userInfo.sex=@"男";
    _nanBtn.backgroundColor=COLOR(254, 167, 173, 1);
    [_nanBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    _nvBtn.backgroundColor=COLOR(211, 211, 211, 1);
    [_nvBtn setTitleColor:COLOR(165, 165, 165, 1) forState:UIControlStateNormal];
    [SVProgressHUD showWithStatus:@"提交中..."];
    [HTTPManager updateUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId nickname:self.userInfo.nickname sex:self.userInfo.sex age:self.userInfo.age address:self.userInfo.address sign:self.userInfo.sign img:self.headData complete:^(NSDictionary *resultDict) {
        [SVProgressHUD dismiss];
        _nanBtn.userInteractionEnabled = YES;
        _nvBtn.userInteractionEnabled = YES;
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view makeToast:@"修改成功" duration:2];
            [self getUserInfo];
        }else{
            NSString *msg=[resultDict objectForKey:@"msg"];
            if ([msg length]>0) {
                [self.view makeToast:msg duration:2];
            }
        }
    }];
}

//取消选择地址
-(void)cancelBtnClick
{
    [self.smallBgView removeFromSuperview];
}

#pragma mark ===点击更换头像的方法===
-(void)changeHeadImage
{
    NSLog(@"点击了修改头像按钮");
    
    //弹出actionsheet。选择获取头像的方式
    //从相册获取图片
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本地相册",nil];
    actionSheet.tag=1002;
    [actionSheet showInView:self.view];
}

#pragma mark ===UIActionSheet Delegate===
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            //相机
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = sourceType;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
            }
            else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
            
        }
            break;
            //本地相册
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

//当选择一张图片后进入这里
#pragma mark ===UIImagePickerController Delegate===
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage])
    {
        self.headImage = [info objectForKey:UIImagePickerControllerEditedImage];
        self.headData = UIImageJPEGRepresentation(self.headImage, 0.5f);
        [SVProgressHUD showWithStatus:@"提交中..."];
        [HTTPManager updateUserInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId nickname:self.userInfo.nickname sex:self.userInfo.sex age:self.userInfo.age address:self.userInfo.address sign:self.userInfo.sign img:self.headData complete:^(NSDictionary *resultDict) {
            [SVProgressHUD dismiss];
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.view makeToast:@"修改成功" duration:2];
                [self saveImage:self.headImage];
                [self getUserInfo];
            }else{
                NSString *msg=[resultDict objectForKey:@"msg"];
                if ([msg length]>0) {
                    [self.view makeToast:msg duration:2];
                }
                
            }
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image
{
    //    NSLog(@"保存头像！");
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.png"];
    //    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success)
    {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //        UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(600, 600)];
    //    [UIImageJPEGRepresentation(smallImage, 0.5f) writeToFile:imageFilePath atomically:YES];//写入文件
    [UIImagePNGRepresentation(smallImage) writeToFile:imageFilePath atomically:YES];//写入文件
    //    UIImage *photo = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    _headImageView.image=photo;
    
    self.headIV.image=self.headImage;
    
    
    
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image)
    {
        newimage = nil;
    }
    else
    {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height)
        {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else
        {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
