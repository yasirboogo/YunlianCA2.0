//
//  RedEnvelopeOpenViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/12/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RedEnvelopeOpenViewController.h"
#import "AdViewController.h"
#import "RedEnvelopeRecordsViewController.h"
#import "JCAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import "EditNewArticleViewController.h"
#import "RedEnvelopeSendViewController.h"
#import "ShareView.h"
#import "TapImageView.h"
#import <SVProgressHUD.h>
#import "StoreDetailViewController.h"
#import "MyCouponViewController.h"
@interface RedEnvelopeOpenViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIWebViewDelegate,TapImageViewDelegate>
{
    UIScrollView *_scrollView;
    UITableView *_tableView;
    NSMutableDictionary * _reqCommentDic;
    NSInteger _totalPages;
    UIWebView * _webView;
    UIView *_bottomView;
    JCAlertView * _alertView;
    UIView * _topView;
    UIView * _topBackView;
    UIImageView * _playerView;
    UIButton * _secondEnBtn;
    UILabel * _secondEnLabel;
    NSTimer * _timer;
}

//@property(nonatomic,strong)NSString *imgUrlString;
@property(nonatomic,strong)NSString *perName;
@property(nonatomic,strong)NSString *theme;
@property(nonatomic,strong)NSString *remark;
@property(nonatomic,strong)NSString *totalMoney;
@property(nonatomic,strong)NSString *adType;
@property(nonatomic,strong)NSString *ylNum;
@property(nonatomic,strong)NSString *myMoney;
@property(nonatomic,strong)NSString *num;
@property(nonatomic,strong)NSString *isGet;
@property(nonatomic,assign)BOOL isAdmin;
@property(nonatomic,strong)NSMutableArray* bigCommentArray;
@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)UITextView *commentTV;
@property(nonatomic,strong)NSString *commentString;
@property(nonatomic,strong)NSString *parentId;
@property(nonatomic,strong)NSString *clickUrl;
@property(nonatomic,assign)BOOL isGetCoupon;
//@property(nonatomic,strong)NSString *storeId;
@property(nonatomic,strong)NSString *merId;
@property(nonatomic,assign)BOOL hasTwice;
@property(nonatomic,strong)NSString *twiceMoney;
@property(nonatomic,assign)NSInteger dsTime;
@property(nonatomic,strong)UIView * bgView;

@end

@implementation RedEnvelopeOpenViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
    
    self.view.backgroundColor=COLOR_HEADVIEW;
    
    _isAdmin=[[self.redDict objectForKey:@"isAdmin"] boolValue];//1、后台 0、用户
    NSLog(@"传来的红包数据===%@",self.redDict);
    _bigCommentArray = [NSMutableArray array];
    _reqCommentDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5",@"pageSize",@"1",@"pageNum", nil];
    self.parentId = @"";
    if (_isAdmin)
    {
        
        //请求后台红包详情
        [self getBackstageRedEnvelopeDetail];
    }
    if (!_isAdmin)
    {
        if (!_scrollView)
        {
            [self createTopView];
        }
    }
    if (_isAdmin) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        

    }
    
    
}

-(void)creatNavView{
    UIImageView *backIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), 20+WZ(5), WZ(14), WZ(25))];
    backIV.image=IMAGE(@"fanhui_bai");
    backIV.userInteractionEnabled = YES;
    [self.view addSubview:backIV];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(5), backIV.top, WZ(60), backIV.height)];
    //backBtn.backgroundColor=COLOR_CYAN;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(backBtn.right+WZ(70)/2.0, backIV.top, SCREEN_WIDTH-WZ(70)*3-WZ(5)*2, backIV.height)];
    titleLabel.text=@"红包详情";
    titleLabel.textColor=COLOR_WHITE;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(19, 17);
    [self.view addSubview:titleLabel];
    if (_isAdmin) {
        UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+WZ(10), backIV.top, WZ(50), backIV.height)];
        [shareBtn addTarget:self action:@selector(redEvelopeShareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setImage:[UIImage imageNamed:@"fenxiang1"] forState:UIControlStateNormal];
        //shareBtn.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:shareBtn];
        UIButton * commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shareBtn.frame), backIV.top, WZ(50), backIV.height)];
        [commentBtn addTarget:self action:@selector(redEvelopeCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn setImage:[UIImage imageNamed:@"huifu"] forState:UIControlStateNormal];
        //commentBtn.backgroundColor = [UICo.lor blueColor];
        [self.view addSubview:commentBtn];
    }
}
//创建二次红包领取button
-(void)creatSecondEnvelope{
    if (self.hasTwice) {
        if (!_secondEnBtn) {
            _secondEnBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-WZ(67)-WZ(70)-WZ(100), WZ(67), WZ(67))];
        }
        [_secondEnBtn addTarget:self action:@selector(secondEnBtnGetClicked) forControlEvents:UIControlEventTouchUpInside];
        [_secondEnBtn setImage:IMAGE(@"yuanxing") forState:UIControlStateNormal];
        _secondEnBtn.userInteractionEnabled = NO;
        if (!_secondEnLabel) {
            _secondEnLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, _secondEnBtn.height-WZ(15)/1.1, _secondEnBtn.width-24, WZ(15))];
            _secondEnLabel.textAlignment = NSTextAlignmentCenter;
            _secondEnLabel.font = FONT(12, 10);
            _secondEnLabel.textColor = [UIColor whiteColor];
            _secondEnLabel.backgroundColor = COLOR(183, 42, 41, 1);
            _secondEnLabel.clipsToBounds = YES;
            _secondEnLabel.layer.cornerRadius = 2.0f;
            _secondEnLabel.adjustsFontSizeToFitWidth = YES;
            [_secondEnBtn addSubview:_secondEnLabel];
            [self.view addSubview:_secondEnBtn];
        }
        if ([self.twiceMoney length]>0) {
    
            _secondEnLabel.text =[NSString stringWithFormat:@"%ld秒",(long)self.dsTime] ;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(redEnvelopeTimerChange) userInfo:nil repeats:YES];
            _secondEnBtn.hidden = NO;
        }else{
            _secondEnBtn.hidden = YES;
        }
    }else{
       _secondEnBtn.hidden = YES;
    }
    
    
}
-(void)redEnvelopeTimerChange{
     self.dsTime--;
    if (self.dsTime<=0) {
        _secondEnBtn.userInteractionEnabled = YES;
        _secondEnLabel.text = @"点击领取红包";
        [_timer invalidate];
        
    }else{
       
        _secondEnLabel.text =[NSString stringWithFormat:@"%ld秒",(long)self.dsTime] ;
    }
    
}
#pragma mark -  打开红包
-(void)openBtnClick{
    NSString *redId=[NSString stringWithFormat:@"%@",[self.redDict objectForKey:@"id"]];
    NSMutableDictionary * reqDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfoData getUserInfoFromArchive].userId,@"userId",redId,@"hbId", nil];
    [HTTPManager getRedEnvelopeListWithReqDic:reqDic WithUrl:@"v2/openTwice.api" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
         UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [window makeToast:@"领取红包成功" duration:2.0];
            self.twiceMoney = resultDict[@"twiceMoney"]==nil?@"":[NSString stringWithFormat:@"%@",resultDict[@"twiceMoney"] ];
            self.hasTwice = NO;
            _secondEnBtn.hidden = YES;
            [self creatTableHeadView];
            [self closeHongbaoBtnClick];
        }else{
           
            NSString * error =resultDict[@"result"]==nil?@"请重试":resultDict[@"result"];
            [window makeToast:error duration:2.0];
        }
    }];
}
//关闭红包
-(void)closeHongbaoBtnClick{
    if (self.bgView)
    {
        [self.bgView removeFromSuperview];
    }
}

