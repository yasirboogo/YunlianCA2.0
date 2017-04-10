//
//  ShareView.m
//  UEnjoyCustomer
//
//  Created by 马JL on 2016/11/8.
//  Copyright © 2016年 马JL. All rights reserved.
//

#import "ShareView.h"
#import "UIButton+ImageLocation.h"
#import <SVProgressHUD.h>
#import <SDImageCache.h>
@implementation ShareView

+(instancetype)sharedInstance{
    static dispatch_once_t once;
    
    static ShareView *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    
    return sharedInstance;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonArray = [NSMutableArray array];
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame), SCREEN_WIDTH, WZ(100)*2+WZ(40))];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
//        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, WZ(25))];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.font = FONT(17, 15);
//       
//        titleLabel.textColor = COLOR(0, 0, 0, 0.75);
//        titleLabel.text = @"分享到";
//        [_backView addSubview:titleLabel];
        CGFloat width = (CGRectGetWidth(frame)-WZ(22)*2-WZ(27)*3)/4.0;
        NSArray * titles = @[@"微信好友",@"微信朋友圈",@"微信收藏",@"QQ",@"QQ空间",@"新浪微博",@"邻里圈"];
        NSArray * images = @[@"sns_icon_22",@"sns_icon_23",@"sns_icon_37",@"sns_icon_24",@"sns_icon_6",@"sns_icon_1",@"linliquan"];
        CGFloat maxY =5;
        CGFloat minX = WZ(22);
        for (NSInteger i=0; i<titles.count; i++) {
            if (i%4==0&&i!=0) {
                maxY+= WZ(100);
                minX = WZ(22);
            }
            UIButton * shareButton = [[UIButton alloc]initWithFrame:CGRectMake(minX+(width+WZ(27))*(i%4), maxY, width, WZ(100))];
            NSLog(@"shareButton==%@",NSStringFromCGRect(shareButton.frame));
            shareButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            shareButton.titleLabel.font = FONT(14, 12);
            shareButton.tag = i;
            [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [shareButton setTitleColor:COLOR(0, 0, 0, 0.75) forState:UIControlStateNormal];
            [shareButton setTitle:titles[i] forState:UIControlStateNormal];
            [shareButton setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [shareButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:WZ(9)];
            if (i==6) {
                shareButton.hidden = YES;
            }
            [_buttonArray addObject:shareButton];
            [_backView addSubview:shareButton];
        }
       
        UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_backView.frame)-WZ(40), SCREEN_WIDTH, WZ(40))];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.titleLabel.font = FONT(19, 17);;
        [cancelBtn setTitleColor:COLOR(0, 0, 0, 1) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(shareCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        [cancelBtn addSubview:lineView];
        [_backView addSubview:cancelBtn];
    }
    return self;
}
-(void)shareButtonClicked:(UIButton *)shareBtn{
    
    if (self.isShowAdjacent&&!_isSelectBtn) {
        _lastButton = shareBtn;
        _isSelectBtn = YES;
        if (_block) {
            _block(shareBtn);
        }
        return;
    }
    
        NSInteger type;
        if (shareBtn.tag==0) {
            type =SSDKPlatformSubTypeWechatSession;
            
        }else if(shareBtn.tag==1){
            type =SSDKPlatformSubTypeWechatTimeline;
        }else if(shareBtn.tag==2){
            type= SSDKPlatformSubTypeWechatFav;
        }else if(shareBtn.tag==3){
            type =SSDKPlatformSubTypeQQFriend;
        }else if(shareBtn.tag==4){
            type = SSDKPlatformSubTypeQZone;
        }else if(shareBtn.tag==5){
            type =SSDKPlatformTypeSinaWeibo;
            
        }
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.shareContent
                                         images:self.image
                                            url:[NSURL URLWithString:self.shareUrl]
                                          title:self.shareTitle
                                           type:SSDKContentTypeAuto];
        [self dismissView];
        [ShareSDK share:type
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             _isSelectBtn = NO;
             UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
             switch (state) {
                     
                 case SSDKResponseStateSuccess:
                 {
                     
                     if (type==SSDKPlatformTypeSinaWeibo){
                         [window makeToast:@"分享新浪微博成功" duration:2];
                        
                     }else if (type==SSDKPlatformSubTypeWechatTimeline){
                          [window makeToast:@"分享朋友圈成功" duration:2];
                         
                     }else if (type==SSDKPlatformSubTypeWechatFav){
                         [window makeToast:@"微信收藏成功" duration:2];
                     }
                     
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     //[SVProgressHUD showSuccessWithStatus:@"分享失败,请重试" duration:1];
                     [window makeToast:@"分享失败,请重试"duration:2];
                     break;
                 }
                 case SSDKResponseStateCancel:
                 {
                     
                 }
                 default:
                     break;
             }
             
         }];

       
    
   
}
-(void)shareWithImageUrlArray:(NSArray*)imageUrlArray title:(NSString*)title content:(NSString*)content url:(NSString*)url{
    
    UIImage *newImg;
    if (imageUrlArray.count>0)
    {  UIImage *oldImg;
        if ([[imageUrlArray firstObject] isKindOfClass:[UIImage class]]) {
            
            oldImg=[imageUrlArray firstObject];
        }else{
            if ([[imageUrlArray firstObject] isKindOfClass:[NSURL class]]) {
                NSURL * imageUrl =[imageUrlArray firstObject];
              oldImg=  [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl.absoluteString];
                if (!oldImg) {
                    NSData *oldData=[NSData dataWithContentsOfURL:[imageUrlArray firstObject]];
                    oldImg=[UIImage imageWithData:oldData];
                }
                
            }
            
            
           
        }
        
        NSData *imgData=[self imageWithImage:oldImg scaledToSize:CGSizeMake(300, 300)];
        newImg=[UIImage imageWithData:imgData];
    }
    else
    {
        newImg=IMAGE(@"");
    }
    [SVProgressHUD dismiss];
    self.image = newImg;
    self.shareTitle = title;
    self.shareContent = content;
    if ([url containsString:@"http"]) {
         self.shareUrl = url;
    }else{
       self.shareUrl= [NSString stringWithFormat:@"%@%@",HOST,url];
    }
   
    if (self.isShowAdjacent) {
        
        [self shareButtonClicked:_lastButton];
    }else{
        [self showView];
    }
    
    //1、创建分享参数 （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:content images:newImg url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] title:title type:SSDKContentTypeAuto];
}
-(void)showView{
    UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:[ShareView sharedInstance]];
    if ([ShareView sharedInstance].isShowAdjacent) {
        UIButton * button = self.buttonArray.lastObject;
        button.hidden = NO;
       
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = COLOR(0, 0, 0, 0.25);
         _backView.frame =CGRectMake(0, CGRectGetHeight(self.frame)-CGRectGetHeight(_backView.frame), SCREEN_WIDTH, CGRectGetHeight(_backView.frame));
    }];
}
-(void)dismissView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor clearColor];
        _backView.frame =CGRectMake(0, CGRectGetHeight(self.frame), SCREEN_WIDTH, CGRectGetHeight(_backView.frame));
    } completion:^(BOOL finished) {
        UIButton * button = self.buttonArray.lastObject;
        button.hidden = YES;
        [self removeFromSuperview];
    }];
}
-(void)shareCancelButtonClicked{
    [self dismissView];
}
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
