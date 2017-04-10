//
//  RedEnvelopeListViewController.m
//  YunlianCA
//
//  Created by 马JL on 2017/2/20.
//  Copyright © 2017年 QinJun. All rights reserved.
//

#import "RedEnvelopeListViewController.h"
#import "RedEnvelopeSendViewController.h"
#import "SVProgressHUD.h"
@interface RedEnvelopeListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSMutableDictionary * _reqDic;
    NSInteger _totalPages;
}
@property(nonatomic,strong)NSMutableArray *recordsArray;
@end

@implementation RedEnvelopeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self createNavigationBar];
     [self createTableView];
    _reqDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.objId,@"objId",self.type,@"type",@"1",@"pageNum",@"10",@"pageSize",nil];
    NSLog(@"_reqDic===%@",_reqDic);
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
    
    [HTTPManager getRedEnvelopeListWithReqDic:_reqDic WithUrl:@"v3/kissReCordList.api" complete:^(NSDictionary *resultDict) {
        NSLog(@"resultDict==%@",resultDict);
        [SVProgressHUD dismiss];
        NSInteger pageNum =[_reqDic[@"pageNum"] integerValue];
        if (pageNum==1) {
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary * listDic = resultDict[@"list"];
            if ([listDic isKindOfClass:[NSDictionary class]]) {
                NSArray * dataArray =listDic[@"data"];
                if ([dataArray isKindOfClass:[NSArray class]]) {
                    if (pageNum==1) {
                        [_recordsArray removeAllObjects];
                        [_recordsArray addObjectsFromArray:dataArray];
                        
                        if (_recordsArray.count>0) {
                            _tableView.tableFooterView = nil;
                            [_tableView reloadData];
                        }else{
                            [self creatTableFootView];
                        }
                        
                    }else{
                        NSMutableArray * indexArray = [self changeIndexWithFirstCount:_recordsArray.count Section:0 lastCount:_recordsArray.count+dataArray.count];
                        [_recordsArray addObjectsFromArray:dataArray];
                        [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
                    }
                }else{
                    
                }

            }
            
        }
        
    }];
}
-(void)creatTableFootView{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(100))];
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
    self.title=@"TA的红包记录";
    
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
    UIView *statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(30))];
    statusView.backgroundColor=COLOR_WHITE;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(40)-1, SCREEN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_HEADVIEW;
    [statusView addSubview:lineView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(12), 0, WZ(120), statusView.height)];
    nameLabel.text=@"用户";
        nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT(15,13);
    nameLabel.textColor=COLOR_LIGHTGRAY;
    //    nameLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:nameLabel];
    
    UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.right+WZ(10), 0, WZ(90), statusView.height)];
    moneyLabel.text=@"金额";
        moneyLabel.textAlignment=NSTextAlignmentCenter;
    moneyLabel.font=FONT(15,13);
    moneyLabel.textColor=COLOR_LIGHTGRAY;
    //    moneyLabel.backgroundColor=COLOR_CYAN;
    [statusView addSubview:moneyLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(12)*3-WZ(120)-WZ(90), statusView.height)];
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
    NSDictionary *dict=self.recordsArray[indexPath.row];
    NSString *nickName=[dict objectForKey:@"nickname"];
    NSString *time=[NSString stringWithFormat:@"%@",[dict objectForKey:@"createTime"]];
    NSString *money=[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"money"] floatValue]];
    NSInteger isAdmin=[[dict objectForKey:@"isAdmin"] integerValue];
    NSString *imgUrlString=[dict objectForKey:@"headimg"];
    NSURL *imgUrl;
    if ([imgUrlString containsString:@"http://"] || [imgUrlString containsString:@"https://"])
    {
        imgUrl=[NSURL URLWithString:imgUrlString];
    }
    else
    {
        imgUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,imgUrlString]];
    }
    
    UIButton *userBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(12), WZ(5), WZ(30), WZ(30))];
    userBtn.layer.cornerRadius=userBtn.width/2.0;
    userBtn.clipsToBounds=YES;
    [cell.contentView addSubview:userBtn];
    if (isAdmin==0)
    {
        [userBtn sd_setBackgroundImageWithURL:imgUrl forState:UIControlStateNormal placeholderImage:IMAGE(@"morentouxiang")];
    }
    if (isAdmin==1)
    {
        [userBtn setBackgroundImage:IMAGE(@"hongbao_xitongtouxiang") forState:UIControlStateNormal];
    }
    
    UILabel *userLabel=[[UILabel alloc]initWithFrame:CGRectMake(userBtn.right+WZ(5), userBtn.top, WZ(120-5)-userBtn.width, userBtn.height)];
    userLabel.text=nickName;
    userLabel.font=FONT(11,9);
    userLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:userLabel];
    
    UILabel *jineLabel=[[UILabel alloc]initWithFrame:CGRectMake(userLabel.right+WZ(10), userBtn.top, WZ(90), userBtn.height)];
    jineLabel.textAlignment = NSTextAlignmentCenter;
    jineLabel.text=[NSString stringWithFormat:@"￥ %@",money];
    jineLabel.font=FONT(11,9);
    jineLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:jineLabel];
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(jineLabel.right+WZ(10), userBtn.top, WZ(120), userBtn.height)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text=[NSString stringWithFormat:@"%@",time];
    timeLabel.font=FONT(11,9);
    timeLabel.textColor=COLOR_BLACK;
    [cell.contentView addSubview:timeLabel];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)refreshData{
    [_reqDic setObject:@"1" forKey:@"pageNum"];
    [self getInfo];
}
-(void)getMoreData{
    NSInteger pageNum =[_reqDic[@"pageNum"] integerValue];
    pageNum++;
    if (pageNum<=_totalPages) {
        [_reqDic setObject:[NSString stringWithFormat:@"%ld",(long)pageNum] forKey:@"pageNum"];
        
        [self getInfo];

    }else{
        [self.view makeToast:@"没有更多数据" duration:1.0];
        [_tableView footerEndRefreshing];
    }
}
-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-WZ(100)-64)];
    _tableView.delegate=self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
    [self creatTabelFootView];
}
-(void)creatTabelFootView{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-WZ(100)-64, SCREEN_WIDTH, WZ(100))];
    //footView.backgroundColor = [UIColor redColor];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(20), SCREEN_WIDTH-WZ(15)*2, WZ(50))];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    button.backgroundColor = COLOR_RED;
    [button setTitle:@"给TA发红包" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(SendRedEnvelopesToTABtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    [self.view addSubview:footView];
    //_tableView.tableFooterView = footView;
}
-(void)SendRedEnvelopesToTABtnClicked{
    RedEnvelopeSendViewController * vc = [[RedEnvelopeSendViewController alloc]init];
    vc.type = self.type;
    vc.objId = self.objId;
    vc.scanMobile = self.phoneNum;
    vc.isMouth = YES;
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
