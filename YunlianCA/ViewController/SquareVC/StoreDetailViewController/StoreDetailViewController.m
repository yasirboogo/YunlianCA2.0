//
//  StoreDetailViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "ShareView.h"
#import "GoodsDetailViewController.h"
#import "OrderConfirmViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <SVProgressHUD.h>
@interface StoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_bottomView;
    
    
}
@property(nonatomic,strong)CTCallCenter *callCenter;
@property(nonatomic,strong)UIButton *shoucangBtn;
@property(nonatomic,strong)UIButton *getBtn;
@property(nonatomic,strong)NSMutableArray *goodsListViewArray;
@property(nonatomic,strong)NSMutableArray *countLabelArray;
@property(nonatomic,strong)StoreModel *storeModel;
@property(nonatomic,strong)StoreModel *goodsModel;
@property(nonatomic,strong)NSMutableArray *goodsCountArray;
@property(nonatomic,strong)UILabel *totalPriceLabel;
@property(nonatomic,strong)NSString *totalPrice;
@property(nonatomic,strong)NSString *addressId;
@property(nonatomic,strong)NSString *receiptAddress;
@property(nonatomic,strong)UIView *couponBgView;
@property(nonatomic,strong)NSArray *imgUrlArray;
@property(nonatomic,strong)UILabel* callLabel;

@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.totalPrice=@"0.00";
    self.addressId=@"";
    
    self.goodsListViewArray=[NSMutableArray array];
    self.countLabelArray=[NSMutableArray array];
    self.goodsCountArray=[NSMutableArray array];
    
    
    [self createNavigationBar];
    [self createBottomView];
    [self createTableView];
    [SVProgressHUD showWithStatus:@"加载中..."];
//    NSLog(@"店铺id===%@",self.storeId);
    [self getStoreDetail];
    
    
    //获取商品列表
    [HTTPManager getGoodsInStoreDetailInfoWithStoreId:self.storeId pageNum:@"1" pageSize:@"20" complete:^(StoreModel *model) {
        
        self.goodsModel=model;
        [self goodsListCellView];
        [_tableView reloadData];
    }];
    
    //获取用户默认地址
    [HTTPManager getUserDefaultShippingAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *addressDict=[resultDict objectForKey:@"receiptInfo"];
            NSString *city=[addressDict objectForKey:@"city"];
            NSString *address=[addressDict objectForKey:@"address"];
            self.receiptAddress=[NSString stringWithFormat:@"%@%@",city,address];
            self.addressId=[addressDict objectForKey:@"id"];
        }
        else
        {
            [self.view makeToast:@"您还没有设置收货地址，请设置后购买" duration:2.0];
        }
    }];
    
    //添加拨打电话的监听
    [self callStore];

}

//获取商铺详情
-(void)getStoreDetail
{
    [HTTPManager getStoreDetailInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId storeId:self.storeId complete:^(StoreModel *model) {
        [SVProgressHUD dismiss];
        if (model) {
            self.storeModel=model;
            [_tableView reloadData];
            
            if ([self.storeModel.storeIsCollect isEqualToString:@"0"])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_hei") forState:UIControlStateNormal];
            }
            if ([self.storeModel.storeIsCollect isEqualToString:@"1"])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_huang") forState:UIControlStateNormal];
            }

        }else{
            [self.view makeToast:@"加载失败" duration:2];
        }
        
    }];
}


//创建商品列表cellView
-(void)goodsListCellView
{
    for (NSInteger i=0; i<self.goodsModel.goodsArray.count; i++)
    {
        NSDictionary *goodsDict=self.goodsModel.goodsArray[i];
        NSString *name=[goodsDict objectForKey:@"name"];
//        NSString *price=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"price"]];
        
//        NSString *createtime=[goodsDict objectForKey:@"createtime"];
//        NSString *explain=[goodsDict objectForKey:@"explain"];
//        NSString *goodsId=[goodsDict objectForKey:@"id"];
        NSString *img=[goodsDict objectForKey:@"img"];
//        NSArray *imgsetArray=[goodsDict objectForKey:@"imgset"];
        NSString *priceZH=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"priceZH"]];
