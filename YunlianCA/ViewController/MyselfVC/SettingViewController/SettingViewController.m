//
//  SettingViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/15.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "SettingViewController.h"

#import "LoginViewController.h"
#import "SuggestionViewController.h"
#import "SettingDetailViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)UISwitch *pushSwitch;
@property(nonatomic,strong)NSString *cacheSizeString;
@property(nonatomic,strong)UILabel *cacheLabel;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)UILabel *mobileLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mobile=@"";
    
    NSString *isPush=[UserInfoData getUserInfoFromArchive].isPush;
    if ([isPush isEqualToString:@"0"])
    {
        self.isPush=YES;
    }
    if ([isPush isEqualToString:@"1"])
    {
        self.isPush=NO;
    }
    
    self.cacheSizeString=@"0.00 M";
    
    [self createNavigationBar];
    [self createTableView];
    
//    User *user=[UserInfoData getUserInfoFromArchive];
//    NSLog(@"isPush===%@",user.isPush);
//    NSLog(@"merId===%@",user.merchantId);
    
}


-(void)getCacheSize
{
    //定义变量存储总的缓存大小
    CGFloat sumSize = 0;
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    //遍历所有子文件
    for (NSString *subPath in subPaths)
    {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        CGFloat fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    
    CGFloat size_m = sumSize/(1024*1024);
    
    NSLog(@"缓存大小===%f",size_m);
    
    if (size_m==0)
    {
        self.cacheSizeString=@"0.00 M";
    }
    else
    {
        self.cacheSizeString=[NSString stringWithFormat:@"%.2f M",size_m];
    }
}

//获取客服热线
-(void)getHotLines
{
    [HTTPManager getHotLines:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.mobile=[resultDict objectForKey:@"cusPhone"];
            self.mobileLabel.text=self.mobile;
            [_tableView reloadData];
        }
        else
        {
            self.mobile=@"";
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getCacheSize];
    [self getHotLines];
//    [self remoteNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"设置";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return 3;
    }
    if (section==2)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
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
        
        cell.textLabel.text=@"消息推送";
        cell.textLabel.font=FONT(17, 15);
        
        UISwitch *pushSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(50), WZ(10), WZ(50), WZ(30))];
        pushSwitch.onTintColor=COLOR(254, 153, 160, 1);
        [pushSwitch addTarget:self action:@selector(pushSwitchClick:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView=pushSwitch;
        self.pushSwitch=pushSwitch;
        
        if (self.isPush==NO)
        {
            [pushSwitch setOn:NO];
        }
        if (self.isPush==YES)
        {
            [pushSwitch setOn:YES];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
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
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"客服热线",@"服务条款",@"意见反馈", nil];
        cell.textLabel.text=titleArray[indexPath.row];
        cell.textLabel.font=FONT(17, 15);
        
        if (indexPath.row==0)
        {
            UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10)-WZ(10)-WZ(150), 0, WZ(150), WZ(50))];
            mobileLabel.text=self.mobile;
            mobileLabel.textColor=COLOR_BLACK;
            mobileLabel.font=FONT(15,13);
            mobileLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:mobileLabel];
            self.mobileLabel=mobileLabel;
        }
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2)
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
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"使用帮助",@"清除缓存", nil];
        cell.textLabel.text=titleArray[indexPath.row];
        cell.textLabel.font=FONT(17, 15);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row==1)
        {
            UILabel *cacheLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(10)-WZ(10)-WZ(150), 0, WZ(150), WZ(50))];
            cacheLabel.text=self.cacheSizeString;
            cacheLabel.textColor=COLOR_BLACK;
            cacheLabel.font=FONT(15,13);
            cacheLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:cacheLabel];
            self.cacheLabel=cacheLabel;
        }
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==3)
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
        
        cell.textLabel.text=@"关于我们";
        cell.textLabel.font=FONT(17, 15);
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        UIButton *exitBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        exitBtn.backgroundColor=COLOR(254, 167, 173, 1);
        exitBtn.layer.cornerRadius=5.0;
        exitBtn.clipsToBounds=YES;
        [exitBtn setTitle:@"退出账号" forState:UIControlStateNormal];
        exitBtn.titleLabel.font=FONT(17, 15);
        [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:exitBtn];
        
        
        cell.backgroundColor=COLOR_HEADVIEW;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            //客服热线
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
//            SettingDetailViewController *vc=[[SettingDetailViewController alloc]init];
////            vc.isHotLines=YES;
//            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==1)
        {
            //服务条款
            SettingDetailViewController *vc=[[SettingDetailViewController alloc]init];
            vc.isService=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row==2)
        {
            //意见反馈
            SuggestionViewController *vc=[[SuggestionViewController alloc]init];
            vc.isSettingVC=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            //使用帮助
            SettingDetailViewController *vc=[[SettingDetailViewController alloc]init];
            vc.isHelp=YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if (indexPath.row==1)
        {
            //清理缓存
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"是否清除全部%@缓存？",self.cacheSizeString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag=101;
            [alertView show];
        }
    }
    if (indexPath.section==3)
    {
        //关于我们
        SettingDetailViewController *vc=[[SettingDetailViewController alloc]init];
        vc.isAboutUs=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==4)
    {
        return nil;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==4)
    {
        return SCREEN_HEIGHT-WZ(50*7+15*4);
    }
    else
    {
        return WZ(50);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==4)
    {
        return 0;
    }
    else
    {
        return WZ(15);
    }
    
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//打开关闭消息推送
-(void)pushSwitchClick:(UISwitch*)pushSwitch
{
    [self remoteNotifications];
}

