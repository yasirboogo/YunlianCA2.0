//
//  EditNewArticleViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/13.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "EditNewArticleViewController.h"
#import <SVProgressHUD.h>
@interface EditNewArticleViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ChooseImagesDelegate>
{
    UIScrollView *_bgScrollView;
    ChooseImagesViewController *_imageVC;
    UITableView *_smallTableView;
}

@property(nonatomic,strong)UIView *smallBgView;
@property(nonatomic,strong)NSMutableArray *smallImageArray;
@property(nonatomic,strong)NSMutableArray *allImageArray;
@property(nonatomic,assign)BOOL isDelete;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *deleteBtnArray;

@property(nonatomic,strong)UIButton * addImageBtn;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,strong)UIView *addImageBgView;

@property(nonatomic,strong)YYTextView *contentTV;
@property(nonatomic,strong)UITextField *titleTF;

@property(nonatomic,strong)NSMutableArray *moduleListArray;
@property(nonatomic,strong)NSString *lanmuID;
@property(nonatomic,strong)NSString *lanmuName;
@property(nonatomic,strong)UILabel *rightLabel;


@end

@implementation EditNewArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lanmuName=@"";
    self.lanmuID=@"";
    self.smallImageArray=[NSMutableArray array];
    self.allImageArray=[NSMutableArray array];
    self.deleteBtnArray=[NSMutableArray array];
    self.imgArray=[NSMutableArray array];
    
    
    [self createNavigationBar];
    [self createSubviews];
    
    if (self.shareImage) {
        [self.smallImageArray addObject:self.shareImage];
        [self createPictures];
    }
    
    NSLog(@"创建帖子界面的moduleDict===%@",self.moduleDict);
    
    
    
}

