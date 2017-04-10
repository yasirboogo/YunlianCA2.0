//
//  ViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <AFNetworkReachabilityManager.h>


#define kNetworkReachability [AFNetworkReachabilityManager sharedManager]

@interface ViewController ()<MBProgressHUDDelegate,AMapLocationManagerDelegate,RCIMReceiveMessageDelegate>//,CLLocationManagerDelegate

@property(nonatomic,strong)AMapLocationManager *locationManager;//定位管理器
@property(nonatomic,strong)CLGeocoder *geocoder;//反地理编码

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=COLOR_WHITE;
    
//    self.selfView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:self.selfView];
    
//    //侧滑
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
//    if (IOS_VERSION_7_OR_ABOVE)
//    {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    }
    
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    hud.color=COLOR_CLEAR;
//    hud.labelText=title;
//    hud.detailsLabelText=detail;
    [self.view addSubview:hud];
    
    //定位
    [self initLocationManager];
    [RCIM sharedRCIM].receiveMessageDelegate=self;
}

#pragma mark - 收到消息监听
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
          UITabBarItem * tabBarItem= [[[self.tabBarController tabBar] items] objectAtIndex:3];
            int count = [[RCIMClient sharedRCIMClient]getUnreadCount:@[[NSNumber numberWithInt:ConversationType_PRIVATE],[NSNumber numberWithInt:ConversationType_GROUP]]];
            if (count>0) {
                tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
            }else
            {
                tabBarItem.badgeValue = nil;
            }
            
        });


    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //去掉导航条下边的shadowImage，就可以正常显示了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    
    if (kNetworkReachability.reachable == NO)
    {
        _netStatusBar.hidden = NO;
    }
    else
    {
        _netStatusBar.hidden = YES;
    }
}

//横着的线
-(UIView *)lineViewWithFrame:(CGRect)frame
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)];
    lineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    lineView.layer.borderWidth=1;
    
    return lineView;
}

//横着的线
+(UIView *)lineViewWithFrame:(CGRect)frame
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)];
    lineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    lineView.layer.borderWidth=1;
    
    return lineView;
}


//竖着的线
-(UIView *)shuXianWithFrame:(CGRect)frame
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 1, frame.size.height)];
    lineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    lineView.layer.borderWidth=1;
    
    return lineView;
}


/*
 自适应高度的label(多行) 忽略frame的宽和高
 */
-(UILabel *)labelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment
{
    NSDictionary *fontDict = @{NSFontAttributeName:font};
    CGFloat length = [text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil].size.width;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, length, frame.size.height)];
    label.text=text;
    label.numberOfLines=0;
    label.font=font;
    label.textAlignment=alignment;
    label.textColor=textColor;
    label.backgroundColor=bgColor;
    label.layer.borderWidth=0;
    label.layer.borderColor=COLOR_CLEAR.CGColor;
    
    
    return label;
}

//自适应高度的label(一行) 忽略frame的宽 高固定
-(UILabel *)aLabelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment
{
    NSDictionary *fontDict = @{NSFontAttributeName:font};
    CGFloat length = [text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil].size.width;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, length+WZ(5), frame.size.height)];
    label.text=text;
    label.font=font;
    label.textAlignment=alignment;
    label.textColor=textColor;
    label.backgroundColor=bgColor;
    label.layer.borderWidth=0;
    label.layer.borderColor=COLOR_CLEAR.CGColor;
    
    
    return label;
}