//分享
-(void)redEvelopeShareButtonClicked:(UIButton *)button{
    [ShareView sharedInstance].isShowAdjacent = YES;
    
    [[ShareView sharedInstance] showView];
    __weak RedEnvelopeOpenViewController * weakSelf = self;
    [ShareView sharedInstance].block = ^(UIButton * button){
        [weakSelf shareSelectWithButton:button];
    };
}
//选择分享方式
-(void)shareSelectWithButton:(UIButton *)button{
    if (_webView) {
        [self getPlayImage];
    }
    
    UIImage * shareImage =[self captureScreen];
    
    if (button.tag==6) {
        [[ShareView sharedInstance] dismissView];
        EditNewArticleViewController * vc = [[EditNewArticleViewController alloc]init];
        vc.shareImage =shareImage;
        vc.lanmuCount = 100000;
        [ShareView sharedInstance].isSelectBtn = NO;
        [self.navigationController pushViewController:vc animated:YES];
       
    }else{
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        [HTTPManager shareRedEnvelopeImage:shareImage userId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
            [SVProgressHUD dismiss];
            
           
            NSString * shareHbUrl = resultDict[@"shareHbUrl"];
            if ([shareHbUrl containsString:@"app/"]) {
                NSRange range = [shareHbUrl rangeOfString:@"app/"];
                shareHbUrl = [shareHbUrl stringByReplacingCharactersInRange:range withString:@""];
            }
            [[ShareView sharedInstance] shareWithImageUrlArray:@[shareImage] title:self.theme content:[NSString stringWithFormat:@"系统红包共%.2f元,已领取%@/%@个",[self.totalMoney floatValue],self.ylNum,self.num] url:shareHbUrl];
            [ShareView sharedInstance].isSelectBtn = NO;
            
        }];
        
    }
     _playerView.hidden = YES;
}
-(UIImage *)snapShotScreenAndSave
{
    CGRect screenFrame = [UIApplication sharedApplication].keyWindow.frame;
    UIGraphicsBeginImageContextWithOptions(screenFrame.size, NO, 0);
   
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        [window drawViewHierarchyInRect:screenFrame afterScreenUpdates:NO];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //保存图片
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    return image;
}
- (UIImage *) captureScreen {
    
    CGSize rect = _tableView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(rect, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_tableView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(void)getBackstageRedEnvelopeDetail
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    NSString *redId=[NSString stringWithFormat:@"%@",[self.redDict objectForKey:@"id"]];
    [HTTPManager getBackstageRedEnvelopeDetailWithUserId:[UserInfoData getUserInfoFromArchive].userId redId:redId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *detailDict=[resultDict objectForKey:@"Onetomanypacket"];
            self.perName=[detailDict objectForKey:@"perName"];
            self.theme=[[detailDict objectForKey:@"theme"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            self.ylNum=[detailDict objectForKey:@"ylNum"];
            self.totalMoney=[detailDict objectForKey:@"totalMoney"];
            self.num=[detailDict objectForKey:@"num"];
            self.isGetCoupon = [[detailDict objectForKey:@"isGetCoupon"] boolValue];
            self.adType=[NSString stringWithFormat:@"%@",[detailDict objectForKey:@"adType"]];
            self.merId=[NSString stringWithFormat:@"%@",[detailDict objectForKey:@"merId"]==nil?@"":[detailDict objectForKey:@"merId"]];
            self.remark=[NSString stringWithFormat:@"%@",[detailDict objectForKey:@"remark"]];
            self.clickUrl=[NSString stringWithFormat:@"%@",[detailDict objectForKey:@"clickUrl"]];

            self.hasTwice=[[detailDict objectForKey:@"hasTwice"] boolValue];
            self.twiceMoney=[NSString stringWithFormat:@"%@",[detailDict objectForKey:@"twiceMoney"]==nil?@"":[detailDict objectForKey:@"twiceMoney"]];
            
            self.dsTime=[[detailDict objectForKey:@"dsTime"]==nil?@"0":[detailDict objectForKey:@"dsTime"] integerValue];
            
            NSDictionary *userDict=[resultDict objectForKey:@"OnetomanypacketList"];
            NSString *totalItems=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"totalItems"]];
            self.isGet=totalItems;
            
            NSDictionary *myDict=[resultDict objectForKey:@"myPacket"];
            self.myMoney=[NSString stringWithFormat:@"%@",[myDict objectForKey:@"money"]];
            
             [self creatSystomView];
            [self creatSecondEnvelope];

           
            
        }else{
            [self creatNavView];
        }
        [hud hide:YES];
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.extendedLayoutIncludesOpaqueBars = NO; self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
//    //去掉导航条下边的shadowImage，就可以正常显示了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationController.navigationBar.translucent = NO;
    [self refreshData];
     [self createBottomCommentView];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [_webView stopLoading];
    [_webView reload];
    _webView=nil;
    [_commentTV resignFirstResponder];
    _bottomView = nil;
    
}
-(void)creatSystomView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-WZ(70))];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell2"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
        
        [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
        [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
        [self.view addSubview:_tableView];
        
        UIButton *checkBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), SCREEN_HEIGHT-WZ(70)+(WZ(70)-WZ(50))/2.0, SCREEN_WIDTH-WZ(20*2), WZ(50))];
        checkBtn.backgroundColor=COLOR(255, 40, 59, 1);
        checkBtn.clipsToBounds=YES;
        checkBtn.layer.cornerRadius=5;
        [checkBtn setTitle:@"查看我的外快（红包）吧" forState:UIControlStateNormal];
        [checkBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        checkBtn.titleLabel.font=FONT(16, 14);
        [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkBtn];
       
    }
    _tableView.tableHeaderView = nil;
     [self creatTableHeadView];
}
-(void)creatTableHeadView{
    UIView * headView = [[UIView alloc]init];
    NSString *imgUrlString=[self.redDict objectForKey:@"userImg"];//发红包人头像
    NSString *nickname=[self.redDict objectForKey:@"nickName"];//发红包人昵称
    NSInteger status=[[self.redDict objectForKey:@"status"] integerValue];//领取状态
    if (!_topView) {
        _topView=[[UIView alloc]init];
    }
    [_topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _topView.backgroundColor=COLOR_WHITE;
    [headView addSubview:_topView];
    UIImageView *topIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(120))];
    topIV.image=IMAGE(@"hongbao_detailtopbg");
    topIV.userInteractionEnabled = YES;
    [_topView addSubview:topIV];

    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
    }
    UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(50))/2.0, topIV.bottom-WZ(50/2.0), WZ(50), WZ(50))];
    headBtn.layer.cornerRadius=headBtn.width/2.0;
    headBtn.clipsToBounds=YES;
    [_topView addSubview:headBtn];
    [headBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
   
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(30), headBtn.bottom+WZ(5), SCREEN_WIDTH-WZ(30*2), WZ(25))];
    nameLabel.text=[NSString stringWithFormat:@"%@的红包",nickname];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(16, 14);
    [_topView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(20), nameLabel.width, WZ(40))];
        moneyLabel.textAlignment=NSTextAlignmentCenter;
        moneyLabel.font=FONT(25, 23);
        //        moneyLabel.backgroundColor=COLOR_CYAN;
    [_topView addSubview:moneyLabel];
        
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, moneyLabel.bottom, nameLabel.width, WZ(20))];
        subLabel.text=[NSString stringWithFormat:@"系统红包共%.2f元,已领取%@/%@个",[self.totalMoney floatValue],self.ylNum,self.num];
    subLabel.textAlignment=NSTextAlignmentCenter;
    subLabel.font=FONT(14, 12);
    subLabel.numberOfLines=2;
    [_topView addSubview:subLabel];
    CGFloat maxY =subLabel.bottom+WZ(20);
    if (!self.hasTwice&&[self.twiceMoney length]>0) {
        UILabel *twiceMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, subLabel.bottom, nameLabel.width, WZ(40))];
        twiceMoneyLabel.text = self.twiceMoney;
        twiceMoneyLabel.textAlignment=NSTextAlignmentCenter;
        twiceMoneyLabel.font=FONT(20, 18);
        [_topView addSubview:twiceMoneyLabel];
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, twiceMoneyLabel.bottom, nameLabel.width, WZ(20))];
        subLabel.text=@"二次红包";
        subLabel.textAlignment=NSTextAlignmentCenter;
        subLabel.font=FONT(14, 12);
        subLabel.numberOfLines=2;
        [_topView addSubview:subLabel];
       
        maxY =subLabel.bottom+WZ(20);
    }
    if ([self.adType isEqualToString:@"2"]){
       //优惠券
        UIImageView * imageView;
        if (self.isGetCoupon) {
            imageView = [self creatCouponsWithCount:self.remark withFrame:CGRectMake(WZ(70), maxY-WZ(20), SCREEN_WIDTH-WZ(70*2), (SCREEN_WIDTH-WZ(70*2))*449/591.0) WithIsShow:@"3"];
        }else{
            imageView = [self creatCouponsWithCount:self.remark withFrame:CGRectMake(WZ(70), maxY, SCREEN_WIDTH-WZ(70*2), (SCREEN_WIDTH-WZ(70*2))*449/591.0) WithIsShow:@"1"];
        }
         _topBackView = imageView;
        [_topView addSubview:imageView];
    
    }else if([self.adType isEqualToString:@"3"]){
        //图片
        
        TapImageView * imageBtn = [[TapImageView alloc]init];
         _topBackView = imageBtn;
        imageBtn.t_delegate = self;
        imageBtn.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *imgUrl;
        if ([self.remark containsString:@"http://"] || [self.remark containsString:@"https://"]){
            imgUrl=[NSURL URLWithString:self.remark];
        }else{
            imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,self.remark]];
        }
        UIImage * image=  [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imgUrl.absoluteString];
        if (!image) {
            NSData * imageData = [NSData dataWithContentsOfURL:imgUrl];
            image = [UIImage imageWithData:imageData];
            [[SDImageCache sharedImageCache] storeImage:image forKey:imgUrl.absoluteString];
        }
        
        
        if (!image) {
            image = IMAGE(@"morentupian");
        }
        CGFloat width =SCREEN_WIDTH-WZ(50)*2;
        CGFloat hight =width/image.size.width*image.size.height;
        imageBtn.frame =CGRectMake(WZ(50),maxY, SCREEN_WIDTH-WZ(50)*2, hight);
        imageBtn.image = image;
    
        [_topView addSubview:imageBtn];
    }else if([self.adType isEqualToString:@"4"]){
        //视频连接
        if (!_webView) {
             _webView = [[UIWebView alloc]init];
        }
        _webView.frame = CGRectMake(WZ(50)+WZ(20), maxY, SCREEN_WIDTH-WZ(50*2)-WZ(20)*2, WZ(150));
        _webView.scrollView.scrollEnabled = NO;
        NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.remark]];
        [_webView loadRequest:req];
        [_topView addSubview:_webView];
        
       UILabel * timeLabel= [self getPlayTime];
        [_webView addSubview:timeLabel];
        _topBackView = _webView;
    }else {
        //文字
        UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(WZ(50), maxY, SCREEN_WIDTH-WZ(50*2), WZ(190))];
        detailView.backgroundColor=COLOR(255, 243, 231, 1);
        detailView.clipsToBounds=YES;
        detailView.layer.cornerRadius=5;
        [_topView addSubview:detailView];
        _topBackView = detailView;
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), WZ(15), detailView.width-WZ(10*2), WZ(25))];
        titleLabel.text=self.theme;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=FONT(17,15);
        //        titleLabel.backgroundColor=COLOR_CYAN;
        [detailView addSubview:titleLabel];
        
        UILabel *detailLabel2=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+WZ(5), titleLabel.width, WZ(135))];
        detailLabel2.text=self.remark;
        detailLabel2.textColor=COLOR_BLACK;
        detailLabel2.textAlignment=NSTextAlignmentCenter;
        detailLabel2.font=FONT(15, 13);
        detailLabel2.numberOfLines=9;
        //        detailLabel.backgroundColor=COLOR_CYAN;
        [detailView addSubview:detailLabel2];
    }
        if (status==0 || status==1){
            moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[self.myMoney floatValue]];
        }
        if (status==2){
            moneyLabel.text=@"红包已过期";
        }
        if (status==3)
        {
            if ([self.myMoney floatValue]>0){
                moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[self.myMoney floatValue]];
            }else{
                moneyLabel.text=@"红包已被抢完";
            }
        }
     _topView.frame=CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_topBackView.frame)+20);
    if (self.isGetCoupon) {
         headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_topView.frame)+WZ(20));
    }else{
         headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_topView.frame));
    }
    
     _tableView.tableHeaderView = headView;
     [self creatNavView];
}
-(UILabel *)getPlayTime{
    NSString * timeStr = [self getVideoInfoWithSourcePath:self.remark];
    CGSize timeSize= [ViewController sizeWithString:timeStr font:FONT(14, 12) maxSize:_webView.size];
    if (timeSize.width>_webView.width) {
        timeSize.width = _webView.width;
    }
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_webView.width-(timeSize.width+10), _webView.height-WZ(25), timeSize.width+10, WZ(25))];
    timeLabel.font = FONT(14, 12);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.text =[self getVideoInfoWithSourcePath:self.remark];
    
    return timeLabel;
}
- ( NSString  *)getVideoInfoWithSourcePath:(NSString *)path{
    NSURL    *movieURL = [NSURL URLWithString:path];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:movieURL options:opts]; ;
    CMTime   time = [asset duration];
    NSInteger time1 = ceil(time.value/time.timescale);
    NSInteger minute = time1/60;
    NSInteger seconds = time1%60;
    
    NSString * timeStr = [NSString stringWithFormat:@"%.2ld:%ld  ",(long)minute,(long)seconds];
    
    return timeStr;
}
//截屏获取视频图片
-(void)getPlayImage{
    if (!_playerView) {
        _playerView = [[UIImageView alloc]initWithFrame:_webView.frame];
        UIImageView * playBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WZ(50), WZ(50))];
        playBtn.image = IMAGE(@"bofang");
        playBtn.center = CGPointMake(_playerView.width/2.0, _playerView.height/2.0);
        [_playerView addSubview:playBtn];
        UILabel * timeLabel= [self getPlayTime];
        [_playerView addSubview:timeLabel];
        _playerView.contentMode =UIViewContentModeScaleAspectFit;
        _playerView.backgroundColor = [UIColor blackColor];
         [_tableView addSubview:_playerView];
    }
    
    _playerView.hidden = NO;
    NSLog(@"getVideoCurrentTime==%f",[self getVideoCurrentTime]);
    _playerView.image = [self thumbnailImageForVideo:[NSURL URLWithString:self.remark] atTime:[self getVideoCurrentTime]*60];
    
    
}
- (double)getVideoCurrentTime
{
    __block double currentTime = 0;
    
    NSString * requestDurationString = @"document.documentElement.getElementsByTagName(\"video\")[0].currentTime.toFixed(1)";
    NSString * result = [_webView stringByEvaluatingJavaScriptFromString:requestDurationString];
    NSLog(@"+++ Web Video CurrentTime:%@",result);
    currentTime = [result doubleValue];
    return currentTime;
}
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
//广告图片btn
-(void)tappedWithObject:(id)sender{
    //点击跳转到下个界面
    
    AdViewController *vc=[[AdViewController alloc]init];
    vc.isURL=YES;
    vc.explain=self.clickUrl;
    vc.hidesBottomBarWhenPushed=YES;
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:vc animated:YES];
}