//        NSString *repertory=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"repertory"]];
//        NSString *sales=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"sales"]];
//        NSString *storeId=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"storeId"]];
//        NSString *userId=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"userId"]];
        
        UIView *goodsListView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(90))];
        goodsListView.backgroundColor=COLOR_WHITE;
        [self.goodsListViewArray addObject:goodsListView];
        
        UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(80), WZ(60))];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentupian")];
        [goodsListView addSubview:iconImageView];
        
        NSString *nameString=name;
        CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(17,15) maxSize:CGSizeMake(WZ(255), WZ(25))];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(25))];
        nameLabel.text=nameString;
        nameLabel.font=FONT(17,15);
        nameLabel.textColor=COLOR_BLACK;
        [goodsListView addSubview:nameLabel];
        
        NSString *priceString=[NSString stringWithFormat:@"¥ %@",priceZH];
        CGSize priceSize=[ViewController sizeWithString:priceString font:FONT(17,15) maxSize:CGSizeMake(WZ(255), WZ(25))];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(10), priceSize.width, WZ(25))];
        priceLabel.text=priceString;
        priceLabel.font=FONT(17,15);
        priceLabel.textColor=COLOR_ORANGE;
        [goodsListView addSubview:priceLabel];
        
        CGSize addSize=[ViewController sizeWithString:@"+" font:FONT(17,15) maxSize:CGSizeMake(WZ(50), WZ(30))];
        UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-addSize.width-WZ(20), iconImageView.bottom-WZ(15+30), addSize.width+WZ(20), WZ(30))];
        addBtn.tag=i;
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        addBtn.titleLabel.font=FONT(17,15);
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [goodsListView addSubview:addBtn];
//        addBtn.backgroundColor=COLOR_CYAN;
        
        CGSize countSize=[ViewController sizeWithString:@"0" font:FONT(15,13) maxSize:CGSizeMake(WZ(1500), WZ(30))];
        UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(addBtn.left-WZ(5)-countSize.width-WZ(10), addBtn.top, countSize.width+WZ(10), WZ(30))];
        countLabel.tag=i;
        countLabel.text=@"0";
        countLabel.font=FONT(15,13);
        countLabel.textAlignment=NSTextAlignmentCenter;
        [goodsListView addSubview:countLabel];
        [self.countLabelArray addObject:countLabel];
        
        CGSize subtractSize=[ViewController sizeWithString:@"-" font:FONT(17,15) maxSize:CGSizeMake(WZ(50), WZ(30))];
        UIButton *subtractBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+20+10+20)-addSize.width-countLabel.width-subtractSize.width, iconImageView.bottom-WZ(15+30), subtractSize.width+WZ(20), WZ(30))];
        subtractBtn.tag=i;
        [subtractBtn setTitle:@"-" forState:UIControlStateNormal];
        [subtractBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        subtractBtn.titleLabel.font=FONT(17,15);
        [subtractBtn addTarget:self action:@selector(subtractBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [goodsListView addSubview:subtractBtn];
//        subtractBtn.backgroundColor=COLOR_CYAN;
        
        //把各商品选择的个数存入数组
        NSInteger goodsCount=0;
        [self.goodsCountArray addObject:[NSString stringWithFormat:@"%ld",(long)goodsCount]];
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    [SVProgressHUD dismiss];
}

-(void)createNavigationBar
{
    self.title=@"详情";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(70), WZ(10), WZ(70), WZ(25))];
    //    rightView.backgroundColor=COLOR_GREEN;
    
    UIButton *shoucangBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(25), WZ(25))];
    [shoucangBtn addTarget:self action:@selector(shoucangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shoucangBtn];
    self.shoucangBtn=shoucangBtn;
    
    UIButton *shareBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(25), 0, WZ(20), WZ(25))];
    [shareBtn setBackgroundImage:IMAGE(@"fenxiang") forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareBtn];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createBottomView
{
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(50), SCREEN_WIDTH, WZ(50))];
    _bottomView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_bottomView];
    
    CGSize hjSize=[ViewController sizeWithString:@"合计：¥ " font:FONT(15,13) maxSize:CGSizeMake(WZ(100), WZ(30))];
    UILabel *hjLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), hjSize.width, WZ(30))];
    hjLabel.text=@"合计：¥ ";
    hjLabel.font=FONT(15,13);
    [_bottomView addSubview:hjLabel];
    
    UILabel *totalPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(hjLabel.right, hjLabel.top, WZ(200), WZ(30))];
    totalPriceLabel.text=self.totalPrice;
    totalPriceLabel.font=FONT(15,13);
    [_bottomView addSubview:totalPriceLabel];
    self.totalPriceLabel=totalPriceLabel;
    
    CGSize buySize=[ViewController sizeWithString:@"立即购买" font:FONT(17,15) maxSize:CGSizeMake(WZ(200), WZ(30))];
    UIButton *buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-buySize.width-WZ(30), 0, buySize.width+WZ(30), _bottomView.height)];
    buyBtn.titleLabel.font=FONT(17, 15);
    buyBtn.backgroundColor=COLOR(254, 153, 160, 1);
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:buyBtn];
    
    
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-_bottomView.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    if (section==1)
    {
        return self.storeModel.couponArray.count;
    }
    if (section==2)
    {
        return 5;
    }
    else
    {
        return self.goodsModel.goodsArray.count;
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
        
        UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(60), WZ(60))];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,self.storeModel.headImg]] placeholderImage:IMAGE(@"morentupian")];
        iconImageView.clipsToBounds=YES;
        iconImageView.layer.cornerRadius=3;
        [cell.contentView addSubview:iconImageView];
        
        NSString *nameString;
        if ([self.storeModel.merchantName isEqualToString:@"(null)"] || self.storeModel.merchantName==nil || [self.storeModel.merchantName isEqualToString:@""])
        {
            nameString=self.storeModel.storeName;
        }
        else
        {
            nameString=[NSString stringWithFormat:@"%@(%@)",self.storeModel.storeName,self.storeModel.merchantName];
        }
        
        
        CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(17,15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15+60+10+15), WZ(20))];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(20))];
        nameLabel.text=nameString;
        nameLabel.font=FONT(17,15);
        nameLabel.textColor=COLOR(146, 135, 187, 1);
        //    nameLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:nameLabel];
        
        NSString *shopHoursString=[NSString stringWithFormat:@"营业时间：%@",self.storeModel.opentime];
        CGSize shopHoursSize=[ViewController sizeWithString:shopHoursString font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(15))];
        
        UILabel *shopHoursLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(6), shopHoursSize.width, WZ(15))];
        shopHoursLabel.text=shopHoursString;
        shopHoursLabel.font=FONT(15,13);
        shopHoursLabel.textColor=COLOR_LIGHTGRAY;
        //    shopHoursLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:shopHoursLabel];
        
        
        
        
        
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
        
        NSDictionary *couponDict=self.storeModel.couponArray[indexPath.row];
        NSString *money=[couponDict objectForKey:@"money"];
        NSString *minMoney=[couponDict objectForKey:@"minMoney"];
        NSString *isYQ=[NSString stringWithFormat:@"%@",[couponDict objectForKey:@"isYQ"]];
        
        UIView *couponBgView=[[UIView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(70))];
        couponBgView.backgroundColor=COLOR(255, 63, 94, 1);
        [cell.contentView addSubview:couponBgView];
        self.couponBgView=couponBgView;
        
        CGSize priceSize=[ViewController sizeWithString:[NSString stringWithFormat:@"¥ %@",money] font:FONT(27,25) maxSize:CGSizeMake(WZ(120), couponBgView.height-WZ(30))];
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), WZ(15), priceSize.width+WZ(10), couponBgView.height-WZ(30))];
        priceLabel.text=[NSString stringWithFormat:@"¥ %@",money];