//正则判断手机号码格式
+ (BOOL)validateMobile:(NSString *)mobile
{
//    //    电信号段:133/153/180/181/189/177
//    //    联通号段:130/131/132/155/156/185/186/145/176
//    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
//    //    虚拟运营商:170
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    
//    return [regextestmobile evaluateWithObject:mobile];
    
    if (mobile.length==11)
    {
        NSString *MOBILE = @"^[0-9]*$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        BOOL isMobile=[regextestmobile evaluateWithObject:mobile];
        
        if (isMobile==YES)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

//判断邮箱格式
+(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

//判断银行卡号
+(BOOL)validateBankCardNumber:(NSString*)bankCardNumber
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[bankCardNumber length];
    int lastNum = [[bankCardNumber substringFromIndex:cardNoLength-1] intValue];
    
    bankCardNumber = [bankCardNumber substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--)
    {
        NSString *tmpString = [bankCardNumber substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 )
        {
            if((i % 2) == 0)
            {
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }
            else
            {
                oddsum += tmpVal;
            }
        }
        else
        {
            if((i % 2) == 1)
            {
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }
            else
            {
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

//身份证号
+(BOOL)validateIdentityCard:(NSString *)identityCard
{
    if (identityCard.length!=18)
    {
        return NO;
    }
    else
    {
        // 正则表达式判断基本 身份证号是否满足格式
        NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
        NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if(![identityStringPredicate evaluateWithObject:identityCard])
        {
            return NO;
        }
        else
        {
            //** 开始进行校验 *//
            //将前17位加权因子保存在数组里
            NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            //用来保存前17位各自乖以加权因子后的总和
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                idCardWiSum+= subStrIndex * idCardWiIndex;
            }
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            //得到最后一位身份证号码
            NSString *idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return NO;
                }
            }
            else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if(![idCardLast isEqualToString:[idCardYArray objectAtIndex:idCardMod]])
                {
                    return NO;
                }
            }
            return YES;
        }
    }
}

//车牌号验证
+(BOOL)validateCarNum:(NSString *)carNum
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNum];
}

//车型
+(BOOL)validateCarType:(NSString *)carType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:carType];
}

//用户名
+(BOOL)validateUserName:(NSString *)userName
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:userName];
    return B;
}

//密码
+(BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
+(BOOL)validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//字符串MD5加密
+ (NSString *)md5:(NSString *)string
{
    //转换成utf-8
    const char *cString = [string UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[16];
    
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    CC_MD5( cString, (CC_LONG)strlen(cString), result );
    
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

//获取手机型号
+(NSString*)getPhoneModel
{
    NSString* phoneModel = [[UIDevice currentDevice] model];
    
    return phoneModel;
}

//获取屏幕分辨率
+(NSString*)getScreenResolution
{
    //分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width=SCREEN_WIDTH*scale_screen;
    CGFloat height=SCREEN_HEIGHT*scale_screen;
    
    NSString *fenbianlv=[NSString stringWithFormat:@"%.0f*%.0f",width,height];
    
    return fenbianlv;
}

/**
  *  根据生日计算星座
  *
  *  @param month 月份
  *  @param day   日期
  *
  *  @return 星座名称
  */
+(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31)
    {
        return @"错误日期格式!";
    }
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }
    else if(month==4 || month==6 || month==9 || month==11)
    {
        if (day>30)
        {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

/**
 *  计算字符串的size
 *
 *  @param string  字符串内容
 *  @param font    字体大小
 *  @param maxSize 内容所允许的最大大小
 *
 *  @return 字符串大小
 */
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    //如果计算的文字的范围超出了指定的范围,返回的就是指定的范围 如果计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
}

/**
 *  处理发布时间
 *
 *  @param timeStr 传进去一个时间
 *
 *  @return 返回处理后的时间
 */
+ (NSString *)getTimeWithTimeString:(NSString *)timeStr
{
    NSString *latestMessageTime = @"";
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString:timeStr];
    CGFloat nowtimeStr =[date timeIntervalSince1970];
    // NSString *nowtimeStr = [NSString stringWithFormat:@"%f",];
    // NSLog(@"nowtimeStr===%f",nowtimeStr);
    //    if (lastMessage) {
    //        double timeInterval = lastMessage.timestamp ;
    if(nowtimeStr > 140000000000) {
        nowtimeStr = nowtimeStr / 1000;
    }
    
    
    NSDate * nowDate = [NSDate date];
    
    CGFloat time = [nowDate timeIntervalSince1970];
    [formatter setDateFormat:@"dd"];
    NSInteger date1 = [[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowtimeStr]] integerValue];
    NSInteger  newDate = [[formatter stringFromDate:nowDate] integerValue];
    double time3 = (time-nowtimeStr)/60;
    if (newDate<date1) {
        if ((date1-newDate)==1) {
            latestMessageTime = @"昨天";
        }else if((date1-newDate)==2){
            latestMessageTime = @"前天";
        }else{
            [formatter setDateFormat:@"MM-dd"];
            latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowtimeStr]];
            
        }
    }else if (newDate==date1){
        if (time3<1) {
            latestMessageTime = @"刚刚";
        }else if ((time3/60)<24){
            [formatter setDateFormat:@"HH:mm"];
            latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowtimeStr]];
        }
    }else{
        if ((newDate-date1)==1) {
            latestMessageTime = @"昨天";
        }else if((newDate-date1)==2){
            latestMessageTime = @"前天";
        }else{
            [formatter setDateFormat:@"MM-dd"];
            latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nowtimeStr]];
            
        }
        
    }
    
    return latestMessageTime;
}

