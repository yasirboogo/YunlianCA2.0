//
//  TabBarViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "TabBarViewController.h"

#import "NearbyViewController.h"
#import "SquareViewController.h"
#import "AroundViewController.h"
#import "NeighbourViewController.h"
#import "MyselfViewController.h"




@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR(253, 76, 91, 1),NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR(146, 146, 146, 1),NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    NearbyViewController *nearbyVC=[[NearbyViewController alloc]init];
    UINavigationController *nearbyNav=[[UINavigationController alloc]initWithRootViewController:nearbyVC];
    UITabBarItem *nearbyItem=[[UITabBarItem alloc]initWithTitle:@"邻里圈" image:IMAGE(@"tabbar_linli_nor") selectedImage:IMAGE(@"tabbar_linli_sele")];
    nearbyItem.selectedImage=[nearbyItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nearbyItem.image=[nearbyItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nearbyVC.tabBarItem=nearbyItem;
    
    AroundViewController *aroundVC=[[AroundViewController alloc]init];
    UINavigationController *aroundNav=[[UINavigationController alloc]initWithRootViewController:aroundVC];
    UITabBarItem *aroundItem=[[UITabBarItem alloc]initWithTitle:@"周边服务" image:IMAGE(@"tabbar_zhoubian_nor") selectedImage:IMAGE(@"tabbar_zhoubian_sele")];
    aroundItem.selectedImage=[aroundItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aroundItem.image=[aroundItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    aroundVC.tabBarItem=aroundItem;
    
    SquareViewController *squareVC=[[SquareViewController alloc]init];
    UINavigationController *squareNav=[[UINavigationController alloc]initWithRootViewController:squareVC];
    UITabBarItem *squareItem=[[UITabBarItem alloc]initWithTitle:@"社区广场" image:IMAGE(@"tabbar_shequ") selectedImage:IMAGE(@"tabbar_shequ")];
    squareItem.selectedImage=[squareItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    squareItem.image=[squareItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    squareVC.tabBarItem=squareItem;
    squareItem.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0);
    
    NeighbourViewController *neighbourVC=[[NeighbourViewController alloc]init];
    UINavigationController *neighbourNav=[[UINavigationController alloc]initWithRootViewController:neighbourVC];
    UITabBarItem *neighbourItem=[[UITabBarItem alloc]initWithTitle:@"邻居" image:IMAGE(@"tabbar_linju_nor") selectedImage:IMAGE(@"tabbar_linju_sele")];
    neighbourItem.selectedImage=[neighbourItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    neighbourItem.image=[neighbourItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    neighbourVC.tabBarItem=neighbourItem;
    
    MyselfViewController *myselfVC=[[MyselfViewController alloc]init];
    UINavigationController *myselfNav=[[UINavigationController alloc]initWithRootViewController:myselfVC];
    UITabBarItem *myselfItem=[[UITabBarItem alloc]initWithTitle:@"我的" image:IMAGE(@"tabbar_wode_nor") selectedImage:IMAGE(@"tabbar_wode_sele")];
    myselfItem.selectedImage=[myselfItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myselfItem.image=[myselfItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myselfVC.tabBarItem=myselfItem;
    
    
    NSMutableArray *navControllers=[[NSMutableArray alloc]initWithObjects:nearbyNav,aroundNav,squareNav,neighbourNav,myselfNav, nil];
    
    UITabBarController *tabBarController=[[UITabBarController alloc]init];
    tabBarController.delegate=self;
    tabBarController.viewControllers=navControllers;
    tabBarController.selectedIndex=2;
    [self.navigationController pushViewController:tabBarController animated:NO];
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    //去掉导航条下边的shadowImage，就可以正常显示了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationController.navigationBar.translucent = NO;
//}




















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
