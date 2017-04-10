//
//  TiXianRecordsViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/8.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "TiXianRecordsViewController.h"

@interface TiXianRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UILabel *_blankLabel;
    
}

@property(nonatomic,strong)NSMutableArray *recordsArray;

@end

@implementation TiXianRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //佣金提现记录
    [HTTPManager commissionWithdrawRecordWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:@"1" pageSize:@"300" complete:^(NSDictionary *resultDict) {
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
                    _blankLabel.text=@"暂无提现记录~~";
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
    self.title=@"提现记录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
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
    NSString *bankCode=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"bankCode"]];
    NSString *bankUserName=[recordDict objectForKey:@"bankUserName"];
    NSString *createTime=[recordDict objectForKey:@"createTime"];
    NSString *money=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"money"]];
    NSString *status=[NSString stringWithFormat:@"%@",[recordDict objectForKey:@"status"]];
    NSString *statusString;
    if ([status isEqualToString:@"0"])
    {
        statusString=@"正在提现";
    }
    if ([status isEqualToString:@"1"])
    {
        statusString=@"已完成";
    }
    
    NSString *userName;
    if (bankUserName.length==1)
    {
        userName=bankUserName;
    }
    if (bankUserName.length==2 || bankUserName.length==3)
    {
        userName=[NSString stringWithFormat:@"*%@",[bankUserName substringFromIndex:bankUserName.length-1]];
    }
    if (bankUserName.length>3)
    {
        userName=[NSString stringWithFormat:@"*%@",[bankUserName substringFromIndex:bankUserName.length-2]];
    }
    
    NSString *cardNumber=[NSString stringWithFormat:@"*** *** %@",[bankCode substringFromIndex:bankCode.length-4]];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(70), WZ(30))];
    timeLabel.text=createTime;
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    //        timeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:timeLabel];
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right+WZ(10), 0, WZ(150), WZ(30))];
    typeLabel.font=FONT(11,9);
    typeLabel.text=[NSString stringWithFormat:@"银行卡:%@ %@",userName,cardNumber];
    typeLabel.textColor=COLOR_LIGHTGRAY;
    //        typeLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:typeLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), 0, WZ(50), WZ(30))];
    jineLabel.text=[NSString stringWithFormat:@"¥%.2f",[money floatValue]];
    jineLabel.font=FONT(11,9);
    jineLabel.textColor=COLOR_LIGHTGRAY;
    //        jineLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:jineLabel];
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), 0, WZ(50), WZ(30))];
    statusLabel.text=statusString;
    statusLabel.font=FONT(11,9);
    statusLabel.textColor=COLOR_LIGHTGRAY;
    //        statusLabel.backgroundColor=COLOR_CYAN;
    [cell.contentView addSubview:statusLabel];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(30))];
    statusView.backgroundColor=COLOR_WHITE;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, statusView.bottom-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [statusView addSubview:lineView];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(70), statusView.height)];
    timeLabel.text=@"时间";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    [statusView addSubview:timeLabel];
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right+WZ(10), 0, WZ(150), statusView.height)];
    typeLabel.font=FONT(15,13);
    typeLabel.text=@"提现方式";
    typeLabel.textColor=COLOR_LIGHTGRAY;
    [statusView addSubview:typeLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), 0, WZ(50), statusView.height)];
    jineLabel.text=@"金额";
    jineLabel.font=FONT(15,13);
    jineLabel.textColor=COLOR_LIGHTGRAY;
    [statusView addSubview:jineLabel];
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), 0, WZ(50), statusView.height)];
    statusLabel.text=@"状态";
    statusLabel.font=FONT(15,13);
    statusLabel.textColor=COLOR_LIGHTGRAY;
    [statusView addSubview:statusLabel];
    
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
