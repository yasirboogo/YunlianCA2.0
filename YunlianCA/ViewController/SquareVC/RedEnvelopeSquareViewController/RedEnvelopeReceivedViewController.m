//
//  RedEnvelopeReceivedViewController.m
//  YunlianCA
//
//  Created by QinJun on 2016/12/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RedEnvelopeReceivedViewController.h"

@interface RedEnvelopeReceivedViewController ()





@property(nonatomic,strong)UIView *smallBgView;


@end

@implementation RedEnvelopeReceivedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createBgView];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    //去掉导航条下边的shadowImage，就可以正常显示了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)createBgView
{
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgIV.image=IMAGE(@"hongbao_shou_beijing");
    [self.view addSubview:bgIV];
    
    UIImageView *backIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), 20+WZ(5), WZ(14), WZ(25))];
    backIV.image=IMAGE(@"fanhui_bai");
    [self.view addSubview:backIV];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(5), backIV.top, WZ(60), backIV.height)];
    //    backBtn.backgroundColor=COLOR_CYAN;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(backBtn.right+WZ(5), backIV.top, SCREEN_WIDTH-WZ(70*2), backIV.height)];
    titleLabel.text=@"收红包";
    titleLabel.textColor=COLOR_WHITE;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=FONT(19, 17);
    [self.view addSubview:titleLabel];
    
    UIView *smallBgView=[[UIView alloc]initWithFrame:CGRectMake(WZ(30), WZ(120), SCREEN_WIDTH-WZ(30*2), SCREEN_WIDTH-WZ(30*2))];
    smallBgView.backgroundColor=COLOR_WHITE;
    smallBgView.clipsToBounds=YES;
    smallBgView.layer.cornerRadius=5;
    [self.view addSubview:smallBgView];
    self.smallBgView=smallBgView;
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[UserInfoData getUserInfoFromArchive].username,@"hongbao", nil];
    NSString *hongbaoString=[dict JSONString];
    //红包二维码内容是个字典
    [self createQRCodeWithUrl:hongbaoString];
    
}

-(void)createQRCodeWithUrl:(NSString*)url
{
    UIView *erweimaView=[[UIView alloc]initWithFrame:CGRectMake((self.smallBgView.width-WZ(220))/2.0, WZ(30), WZ(220), WZ(220))];
    erweimaView.backgroundColor=COLOR_WHITE;
    erweimaView.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    erweimaView.layer.borderWidth=1;
    [self.smallBgView addSubview:erweimaView];
    
    UIImageView *erweimaIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(4), WZ(4), erweimaView.width-WZ(4*2), erweimaView.width-WZ(4*2))];
    [erweimaView addSubview:erweimaIV];
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = url;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    UIImage *bigImage=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:WZ(216)];
    erweimaIV.image =bigImage;
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), erweimaView.bottom+WZ(10), self.smallBgView.width-WZ(15*2), WZ(25))];
    detailLabel.text=@"扫一扫，领红包";
    detailLabel.textColor=COLOR_LIGHTGRAY;
    detailLabel.textAlignment=NSTextAlignmentCenter;
    detailLabel.font=FONT(15, 13);
    [self.smallBgView addSubview:detailLabel];
    
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