//        priceLabel.text=@"¥ 9999";
        priceLabel.textColor=COLOR_WHITE;
        priceLabel.font=FONT(27,25);
        priceLabel.textAlignment=NSTextAlignmentCenter;
        [couponBgView addSubview:priceLabel];
//        priceLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(priceLabel.right+WZ(10), WZ(10), WZ(150), WZ(25))];
        titleLabel.text=@"优惠券";
        titleLabel.textColor=COLOR_WHITE;
        titleLabel.font=FONT(19,17);
        [couponBgView addSubview:titleLabel];
//        titleLabel.backgroundColor=COLOR_CYAN;
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, WZ(25))];
        subLabel.text=[NSString stringWithFormat:@"满%@元可使用",minMoney];
        subLabel.textColor=COLOR_WHITE;
        subLabel.font=FONT(13,11);
        [couponBgView addSubview:subLabel];
//        subLabel.backgroundColor=COLOR_CYAN;
        
        NSString *lingquString;
        if ([isYQ isEqualToString:@"0"])
        {
            lingquString=@"立即领取";
        }
        if ([isYQ isEqualToString:@"1"])
        {
            lingquString=@"已领取";
        }
        
        CGSize getSize=[ViewController sizeWithString:lingquString font:FONT(15,13) maxSize:CGSizeMake(WZ(120), WZ(25))];
        UIButton *getBtn=[[UIButton alloc]initWithFrame:CGRectMake(couponBgView.width-WZ(10)-getSize.width-WZ(15), WZ(22.5), getSize.width+WZ(15), WZ(25))];
        getBtn.tag=indexPath.row;
        getBtn.titleLabel.font=FONT(15,13);
        [getBtn addTarget:self action:@selector(getBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [couponBgView addSubview:getBtn];
        self.getBtn=getBtn;
        if ([isYQ isEqualToString:@"0"])
        {
            getBtn.backgroundColor=COLOR_WHITE;
            [getBtn setTitle:lingquString forState:UIControlStateNormal];
            [getBtn setTitleColor:COLOR(255, 63, 94, 1) forState:UIControlStateNormal];
        }
        if ([isYQ isEqualToString:@"1"])
        {
            getBtn.userInteractionEnabled=NO;
            getBtn.backgroundColor=COLOR_WHITE;
            [getBtn setTitle:@"已领取" forState:UIControlStateNormal];
            [getBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2)
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
            //商铺简介
            UILabel *dpjjLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            dpjjLabel.text=@"店铺简介";
            dpjjLabel.textColor=COLOR_LIGHTGRAY;
            //            dpjjLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:dpjjLabel];
            
            NSString *jianjieString=self.storeModel.storeExplains;
            CGSize jianjieSize=[ViewController sizeWithString:jianjieString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
            
            UILabel *jianjieLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), dpjjLabel.bottom, jianjieSize.width, jianjieSize.height)];
            jianjieLabel.text=jianjieString;
            jianjieLabel.font=FONT(15,13);
            jianjieLabel.numberOfLines=0;
            [cell.contentView addSubview:jianjieLabel];
        }
        if (indexPath.row==1)
        {
//            NSLog(@"图片===%@",self.storeModel.storeImageUrl);
            self.imgUrlArray=[self.storeModel.storeImageUrl componentsSeparatedByString:@","];
//            NSLog(@"图片路径数组===%@",imgUrlArray);
            //图片详情
            NSInteger imageCount=self.imgUrlArray.count;
            CGFloat imageWidth=WZ(80);
            CGFloat leftMargin=WZ(15);
            CGFloat space=WZ(8);
            
            UILabel *tpxqLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            tpxqLabel.text=[NSString stringWithFormat:@"图片详情 (%lu张)",(unsigned long)imageCount];
            tpxqLabel.textColor=COLOR_LIGHTGRAY;
            [cell.contentView addSubview:tpxqLabel];
            
            UIScrollView *imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, tpxqLabel.bottom, SCREEN_WIDTH, WZ(80))];
            imageScrollView.contentSize=CGSizeMake(leftMargin+(imageWidth+space)*imageCount+WZ(7), imageWidth);
            //            imageScrollView.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:imageScrollView];
            
            for (NSInteger i=0; i<imageCount; i++)
            {
                NSString *img=self.imgUrlArray[i];
                
                UIButton *imageBtn=[[UIButton alloc]initWithFrame:CGRectMake(leftMargin+(imageWidth+space)*i, 0, imageWidth, imageWidth)];
                imageBtn.tag=i;
                [imageBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] forState:UIControlStateNormal placeholder:IMAGE(@"morentupian")];
                [imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageScrollView addSubview:imageBtn];
                
            }
            
            
        }
        if (indexPath.row==2)
        {
            //联系电话
            cell.textLabel.text=@"联系电话";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            UILabel *lxdhLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
            lxdhLabel.text=self.storeModel.mobile;
            lxdhLabel.font=FONT(17,15);
            //        lxdhLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:lxdhLabel];
            UIButton *callBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(50), 5, WZ(30), WZ(30))];
