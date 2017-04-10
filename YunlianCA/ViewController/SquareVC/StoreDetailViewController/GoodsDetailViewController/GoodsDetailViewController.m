//
//  GoodsDetailViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/28.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "ShareView.h"
#import "OrderConfirmViewController.h"

@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIButton *_buyBtn;
    
    
}

@property(nonatomic,strong)UIButton *shoucangBtn;
@property(nonatomic,strong)UIView *circleView;
@property(nonatomic,strong)UILabel *currentLabel;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)StoreModel *goodsModel;
@property(nonatomic,strong)NSMutableArray *commentArray;
@property(nonatomic,assign)NSInteger goodsCount;
@property(nonatomic,strong)NSString *addressId;
@property(nonatomic,strong)NSString *totalPrice;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goodsCount=0;
    self.totalPrice=@"0";
    
    [self createNavigationBar];
    [self createBuyBtn];
    [self createTableView];
    
    
    
    //获取用户默认地址
    [HTTPManager getUserDefaultShippingAddressWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *addressDict=[resultDict objectForKey:@"receiptInfo"];
//            NSString *city=[addressDict objectForKey:@"city"];
//            NSString *address=[addressDict objectForKey:@"address"];
//            self.receiptAddress=[NSString stringWithFormat:@"%@%@",city,address];
            self.addressId=[addressDict objectForKey:@"id"];
        }
        else
        {
            [self.view makeToast:@"您还没有设置收货地址，请设置后购买" duration:2.0];
        }
    }];
    
    
    
    
}

//获取商品详情
-(void)getGoodsInfo
{
    [HTTPManager getGoodsDetailInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId goodsId:self.goodsId complete:^(StoreModel *model) {
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            self.goodsModel=model;
            
            if ([self.goodsModel.goodsIsCollect isEqualToString:@"0"])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_hei") forState:UIControlStateNormal];
            }
            if ([self.goodsModel.goodsIsCollect isEqualToString:@"1"])
            {
                [self.shoucangBtn setBackgroundImage:IMAGE(@"shoucang_huang") forState:UIControlStateNormal];
            }
            
            //数据请求成功之后创建购买view
            [self createBuyView];
            [_tableView reloadData];
        }
        
    }];
}

//获取商品评论
-(void)getGoodsCommentWithPxType:(NSString*)pxType
{
    [HTTPManager getCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId objectId:self.goodsId type:@"2" storeId:self.storeId pageNum:@"1" pageSize:@"100" pxType:pxType complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.commentArray=[[listDict objectForKey:@"data"] mutableCopy];
            [_tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getGoodsInfo];
    [self getGoodsCommentWithPxType:@"1"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
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


-(void)createBuyBtn
{
    _buyBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(50), SCREEN_WIDTH, WZ(50))];
    _buyBtn.backgroundColor=COLOR(254, 153, 160, 1);
    _buyBtn.titleLabel.font=FONT(17, 15);
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [_buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buyBtn];
}

//创建购买界面
-(void)createBuyView
{
    UIView *parentView = [[UIView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].windows[0];
    if (window.subviews.count > 0)
    {
        parentView = [window.subviews objectAtIndex:0];
    }
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-WZ(50))];
    bgView.backgroundColor=[COLOR_BLACK colorWithAlphaComponent:0.5];
    bgView.hidden=YES;
    [parentView addSubview:bgView];
    self.bgView=bgView;
    
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, bgView.bottom-WZ(140), bgView.width, WZ(140))];
    bottomView.backgroundColor=COLOR_WHITE;
    [bgView addSubview:bottomView];
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(80), WZ(60))];
    [bottomView addSubview:iconImageView];
    
    NSArray *imgUrlArray=[self.goodsModel.goodsImageUrl componentsSeparatedByString:@","];
    