//创建优惠券
-(UIImageView * )creatCouponsWithCount:(NSString *)money withFrame:(CGRect )frame WithIsShow:(NSString *)type{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    
    
    UIImageView * sheepImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, imageView.height/2.0-WZ(33)/2.0, WZ(23)/2.0, WZ(33)/2.0)];
    sheepImageView.image  =IMAGE(@"renmingbi");
    [imageView addSubview:sheepImageView];
    
    UILabel * moneyLabel = [[UILabel alloc]init];
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    
    moneyLabel.textColor = [UIColor whiteColor];
    moneyLabel.font =FONT(82,80);
    moneyLabel.text = money;
    
    [imageView addSubview:moneyLabel];
    
    UILabel *couponsLabel = [[UILabel alloc]init];
    couponsLabel.adjustsFontSizeToFitWidth = YES;
    couponsLabel.textColor = [UIColor whiteColor];
    couponsLabel.font = FONT(27, 25);
    
    [imageView addSubview:couponsLabel];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.adjustsFontSizeToFitWidth = YES;
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.font = FONT(14, 12);
    [imageView addSubview:promptLabel];
   
    if ([type isEqualToString:@"1"]) {
        //未点击领取的优惠券
        imageView.image = IMAGE(@"youhuiquan_hong");
        sheepImageView.frame = CGRectMake(30, imageView.height/2.0-WZ(33)/2.0, WZ(23)/2.0, WZ(33)/2.0);
        CGSize contentSize=[ViewController sizeWithString:money font:FONT(82,80) maxSize:CGSizeMake(imageView.width, imageView.height/2.0)];
        if (contentSize.width>imageView.width/2.5) {
            contentSize.width = imageView.width/2.5;
        }
        moneyLabel.frame =CGRectMake(CGRectGetMaxX(sheepImageView.frame), CGRectGetMaxY(sheepImageView.frame)-contentSize.height*0.65, contentSize.width, contentSize.height*0.7);
        
        UIButton * receiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, imageView.height/2.0+10, imageView.width-20, imageView.height/2.0-20)];
        [receiveBtn addTarget:self action:@selector(receiveCouponsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        imageView.userInteractionEnabled = YES;
        [receiveBtn setImage:IMAGE(@"anniu") forState:UIControlStateNormal];
        [imageView addSubview:receiveBtn];
        couponsLabel.text = @"优惠券";
        promptLabel.text = @"点击马上领取";

    }else if ([type isEqualToString:@"2"]||[type isEqualToString:@"3"]){
         //2、弹出框优惠券 3、已领取优惠券
        if ([type isEqualToString:@"2"]) {
            imageView.image = IMAGE(@"youhuiquan_huang");
        }else{
            imageView.center = imageView.center;
            imageView.bounds = CGRectMake(0, 0, imageView.width, imageView.height*0.6);
            imageView.image = IMAGE(@"huise");
        }
        
        CGSize contentSize=[ViewController sizeWithString:money font:FONT(82,80) maxSize:CGSizeMake(imageView.width, imageView.height)];
        if (contentSize.width>imageView.width/2.0) {
            contentSize.width = imageView.width/2.0;
        }
        moneyLabel.frame =CGRectMake(30+WZ(23)/2.0, (imageView.height-contentSize.height*0.7)/2.0, contentSize.width, contentSize.height*0.7);
        
        sheepImageView.frame = CGRectMake(30, CGRectGetMaxY(moneyLabel.frame)-WZ(33)/1.5, WZ(23)/2.0, WZ(33)/2.0);
        
        couponsLabel.text = @"优惠券";
        promptLabel.text = @"已领取";
       
    }
    couponsLabel.frame =CGRectMake(CGRectGetMaxX(moneyLabel.frame)+5, CGRectGetMinY(moneyLabel.frame), imageView.width-CGRectGetMaxX(moneyLabel.frame)-20, moneyLabel.height*0.7);
    promptLabel.frame = CGRectMake(CGRectGetMaxX(moneyLabel.frame)+5, CGRectGetMaxY(couponsLabel.frame), imageView.width-CGRectGetMaxX(moneyLabel.frame)-20, moneyLabel.height*0.3);
    
    return imageView;
}
-(void)receiveCouponsBtnClicked:(UIButton *)button{
    
    [HTTPManager getCouponFromStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId couponId:self.clickUrl complete:^(NSDictionary *resultDict) {
        
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            button.userInteractionEnabled=NO;
            button.backgroundColor=COLOR_WHITE;
            [button setTitle:@"已领取" forState:UIControlStateNormal];
            [button setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
            [_topBackView removeFromSuperview];
            UIImageView * imageView = [self creatCouponsWithCount:self.remark withFrame:_topBackView.frame WithIsShow:@"3"];
            _topBackView = imageView;
            
            [_topView addSubview:imageView];
            [self getCouponsSuccess];
        }
        else
        {
            
            NSString * result = [resultDict objectForKey:@"result"];
            if ([result isEqualToString:@"已领取！"]) {
                [_topBackView removeFromSuperview];
                UIImageView * imageView = [self creatCouponsWithCount:self.remark withFrame:_topBackView.frame WithIsShow:@"3"];
                _topBackView = imageView;
                [_topView addSubview:imageView];
            }
            [self.view.window makeToast:[resultDict objectForKey:@"result"] duration:1.0];
        }
    }];

}
-(void)getCouponsSuccess{
    UIImageView * customView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WZ(267.5), WZ(289))];
    customView.image = IMAGE(@"hongdi");
    customView.userInteractionEnabled = YES;
    UIButton * shutDownBtn = [[UIButton alloc]initWithFrame:CGRectMake(customView.width-WZ(50), 0, WZ(50), WZ(50))];
    [shutDownBtn addTarget:self action:@selector(shutDownButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [shutDownBtn setImage:IMAGE(@"guanbi") forState:UIControlStateNormal];
    [customView addSubview:shutDownBtn];
    
    UIImageView * titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WZ(151), WZ(30))];
    titleImageView.image = IMAGE(@"gongxinin");
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    titleImageView.center = CGPointMake(customView.width/2.0, 5+WZ(46)/2.0);
    [customView addSubview:titleImageView];
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleImageView.frame)+10, customView.width, WZ(20))];
    detailLabel.font = FONT(16, 14);
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text =[NSString stringWithFormat:@"领取了%@元优惠券",self.remark];
    [customView addSubview:detailLabel];
    UIImageView *couponsImageView = [self creatCouponsWithCount:self.remark withFrame:CGRectMake(WZ(20), CGRectGetMaxY(detailLabel.frame)+20, customView.width-WZ(20)*2, (customView.width-WZ(20)*2)*193/415.0) WithIsShow:@"2"];
    [customView addSubview:couponsImageView];
    
    UIButton * userCBtn = [[UIButton alloc]initWithFrame:CGRectMake(WZ(40),CGRectGetMaxY(couponsImageView.frame)/2.0+(customView.height-WZ(40))/2.0, customView.width-WZ(80), WZ(40))];
    [userCBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [userCBtn setTitle:@"去使用>>" forState:UIControlStateNormal];
    userCBtn.backgroundColor = [UIColor whiteColor];
    userCBtn.clipsToBounds = YES;
    userCBtn.layer.cornerRadius = WZ(40)/2.0;
    [userCBtn addTarget:self action:@selector(userCBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:userCBtn];
    
    _alertView = [[JCAlertView alloc] initWithCustomView:customView dismissWhenTouchedBackground:YES];
    [_alertView show];

}
//取消弹出框
-(void)shutDownButtonClicked{
    [_alertView dismissWithCompletion:nil];
}
//使用优惠券
-(void)userCBtnClicked:(UIButton*)button{
    //跳转到店铺详情界面
    
    [self shutDownButtonClicked];
    if ([self.merId length]>0) {
        StoreDetailViewController *vc=[[StoreDetailViewController alloc]init];
        vc.storeId=self.merId;
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        MyCouponViewController * vc = [[MyCouponViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
-(void)createTopView
{
//    if (status==0)
//    {
//        statusString=@"未领取";
//    }
//    if (status==1)
//    {
//        statusString=@"已领取";
//    }
//    if (status==2)
//    {
//        statusString=@"已过期";
//    }
//    if (status==3)
//    {
//        statusString=@"已领完";
//    }
    
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    [self.view addSubview:_scrollView];
    
    NSString *imgUrlString=[self.redDict objectForKey:@"userImg"];//发红包人头像
    NSString *nickname=[self.redDict objectForKey:@"nickName"];//发红包人昵称
    NSString *imgUrlString1=[self.redDict objectForKey:@"userImg1"];//领红包人头像
    NSString *nickname1=[self.redDict objectForKey:@"nickName1"];//领红包人昵称
    
    NSString *theme=[self.redDict objectForKey:@"theme"]==nil?@"":[[self.redDict objectForKey:@"theme"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    NSString *money=[NSString stringWithFormat:@"%.2f",[[self.redDict objectForKey:@"money"] floatValue]];
    NSInteger isAdmin=[[self.redDict objectForKey:@"isAdmin"] integerValue];//1、后台 0、用户
    NSInteger isOwn=[[self.redDict objectForKey:@"isOwn"] integerValue];//1、自己发的 0、别人发的
    NSInteger status=[[self.redDict objectForKey:@"status"] integerValue];//领取状态
    
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(330))];
    topView.backgroundColor=COLOR_WHITE;
    [_scrollView addSubview:topView];
    
    if (isAdmin==0)
    {
        _scrollView.frame=CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT+20);
        topView.frame=CGRectMake(0, 0, SCREEN_WIDTH, WZ(230));
    }
    if (isAdmin==1)
    {
        _scrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        topView.frame=CGRectMake(0, 0, SCREEN_WIDTH, WZ(500));
    }
    
    UIImageView *topIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(120))];
    topIV.image=IMAGE(@"hongbao_detailtopbg");
    [topView addSubview:topIV];
    
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
    }
    UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(50))/2.0, topIV.bottom-WZ(50/2.0), WZ(50), WZ(50))];
    headBtn.layer.cornerRadius=headBtn.width/2.0;
    headBtn.clipsToBounds=YES;
    [topView addSubview:headBtn];
    if (isAdmin==0)
    {
        [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    }
    if (isAdmin==1)
    {
        [headBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
    }
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(30), headBtn.bottom+WZ(5), SCREEN_WIDTH-WZ(30*2), WZ(25))];
    nameLabel.text=[NSString stringWithFormat:@"%@的红包",nickname];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(16, 14);
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [topView addSubview:nameLabel];
    
    UIButton *checkBtn=[[UIButton alloc]init];
    checkBtn.backgroundColor=COLOR(255, 40, 59, 1);
    checkBtn.clipsToBounds=YES;
    checkBtn.layer.cornerRadius=5;
    [checkBtn setTitle:@"查看我的外快（红包）吧" forState:UIControlStateNormal];
    [checkBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    checkBtn.titleLabel.font=FONT(16, 14);
    [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:checkBtn];
    
    UILabel *detailLabel=[[UILabel alloc]init];
    detailLabel.text=@"未领取的红包，将于24小时候发起退款";
    detailLabel.textColor=COLOR_LIGHTGRAY;
    detailLabel.textAlignment=NSTextAlignmentCenter;
    detailLabel.font=FONT(15, 13);
//    detailLabel.backgroundColor=COLOR_CYAN;
    [_scrollView addSubview:detailLabel];
    
    //用户发的红包
    if (isAdmin==0)
    {
        checkBtn.frame=CGRectMake(WZ(20), topView.bottom+WZ(150), SCREEN_WIDTH-WZ(20*2), WZ(50));
        detailLabel.frame=CGRectMake(checkBtn.left, checkBtn.bottom+WZ(5), checkBtn.width, WZ(25));
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(3), nameLabel.width, WZ(40))];
        subLabel.text=theme;
        subLabel.textColor=COLOR_LIGHTGRAY;
        subLabel.textAlignment=NSTextAlignmentCenter;
        subLabel.font=FONT(15, 13);
        subLabel.numberOfLines=2;