//            callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, WZ(30)/2.0);
//            callBtn.size=CGSizeMake(WZ(30), WZ(30));
            
            [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
            callBtn.layer.cornerRadius=callBtn.width/2.0;
            callBtn.clipsToBounds=YES;
            callBtn.tag=indexPath.row;
            [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:callBtn];
            
            if (self.storeModel.callNum==nil || [self.storeModel.callNum isEqualToString:@""])
            {
                self.storeModel.callNum=@"0";
            }
            
            NSString *callNumString=[NSString stringWithFormat:@"拨打%@次",self.storeModel.callNum];
            CGSize callLabelSize=[ViewController sizeWithString:callNumString font:FONT(11,9) maxSize:CGSizeMake(WZ(100),WZ(20))];
            
            UILabel *callLabel=[[UILabel alloc]initWithFrame:CGRectMake(callBtn.center.x-callLabelSize.width/2.0, CGRectGetHeight(callBtn.frame)+5, callLabelSize.width, WZ(20))];
            callLabel.adjustsFontSizeToFitWidth = YES;
            callLabel.textAlignment=NSTextAlignmentCenter;
            callLabel.text=callNumString;
            callLabel.textColor=COLOR(166, 213, 157, 1);
            callLabel.font=FONT(11,9);
            [cell.contentView addSubview:callLabel];
            self.callLabel=callLabel;
            
            
        }
        if (indexPath.row==3)
        {
            //联系人
            cell.textLabel.text=@"联系人";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            UILabel *lxrLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
            lxrLabel.text=self.storeModel.username;
            lxrLabel.font=FONT(17,15);
            //        lxrLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:lxrLabel];
            
            
        }
        if (indexPath.row==4)
        {
            //地址
            cell.textLabel.text=@"地址";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(205), WZ(50))];
            addressLabel.text=self.storeModel.address;
