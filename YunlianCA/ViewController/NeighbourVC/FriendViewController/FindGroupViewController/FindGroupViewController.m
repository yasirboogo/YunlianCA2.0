//
//  FindGroupViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "FindGroupViewController.h"

#import "GroupDetailViewController.h"
#import "RCConversationDetailsVC.h"


@interface FindGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
//    UIView *_searchView;
    
    
    
}

@property(nonatomic,strong)NSMutableArray *groupArray;



@end

@implementation FindGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
//    [self createTopSearchView];
    [self createTableView];
    
    
    
    
    
}

//发现群
-(void)findGroupList
{
    [HTTPManager findGroupWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.groupArray=[[listDict objectForKey:@"data"] mutableCopy];
            
            [_tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self findGroupList];
}

-(void)createNavigationBar
{
    self.title=@"发现群";
    
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
//    //    searchTF.backgroundColor=COLOR_CYAN;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
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
    
    NSDictionary *groupDict=self.groupArray[indexPath.row];
    NSString *des=[groupDict objectForKey:@"des"];
    NSString *img=[groupDict objectForKey:@"img"];
    NSString *name=[groupDict objectForKey:@"name"];
    NSString *count=[NSString stringWithFormat:@"%@",[groupDict objectForKey:@"imUserCount"]];
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(40), WZ(40))];
    [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] placeholderImage:IMAGE(@"morentouxiang")];
    iconIV.clipsToBounds=YES;
    iconIV.layer.cornerRadius=iconIV.width/2.0;
    [cell.contentView addSubview:iconIV];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+80+20), WZ(20))];
    nameLabel.text=name;
    nameLabel.textColor=COLOR(146, 135, 187, 1);
    nameLabel.font=FONT(15,13);
    [cell.contentView addSubview:nameLabel];
    
//    CGSize juliSize=[ViewController sizeWithString:@"10.5km" font:FONT(11,9) maxSize:CGSizeMake(WZ(60), WZ(20))];
//    UILabel *juliLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-juliSize.width, nameLabel.top, juliSize.width, nameLabel.height)];
//    juliLabel.text=@"10.5km";
//    juliLabel.textColor=COLOR_LIGHTGRAY;
//    juliLabel.font=FONT(11,9);
//    [cell.contentView addSubview:juliLabel];
//    
//    UIImageView *juliIV=[[UIImageView alloc]initWithFrame:CGRectMake(juliLabel.left-WZ(5+10), juliLabel.top+WZ(5), WZ(10), WZ(12))];
//    juliIV.image=IMAGE(@"linju_juli");
//    [cell.contentView addSubview:juliIV];
    
    NSString *typeString=des;
    CGSize typeSize=[ViewController sizeWithString:typeString font:FONT(11,9) maxSize:CGSizeMake(WZ(100), WZ(20))];
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, typeSize.width, WZ(20))];
    typeLabel.text=typeString;
    typeLabel.textColor=COLOR_LIGHTGRAY;
    typeLabel.font=FONT(11,9);
    [cell.contentView addSubview:typeLabel];
    
    NSString *countString=[NSString stringWithFormat:@"%@人",count];
    CGSize countSize=[ViewController sizeWithString:countString font:FONT(11,9) maxSize:CGSizeMake(WZ(100), WZ(20))];
    
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), typeLabel.top, countSize.width, WZ(20))];
    countLabel.text=countString;
    countLabel.textColor=COLOR_LIGHTGRAY;
    countLabel.font=FONT(11,9);
    [cell.contentView addSubview:countLabel];
    
    NSString *joinString=@"立即加入";
    CGSize joinSize=[ViewController sizeWithString:joinString font:FONT(13,11) maxSize:CGSizeMake(WZ(100), WZ(20))];
    
    UIButton *joinBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-joinSize.width-WZ(10), WZ(70-22)/2.0, joinSize.width+WZ(10), WZ(22))];
    joinBtn.tag=indexPath.row;
    joinBtn.clipsToBounds=YES;
    joinBtn.layer.cornerRadius=3;
    joinBtn.layer.borderWidth=1;
    joinBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    [joinBtn setTitle:joinString forState:UIControlStateNormal];
    [joinBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    joinBtn.titleLabel.font=FONT(13,11);
    [joinBtn addTarget:self action:@selector(joinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:joinBtn];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *groupDict=self.groupArray[indexPath.row];
    NSString *groupId=[NSString stringWithFormat:@"%@",[groupDict objectForKey:@"id"]];
    
    GroupDetailViewController *vc=[[GroupDetailViewController alloc]init];
    vc.groupId=groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
    titleView.backgroundColor=COLOR_HEADVIEW;
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(15);
}




#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//立即加入群
-(void)joinBtnClick:(UIButton*)button
{
    NSDictionary *groupDict=self.groupArray[button.tag];
    NSString *groupId=[NSString stringWithFormat:@"%@",[groupDict objectForKey:@"id"]];
    NSString *groupName=[groupDict objectForKey:@"name"];
    [HTTPManager joinGroupWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:groupId groupName:groupName complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.view.window makeToast:@"加群成功，开始聊天吧~~" duration:1.0];
            
            RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
            conversationVC.conversationType=ConversationType_GROUP;
            conversationVC.targetId = groupId;
            conversationVC.title = groupName;
            conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
            conversationVC.enableUnreadMessageIcon=YES;
            conversationVC.hidesBottomBarWhenPushed=YES;
            conversationVC.isGroup=YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
        else
        {
            [self.view makeToast:@"加群失败，请重试。" duration:1.0];
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
