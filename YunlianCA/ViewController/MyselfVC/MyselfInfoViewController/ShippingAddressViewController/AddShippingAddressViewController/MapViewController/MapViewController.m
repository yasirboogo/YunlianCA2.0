//
//  MapViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,UIAlertViewDelegate>
{
    MAPointAnnotation *_pointAnnotation;
    UIButton *_zoomInBtn;//地图放大按钮
    UIButton *_zoomOutBtn;//地图缩小按钮
    UIAlertView *_alertView;
    
}

@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapLocationManager *locationManager;//定位管理器
@property(nonatomic,strong)CLGeocoder *geocoder;//反地理编码


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self configMapView];
    [self createMapSubviews];
    
    [self geocoder];
    [self initLocationManager];
    
    
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

//配置地图
- (void)configMapView
{
    self.mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView.delegate = self;
    self.mapView.pausesLocationUpdatesAutomatically = NO;
//    self.mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    //指定定位是否会被系统自动暂停。默认为YES。只在iOS 6.0之后起作用。
    self.mapView.pausesLocationUpdatesAutomatically = NO;
    self.mapView.showsUserLocation=YES;
    self.mapView.userTrackingMode=MAUserTrackingModeFollowWithHeading;
    self.mapView.zoomEnabled=YES;
    self.mapView.showsLabels=YES;
    self.mapView.touchPOIEnabled=YES;
    [self.view addSubview:self.mapView];
    
}

-(void)createNavigationBar
{
    self.title=@"地图";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_WHITE}];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(10), WZ(20))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createMapSubviews
{
    //地图放大按钮
    _zoomInBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(55), SCREEN_HEIGHT-64-WZ(100), WZ(40), WZ(40))];
    _zoomInBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    _zoomInBtn.layer.borderWidth=1;
    _zoomInBtn.backgroundColor=COLOR_WHITE;
    [_zoomInBtn setTitle:@"+" forState:UIControlStateNormal];
    [_zoomInBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [_zoomInBtn addTarget:self action:@selector(zoomInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zoomInBtn];
    
    //地图缩小按钮
    _zoomOutBtn=[[UIButton alloc]initWithFrame:CGRectMake(_zoomInBtn.left, _zoomInBtn.bottom+WZ(10), WZ(40), WZ(40))];
    _zoomOutBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    _zoomOutBtn.layer.borderWidth=1;
    _zoomOutBtn.backgroundColor=COLOR_WHITE;
    [_zoomOutBtn setTitle:@"-" forState:UIControlStateNormal];
    [_zoomOutBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [_zoomOutBtn addTarget:self action:@selector(zoomOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zoomOutBtn];
    
    //显示用户自身位置按钮
    UIButton *userLocationBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15),_zoomInBtn.bottom+WZ(10), WZ(40), WZ(40))];
    userLocationBtn.layer.borderWidth=1;
    userLocationBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    userLocationBtn.backgroundColor=COLOR_WHITE;
    [userLocationBtn setTitle:@"◉" forState:UIControlStateNormal];
    [userLocationBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    [userLocationBtn addTarget:self action:@selector(userLocationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userLocationBtn];
}

-(CLGeocoder *)geocoder
{
    if (_geocoder==nil)
    {
        _geocoder=[[CLGeocoder alloc]init];
    }
    
    return _geocoder;
}

//初始化定位管理器
-(void)initLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=1.0;//1米定位一次
    self.locationManager.distanceFilter=distance;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //启动跟踪定位
    [self.locationManager startUpdatingLocation];
}

#pragma mark ===AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //    NSLog(@"纬度：%f,经度：%f,海拔：%f,速度：%f",_lastCoordinate.latitude,_lastCoordinate.longitude,location.altitude,location.speed);
    
    CLLocationCoordinate2D coordinate=location.coordinate;
    CGFloat lat=coordinate.latitude;
    CGFloat lon=coordinate.longitude;
    NSString *latitude=[NSString stringWithFormat:@"%f",lat];
    NSString *longitude=[NSString stringWithFormat:@"%f",lon];
    
    CLLocation *location1=[[CLLocation alloc]initWithLatitude:lat longitude:lon];
    //2.反地理编码
    [self.geocoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0)
        {
            NSLog(@"未知地点");
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
            NSString *address=[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
            //详细地址
            NSString *detailAddress=[NSString stringWithFormat:@"%@%@%@%@",province,city,area,street];
//            NSLog(@"定位地址===%@",addressDictionary);
            
            NSMutableDictionary *addressDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:address,@"pca",street,@"street",latitude,@"lat",longitude,@"lon", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"address" object:self userInfo:addressDict];
        }
    }];
}