//    NSLog(@"imgUrlArray===%@",imgUrlArray);
    
    if (imgUrlArray.count>0)
    {
        NSString *imgUrl=[imgUrlArray firstObject];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrl]] placeholderImage:IMAGE(@"morentupian")];
    }
    else
    {
        iconImageView.image=IMAGE(@"morentupian");
    }
    
    NSString *nameString=self.goodsModel.goodsName;
    CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(17,15) maxSize:CGSizeMake(WZ(225), WZ(25))];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(25))];
    nameLabel.text=nameString;
    nameLabel.font=FONT(17,15);
    nameLabel.textColor=COLOR_BLACK;
    [bottomView addSubview:nameLabel];
    
    NSString *priceString=[NSString stringWithFormat:@"¥ %@",self.goodsModel.priceZH];
    CGSize priceSize=[ViewController sizeWithString:priceString font:FONT(17,15) maxSize:CGSizeMake(WZ(225), WZ(25))];
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(10), priceSize.width, WZ(25))];
    priceLabel.text=priceString;
    priceLabel.font=FONT(17,15);
    priceLabel.textColor=COLOR_ORANGE;
    [bottomView addSubview:priceLabel];
    
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(bottomView.width-WZ(15)-WZ(20), iconImageView.top, WZ(20), WZ(20))];
    [closeBtn setBackgroundImage:IMAGE(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:closeBtn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+WZ(15), bgView.width, 1)];
    lineView.backgroundColor=COLOR(236, 236, 236, 1);
    [bottomView addSubview:lineView];
    
    UILabel *slLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.left, iconImageView.bottom+WZ(15), WZ(200), WZ(50))];
    slLabel.text=@"购买数量";
    [bottomView addSubview:slLabel];
    
    CGSize addSize=[ViewController sizeWithString:@"+" font:FONT(17,15) maxSize:CGSizeMake(WZ(50), WZ(20))];
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(bottomView.width-WZ(15)-addSize.width-WZ(10), slLabel.bottom-WZ(10+25), addSize.width+WZ(10), WZ(20))];
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    addBtn.titleLabel.font=FONT(17,15);
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addBtn];
//    addBtn.backgroundColor=COLOR_CYAN;
    
    CGSize countSize=[ViewController sizeWithString:[NSString stringWithFormat:@"%ld",self.goodsCount] font:FONT(15,13) maxSize:CGSizeMake(WZ(1500), WZ(20))];
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(addBtn.left-WZ(5)-countSize.width-WZ(10), addBtn.top, countSize.width+WZ(10), WZ(20))];
    countLabel.text=[NSString stringWithFormat:@"%ld",self.goodsCount];
    countLabel.font=FONT(15,13);
    countLabel.textAlignment=NSTextAlignmentCenter;
    [bottomView addSubview:countLabel];
    self.countLabel=countLabel;
    
    CGSize subtractSize=[ViewController sizeWithString:@"-" font:FONT(17,15) maxSize:CGSizeMake(WZ(50), WZ(20))];
    UIButton *subtractBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10+10)-addSize.width-countLabel.width-subtractSize.width, addBtn.top, subtractSize.width+WZ(10), WZ(20))];
    [subtractBtn setTitle:@"-" forState:UIControlStateNormal];
    [subtractBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    subtractBtn.titleLabel.font=FONT(17,15);
    [subtractBtn addTarget:self action:@selector(subtractBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:subtractBtn];
    
//    subtractBtn.backgroundColor=COLOR_CYAN;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3)
    {
        return self.commentArray.count;
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
        
        NSArray *imgUrlArray=[self.goodsModel.goodsImageUrl componentsSeparatedByString:@","];
        
        UIScrollView *iconScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(250))];
        iconScrollView.tag=1;
        iconScrollView.delegate=self;
        iconScrollView.pagingEnabled=YES;
        iconScrollView.contentSize=CGSizeMake(SCREEN_WIDTH*imgUrlArray.count, WZ(250));
        iconScrollView.showsHorizontalScrollIndicator=NO;
        iconScrollView.showsVerticalScrollIndicator=NO;
        [cell.contentView addSubview:iconScrollView];
        
        if (imgUrlArray.count>0)
        {
            for (NSInteger i=0; i<imgUrlArray.count; i++)
            {
                NSString *img=imgUrlArray[i];
                
                UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, WZ(250))];
                [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentupian")];
                [iconScrollView addSubview:iconIV];
            }
        }
        
        UIView *circleView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(10)-WZ(40), iconScrollView.bottom-WZ(10)-WZ(40), WZ(40), WZ(40))];
        circleView.backgroundColor=[COLOR_BLACK colorWithAlphaComponent:0.5];
        circleView.clipsToBounds=YES;
        circleView.layer.cornerRadius=circleView.width/2.0;
        [cell.contentView addSubview:circleView];
        self.circleView=circleView;
        
        CGSize xieSize=[ViewController sizeWithString:@"/" font:FONT(15,13) maxSize:CGSizeMake(WZ(20), WZ(20))];
        
        CGFloat labelWidth=(circleView.width-xieSize.width)/2.0;
        CGFloat topMargin=WZ(10);
        CGFloat labelHeight=circleView.height-topMargin*2;
        
        UILabel *currentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topMargin, labelWidth, labelHeight)];
        
        currentLabel.textColor=COLOR_WHITE;
        currentLabel.textAlignment=NSTextAlignmentRight;
        currentLabel.font=FONT(15,13);
        [circleView addSubview:currentLabel];
        self.currentLabel=currentLabel;
        if (imgUrlArray.count<=0)
        {
            currentLabel.text=@"0";
        }
        else
        {
            currentLabel.text=@"1";
        }
        
        UILabel *xieLabel=[[UILabel alloc]initWithFrame:CGRectMake(currentLabel.right, topMargin, xieSize.width, labelHeight)];
        xieLabel.text=@"/";
        xieLabel.textColor=COLOR_WHITE;
        xieLabel.textAlignment=NSTextAlignmentCenter;
        xieLabel.font=FONT(15,13);
        [circleView addSubview:xieLabel];
        
        UILabel *totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(xieLabel.right, topMargin, labelWidth, labelHeight)];
        totalLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)imgUrlArray.count];
        totalLabel.textColor=COLOR_WHITE;
        totalLabel.textAlignment=NSTextAlignmentLeft;
        totalLabel.font=FONT(15,13);
        [circleView addSubview:totalLabel];
        self.totalLabel=totalLabel;
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), iconScrollView.bottom+WZ(10), WZ(200), WZ(30))];
        nameLabel.text=self.goodsModel.goodsName;
        nameLabel.font=FONT(17, 15);
        [cell.contentView addSubview:nameLabel];
        
        CGSize xlSize=[ViewController sizeWithString:[NSString stringWithFormat:@"销量 %@",self.goodsModel.sales] font:FONT(13,11) maxSize:CGSizeMake(WZ(150), WZ(20))];
        UILabel *xlLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-xlSize.width, iconScrollView.bottom+WZ(15), xlSize.width, WZ(20))];
        xlLabel.text=[NSString stringWithFormat:@"销量 %@",self.goodsModel.sales];
        xlLabel.font=FONT(13,11);
        xlLabel.textColor=COLOR_LIGHTGRAY;
        [cell.contentView addSubview:xlLabel];
        
        NSString *zhjString=[NSString stringWithFormat:@"￥ %@",self.goodsModel.priceZH];
        CGSize xjSize=[ViewController sizeWithString:zhjString font:FONT(19,17) maxSize:CGSizeMake(WZ(100), WZ(25))];
        UILabel *xjLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), nameLabel.bottom+WZ(5), xjSize.width, WZ(25))];
        xjLabel.text=zhjString;
        xjLabel.textColor=COLOR_ORANGE;
        xjLabel.font=FONT(19,17);
        [cell.contentView addSubview:xjLabel];
