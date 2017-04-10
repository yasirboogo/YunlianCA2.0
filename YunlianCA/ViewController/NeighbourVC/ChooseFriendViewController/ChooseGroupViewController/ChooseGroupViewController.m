//
//  ChooseGroupViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ChooseGroupViewController.h"

#import "RCConversationDetailsVC.h"
#import "GroupDetailViewController.h"


@interface ChooseGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
    
    
}

@property(nonatomic,strong)NSMutableArray *groupArray;


@end

@implementation ChooseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self getGroupList];
}

//群列表
-(void)getGroupList
{
    [HTTPManager chooseGroupWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"200" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.groupArray=[[listDict objectForKey:@"data"] mutableCopy];
            if (self.groupArray.count>0)
            {
                [_tableView reloadData];
            }
            else
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无群~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
            }
        }
    }];
}

-(void)createNavigationBar
{
    self.title=@"选择群";
    
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
    
    
    UIButton *iconBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(40), WZ(40))];
    [iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,img]] forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    iconBtn.clipsToBounds=YES;
    iconBtn.layer.cornerRadius=iconBtn.width/2.0;
    iconBtn.tag=indexPath.row;
    [iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:iconBtn];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconBtn.right+WZ(10), iconBtn.top, SCREEN_WIDTH-iconBtn.right-WZ(15+10+80+20), WZ(20))];
    nameLabel.text=name;
    nameLabel.textColor=COLOR(146, 135, 187, 1);
    nameLabel.font=FONT(15,13);
    [cell.contentView addSubview:nameLabel];
    
    NSString *desString=des;
    CGSize desSize=[ViewController sizeWithString:desString font:FONT(11,9) maxSize:CGSizeMake(WZ(250), WZ(20))];
    
    UILabel *desLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(3), desSize.width, WZ(20))];
    desLabel.text=desString;
    desLabel.textColor=COLOR_LIGHTGRAY;
    desLabel.font=FONT(11,9);
    [cell.contentView addSubview:desLabel];
    
    NSString *countString=[NSString stringWithFormat:@"%@人",count];
    CGSize countSize=[ViewController sizeWithString:countString font:FONT(11,9) maxSize:CGSizeMake(WZ(50), WZ(20))];
    
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(desLabel.right+WZ(10), desLabel.top, countSize.width, WZ(20))];
    countLabel.text=countString;
    countLabel.textColor=COLOR_LIGHTGRAY;
    countLabel.font=FONT(11,9);
    [cell.contentView addSubview:countLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转群里聊天
    NSDictionary *groupDict=self.groupArray[indexPath.row];
    NSString *name=[groupDict objectForKey:@"name"];
    NSString *groupId=[NSString stringWithFormat:@"%@",[groupDict objectForKey:@"id"]];
    NSString *img=[groupDict objectForKey:@"img"];
    
    RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
    conversationVC.conversationType=ConversationType_GROUP;
    conversationVC.targetId = groupId;
    conversationVC.title = name;
    conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
    conversationVC.enableUnreadMessageIcon=YES;
    conversationVC.hidesBottomBarWhenPushed=YES;
    conversationVC.groupId=groupId;
    conversationVC.groupName=name;
    conversationVC.groupImg=img;
    conversationVC.isGroup=YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(70);
}







#pragma mark ===点击按钮的方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击群头像跳转群信息界面
-(void)iconBtnClick:(UIButton*)button
{
    NSDictionary *groupDict=self.groupArray[button.tag];
    NSString *groupId=[NSString stringWithFormat:@"%@",[groupDict objectForKey:@"id"]];
    
    GroupDetailViewController *vc=[[GroupDetailViewController alloc]init];
    vc.groupId=groupId;
    [self.navigationController pushViewController:vc animated:YES];
    
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
