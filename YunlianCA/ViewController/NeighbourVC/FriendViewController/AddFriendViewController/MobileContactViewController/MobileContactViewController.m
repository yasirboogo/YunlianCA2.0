//
//  MobileContactViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/23.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MobileContactViewController.h"

#import <AddressBook/AddressBook.h>
#import "ZYContact.h"

@interface MobileContactViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIView *_searchView;
    
    
    
}

@property (retain, nonatomic) NSMutableArray *contactsArray;
@property (retain, nonatomic) NSMutableDictionary *dictionary;
@property (retain, nonatomic) NSArray *allKeys;



@end

@implementation MobileContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getContacts];
    [self createNavigationBar];
    [self createTopSearchView];
    [self createTableView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    self.title=@"手机联系人";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createTopSearchView
{
    _searchView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(45))];
    _searchView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_searchView];
    
    UIImageView *searchIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(12.5), WZ(20), WZ(20))];
    searchIV.image=IMAGE(@"sousuo_hei");
    [_searchView addSubview:searchIV];
    
    UITextField *searchTF=[[UITextField alloc]initWithFrame:CGRectMake(searchIV.right+WZ(10), 0, SCREEN_WIDTH-searchIV.right-WZ(10+15), _searchView.height)];
    searchTF.placeholder=@"搜索";
    //    searchTF.backgroundColor=COLOR_CYAN;
    [_searchView addSubview:searchTF];
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _searchView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_searchView.height-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
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
    
    //先根据区号从字典中取出对应的key 然后根据key从字典中取得该区显示的联系人们
    NSString *key = [self.allKeys objectAtIndex:indexPath.section];
    NSMutableArray *mutableArray = [_dictionary objectForKey:key];
    
    UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(30), WZ(30))];
    headImageView.layer.cornerRadius=headImageView.width/2.0;
    headImageView.clipsToBounds=YES;
    headImageView.image=IMAGE(@"head_img01");
    [cell.contentView addSubview:headImageView];
    
    ZYContact *contact = mutableArray[indexPath.row];
    
    CGFloat contactLength = [contact.name boundingRectWithSize:CGSizeMake(WZ(230), WZ(15)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(15,13)} context:nil].size.width;
    
    UILabel *contactLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImageView.right+WZ(5), headImageView.top, contactLength, headImageView.height)];
    contactLabel.text=contact.name;
    contactLabel.font=FONT(15,13);
    //    contactLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:contactLabel];
    
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(60+20), WZ(13), WZ(60), WZ(24))];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    addBtn.titleLabel.font=FONT(15,13);
    addBtn.layer.cornerRadius=3;
    addBtn.clipsToBounds=YES;
    addBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    addBtn.layer.borderWidth=1;
    addBtn.tag=indexPath.row;
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:addBtn];
    
    
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

//添加好友
-(void)addBtnClick:(UIButton*)button
{
    
    
    
}





#pragma mark ===获取手机联系人
//获取通讯录
-(void)getContacts
{
    self.contactsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.allKeys=[[NSArray alloc]init];
    
    //存放错误信息
    CFErrorRef errorRef = NULL;
    
    //创建通讯录
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &errorRef);
    
    //获取应用的授权状态
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authorizationStatus == kABAuthorizationStatusNotDetermined)
    {
        NSLog(@"________授权");
    }
    
    //判断授权状态
    switch (authorizationStatus)
    {
            //用户还没有作出关于这个应用程序是否可以访问数据类的选择。
        case kABAuthorizationStatusNotDetermined:
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                NSLog(@"%d", granted);
            });
        }
            break;
            //应用没有被授权访问数据类。用户不能改变 例如家长控制
        case kABAuthorizationStatusRestricted:
            break;
            //用户明确拒绝此应用程序访问数据。
        case kABAuthorizationStatusDenied:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的设置->隐私->通讯录中开启授权" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
            break;
            //已经授权
        case kABAuthorizationStatusAuthorized:
            break;
            
        default:
            break;
    }
    
    //获取所有联系人
    NSArray *allPeople = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (int i=0; i<allPeople.count; i++)
    {
        //取出一条联系人
        ABRecordRef recordRef = (__bridge ABRecordRef)(allPeople[i]);
        //取出联系人的全名
        NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(recordRef);
        //根据propertyID 取出一个类型的数据 多值
        ABMultiValueRef multiValueRef = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
        //根据索引取出电话号码
        NSString *phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multiValueRef, 0));
        
        ZYContact *contact = [[ZYContact alloc] init];
        contact.name = fullName;
        contact.phoneNumber = [self trimingString:phoneNumber];
        [_contactsArray addObject:contact];
    }
    
    //分组
    for (int i=0; i<_contactsArray.count; i++)
    {
        ZYContact *contact = _contactsArray[i];
        
        //        NSLog(@"第%d个联系人的名称===%@",i,contact.name);
        if (contact.name!=NULL)
        {
            //将OC字符串转化为C字符串
            CFStringRef stringRef = CFStringCreateWithCString( kCFAllocatorDefault, [contact.name UTF8String], kCFStringEncodingUTF8);
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
                [mutableArray addObject:contact];
            }
            else
            {
                //如果没有这个组
                NSMutableArray *mutableArray = [NSMutableArray arrayWithObjects:contact, nil];
                //将该数组存入字典
                [_dictionary setValue:mutableArray forKey:firstCharacter];
            }
            
            
            
            
        }
        
    }
    
    NSArray *allKeys = [_dictionary allKeys];
    
    //排序 调用指定方法对数组进行排序
    //compare方法 调用的是数组中元素的类的方法 该方法是可以自定义的
    self.allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    //    NSLog(@"sortedArray___%@", self.allKeys);
    
    
    
    
    [_tableView reloadData];
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
