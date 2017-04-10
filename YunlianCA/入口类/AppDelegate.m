//
//  AppDelegate.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AppDelegate.h"
// iOS10注册APNs所需头文件
//#import <UserNotifications/UNUserNotificationCenter.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"

#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "AddFriendViewController.h"
#import "WelcomeController.h"
#import <RongCloudIMKit/RongIMLib/RCMessage.h>
#import "MessageSystemVC.h"
#import "RedEnvelopeSquareViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<UIAlertViewDelegate,WXApiDelegate,JPUSHRegisterDelegate,RCConnectionStatusChangeDelegate,RCIMConnectionStatusDelegate>//,RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupUserInfoDataSource

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *hongbao;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.hongbao=@"no";
//    //主目录
//    NSString *path = NSHomeDirectory();
//    NSLog(@"沙盒目录:\n%@",path);
    
    //如需远程推送 用户信息提供者写在此类 否则可以写在聊天类
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
//    [[RCIM sharedRCIM] setGroupUserInfoDataSource:self];
    
    /**
     * 推送处理1
     */
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    { // iOS8
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    [self registJGPushWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedHongbaoNotification:) name:@"hongbao" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidReceiveMessage:)
                                                 name:kJPFNetworkDidReceiveMessageNotification
                                               object:nil];

    //第三方IQKeyboardManager
    IQKeyboardManager *keyManager = [IQKeyboardManager sharedManager];
    keyManager.enable = YES;
    keyManager.shouldResignOnTouchOutside = YES;
    keyManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyManager.enableAutoToolbar = NO;
    
    
    
    /**
     *  融云
     */
    [[RCIM sharedRCIM] initWithAppKey:@"n19jmcy595bt9"];
    //添加收到融云消息的监听
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"])
    {
        WelcomeController *vc=[[WelcomeController alloc]init];
        self.window.rootViewController=vc;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
    }
    else
    {
        NSFileManager *manager=[NSFileManager defaultManager];
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isThird.plist"];
        if ([manager fileExistsAtPath:path])
        {
            NSDictionary *isThirdLoginDict=[NSDictionary dictionaryWithContentsOfFile:path];
            NSString *isThird=[isThirdLoginDict objectForKey:@"isThird"];
            if ([isThird isEqualToString:@"是"])
            {
                //是第三方登录 连接融云服务器
                self.token=[UserInfoData getUserInfoFromArchive].token;
                [self connectRongYunServer];
                
                TabBarViewController *vc=[[TabBarViewController alloc]init];
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                self.window.rootViewController=nav;
                self.window.backgroundColor=COLOR_WHITE;
                NSLog(@"第三方登录");
            }
            if ([isThird isEqualToString:@"否"])
            {
                NSLog(@"非第三方登录");
                NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ifLogin.plist"];
                
                if ([manager fileExistsAtPath:filePath])
                {
                    NSDictionary *ifLoginDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
                    if (![ifLoginDict isEqual:[NSNull null]])
                    {
                        NSString *ifLogin=[ifLoginDict objectForKey:@"ifLogin"];
                        if ([ifLogin isEqualToString:@"L"])
                        {
                            NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
                            NSDictionary *loginDict=[NSDictionary dictionaryWithContentsOfFile:path];
                            [HTTPManager loginWithName:[loginDict objectForKey:@"name"] password:[loginDict objectForKey:@"password"] complete:^(User *user) {
                                if ([user.result isEqualToString:STATUS_SUCCESS])
                                {
                                    NSString *filePath3=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
                                    NSMutableDictionary *dict3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.areaName,@"area",user.areaId,@"areaId", nil];
                                    [dict3 writeToFile:filePath3 atomically:YES];
                                    
                                    self.token=user.token;
                                    //保存融云用户id和token
                                    NSString *path = [[NSBundle mainBundle] pathForResource:@"rongyunToken" ofType:@"plist"];
                                    NSMutableDictionary *rongyunDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.userId,@"userId",user.token,@"token", nil];
                                    [rongyunDict writeToFile:path atomically:YES];
                                    
                                    [self connectRongYunServer];
                                    
                                    NSString *filePath4=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"registrationID.plist"];
                                    NSDictionary *dict4=[NSDictionary dictionaryWithContentsOfFile:filePath4];
                                    NSString *registrationID=[dict4 objectForKey:@"registrationID"];
                                    //极光推送绑定设备号
                                    [HTTPManager uploadDeviceTokenUserId:user.userId jgCode:registrationID complete:^(NSDictionary *resultDict) {
                                        
                                    }];
                                    
                                    
                                    TabBarViewController *vc=[[TabBarViewController alloc]init];
                                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                                    self.window.rootViewController=nav;
                                    self.window.backgroundColor=COLOR_WHITE;
                                }
                                else
                                {
                                    LoginViewController *vc=[[LoginViewController alloc]init];
                                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                                    self.window.rootViewController=nav;
                                    self.window.backgroundColor=COLOR_WHITE;
                                    
                                    [self.window makeToast:user.msg duration:2.0];
                                }
                            }];
                        }
                        if ([ifLogin isEqualToString:@"E"])
                        {
                            LoginViewController *vc=[[LoginViewController alloc]init];
                            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                            self.window.rootViewController=nav;
                            self.window.backgroundColor=COLOR_WHITE;
                        }
                    }
                    else
                    {
                        LoginViewController *vc=[[LoginViewController alloc]init];
                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                        self.window.rootViewController=nav;
                        self.window.backgroundColor=COLOR_WHITE;
                    }
                }
                else
                {
                    LoginViewController *vc=[[LoginViewController alloc]init];
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                    self.window.rootViewController=nav;
                    self.window.backgroundColor=COLOR_WHITE;
                }
            }
        }
        else
        {
            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ifLogin.plist"];
            
            if ([manager fileExistsAtPath:filePath])
            {
                NSDictionary *ifLoginDict=[NSDictionary dictionaryWithContentsOfFile:filePath];
                if (![ifLoginDict isEqual:[NSNull null]])
                {
                    NSString *ifLogin=[ifLoginDict objectForKey:@"ifLogin"];
                    if ([ifLogin isEqualToString:@"L"])
                    {
                        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
                        NSDictionary *loginDict=[NSDictionary dictionaryWithContentsOfFile:path];
                        [HTTPManager loginWithName:[loginDict objectForKey:@"name"] password:[loginDict objectForKey:@"password"] complete:^(User *user) {
                            if ([user.result isEqualToString:STATUS_SUCCESS])
                            {
                                NSString *filePath3=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"area.plist"];
                                NSMutableDictionary *dict3=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.areaName,@"area",user.areaId,@"areaId", nil];
                                [dict3 writeToFile:filePath3 atomically:YES];
                                
                                self.token=user.token;
                                //保存融云用户id和token
                                NSString *path = [[NSBundle mainBundle] pathForResource:@"rongyunToken" ofType:@"plist"];
                                NSMutableDictionary *rongyunDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:user.userId,@"userId",user.token,@"token", nil];
                                [rongyunDict writeToFile:path atomically:YES];
                                
                                [self connectRongYunServer];
                                
                                NSString *filePath4=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"registrationID.plist"];
                                NSDictionary *dict4=[NSDictionary dictionaryWithContentsOfFile:filePath4];
                                NSString *registrationID=[dict4 objectForKey:@"registrationID"];
                                //极光推送绑定设备号
                                [HTTPManager uploadDeviceTokenUserId:user.userId jgCode:registrationID complete:^(NSDictionary *resultDict) {
                                    
                                }];
                                
                                TabBarViewController *vc=[[TabBarViewController alloc]init];
                                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                                self.window.rootViewController=nav;
                                self.window.backgroundColor=COLOR_WHITE;
                            }
                            else
                            {
                                LoginViewController *vc=[[LoginViewController alloc]init];
                                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                                self.window.rootViewController=nav;
                                self.window.backgroundColor=COLOR_WHITE;
                                
                                [self.window makeToast:user.msg duration:2.0];
                            }
                        }];
                    }
                    if ([ifLogin isEqualToString:@"E"])
                    {
                        LoginViewController *vc=[[LoginViewController alloc]init];
                        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                        self.window.rootViewController=nav;
                        self.window.backgroundColor=COLOR_WHITE;
                    }
                }
                else
                {
                    LoginViewController *vc=[[LoginViewController alloc]init];
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                    self.window.rootViewController=nav;
                    self.window.backgroundColor=COLOR_WHITE;
                }
            }
            else
            {
                LoginViewController *vc=[[LoginViewController alloc]init];
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                self.window.rootViewController=nav;
                self.window.backgroundColor=COLOR_WHITE;
            }
        }
        NSLog(@"不是第一次启动");
    }
    
    
    
    
    

    
    
    /**
     *  高德地图
     */
    //配置用户Key(测试版)
