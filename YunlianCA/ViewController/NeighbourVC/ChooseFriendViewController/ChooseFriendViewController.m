//
//  ChooseFriendViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ChooseFriendViewController.h"

#import "ChooseGroupViewController.h"
#import "CreateGroupViewController.h"
#import "RCConversationDetailsVC.h"

@interface ChooseFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
//    UIView *_searchView;
    
    
    
}

@property(nonatomic,strong)UIButton *rightBtn;
@property (retain, nonatomic) NSMutableDictionary *dictionary;
@property (retain, nonatomic) NSArray *allKeys;
@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;


@end

@implementation ChooseFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedArray=[NSMutableArray array];
    
    [self createNavigationBar];
//    [self createTopSearchView];
    [self createTableView];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getFriends];
}

-(void)createNavigationBar
{
    self.title=@"选择好友或群";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    CGSize rightSize;
    if (self.selectedArray.count>0)
    {
        rightSize=[ViewController sizeWithString:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] font:FONT(17, 15) maxSize:CGSizeMake(WZ(100), WZ(30))];
    }
    else
    {
        rightSize=[ViewController sizeWithString:@"确定" font:FONT(17, 15) maxSize:CGSizeMake(WZ(100), WZ(30))];
    }
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(40), WZ(10), rightSize.width, WZ(30))];
    rightBtn.titleLabel.font=FONT(17, 15);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn=rightBtn;
    
    if (self.selectedArray.count>0)
    {
        [rightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
        [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        rightBtn.userInteractionEnabled=YES;
    }
    else
    {
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        rightBtn.userInteractionEnabled=NO;
    }
    
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
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
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(65))];
    headerView.backgroundColor=COLOR_HEADVIEW;
    _tableView.tableHeaderView=headerView;
    
    UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(15), headerView.width, headerView.height-WZ(15))];
    aView.backgroundColor=COLOR_WHITE;
    [headerView addSubview:aView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, aView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [headerView addSubview:lineView];
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
    iconIV.image=IMAGE(@"linju_faxianqun");
    [aView addSubview:iconIV];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-iconIV.right-WZ(15+10+10), iconIV.height)];
    titleLabel.text=@"选择群";
    [aView addSubview:titleLabel];
    
    UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(8), WZ(17.5), WZ(8), WZ(15))];
    //        jiantouIV.backgroundColor=COLOR_CYAN;
    jiantouIV.image=IMAGE(@"youjiantou_hei");
    [aView addSubview:jiantouIV];
    
    UIButton *chooseGroupBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, aView.width, aView.height)];
    [chooseGroupBtn addTarget:self action:@selector(chooseGroupBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:chooseGroupBtn];
    
    
    
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //使用排序好的数组
    return self.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //先取得这个区在字典中的key
    NSString *key = [self.allKeys objectAtIndex:section];
    //然后根据key 取出这个区的数据 返回count
    NSArray *array=[_dictionary objectForKey:key];
    
    return array.count;
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
    
    //先根据区号从字典中取出对应的key 然后根据key从字典中取得该区显示的好友们
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSMutableArray *mutableArray = [_dictionary objectForKey:key];
    NSDictionary *friendDict=mutableArray[indexPath.row];
    NSString *headimg=[friendDict objectForKey:@"headimg"];
    NSString *nickname=[friendDict objectForKey:@"nickname"];
//    NSString *userId=[friendDict objectForKey:@"id"];
    
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
    headImageView.layer.cornerRadius=headImageView.width/2.0;
    headImageView.clipsToBounds=YES;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headimg]] placeholderImage:IMAGE(@"morentouxiang")];
    [cell.contentView addSubview:headImageView];
    
    UILabel *contactLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImageView.right+WZ(5), 0, SCREEN_WIDTH-headImageView.width-WZ(15+5+15)-WZ(20+10), WZ(50))];
    contactLabel.text=nickname;
    contactLabel.font=FONT(15,13);
    [cell.contentView addSubview:contactLabel];
    
    UIImageView *checkImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+20), WZ(17), WZ(20), WZ(16))];
    [cell.contentView addSubview:checkImageView];
    
    if ([self.selectedArray containsObject:friendDict])
    {
        checkImageView.image=IMAGE(@"linju_xuanze");
    }
    else
    {
        checkImageView.image=IMAGE(@"");
    }
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(20))];
    titleView.backgroundColor=COLOR(252, 252, 252, 1);
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), titleView.height)];
    label.text=[NSString stringWithFormat:@"%@",[self.allKeys objectAtIndex:section]];//从排序好的数组中取值
    label.textColor=COLOR_LIGHTGRAY;
    label.font=FONT(15,13);
    [titleView addSubview:label];
    
    return titleView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.allKeys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSMutableArray *mutableArray = [_dictionary objectForKey:key];
    NSDictionary *friendDict=mutableArray[indexPath.row];
