//
//  TuiGuangViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/21.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "TuiGuangViewController.h"

#import "QRCodeGenerator.h"


@interface TuiGuangViewController ()


@property(nonatomic,strong)NSString *url;

@end

@implementation TuiGuangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.view.backgroundColor=COLOR_HEADVIEW;
    
//    [self createNavigationBar];
    [self createSubviews];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
//    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
    self.navigationController.navigationBarHidden=NO;
}

//-(void)createNavigationBar
//{
//    self.title=@"我要推广";
//    
//    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
//    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem=leftItem;
//    
//}

-(void)createSubviews
{
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(65));
    [self.view addSubview:scrollView];
    
    UIImageView *topIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(300))];
    topIV.image=IMAGE(@"tuiguang01");
    [scrollView addSubview:topIV];
    
    UIImageView *backIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(20), WZ(35), WZ(12), WZ(25))];
    backIV.image=IMAGE(@"fanhui");
    [self.view addSubview:backIV];
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, WZ(30), WZ(52), WZ(35))];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIView *erweimaView=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(140))/2.0, topIV.bottom+WZ(5), WZ(140), WZ(152))];
    erweimaView.backgroundColor=COLOR_WHITE;
//    erweimaView.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
//    erweimaView.layer.borderWidth=1;
    [scrollView addSubview:erweimaView];
    
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, erweimaView.width, erweimaView.height)];
    bgIV.image=IMAGE(@"jiantoukuang");
    [erweimaView addSubview:bgIV];
    
    UIImageView *erweimaIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(2), WZ(7), erweimaView.width-WZ(2*2), erweimaView.width-WZ(2*2))];
    //    erweimaIV.image=[QRCodeGenerator qrImageForString:@"中国有礼仪之大,故称夏;有章服之美,谓之华。" imageSize:WZ(170)];;
    [erweimaView addSubview:erweimaIV];
    
    NSString *code=[UserInfoData getUserInfoFromArchive].username;
    self.url=[NSString stringWithFormat:@"%@share/toRegister.api?inviteCode=%@",HOST,code];
//    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
//    
//    if ([bundleIdentifier isEqualToString:@"com.yingnuo.YunlianCA"])
//    {
//        //正式环境链接
//        self.url=[NSString stringWithFormat:@"%@share/toRegister.api?inviteCode=%@",HOST,code];
//    }
//    else if ([bundleIdentifier isEqualToString:@"com.yingnuo.YLCA"])
//    {
//        //测试环境链接
//        self.url=[NSString stringWithFormat:@"http://101.201.121.59:8090/shequ/app/share/toRegister.api?inviteCode=%@",HOST,code];
//    }
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
//    NSMutableDictionary *codeDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:codeString,@"InvateCode_Yunlian", nil];
//    NSString *dataString = [codeDict JSONString];
    NSData *data = [self.url dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    erweimaIV.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:WZ(140)];
    
    UIImageView *middleIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, erweimaView.bottom+WZ(5), SCREEN_WIDTH, WZ(180))];
    middleIV.image=IMAGE(@"tuiguang02");
    [scrollView addSubview:middleIV];
    
    UILabel *urlLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), middleIV.bottom, SCREEN_WIDTH-WZ(15*2), WZ(40))];
    urlLabel.text=self.url;
    urlLabel.numberOfLines=2;
    urlLabel.textAlignment=NSTextAlignmentCenter;
    urlLabel.font=FONT(13, 11);
    [scrollView addSubview:urlLabel];
    
    UIImageView *bottomIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, urlLabel.bottom, SCREEN_WIDTH, WZ(50))];
    bottomIV.image=IMAGE(@"tuiguang03");
    [scrollView addSubview:bottomIV];
    
    CGSize copySize=[ViewController sizeWithString:@"点击复制分享链接" font:FONT(13, 11) maxSize:CGSizeMake(WZ(200), WZ(20))];
    UIButton *copyBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-copySize.width-WZ(20))/2.0, bottomIV.top+WZ(5), copySize.width+WZ(20), WZ(20))];
    [copyBtn setTitle:@"点击复制分享链接" forState:UIControlStateNormal];
    [copyBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    copyBtn.titleLabel.font=FONT(13, 11);
    copyBtn.clipsToBounds=YES;
    copyBtn.layer.cornerRadius=3;
    copyBtn.backgroundColor=COLOR(255, 87, 115, 1);
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:copyBtn];
    
    
//    UILabel *tjmLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), erweimaView.bottom+WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(20))];
//    tjmLabel.text=@"您的专属推荐码为:";
//    tjmLabel.font=FONT(17,15);
//    tjmLabel.textAlignment=NSTextAlignmentCenter;
//    [scrollView addSubview:tjmLabel];
//    
//    UILabel *tuijianmaLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), tjmLabel.bottom, SCREEN_WIDTH-WZ(15*2), WZ(20))];
//    tuijianmaLabel.font=FONT(17,15);
//    tuijianmaLabel.textAlignment=NSTextAlignmentCenter;
//    [scrollView addSubview:tuijianmaLabel];
//    
//    if (code==nil || [code isEqualToString:@""])
//    {
//        tuijianmaLabel.text=@"暂无推荐码";
//    }
//    else
//    {
//        tuijianmaLabel.text=[NSString stringWithFormat:@"%@",code];
//    }
//    
//    
//    UILabel *myUrlLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), tuijianmaLabel.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), WZ(20))];
//    myUrlLabel.text=@"我的专属推荐链接:";
//    myUrlLabel.textAlignment=NSTextAlignmentCenter;
//    myUrlLabel.font=FONT(17, 15);
//    [scrollView addSubview:myUrlLabel];
//    
//    
//    UILabel *urlLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), myUrlLabel.bottom, SCREEN_WIDTH-WZ(15*2), WZ(40))];
//    urlLabel.text=self.url;
//    urlLabel.numberOfLines=2;
//    urlLabel.textAlignment=NSTextAlignmentCenter;
//    urlLabel.font=FONT(15, 13);
//    [scrollView addSubview:urlLabel];
//
//    UIButton *copyBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+70), myUrlLabel.top, WZ(70), myUrlLabel.height)];
//    [copyBtn setTitle:@"点击复制" forState:UIControlStateNormal];
//    [copyBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
//    copyBtn.titleLabel.font=FONT(13, 11);
//    copyBtn.clipsToBounds=YES;
//    copyBtn.layer.cornerRadius=3;
//    copyBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
//    copyBtn.layer.borderWidth=1;
//    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:copyBtn];
//
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(60), urlLabel.bottom+WZ(30), SCREEN_WIDTH-WZ(60*2), WZ(186.5))];
//    imageView.image=IMAGE(@"tuiguang");
//    [scrollView addSubview:imageView];
    
    
    
    
    
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


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


/**
 复制链接
 */
-(void)copyBtnClick
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setURL:[NSURL URLWithString:self.url]];
    
    [self.view makeToast:@"推荐链接已复制" duration:2.0];
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
