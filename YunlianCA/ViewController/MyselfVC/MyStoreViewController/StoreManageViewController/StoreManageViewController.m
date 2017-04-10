//
//  StoreManageViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "StoreManageViewController.h"

#import "CouponManageViewController.h"
#import "GoodsManageViewController.h"
#import "CreateStoreViewController.h"
#import "MyStoreViewController.h"

@interface StoreManageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)StoreModel *storeModel;


@end

@implementation StoreManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    
    if (self.isMyStoreVC==YES)
    {
        //如果是从我的店铺列表进来的 就根据传进来的storeId请求店铺详细信息
        [HTTPManager getStoreDetailInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId storeId:self.storeId complete:^(StoreModel *model) {
            self.storeModel=model;
            self.storeId=model.storeId;
            self.createTime=model.storeCreateTime;
            self.storeIconUrl=model.headImg;
            self.storeName=model.storeName;
            self.openTime=model.opentime;
            self.storeDes=model.storeExplains;
            self.lanmu=model.moduleName1;
            self.erjilanmu=model.moduleName2;
            
            NSMutableArray *imgUrlArray=[NSMutableArray array];
            NSArray *urlArray=[model.storeImageUrl componentsSeparatedByString:@","];
            for (NSInteger i=0; i<urlArray.count; i++)
            {
                NSString *img=urlArray[i];
                [imgUrlArray addObject:img];
            }
            self.storeImagesUrl=imgUrlArray;
            self.storeAddress=model.address;
            self.storeMobile=model.mobile;
            self.storeContact=model.username;
            self.moduleId=model.moduleId;
            self.longitudeString=model.longitude;
            self.latitudeString=model.latitude;
            
            
            
            [self createTableView];
        }];
    }
    if (self.isCreateStoreVC==YES)
    {
        [self createTableView];
    }
    
    
}

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
    self.title=@"店铺管理";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(20+10), 0, WZ(20), WZ(20))];
    [deleteBtn setBackgroundImage:IMAGE(@"shanchu") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
//    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(70), WZ(10), WZ(70), WZ(25))];
//    //    rightView.backgroundColor=COLOR_GREEN;
//    
//    UIButton *editBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(28), WZ(25))];
//    [editBtn setBackgroundImage:IMAGE(@"bianji") forState:UIControlStateNormal];
//    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:editBtn];
//    
//    UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(25), 0, WZ(25), WZ(25))];
//    [deleteBtn setBackgroundImage:IMAGE(@"shanchu") forState:UIControlStateNormal];
//    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:deleteBtn];
//    
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
//    self.navigationItem.rightBarButtonItem=rightItem;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    if (section==2)
    {
        return 6;
    }
    else
    {
        return 1;//18013820100
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
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"管理优惠券功能",@"商品管理", nil];
        cell.textLabel.text=titleArray[indexPath.row];
        cell.textLabel.textColor=COLOR_RED;
        cell.textLabel.font=FONT(17, 15);
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
        
        CGSize fblmSize=[ViewController sizeWithString:@"发布栏目：" font:FONT(15,13) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *fblmLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), fblmSize.width, WZ(25))];
        fblmLabel.text=@"发布栏目：";
        fblmLabel.textColor=COLOR_LIGHTGRAY;
        fblmLabel.font=FONT(15,13);
        [cell.contentView addSubview:fblmLabel];
        
        UILabel *fabulanmuLabel=[[UILabel alloc]initWithFrame:CGRectMake(fblmLabel.right, fblmLabel.top, SCREEN_WIDTH-fblmLabel.right-WZ(15), fblmLabel.height)];
        fabulanmuLabel.text=self.lanmu;
        fabulanmuLabel.textColor=COLOR_LIGHTGRAY;
        fabulanmuLabel.font=FONT(15,13);
        [cell.contentView addSubview:fabulanmuLabel];
        
        CGSize ejlmSize=[ViewController sizeWithString:@"二级栏目：" font:FONT(15,13) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *ejlmLabel=[[UILabel alloc]initWithFrame:CGRectMake(fblmLabel.left, fblmLabel.bottom, ejlmSize.width, WZ(25))];
        ejlmLabel.text=@"二级栏目：";
        ejlmLabel.textColor=COLOR_LIGHTGRAY;
        ejlmLabel.font=FONT(15,13);
        [cell.contentView addSubview:ejlmLabel];
        
        UILabel *erjilanmuLabel=[[UILabel alloc]initWithFrame:CGRectMake(ejlmLabel.right, ejlmLabel.top, SCREEN_WIDTH-ejlmLabel.right-WZ(15), ejlmLabel.height)];
        erjilanmuLabel.text=self.erjilanmu;
        erjilanmuLabel.textColor=COLOR_LIGHTGRAY;
        erjilanmuLabel.font=FONT(15,13);
        [cell.contentView addSubview:erjilanmuLabel];
        
        CGSize cjsjSize=[ViewController sizeWithString:@"创建时间：" font:FONT(15,13) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *cjsjLabel=[[UILabel alloc]initWithFrame:CGRectMake(fblmLabel.left, ejlmLabel.bottom, cjsjSize.width, WZ(25))];
        cjsjLabel.text=@"创建时间：";
        cjsjLabel.textColor=COLOR_LIGHTGRAY;
        cjsjLabel.font=FONT(15,13);
        [cell.contentView addSubview:cjsjLabel];
        
        UILabel *chuangjianshijianLabel=[[UILabel alloc]initWithFrame:CGRectMake(cjsjLabel.right, cjsjLabel.top, SCREEN_WIDTH-cjsjLabel.right-WZ(15), cjsjLabel.height)];
        chuangjianshijianLabel.text=self.createTime;
        chuangjianshijianLabel.textColor=COLOR_LIGHTGRAY;
        chuangjianshijianLabel.font=FONT(15,13);
        [cell.contentView addSubview:chuangjianshijianLabel];
        
        
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
        
        if (indexPath.row==0)
        {
            UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(60), WZ(60))];
            iconImageView.clipsToBounds=YES;
            iconImageView.layer.cornerRadius=3;
            [cell.contentView addSubview:iconImageView];
            
            if (self.storeIcon!=nil)
            {
                iconImageView.image=self.storeIcon;
            }
            if (self.storeIconUrl!=nil)
            {
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,self.storeIconUrl]] placeholderImage:IMAGE(@"morentupian")];
            }
            
            NSString *nameString=self.storeName;
            CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(20))];
            
            UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(20))];
            nameLabel.text=nameString;
            nameLabel.font=FONT(15,13);
            nameLabel.textColor=COLOR(146, 135, 187, 1);
            //    nameLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:nameLabel];
            
            NSString *shopHoursString=[NSString stringWithFormat:@"营业时间：%@",self.openTime];
            CGSize shopHoursSize=[ViewController sizeWithString:shopHoursString font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(15))];
            
            UILabel *shopHoursLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(6), shopHoursSize.width, WZ(15))];
            shopHoursLabel.text=shopHoursString;
            shopHoursLabel.font=FONT(12,10);
            shopHoursLabel.textColor=COLOR_LIGHTGRAY;
            //    shopHoursLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:shopHoursLabel];
        }
        if (indexPath.row==1)
        {
            UILabel *dpjjLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            dpjjLabel.text=@"店铺简介";
            dpjjLabel.textColor=COLOR_LIGHTGRAY;
            dpjjLabel.font=FONT(17, 15);
//            dpjjLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:dpjjLabel];
            
            NSString *jianjieString=self.storeDes;
            CGSize jianjieSize=[ViewController sizeWithString:jianjieString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
            
            UILabel *jianjieLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), dpjjLabel.bottom, jianjieSize.width, jianjieSize.height)];
            jianjieLabel.text=jianjieString;
            jianjieLabel.font=FONT(15,13);
            jianjieLabel.numberOfLines=0;
            [cell.contentView addSubview:jianjieLabel];
        }
        if (indexPath.row==2)
        {
            NSInteger imageCount = 0;
            if (self.isMyStoreVC==YES)
            {
                imageCount=self.storeImagesUrl.count;
            }
            if (self.isCreateStoreVC==YES)
            {
                imageCount=self.storeImages.count;
            }
            
            CGFloat imageWidth=WZ(80);
            CGFloat leftMargin=WZ(15);
            CGFloat space=WZ(8);
            
            UILabel *tpxqLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            tpxqLabel.text=[NSString stringWithFormat:@"图片详情 (%ld张)",(long)imageCount];
            tpxqLabel.textColor=COLOR_LIGHTGRAY;
            tpxqLabel.font=FONT(17, 15);
            [cell.contentView addSubview:tpxqLabel];
            
            UIScrollView *imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, tpxqLabel.bottom, SCREEN_WIDTH, WZ(80))];
            imageScrollView.contentSize=CGSizeMake(leftMargin+(imageWidth+space)*imageCount+WZ(7), imageWidth);
