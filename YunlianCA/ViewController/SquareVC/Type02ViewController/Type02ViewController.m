//
//  Type02ViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "Type02ViewController.h"


#define COUNT_VC 4

@interface Type02ViewController ()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate>
{
    UITableView *_tableView;
    ImagePlayerView *_playerView;
    
    UIScrollView *_scrollView;
    
    
}

@property(nonatomic,strong)NSArray *adIVArray;
@property(nonatomic,strong)UIButton *contentImageBtn;
@property(nonatomic,strong)UIButton *contentImageBtn0;


@end

@implementation Type02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    self.adIVArray=[[NSArray alloc]initWithObjects:IMAGE(@"test_ad01"),IMAGE(@"test_ad02"),IMAGE(@"test_ad03"),IMAGE(@"test_ad04"), nil];
    
    [_playerView startTimer];
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
//    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
    [_playerView stopTimer];
}

-(void)createNavigationBar
{
    self.title=self.titleString;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(70), WZ(10), WZ(70), WZ(25))];
    //    rightView.backgroundColor=COLOR_GREEN;
    
    UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WZ(28), WZ(25))];
    [fabuBtn setBackgroundImage:IMAGE(@"fabutiezi") forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(fabuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:fabuBtn];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(rightView.width-WZ(25), 0, WZ(25), WZ(25))];
    [searchBtn setBackgroundImage:IMAGE(@"sousuo_hei") forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchBtn];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _tableView.tag=0;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    if (section==0)
    {
        return 1;
    }
    if (section==1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
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
        
        _playerView=[[ImagePlayerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(175))];
        _playerView.imagePlayerViewDelegate=self;
        _playerView.scrollInterval=3;
        [cell.contentView addSubview:_playerView];
        [_playerView reloadData];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
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
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(50))];
        bgView.backgroundColor=COLOR_WHITE;
        [cell.contentView addSubview:bgView];
        
        UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(30), WZ(20))];
        zhidingLabel.text=@"置顶";
        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
        zhidingLabel.textColor=COLOR_WHITE;
        zhidingLabel.font=FONT(11,9);
        zhidingLabel.textAlignment=NSTextAlignmentCenter;
        zhidingLabel.layer.cornerRadius=3;
        zhidingLabel.clipsToBounds=YES;
        [bgView addSubview:zhidingLabel];
        
        UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(zhidingLabel.right+WZ(10), 0, SCREEN_WIDTH-zhidingLabel.right-WZ(10+15), WZ(50))];
        biaotiLabel.backgroundColor=COLOR_WHITE;
        biaotiLabel.text=@"疯狂动物城方言";
        [bgView addSubview:biaotiLabel];
        
        
        
        cell.backgroundColor=COLOR(241, 241, 241, 1);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(900))];
        _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*4, WZ(900));
        _scrollView.pagingEnabled=YES;
        _scrollView.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:_scrollView];
        
        
        
        for (NSInteger i=0; i<4; i++)
        {
            UITableView *smallTableView=[[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, WZ(900))];
            smallTableView.scrollEnabled=NO;
//            smallTableView.delegate=self;
//            smallTableView.dataSource=self;
            smallTableView.tag=i+1;
            smallTableView.tableFooterView=[[UIView alloc]init];
            [_scrollView addSubview:smallTableView];
        }
        
        
        
        
        
        
        
        
        
        
        
