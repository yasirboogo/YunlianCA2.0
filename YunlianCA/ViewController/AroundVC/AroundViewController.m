//
//  AroundViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AroundViewController.h"

#import "AroundPlaceViewController.h"
#import "Type01ViewController.h"
#import "Type03ViewController.h"


#define TOP_SV_HEIGHT WZ(45)

@interface AroundViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_topScrollView;
    CGFloat _buttonWidth;
    UITableView *_tableView;
    
}

@property(nonatomic,strong)NSMutableArray *topBtnArray;
@property(nonatomic,strong)NSMutableArray *bigClassArray;
@property(nonatomic,assign)NSInteger bigClassCount;
@property(nonatomic,strong)NSMutableArray *topTitleArray;


@end

@implementation AroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    self.bigClassCount=0;
    
    self.topBtnArray=[NSMutableArray array];
    self.topTitleArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    
    [HTTPManager surroundingService:^(NSMutableArray *bigClassArray) {
        self.bigClassArray=bigClassArray;
        self.bigClassCount=bigClassArray.count;
        
        for (NSInteger i=0; i<bigClassArray.count; i++)
        {
            AroundModel *model=bigClassArray[i];
            [self.topTitleArray addObject:model.bigClassName];
        }
        
        [self initSubviews];
        [_tableView reloadData];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [HTTPManager surroundingService:^(NSMutableArray *bigClassArray) {
        self.bigClassArray=bigClassArray;
        self.bigClassCount=bigClassArray.count;
        
        for (NSInteger i=0; i<bigClassArray.count; i++)
        {
            AroundModel *model=bigClassArray[i];
            [self.topTitleArray addObject:model.bigClassName];
        }
        
        if (!_topScrollView)
        {
            [self initSubviews];
        }
        
        [_tableView reloadData];
    }];
}

-(void)createNavigationBar
{
    self.title=@"周边服务";
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)initSubviews
{
    if (self.bigClassCount<=4)
    {
        _buttonWidth=(SCREEN_WIDTH-WZ(15*2))/self.bigClassCount;
    }
    if (self.bigClassCount>=4)
    {
        _buttonWidth=WZ(86.25);
    }
    
    if (!_topScrollView)
    {
        _topScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_SV_HEIGHT)];
        _topScrollView.delegate=self;
        [self.view addSubview:_topScrollView];
    }
    
    if (self.bigClassCount<=4)
    {
        _topScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, TOP_SV_HEIGHT);
    }
    if (self.bigClassCount>=4)
    {
        _topScrollView.contentSize=CGSizeMake(_buttonWidth*self.bigClassCount+WZ(15*2), TOP_SV_HEIGHT);
    }
    
    for (NSInteger i=0; i<self.bigClassCount; i++)
    {
        UIButton *topBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)+_buttonWidth*i, 0, _buttonWidth, TOP_SV_HEIGHT)];
        topBtn.tag=i;
        topBtn.titleLabel.font=FONT(15,13);
        [topBtn setTitle:self.topTitleArray[i] forState:UIControlStateNormal];
        [topBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:topBtn];
        
        [self.topBtnArray addObject:topBtn];
        //        topBtn.backgroundColor=COLOR_CYAN;
        
        if (i==0)
        {
            [topBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
        }
    }
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, TOP_SV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_SV_HEIGHT-64-49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bigClassArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
    
    AroundModel *model=self.bigClassArray[indexPath.section];
    NSString *bigClassImageUrl=model.bigClassImage;
    NSString *bigClassName=model.bigClassName;
    NSMutableArray *mListArray=model.smallClassArray;
    
    UIImageView *adIV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(125))];
    [adIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,bigClassImageUrl]] placeholderImage:IMAGE(@"morenguanggao")];
    adIV.contentMode=UIViewContentModeScaleToFill;
    [cell.contentView addSubview:adIV];
    
    UIView *circleLineView=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(200))/2.0, WZ(17.5), WZ(200), WZ(90))];
    circleLineView.backgroundColor=COLOR_CLEAR;
    circleLineView.layer.borderColor=COLOR_WHITE.CGColor;
    circleLineView.layer.borderWidth=1;
    [cell.contentView addSubview:circleLineView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(WZ(8), WZ(8), circleLineView.width-WZ(8*2), circleLineView.height-WZ(8*2))];
    bgView.backgroundColor=[COLOR_WHITE colorWithAlphaComponent:0.7];
    [circleLineView addSubview:bgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(10), WZ(10), bgView.width-WZ(10*2), WZ(30))];
    titleLabel.text=bigClassName;
    titleLabel.textAlignment=NSTextAlignmentCenter;
//    titleLabel.backgroundColor=COLOR_CYAN;
    titleLabel.font=FONT(19,17);
    [bgView addSubview:titleLabel];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, WZ(25))];
    subLabel.text=bigClassName;
    subLabel.textAlignment=NSTextAlignmentCenter;
