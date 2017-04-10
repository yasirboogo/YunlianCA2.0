//
//  AroundPlaceViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/24.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AroundPlaceViewController.h"

#import <MAMapKit/MAAnnotationView.h>
#import "DetailPlaceViewController.h"

@interface AroundPlaceViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MAMapViewDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
    MAMapView *_mapView;
    UILabel *_blankLabel;
    
}

@property(nonatomic,strong)NSMutableArray *addressArray;
@property(nonatomic,strong)NSMutableArray *annotationsArray;
@property(nonatomic,strong)NSString *detailAddress;
@property(nonatomic,assign)NSInteger index;


@end

@implementation AroundPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //增加一个KVO  index
//    [self addObserver:self forKeyPath:@"index" options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
    [self createNavigationBar];
    [self createMapView];
    
    
    NSString *moduleId=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
    NSString *lng=[NSString stringWithFormat:@"%f",self.longitude];
    NSString *lat=[NSString stringWithFormat:@"%f",self.latitude];
    
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    [HTTPManager surroundingServiceForStoreListWithModuleId:moduleId areaId:[UserInfoData getUserInfoFromArchive].areaId lng:lng lat:lat pageNum:@"1" pageSize:@"200" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.addressArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            [hud hide:YES];
            
            if (self.addressArray.count>0)
            {
                [self createTableView];
                
                self.annotationsArray = [NSMutableArray array];
                for (NSInteger i=0; i<self.addressArray.count; i++)
                {
                    NSDictionary *addressDict=self.addressArray[i];
                    NSString *name=[addressDict objectForKey:@"name"];
                    CGFloat latitude=[[addressDict objectForKey:@"latitude"] floatValue];
                    CGFloat longitude=[[addressDict objectForKey:@"longitude"] floatValue];
                    
                    if (i==0)
                    {
                        _mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    }
                    
                    MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    annotation.title = name;
                    [self.annotationsArray addObject:annotation];
                    
                    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
                    //2.反地理编码
                    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
                    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error||placemarks.count==0)
                        {
                            //            NSLog(@"未知地点");
                            self.detailAddress=@"未知地点";
                        }
                        else//编码成功
                        {
                            //显示最前面的地标信息
                            CLPlacemark *firstPlacemark=[placemarks firstObject];
                            NSDictionary *addressDictionary=firstPlacemark.addressDictionary;
                            //省
                            NSString *province=[addressDictionary objectForKey:@"State"];
                            //市
                            NSString *city=[addressDictionary objectForKey:@"City"];
                            //区
                            NSString *area=[addressDictionary objectForKey:@"SubLocality"];
                            //街道
                            NSString *street=[addressDictionary objectForKey:@"Street"];
                            //省市区
//                            NSString *address=[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
                            //详细地址
                            self.detailAddress=[NSString stringWithFormat:@"%@%@%@",city,area,street];
                            
                            annotation.subtitle = self.detailAddress;
                        }
                    }];
                }
                
                [_mapView addAnnotations:self.annotationsArray];
            }
            else
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), _mapView.bottom+WZ(100), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无服务地点~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
            }
        }
        else
        {
            [hud hide:YES];
            [self.view makeToast:@"获取数据失败，请重试。" duration:1.0];
        }
    }];
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

//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//    //  NSLog(@"地图");
//    if (updatingLocation) {
//        //      NSLog(@"latitude = %f longitude = %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//        //确定地图经纬度
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        //设置的当前位置 为地图中心
////        _mapView.centerCoordinate = coordinate;
////        self.location = userLocation;
//        
////        MACoordinateRegion region = MACoordinateRegionMakeWithDistance(coordinate,1500, 1500);
////        [_mapView setRegion:[_mapView regionThatFits:region] animated:NO];
//    }
//}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    
//}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=[self.moduleDict objectForKey:@"name"];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createMapView
{
    _mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(300))];
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;
    _mapView.zoomEnabled = YES;//支持缩放
    _mapView.mapType = MAMapTypeStandard;//标准模式
    [self.view addSubview:_mapView];
//    _mapView.centerCoordinate=
//    //定位管理器
//    _locationManager=[[CLLocationManager alloc]init];
//    
//    if (![CLLocationManager locationServicesEnabled])
//    {
//        [self.view makeToast:@"定位服务当前可能尚未打开，请设置打开！" duration:1.0];
//        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
//        return;
//    }
//    
//    //如果没有授权则请求用户授权
//    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
//        [_locationManager requestWhenInUseAuthorization];
//    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
//        //设置代理
//        _locationManager.delegate=self;
//        //设置定位精度
//        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//        //定位频率,每隔多少米定位一次
//        CLLocationDistance distance=10.0;//十米定位一次
//        _locationManager.distanceFilter=distance;
//        //启动跟踪定位
//        [_locationManager startUpdatingLocation];
//    }
    
}