//        xjLabel.backgroundColor=COLOR_CYAN;
        
        NSString *yjString=[NSString stringWithFormat:@"￥ %@",self.goodsModel.price];
        CGSize yjSize=[ViewController sizeWithString:yjString font:FONT(15,13) maxSize:CGSizeMake(WZ(100), WZ(20))];
        UILabel *yjLabel=[[UILabel alloc]initWithFrame:CGRectMake(xjLabel.right+WZ(20), xjLabel.bottom-WZ(20), yjSize.width, WZ(20))];
        yjLabel.text=yjString;
        yjLabel.textColor=COLOR_LIGHTGRAY;
        yjLabel.font=FONT(15,13);
        [cell.contentView addSubview:yjLabel];
//        yjLabel.backgroundColor=COLOR_CYAN;
        
        UIView *deleteView=[[UIView alloc]initWithFrame:CGRectMake(yjLabel.left, yjLabel.top+yjLabel.height/2.0, yjLabel.width, 1)];
        deleteView.backgroundColor=COLOR_LIGHTGRAY;
        [cell.contentView addSubview:deleteView];
        
        
        
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
        
        UILabel *jsLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(40))];
        jsLabel.text=@"商品介绍";
        jsLabel.textColor=COLOR_LIGHTGRAY;
        jsLabel.font=FONT(17, 15);
        [cell.contentView addSubview:jsLabel];
