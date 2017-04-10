//
//  ScanViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ScanViewController.h"
#import "UIView+SDExtension.h"

#import "ScanDetailViewController.h"
#import "ScanPayMoneyViewController.h"
#import "RedEnvelopeSendViewController.h"
#import <AVFoundation/AVFoundation.h>
#define TINTCOLOR_ALPHA 0.3  //浅色透明度
#define DARKCOLOR_ALPHA 0.5  //深色透明度


static const CGFloat kMargin = 30;
@interface ScanViewController ()<UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    UIButton*_backBtn;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak)   UIView *maskView;
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;
//扫描的得到的内容
@property(nonatomic,strong)NSString *symbolStr;

@property(nonatomic,strong)NSString *merId;
@property(nonatomic,strong)NSString *termId;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.merId=@"";
    self.termId=@"";
    

    
    [self setupMaskView];
    [self setupTipTitleView];
    [self setupScanWindowView];
    [self beginScanning];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotificationEnterForeground) name:@"EnterForeground" object:nil];
    _backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(10), 20+WZ(5), WZ(40), WZ(40))];
    [_backBtn setImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    
    [_backBtn  addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}
-(void)getNotificationEnterForeground{
    CGFloat scanNetImageViewH = 241;
    CGFloat scanWindowH = self.view.sd_width - kMargin * 2;
    CGFloat scanNetImageViewW = _scanWindow.sd_width;
    
    _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindowH);
    scanNetAnimation.duration = 1.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
    [_scanWindow addSubview:_scanNetImageView];
}
-(void)setupTipTitleView{
    
    
    UIView*mask=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.sd_y+_maskView.sd_height, self.view.sd_width, SCREEN_HEIGHT-_maskView.sd_y+_maskView.sd_height)];
    mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view addSubview:mask];
    
    //2.操作提示
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,WZ(165.5)+WZ(230)+WZ(26)*3, self.view.bounds.size.width, WZ(15))];
    
    tipLabel.text = @"将二维码/条形码放入框内，即可自动扫描";
    tipLabel.backgroundColor = COLOR(255, 255, 255, 0.56);
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
   
    
}