//定位出错
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
        
        NSLog(@"定位错误信息====%@",error);
        switch (error.code) {
            case 1:
            {
                if (!_alertView)
                {
                    _alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已禁止此APP访问位置信息，设置里可修改权限。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    _alertView.tag=error.code;
                    [_alertView show];
                }
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

//触摸地图获取具体地址信息
- (void)mapView:(MAMapView *)mapView didTouchPois:(NSArray *)pois
{
    MATouchPoi *poi=[pois lastObject];
    NSString *addressName=poi.name;
    
    CLLocationCoordinate2D coordinate=poi.coordinate;
    CGFloat lat=coordinate.latitude;
    CGFloat lon=coordinate.longitude;
    NSString *latitude=[NSString stringWithFormat:@"%f",lat];
    NSString *longitude=[NSString stringWithFormat:@"%f",lon];
    
    NSLog(@"addressName====%@\r\nlatitude====%@\r\nlongitude====%@",addressName,latitude,longitude);
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:lat longitude:lon];
    
    //2.反地理编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error||placemarks.count==0)
        {
            NSLog(@"未知地点");
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
            NSString *address=[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
            //详细地址
            NSString *detailAddress=[NSString stringWithFormat:@"%@%@%@%@",province,city,area,street];
            NSLog(@"选择的地址===%@",detailAddress);
            
            NSMutableDictionary *addressDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:address,@"pca",street,@"street",latitude,@"lat",longitude,@"lon", nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"address" object:self userInfo:addressDict];
            
            
            if (_pointAnnotation==nil)
            {
                _pointAnnotation = [[MAPointAnnotation alloc] init];
                
                _pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
                _pointAnnotation.title = addressName;
                _pointAnnotation.subtitle = detailAddress;
                [_mapView addAnnotation:_pointAnnotation];
            }
            else
            {
                [self.mapView removeAnnotation:_pointAnnotation];
                
                _pointAnnotation = [[MAPointAnnotation alloc] init];
                
                _pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat,lon);
                _pointAnnotation.title = addressName;
                _pointAnnotation.subtitle = detailAddress;
                [_mapView addAnnotation:_pointAnnotation];
            }
        }
    }];
    
}

//根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        
        
        pointAnnotationView.animatesDrop   = YES;
        pointAnnotationView.canShowCallout = YES;
        //        pointAnnotationView.draggable      = YES;
        pointAnnotationView.pinColor=MAPinAnnotationColorRed;
        
        
        
        return pointAnnotationView;
    }
    
    return nil;
}

#pragma mark ===buttonClick===

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//放大地图
-(void)zoomInBtnClick
{
    if (self.mapView.zoomLevel<self.mapView.maxZoomLevel)
    {
        self.mapView.zoomLevel++;
        [_zoomOutBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    }
    if (self.mapView.zoomLevel==self.mapView.maxZoomLevel)
    {
        [_zoomInBtn resignFirstResponder];
        [_zoomInBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
    }
    
}
//缩小地图
-(void)zoomOutBtnClick
{
    if (self.mapView.zoomLevel>self.mapView.minZoomLevel)
    {
        self.mapView.zoomLevel--;
        [_zoomInBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    }
    if (self.mapView.zoomLevel==self.mapView.minZoomLevel)
    {
        [_zoomOutBtn resignFirstResponder];
        [_zoomOutBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
    }
}

//显示用户当前位置
-(void)userLocationBtnClick
{
    //点击按钮时显示用户位置
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    
    
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