/**
 *  左右两根线 中间有内容的view
 *
 *  @param frame       view的位置
 *  @param labelString 中间内容
 *  @param font        字体大小
 *  @param color       view的背景
 *
 *  @return 返回一个view
 */
+(UIView*)lineLabelviewWithFrame:(CGRect)frame labelString:(NSString*)labelString font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor
{
    UIView *aView=[[UIView alloc]initWithFrame:frame];
    aView.backgroundColor=backgroundColor;
    
    CGSize labelSize=CGSizeMake(SCREEN_WIDTH*250/IPHONE6_WIDTH, SCREEN_WIDTH*40/IPHONE6_WIDTH);
    NSAttributedString *attributedText=[[NSAttributedString alloc]initWithString:labelString attributes:@{NSFontAttributeName:font}];
    CGRect labelRect=[attributedText boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size=labelRect.size;
    
    UIView *leftLineView=[[UIView alloc]initWithFrame:CGRectMake(0, aView.frame.size.height/2, (aView.frame.size.width-size.width-SCREEN_WIDTH*5/IPHONE6_WIDTH-SCREEN_WIDTH*20/IPHONE6_WIDTH)/2.0, 1)];
    leftLineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    leftLineView.layer.borderWidth=1;
    [aView addSubview:leftLineView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(leftLineView.right+SCREEN_WIDTH*10/IPHONE6_WIDTH, 0, size.width+SCREEN_WIDTH*5/IPHONE6_WIDTH, frame.size.height)];
    label.text=labelString;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=font;
    label.textColor=textColor;
    [aView addSubview:label];
    
    UIView *rightLineView=[[UIView alloc]initWithFrame:CGRectMake(label.right+SCREEN_WIDTH*10/IPHONE6_WIDTH, aView.frame.size.height/2, leftLineView.frame.size.width, 1)];
    rightLineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    rightLineView.layer.borderWidth=1;
    [aView addSubview:rightLineView];
    
    return aView;
}

/**
 *  图片浏览器
 *
 *  @param images     图片路径或者图片数组
 *  @param photoIndex 选择放大的图片索引
 */
+(void)photoBrowserWithImages:(NSArray*)images photoIndex:(NSInteger)photoIndex
{
    EaseMessageReadManager *messageReadManager = [EaseMessageReadManager defaultManager];
    [messageReadManager showBrowserWithImages:images];
    [messageReadManager.photoBrowser setCurrentPhotoIndex:photoIndex];
}

/**
 *  提示框
 *
 *  @param view   提示框所加在的view
 *  @param title  提示框标题
 *  @param detail 提示框子标题
 *
 *  @return 返回一个提示框
 */
-(MBProgressHUD*)MBProgressHUDAddToView:(UIView*)view title:(NSString*)title detail:(NSString*)detail
{
    self.hud=[[MBProgressHUD alloc]initWithView:view];
    self.hud.delegate=self;
    self.hud.color=COLOR(100, 100, 100, 0.8);
//    self.hud.alpha=0.5;
    self.hud.labelText=title;
    self.hud.detailsLabelText=detail;
    [view addSubview:self.hud];
    
    return self.hud;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud=nil;
}

#pragma mark - 监测网络连接
-(void)startMonitorNewWorkWithTarget:(ViewController *)trage
{
    [kNetworkReachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                if (_netStatusBar)
                {
                    [_netStatusBar removeFromSuperview];
                }
                
                [self addNetStatusBar:trage];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [_netStatusBar removeFromSuperview];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [_netStatusBar removeFromSuperview];
                break;
            }
            default:
                break;
        }
    }];
    
    [kNetworkReachability startMonitoring];
}

