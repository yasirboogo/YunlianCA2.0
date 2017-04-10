//
//  RecomendFriendsViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RecomendFriendsViewController.h"

@interface RecomendFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
    
}

@property(nonatomic,strong)NSMutableArray *friendsArray;
@property(nonatomic,assign)BOOL ifArea;


@end

@implementation RecomendFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    [self recomendFriendsData];
    
    self.ifArea=[ViewController ifRegisterArea];
    
    
    
}

-(void)recomendFriendsData
{
    //推荐好友
    [HTTPManager recomendFriendsWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"50" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            NSMutableArray *dataArray=[[listDict objectForKey:@"data"] mutableCopy];
            self.friendsArray=[NSMutableArray array];
            for (NSInteger i=0; i<dataArray.count; i++)
            {
                NSDictionary *dict=dataArray[i];
                NSString *userId=[NSString stringWithFormat:@"%@",[dict objectForKey:@"userId"]];
                
                if (![userId isEqualToString:[NSString stringWithFormat:@"%@",[UserInfoData getUserInfoFromArchive].userId]])
                {
                    [self.friendsArray addObject:dict];
                }
            }
//            NSLog(@"推荐好友列表===%@",self.friendsArray);
//            NSLog(@"用户id===%@",[UserInfoData getUserInfoFromArchive].userId);
            
            [_tableView reloadData];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"推荐好友";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    NSDictionary *friendDict=self.friendsArray[indexPath.row];
    NSString *headimg=[friendDict objectForKey:@"headimg"];
    NSString *nickname=[friendDict objectForKey:@"nickname"];
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
//    iconIV.image=IMAGE(@"head_img01");
    [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] placeholderImage:IMAGE(@"morentouxiang")];
    iconIV.clipsToBounds=YES;
    iconIV.layer.cornerRadius=iconIV.width/2.0;
    [cell.contentView addSubview:iconIV];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+10+90), iconIV.height)];
    titleLabel.text=nickname;
    titleLabel.font=FONT(15,13);
    [cell.contentView addSubview:titleLabel];
    
    UIButton *addFriendBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+60), WZ(13), WZ(60), WZ(24))];
    addFriendBtn.tag=indexPath.row;
    [addFriendBtn setTitle:@"加好友" forState:UIControlStateNormal];
    
    addFriendBtn.titleLabel.font=FONT(15,13);
    addFriendBtn.clipsToBounds=YES;
    addFriendBtn.layer.cornerRadius=3;
    addFriendBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    addFriendBtn.layer.borderWidth=1;
    [addFriendBtn addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:addFriendBtn];
    
    if (self.ifArea==YES)
    {
        [addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        addFriendBtn.backgroundColor=COLOR_WHITE;
    }
    else
    {
        [addFriendBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        addFriendBtn.backgroundColor=COLOR_LIGHTGRAY;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
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
////        [tableView deleteRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationTop];
//    }
//}


#pragma mark ===点击按钮的方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加好友
-(void)addFriendBtnClick:(UIButton*)button
{
    NSLog(@"加好友tag===%ld",(long)button.tag);
    NSDictionary *friendDict=self.friendsArray[button.tag];
    NSString *userId=[friendDict objectForKey:@"userId"];
    
    [HTTPManager addFriendRequestWithUserId:[UserInfoData getUserInfoFromArchive].userId toUserId:userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view makeToast:@"已发送好友请求" duration:2.0];
            [self.friendsArray removeObjectAtIndex:button.tag];
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:[resultDict objectForKey:@"error"] duration:2.0];
        }
    }];
    
//    BOOL ifArea=[ViewController ifRegisterArea];
//    if (ifArea==YES)
//    {
//        
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前所在的片区非注册片区，不能进行此操作！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
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