//    subLabel.backgroundColor=COLOR_CYAN;
    subLabel.font=FONT(15,13);
    [bgView addSubview:subLabel];
    
    
    NSMutableArray *nameArray=[NSMutableArray array];
    NSMutableArray *idArray=[NSMutableArray array];
    NSMutableArray *isHomeArray=[NSMutableArray array];
    NSMutableArray *statusArray=[NSMutableArray array];
    NSMutableArray *createTimeArray=[NSMutableArray array];
    NSMutableArray *distinctionArray=[NSMutableArray array];
    NSMutableArray *gradeArray=[NSMutableArray array];
    NSMutableArray *parentIdArray=[NSMutableArray array];
    NSMutableArray *imgArray=[NSMutableArray array];
    
    for (NSInteger i=0; i<mListArray.count; i++)
    {
        NSString *smallClassName=[mListArray[i] objectForKey:@"name"];
        [nameArray addObject:smallClassName];
        
        NSString *smallClassId=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"id"]];
        [idArray addObject:smallClassId];
        
        NSString *smallClassIsHome=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"isHome"]];
        [isHomeArray addObject:smallClassIsHome];
        
        NSString *smallClassStatus=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"status"]];
        [statusArray addObject:smallClassStatus];
        
        NSString *smallClassCreateTime=[mListArray[i] objectForKey:@"carettime"];
        [createTimeArray addObject:smallClassCreateTime];
        
        NSString *smallClassDistinction=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"distinction"]];
        [distinctionArray addObject:smallClassDistinction];
        
        NSString *smallClassGrade=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"grade"]];
        [gradeArray addObject:smallClassGrade];
        
        NSString *smallClassParentId=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"parentId"]];
        [parentIdArray addObject:smallClassParentId];
        
        NSString *smallClassImg=[NSString stringWithFormat:@"%@",[mListArray[i] objectForKey:@"img"]];
        [imgArray addObject:smallClassImg];
    }
    
    CGFloat leftMargin=WZ(15);
    CGFloat space=WZ(15);
    CGFloat btnWidth=WZ(75);
    CGFloat btnHeight=WZ(28);
    
    for (NSInteger i=0; i<nameArray.count; i++)
    {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:nameArray[i],@"name",idArray[i],@"id",isHomeArray[i],@"isHome",statusArray[i],@"status",createTimeArray[i],@"createtime",distinctionArray[i],@"distinction",gradeArray[i],@"grade",parentIdArray[i],@"parentId",imgArray[i],@"img", nil];
        AroundSmallClassBtn *detailBtn=[[AroundSmallClassBtn alloc]initWithFrame:CGRectMake(leftMargin+(btnWidth+space)*(i%4), adIV.bottom+WZ(15)+(btnHeight+space)*(i/4), btnWidth, btnHeight)];
        detailBtn.tag=i;
        detailBtn.smallClassDict=dict;
        detailBtn.clipsToBounds=YES;
        detailBtn.layer.cornerRadius=3;
        detailBtn.layer.borderColor=COLOR(239, 239, 239, 1).CGColor;
        detailBtn.layer.borderWidth=1;
        [detailBtn setTitle:nameArray[i] forState:UIControlStateNormal];
        [detailBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        detailBtn.titleLabel.font=FONT(13,11);
        [detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:detailBtn];
    }
    
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
    aView.backgroundColor=COLOR_HEADVIEW;
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AroundModel *model=self.bigClassArray[indexPath.section];
    NSMutableArray *mListArray=model.smallClassArray;
    
    NSMutableArray *detailArray=[NSMutableArray array];
    for (NSInteger i=0; i<mListArray.count; i++)
    {
        NSString *smallClassName=[mListArray[i] objectForKey:@"name"];
        [detailArray addObject:smallClassName];
    }
    
    CGFloat space=WZ(15);
    CGFloat btnHeight=WZ(28);
    
    if (detailArray.count%4>0)
    {
        NSInteger hangShu=detailArray.count/4+1;
        return WZ(125)+WZ(15)+(btnHeight+space)*hangShu;
    }
    else
    {
        NSInteger hangShu=detailArray.count/4;
        return WZ(125)+WZ(15)+(btnHeight+space)*hangShu;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(10);
}




#pragma mark ===按钮点击方法
//点击顶部button
-(void)topBtnClick:(UIButton*)button
{
//    NSLog(@"点击顶部button的tag值===%ld",(long)button.tag);
    
    for (UIButton *btn in self.topBtnArray)
    {
        if (button.tag==btn.tag)
        {
            [btn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            
            [_tableView scrollToRow:0 inSection:button.tag atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else
        {
            [btn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        }
    }
}

//点击每个分类里面的小项
-(void)detailBtnClick:(AroundSmallClassBtn*)button
{
    NSDictionary *dict=button.smallClassDict;
    NSString *isHome=[dict objectForKey:@"isHome"];
    NSString *status=[dict objectForKey:@"status"];
    
    if ([isHome isEqualToString:@"0"])
    {
        //isHome=0 周边（快递）
        AroundPlaceViewController *vc=[[AroundPlaceViewController alloc]init];
        vc.moduleDict=dict;
        self.navigationController.navigationBarHidden=NO;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([isHome isEqualToString:@"1"])
    {
        if ([status isEqualToString:@"0"])
        {
            //isHome=1 status=0 首页门店类 比如家家淘宝 云超市之类
            Type03ViewController *type03VC=[[Type03ViewController alloc]init];
            type03VC.moduleDict=dict;
            type03VC.areaId =[UserInfoData getUserInfoFromArchive].areaId;
            self.navigationController.navigationBarHidden=NO;
            type03VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:type03VC animated:YES];
        }
        if ([status isEqualToString:@"1"])
        {
            //isHome=1 status=0 首页发帖类 比如新鲜事儿 邻里社区之类
            Type01ViewController *type01VC=[[Type01ViewController alloc]init];
            type01VC.moduleDict=dict;
            self.navigationController.navigationBarHidden=NO;
            type01VC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:type01VC animated:YES];
        }
    }
    
    
//    NSLog(@"小分类字典===%@",button.smallClassDict);
    
    
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

@implementation AroundSmallClassBtn

@synthesize smallClassDict;

@end