//    [AMapServices sharedServices].apiKey = @"6bcbc84c5d895498ea3f790600396213";
    //配置用户Key(正式版)
    [AMapServices sharedServices].apiKey = @"c52641e5ba4da017129ffa8be10e910e";
    
//    [AMapSearchServices sharedServices].apiKey = @"7f7789bb8b2e1f179c033ce56c3a5632";
    
    
    /**
     *  shareSDK第三方分享
     */
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"16284281708d0"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
    onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3750661816"
                                           appSecret:@"3e48eb00677946ad681467b2de8b6d53"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx2503d1cf5b942d99"
                                       appSecret:@"0c41940036d1b10d24d15dfcb23be006"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105551217"
                                      appKey:@"JHZT0uRUv0d2xMaf"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    [WXApi registerApp:@"wx2503d1cf5b942d99" withDescription:@"云联社区联盟"];
    
    
    
    // 如果此时 App 已经被系统冻结 在-application:didFinishLaunchingWithOptions: 即此方法中获取远程推送内容 如果app没有被冻结在- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo中获取远程推送消息
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSLog(@"APP已被冻结获取到的远程推送信息===%@",remoteNotificationUserInfo);
    
    // 如果此时 App 已经被系统冻结 此方法中获取本地通知的内容
    UILocalNotification *localNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    NSLog(@"APP已被冻结获取到的本地推送信息===%@",localNotification.userInfo);
    
    
    
    //极光推送 //uid:8046666751   registrationID:191e35f7e04a6c912a0
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续旧的注册方式
   
    
    
    
       return YES;
}
-(void)registJGPushWithOptions:(NSDictionary *)launchOptions{
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    BOOL isProudct;
#if DEBUG
    isProudct = NO;
#else
    isProudct = YES;
#endif
    [JPUSHService setupWithOption:launchOptions appKey:@"1d2719afb161bba1a38053c3"
                          channel:nil
                 apsForProduction:isProudct
            advertisingIdentifier:advertisingId];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"registrationID.plist"];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:registrationID,@"registrationID", nil];
        [dict writeToFile:filePath atomically:YES];
        
        if ([UserInfoData getUserInfoFromArchive].userId!=nil && ![[UserInfoData getUserInfoFromArchive].userId isEqualToString:@""])
        {
            [HTTPManager uploadDeviceTokenUserId:[UserInfoData getUserInfoFromArchive].userId jgCode:registrationID complete:^(NSDictionary *resultDict) {
                
            }];
        }

       NSLog(@"registrationID获取成功：%@",registrationID);
    }];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
}
//红包界面通知
-(void)receivedHongbaoNotification:(NSNotification*)notification
{
    NSDictionary *dict=[notification userInfo];
    self.hongbao=[dict objectForKey:@"isHongbaoSquareVC"];
//    if ([hongbao isEqualToString:@"yes"])
//    {
//        //进入红包广场关闭推送
//        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
//    }
//    if ([hongbao isEqualToString:@"no"])
//    {
//        //退出红包广场开启推送
//        //系统推送
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        //极光推送
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
//    }
    
}



