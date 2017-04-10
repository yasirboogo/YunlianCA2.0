//
//  PaymentQRCodeViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "PaymentQRCodeViewController.h"

#import "QRCodeGenerator.h"
#import <SVProgressHUD.h>



@interface PaymentQRCodeViewController ()
{
    NSString *_merName;
}
@end

@implementation PaymentQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    UIImageView * headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*258/750.0)];
    headImageView.image = [UIImage imageNamed:@"payHead"];
    [self.view addSubview:headImageView];
    
     [self getPayQRCode];
    
    UIImageView * footImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH*196/750.0-64, SCREEN_WIDTH, SCREEN_WIDTH*196/750.0)];
    footImageView.image = [UIImage imageNamed:@"payFoot"];
    [self.view addSubview:footImageView];
}

//获取付款码
-(void)getPayQRCode
{
    
//    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"获取中..." detail:nil];
//    [hud show:YES];
//    [hud hide:YES afterDelay:20];
    [SVProgressHUD showWithStatus:@"获取中..."];
    [HTTPManager getPayQRCodeWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        [SVProgressHUD dismiss];
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
            
            
            _merName=[resultDict objectForKey:@"merName"]==nil?@"":[resultDict objectForKey:@"merName"];
//            NSString *termId=[resultDict objectForKey:@"termId"];
//            NSString *url=[NSString stringWithFormat:@"http://zjwl.dealreal.com.cn/xmMemcardController.do?goPayment&merId=%@&termId=%@",merId,termId];
            if ([resultDict objectForKey:@"url"]==nil) {
                [self.view makeToast:@"获取付款二维码失败" duration:1.0];
                return ;
            }
            NSString *url=[resultDict objectForKey:@"url"];
            [self createQRCodeWithUrl:url WithSuccess:YES];
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self createQRCodeWithUrl:msg WithSuccess:NO];
            
//            //[self.view makeToast:msg duration:5.0];
//            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:msg detail:nil];
//            [hud show:YES];
//            [hud hide:YES afterDelay:5];
            
        }
        
       
    }];
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
    self.title=@"收款码";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

-(void)createQRCodeWithUrl:(NSString*)url WithSuccess:(BOOL)isSuccess
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.center.y-WZ(170)/2.0-WZ(60)-10, SCREEN_WIDTH-20, WZ(20))];
    titleLabel.font = FONT(18, 16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = _merName;
    [self.view addSubview:titleLabel];
    
    UIView *erweimaView=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(170))/2.0, self.view.center.y-WZ(170)/2.0-WZ(40)+10, WZ(170), WZ(170))];
    erweimaView.backgroundColor=COLOR_WHITE;
    erweimaView.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    erweimaView.layer.borderWidth=1;
    [self.view addSubview:erweimaView];
    
    UIImageView *erweimaIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(4), WZ(4), erweimaView.width-WZ(4*2), erweimaView.width-WZ(4*2))];
//    erweimaIV.image=[QRCodeGenerator qrImageForString:@"中国有礼仪之大,故称夏;有章服之美,谓之华。" imageSize:WZ(170)];;
    [erweimaView addSubview:erweimaIV];
    if (isSuccess) {
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
        UIImage *bigImage=[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:WZ(162)];
        erweimaIV.image =bigImage;
    }else{
        erweimaIV.image =IMAGE(@"morentupian");
        [self.view makeToast:url duration:3.0];
    }
    
    
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), erweimaView.bottom+WZ(40), SCREEN_WIDTH-WZ(15*2), WZ(60))];
    detailLabel.numberOfLines=3;
    detailLabel.text=@"温馨提示：本平台主做本地社区当面在线或线下交易，您确认该商户是您熟悉、信任的商家才可以支付。";
    detailLabel.textAlignment=NSTextAlignmentCenter;
    detailLabel.font=FONT(15, 13);
    [self.view addSubview:detailLabel];
    
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