//打开关闭消息推送
-(void)remoteNotifications
{
    User *user=[UserInfoData getUserInfoFromArchive];
    
    [HTTPManager ifReceiveRemoteNotificationsWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSString *push=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"isPush"]];
            if ([push isEqualToString:@"0"])
            {
                self.isPush=YES;
                [self.pushSwitch setOn:YES];
                
                user.isPush=@"0";
                [UserInfoData saveUserInfoWithUser:user];
            }
            if ([push isEqualToString:@"1"])
            {
                self.isPush=NO;
                [self.pushSwitch setOn:NO];
                
                user.isPush=@"1";
                [UserInfoData saveUserInfoWithUser:user];
            }
            [_tableView reloadData];
        }
    }];
}

//退出账号
-(void)exitBtnClick
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=100;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==1)
        {
            NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"isThird.plist"];
            NSDictionary *isThirdLoginDict=[NSDictionary dictionaryWithContentsOfFile:path];
            NSString *isThird=[isThirdLoginDict objectForKey:@"isThird"];
            NSFileManager *manager=[NSFileManager defaultManager];
            if ([manager fileExistsAtPath:path])
            {
                if ([isThird isEqualToString:@"是"])
                {
                    //                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                    //                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                    //                [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                    
                    [isThirdLoginDict setValue:@"否" forKey:@"isThird"];
                    [isThirdLoginDict writeToFile:path atomically:YES];
                    
                    LoginViewController *vc=[[LoginViewController alloc]init];
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                    UIWindow *window=[UIApplication sharedApplication].windows[0];
                    window.rootViewController=nav;
                }
                if ([isThird isEqualToString:@"否"])
                {
                    NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ifLogin.plist"];
                    NSFileManager *manager=[NSFileManager defaultManager];
                    
                    if ([manager fileExistsAtPath:filePath])
                    {
                        NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
                        [dict setValue:@"E" forKey:@"ifLogin"];
                        [dict writeToFile:filePath atomically:YES];
                    }
                    
                    LoginViewController *vc=[[LoginViewController alloc]init];
                    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                    UIWindow *window=[UIApplication sharedApplication].windows[0];
                    window.rootViewController=nav;
                }
            }
            else
            {
                NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"ifLogin.plist"];
                NSFileManager *manager=[NSFileManager defaultManager];
                
                if ([manager fileExistsAtPath:filePath])
                {
                    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
                    [dict setValue:@"E" forKey:@"ifLogin"];
                    [dict writeToFile:filePath atomically:YES];
                }
                
                LoginViewController *vc=[[LoginViewController alloc]init];
                UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
                UIWindow *window=[UIApplication sharedApplication].windows[0];
                window.rootViewController=nav;
            }
            
            
        }
    }
    if (alertView.tag==101)
    {
        if (buttonIndex==1)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            [fileManager removeItemAtPath:cacheFilePath error:nil];
            
            self.cacheLabel.text=@"0.00 M";
            self.cacheSizeString=@"0.00 M";
        }
    }
//    if (alertView.tag==102)
//    {
//        if (buttonIndex==1)
//        {
//            
//            
//            
//        }
//    }
    
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
