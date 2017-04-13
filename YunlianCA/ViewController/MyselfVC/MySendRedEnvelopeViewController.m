//
//  MySendRedEnvelopeViewController.m
//  YunlianCA
//
//  Created by innofive on 17/4/12.
//  Copyright © 2017年 QinJun. All rights reserved.
//

#import "MySendRedEnvelopeViewController.h"
#import "UITextView+Placeholder.h"

#import "SVProgressHUD.h"
@interface MySendRedEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    UIButton *_currentAdTypeBtn;
    UIButton *_currentTwiceTypeBtn;
}
@property(nonatomic,strong)NSMutableArray *itemsArray;

@end

@implementation MySendRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationBar];
    [self createTableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.tintColor=COLOR(255, 63, 94, 1);
    self.view.backgroundColor=[UIColor colorWithRGB:0xEDEDED];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)getInfo{
    

    
    
}

-(void)createNavigationBar
{
    self.title=@"发红包";
    
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
    return 14;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return WZ(24);
    }
    else if (section == 2 || section == 3 || section == 4 || section == 5){
        return WZ(37);
    }
    else if (section == 12){
        return WZ(230);
    }
    else if (section == 13){
        return WZ(90);
    }
    else{
        return WZ(15);
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc] init];
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(24));
    }
    else if (section == 2 || section == 3 || section == 4 || section == 5){
        NSArray *headerTitles = @[@"可领取金额",@"初始已领取金额",@"可领取",@"初始已领取数量"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(37));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WZ(30), 0, headerView.width-WZ(40)*2, headerView.height)];
        titleLabel.text = headerTitles[section-2];
        titleLabel.font = FONT(12, 10);
        titleLabel.textColor = COLOR(153, 153, 153, 1);
        [headerView addSubview:titleLabel];
    }
    else if (section == 12){
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(230));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WZ(20), WZ(10), tableView.width-WZ(20)*2, WZ(30))];
        titleLabel.text = @"广告类型";
        titleLabel.font = FONT(15, 13);
        titleLabel.textColor = COLOR(51, 51, 51, 1);
        [headerView addSubview:titleLabel];
        
        
        NSArray<NSString*> *titleBtns = @[@"文字",@"优惠券",@"链接",@"视频"];
        [titleBtns enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [headerView addSubview:selectBtn];
            selectBtn.frame = CGRectMake(titleLabel.left+idx*titleLabel.width/4.0f, titleLabel.bottom, titleLabel.width/4.0f, WZ(50));
            [selectBtn setImage:[UIImage imageNamed:@"xuanze_wxz"] forState:UIControlStateNormal];
            [selectBtn setImage:[UIImage imageNamed:@"xuanze_xz"] forState:UIControlStateSelected];
            [selectBtn setTitle:titleBtns[idx] forState:UIControlStateNormal];
            [selectBtn setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
            selectBtn.titleLabel.font = FONT(14, 12);
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -WZ(20), 0, 0)];
            selectBtn.tag = idx;
            [selectBtn addTarget:self action:@selector(selectAdsTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (idx == 0) {
                selectBtn.selected = YES;
                _currentAdTypeBtn = selectBtn;
            }
        }];
        
        UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(titleLabel.left, _currentAdTypeBtn.bottom, titleLabel.width,headerView.height-_currentAdTypeBtn.bottom-WZ(20))];
        contentTextView.placeholder = @"想要说点什么呐";
        contentTextView.font = FONT(15, 13);
        contentTextView.textColor = COLOR(153, 153, 153, 1);
        [headerView addSubview:contentTextView];
    }
    else if (section == 13){
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(90));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WZ(20), WZ(10), tableView.width-WZ(20)*2, WZ(30))];
        titleLabel.text = @"红包二次出发类型";
        titleLabel.font = FONT(15, 13);
        titleLabel.textColor = COLOR(51, 51, 51, 1);
        [headerView addSubview:titleLabel];
        
        
        NSArray<NSString*> *titleBtns = @[@"无",@"红包"];
        [titleBtns enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [headerView addSubview:selectBtn];
            selectBtn.frame = CGRectMake(titleLabel.left+idx*titleLabel.width/3.0f, titleLabel.bottom, titleLabel.width/3.0f, WZ(50));
            [selectBtn setImage:IMAGE(@"xuanze_wxz") forState:UIControlStateNormal];
            [selectBtn setImage:IMAGE(@"xuanze_xz")  forState:UIControlStateSelected];
            [selectBtn setTitle:titleBtns[idx] forState:UIControlStateNormal];
            [selectBtn setTitleColor:COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
            selectBtn.titleLabel.font = FONT(14, 12);
            [selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -WZ(60), 0, 0)];
            [selectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -WZ(40), 0, 0)];
            selectBtn.tag = idx;
            [selectBtn addTarget:self action:@selector(selectTwiceTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (idx == 0) {
                selectBtn.selected = YES;
                _currentTwiceTypeBtn = selectBtn;
            }
        }];
    }
    else{
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(15));
    }
    return headerView;
    
}
-(void)selectAdsTypeBtnClicked:(UIButton*)btn{
    if (btn!= _currentAdTypeBtn) {
        _currentAdTypeBtn.selected = NO;
        btn.selected = YES;
        _currentAdTypeBtn = btn;
    }else{
        _currentAdTypeBtn.selected = YES;
    }
}
-(void)selectTwiceTypeBtnClicked:(UIButton*)btn{
    if (btn!= _currentTwiceTypeBtn) {
        _currentTwiceTypeBtn.selected = NO;
        btn.selected = YES;
        _currentTwiceTypeBtn = btn;
    }else{
        _currentTwiceTypeBtn.selected = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 13) {
        return WZ(100);
    }
    else{
        return WZ(0.001);
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    if (section == 13) {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(100));
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:sendBtn];
        sendBtn.frame = CGRectMake(WZ(20), WZ(25), footerView.width-WZ(20)*2, WZ(50));
        [sendBtn setTitle:@"塞钱进红包" forState:UIControlStateNormal];
        [sendBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        sendBtn.backgroundColor = COLOR_RED;
        sendBtn.titleLabel.font = FONT(18, 16);
        sendBtn.layer.masksToBounds = YES;
        sendBtn.layer.cornerRadius = WZ(5);
        [sendBtn addTarget:self action:@selector(sendMoneyToRedEnvelopeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WZ(0.001));
    }
    return footerView;
}
-(void)sendMoneyToRedEnvelopeBtnClick{
    NSLog(@"sendMoneyToRedEnvelopeBtnClick");
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor colorWithRGB:0xEDEDED];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(WZ(20), 0, cell.width-WZ(20)*2, cell.height)];
    cellView.backgroundColor = COLOR_WHITE;
    [cell.contentView addSubview:cellView];
    
    NSArray *leftTitles = @[@"红包类型",@"金额",@"金额底数",@"数量",@"数量底数",@"开始时间",@"有效时间",@"名称",@"主题",@"时段控制",@"年龄控制",@"性别控制",@"注册商户时所使用的手机号",@"红包二次倒数时间"];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(WZ(10), 0, cell.width*0.5, cell.height)];
    leftLabel.text = leftTitles[indexPath.section];
    leftLabel.font = FONT(15, 13);
    [cellView addSubview:leftLabel];
    if (indexPath.section == 12 || indexPath.section == 13) {
        leftLabel.textColor = COLOR(153, 153, 153, 1);
    }
    
    if (indexPath.section == 0 || indexPath.section == 5 ||indexPath.section == 6 ||indexPath.section == 11) {

    }
    else if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4){
        UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellView.width-WZ(15), 0, WZ(15), WZ(15))];
        rightImgView.image = IMAGE(@"");
        rightImgView.backgroundColor = COLOR_RED;
        [cellView addSubview:rightImgView];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        [cellView addSubview:unitLabel];
        unitLabel.font = FONT(15, 13);
        unitLabel.textColor = COLOR(51, 51, 51, 1);
        unitLabel.textAlignment = NSTextAlignmentCenter;
        if (indexPath.section == 1 || indexPath.section == 2) {
            unitLabel.text = @"元";
        }
        else if (indexPath.section == 3 || indexPath.section == 4){
            unitLabel.text = @"个";
        }
        CGFloat unitWidth = [unitLabel.text sizeWithAttributes:@{NSFontAttributeName:unitLabel.font}].width;
        unitLabel.frame = CGRectMake(rightImgView.left-unitWidth, 0, unitWidth, cellView.height);
        
        UITextField *contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftLabel.right+WZ(10), WZ(5), unitLabel.left-leftLabel.right-WZ(10)*2, WZ(35))];
        contentTextField.textColor = COLOR(153, 153, 153, 1);
        contentTextField.font = FONT(15, 13);
        contentTextField.textAlignment = NSTextAlignmentRight;
        contentTextField.placeholder = @"测试5";
        [cellView addSubview:contentTextField];
    }
    else if (indexPath.section == 7 || indexPath.section == 8){
        UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellView.width-WZ(15), 0, WZ(15), WZ(15))];
        rightImgView.image = IMAGE(@"");
        rightImgView.backgroundColor = COLOR_RED;
        [cellView addSubview:rightImgView];
        
        UITextField *contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftLabel.right+WZ(10), WZ(5), rightImgView.left-leftLabel.right-WZ(10)*2, WZ(35))];
        contentTextField.textColor = COLOR(153, 153, 153, 1);
        contentTextField.font = FONT(15, 13);
        contentTextField.textAlignment = NSTextAlignmentRight;
        [cellView addSubview:contentTextField];
        if (indexPath.section == 7) {
            contentTextField.placeholder = @"如：糖果店";
        }
        else if (indexPath.section == 8){
            contentTextField.placeholder = @"如：过年好";
        }
    }
    else if (indexPath.section == 9 || indexPath.section == 10){
        
    }
    else if (indexPath.section == 12){
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.right+WZ(10), 0, cellView.width-leftLabel.right-WZ(10)*2, cellView.height)];
        phoneLabel.text = @"13631499999";
        phoneLabel.textAlignment = NSTextAlignmentRight;
        phoneLabel.font = FONT(15, 13);
        phoneLabel.textColor = COLOR(153, 153, 153, 1);
        [cellView addSubview:phoneLabel];
    }
    else if (indexPath.section == 13){
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellView.width-WZ(20)-WZ(10), 0, WZ(20), cellView.height)];
        unitLabel.text = @"秒";
        unitLabel.font = FONT(15, 13);
        unitLabel.textColor = COLOR(153, 153, 153, 1);
        [cellView addSubview:unitLabel];
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)createTableView
{
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = [UIColor colorWithRGB:0xEDEDED];
    _tableView.bounces = NO;
    _tableView.dataSource=self;
    _tableView.rowHeight = WZ(45);
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
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