//连接融云服务器
-(void)connectRongYunServer
{
    static NSInteger index = 0;
    index++;
    [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId) {
        index = 0;
        NSLog(@"融云服务器连接成功。当前登录的用户ID：%@", userId);
        [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    } error:^(RCConnectErrorCode status) {
        
        if (index<4) {
            [self connectRongYunServer];
        }
        
       
        NSLog(@"融云服务器连接失败的错误码为:%ld", (long)status);
        
    } tokenIncorrect:^{
        
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"status==%ld",(long)status);
    if (status==ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"当前账号在别的设备登录！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        alertView.tag = 1000;
        [alertView show];
    }else if (status==ConnectionStatus_NETWORK_UNAVAILABLE){
        [self.window makeToast:@"当前网络不可用！" duration:2];
    }
}
////融云聊天信息
//- (void)didReceiveMessageNotification:(NSNotification *)notification
//{
////    RCMessage *message=notification.object;
////    RCMessageContent *content=message.content;
//    RCTextMessage *message=notification.object;
//    NSLog(@"融云聊天信息===%@",message);
//    
//}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // register to receive notifications
    [application registerForRemoteNotifications];
    
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"设备token===%@",deviceToken);
    
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [JPUSHService registerDeviceToken:deviceToken];
    });
        
} 

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
//{
//    //应用在前台收到通知
//    NSLog(@"应用在前台收到通知========%@", notification);
//    
//}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    //点击通知进入应用
    NSLog(@"点击通知进入应用:%@", response);
    
}

