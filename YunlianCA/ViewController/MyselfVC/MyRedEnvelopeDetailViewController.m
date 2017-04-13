//
//  MyRedEnvelopeDetailViewController.m
//  YunlianCA
//
//  Created by innofive on 17/4/12.
//  Copyright © 2017年 QinJun. All rights reserved.
//

#import "MyRedEnvelopeDetailViewController.h"

#import "SVProgressHUD.h"
@interface MyRedEnvelopeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSInteger _totalPages;
}
@property(nonatomic,strong)NSMutableArray *recordsArray;
@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation MyRedEnvelopeDetailViewController

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
            self.recordsArray = [NSMutableArray arrayWithArray:@[
                                                                 @{@"img":@"xiaoxi_w",@"nickname":@"埃文斯",@"money":@"20",@"time":@"2017-12-21 21:21"},
                                                                 @{@"img":@"xiaoxi_w",@"nickname":@"埃文斯",@"money":@"20",@"time":@"2017-12-21 21:21"},
                                                                 @{@"img":@"xiaoxi_w",@"nickname":@"埃文斯",@"money":@"20",@"time":@"2017-12-21 21:21"}
                                                                 ]];
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
    self.title=@"红包明细";
    
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
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(40), 0, WZ(90), statusView.height)];
    nameLabel.text=@"用户";
    //nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR_LIGHTGRAY;
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+WZ(10), 0, WZ(70), statusView.height)];
    moneyLabel.text=@"金额";
    moneyLabel.textAlignment=NSTextAlignmentCenter;
    moneyLabel.font=FONT(15,13);
    moneyLabel.textColor=COLOR_LIGHTGRAY;
    //    moneyLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), 0, SCREEN_WIDTH-moneyLabel.right-2*WZ(10), statusView.height)];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text=@"时间";
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_LIGHTGRAY;
    //    timeLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:timeLabel];
    
    return statusView;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame)-1, SCREEN_WIDTH, 1)];
    //    lineView.backgroundColor = COLOR_HEADVIEW;
    //    [cell.contentView addSubview:lineView];
    
    
    NSDictionary *dict = _recordsArray[indexPath.row];
    
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WZ(10), WZ(10), WZ(26), WZ(26))];
    headImgView.image = IMAGE(dict[@"img"]);
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = headImgView.width/2.0f;
    [cell.contentView addSubview:headImgView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImgView.right+WZ(10), headImgView.top, WZ(80), headImgView.height)];
    nameLabel.text=[NSString stringWithFormat:@"%@",dict[@"nickname"]];
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+WZ(10), headImgView.top, WZ(70), headImgView.height)];
    moneyLabel.text=[NSString stringWithFormat:@"￥%@",dict[@"money"]];
    moneyLabel.font=FONT(15,13);
    moneyLabel.textColor=COLOR_BLACK;
    moneyLabel.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), headImgView.top, SCREEN_WIDTH-moneyLabel.right-2*WZ(10), headImgView.height)];
    timeLabel.text=[NSString stringWithFormat:@"%@",dict[@"time"]];
    timeLabel.font=FONT(15,13);
    timeLabel.textColor=COLOR_BLACK;
    timeLabel.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:timeLabel];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-64)];
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
}

-(void)SendRedEnvelopesToTABtnClicked{

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