//        jsLabel.backgroundColor=COLOR_CYAN;
        
        NSString *jieshaoString=self.goodsModel.goodsExplains;
        CGSize jieshaoSize=[ViewController sizeWithString:jieshaoString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(1000))];
        
        UILabel *jieshaoLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), jsLabel.bottom, jieshaoSize.width, jieshaoSize.height)];
        jieshaoLabel.text=jieshaoString;
        jieshaoLabel.font=FONT(15,13);
        jieshaoLabel.numberOfLines=0;
        [cell.contentView addSubview:jieshaoLabel];
        
        
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
        
        UILabel *xxLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(40))];
        xxLabel.text=@"商家信息";
        xxLabel.textColor=COLOR_LIGHTGRAY;
        xxLabel.font=FONT(17, 15);
        [cell.contentView addSubview:xxLabel];
//        xxLabel.backgroundColor=COLOR_CYAN;
        
        NSString *iconUrl=self.goodsModel.headImg;
        UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), xxLabel.bottom+WZ(10), WZ(40), WZ(40))];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,iconUrl]] placeholderImage:IMAGE(@"morentupian")];
        [cell.contentView addSubview:iconImageView];
        
        NSString *nameString=self.goodsModel.storeName;
        CGSize nameSize=[ViewController sizeWithString:nameString font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(20))];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(20))];
        nameLabel.text=nameString;
        nameLabel.font=FONT(15,13);
        nameLabel.textColor=COLOR(146, 135, 187, 1);
        //    nameLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:nameLabel];
        
        NSString *shopHoursString=[NSString stringWithFormat:@"营业时间：%@",self.goodsModel.opentime];
        CGSize shopHoursSize=[ViewController sizeWithString:shopHoursString font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(20))];
        
        UILabel *shopHoursLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom, shopHoursSize.width, WZ(20))];
        shopHoursLabel.text=shopHoursString;
        shopHoursLabel.font=FONT(12,10);
        shopHoursLabel.textColor=COLOR_LIGHTGRAY;
        //    shopHoursLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:shopHoursLabel];
        