//app存活的时候在此方法获取远程推送信息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  
    [self getNotification:userInfo];
    //    application.applicationIconBadgeNumber=type;
    
    
    //极光推送
    [JPUSHService handleRemoteNotification:userInfo];
}
-(void)getNotification:(NSDictionary *)userInfo{
    NSDictionary *apsDict=[userInfo objectForKey:@"aps"];
    NSString *name=[apsDict objectForKey:@"alert"];
    NSInteger type=[[apsDict objectForKey:@"badge"] integerValue];
    NSLog(@"didReceiveRemoteNotification===%@",userInfo);
    if (type==1)
    {
        //加好友信息
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"好友信息" message:name delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即查看", nil];
        alertView.tag=100;
        [alertView show];
    }
    if (type==2)
    {
        //系统消息
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"系统消息" message:name delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"立即查看", nil];
        alertView.tag=101;
        [alertView show];
    }

}
//app存活的时候在此方法获取本地推送信息
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // notification为本地通知的内容
    NSLog(@"本地推送的内容===%@",notification.userInfo);
    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==1)
        {
            //这个东西是一个辨别标示，在跳转到指定页面后拿到[pushJudge setObject:@"push" forKey:@"push"];从而可以知道是通过推送消息跳转过来的还是正常情况下通过导航栏导航过来的！
            NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
            [pushJudge setObject:@"friend" forKey:@"friend"];
            [pushJudge synchronize];
            
            //跳转到加好友界面
            AddFriendViewController *vc=[[AddFriendViewController alloc]init];
            UINavigationController *pushNav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.window.rootViewController presentViewController:pushNav animated:YES completion:^{
                
            }];
        }
    }
    if (alertView.tag==101)
    {
        if (buttonIndex==1)
        {
            //这个东西是一个辨别标示，在跳转到指定页面后拿到[pushJudge setObject:@"push" forKey:@"push"];从而可以知道是通过推送消息跳转过来的还是正常情况下通过导航栏导航过来的！
            NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
            [pushJudge setObject:@"system" forKey:@"system"];
            [pushJudge synchronize];
            
            //跳转到系统消息界面
            MessageSystemVC *vc=[[MessageSystemVC alloc]init];
            UINavigationController *pushNav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.window.rootViewController presentViewController:pushNav animated:YES completion:^{
                
            }];
        }
    }
    if (alertView.tag==102)
    {
        if (buttonIndex==1)
        {
            //这个东西是一个辨别标示，在跳转到指定页面后拿到[pushJudge setObject:@"push" forKey:@"push"];从而可以知道是通过推送消息跳转过来的还是正常情况下通过导航栏导航过来的！
            NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
            [pushJudge setObject:@"hongbao" forKey:@"hongbao"];
            [pushJudge synchronize];
            
            //跳转到红包广场界面
            RedEnvelopeSquareViewController *vc=[[RedEnvelopeSquareViewController alloc]init];
            UINavigationController *pushNav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.window.rootViewController presentViewController:pushNav animated:YES completion:^{
                
            }];
        }
    }
    //加好友
    if (alertView.tag==1000) {
        LoginViewController *vc=[[LoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController=nav;
        self.window.backgroundColor=COLOR_WHITE;
        
    }
}

//微信支付
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
    
}
-(BOOL)application:(UIApplication*)app openURL:(NSURL*)url options:(NSDictionary<NSString *,id> *)options
{
    /*
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    if ([url.host isEqualToString:@"safepay"]) {
        //这个是进程KILL掉之后也会调用，这个只是第一次授权回调，同时也会返回支付信息
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [self AlipayWithResutl:resultDic];
        }];
        //跳转支付宝钱包进行支付，处理支付结果，这个只是辅佐订单支付结果回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self AlipayWithResutl:resultDic];
        }];
        
    }else if ([url.host isEqualToString:@"platformapi"]){
        //授权返回码
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self AlipayWithResutl:resultDic];
        }];
    }
    return  [WXApi handleOpenURL:url delegate:self];
}
-(void)AlipayWithResutl:(NSDictionary *)resultDic{
    NSString  *str = [resultDic objectForKey:@"resultStatus"];
    if (str.intValue == 9000)
    {
        // 支付成功
        //通过通知中心发送通知
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"ali_success",@"resoult", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:nil userInfo:userInfo];
    }
    else
    {
        //通过通知中心发送通知
        NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"fail",@"resoult", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResult" object:nil userInfo:userInfo];
    }
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"wx2503d1cf5b942d99"])
    {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    
    return YES;
}

#pragma mark 微信回调方法
-(void)onResp:(BaseResp*)resp
{
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    NSLog(@"strMsg: %@",strMsg);
    
    NSString * errStr       = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
    NSLog(@"errStr: %@",errStr);
    
    NSString * strTitle;
    //判断是微信消息的回调 --> 是支付回调回来的还是消息回调回来的.
    if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
    }
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode)
        {
            case WXSuccess:
            {
                strMsg = @"支付结果:";
                NSLog(@"支付成功: %d",resp.errCode);
                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户取消了支付";
                NSLog(@"用户取消支付: %d",resp.errCode);
                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
                NSLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
                wxPayResult = @"faile";
                break;
            }
        }
//        //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
//        NSNotification * notification = [NSNotification notificationWithName:@"WXPay" object:wxPayResult];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"已登录");
}
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//当APP正在吊起使用当中是调用前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"当APP正在吊起使用当中是调用前台%@",userInfo);
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        [self getNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
//点击通知栏中的通知时调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"当APP正在吊起使用当中是调用前台");
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        [self getNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
//极光推送收到的信息
-(void)networkDidReceiveMessage:(NSNotification *)notification
{

    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"networkDidReceiveMessage==%@",userInfo);
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extrasDict = [userInfo valueForKey:@"extras"];
    NSString * type = extrasDict[@"type"];
    NSString *theme = [extrasDict valueForKey:@"theme"]==nil?@"":[[extrasDict valueForKey:@"theme"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([type isEqualToString:@"addFriend"]) {
         UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:content message:theme delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去查看", nil];
        self.notInfo =userInfo;
        alertView.tag = 100;
        [alertView show];
    }else{
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:content message:theme delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去领取", nil];
        alertView.tag=102;
        [alertView show];
    }

}

//-(void)createLocalNotification{
//    
//    
//    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    
//    NSDate *pushDate = [NSDate date];
//    
//    if (notification != nil) {
//        
//    notification.fireDate = pushDate;
//        
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//        
//    notification.repeatInterval = 0;
//        
//    notification.soundName = UILocalNotificationDefaultSoundName;
//        
//    notification.alertBody = @"您有一条新消息";
//    
//        
//        UIApplication *app = [UIApplication sharedApplication];
//        
//        
//        [app scheduleLocalNotification:notification];
//        
//    }
//}











//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
//{
////    NSLog(@"聊天界面用户id===%@",userId);
//    if (![userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
//    {
//        [HTTPManager getUserInfoWithUserId:userId complete:^(User *user) {
//            if ([user.result isEqualToString:STATUS_SUCCESS])
//            {
//                NSString *imgUrlString=user.headImage;
//                NSString *imgUrl;
//                if ([imgUrlString containsString:@"http://"])
//                {
//                    imgUrl=imgUrlString;
//                }
//                else
//                {
//                    imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
//                }
//                RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:user.userId name:user.nickname portrait:imgUrl];
//                completion(userInfo);
//            }
//        }];
//    }
//    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
//    {
//        User *myUserInfo=[UserInfoData getUserInfoFromArchive];
//        NSString *imgUrlString=myUserInfo.headImage;
//        NSString *imgUrl;
//        if ([imgUrlString containsString:@"http://"])
//        {
//            imgUrl=imgUrlString;
//        }
//        else
//        {
//            imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
//        }
//        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:myUserInfo.userId name:myUserInfo.nickname portrait:imgUrl];
//        completion(userInfo);
//    }
//}
//
//- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *userInfo))completion
//{
//    if (![userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
//    {
//        [HTTPManager groupInfoWithUserId:userId groupId:groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
//            NSString *result=[resultDict objectForKey:@"result"];
//            if ([result isEqualToString:STATUS_SUCCESS])
//            {
//                NSDictionary *listDict=[resultDict objectForKey:@"list"];
//                NSArray *userArray=[listDict objectForKey:@"data"];
//                
//                for (NSInteger i=0; i<userArray.count; i++)
//                {
//                    NSDictionary *userDict=userArray[i];
//                    NSString *userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
//                    NSString *nickname=[userDict objectForKey:@"nickname"];
//                    NSString *headimg=[userDict objectForKey:@"headimg"];
//                    
//                    NSString *imgUrlString=headimg;
//                    NSString *imgUrl;
//                    if ([imgUrlString containsString:@"http://"])
//                    {
//                        imgUrl=imgUrlString;
//                    }
//                    else
//                    {
//                        imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
//                    }
//                    
//                    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:nickname portrait:imgUrl];
//                    completion(userInfo);
//                }
//            }
//        }];
//    }
//    if ([userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
//    {
//        User *myUserInfo=[UserInfoData getUserInfoFromArchive];
//        NSString *imgUrlString=myUserInfo.headImage;
//        NSString *imgUrl;
//        if ([imgUrlString containsString:@"http://"])
//        {
//            imgUrl=imgUrlString;
//        }
//        else
//        {
//            imgUrl=[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString];
//        }
//        
//        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:myUserInfo.userId name:myUserInfo.nickname portrait:imgUrl];
//        completion(userInfo);
//    }
//}
//
//- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion
//{
//    //    NSLog(@"消息列表的群id===%@",groupId);
//    [HTTPManager groupInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
//        NSString *result=[resultDict objectForKey:@"result"];
//        if ([result isEqualToString:STATUS_SUCCESS])
//        {
//            NSDictionary *groupInfoDict=[resultDict objectForKey:@"imGroup"];
//            NSString *groupId=[NSString stringWithFormat:@"%@",[groupInfoDict objectForKey:@"id"]];
//            NSString *groupName=[groupInfoDict objectForKey:@"name"];
//            NSString *groupImg=[groupInfoDict objectForKey:@"img"];
//            
//            RCGroup *groupInfo=[[RCGroup alloc]initWithGroupId:groupId groupName:groupName portraitUri:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,groupImg]];
//            
//            completion(groupInfo);
//        }
//    }];
//}















- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterForeground" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    
    
    
}

@end