-(void)getLanmuData
{
    NSString * url;
    if (self.shareImage) {
        url= @"index/getModuleListOfShareArticle.api";
    }else{
        url= @"user/moduleByFatherId.api";
    }
    [HTTPManager getLanmuDataWithFatherId:[self.moduleDict objectForKey:@"id"] WithUrl:(NSString *)url complete:^(NSDictionary *resultDict) {
        [SVProgressHUD dismiss];
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            if (self.shareImage) {
                NSArray * list =[resultDict objectForKey:@"list"];
                self.moduleListArray = [list mutableCopy];
                [_smallTableView reloadData];
                if (self.moduleDict) {
                    if (self.moduleListArray.count<=0) {
                        self.lanmuID=[NSString stringWithFormat:@"%@",[self.moduleDict objectForKey:@"id"]];
                        self.lanmuName=[self.moduleDict objectForKey:@"name"];
                        
                        self.rightLabel.text=self.lanmuName;
                        
                        [self.smallBgView removeFromSuperview];
                    }
                }
                
                
            }else{
                self.moduleListArray=[resultDict objectForKey:@"moduleList"];
            }
           
            
        }
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    self.navigationController.navigationBarHidden=NO;
     [self getLanmuData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}


-(void)createNavigationBar
{
    self.title=@"创建帖子";
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    CGSize fabuSize=[ViewController sizeWithString:@"发布" font:FONT(17, 15) maxSize:CGSizeMake(WZ(100), WZ(30))];
    UIButton *fabuBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(40), WZ(10), fabuSize.width, WZ(30))];
    fabuBtn.titleLabel.font=FONT(17, 15);
    [fabuBtn setTitle:@"发布" forState:UIControlStateNormal];
    [fabuBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(fabuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:fabuBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createSubviews
{
    _bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    _bgScrollView.backgroundColor=COLOR(241, 241, 241, 1);
    [self.view addSubview:_bgScrollView];
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), SCREEN_WIDTH, WZ(100))];
    titleView.backgroundColor=COLOR_WHITE;
    [_bgScrollView addSubview:titleView];
    
    if (self.lanmuCount>0)
    {
        titleView.frame=CGRectMake(0, WZ(10), SCREEN_WIDTH, WZ(100));
        
        UILabel *leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(80), WZ(50))];
        //    leftLabel.backgroundColor=COLOR_CYAN;
        leftLabel.text=@"栏目";
        leftLabel.font=FONT(17, 15);
        [titleView addSubview:leftLabel];
        
        UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(leftLabel.right+WZ(10), 0, SCREEN_WIDTH-WZ(15*2+10*2+10)-leftLabel.width, WZ(50))];
        //    rightLabel.backgroundColor=COLOR_CYAN;
        //    rightLabel.textAlignment=NSTextAlignmentCenter;
        rightLabel.font=FONT(17, 15);
        [titleView addSubview:rightLabel];
        self.rightLabel=rightLabel;
        
        UIImageView *rightIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+15), WZ(17), WZ(10), WZ(16))];
        rightIV.image=IMAGE(@"youjiantou_hei");
        [titleView addSubview:rightIV];
        
        UIButton *lanmuBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(50))];
        [lanmuBtn addTarget:self action:@selector(lanmuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:lanmuBtn];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(50), SCREEN_WIDTH, 1)];
        lineView.backgroundColor=COLOR_HEADVIEW;
        [titleView addSubview:lineView];
    }
    else
    {
        titleView.frame=CGRectMake(0, WZ(10), SCREEN_WIDTH, WZ(50));
    }
    
    UITextField *titleTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15), WZ(50), SCREEN_WIDTH-WZ(15*2), WZ(50))];
    titleTF.font=FONT(17,15);
    titleTF.placeholder=@"请输入标题";
    [titleView addSubview:titleTF];
    self.titleTF=titleTF;
    
    if (self.lanmuCount>0)
    {
        titleTF.frame=CGRectMake(WZ(15), WZ(50), SCREEN_WIDTH-WZ(15*2), WZ(50));
    }
    else
    {
        titleTF.frame=CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50));
    }
    
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, titleView.bottom+WZ(10), SCREEN_WIDTH, WZ(150))];
    contentView.backgroundColor=COLOR_WHITE;
    [_bgScrollView addSubview:contentView];
    self.contentView=contentView;
    
    YYTextView *contentTV=[[YYTextView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), contentView.width-WZ(15*2), contentView.height-WZ(15*2))];
    contentTV.placeholderText=@"请输入内容";
    //        contentTV.placeholderTextColor=COLOR_LIGHTGRAY;
    contentTV.placeholderFont=FONT(17,15);
    contentTV.font=FONT(17,15);
    [contentView addSubview:contentTV];
    self.contentTV=contentTV;
    
    UIView *addImageBgView=[[UIView alloc]initWithFrame:CGRectMake(0, contentView.bottom, SCREEN_WIDTH, WZ(110))];
    addImageBgView.backgroundColor=COLOR_WHITE;
    [_bgScrollView addSubview:addImageBgView];
    self.addImageBgView=addImageBgView;
    
    UIButton * addImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(80), WZ(80))];
    [addImageBtn setBackgroundImage:IMAGE(@"tianjiatupian") forState:UIControlStateNormal];
    addImageBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    addImageBtn.layer.borderWidth=1.0;
    [addImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addImageBgView addSubview:addImageBtn];
    self.addImageBtn=addImageBtn;
    
    
}

-(void)createSmallTableView
{
    UIView *smallBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    smallBgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.8];
    [self.view.window addSubview:smallBgView];
    self.smallBgView=smallBgView;
    
    _smallTableView=[[UITableView alloc]initWithFrame:CGRectMake(WZ(30), 64, SCREEN_WIDTH-WZ(30*2), SCREEN_HEIGHT-64-49-WZ(50))];
    _smallTableView.delegate=self;
    _smallTableView.dataSource=self;
    _smallTableView.tableFooterView=[[UIView alloc]init];
    [smallBgView addSubview:_smallTableView];
    
    UIButton *cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(30), SCREEN_HEIGHT-49-WZ(50), SCREEN_WIDTH-WZ(30*2), WZ(50))];
    cancelBtn.backgroundColor=COLOR_LIGHTGRAY;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [smallBgView addSubview:cancelBtn];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moduleListArray.count;
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
    
    NSDictionary *dict=self.moduleListArray[indexPath.row];
    NSString *name=[dict objectForKey:@"name"];
    cell.textLabel.text=name;
    cell.textLabel.font=FONT(17, 15);
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.shareImage&&self.moduleDict==nil) {
        self.moduleDict=self.moduleListArray[indexPath.row];
        [SVProgressHUD showWithStatus:@"加载中..."];
        [self getLanmuData];
    }else{
        NSDictionary *dict=self.moduleListArray[indexPath.row];
        self.lanmuID=[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        self.lanmuName=[dict objectForKey:@"name"];
        
        self.rightLabel.text=self.lanmuName;
        
        [self.smallBgView removeFromSuperview];
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(10))];
    headView.backgroundColor=COLOR_HEADVIEW;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(10);
}


