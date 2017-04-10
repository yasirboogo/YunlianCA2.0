//
//  ShippingAddressViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/5.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ShippingAddressViewController.h"

#import "AddShippingAddressViewController.h"


@interface ShippingAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)Model *addressModel;
@property(nonatomic,assign)NSInteger deleteTag;
@property(nonatomic,strong)NSString *addressId;

@end

@implementation ShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=COLOR_HEADVIEW;
    
    [self createNavigationBar];
    [self createBottomBtn];
    
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getAddressList];
    
    
    
    
}

-(void)getAddressList
{
    [HTTPManager getShippingAddressListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"20" complete:^(Model *model) {
        self.addressModel=model;
        
        [self createTableView];
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"管理地址";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createBottomBtn
{
    UIButton *bottomBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-WZ(50)-64, SCREEN_WIDTH, WZ(50))];
    bottomBtn.backgroundColor=COLOR_WHITE;
    [bottomBtn setTitle:@"+ 添加新地址" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, bottomBtn.top, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_LIGHTGRAY;
    [self.view addSubview:lineView];
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
    return self.addressModel.shippingAddressArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    NSDictionary *addressDict=[self.addressModel.shippingAddressArray objectAtIndex:indexPath.section];
    NSString *address=[addressDict objectForKey:@"address"];
    NSString *city=[addressDict objectForKey:@"city"];
    NSString *createTime=[addressDict objectForKey:@"createTime"];
    NSString *addressId=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"id"]];
    NSString *status=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"status"]];
    NSString *userId=[addressDict objectForKey:@"userId"];
    NSString *username=[addressDict objectForKey:@"username"];
    NSString *userphone=[addressDict objectForKey:@"userphone"];
    
    CGSize shSize=[ViewController sizeWithString:@"收货人：" font:FONT(17,15) maxSize:CGSizeMake(WZ(80),WZ(25))];
    UILabel *shLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), shSize.width, WZ(25))];
    shLabel.text=@"收货人：";
    shLabel.font=FONT(17,15);
    [cell.contentView addSubview:shLabel];
    
    CGSize shouHuoSize=[ViewController sizeWithString:username font:FONT(17,15) maxSize:CGSizeMake(WZ(200),WZ(25))];
    UILabel *shouHuoLabel=[[UILabel alloc]initWithFrame:CGRectMake(shLabel.right, WZ(10), shouHuoSize.width, WZ(25))];
    shouHuoLabel.text=username;
    shouHuoLabel.font=FONT(17,15);
    [cell.contentView addSubview:shouHuoLabel];
    
    CGSize mobileSize=[ViewController sizeWithString:userphone font:FONT(17,15) maxSize:CGSizeMake(WZ(200),WZ(25))];
    UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-mobileSize.width, WZ(10), mobileSize.width, WZ(25))];
    mobileLabel.text=userphone;
    mobileLabel.font=FONT(17,15);
    [cell.contentView addSubview:mobileLabel];
    
    CGSize addressSize=[ViewController sizeWithString:[NSString stringWithFormat:@"%@%@",city,address] font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(200))];
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), shLabel.bottom+WZ(10), addressSize.width, addressSize.height)];
    addressLabel.text=[NSString stringWithFormat:@"%@%@",city,address];
    addressLabel.font=FONT(13,11);
    addressLabel.numberOfLines=0;
    [cell.contentView addSubview:addressLabel];
    
    UIView *lineView0=[[UIView alloc]initWithFrame:CGRectMake(0, addressLabel.bottom+WZ(10), SCREEN_WIDTH, 1)];
    lineView0.backgroundColor=COLOR_HEADVIEW;
    [cell.contentView addSubview:lineView0];
    
    UIButton *checkBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), lineView0.bottom+WZ(12.5), WZ(20), WZ(20))];
    checkBtn.layer.cornerRadius=checkBtn.width/2.0;
    checkBtn.clipsToBounds=YES;
    [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkBtn];
    
    if ([status isEqualToString:@"1"])
    {
        checkBtn.backgroundColor=COLOR(254, 167, 173, 1);
    }
    else
    {
        checkBtn.backgroundColor=COLOR_LIGHTGRAY;
    }
    
    CGSize mrdzSize=[ViewController sizeWithString:@"默认地址" font:FONT(17,15) maxSize:CGSizeMake(WZ(100),WZ(25))];
    UILabel *mrdzLabel=[[UILabel alloc]initWithFrame:CGRectMake(checkBtn.right+WZ(15), lineView0.bottom+WZ(10), mrdzSize.width, WZ(25))];
    mrdzLabel.text=@"默认地址";
    mrdzLabel.font=FONT(17,15);
    [cell.contentView addSubview:mrdzLabel];
    
    CGSize deleteSize=[ViewController sizeWithString:@"删除" font:FONT(17,15) maxSize:CGSizeMake(WZ(100),WZ(25))];
    UILabel *deleteLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-deleteSize.width, mrdzLabel.top, deleteSize.width, WZ(25))];
    deleteLabel.text=@"删除";
    deleteLabel.font=FONT(17,15);
    [cell.contentView addSubview:deleteLabel];
    
    UIImageView *deleteIV=[[UIImageView alloc]initWithFrame:CGRectMake(deleteLabel.left-WZ(10+20), mrdzLabel.top+WZ(3), WZ(20), WZ(20))];
    deleteIV.image=IMAGE(@"shanchu");
    [cell.contentView addSubview:deleteIV];
    
    ShippingAddressDeleteBtn *deleteBtn=[[ShippingAddressDeleteBtn alloc]initWithFrame:CGRectMake(deleteIV.left, mrdzLabel.top, deleteIV.width+deleteLabel.width+WZ(10), WZ(25))];
    deleteBtn.tag=indexPath.section;
    deleteBtn.addressId=addressId;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteBtn];
    
    CGSize editSize=[ViewController sizeWithString:@"编辑" font:FONT(17,15) maxSize:CGSizeMake(WZ(100),WZ(25))];
    UILabel *editLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-deleteSize.width-deleteIV.width-editSize.width-WZ(15+10+25), mrdzLabel.top, editSize.width, WZ(25))];
    editLabel.text=@"编辑";
    editLabel.font=FONT(17,15);
    [cell.contentView addSubview:editLabel];
    
    UIImageView *editIV=[[UIImageView alloc]initWithFrame:CGRectMake(editLabel.left-WZ(10+20), mrdzLabel.top+WZ(3), WZ(20), WZ(20))];
    editIV.image=IMAGE(@"bianji");
    [cell.contentView addSubview:editIV];
    
    UIButton *editBtn=[[UIButton alloc]initWithFrame:CGRectMake(editIV.left, mrdzLabel.top, editIV.width+editLabel.width+WZ(10), WZ(25))];
    editBtn.tag=indexPath.section;
    [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editBtn];
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *addressDict=[self.addressModel.shippingAddressArray objectAtIndex:indexPath.section];
    NSString *address=[addressDict objectForKey:@"address"];
    CGSize addressSize=[ViewController sizeWithString:address font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(200))];
    
    return WZ(10+25+10+10+45)+addressSize.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
    headView.backgroundColor=COLOR_HEADVIEW;
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(10);
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加新地址
-(void)bottomBtnClick
{
    AddShippingAddressViewController *vc=[[AddShippingAddressViewController alloc]init];
    vc.isAddAddress=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

//默认地址
-(void)checkBtnClick
{
    
    
    
}

//删除地址
-(void)deleteBtnClick:(ShippingAddressDeleteBtn*)button
{
    self.deleteTag=button.tag;
    NSDictionary *addressDict=[self.addressModel.shippingAddressArray objectAtIndex:button.tag];
    self.addressId=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"id"]];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除此收货地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [HTTPManager deleteShippingAddressWithAddressId:self.addressId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.addressModel.shippingAddressArray removeObjectAtIndex:self.deleteTag];
                [_tableView reloadData];
                [self.view makeToast:@"删除地址成功" duration:1.0];
            }
            else
            {
//                NSString *error=[resultDict objectForKey:@"error"];
                [self.view makeToast:result duration:1.0];
            }
            
        }];
    }
}

//编辑地址
-(void)editBtnClick:(UIButton*)button
{
    NSDictionary *addressDict=[self.addressModel.shippingAddressArray objectAtIndex:button.tag];
    
    AddShippingAddressViewController *vc=[[AddShippingAddressViewController alloc]init];
    vc.isEditAddress=YES;
    vc.addressDict=addressDict;
    [self.navigationController pushViewController:vc animated:YES];
    
    
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

@implementation ShippingAddressDeleteBtn

@synthesize addressId;

@end
