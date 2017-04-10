//
//  YongJinMingXiVC.m
//  YunlianCA
//
//  Created by QinJun on 2016/10/28.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "YongJinMingXiVC.h"

#import "RedEnvelopeRecordsViewController.h"

@interface YongJinMingXiVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
    
}

@property(nonatomic,strong)NSMutableArray *recordsArray;

@end

@implementation YongJinMingXiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //佣金明细
    [HTTPManager getYongJinRecordsWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"300" complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *recordsDict=[resultDict objectForKey:@"txCzRecord"];
            self.recordsArray=[[recordsDict objectForKey:@"data"] mutableCopy];
            [_tableView reloadData];
            if (self.recordsArray.count==0)
            {
                if (!_blankLabel)
                {
                    _blankLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                    _blankLabel.text=@"暂无佣金明细~~";
                    _blankLabel.font=FONT(17, 15);
                    _blankLabel.textAlignment=NSTextAlignmentCenter;
                    [self.view addSubview:_blankLabel];
                }
            }
            else
            {
                if (_blankLabel)
                {
                    [_blankLabel removeFromSuperview];
                    _blankLabel=nil;
                }
            }
        }
    }];
}

-(void)createNavigationBar
{
    self.title=@"佣金明细";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+80), WZ(10), WZ(80), WZ(30))];
    [rightBtn setTitle:@"红包明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordsArray.count;
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
    
    NSDictionary *recordDict=self.recordsArray[indexPath.row];
    NSString *createTime=[recordDict objectForKey:@"createTime"];
    NSString *money=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"money"]];
    NSString *grade=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"grade"]];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3.0, WZ(30))];
    timeLabel.text=createTime;
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    timeLabel.textAlignment=NSTextAlignmentCenter;
    //        timeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:timeLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right, 0, SCREEN_WIDTH/3.0, WZ(30))];
    moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[money floatValue]];
    moneyLabel.font=FONT(11,9);
    moneyLabel.textColor=COLOR_LIGHTGRAY;
    moneyLabel.textAlignment=NSTextAlignmentCenter;
    //        moneyLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:moneyLabel];
    
    UILabel *gradeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right, 0, SCREEN_WIDTH/3.0, WZ(30))];
    gradeLabel.text=grade;
    gradeLabel.font=FONT(11,9);
    gradeLabel.textColor=COLOR_LIGHTGRAY;
    gradeLabel.textAlignment=NSTextAlignmentCenter;
    //        gradeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:gradeLabel];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //纯阳雪 江山雪 眉间雪 千樽雪 菩提雪，胭脂雪，杨花雪
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(30))];
    statusView.backgroundColor=COLOR_WHITE;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, statusView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [statusView addSubview:lineView];
    
    NSArray *array=[[NSArray alloc]initWithObjects:@"时间",@"金额",@"等级", nil];
    
    for (NSInteger i=0; i<3; i++)
    {
        UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0*i, 0, SCREEN_WIDTH/3.0, statusView.height)];
        statusLabel.text=array[i];
        statusLabel.font=FONT(15,13);
        statusLabel.textColor=COLOR_LIGHTGRAY;
        statusLabel.textAlignment=NSTextAlignmentCenter;
        [statusView addSubview:statusLabel];
    }
    
    return statusView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(30);
}



#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//红包明细
-(void)rightBtnClick
{
    RedEnvelopeRecordsViewController *vc=[[RedEnvelopeRecordsViewController alloc]init];
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
