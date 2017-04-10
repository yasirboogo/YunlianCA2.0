//
//  SystemMessageViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/1.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "SystemMessageViewController.h"

#import "MessageSystemVC.h"
#import "MessageCommentVC.h"
#import "MessagePraiseVC.h"

@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)NSString *praiseBrief;
@property(nonatomic,strong)NSString *systemBrief;
@property(nonatomic,strong)NSString *commentBrief;
@property(nonatomic,assign)NSInteger xtRemind;
@property(nonatomic,assign)NSInteger plRemind;
@property(nonatomic,assign)NSInteger dzRemind;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.xtRemind=0;
    self.plRemind=0;
    self.dzRemind=0;
    self.praiseBrief=@"";
    self.systemBrief=@"";
    self.commentBrief=@"";
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
}

//我的信息提醒
-(void)mybriefMessage
{
    [HTTPManager getMyMessageOrAlertWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *praiseListDict=[resultDict objectForKey:@"praiseList"];
            NSArray *praiseArray=[praiseListDict objectForKey:@"data"];
            if (praiseArray.count>0)
            {
                self.praiseBrief=[[[praiseArray firstObject] objectForKey:@"beanContent"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else
            {
                self.praiseBrief=@"暂无点赞消息";
            }
            
            NSDictionary *xtListDict=[resultDict objectForKey:@"xtList"];
            NSArray *xtArray=[xtListDict objectForKey:@"data"];
            if (xtArray.count>0)
            {
                self.systemBrief=[[xtArray firstObject] objectForKey:@"content"];
            }
            else
            {
                self.systemBrief=@"暂无系统消息";
            }
            
            NSString *plRemind=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"plRemind"]];
            if (plRemind==nil || [plRemind isEqualToString:@""])
            {
                plRemind=@"0";
            }
            self.commentBrief=[NSString stringWithFormat:@"您有%@条新评论",plRemind];
            
            self.xtRemind=[[resultDict objectForKey:@"xtRemind"] integerValue];
            self.plRemind=[[resultDict objectForKey:@"plRemind"] integerValue];
            self.dzRemind=[[resultDict objectForKey:@"dzRemind"] integerValue];
            
            [_tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    [self mybriefMessage];
}

-(void)createNavigationBar
{
    self.title=@"消息";
    
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
    return 3;
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
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"系统消息",@"评论",@"赞", nil];
    NSArray *subArray=[[NSArray alloc]initWithObjects:self.systemBrief,self.commentBrief,self.praiseBrief, nil];
//    NSArray *iconArray=[[NSArray alloc]initWithObjects:IMAGE(@"linju_pinglun"),IMAGE(@"linju_pinglun"),IMAGE(@"linju_zan"), nil];
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(40), WZ(40))];
//    iconIV.image=iconArray[indexPath.row];
    iconIV.layer.cornerRadius=5;
    iconIV.clipsToBounds=YES;
    [cell.contentView addSubview:iconIV];
    
    if (indexPath.row==0)
    {
        if (self.xtRemind<=0)
        {
            iconIV.image=IMAGE(@"xitongxiaoxi_w");
        }
        else
        {
            iconIV.image=IMAGE(@"xitongxiaoxi_y");
        }
    }
    if (indexPath.row==1)
    {
        if (self.plRemind<=0)
        {
            iconIV.image=IMAGE(@"pinglun_w");
        }
        else
        {
            iconIV.image=IMAGE(@"pinglun_y");
        }
    }
    if (indexPath.row==2)
    {
        if (self.dzRemind<=0)
        {
            iconIV.image=IMAGE(@"zan_w");
        }
        else
        {
            iconIV.image=IMAGE(@"zan_y");
        }
    }
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10)-WZ(40), WZ(22))];
    titleLabel.backgroundColor=COLOR_WHITE;
    titleLabel.text=titleArray[indexPath.row];
    titleLabel.font=FONT(15, 13);
    [cell.contentView addSubview:titleLabel];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, iconIV.height-titleLabel.height)];
    subLabel.text=subArray[indexPath.row];
    subLabel.textColor=COLOR_LIGHTGRAY;
    subLabel.font=FONT(13, 11);
    //        subLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:subLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        MessageSystemVC *vc=[[MessageSystemVC alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==1)
    {
        MessageCommentVC *vc=[[MessageCommentVC alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==2)
    {
        MessagePraiseVC *vc=[[MessagePraiseVC alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(70);
}



#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