//        subLabel.backgroundColor=COLOR_CYAN;
        [topView addSubview:subLabel];
        
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), topView.bottom+WZ(5), SCREEN_WIDTH-WZ(15*2), WZ(25))];
//        moneyLabel.text=money;
        moneyLabel.textColor=COLOR_LIGHTGRAY;
        moneyLabel.font=FONT(15, 13);
        //    moneyLabel.backgroundColor=COLOR_CYAN;
        [_scrollView addSubview:moneyLabel];
        
        UIView *userView=[[UIView alloc]initWithFrame:CGRectMake(0, moneyLabel.bottom+WZ(5), SCREEN_WIDTH, WZ(60))];
        userView.backgroundColor=COLOR_WHITE;
        [_scrollView addSubview:userView];
        
        NSURL *imgUrl1;
        if ([imgUrlString1 containsString:@"http://"] || [imgUrlString1 containsString:@"https://"])
        {
            imgUrl1=[NSURL URLWithString:imgUrlString1];
        }
        else
        {
            imgUrl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString1]];
        }
        
        UIButton *headBtn1=[[UIButton alloc]initWithFrame:CGRectMake(WZ(10), WZ(10), WZ(40), WZ(40))];
        headBtn1.layer.cornerRadius=headBtn1.width/2.0;
        headBtn1.clipsToBounds=YES;
        [headBtn1 sd_setBackgroundImageWithURL:imgUrl1 forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        [userView addSubview:headBtn1];
        
        UILabel *nicknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headBtn1.right+WZ(10), headBtn1.top, WZ(120), headBtn1.height)];
        nicknameLabel.text=nickname1;
        nicknameLabel.font=FONT(15, 13);