//        UserHeadView *headView=[[UserHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(70))];
//        [cell.contentView addSubview:headView];
//        
//        [headView.headImageBtn setBackgroundImage:IMAGE(@"head_img01") forState:UIControlStateNormal];
//        headView.nameLabel.text=@"华夏衣冠";
//        headView.timeLabel.text=@"2016-05-20";
//        
//        [headView.addFriendBtn setTitle:@"好友" forState:UIControlStateNormal];
//        [headView.addFriendBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
//        headView.addFriendBtn.layer.borderColor=COLOR(154, 154, 154, 1).CGColor;
//        headView.addFriendBtn.layer.borderWidth=1;
//        
//        UILabel *zhidingLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), headView.bottom, WZ(30), WZ(20))];
//        zhidingLabel.text=@"置顶";
//        zhidingLabel.backgroundColor=COLOR(166, 213, 157, 1);
//        zhidingLabel.textColor=COLOR_WHITE;
//        zhidingLabel.font=FONT(11);
//        zhidingLabel.textAlignment=NSTextAlignmentCenter;
//        zhidingLabel.layer.cornerRadius=3;
//        zhidingLabel.clipsToBounds=YES;
//        [cell.contentView addSubview:zhidingLabel];
//        
//        UILabel *biaotiLabel=[[UILabel alloc]initWithFrame:CGRectMake(zhidingLabel.right+WZ(10), zhidingLabel.top, SCREEN_WIDTH-zhidingLabel.right-WZ(10+15), zhidingLabel.height)];
//        //        biaotiLabel.backgroundColor=COLOR_CYAN;
//        biaotiLabel.text=@"巴西游玩";
//        [cell.contentView addSubview:biaotiLabel];
//        
//        NSString *content=@"        汉服，全称是“汉民族传统服饰”，又称汉衣冠、汉装、华服，是从黄帝即位到公元17世纪中叶（明末清初），在汉族的主要居住区，以“华夏－汉”文化为背景和主导思想，以华夏礼仪文化为中心，通过自然演化而形成的具有独特汉民族风貌性格，明显区别于其他民族的传统服装和配饰体系，是中国“衣冠上国”、“礼仪之邦”、“锦绣中华”、赛里斯国的体现，承载了汉族的染织绣等杰出工艺和美学，传承了30多项中国非物质文化遗产以及受保护的中国工艺美术。\n        与汉人一词类似，汉服中的“汉”字的词义外延亦存在着由汉朝扩大为整个民族指称的过程。如《马王堆三号墓遣册》关于“汉服”最早的记载：“简四四‘美人四人，其二人楚服，二人汉服’”中的“汉服”是指汉朝的服饰礼仪制度，即《周礼》《仪礼》《礼记》里的冠服体；而成书于唐朝的《蛮书》的记载：“初袭汉服，后稍参诸戎风俗，迄今但朝霞缠头，其余无异”中的“汉服”指的则是汉人的服饰礼仪制度。\n        汉服“始于黄帝，备于尧舜”，源自黄帝制冕服。定型于周朝，并通过汉朝依据四书五经形成完备的冠服体系，成为神道设教的一部分 因此后来各个华夏朝代均宗周法汉以继承汉衣冠为国家大事，于是有了二十四史中的舆服志。“黄帝、尧、舜垂衣裳而治天下，益取自乾坤”，是说上衣下裳的形制是取天意而定，是神圣的。汉服还通过华夏法系影响了整个汉文化圈，亚洲各国的部分民族如日本、朝鲜、越南、蒙古、不丹等等服饰均具有或借鉴汉服特征。";
//        
//        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000))];
//        
//        UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), zhidingLabel.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15) textAlignment:NSTextAlignmentLeft];
//        [cell.contentView addSubview:contentLabel];
//        
//        NSArray*contentImageArray=[[NSArray alloc]initWithObjects:IMAGE(@"hanfu01.jpeg"),IMAGE(@"hanfu02.jpeg"),IMAGE(@"hanfu03.jpg"),IMAGE(@"hanfu04.jpg"),IMAGE(@"hanfu05.jpg"),IMAGE(@"hanfu06.jpg"),IMAGE(@"hanfu07.jpg"),IMAGE(@"hanfu08.jpg"),IMAGE(@"hanfu09.jpg"), nil];
//        
//        for (NSInteger i=0; i<9; i++)
//        {
//            UIButton *contentImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
//            contentImageBtn.tag=i;
//            [contentImageBtn setBackgroundImage:contentImageArray[i] forState:UIControlStateNormal];
//            contentImageBtn.contentMode=UIViewContentModeScaleAspectFill;
//            [contentImageBtn addTarget:self action:@selector(contentImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.contentView addSubview:contentImageBtn];
//            self.contentImageBtn=contentImageBtn;
//        }
//        
//        ArticleBottomView *bottomView=[[ArticleBottomView alloc]initWithFrame:CGRectMake(0, self.contentImageBtn.bottom, SCREEN_WIDTH, WZ(30+18))];
//        [cell.contentView addSubview:bottomView];
//        
//        bottomView.addressLabel.text=@"广州";
//        bottomView.pageViewLabel.text=@"102";
//        bottomView.praiseLabel.text=@"10";
//        bottomView.commentLabel.text=@"12";
//        
//        //        bottomView.addressLabel.backgroundColor=COLOR_CYAN;
//        //        bottomView.pageViewLabel.backgroundColor=COLOR_CYAN;
//        //        bottomView.praiseLabel.backgroundColor=COLOR_CYAN;
//        //        bottomView.commentLabel.backgroundColor=COLOR_CYAN;
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2)
    {
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(35))];
        aView.backgroundColor=COLOR_WHITE;
        
        //修改COUNT_VC 也要修改此数组
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"求助",@"去哪玩",@"文心",@"失物招领", nil];
        
        for (NSInteger i=0; i<COUNT_VC; i++)
        {
            UIButton *titleBtn=[[UIButton alloc]initWithFrame:CGRectMake(0+SCREEN_WIDTH/COUNT_VC*i, 0, SCREEN_WIDTH/COUNT_VC, WZ(45))];
            [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [titleBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
            titleBtn.titleLabel.font=FONT(15,13);
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [aView addSubview:titleBtn];
            
            if (i==0)
            {
                [titleBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
            }
            
            
        }
        
        
        
        
        
        return aView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(175);
    }
    if (indexPath.section==1)
    {
        return WZ(50+10);
    }
    else
    {
//        NSString *content=@"    汉服，全称是“汉民族传统服饰”，又称汉衣冠、汉装、华服，是从黄帝即位到公元17世纪中叶（明末清初），在汉族的主要居住区，以“华夏－汉”文化为背景和主导思想，以华夏礼仪文化为中心，通过自然演化而形成的具有独特汉民族风貌性格，明显区别于其他民族的传统服装和配饰体系，是中国“衣冠上国”、“礼仪之邦”、“锦绣中华”、赛里斯国的体现，承载了汉族的染织绣等杰出工艺和美学，传承了30多项中国非物质文化遗产以及受保护的中国工艺美术。\n    与汉人一词类似，汉服中的“汉”字的词义外延亦存在着由汉朝扩大为整个民族指称的过程。如《马王堆三号墓遣册》关于“汉服”最早的记载：“简四四‘美人四人，其二人楚服，二人汉服’”中的“汉服”是指汉朝的服饰礼仪制度，即《周礼》《仪礼》《礼记》里的冠服体；而成书于唐朝的《蛮书》的记载：“初袭汉服，后稍参诸戎风俗，迄今但朝霞缠头，其余无异”中的“汉服”指的则是汉人的服饰礼仪制度。\n    汉服“始于黄帝，备于尧舜”，源自黄帝制冕服。定型于周朝，并通过汉朝依据四书五经形成完备的冠服体系，成为神道设教的一部分 因此后来各个华夏朝代均宗周法汉以继承汉衣冠为国家大事，于是有了二十四史中的舆服志。“黄帝、尧、舜垂衣裳而治天下，益取自乾坤”，是说上衣下裳的形制是取天意而定，是神圣的。汉服还通过华夏法系影响了整个汉文化圈，亚洲各国的部分民族如日本、朝鲜、越南、蒙古、不丹等等服饰均具有或借鉴汉服特征。";
//        CGSize contentSize=[ViewController sizeWithString:content font:FONT(15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000))];
//        
//        UILabel *contentLabel=[UILabel labelWithFrame:CGRectMake(WZ(15), WZ(70+20)+WZ(15), SCREEN_WIDTH-WZ(15*2), contentSize.height) labelSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50000)) text:content textColor:COLOR_BLACK bgColor:COLOR_WHITE font:FONT(15) textAlignment:NSTextAlignmentLeft];
//        
//        for (NSInteger i=0; i<9; i++)
//        {
//            UIButton *contentImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15)+WZ(110+7)*(i%3), contentLabel.bottom+WZ(15)+WZ(110+7)*(i/3), WZ(110), WZ(110))];
//            self.contentImageBtn0=contentImageBtn;
//        }
//        
//        return self.contentImageBtn0.bottom+WZ(15)+WZ(30+18);
        
        return WZ(1000);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2)
    {
        return WZ(45);
    }
    else
    {
        return 0;
    }
}

#pragma mark ===循环滚动条
- (NSInteger)numberOfItems
{
    return 4;
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    self.adIVArray=[[NSArray alloc]initWithObjects:IMAGE(@"test_ad01"),IMAGE(@"test_ad02"),IMAGE(@"test_ad03"),IMAGE(@"test_ad04"), nil];
    
    imageView.image=self.adIVArray[index];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    //点击跳转到下个界面
    
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//发布帖子
-(void)fabuBtnClick
{
    NSLog(@"发布帖子");
    
    EditNewArticleViewController *vc=[[EditNewArticleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

//搜索帖子
-(void)searchBtnClick
{
    NSLog(@"搜索帖子");
    
    ArticleSearchViewController *searchVC=[[ArticleSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//切换界面 求助 去哪玩 文心 失物招领等
-(void)titleBtnClick:(UIButton*)button
{
    
    
    
}


//点击图片全屏浏览
-(void)contentImageBtnClick:(UIButton*)button
{
    NSLog(@"点击的图片tag值===%ld",(long)button.tag);
    
    
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