//            addressLabel.text=@"广东省广州市白云区云城西路228号228创意园C栋3楼";
            addressLabel.font=FONT(15,13);
            addressLabel.numberOfLines=2;
//            addressLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:addressLabel];
            
            UIButton *addressBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(10+50), WZ(10), WZ(50), WZ(30))];
            [addressBtn setTitle:@"导航" forState:UIControlStateNormal];
            [addressBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            addressBtn.backgroundColor=COLOR(254, 153, 160, 1);
            addressBtn.titleLabel.font=FONT(17, 15);
            addressBtn.clipsToBounds=YES;
            addressBtn.layer.cornerRadius=3;
            [addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addressBtn];
            
            
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
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
        
        
        UIView *cellView=self.goodsListViewArray[indexPath.row];
        [cell.contentView addSubview:cellView];
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)callBtnClick:(UIButton *)button{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.storeModel.mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==3)
    {
        NSDictionary *goodsDict=self.goodsModel.goodsArray[indexPath.row];
        NSString *goodsId=[goodsDict objectForKey:@"id"];
        NSString *storeId=self.storeModel.storeId;
        //跳转商品详情界面
        GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
        vc.merchantId=self.storeModel.merchantId;
        vc.goodsId=goodsId;
        vc.storeId=storeId;
        [self.navigationController pushViewController:vc animated:NO];
    }