//#pragma mark - CoreLocation 代理
//#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
////可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location=[locations firstObject];//取出第一个位置
//    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
//    
//    MACoordinateRegion region = MACoordinateRegionMakeWithDistance(coordinate,1500, 1500);
////    MKCoordinateRegion region=MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.1f, 0.1f));
//    [_mapView setRegion:[_mapView regionThatFits:region] animated:NO];
//    
//    //如果不需要实时定位，使用完即使关闭定位服务
////    [_locationManager stopUpdatingLocation];
//}


-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, WZ(200), SCREEN_WIDTH, SCREEN_HEIGHT-WZ(200)-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}


#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count;
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
    
    NSDictionary *addressDict=self.addressArray[indexPath.row];
    NSString *address=[addressDict objectForKey:@"address"];
    NSString *titleName=[addressDict objectForKey:@"name"];
    NSString *mobile=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"mobile"]];
    NSString *callNum=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"callNum"]];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2)-WZ(80), WZ(25))];
    titleLabel.text=titleName;
    titleLabel.textColor=COLOR(146, 135, 187, 1);
//    titleLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, WZ(20))];
    addressLabel.text=[NSString stringWithFormat:@"地址：%@",address];
    addressLabel.font=FONT(13,11);
//    addressLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:addressLabel];
    
    CGSize dianhuaSize=[ViewController sizeWithString:@"电话：" font:FONT(13,11) maxSize:CGSizeMake(WZ(50), WZ(20))];
    UILabel *dianhuaLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, addressLabel.bottom, dianhuaSize.width, WZ(20))];
    dianhuaLabel.text=@"电话：";
    dianhuaLabel.font=FONT(13,11);
//    dianhuaLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:dianhuaLabel];
    
    UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(dianhuaLabel.right, dianhuaLabel.top, titleLabel.width-dianhuaSize.width, WZ(20))];
    mobileLabel.text=mobile;
    mobileLabel.textColor=COLOR_GREEN;
    mobileLabel.font=FONT(13,11);
//    mobileLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:mobileLabel];
    
    NSString *callString=[NSString stringWithFormat:@"拨打%@次",callNum];
    CGSize callLabelSize=[ViewController sizeWithString:callString font:FONT(11,9) maxSize:CGSizeMake(WZ(120),WZ(20))];
    
    UILabel *callLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(12)-callLabelSize.width, WZ(50), callLabelSize.width, WZ(20))];
    callLabel.textAlignment=NSTextAlignmentCenter;
    callLabel.text=callString;
    callLabel.textColor=COLOR(166, 213, 157, 1);
    callLabel.font=FONT(11,9);
    [cell.contentView addSubview:callLabel];
    
    UIButton *callBtn=[[UIButton alloc]init];
    callBtn.tag=indexPath.row;
    callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, callLabel.center.y-WZ(40));
    callBtn.size=CGSizeMake(WZ(30), WZ(30));
//    callBtn.backgroundColor=COLOR(166, 213, 157, 1);
    [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
    callBtn.layer.cornerRadius=callBtn.width/2.0;
    callBtn.clipsToBounds=YES;
    [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:callBtn];
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
    
    NSDictionary *addressDict=self.addressArray[indexPath.row];
//    CGFloat latitude0=[[addressDict objectForKey:@"latitude"] floatValue];
//    CGFloat longitude0=[[addressDict objectForKey:@"longitude"] floatValue];
    
    DetailPlaceViewController *vc=[[DetailPlaceViewController alloc]init];
    vc.addressDict=addressDict;
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSDictionary *addressDict=self.addressArray[indexPath.row];
////    NSString *name=[addressDict objectForKey:@"name"];
//    CGFloat latitude0=[[addressDict objectForKey:@"latitude"] floatValue];
//    CGFloat longitude0=[[addressDict objectForKey:@"longitude"] floatValue];
////    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(latitude, longitude);
//    
//    for (MAPointAnnotation *annotation in self.annotationsArray)
//    {
//        CGFloat latitude1=annotation.coordinate.latitude;
//        CGFloat longitude1=annotation.coordinate.longitude;
//        
//        if (latitude0==latitude1 && longitude0==longitude1)
//        {
////            annotation
//        }
//    }
//    
//    
//    
//    MAPointAnnotation *annotation=self.annotationsArray[indexPath.row];
//    
//    if (indexPath.row==self.addressArray.count)
//    {
//        
//    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(85);
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//打电话
-(void)callBtnClick:(UIButton*)button
{
    NSDictionary *addressDict=self.addressArray[button.tag];
    NSString *mobile=[NSString stringWithFormat:@"%@",[addressDict objectForKey:@"mobile"]];
    
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