#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//选择栏目
-(void)lanmuBtnClick
{
    
    [self createSmallTableView];
    if (self.shareImage) {
        self.moduleDict = nil;
        [self getLanmuData];
    }
    
}

//取消选择地址
-(void)cancelBtnClick
{
    [self.smallBgView removeFromSuperview];
}

//发布帖子
-(void)fabuBtnClick:(UIButton *)button
{
    NSLog(@"发布帖子");
    
    [self.titleTF resignFirstResponder];
    [self.contentTV resignFirstResponder];
    
    NSString *title=[self.titleTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content=[self.contentTV.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (self.lanmuCount<=0)
    {
        self.lanmuName=@"请选择栏目";
        self.lanmuID=[self.moduleDict objectForKey:@"id"];
    }
    
    if ([self.lanmuName isEqualToString:@""])
    {
        [self.view makeToast:@"请选择栏目" duration:2.0];
    }
    else
    {
        if ([title isEqualToString:@""] || title==nil)
        {
            [self.view makeToast:@"请输入标题" duration:2.0];
        }
        else
        {
            if ([content isEqualToString:@""] || content==nil)
            {
                [self.view makeToast:@"请输入内容" duration:2.0];
            }
            else
            {
                
                MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在发布..." detail:nil];
                button.userInteractionEnabled = NO;
                [hud show:YES];
                [hud hide:YES afterDelay:20];
                //发布帖子
                [HTTPManager addArticleWithCreateUserId:[UserInfoData getUserInfoFromArchive].userId moduleId:self.lanmuID areaId:[UserInfoData getUserInfoFromArchive].areaId title:title content:content imgSet:self.allImageArray complete:^(NSDictionary *resultDict) {
                    button.userInteractionEnabled = YES;
                    NSString *result=[resultDict objectForKey:@"result"];
                    if ([result isEqualToString:STATUS_SUCCESS])
                    {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        NSString *msg=[resultDict objectForKey:@"msg"];
                        [self.view makeToast:msg duration:2.0];
                    }
                    [hud hide:YES];
                }];
                
                
            }
        }
    }
    
    
}

//添加图片
-(void)addImageBtnClick
{
    if (9-self.allImageArray.count>0)
    {
        _imageVC=[[ChooseImagesViewController alloc]init];
        _imageVC.delegate=self;
        _imageVC.maxNumImage=9-self.allImageArray.count;
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:_imageVC animated:NO];
    }
    else
    {
        [self.view makeToast:@"图片最多选择9张" duration:2.0];
    }
    
    
}

-(void)withImageArray:(NSMutableArray*)imageArray withIsChoose:(BOOL)isChoose
{
    self.smallImageArray=imageArray;
    
    NSInteger imageCount=self.allImageArray.count+imageArray.count;
    
    if (imageCount<=9)
    {
        //创建九宫格
        [self createPictures];
    }
    
}

//创建九宫格的方法
-(void)createPictures
{
    //间距
    CGFloat space=WZ(9);
    CGFloat imageWidth=(SCREEN_WIDTH-WZ(15*2)-space*3)/4.0;
    CGFloat imageHeight=imageWidth;
    
    //每次都重新创建总数组里的imageView 创建之前全部清除上一次创建的imageView
    for (NSInteger i=0; i<self.imgArray.count; i++)
    {
        UIImageView *imgView=self.imgArray[i];
        UIButton *deleteBtn=self.deleteBtnArray[i];
        
        [imgView removeFromSuperview];
        [deleteBtn removeFromSuperview];
    }
    //清除imageView之后把存放imageView的数组也置空
    [self.imgArray removeAllObjects];
    [self.deleteBtnArray removeAllObjects];
    
    if (self.isDelete==YES)
    {
        if (self.smallImageArray.count>0)
        {
            for (NSInteger i=0; i<self.allImageArray.count; i++)
            {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*(i%4), WZ(15)+(imageHeight+space)*(i/4), imageWidth, imageHeight)];
                imageView.tag=i;
                imageView.image=self.allImageArray[i];
                [self.addImageBgView addSubview:imageView];
                self.imageView=imageView;
                
                UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
                [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
//                deleteBtn.backgroundColor=COLOR_CYAN;
                deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
                deleteBtn.clipsToBounds=YES;
                deleteBtn.tag=i;
                [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                [self.addImageBgView addSubview:deleteBtn];
                
                [self.imgArray addObject:imageView];
                [self.deleteBtnArray addObject:deleteBtn];
                
                
            }
            
            
            if (self.allImageArray.count==4 || self.allImageArray.count==8)
            {
                self.addImageBtn.frame=CGRectMake(WZ(15), self.imageView.bottom+space, imageWidth, imageHeight);
            }
            else
            {
                self.addImageBtn.frame=CGRectMake(self.imageView.right+space, self.imageView.top, imageWidth, imageHeight);
            }
            
            if (self.allImageArray.count<4)
            {
                self.addImageBgView.frame=CGRectMake(0, self.contentView.bottom, SCREEN_WIDTH, WZ(110));
            }
            if (self.allImageArray.count>=4 && self.allImageArray.count<8)
            {
                self.addImageBgView.frame=CGRectMake(0, self.contentView.bottom, SCREEN_WIDTH, WZ(110*2-15));
            }
            if (self.allImageArray.count>=8)
            {
                self.addImageBgView.frame=CGRectMake(0, self.contentView.bottom, SCREEN_WIDTH, WZ(110*3-15*2));
            }
            
        }
        
        self.isDelete=NO;
    }
    else
    {
        //然后把每次选择的图片数组加到总数组里
        [self.allImageArray addObjectsFromArray:self.smallImageArray];
        
        if (self.smallImageArray.count>0)
        {
            for (NSInteger i=0; i<self.allImageArray.count; i++)
            {
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*(i%4), WZ(15)+(imageHeight+space)*(i/4), imageWidth, imageHeight)];
                imageView.tag=i;
                imageView.image=self.allImageArray[i];
                [self.addImageBgView addSubview:imageView];
                self.imageView=imageView;
                
                UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
                [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
//                deleteBtn.backgroundColor=COLOR_CYAN;
                deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
                deleteBtn.clipsToBounds=YES;
                deleteBtn.tag=i;
                [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                [self.addImageBgView addSubview:deleteBtn];
                
                [self.imgArray addObject:imageView];
                [self.deleteBtnArray addObject:deleteBtn];
            }
            
            
            if (self.allImageArray.count==4 || self.allImageArray.count==8)
            {
                self.addImageBtn.frame=CGRectMake(WZ(15), self.imageView.bottom+space, imageWidth, imageHeight);
            }
            else
            {
                self.addImageBtn.frame=CGRectMake(self.imageView.right+space, self.imageView.top, imageWidth, imageHeight);
            }
            
            if (self.allImageArray.count<4)
            {
                self.addImageBgView.frame=CGRectMake(0, self.contentView.bottom, SCREEN_WIDTH, WZ(110));
            }
            if (self.allImageArray.count>=4 && self.allImageArray.count<8)
            {
                self.addImageBgView.frame=CGRectMake(0, self.contentView.bottom, SCREEN_WIDTH, WZ(110*2-15));
            }
            if (self.allImageArray.count>=8)
            {
                self.addImageBgView.frame=CGRectMake(0, self.contentView.bottom, SCREEN_WIDTH, WZ(110*3-15*2));
            }
        }
    }
    
    
}

//删除图片
-(void)deleteImageView:(UIButton*)button
{
    [self.allImageArray removeObjectAtIndex:button.tag];
    
    self.isDelete=YES;
    
    [self createPictures];
    
    if (self.allImageArray.count==0)
    {
        CGFloat space=WZ(9);
        CGFloat imageWidth=(SCREEN_WIDTH-WZ(15*2)-space*3)/4.0;
        CGFloat imageHeight=imageWidth;
        
        self.addImageBtn.frame=CGRectMake(WZ(15), WZ(15), imageWidth, imageHeight);
    }
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
