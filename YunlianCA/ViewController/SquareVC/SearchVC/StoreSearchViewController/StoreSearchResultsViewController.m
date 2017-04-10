//
//  StoreSearchResultsViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "StoreSearchResultsViewController.h"

#import "StoreDetailViewController.h"

@interface StoreSearchResultsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)UIButton *contentImageBtn;
@property(nonatomic,strong)UIButton *contentImageBtn0;



@end

@implementation StoreSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"搜索结果";
    
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
    return self.resultsArray.count;
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
    
    NSDictionary *storeDict=self.resultsArray[indexPath.row];
    NSString *callNum=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"callNum"]];
    NSString *explains=[storeDict objectForKey:@"explains"];
    NSString *headImg=[storeDict objectForKey:@"headImg"];
//    NSString *storeId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"id"]];
//    NSString *mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"mobile"]];
    NSString *name=[storeDict objectForKey:@"name"];
    NSString *opentime=[storeDict objectForKey:@"opentime"];
    
    
    UIImageView *iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(60), WZ(60))];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,headImg]] placeholderImage:IMAGE(@"morentupian")];
    [cell.contentView addSubview:iconImageView];
    
    CGSize nameSize=[ViewController sizeWithString:name font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(20))];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), iconImageView.top, nameSize.width, WZ(20))];
    nameLabel.text=name;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR(146, 135, 187, 1);
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:nameLabel];
    
    NSString *shopHoursString=[NSString stringWithFormat:@"营业时间：%@",opentime];
    CGSize shopHoursSize=[ViewController sizeWithString:shopHoursString font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(15))];
    
    UILabel *shopHoursLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), nameLabel.bottom+WZ(6), shopHoursSize.width, WZ(15))];
    shopHoursLabel.text=shopHoursString;
    shopHoursLabel.font=FONT(12,10);
    shopHoursLabel.textColor=COLOR_LIGHTGRAY;
    //    shopHoursLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:shopHoursLabel];
    
    CGSize signSize=[ViewController sizeWithString:explains font:FONT(12,10) maxSize:CGSizeMake(WZ(200), WZ(15))];
    
    UILabel *signLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+WZ(10), shopHoursLabel.bottom+WZ(3), signSize.width, WZ(15))];
    signLabel.text=explains;
    signLabel.font=FONT(12,10);
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

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到店铺详情界面
    StoreDetailViewController *vc=[[StoreDetailViewController alloc]init];
    vc.storeId=[self.resultsArray[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(90);
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//打电话
-(void)callBtnClick:(UIButton*)button
{
    button.userInteractionEnabled = NO;
    NSDictionary *storeDict=self.resultsArray[button.tag];
    NSString *mobile=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"mobile"]];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     button.userInteractionEnabled = YES;
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

@implementation StoreSearchResultImageBtn

@synthesize imageBtnArray;

@end