//            imageScrollView.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:imageScrollView];
            
            for (NSInteger i=0; i<imageCount; i++)
            {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(leftMargin+(imageWidth+space)*i, 0, imageWidth, imageWidth)];
                [imageScrollView addSubview:imageView];
                
                if (self.storeIcon!=nil)
                {
                    imageView.image=self.storeImages[i];
                }
                if (self.storeIconUrl!=nil)
                {
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,self.storeImagesUrl]] placeholderImage:IMAGE(@"morentupian")];
                }
            }
        }
        if (indexPath.row==3)
        {
            cell.textLabel.text=@"店铺地址";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            cell.textLabel.font=FONT(17, 15);
            
            UILabel *dpdzLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15*2+10)-WZ(240), 0, WZ(265), WZ(50))];
            dpdzLabel.text=self.storeAddress;
            dpdzLabel.font=FONT(15,13);
            dpdzLabel.numberOfLines=2;
//            dpdzLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:dpdzLabel];
        }
        if (indexPath.row==4)
        {
            cell.textLabel.text=@"联系电话";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            cell.textLabel.font=FONT(17, 15);
            
            UILabel *lxdhLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
            lxdhLabel.text=self.storeMobile;
            lxdhLabel.font=FONT(15,13);
            //        lxdhLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:lxdhLabel];
        }
        if (indexPath.row==5)
        {
            cell.textLabel.text=@"联系人";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            cell.textLabel.font=FONT(17, 15);
            
            UILabel *lxrLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
            lxrLabel.text=self.storeContact;
            lxrLabel.font=FONT(15,13);
            //        lxrLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:lxrLabel];
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
        if (indexPath.row==0)
        {
            //优惠券管理功能
            CouponManageViewController *vc=[[CouponManageViewController alloc]init];
            vc.storeId=self.storeId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if (indexPath.row==1)
        {
            //商品管理功能
            GoodsManageViewController *vc=[[GoodsManageViewController alloc]init];
            vc.storeId=self.storeId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1 || section==2)
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
    if (indexPath.section==0)
    {
        return WZ(50);
    }
    if (indexPath.section==1)
    {
        return WZ(95);
    }
    else
    {
        if (indexPath.row==0)
        {
            return WZ(90);
        }
        if (indexPath.row==1)
        {
            NSString *jianjieString=self.storeDes;
            CGSize jianjieSize=[ViewController sizeWithString:jianjieString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
            
            return jianjieSize.height+WZ(50+10);
        }
        if (indexPath.row==2)
        {
            return WZ(140);
        }
        else
        {
            return WZ(50);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1 || section==2)
    {
        return WZ(15);
    }
    else
    {
        return 0;
    }
}



#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
//    [self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[MyStoreViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


////编辑店铺
//-(void)editBtnClick
//{
//    CreateStoreViewController *vc=[[CreateStoreViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

//删除店铺
-(void)deleteBtnClick
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除此店铺？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [HTTPManager deleteStoreWithIds:self.storeId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.view.window makeToast:@"删除店铺成功" duration:1.0];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                //            NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:result duration:1.0];
            }
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