//    if (indexPath.section==2&&indexPath.row==2) {
////        NSDictionary *storeDict=self.bigStoreArray[button.tag];
////        NSString *mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"mobile"]];
////        NSString *callStoreId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
//        
//        
//
//    }
}
-(void)callStore
{
    __weak StoreDetailViewController *weakSelf=self;
    
    
    _callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"挂断了电话咯Call has been disconnected");
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"电话通了Call has just been connected");
            //电话接通之后调用拨打电话次数+1的方法
           
            [HTTPManager addCallNumberWithStoreId:weakSelf.storeModel.storeId complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    weakSelf.storeModel.callNum=[NSString stringWithFormat:@"%ld",[weakSelf.storeModel.callNum integerValue]+1];
                    weakSelf.callLabel.text=[NSString stringWithFormat:@"拨打%@次",weakSelf.storeModel.callNum];
                }
               
                
            }];
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"来电话了Call is incoming");
            
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"正在播出电话call is dialing");
        }
        else
        {
            NSLog(@"嘛都没做Nothing is done");
        }
    };
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==3)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(50))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), titleView.width, titleView.height-WZ(10))];
        aView.backgroundColor=COLOR_WHITE;
        [titleView addSubview:aView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), aView.height)];
        label.text=@"商品列表";
        [aView addSubview:label];
        
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
        return WZ(90);
    }
    if (indexPath.section==1)
    {
        return WZ(100);
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            NSString *jianjieString=self.storeModel.storeExplains;
            CGSize jianjieSize=[ViewController sizeWithString:jianjieString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
            
            return jianjieSize.height+WZ(50+10);
        }
        if (indexPath.row==1)
        {
            return WZ(150);
        }
        else
        {
            return WZ(50)+5;
        }
    }
    else
    {
        return WZ(90);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3)
    {
        return WZ(50);
    }
    else
    {
        return 0;
    }
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航
-(void)addressBtnClick
{
    NSString *address=self.storeModel.address;
    
    CGFloat latitude=[self.storeModel.latitude floatValue];
    CGFloat longitude=[self.storeModel.longitude floatValue];
    
    NSString *appName=@"云联社区联盟";
    NSString *urlScheme=@"YunLianCA";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        //iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=36.547901&lon=104.258354&dev=1&style=2
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,latitude,longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        
        return;
    }
    //    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    //    {
    //        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",latitude, longitude,address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    //
    //        return;
    //    }
    else
    {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
        return;
    }
}

//收藏
-(void)shoucangBtnClick
{
    [HTTPManager addUserCollectionWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"3" objectid:self.storeId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_huang") forState:UIControlStateNormal];
            [self.view makeToast:@"收藏成功" duration:1.0];
        }
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"result"] duration:1.0];
        }
    }];
    
    
}

//分享
-(void)shareBtnClick
{
    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,self.storeModel.headImg]];
     [ShareView sharedInstance].isShowAdjacent = NO;
    [[ShareView sharedInstance] shareWithImageUrlArray:@[imageUrl] title:self.storeModel.storeName content:self.storeModel.storeExplains url:[NSString stringWithFormat:@"%@share/storeInfo.api?id=%@&userId=%@",HOST,self.storeId,[UserInfoData getUserInfoFromArchive].userId]];
}

//领取优惠券
-(void)getBtnClick:(UIButton*)button
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        NSDictionary *couponDict=self.storeModel.couponArray[button.tag];
        NSString *couponId=[couponDict objectForKey:@"id"];
        if (couponId==nil)
        {
            couponId=@"";
        }
        
        [HTTPManager getCouponFromStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId couponId:couponId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                button.userInteractionEnabled=NO;
                button.backgroundColor=COLOR_WHITE;
                [button setTitle:@"已领取" forState:UIControlStateNormal];
                [button setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
                
                [self getStoreDetail];
            }
            else
            {
                [self.view.window makeToast:[resultDict objectForKey:@"result"] duration:1.0];
            }
        }];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}