//        NSString *callNumString=[NSString stringWithFormat:@"拨打%@次",self.goodsModel.callNum];
//        CGSize callNumSize=[ViewController sizeWithString:callNumString font:FONT(11,9) maxSize:CGSizeMake(WZ(100),WZ(20))];
//        
//        UILabel *callLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(12)-callNumSize.width, xxLabel.bottom+WZ(35), callNumSize.width, WZ(20))];
//        callLabel.textAlignment=NSTextAlignmentCenter;
//        callLabel.text=callNumString;
//        callLabel.textColor=COLOR(166, 213, 157, 1);
//        callLabel.font=FONT(11,9);
//        [cell.contentView addSubview:callLabel];
//        
//        UIButton *callBtn=[[UIButton alloc]init];
//        callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, callLabel.center.y-WZ(40));
//        callBtn.size=CGSizeMake(WZ(30), WZ(30));
//        //    callBtn.backgroundColor=COLOR(166, 213, 157, 1);
//        [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
//        callBtn.layer.cornerRadius=callBtn.width/2.0;
//        callBtn.clipsToBounds=YES;
//        [cell.contentView addSubview:callBtn];
        
        
        NSString *signString=self.goodsModel.storeExplains;
        CGSize signSize=[ViewController sizeWithString:signString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
        
        UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), iconImageView.bottom+WZ(15), signSize.width, signSize.height)];
        signLabel.text=signString;
        signLabel.font=FONT(15,13);
        signLabel.numberOfLines=0;
        //    signLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:signLabel];
        
        
        
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
        
        NSDictionary *commentDict=self.commentArray[indexPath.row];
        NSString *content=[[commentDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *createtime=[commentDict objectForKey:@"createtime"];
        NSString *headImg=[commentDict objectForKey:@"headImg"];
        NSString *isLike=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"isLike"]];
        NSString *praisecount=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"praisecount"]];
        NSString *userName=[commentDict objectForKey:@"userName"];
        NSString *ofUserName=[commentDict objectForKey:@"ofUserName"];
        NSInteger star=[[commentDict objectForKey:@"star"] integerValue];
        
        UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
        [cell.contentView addSubview:headView];
        
        NSString *imgUrlString=headImg;
        NSURL *imgUrl;
        if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
        {
            imgUrl=[NSURL URLWithString:imgUrlString];
        }
        else
        {
            imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]];
        }
        [headView.headImageBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        headView.nameLabel.text=userName;
        
        CGSize dateSize=[ViewController sizeWithString:createtime font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(22))];
        headView.addFriendBtn.titleLabel.font=FONT(13,11);
        [headView.addFriendBtn setTitle:createtime forState:UIControlStateNormal];
        [headView.addFriendBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        [headView.addFriendBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        headView.addFriendBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-dateSize.width, WZ(25), dateSize.width, WZ(22));
        
        for (NSInteger i=0; i<5; i++)
        {
            UIImageView *starIV=[[UIImageView alloc]initWithFrame:CGRectMake(headView.nameLabel.left+(WZ(15)+WZ(3))*(i%5), headView.nameLabel.bottom, WZ(15), WZ(15))];
            [cell.contentView addSubview:starIV];
            
            if (i<star)
            {
                starIV.image=IMAGE(@"wode_dingdanpingjia_huang");
            }
            else
            {
                starIV.image=IMAGE(@"wode_dingdanpingjia_hui");
            }
        }
        
//        NSString *contentString;
//        if (ofUserName==nil || [ofUserName isEqualToString:@""])
//        {
//            contentString=content;
//        }
//        else
//        {
//            contentString=[NSString stringWithFormat:@"回复 %@：%@",ofUserName,content];
//        }
        
        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.headImageBtn.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
        contentLabel.text=content;
        contentLabel.font=FONT(15,13);
        contentLabel.numberOfLines=0;
        [cell.contentView addSubview:contentLabel];
        
        ArticleBottomView *bottomView=[[ArticleBottomView alloc]initWithFrame:CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(45))];
        //        bottomView.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:bottomView];
        
        bottomView.pageViewIV.frame=CGRectMake(0, 0, 0, 0);
        CGSize praiseSize=[ViewController sizeWithString:praisecount font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(18))];
        bottomView.praiseLabel.frame=CGRectMake(SCREEN_WIDTH-WZ(15)-praiseSize.width, WZ(15), praiseSize.width, WZ(18));
        bottomView.praiseBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(15+18+5)-praiseSize.width, WZ(15), WZ(18), WZ(18));
        bottomView.praiseLabel.text=praisecount;
        bottomView.praiseLabel.tag=indexPath.row;
        bottomView.praiseLabel.font=FONT(15, 13);
        bottomView.commentLabel.frame=CGRectMake(0, 0, 0, 0);
        bottomView.commentIV.frame=CGRectMake(0, 0, 0, 0);
        
        bottomView.praiseBtn.tag=indexPath.row;
        [bottomView.praiseBtn addTarget:self action:@selector(commentPraiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([isLike isEqualToString:@"0"])
        {
            [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hui") forState:UIControlStateNormal];
        }
        if ([isLike isEqualToString:@"1"])
        {
            [bottomView.praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
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
    if (section==0)
    {
        return nil;
    }
    if (section==3)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(50))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), titleView.width, titleView.height-WZ(10))];
        aView.backgroundColor=COLOR_WHITE;
        [titleView addSubview:aView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), aView.height)];
        label.text=@"评价";
        label.font=FONT(17, 15);
        [aView addSubview:label];
        
        return titleView;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(250+75);
    }
    if (indexPath.section==1)
    {
        NSString *jieshaoString=self.goodsModel.goodsExplains;
        CGSize jieshaoSize=[ViewController sizeWithString:jieshaoString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(1000))];
        
        return WZ(40)+jieshaoSize.height+WZ(10);
    }
    if (indexPath.section==2)
    {
        NSString *signString=self.goodsModel.storeExplains;
        CGSize signSize=[ViewController sizeWithString:signString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
        
        return WZ(40+10+40+15)+signSize.height+WZ(10);
    }
    else
    {
        NSDictionary *commentDict=self.commentArray[indexPath.row];
        NSString *content=[[commentDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
        UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
        
        return contentLabel.bottom+WZ(45);
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    if (section==3)
    {
        return WZ(50);
    }
    else
    {
        return WZ(10);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==1)
    {
        NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
        self.currentLabel.text=[NSString stringWithFormat:@"%ld",(long)index+1];
        
        //开始动画
        [UIView beginAnimations:@"doflip" context:nil];
        //设置时长
        [UIView setAnimationDuration:0.5];
        //设置动画淡入淡出
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //设置代理
        [UIView setAnimationDelegate:self];
        //设置翻转方向
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight  forView:self.circleView cache:YES];
        //动画结束
        [UIView commitAnimations];
    }
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//收藏
-(void)shoucangBtnClick
{
    [HTTPManager addUserCollectionWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" objectid:self.goodsId  complete:^(NSDictionary *resultDict) {
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
    NSArray *imgArray=[self.goodsModel.goodsImageUrl componentsSeparatedByString:@","];
    NSURL *imageUrl;
    if (imgArray.count>0)
    {
        imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[imgArray firstObject]]];
    }
    else
    {
        imageUrl=[NSURL URLWithString:@""];
    }
     [ShareView sharedInstance].isShowAdjacent = NO;
    [[ShareView sharedInstance] shareWithImageUrlArray:@[imageUrl] title:self.goodsModel.goodsName content:self.goodsModel.goodsExplains url:[NSString stringWithFormat:@"%@share/proInfo.api?id=%@&userId=%@",HOST,self.goodsId,[UserInfoData getUserInfoFromArchive].userId]];
    
}

//评论点赞
-(void)commentPraiseBtnClick:(UIButton*)button
{
    NSDictionary *commentDict=self.commentArray[button.tag];
    NSString *commentId=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"id"]];
    
    [HTTPManager addPraiseWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" objectId:commentId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [button setBackgroundImage:IMAGE(@"dianzanrenshu_hong") forState:UIControlStateNormal];
            
            [self getGoodsCommentWithPxType:@"1"];
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view makeToast:msg duration:1.0];
        }
    }];
}




