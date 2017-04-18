//
//  UserInfoViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/4.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "UserInfoViewController.h"

#import "StoreDetailViewController.h"
#import "MyArticleViewController.h"
#import "RCConversationDetailsVC.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
    
}

@property(nonatomic,strong)User *userInfo;
@property(nonatomic,strong)StoreModel *storeModel;
//@property(nonatomic,strong)UIButton *sendMessageBtn;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
}

//获取用户信息
-(void)getUserInfo
{
    [HTTPManager getUserInfoWithUserId:self.userId complete:^(User *user) {
        if ([user.result isEqualToString:STATUS_SUCCESS])
        {
            self.userInfo=user;
            [_tableView reloadData];
        }
    }];
}

//获取店铺列表
-(void)getStoreInfo
{
    [HTTPManager getMyStoreWithUserId:self.userId complete:^(StoreModel *storeModel) {
        if ([storeModel.result isEqualToString:STATUS_SUCCESS])
        {
            self.storeModel=storeModel;
            [_tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
    [self getUserInfo];
    [self getStoreInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"详情";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    UIButton *callBtn=[[UIButton alloc]init];
    callBtn.frame = CGRectMake(SCREEN_WIDTH-WZ(35), WZ(10), WZ(25), WZ(25));
    [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
    callBtn.layer.cornerRadius=callBtn.width/2.0;
    callBtn.clipsToBounds=YES;
    [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    callBtn.tag = -99;
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:callBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return self.storeModel.myStoreArray.count;
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
        
        UIImageView *headIV=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(70))/2.0, WZ(30), WZ(70), WZ(70))];
        [headIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,self.userInfo.headImage]] placeholderImage:IMAGE(@"morentouxiang")];
        headIV.layer.borderColor=COLOR(254, 167, 173, 1).CGColor;
        headIV.layer.borderWidth=2.0;
        headIV.clipsToBounds=YES;
        headIV.layer.cornerRadius=headIV.width/2.0;
        [cell.contentView addSubview:headIV];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headIV.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), WZ(25))];
        nameLabel.text=self.userInfo.nickname;
        nameLabel.textColor=COLOR_WHITE;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.font=FONT(17, 15);
        [cell.contentView addSubview:nameLabel];
        
        NSString *sign=[NSString stringWithFormat:@"签名：%@",self.userInfo.sign];
        CGSize signSize=[ViewController sizeWithString:sign font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100))];
        UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), nameLabel.bottom+WZ(10), SCREEN_WIDTH-WZ(15*2), signSize.height)];
        signLabel.text=sign;
        signLabel.textColor=COLOR(255, 172, 177, 1);
        signLabel.textAlignment=NSTextAlignmentCenter;
        signLabel.font=FONT(15, 13);
        signLabel.numberOfLines=0;
        [cell.contentView addSubview:signLabel];
        
        
        
        
        
        cell.backgroundColor=COLOR(255, 63, 94, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
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
        
        NSDictionary *storeDict=self.storeModel.myStoreArray[indexPath.row];
        NSString *headImg=[storeDict objectForKey:@"headImg"];
        NSString *name=[storeDict objectForKey:@"name"];
        NSString *opentime=[storeDict objectForKey:@"opentime"];
        NSString *explains=[storeDict objectForKey:@"explains"];
        NSString *callNum=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"callNum"]];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(50), WZ(50))];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]] placeholderImage:IMAGE(@"morentupian")];
        iconIV.clipsToBounds=YES;
        iconIV.layer.cornerRadius=iconIV.width/2.0;
        [cell.contentView addSubview:iconIV];
        
        CGSize nameSize=[ViewController sizeWithString:name font:FONT(17,15) maxSize:CGSizeMake(WZ(200), WZ(25))];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, nameSize.width, WZ(25))];
        nameLabel.text=name;
        nameLabel.font=FONT(17,15);
        nameLabel.textColor=COLOR(146, 135, 187, 1);
        //    nameLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:nameLabel];
        
        NSString *openTimeString=[NSString stringWithFormat:@"营业时间：%@",opentime];
        CGSize openTimeSize=[ViewController sizeWithString:openTimeString font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(25))];
        
        UILabel *openTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), nameLabel.bottom, openTimeSize.width, WZ(25))];
        openTimeLabel.text=openTimeString;
        openTimeLabel.font=FONT(12,10);
        openTimeLabel.textColor=COLOR_LIGHTGRAY;
        //    openTimeLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:openTimeLabel];
        
        CGSize signSize=[ViewController sizeWithString:explains font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100))];
        
        UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), iconIV.bottom+WZ(15), signSize.width, signSize.height)];
        signLabel.text=explains;
        signLabel.font=FONT(15,13);
        signLabel.numberOfLines=0;
        //    signLabel.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:signLabel];
        
        if (callNum==nil || [callNum isEqualToString:@""])
        {
            callNum=@"0";
        }
        
        NSString *callNumString=[NSString stringWithFormat:@"拨打%@次",callNum];
        CGSize callLabelSize=[ViewController sizeWithString:callNumString font:FONT(11,9) maxSize:CGSizeMake(WZ(100),WZ(20))];
        
        UILabel *callLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(12)-callLabelSize.width, WZ(50), callLabelSize.width, WZ(20))];
        callLabel.textAlignment=NSTextAlignmentCenter;
        callLabel.text=callNumString;
        callLabel.textColor=COLOR(166, 213, 157, 1);
        callLabel.font=FONT(11,9);
        [cell.contentView addSubview:callLabel];
        
        UIButton *callBtn=[[UIButton alloc]init];
        callBtn.center=CGPointMake(callLabel.center.x-WZ(30)/2.0, callLabel.center.y-WZ(40));
        callBtn.size=CGSizeMake(WZ(30), WZ(30));
        //    callBtn.backgroundColor=COLOR(166, 213, 157, 1);
        [callBtn setBackgroundImage:IMAGE(@"bodadianhua") forState:UIControlStateNormal];
        callBtn.layer.cornerRadius=callBtn.width/2.0;
        callBtn.clipsToBounds=YES;
        callBtn.tag=indexPath.row;
        [callBtn addTarget:self action:@selector(callBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:callBtn];
        
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2)
    {
        static NSString *cellIdentifier=@"Cell2";
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
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(20), WZ(20))];
        imageView.image=IMAGE(@"wode_wodefawen");
        [cell.contentView addSubview:imageView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+WZ(15), 0, WZ(150), WZ(50))];
        titleLabel.font=FONT(17,15);
        titleLabel.text=@"我的发文";
        [cell.contentView addSubview:titleLabel];
        
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"Cell3";
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
        
        UIButton *sendMessageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        sendMessageBtn.backgroundColor=COLOR(254, 167, 173, 1);
        sendMessageBtn.layer.cornerRadius=5.0;
        sendMessageBtn.clipsToBounds=YES;
        [sendMessageBtn setTitle:@"发消息" forState:UIControlStateNormal];
        [sendMessageBtn addTarget:self action:@selector(sendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:sendMessageBtn];
//        self.sendMessageBtn=sendMessageBtn;
        
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
        NSDictionary *storeDict=self.storeModel.myStoreArray[indexPath.row];
        NSString *storeId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
        
        //跳转到店铺详情界面
        StoreDetailViewController *vc=[[StoreDetailViewController alloc]init];
        vc.storeId=storeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==2)
    {
        //跳转到我的发文界面
        MyArticleViewController *vc=[[MyArticleViewController alloc]init];
        vc.userId=self.userInfo.userId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0 || section==3)
    {
        return nil;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        NSString *sign=[NSString stringWithFormat:@"签名：%@",self.userInfo.sign];
        CGSize signSize=[ViewController sizeWithString:sign font:FONT(15, 13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100))];
        
        return WZ(30+70+10+25+10+15)+signSize.height;
    }
    if (indexPath.section==1)
    {
        NSDictionary *storeDict=self.storeModel.myStoreArray[indexPath.row];
        NSString *explains=[storeDict objectForKey:@"explains"];
        CGSize signSize=[ViewController sizeWithString:explains font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(100))];
        
        return WZ(15+50+15+15)+signSize.height;
    }
    if (indexPath.section==2)
    {
        return WZ(50);
    }
    else
    {
        return WZ(110);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 || section==3)
    {
        return 0;
    }
    else
    {
        return WZ(10);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0)
    {
        scrollView.scrollEnabled=NO;
    }
    else
    {
        scrollView.scrollEnabled=YES;
    }
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//发消息
-(void)sendMessageBtnClick
{
    if (self.userInfo!=nil)
    {
        RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
        conversationVC.conversationType=ConversationType_PRIVATE;
        conversationVC.targetId = self.userId;
        conversationVC.title = self.userInfo.nickname;
        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        conversationVC.enableUnreadMessageIcon=YES;
        conversationVC.hidesBottomBarWhenPushed=YES;
        conversationVC.isPerson=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
    else
    {
        [self.view makeToast:@"未获取用户信息" duration:1.0];
    }
    
}

//打电话
-(void)callBtnClick:(UIButton*)button
{
    NSString *mobile = [NSString string];
    if (button.tag == -99) {
        mobile=[NSString stringWithFormat:@"%@",self.userInfo.username];
    }else{
        NSDictionary *storeDict=self.storeModel.myStoreArray[button.tag];
        mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"mobile"]];
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