//        nicknameLabel.backgroundColor=COLOR_CYAN;
        [userView addSubview:nicknameLabel];
        
        UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+120), headBtn1.top, WZ(120), headBtn1.height)];
        jineLabel.text=[NSString stringWithFormat:@"%.2f元",[money floatValue]];
        jineLabel.textAlignment=NSTextAlignmentRight;
        jineLabel.font=FONT(16, 14);
//        jineLabel.backgroundColor=COLOR_CYAN;
        [userView addSubview:jineLabel];
        
        if (isOwn==0)
        {
            //别人发的
            if (status==0 || status==1)
            {
                moneyLabel.text=[NSString stringWithFormat:@"1个红包共%.2f元，已领取",[money floatValue]];
                detailLabel.hidden=YES;
            }
            if (status==2)
            {
                moneyLabel.text=[NSString stringWithFormat:@"1个红包共%.2f元，已过期",[money floatValue]];
                userView.hidden=YES;
            }
        }
        if (isOwn==1)
        {
            //自己发的
            if (status==0)
            {
                moneyLabel.text=[NSString stringWithFormat:@"1个红包共%.2f元，对方未领取",[money floatValue]];
                userView.hidden=YES;
            }
            if (status==1)
            {
                moneyLabel.text=[NSString stringWithFormat:@"1个红包共%.2f元，对方已领取",[money floatValue]];
                detailLabel.hidden=YES;
            }
            if (status==2)
            {
                moneyLabel.text=[NSString stringWithFormat:@"1个红包共%.2f元，已退款到钱包",[money floatValue]];
                userView.hidden=YES;
            }
        }
        
    }
    if (isAdmin==1)
    {
        checkBtn.frame=CGRectMake(WZ(20), topView.bottom+WZ(20), SCREEN_WIDTH-WZ(20*2), WZ(50));
        detailLabel.frame=CGRectMake(checkBtn.left, checkBtn.bottom+WZ(5), checkBtn.width, WZ(25));
        detailLabel.hidden=YES;
        
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(20), nameLabel.width, WZ(40))];
        moneyLabel.textAlignment=NSTextAlignmentCenter;
        moneyLabel.font=FONT(25, 23);