//    NSString *userId=[friendDict objectForKey:@"id"];
    
    if ([self.selectedArray containsObject:friendDict])
    {
        [self.selectedArray removeObject:friendDict];
    }
    else
    {
        [self.selectedArray addObject:friendDict];
    }
    
    [tableView reloadData];
    
//    NSLog(@"选择的用户===%@",self.selectedArray);
    
    
    if (self.selectedArray.count>0)
    {
        CGSize rightSize=[ViewController sizeWithString:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] font:FONT(17, 15) maxSize:CGSizeMake(WZ(100), WZ(30))];
        self.rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(40), WZ(10), rightSize.width, WZ(30));
        [self.rightBtn setTitle:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.selectedArray.count] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        self.rightBtn.userInteractionEnabled=YES;
    }
    else
    {
        CGSize rightSize=[ViewController sizeWithString:@"确定" font:FONT(17, 15) maxSize:CGSizeMake(WZ(100), WZ(30))];
        self.rightBtn.frame=CGRectMake(SCREEN_WIDTH-WZ(40), WZ(10), rightSize.width, WZ(30));
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:COLOR_LIGHTGRAY forState:UIControlStateNormal];
        self.rightBtn.userInteractionEnabled=NO;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(20);
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//选择群
-(void)chooseGroupBtnClick
{
    ChooseGroupViewController *vc=[[ChooseGroupViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//开始聊天
-(void)rightBtnClick
{
    if (self.selectedArray.count==1)
    {
        //选择一个好友 单聊
        NSDictionary *friendDict=self.selectedArray[0];
        NSString *userId=[NSString stringWithFormat:@"%@",[friendDict objectForKey:@"id"]];
        NSString *nickname=[friendDict objectForKey:@"nickname"];
        
        RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
        conversationVC.conversationType=ConversationType_PRIVATE;
        conversationVC.targetId = userId;
        conversationVC.title = nickname;
        conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        conversationVC.enableUnreadMessageIcon=YES;
        conversationVC.hidesBottomBarWhenPushed=YES;
        conversationVC.isPerson=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        
    }
    if (self.selectedArray.count>1)
    {
        NSMutableArray *idArray=[NSMutableArray array];
        for (NSDictionary *friendDict in self.selectedArray)
        {
            NSString *userId=[friendDict objectForKey:@"id"];
            [idArray addObject:userId];
        }
        [idArray addObject:[UserInfoData getUserInfoFromArchive].userId];
        NSString *userIds=[idArray componentsJoinedByString:@","];
        
        //选择超过1个好友 跳转到创建群界面
        CreateGroupViewController *vc=[[CreateGroupViewController alloc]init];
        vc.userIds=userIds;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}



#pragma mark ===获取好友昵称
//获取好友昵称
-(void)getFriends
{
    self.dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.allKeys=[[NSArray alloc]init];
    
    [HTTPManager getMyFriendsListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"100" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[resultDict objectForKey:@"list"];
            self.friendsArray=[[listDict objectForKey:@"data"] mutableCopy];
            if (self.friendsArray.count>0)
            {
                //分组
                for (NSInteger i=0; i<self.friendsArray.count; i++)
                {
                    NSDictionary *friendDict=self.friendsArray[i];
                    NSString *nickname=[friendDict objectForKey:@"nickname"];
                    if (nickname!=nil && ![nickname isEqualToString:@""])
                    {
                        //将OC字符串转化为C字符串
                        CFStringRef stringRef = CFStringCreateWithCString( kCFAllocatorDefault, [nickname UTF8String], kCFStringEncodingUTF8);
                        //将C不可变字符串转化为可变字符串
                        CFMutableStringRef mutableStringRef = CFStringCreateMutableCopy(NULL, 0, stringRef);
                        //将汉字转化为拼音
                        //其中mutableStringRef参数是要转换的字符串，同时它是mutable的，直接作为最终转换后的字符串。range是转换的范围，如果为NULL，视为全部转换。transform可以指定要进行什么样的转换，这里可以指定多种语言的拼写转换。reverse指定该转换是否必须是可逆向转换的。返回值如果转换成功就返回true，否则返回false。
                        CFStringTransform(mutableStringRef, NULL, kCFStringTransformMandarinLatin, NO);
                        //去掉拼音中的声调
                        CFStringTransform(mutableStringRef, NULL, kCFStringTransformStripDiacritics, NO);
                        //        NSLog(@"%@", mutableStringRef);
                        
                        NSString *mutableString = (__bridge NSString *)mutableStringRef;
                        //截取字符串的首字符 并将字符转化为大写
                        NSString *firstCharacter = [[mutableString substringToIndex:1] uppercaseString];
                        //        NSLog(@"firstCharacter____%@", firstCharacter);
                        
                        //判断字典中是否有该Key 即是否有这个组
                        if ([[_dictionary allKeys] containsObject:firstCharacter])
                        {
                            //如果包含 将该Key下的数组取出来 把该联系人放进去
                            NSMutableArray *mutableArray = [_dictionary objectForKey:firstCharacter];
                            [mutableArray addObject:friendDict];
                        }
                        else
                        {
                            //如果没有这个组
                            NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:friendDict, nil];
                            //将该数组存入字典
                            [_dictionary setValue:mutableArray forKey:firstCharacter];
                        }
                    }
                }
                
                NSArray *allKeys = [_dictionary allKeys];
                //排序 调用指定方法对数组进行排序
                //compare方法 调用的是数组中元素的类的方法 该方法是可以自定义的
                self.allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
                
                [_tableView reloadData];
            }
            else
            {
                
            }
            
            
        }
    }];
    
    
    
    
}

//截取字符串 （）空格 - ·
- (NSString *)trimingString:(NSString *)string
{
    if (string.length == 0)
    {
        return nil;
    }
    //对字符串进行剪切、替换等操作 将不可变字符串转化为可变字符串
    //强制转化不可以 只改表面 没改本质 应根据不可变字符串创建一个可变字符串
    NSMutableString *mutableString = [NSMutableString string];
    [mutableString stringByAppendingString:string];
    
    //删除左括号  返回一个字符在字符串中的位置及长度
    NSRange range = [mutableString rangeOfString:@"("];
    //如果@"("的location不等于没找到
    if (range.location != NSNotFound)
    {
        [mutableString deleteCharactersInRange:range];
    }
    
    //将3替换为4 返回一个字符在字符串中的位置及长度
    NSRange range1 = [mutableString rangeOfString:@"3"];
    while (range1.location != NSNotFound)
    {
        //将3替换为4
        [mutableString replaceCharactersInRange:range1 withString:@"4"];
        //        NSLog(@"mutableString____%@", mutableString);
        
        //更新range
        range1 = [mutableString rangeOfString:@"3"];
    }
    
    //一个字符 删除多遍
    //删除· 返回一个字符在字符串中的位置及长度
    NSRange range2 = [mutableString rangeOfString:@" "];
    while (range2.location != NSNotFound)
    {
        //删除·
        [mutableString deleteCharactersInRange:range2];
        //        NSLog(@"mutableString____%@", mutableString);
        
        //更新range
        range2 = [mutableString rangeOfString:@" "];
    }
    
    //删除左括号  返回一个字符在字符串中的位置及长度
    NSRange range3 = [mutableString rangeOfString:@")"];
    if (range3.location != NSNotFound)
    {
        [mutableString deleteCharactersInRange:range3];
    }
    
    NSRange range4 = [mutableString rangeOfString:@"-"];
    if (range4.location != NSNotFound)
    {
        [mutableString deleteCharactersInRange:range4];
    }
    
    return mutableString;
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
