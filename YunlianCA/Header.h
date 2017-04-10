//
//  Header.h
//  ZZQ
//
//  Created by QinJun on 15/11/16.
//  Copyright © 2015年 QinJun. All rights reserved.
//

#ifndef Header_h
#define Header_h




#define IPHONE6_WIDTH 375.0
#define IPHONE6_HEIGHT 667.0
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define WZ(wz) SCREEN_WIDTH*(wz)/IPHONE6_WIDTH



//宏定义图片
#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//宏定义RGB颜色
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//导航条颜色
#define COLOR_NAVIGATION [UIColor colorWithRed:251/255.0 green:250/255.0 blue:252/255.0 alpha:1]
//区头和背景view颜色
#define COLOR_HEADVIEW [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]





//颜色
#define COLOR_CYAN [UIColor cyanColor]
#define COLOR_CLEAR [UIColor clearColor]
#define COLOR_WHITE [UIColor whiteColor]
#define COLOR_LIGHTGRAY [UIColor lightGrayColor]
#define COLOR_BLACK [UIColor blackColor]
#define COLOR_RED [UIColor redColor]
#define COLOR_YELLOW [UIColor yellowColor]
#define COLOR_BLUE [UIColor blueColor]
#define COLOR_ORANGE [UIColor orangeColor]
#define COLOR_GREEN [UIColor greenColor]

//字体大小
#define Font(font) [UIFont systemFontOfSize:font]
#define FONT(FontB,FontS) ([UIScreen mainScreen].bounds.size.width > 320? [UIFont systemFontOfSize:FontB]:[UIFont systemFontOfSize:FontS])


//宏定义距离
#define SPACE_LEFTMARGIN SCREEN_WIDTH*30/IPHONE6_WIDTH







//返回成功状态码
#define STATUS_SUCCESS @"ok"
#define STATUS_FAILURE @"error"

#if 0
//本地服务器地址
#define HOST @"http://192.168.1.228:8090/shequ/app/"
#define HOSTIMAGE @"http://192.168.1.228:8080/"

#elif 1
//云服务器地址
#define HOST @"http://app.ylsqlm.com/shequ/app/"
#define HOSTIMAGE @"http://app.ylsqlm.com:8080/"

#else
//测试服务器地址
#define HOST @"http://101.201.121.59:8090/shequ/app/"
#define HOSTIMAGE @"http://app.ylsqlm.com:8080/"
#endif











////弹出信息
//#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]



#define NSNumWithUnsignedInteger(u)             ([NSNumber numberWithUnsignedInteger:u])
#define NSNumWithInt(i)                         ([NSNumber numberWithInt:i])
#define NSNumWithInteger(i)                     ([NSNumber numberWithInteger:i])
#define NSNumWithFloat(f)                       ([NSNumber numberWithFloat:f])
#define NSNumWithBool(b)                        ([NSNumber numberWithBool:b])

#define ContinueIf(expr)            if ((expr))  { continue;     }
#define ContinueIf(expr)            if ((expr))  { continue;     }
#define BreakIf(expr)               if ((expr))  { break;        }
#define ReturnIf(expr)              if ((expr))  { return;       }
#define ReturnValIf(expr, val)      if ((expr))  { return (val); }
#define ContinueIfNot(expr)         if (!(expr)) { continue;     }
#define BreakIfNot(expr)            if (!(expr)) { break;        }
#define ReturnIfNot(expr)           if (!(expr)) { return;       }
#define ReturnValIfNot(expr, val)   if (!(expr)) { return (val); }

// 自身弱引用
#define WEAK_SELF()  __weak __typeof(self) weakSelf = self;
// 使用__block来修饰在Block中实用的对象,仍然会被retain
#define BLOCK_SELF()  __block __typeof(self) blockSelf = self;

// 版本号
#define IOS_VERSION_6_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)? (YES):(NO))
#define IOS_VERSION_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#define IOS_VERSION_8_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)




/*
 *  HTTPManager
 */
#import "HTTPManager.h"
#import "Model.h"
#import "User.h"
#import "UserInfoData.h"
#import "StoreModel.h"
#import "ArticleModel.h"
#import "AroundModel.h"
#import "OrderModel.h"




/**
 *  自写类
 */
#import "UserHeadView.h"
#import "ArticleBottomView.h"
#import "EditNewArticleViewController.h"
#import "ArticleSearchViewController.h"
#import "StoreSearchViewController.h"
#import "EditNewArticleViewController.h"





/**
 *  拓展类
 */
//#import <UIKit/UIKit.h>

#import "UIView+View.h"
#import "UIView+YYAdd.h"
#import "UIView+Toast.h"
#import "UILabel+Label.h"
#import "NSString+String.h"
#import "UIView+View.h"
#import "UITextField+TextField.h"
#import "UIView+Toast.h"
#import "UIScrollView+LH.h"
#import "UIImage+LH.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


/**
 *  第三方
 */
#import "MJRefresh.h"
#import "ImagePlayerView.h"
#import "YYKit.h"
#import "YYTextView.h"
#import "JSONKit.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"



/**
 *  shareSDK分享
 */
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件 新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "WeiboSDK.h"


/**
 *  高德地图
 */
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


/**
 *  融云即时通讯
 */
#import <RongIMKit/RongIMKit.h>
//#import "RCConversationDetailsVC.h"
//#import <RongCloudIMKit/RongIMLib/RCIMClient.h>

/**
 *  第三方支付
 */
#import "WXApi.h"


///**
// *  个推
// */
//#define GeTuiAppId @"g3gxnaH5lK7leoBnLbw956"
//#define GeTuiAppKey @"wVECIx5r44AT0kQDBmIbA3"
//#define GeTuiAppSecret @"FP21uvvtcf7LkB5L6sKJY8"
//
//#import "GeTuiSdk.h"
//
//
//
//
//
//
//
///**
// *  YYKit
// */
//#import "YYKit.h"
//#import "NSAttributedString+YYText.h"
//#import "NSString+YYAdd.h"



/**
 *  图片浏览
 */
#import "QBImagePickerController.h"
#import "ChooseImagesViewController.h"
#import "EaseMessageReadManager.h"
#import "MBProgressHUD.h"



#endif /* Header_h */