//        moneyLabel.backgroundColor=COLOR_CYAN;
        [topView addSubview:moneyLabel];
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, moneyLabel.bottom, nameLabel.width, WZ(35))];
        subLabel.text=[NSString stringWithFormat:@"系统红包共%.2f元,已领取%@/%@个",[self.totalMoney floatValue],self.isGet,self.num];
        subLabel.textAlignment=NSTextAlignmentCenter;
        subLabel.font=FONT(14, 12);
        subLabel.numberOfLines=2;
//        subLabel.backgroundColor=COLOR_CYAN;
        [topView addSubview:subLabel];
        
        UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(WZ(50), subLabel.bottom+WZ(20), SCREEN_WIDTH-WZ(50*2), WZ(190))];
        detailView.backgroundColor=COLOR(255, 243, 231, 1);
        detailView.clipsToBounds=YES;
        detailView.layer.cornerRadius=5;
        [topView addSubview:detailView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), WZ(15), detailView.width-WZ(10*2), WZ(25))];
        titleLabel.text=self.theme;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=FONT(17,15);
//        titleLabel.backgroundColor=COLOR_CYAN;
        [detailView addSubview:titleLabel];
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+WZ(5), titleLabel.width, WZ(135))];
        detailLabel.text=self.remark;
        detailLabel.textColor=COLOR_BLACK;
        detailLabel.textAlignment=NSTextAlignmentCenter;
        detailLabel.font=FONT(15, 13);
        detailLabel.numberOfLines=9;
//        detailLabel.backgroundColor=COLOR_CYAN;
        [detailView addSubview:detailLabel];
        
        if (status==0 || status==1)
        {
            moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[self.myMoney floatValue]];
        }
        if (status==2)
        {
            moneyLabel.text=@"红包已过期";
        }
        if (status==3)
        {
            if ([self.myMoney floatValue]>0)
            {
                moneyLabel.text=[NSString stringWithFormat:@"%.2f元",[self.myMoney floatValue]];
            }
            else
            {
                moneyLabel.text=@"红包已被抢完";
            }
        }
    }
    
    [self creatNavView];
    
    
}











