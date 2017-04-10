//
//  ReportGroupViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/9.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ReportGroupViewController.h"

@interface ReportGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)NSArray *reasonArray;
@property(nonatomic,strong)NSString *reason;
@property(nonatomic,assign)NSInteger cellRow;
//@property(nonatomic,strong)UIImageView *checkImageView;
@property(nonatomic,strong)NSMutableArray *cellViewArray;
@property(nonatomic,strong)NSMutableArray *checkIVArray;

@end

@implementation ReportGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reason=@"赌博";
    self.reasonArray=[[NSArray alloc]initWithObjects:@"赌博",@"色情低俗",@"违法暴力",@"政治敏感",@"欺诈骗钱", nil];
    self.cellViewArray=[NSMutableArray array];
    self.checkIVArray=[NSMutableArray array];
    self.cellRow=0;
    
    [self createNavigationBar];
    [self createTableView];
    [self createCellView];
    
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"举报";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(40), WZ(30))];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createCellView
{
    for (NSInteger i=0; i<5; i++)
    {
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(50))];
        cellView.backgroundColor=COLOR_WHITE;
        [self.cellViewArray addObject:cellView];
        
        UILabel *reasonLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*3+20), cellView.height)];
        reasonLabel.text=self.reasonArray[i];
        reasonLabel.font=FONT(17, 15);
        [cellView addSubview:reasonLabel];
        
        UIImageView *checkIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+20), WZ(17), WZ(20), WZ(16))];
        checkIV.image=IMAGE(@"");
        [cellView addSubview:checkIV];
        [self.checkIVArray addObject:checkIV];
    }
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
    return 5;
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
    
    UIView *cellView=self.cellViewArray[indexPath.row];
    [cell.contentView addSubview:cellView];
    
    if (self.cellRow==indexPath.row)
    {
        UIImageView *checkIV=self.checkIVArray[indexPath.row];
        checkIV.image=IMAGE(@"linju_xuanze");
    }
    else
    {
        UIImageView *checkIV=self.checkIVArray[indexPath.row];
        checkIV.image=IMAGE(@"");
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellRow=indexPath.row;
    self.reason=self.reasonArray[indexPath.row];
    
    [_tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
    titleView.backgroundColor=COLOR_HEADVIEW;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), titleView.height)];
    titleLabel.backgroundColor=COLOR_HEADVIEW;
    titleLabel.text=@"请选择举报原因";
    titleLabel.textColor=COLOR_LIGHTGRAY;
    titleLabel.font=FONT(15, 13);
    [titleView addSubview:titleLabel];
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(40);
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
-(void)rightBtnClick
{
    NSLog(@"举报原因===%@",self.reason);
    
    [HTTPManager reportGroupWithUserId:[UserInfoData getUserInfoFromArchive].userId groupId:self.groupId cause:self.reason complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [self.view.window makeToast:@"举报成功，我们将会核实情况进行处理。" duration:2.0];
        }
        else
        {
            [self.view makeToast:@"举报失败，请稍后重试。" duration:1.0];
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
