//
//  DetailPlaceViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/10/24.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "DetailPlaceViewController.h"

@interface DetailPlaceViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
    
    
}


@end

@implementation DetailPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavigationBar];
    [self createMapView];
    [self createBottomView];
    
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=[self.addressDict objectForKey:@"name"];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(10+50), WZ(10), WZ(50), WZ(25))];
    [rightBtn setTitle:@"导航" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    rightBtn.titleLabel.font=FONT(17, 15);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createBottomView
{
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-WZ(85), SCREEN_WIDTH, WZ(85))];
    bottomView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:bottomView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_LIGHTGRAY;
    [bottomView addSubview:lineView];
    
    NSString *address=[self.addressDict objectForKey:@"address"];
    NSString *titleName=[self.addressDict objectForKey:@"name"];
    NSString *mobile=[NSString stringWithFormat:@"%@",[self.addressDict objectForKey:@"mobile"]];
    NSString *callNum=[NSString stringWithFormat:@"%@",[self.addressDict objectForKey:@"callNum"]];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2)-WZ(80), WZ(25))];
    titleLabel.text=titleName;
    titleLabel.textColor=COLOR(146, 135, 187, 1);
    //    titleLabel.backgroundColor=COLOR_CYAN;
    [bottomView addSubview:titleLabel];
    
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width+WZ(20), WZ(20))];
    addressLabel.text=[NSString stringWithFormat:@"地址：%@",address];
    addressLabel.font=FONT(13,11);
    //    addressLabel.backgroundColor=COLOR_CYAN;
    [bottomView addSubview:addressLabel];
    
    CGSize dianhuaSize=[ViewController sizeWithString:@"电话：" font:FONT(13,11) maxSize:CGSizeMake(WZ(50), WZ(20))];
    UILabel *dianhuaLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, addressLabel.bottom, dianhuaSize.width, WZ(20))];
    dianhuaLabel.text=@"电话：";
    dianhuaLabel.font=FONT(13,11);
    //    dianhuaLabel.backgroundColor=COLOR_CYAN;
    [bottomView addSubview:dianhuaLabel];
    
    UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(dianhuaLabel.right, dianhuaLabel.top, titleLabel.width-dianhuaSize.width, WZ(20))];
    mobileLabel.text=mobile;
    mobileLabel.textColor=COLOR_GREEN;
    mobileLabel.font=FONT(13,11);
    //    mobileLabel.backgroundColor=COLOR_CYAN;
    [bottomView addSubview:mobileLabel];
    
    NSString *callString=[NSString stringWithFormat:@"拨打%@次",callNum];
    CGSize callLabelSize=[ViewController sizeWithString:callString font:FONT(11,9) maxSize:CGSizeMake(WZ(120),WZ(20))];
    
    UILabel *callLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(12)-callLabelSize.width, WZ(50), callLabelSize.width, WZ(20))];
    callLabel.textAlignment=NSTextAlignmentCenter;
    callLabel.text=callString;
    callLabel.textColor=COLOR(166, 213, 157, 1);
    callLabel.font=FONT(11,9);
    [bottomView addSubview:callLabel];
    
    UIButton *callBtn=[[UIButton alloc]init];
    callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, callLabel.center.y-WZ(40));
    callBtn.size=CGSizeMake(WZ(30), WZ(30));
    [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
    callBtn.layer.cornerRadius=callBtn.width/2.0;
    callBtn.clipsToBounds=YES;
    [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:callBtn];
    
}

-(void)createMapView
{
    _mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-WZ(85))];
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.mapType = MAMapTypeStandard;//标准模式
    [self.view addSubview:_mapView];
    
    NSString *name=[self.addressDict objectForKey:@"name"];
    NSString *address=[self.addressDict objectForKey:@"address"];
    CGFloat latitude=[[self.addressDict objectForKey:@"latitude"] floatValue];
    CGFloat longitude=[[self.addressDict objectForKey:@"longitude"] floatValue];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = name;
    annotation.subtitle=address;
    [_mapView addAnnotation:annotation];
    
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    //    _mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    _mapView.centerCoordinate = view.annotation.coordinate;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        //        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//导航
-(void)rightBtnClick
{
    NSString *address=[self.addressDict objectForKey:@"address"];
    
    CGFloat latitude=[[self.addressDict objectForKey:@"latitude"] floatValue];
    CGFloat longitude=[[self.addressDict objectForKey:@"longitude"] floatValue];
    
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


//打电话
-(void)callBtnClick:(UIButton*)button
{
    NSString *mobile=[NSString stringWithFormat:@"%@",[self.addressDict objectForKey:@"mobile"]];
   
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