#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//查看我的外快吧
-(void)checkBtnClick
{
    RedEnvelopeRecordsViewController *vc=[[RedEnvelopeRecordsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bigCommentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return WZ(40);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
    aView.backgroundColor=COLOR_WHITE;
    aView.layer.borderColor = COLOR_NAVIGATION.CGColor;
    aView.layer.borderWidth = 2.0f;
    UIButton *titleLabel=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(50), aView.height)];
    titleLabel.titleLabel.font =FONT(15,13);
    [titleLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleLabel.tag = 100;
    [aView addSubview:titleLabel];

    [titleLabel setTitle:@"评论" forState:UIControlStateNormal];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame),aView.height-3, CGRectGetWidth(titleLabel.frame), 2)];
    lineView.backgroundColor = COLOR(255, 150, 158, 1);
    [aView addSubview:lineView];
    
    return aView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *commentDict;
    if (indexPath.row<self.bigCommentArray.count) {
        commentDict=self.bigCommentArray[indexPath.row];
    }
    
    NSString *content=[[commentDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGSize contentSize=[ViewController sizeWithString:content font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
    
    UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15,13) textAlignment:NSTextAlignmentLeft];
    
    return contentLabel.bottom+WZ(30);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell2";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDictionary *commentDict;
    if (indexPath.row<self.bigCommentArray.count) {
        commentDict=self.bigCommentArray[indexPath.row];
    }
    
    NSString *content=[[commentDict objectForKey:@"content"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *createtime=[commentDict objectForKey:@"createtime"];
    NSString *headImg=[commentDict objectForKey:@"headImg"];
    NSString *isLike=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"isLike"]];
    NSString *praisecount=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"praisecount"]];
    NSString *userName=[commentDict objectForKey:@"userName"];
    NSString *ofUserName=[commentDict objectForKey:@"ofUserName"];
    
    UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
    [cell.contentView addSubview:headView];
    headView.goBtn.hidden=YES;
    
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
    headView.nameLabel.textColor = [UIColor blackColor];
    headView.timeLabel.text=createtime;
    headView.timeLabel.textColor=COLOR_LIGHTGRAY;
    headView.addFriendBtn.hidden = YES;
    
    NSString *contentString;
    if (ofUserName==nil || [ofUserName isEqualToString:@""])
    {
        contentString=content;
    }
    else
    {
        contentString=[NSString stringWithFormat:@"回复 %@：%@",ofUserName,content];
    }
  
    NSRange range = [contentString rangeOfString:ofUserName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
    [str  addAttribute:NSFontAttributeName value:FONT(15,13) range:range];
    [str  addAttribute:NSForegroundColorAttributeName value:COLOR(243, 167, 170, 1) range:range];
    

    CGSize contentSize=[ViewController sizeWithString:contentString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(5000))];
    UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.headImageBtn.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height)];
    contentLabel.text=contentString;
    contentLabel.font=FONT(15, 13);
    contentLabel.numberOfLines=0;
    contentLabel.attributedText = str;
    [cell.contentView addSubview:contentLabel];
    
    ArticleBottomView *bottomView=[[ArticleBottomView alloc]initWithFrame:CGRectMake(0, contentLabel.bottom, SCREEN_WIDTH, WZ(45))];
    //        bottomView.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:bottomView];
    
    bottomView.pageViewIV.frame=CGRectMake(0, 0, 0, 0);
    bottomView.praiseLabel.text=praisecount;
    bottomView.praiseLabel.tag=indexPath.row;
    bottomView.commentLabel.text=@"回复";
    
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
    
    NSString *kissNum=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"kissNum"]==nil?@"0":[commentDict objectForKey:@"kissNum"]];
    bottomView.zuiLabel.text =kissNum;
    bottomView.zuiBtn.tag = indexPath.row;
    [bottomView.zuiBtn addTarget:self action:@selector(dynamicZuiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomView.commentBtn.tag = indexPath.row;
    [bottomView.commentBtn addTarget:self action:@selector(dynamicCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSString * userPhone =[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"userPhone"]];
    NSLog(@"userPhone==%@===%@",userPhone,[UserInfoData getUserInfoFromArchive].username);
    if ([userPhone isEqualToString:[UserInfoData getUserInfoFromArchive].username]) {
        bottomView.zuiIV.image = IMAGE(@"zuichun_fen");
    }else{
        bottomView.zuiIV.image = IMAGE(@"zuichun");
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}
//评论点赞
-(void)commentPraiseBtnClick:(UIButton*)button
{
    NSMutableDictionary *commentDict=self.bigCommentArray[button.tag];
    if (![commentDict isEqual:[NSNull null]])
    {
        NSString *commentId=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"id"]];
        
        [HTTPManager addPraiseWithUserId:[UserInfoData getUserInfoFromArchive].userId type:@"2" objectId:commentId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [commentDict setValue:@"1" forKey:@"isLike"];
                NSInteger praisecount=[[commentDict objectForKey:@"praisecount"] integerValue];
                [commentDict setValue:[NSString stringWithFormat:@"%ld",praisecount+1] forKey:@"praisecount"];
                
                [_tableView reloadData];
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:1.0];
            }
        }];
    }
    
}
//评论👄btn
-(void)dynamicZuiButtonClicked:(UIButton *)button{
    NSDictionary *commentDict=self.bigCommentArray[button.tag];
    NSString * userPhone =[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"userPhone"]];
    NSLog(@"userPhone==%@===%@",userPhone,[UserInfoData getUserInfoFromArchive].username);
    if ([userPhone isEqualToString:[UserInfoData getUserInfoFromArchive].username]) {
        [self.view makeToast:@"亲，不能嘴自己的哟！" duration:1.0];
        return;
        
    }
    NSLog(@"commentDict==%@",commentDict);
    //RedEnvelopeListViewController *vc=[[RedEnvelopeListViewController alloc]init];
    RedEnvelopeSendViewController * vc = [[RedEnvelopeSendViewController alloc]init];
    vc.type = @"2";
    vc.objId = [NSString stringWithFormat:@"%@",commentDict[@"id"]];
    vc.scanMobile = [NSString stringWithFormat:@"%@",commentDict[@"userPhone"]];
    
    vc.isMouth = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dynamicCommentButtonClicked:(UIButton *)button{
    NSDictionary *commentDict=self.bigCommentArray[button.tag];
    NSLog(@"评论字典===%@",commentDict);
    NSString *commentId=[NSString stringWithFormat:@"%@",[commentDict objectForKey:@"id"]];
    NSString *userName=[commentDict objectForKey:@"userName"];
    self.commentString=@"";
    [self.commentTV becomeFirstResponder];
    self.textLabel.text=[NSString stringWithFormat:@"回复:%@",userName];
    self.textLabel.textColor=COLOR(158, 158, 158, 1);
    
    self.parentId=commentId;
    [_tableView reloadData];
}
//刷新
-(void)refreshData{
    if (!_reqCommentDic) {
        _reqCommentDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"pageNum",nil];
    }else{
        [_reqCommentDic setObject:@"1" forKey:@"pageNum"];
    }
    
    [self getInfo];

}
//加载更多
-(void)getMoreData{
    NSInteger pageNum = [_reqCommentDic[@"pageNum"] integerValue];
    pageNum++;
    if (pageNum>_totalPages) {
        [self.view makeToast:@"没有更多数据" duration:1.0];
        [_tableView footerEndRefreshing];
        return;
    }
    [_reqCommentDic setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"pageNum"];
    [self getInfo];
}
-(void)getInfo{
    
    NSString *redId=[NSString stringWithFormat:@"%@",[self.redDict objectForKey:@"id"]];
    [HTTPManager getCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId objectId:redId type:@"3" storeId:@"" pageNum:_reqCommentDic[@"pageNum"] pageSize:@"5" pxType:@"" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSMutableDictionary *listDict=[[resultDict objectForKey:@"list"] mutableCopy];
            NSMutableArray *commentArray=[[listDict objectForKey:@"data"] mutableCopy];
            _totalPages= [listDict[@"totalPages"] integerValue];
            NSInteger pageNum = [_reqCommentDic[@"pageNum"] integerValue];
            if (pageNum<=1) {
                _tableView.tableFooterView=nil;
                if (commentArray.count==0) {
                    [self creatTableFootView];
                }else{
                    [self.bigCommentArray removeAllObjects];
                    for (NSDictionary * dic in commentArray) {
                        [self.bigCommentArray addObject:[dic mutableCopy]];
                    }
                    [_tableView reloadData];
                }
                [_tableView headerEndRefreshing];
            }else{
                NSMutableArray * indexArray = [self changeIndexWithFirstCount:self.bigCommentArray.count Section:0 lastCount:self.bigCommentArray.count+commentArray.count];
                for (NSDictionary * dic in commentArray) {
                    
                    [self.bigCommentArray addObject:[dic mutableCopy]];
                }
                
                [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                
                //结束加载
                [_tableView footerEndRefreshing];
            }

        }else{
            [_tableView footerEndRefreshing];
             [_tableView headerEndRefreshing];
        }
    }];

}
-(void)creatTableFootView{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(50))];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(17, 15);
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"暂无评论";
    _tableView.tableFooterView = titleLabel;
}
-(NSMutableArray*)changeIndexWithFirstCount:(NSInteger)firstCount  Section:(NSInteger)section lastCount:(NSInteger)lastCount{
    NSMutableArray* indexArray = [NSMutableArray array];
    for (NSInteger i=firstCount; i<lastCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexArray addObject:indexPath];
    }
    return indexArray;
}
#pragma mark - 评论操作
//滑动tableView隐藏键盘 只需实现tableView的这个代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
//评论
-(void)redEvelopeCommentButtonClicked:(UIButton *)button{
     self.textLabel.text = @"评论";
    [self.commentTV becomeFirstResponder];
}
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    NSLog(@"键盘高度===%f",deltaY);
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _bottomView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-deltaY-WZ(50), SCREEN_WIDTH, WZ(50));
    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _bottomView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREEN_WIDTH, WZ(50));
    } completion:^(BOOL finished) {
        
    }];
}