//购买
-(void)buyBtnClick
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        if (self.bgView.hidden==YES)
        {
            [_buyBtn setTitle:@"马上下单" forState:UIControlStateNormal];
            self.bgView.hidden=!self.bgView.hidden;
        }
        else
        {
            if ([self.countLabel.text integerValue]<=0)
            {
                [self.view.window makeToast:@"商品数量至少为1" duration:2.0];
            }
            else
            {
                [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
                self.bgView.hidden=!self.bgView.hidden;
                
                NSMutableArray *goodsListArray=[NSMutableArray array];
                NSString *goodsId=self.goodsModel.goodsId;
                NSString *goodsCount=[NSString stringWithFormat:@"%ld",self.goodsCount];
                NSString *priceZH=self.goodsModel.priceZH;
                NSString *goodsImg=self.goodsModel.goodsIcon;
                NSString *goodsName=self.goodsModel.goodsName;
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:goodsId,@"itemId",goodsCount,@"count",priceZH,@"amount", nil];
                [goodsListArray addObject:dict];
                
                NSMutableArray *goodsInfoArray=[NSMutableArray array];
                NSMutableDictionary *goodsDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:goodsName,@"name",goodsCount,@"count",priceZH,@"amount",goodsImg,@"img", nil];
                [goodsInfoArray addObject:goodsDict];
                
                NSMutableDictionary *orderDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.storeId,@"storeId",self.goodsModel.userId,@"sellerid",[UserInfoData getUserInfoFromArchive].userId,@"buyerid",self.totalPrice,@"money",self.totalPrice,@"sfMoney",@"",@"explains",self.addressId,@"receiptId",@"",@"couponId",goodsListArray,@"list", nil];
                
                //跳转到订单确认界面
                OrderConfirmViewController *vc=[[OrderConfirmViewController alloc]init];
                vc.merchantId=self.merchantId;
                vc.orderDict=orderDict;
                vc.goodsInfoArray=goodsInfoArray;
                vc.isGoodsDetailVC=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
    
}

//加
-(void)addBtnClick
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        NSInteger count=[self.countLabel.text integerValue];
        count=count+1;
        self.countLabel.text=[NSString stringWithFormat:@"%ld",(long)count];
        self.goodsCount=count;
        self.totalPrice=[NSString stringWithFormat:@"%.2f",count*[self.goodsModel.priceZH floatValue]];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}

//减
-(void)subtractBtnClick
{
    BOOL ifArea=[ViewController ifRegisterArea];
    if (ifArea==YES)
    {
        if ([self.countLabel.text integerValue]<=0)
        {
            self.countLabel.text=@"0";
            self.goodsCount=0;
            self.totalPrice=@"0";
        }
        if ([self.countLabel.text integerValue]>0)
        {
            NSInteger count=[self.countLabel.text integerValue];
            count=count-1;
            self.countLabel.text=[NSString stringWithFormat:@"%ld",(long)count];
            self.goodsCount=count;
            self.totalPrice=[NSString stringWithFormat:@"%.2f",count*[self.goodsModel.priceZH floatValue]];
        }
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
    
}

//关闭购买界面
-(void)closeBtnClick
{
    [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    self.bgView.hidden=YES;
    
    
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
