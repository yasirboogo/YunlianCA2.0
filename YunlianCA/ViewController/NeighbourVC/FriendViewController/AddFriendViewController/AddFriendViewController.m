//
//  AddFriendViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AddFriendViewController.h"

#import "RecomendFriendsViewController.h"

@interface AddFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
//    UIView *_searchView;
    
    
    
}

@property(nonatomic,strong)NSMutableArray *friendsArray;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavigationBar];
//    [self createTopSearchView];
    [self createTableView];
    
    
    
    //点击推送alertView进入此界面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"friend"] isEqualToString:@"friend"])
    {
        [self.tabBarController.tabBar setHidden:YES];
        //给导航栏加一个返回按钮，便于将推送进入的页面返回出去，如果不是推送进入该页面，那肯定是通过导航栏进入的，则页面导航栏肯定会有导航栏自带的leftBarButtonItem返回上一个页面
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(rebackToRootViewAction)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
}

- (void)rebackToRootViewAction
{
    //将标示条件置空，以防通过正常情况下导航栏进入该页面时无法返回上一级页面
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"" forKey:@"friend"];
    [pushJudge synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)makeMeFriendData
{
    //好友记录
    [HTTPManager getUserMakeMeFriendWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.friendsArray=[[listDict objectForKey:@"data"] mutableCopy];
            [_tableView reloadData];
        }
        else
        {
            NSString *error=[resultDict objectForKey:@"error"];
            [self.view makeToast:error duration:1.0];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self makeMeFriendData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.isMyselfVC==YES)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
        self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    }
    if (self.isNeighbourVC==YES)
    {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
        self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    }
    
}

-(void)createNavigationBar
{
    self.title=@"加好友";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

//-(void)createTopSearchView
//{
//    _searchView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
//    _searchView.backgroundColor=COLOR_WHITE;
//    [self.view addSubview:_searchView];
//    
//    UIImageView *searchIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(12.5), WZ(20), WZ(20))];
//    searchIV.image=IMAGE(@"sousuo_hei");
//    [_searchView addSubview:searchIV];
//    
//    UITextField *searchTF=[[UITextField alloc]initWithFrame:CGRectMake(searchIV.right+WZ(10), 0, SCREEN_WIDTH-searchIV.right-WZ(10+15), _searchView.height)];
//    searchTF.placeholder=@"搜索";
////    searchTF.backgroundColor=COLOR_CYAN;
//    [_searchView addSubview:searchTF];
//    
//}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else
    {
        return self.friendsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellIdentifier=@"Cell0";
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
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
        iconIV.image=IMAGE(@"linju_tuijianhaoyou");
        [cell.contentView addSubview:iconIV];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+10), iconIV.height)];
        titleLabel.text=@"推荐好友";
        [cell.contentView addSubview:titleLabel];
        
        
        
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"Cell1";
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
        NSDictionary *friendDict=self.friendsArray[indexPath.row];
        NSString *headimg=[friendDict objectForKey:@"headimg"];
        NSString *nickname=[friendDict objectForKey:@"nickname"];
        NSString *status=[friendDict objectForKey:@"status"];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] placeholderImage:IMAGE(@"morentouxiang")];
        iconIV.clipsToBounds=YES;
        iconIV.layer.cornerRadius=iconIV.width/2.0;
        [cell.contentView addSubview:iconIV];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+10+90), iconIV.height)];
        titleLabel.text=nickname;
        titleLabel.font=FONT(15,13);
        [cell.contentView addSubview:titleLabel];
        
        UIButton *addFriendBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+60), WZ(13), WZ(60), WZ(24))];
        [addFriendBtn setTitle:status forState:UIControlStateNormal];
        addFriendBtn.titleLabel.font=FONT(15,13);
        addFriendBtn.clipsToBounds=YES;
        addFriendBtn.layer.cornerRadius=3;
        addFriendBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
        addFriendBtn.layer.borderWidth=1;
        addFriendBtn.tag=indexPath.row;
        [cell.contentView addSubview:addFriendBtn];
        
        if ([status isEqualToString:@"已添加"])
        {
            [addFriendBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
            addFriendBtn.userInteractionEnabled=NO;
        }
        if ([status isEqualToString:@"接受"])
        {
            [addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
            [addFriendBtn addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
//        //推荐好友
        RecomendFriendsViewController *vc=[[RecomendFriendsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
    titleView.backgroundColor=COLOR_HEADVIEW;
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(15);
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
////定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
////进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle==UITableViewCellEditingStyleDelete)
//    {
//        //先删除数据源 再删除cell
//        [tableView setEditing:NO animated:YES];
//        
//        NSDictionary *friendDict=self.friendsArray[indexPath.row];
//        NSString *userId=[friendDict objectForKey:@"userId"];
//        
//        [HTTPManager ifAgreeAddFriendWithUserId:userId toUserId:[UserInfoData getUserInfoFromArchive].userId status:@"0" complete:^(NSDictionary *resultDict) {
//            NSString *result=[resultDict objectForKey:@"result"];
//            if ([result isEqualToString:STATUS_SUCCESS])
//            {
//                [self.view makeToast:@"已拒绝对方添加好友" duration:2.0];
//                [self.friendsArray removeObjectAtIndex:indexPath.row];
//                [_tableView reloadData];
//            }
//            else
//            {
//                [self.view makeToast:[resultDict objectForKey:@"error"] duration:2.0];
//            }
//        }];
//        
//    }
//}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//接受好友
-(void)addFriendBtnClick:(UIButton*)button
{
    NSDictionary *friendDict=self.friendsArray[button.tag];
    NSString *userId=[friendDict objectForKey:@"userId"];
    
    [HTTPManager ifAgreeAddFriendWithUserId:userId toUserId:[UserInfoData getUserInfoFromArchive].userId status:@"1" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view.window makeToast:@"已添加好友" duration:2.0];
            [self makeMeFriendData];
        }
        else
        {
            [self.view.window makeToast:[resultDict objectForKey:@"error"] duration:2.0];
        }
    }];
    
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