-(void)createBottomCommentView
{
    
    
    UIWindow *window=[UIApplication sharedApplication].windows[0];
    
    if (!_bottomView) {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, WZ(50))];
        UITextView *commentTV=[[UITextView alloc]initWithFrame:CGRectMake(WZ(15), WZ(8), SCREEN_WIDTH-WZ(15*2), WZ(50)-WZ(8*2))];
        commentTV.backgroundColor=COLOR_WHITE;
        commentTV.returnKeyType=UIReturnKeySend;
        commentTV.delegate=self;
        commentTV.font=FONT(17, 15);
        commentTV.clipsToBounds=YES;
        commentTV.layer.cornerRadius=3;
        commentTV.layer.borderWidth=1.0;
        commentTV.layer.borderColor=COLOR(234, 234, 234, 1).CGColor;
        [_bottomView addSubview:commentTV];
        self.commentTV=commentTV;
        
        self.textLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15+5), WZ(8), SCREEN_WIDTH-WZ(20*2), WZ(50)-WZ(8*2))];
        self.textLabel.text=@"写评论";
        self.textLabel.textColor=COLOR(158, 158, 158, 1);
        self.textLabel.font=FONT(17, 15);
        self.textLabel.layer.cornerRadius=3;
        self.textLabel.layer.borderWidth=1.0;
        self.textLabel.layer.borderColor=COLOR_CLEAR.CGColor;
        [_bottomView addSubview:self.textLabel];
    }
    
    _bottomView.backgroundColor=COLOR(245, 246, 247, 1);
    [window addSubview:_bottomView];
    
    
    //    self.textLabel=textLabel;
}
#pragma mark -textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        if (self.commentString==nil||[self.commentString isEqualToString:@""]) {
            [self.view makeToast:@"请输入评论内容" duration:1.5];
            return YES;
        }
        NSString *comment=[self.commentString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *redId=[NSString stringWithFormat:@"%@",[self.redDict objectForKey:@"id"]];
        //添加评论
        [HTTPManager addCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId userName:[UserInfoData getUserInfoFromArchive].username payInfoId:@"" objectId:redId parentId:self.parentId type:@"3" storeId:@"" content:comment star:@"" imageArray:nil complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                self.commentString=@"";
                self.commentTV.text=@"";
               // _isEedEnD = NO;
                
                [self refreshData];
                
//                self.commentNum=[NSString stringWithFormat:@"%ld",[self.commentNum integerValue]+1];
//                self.articleCommentLabel.text=self.commentNum;
            }
            else
            {
                [self.view makeToast:@"评论失败" duration:1.0];
            }
        }];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.commentString=textView.text;
    
    if (textView.text.length>0)
    {
        [self.textLabel setHidden:YES];
    }
    if (textView.text.length==0)
    {
        [self.textLabel setHidden:NO];
    }
    
}
//领取红包
-(void)secondEnBtnGetClicked{
    
    NSString *imgUrlString=[self.redDict objectForKey:@"userImg"];
    NSString *nickname=[self.redDict objectForKey:@"nickName"];
    NSString *theme=[[self.redDict objectForKey:@"theme"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger isAdmin=[[self.redDict objectForKey:@"isAdmin"] integerValue];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view.window addSubview:bgView];
    self.bgView=bgView;
    
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(80), WZ(100), WZ(40), WZ(40))];
    [closeBtn setBackgroundImage:IMAGE(@"hongbao_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeHongbaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeBtn];
    
    UIImageView *hongbaoIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(50), WZ(120), SCREEN_WIDTH-WZ(50*2), SCREEN_HEIGHT-WZ(120+150))];
    hongbaoIV.image=IMAGE(@"hongbao_open");
    [bgView addSubview:hongbaoIV];
    
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,[self.redDict objectForKey:@"userImg"]]];
    }
    UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake((hongbaoIV.width-WZ(50))/2.0, WZ(130), WZ(50), WZ(50))];
    
    [hongbaoIV addSubview:headBtn];
    NSInteger onetomanyTypeId=[self.redDict[@"onetomanyTypeId"] integerValue];
    // NSString *command = self.redDict[@"command"];
    
    if (onetomanyTypeId==3) {
        headBtn.frame = CGRectMake((hongbaoIV.width-WZ(100))/2.0, WZ(130), WZ(100), WZ(30));
        [headBtn setTitleColor:COLOR(255, 231, 192, 1) forState:UIControlStateNormal];
        headBtn.titleLabel.font = FONT(16, 14);
        [headBtn setTitle:@"口令红包" forState:UIControlStateNormal];
        hongbaoIV.userInteractionEnabled =YES;
    }else{
        headBtn.frame = CGRectMake((hongbaoIV.width-WZ(50))/2.0, WZ(130), WZ(50), WZ(50));
        headBtn.layer.cornerRadius=headBtn.width/2.0;
        headBtn.clipsToBounds=YES;
        if (isAdmin==0)
        {
            [headBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
        }
        if (isAdmin==1)
        {
            [headBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
        }
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(headBtn.left-WZ(40), headBtn.bottom+WZ(3), headBtn.width+WZ(40*2), WZ(25))];
        headLabel.text=nickname;
        headLabel.textColor=COLOR(255, 231, 192, 1);
        headLabel.textAlignment=NSTextAlignmentCenter;
        headLabel.font=FONT(15, 13);
        //    headLabel.backgroundColor=COLOR_CYAN;
        [hongbaoIV addSubview:headLabel];
    }
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.frame = CGRectMake(WZ(10), headBtn.bottom+WZ(30), hongbaoIV.width-WZ(10*2), WZ(50));
    titleLabel.text=theme;
    titleLabel.textColor=COLOR(255, 231, 192, 1);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(17, 15);
    titleLabel.numberOfLines=2;
    //    titleLabel.backgroundColor=COLOR_CYAN;
    [hongbaoIV addSubview:titleLabel];
    
    UIButton *openBtn=[[UIButton alloc]initWithFrame:CGRectMake(hongbaoIV.left+WZ(40), hongbaoIV.bottom-WZ(95), hongbaoIV.width-WZ(40*2), WZ(55))];
    [openBtn setBackgroundImage:IMAGE(@"hongbao_chaikai") forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:openBtn];
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