- (void)addNetStatusBar:(ViewController*)target
{
    _netStatusBar = [[UIView alloc] init];
    _netStatusBar.frame = CGRectMake(0, 0, kScreenWidth, 45);
    _netStatusBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [target.view addSubview:_netStatusBar];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"网络未连接，请检查您的网络设置！";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor whiteColor];
    
    [lab sizeToFit];
    CGFloat labW = lab.width;
    CGFloat labH = lab.height;
    CGFloat labX = _netStatusBar.width/2 - labW/2;
    CGFloat labY = _netStatusBar.height/2 - labH/2;
    lab.frame = CGRectMake(labX, labY, labW, labH);
    [_netStatusBar addSubview:lab];
}

/**
 *  shareSDK第三方分享
 *
 *  @param imageUrlArray 图片URL数组
 *  @param title         分享标题
 *  @param content       分享内容
 *  @param url           点击分享内容跳转到的URL
 */
-(void)shareWithImageUrlArray:(NSArray*)imageUrlArray title:(NSString*)title content:(NSString*)content url:(NSString*)url
{
    UIImage *newImg;
    if (imageUrlArray.count>0)
    {
        NSData *oldData=[NSData dataWithContentsOfURL:[imageUrlArray firstObject]];
        UIImage *oldImg=[UIImage imageWithData:oldData];
        NSData *imgData=[self imageWithImage:oldImg scaledToSize:CGSizeMake(300, 300)];
        newImg=[UIImage imageWithData:imgData];
    }
    else
    {
        newImg=IMAGE(@"");
    }
    
    //1、创建分享参数 （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content images:newImg url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] title:title type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

/**
 *  计算单个文件大小
 *
 *  @param path 传进去一个文件路径
 *
 *  @return 返回文件大小（Mb）
 */
+(CGFloat)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path])
    {
        CGFloat size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    
    return 0;
}

/**
 *  计算文件夹大小
 *
 *  @param path 传进去一个文件夹路径
 *
 *  @return 返回文件夹大小（Mb）
 */
+(CGFloat)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    CGFloat folderSize;
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        
        for (NSString *fileName in childerFiles)
        {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    
    return 0;
}

/**
 *  清理缓存
 *  @param path 传进去一个文件夹路径
 */
+(void)clearCache:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour FromMinute:(NSInteger)fromMin toHour:(NSInteger)toHour toMinute:(NSInteger)toMin
{
    NSDate *fromDate = [self getCustomDateWithHour:fromHour andMinute:fromMin];
    NSDate *toDate = [self getCustomDateWithHour:toHour andMinute:toMin];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:fromDate]==NSOrderedDescending && [currentDate compare:toDate]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:%ld-%ld:%ld 之间！", (long)fromHour, (long)fromMin, (long)toHour, (long)toMin);
        
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //以下代码测试用
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:currentDate];
    NSDate *currentDate0 = [currentDate dateByAddingTimeInterval:time];
    NSLog(@"当前时间===%@",currentDate0);
    
    return [resultCalendar dateFromComponents:resultComps];
}



/**
 *  是否注册时候的片区
 *
 *  @return 是否注册时候的片区
 */
+(BOOL)ifRegisterArea
{
    NSString *areaId0=[UserInfoData getUserInfoFromArchive].areaId;
    
    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
    NSFileManager *manager=[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        NSDictionary *areaDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
        NSString *areaId1=[areaDict objectForKey:@"areaId"];
        if ([areaId0 isEqualToString:areaId1])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
}













#pragma mark ===地图===

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
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    NSLog(@"纬度：%f,经度：%f,海拔：%f,速度：%f",_lastCoordinate.latitude,_lastCoordinate.longitude,location.altitude,location.speed);
    
    CLLocationCoordinate2D coordinate=location.coordinate;
    CGFloat lat=coordinate.latitude;
    CGFloat lon=coordinate.longitude;
    self.latitude=lat;
    self.longitude=lon;
    
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
            //            NSString *address=[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
            //详细地址
            NSString *detailAddress=[NSString stringWithFormat:@"%@%@%@%@",province,city,area,street];
            
//            NSLog(@"定位地址===%@",addressDictionary);
            
            NSString *casAddress=[NSString stringWithFormat:@"%@%@%@",city,area,street];
            NSMutableDictionary *addressDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:casAddress,@"address", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"casAddress" object:self userInfo:addressDict];
            
            