- (void)setupMaskView
{
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    mask.layer.borderWidth = WZ(165.5);
    
    mask.bounds = CGRectMake(0, 0, WZ(230) + WZ(165.5)*2 + kMargin , WZ(230) + WZ(165.5)*2 + kMargin);
    mask.center = CGPointMake(self.view.sd_width * 0.5, self.view.sd_height * 0.5);
    mask.sd_y = 0;
    
    [self.view addSubview:mask];
}
- (void)setupScanWindowView
{
    
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-(WZ(230)+kMargin))/2.0, WZ(165.5), WZ(230)+kMargin, WZ(230)+kMargin)];
    _scanWindow.clipsToBounds = YES;
    //_scanWindow.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scanWindow];
    
    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode_scanLine"]];
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"wode_zuoshangjiao"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scanWindow.frame) - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"wode_youshangjiao"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_scanWindow.frame) - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"wode_zuoxiajiao"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_scanWindow.frame)-buttonWH,CGRectGetHeight(_scanWindow.frame)-buttonWH, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"wode_youxiajiao"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
}
- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError * error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    NSLog(@"error===%@",error);
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        [self.view makeToast:errorStr duration:2];
        return;
    }
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
   
    CGRect scanCrop=[self getScanCrop:CGRectMake(0, 0, _scanWindow.bounds.size.width*1.5, _scanWindow.bounds.size.height*1.5) readerViewBounds:self.view.frame];
    //CGRect scanCrop=[self getScanCrop:self.view.bounds readerViewBounds:self.view.frame];
    output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
   
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
   
    
    //开始捕获
    //[_session startRunning];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
            //const zbar_symbol_t *symbol =zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
            self.symbolStr = metadataObject.stringValue;
         NSLog(@"metadataObject===%@",metadataObject.stringValue);
            if(!self.symbolStr)
            {
                return;
            }
            else
            {
                 [_session stopRunning];
                NSString *titleString=@"";
                NSString *messageString=@"";
                NSString *leftString=@"";
                NSString *rightString=@"";
        
                if ([self.symbolStr containsString:@"http://"] || [self.symbolStr containsString:@"https://"])
                {
                    if ([self.symbolStr containsString:@"merId"] && [self.symbolStr containsString:@"termId"])
                    {
                        //http://zjwl.dealreal.com.cn/xmMemcardController.do?goPayment&merId=000000010000309&termId=10000287
        
                        NSLog(@"内容===%@",self.symbolStr);
        
                        NSArray *array=[self.symbolStr componentsSeparatedByString:@"&"];
                        for (NSInteger i=0; i<array.count; i++)
                        {
                            NSString *string=array[i];
        //                    NSLog(@"内容===%@",string);
        
                            if ([string containsString:@"merId"])
                            {
                                NSArray *arr_param = [string componentsSeparatedByString:@"="];
                                self.merId= arr_param.lastObject;
                            }
                            if ([string containsString:@"termId"])
                            {
                                NSArray *arr_param = [string componentsSeparatedByString:@"="];
                                self.termId=arr_param.lastObject;
                            }
        
                        }
        
                        if (![self.merId isEqualToString:@""] && ![self.termId isEqualToString:@""])
                        {
                            //直接跳转付款界面
                            ScanPayMoneyViewController *vc=[[ScanPayMoneyViewController alloc]init];
                            vc.merId=self.merId;
                            vc.termId=self.termId;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                    else
                    {
                        //网址
                        titleString=@"网址";
                        messageString=[NSString stringWithFormat:@"%@",self.symbolStr];
                        leftString=@"取消";
                        rightString=@"立即前往";
        
                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:titleString message:messageString delegate:self cancelButtonTitle:leftString otherButtonTitles:rightString, nil];
                        alertView.tag=0;
                        [alertView show];
                    }
                    return;
                }
                if ([self.symbolStr containsString:@"hongbao"])
                {
                    NSDictionary *hongbaoDict=[self.symbolStr objectFromJSONString];
                    NSString *hongbao=[hongbaoDict objectForKey:@"hongbao"];
                    if (![hongbao isEqualToString:@""] && hongbao!=nil)
                    {
                        RedEnvelopeSendViewController *vc=[[RedEnvelopeSendViewController alloc]init];
                        vc.scanMobile=hongbao;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
        
                    return;
                }
                else
                {
                    //其他
                    titleString=@"提示";
                    messageString=[NSString stringWithFormat:@"%@",self.symbolStr];
                    leftString=@"取消";
                    rightString=@"确定";
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:titleString message:messageString delegate:self cancelButtonTitle:leftString otherButtonTitles:rightString, nil];
                    alertView.tag=0;
                    [alertView show];
                    
                    return;
                }
                
            }

        
        
    }
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    NSLog(@"===%f==%f==%f==%f",x, y, width, height);
    return CGRectMake(x, y, width, height);
    
}
#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        [_scanNetImageView.layer setTimeOffset:0.0];
        
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = 241;
        CGFloat scanWindowH = self.view.sd_width - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.sd_width;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==0)
    {
        if (buttonIndex==1)
        {
            if ([self.symbolStr containsString:@"http://"] || [self.symbolStr containsString:@"https://"])
            {
                if ([self.symbolStr containsString:@"merId"] && [self.symbolStr containsString:@"termId"])
                {
                    
                    
                }
                else
                {
                    //跳转网页
                    ScanDetailViewController *vc=[[ScanDetailViewController alloc]init];
                    vc.url=self.symbolStr;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }
//            if ([self.symbolStr containsString:@"InvateCode_Yunlian"])
//            {
//                NSDictionary *codeDict=[self.symbolStr objectFromJSONString];
//                NSString *code=[codeDict objectForKey:@"InvateCode_Yunlian"];
//                NSLog(@"推荐码为：%@",code);
//                
//                //扫码成为会员
//                [HTTPManager becomeMemberWithUserId:[UserInfoData getUserInfoFromArchive].userId code:code complete:^(NSDictionary *resultDict) {
//                    NSString *result=[resultDict objectForKey:@"result"];
//                    if ([result isEqualToString:STATUS_SUCCESS])
//                    {
//                        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成为会员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                        alertView.tag=1;
//                        [alertView show];
//                    }
//                    else
//                    {
//                        NSString *msg=[resultDict objectForKey:@"msg"];
//                        [self.view makeToast:msg duration:2.0];
//                    }
//                }];
//            }
            else
            {
                //其他内容 不做处理
                 [_session startRunning];
            }
            
        }
         [_session startRunning];
    }
    
}

//返回按钮
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//跳出扫描界面时移除扫描线 停止定时器
- (void)viewWillDisappear:(BOOL)animated
{

    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    self.navigationController.navigationBarHidden=NO;
    
    [super viewWillDisappear:animated];
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    [_scanWindow removeFromSuperview];
    [_maskView removeFromSuperview];
    
}

//扫描后的界面返回重新进行二维码扫描动作
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    self.navigationController.navigationBarHidden=YES;

    [self resumeAnimation];
    if (![_session isRunning]) {
         [_session startRunning];
    }
    [self.view addSubview:_maskView];
    [self.view addSubview:_scanWindow];
    [self.view addSubview:_backBtn];
   
}
-(void)navLeftBarButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
