//
//  MyRedEnvelopeListViewController.m
//  YunlianCA
//
//  Created by innofive on 17/4/12.
//  Copyright © 2017年 QinJun. All rights reserved.
//

#import "MyRedEnvelopeListViewController.h"
#import "MyRedEnvelopeDetailViewController.h"
#import "MySendRedEnvelopeViewController.h"

#import "SVProgressHUD.h"
@interface MyRedEnvelopeListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSInteger _totalPages;
}
@property(nonatomic,strong)NSMutableArray *recordsArray;
@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation MyRedEnvelopeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageNum=1;
    [self createNavigationBar];
    [self createTableView];

    _recordsArray = [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"加载中"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    [self refreshData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
-(void)getInfo{
    
    [HTTPManager getRedEnvelopeListWithUserId:[UserInfoData getUserInfoFromArchive].userId pageNum:[NSString stringWithFormat:@"%ld",_pageNum] pageSize:@"20" complete:^(NSMutableArray *listArray) {
        if (listArray!=nil) {
            //self.recordsArray=listArray;
            self.recordsArray = [NSMutableArray arrayWithArray:
                                 @[
                                   @{@"type":@"普通红包",@"totalmoney":@"1200",@"count":@"10",@"balance":@"200"},
                                   @{@"type":@"普通红包",@"totalmoney":@"1200",@"count":@"10",@"balance":@"200"},
                                   @{@"type":@"普通红包",@"totalmoney":@"1200",@"count":@"10",@"balance":@"200"}
                                   ]
                                 ];
            [_tableView reloadData];
        }
        [SVProgressHUD dismiss];
    }];
    

}
-(void)creatTableFootView{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(58))];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(17, 15);
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"暂无红包记录";
    _tableView.tableFooterView = titleLabel;
}
-(NSMutableArray*)changeIndexWithFirstCount:(NSInteger)firstCount  Section:(NSInteger)section lastCount:(NSInteger)lastCount{
    NSMutableArray* indexArray = [NSMutableArray array];
    for (NSInteger i=firstCount; i<lastCount; i++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexArray addObject:indexPath];
    }
    return indexArray;
}
-(void)createNavigationBar
{
    self.title=@"红包列表";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WZ(40);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
    statusView.backgroundColor=COLOR_WHITE;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(40)-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [statusView addSubview:lineView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), 0, WZ(70), statusView.height)];
    nameLabel.text=@"类型";
//    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR_LIGHTGRAY;
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+WZ(10), 0, WZ(70), statusView.height)];
    moneyLabel.text=@"总额(￥)";
//    moneyLabel.textAlignment=NSTextAlignmentCenter;
    moneyLabel.font=FONT(15,13);
    moneyLabel.textColor=COLOR_LIGHTGRAY;
    //    moneyLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), 0, WZ(70), statusView.height)];
//    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text=@"数量(个)";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    //    timeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:timeLabel];
    
    UILabel *balanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.right+WZ(10), 0, WZ(70), statusView.height)];
//    balanceLabel.textAlignment=NSTextAlignmentCenter;
    balanceLabel.text=@"余额(￥)";
    balanceLabel.font=FONT(15,13);
    balanceLabel.textColor=COLOR_LIGHTGRAY;
    //    timeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:balanceLabel];
    
    return statusView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame)-1, SCREEN_WIDTH, 1)];
    //    lineView.backgroundColor = COLOR_HEADVIEW;
    //    [cell.contentView addSubview:lineView];
    
    
    NSDictionary *dict = _recordsArray[indexPath.row];
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), WZ(10), WZ(70), WZ(22))];
    typeLabel.text=[NSString stringWithFormat:@"%@",dict[@"type"]];
    typeLabel.font=FONT(15,13);
    typeLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:typeLabel];
    
    UILabel *totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+WZ(10), typeLabel.top, WZ(70), typeLabel.height)];
    totalLabel.text=[NSString stringWithFormat:@"%@",dict[@"totalmoney"]];
    totalLabel.font=FONT(15,13);
    totalLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:totalLabel];
    
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(totalLabel.right+WZ(10), typeLabel.top, WZ(70), typeLabel.height)];
    countLabel.text=[NSString stringWithFormat:@"%@",dict[@"count"]];
    countLabel.font=FONT(15,13);
    countLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:countLabel];
    
    UILabel *balanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(countLabel.right+WZ(10), typeLabel.top, WZ(45), typeLabel.height)];
    balanceLabel.text=[NSString stringWithFormat:@"%@",dict[@"balance"]];
    balanceLabel.font=FONT(15,13);
    balanceLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:balanceLabel];
    
    UIButton *checkBtn=[[UIButton alloc]initWithFrame:CGRectMake(balanceLabel.right+WZ(10), typeLabel.top, SCREEN_WIDTH-balanceLabel.right-WZ(10)*2, typeLabel.height)];
    checkBtn.layer.cornerRadius=WZ(6);
    checkBtn.clipsToBounds=YES;
    checkBtn.titleLabel.font = FONT(12,10);
    [checkBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    checkBtn.backgroundColor = COLOR_RED;
    [cell.contentView addSubview:checkBtn];
    checkBtn.tag = indexPath.row;
    [checkBtn addTarget:self action:@selector(cheakRedEnvelopesDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)cheakRedEnvelopesDetailBtnClicked:(UIButton*)btn{
    MyRedEnvelopeDetailViewController * vc = [[MyRedEnvelopeDetailViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)refreshData{
    self.pageNum = 1;
    [self getInfo];
}
-(void)getMoreData{
    self.pageNum += 1;
    if (_pageNum<=_totalPages) {
        
        [self getInfo];
        
    }else{
        [self.view makeToast:@"没有更多数据" duration:1.0];
        [_tableView footerEndRefreshing];
    }
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-WZ(58)-64-WZ(10)*2)];
    _tableView.delegate=self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource=self;
    _tableView.rowHeight = WZ(46);
    _tableView.tableFooterView=[[UIView alloc]init];
    //_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView setSeparatorColor:[UIColor colorWithRGB:0xEDEDED]];
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
    [self creatTabelFootView];
}
-(void)creatTabelFootView{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0,_tableView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_tableView.bottom)];
    //footView.backgroundColor = [UIColor redColor];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake((footView.width-WZ(58))/2.0, WZ(10), WZ(58), WZ(58))];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = button.width/2.0;
    button.backgroundColor = [UIColor colorWithRGB:0Xff4738];
    button.layer.borderWidth = WZ(3);
    button.layer.borderColor = [UIColor colorWithRGB:0xFFD2D2].CGColor;
    [button setTitle:@"发红包" forState:UIControlStateNormal];
    button.titleLabel.font = FONT(15, 13);
    [button addTarget:self action:@selector(SendRedEnvelopesToTABtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    [self.view addSubview:footView];
    //_tableView.tableFooterView = footView;
}
-(void)SendRedEnvelopesToTABtnClicked{
    MySendRedEnvelopeViewController * vc = [[MySendRedEnvelopeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