//                        NSMutableDictionary *addressDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:address,@"address",[NSString stringWithFormat:@"%f",lat],@"lat",[NSString stringWithFormat:@"%f",lon],@"lon",state,@"province",city,@"city",subLocality,@"region",street,@"street", nil];
//            
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"address" object:self userInfo:addressDict];
//            
//                        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"address.plist"];
//                        [addressDict writeToFile:filePath atomically:YES];
        }
    }];

    
}












//#pragma mark ===地图===
//
//-(CLGeocoder *)geocoder
//{
//    if (_geocoder==nil)
//    {
//        _geocoder=[[CLGeocoder alloc]init];
//    }
//    
//    return _geocoder;
//}
//
////初始化定位管理器
//-(void)initLocationManager
//{
//    //定位管理器
//    _locationManager=[[CLLocationManager alloc]init];
//    //获取授权认证
//    [_locationManager requestAlwaysAuthorization];
//    [_locationManager requestWhenInUseAuthorization];
//    //设置代理
//    _locationManager.delegate=self;
//    //设置定位精度
//    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
//    //定位频率,每隔多少米定位一次
//    CLLocationDistance distance=10.0;//十米定位一次
//    _locationManager.distanceFilter=distance;
//    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    //启动跟踪定位
//    [_locationManager startUpdatingLocation];
//    
//}
//
//#pragma mark ===CLLocationManagerDelegate===
//
////跟踪定位代理方法，每次位置发生变化即会执行
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *lastLocation=[locations lastObject];
//    _lastCoordinate=lastLocation.coordinate;
//    //    NSLog(@"纬度：%f,经度：%f,海拔：%f,速度：%f",_lastCoordinate.latitude,_lastCoordinate.longitude,lastLocation.altitude,lastLocation.speed);
//    
//    CLLocationCoordinate2D coordinate=lastLocation.coordinate;
//    CGFloat lat=coordinate.latitude;
//    CGFloat lon=coordinate.longitude;
//    
//    self.latitude=lat;
//    self.longitude=lon;
//    
//    CLLocation *location=[[CLLocation alloc]initWithLatitude:lat longitude:lon];
//    //2.反地理编码
//    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error||placemarks.count==0)
//        {
//            //            NSLog(@"未知地点");
//        }
//        else//编码成功
//        {
//            //显示最前面的地标信息
//            CLPlacemark *firstPlacemark=[placemarks firstObject];
//            
//            NSDictionary *addressDictionary=firstPlacemark.addressDictionary;
//            
//            //省
//            NSString *province=[addressDictionary objectForKey:@"State"];
//            //市
//            NSString *city=[addressDictionary objectForKey:@"City"];
//            //区
//            NSString *area=[addressDictionary objectForKey:@"SubLocality"];
//            //街道
//            NSString *street=[addressDictionary objectForKey:@"Street"];
//            //省市区
////            NSString *address=[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
//            //详细地址
//            NSString *detailAddress=[NSString stringWithFormat:@"%@%@%@%@",province,city,area,street];
//            
//            NSLog(@"定位地址===%@",addressDictionary);
//            
//            NSString *casAddress=[NSString stringWithFormat:@"%@%@%@",city,area,street];
//            NSMutableDictionary *addressDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:casAddress,@"address", nil];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"casAddress" object:self userInfo:addressDict];
//            
//            
////            NSMutableDictionary *addressDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:address,@"address",[NSString stringWithFormat:@"%f",lat],@"lat",[NSString stringWithFormat:@"%f",lon],@"lon",state,@"province",city,@"city",subLocality,@"region",street,@"street", nil];
////            
////            [[NSNotificationCenter defaultCenter]postNotificationName:@"address" object:self userInfo:addressDict];
////            
////            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"address.plist"];
////            [addressDict writeToFile:filePath atomically:YES];
//        }
//    }];
//
//}
//
////定位出错
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    if (error.code == kCLErrorDenied)
//    {
//        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
//        
//        NSLog(@"定位错误信息====%ld",(long)error.code);
//        
//        
//    }
//}





-(UIView *)creatDoneView{
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    mainView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 0, 100, 30)];
    [doneButton setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = FONT(16, 14);
    [doneButton addTarget:self action:@selector(topUpTFDonBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:doneButton];
    return mainView;
}
-(void)topUpTFDonBtnClicked{
    [self.view endEditing:YES];
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