//立即购买
-(void)buyBtnClick
{
//    NSLog(@"购买的各商品数量===%@",self.goodsCountArray);
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        NSMutableArray *goodsListArray=[NSMutableArray array];
        NSMutableArray *goodsInfoArray=[NSMutableArray array];
        for (NSInteger i=0; i<self.goodsCountArray.count; i++)
        {
            NSString *goodsCount=self.goodsCountArray[i];
            NSDictionary *goodsDict=self.goodsModel.goodsArray[i];
            NSString *goodsId=[goodsDict objectForKey:@"id"];
            NSString *priceZH=[goodsDict objectForKey:@"priceZH"];
            NSString *goodsImg=[goodsDict objectForKey:@"img"];
            NSString *goodsName=[goodsDict objectForKey:@"name"];
            
            if ([goodsCount integerValue]>0)
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:goodsId,@"itemId",goodsCount,@"count",priceZH,@"amount", nil];
                [goodsListArray addObject:dict];
                
                NSMutableDictionary *goodsDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:goodsName,@"name",goodsCount,@"count",priceZH,@"amount",goodsImg,@"img", nil];
                [goodsInfoArray addObject:goodsDict];
            }
        }
        
        //    NSLog(@"将要购买的商品数组===%@",goodsListArray);
        
        NSMutableDictionary *orderDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.storeId,@"storeId",self.storeModel.userId,@"sellerid",[UserInfoData getUserInfoFromArchive].userId,@"buyerid",self.totalPrice,@"money",self.totalPrice,@"sfMoney",@"",@"explains",self.addressId,@"receiptId",@"",@"couponId",goodsListArray,@"list", nil];
        //    NSString *orderJsonString=[orderDict JSONString];
        //    NSLog(@"订单jsonString===%@",orderJsonString);
        NSLog(@"订单字典===%@",orderDict);
        
        if (self.totalPrice==nil || [self.totalPrice isEqualToString:@"0.00"])
        {
            [self.view makeToast:@"请至少选择一种商品" duration:2.0];
        }
        else
        {
            if (self.storeModel.userId==nil || [[NSString stringWithFormat:@"%@",self.storeModel.userId] isEqualToString:@""])
            {
                [self.view makeToast:@"未成功获取卖家信息，请重试" duration:2.0];
            }
            else
            {
                if ([UserInfoData getUserInfoFromArchive].userId==nil || [[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId] isEqualToString:@""])
                {
                    [self.view makeToast:@"未成功获取买家信息，请重试" duration:2.0];
                }
                else
                {
                    if (self.addressId==nil || [[NSString stringWithFormat:@"%@",self.addressId] isEqualToString:@""])
                    {
                        [self.view makeToast:@"请先设置默认收货地址" duration:2.0];
                    }
                    else
                    {
                        if (goodsListArray.count<=0)
                        {
                            [self.view makeToast:@"请至少选择一种商品" duration:2.0];
                        }
                        else
                        {
                            //跳转到订单确认界面
                            OrderConfirmViewController *vc=[[OrderConfirmViewController alloc]init];
                            vc.merchantId=self.storeModel.merchantId;
                            vc.orderDict=orderDict;
                            vc.goodsInfoArray=goodsInfoArray;
                            vc.isStoreDetailVC=YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }
            }
        }
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
    
    
    
    
}

//添加商品
-(void)addBtnClick:(UIButton*)button
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        UILabel *countLabel=self.countLabelArray[button.tag];
        NSInteger count=[self.goodsCountArray[button.tag] integerValue];
        count=count+1;
        [self.goodsCountArray replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
        countLabel.text=[NSString stringWithFormat:@"%ld",(long)count];
        
        NSString *priceString=[NSString stringWithFormat:@"%@",[self.goodsModel.goodsArray[button.tag] objectForKey:@"priceZH"]];
        CGFloat price=[priceString floatValue];
        self.totalPrice=[NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]+price];
        
        self.totalPriceLabel.text=self.totalPrice;
        
        //    NSLog(@"总价(+)===%@",self.totalPrice);
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
    
}

//减少商品
-(void)subtractBtnClick:(UIButton*)button
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        UILabel *countLabel=self.countLabelArray[button.tag];
        
        if ([self.goodsCountArray[button.tag] integerValue]>0)
        {
            NSInteger count=[self.goodsCountArray[button.tag] integerValue];
            count=count-1;
            [self.goodsCountArray replaceObjectAtIndex:button.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
            countLabel.text=[NSString stringWithFormat:@"%ld",(long)count];
            
            NSString *priceString=[NSString stringWithFormat:@"%@",[self.goodsModel.goodsArray[button.tag] objectForKey:@"priceZH"]];
            CGFloat price=[priceString floatValue];
            self.totalPrice=[NSString stringWithFormat:@"%.2f",[self.totalPrice floatValue]-price];
            
            self.totalPriceLabel.text=self.totalPrice;
        }
        
        
        //    NSLog(@"总价(-)===%@",self.totalPrice);
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
}

//点击全屏浏览图片
-(void)imageBtnClick:(UIButton*)button
{
    [ViewController photoBrowserWithImages:self.imgUrlArray photoIndex:button.tag];
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
