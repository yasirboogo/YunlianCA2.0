//
//  OrderCommentViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "OrderCommentViewController.h"

@interface OrderCommentViewController ()<UIScrollViewDelegate,ChooseImagesDelegate,YYTextViewDelegate>
{
    UIScrollView *_bgScrollView;
    ChooseImagesViewController *_imageVC;
    
}

@property(nonatomic,strong)NSMutableArray *smallImageArray;
@property(nonatomic,strong)NSMutableArray *allImageArray;
@property(nonatomic,assign)BOOL isDelete;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *deleteBtnArray;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton * addImageBtn;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSMutableArray *starBtnArray;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)YYTextView *contentTV;
@property(nonatomic,strong)NSString *starCount;

@end

@implementation OrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.content=@"";
    self.starCount=@"0";
    
    self.smallImageArray=[NSMutableArray array];
    self.allImageArray=[NSMutableArray array];
    self.deleteBtnArray=[NSMutableArray array];
    self.imgArray=[NSMutableArray array];
    self.starBtnArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createSubviews];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

-(void)createNavigationBar
{
    self.title=@"去评价";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+50), WZ(10), WZ(50), WZ(30))];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
}

-(void)createSubviews
{
    _bgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+WZ(100));
    _bgScrollView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_bgScrollView];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(15), SCREEN_WIDTH, WZ(210))];
    bgView.backgroundColor=COLOR_WHITE;
    [_bgScrollView addSubview:bgView];
    self.bgView=bgView;
    
    UIView *lineView=[UIView lineViewWithFrame:CGRectMake(WZ(15), WZ(80), SCREEN_WIDTH-WZ(15*2), 1)];
    [bgView addSubview:lineView];
    
    NSString *zpString=@"总评:";
    CGSize zpSize=[ViewController sizeWithString:zpString font:FONT(17,15
                                                                    ) maxSize:CGSizeMake(WZ(100), WZ(80))];
    UILabel *zpLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, zpSize.width, WZ(80))];
    zpLabel.text=zpString;
    zpLabel.font=FONT(17,15);
    [bgView addSubview:zpLabel];
    
    for (NSInteger i=0; i<5; i++)
    {
        UIButton *starBtn=[[UIButton alloc]initWithFrame:CGRectMake(zpLabel.right+WZ(22)+(WZ(27)+WZ(20))*(i%5), WZ(27), WZ(27), WZ(27))];
        starBtn.tag=i;
        [starBtn setBackgroundImage:IMAGE(@"wode_dingdanpingjia_hui") forState:UIControlStateNormal];
        [starBtn addTarget:self action:@selector(starBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:starBtn];
        
        [self.starBtnArray addObject:starBtn];
    }
    
    
    YYTextView *contentTV=[[YYTextView alloc]initWithFrame:CGRectMake(WZ(15), lineView.bottom, SCREEN_WIDTH-WZ(15*2), WZ(130))];
    contentTV.delegate=self;
    contentTV.placeholderText=@"长度在5-200字之间，您可以将自己的感受与大家分享一下(^_^)";
    contentTV.placeholderFont=FONT(17,15);
    contentTV.font=FONT(17,15);
    [bgView addSubview:contentTV];
    self.contentTV=contentTV;
    
    UIButton * addImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), bgView.bottom+WZ(15), WZ(80), WZ(80))];
    [addImageBtn setBackgroundImage:IMAGE(@"tianjiatupian") forState:UIControlStateNormal];
    addImageBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    addImageBtn.layer.borderWidth=1.0;
    [addImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:addImageBtn];
    self.addImageBtn=addImageBtn;
    
    
}

- (void)textViewDidChange:(YYTextView *)textView
{
    self.content=textView.text;
}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交评价
-(void)rightBtnClick
{
    NSLog(@"提交评价");
    [self.contentTV resignFirstResponder];
    NSString *storeId=[self.orderDict objectForKey:@"storeId"];
    if (storeId==nil)
    {
        storeId=@"";
    }
    
    NSMutableArray *goodsIdArray=[NSMutableArray array];
    NSArray *goodsArray=[self.orderDict objectForKey:@"orderItemSet"];
    for (NSDictionary *goodsDict in goodsArray)
    {
        NSString *goodsId=[goodsDict objectForKey:@"id"];
        [goodsIdArray addObject:goodsId];
    }
    NSString *goodsIdString=[goodsIdArray componentsJoinedByString:@","];
    NSString *payInfoId=[self.orderDict objectForKey:@"id"];
    
    
    if ([self.starCount isEqualToString:@"0"])
    {
        [self.view makeToast:@"您还没有选星星" duration:1.0];
    }
    else
    {
        if (self.content.length<5 || self.content.length>200)
        {
            [self.view makeToast:@"评价内容长度在5~200个字" duration:1.0];
        }
        else
        {
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view.window title:@"提交评价..." detail:nil];
            [hud show:YES];
            [hud hide:YES afterDelay:30];
            
            [HTTPManager addCommentWithUserId:[UserInfoData getUserInfoFromArchive].userId userName:[UserInfoData getUserInfoFromArchive].username payInfoId:payInfoId objectId:goodsIdString parentId:@"" type:@"2" storeId:storeId content:self.content star:self.starCount imageArray:self.allImageArray complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.view.window makeToast:@"提交评论成功" duration:2.0];
                    
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"yes",@"isOK", nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"isComment" object:nil userInfo:dict];
                }
                else
                {
                    [self.view makeToast:result duration:2.0];
                }
                [hud hide:YES];
            }];
        }
    }
}

//星星
-(void)starBtnClick:(UIButton*)button
{
    for (UIButton *btn in self.starBtnArray)
    {
        if (btn.tag<=button.tag)
        {
            [btn setBackgroundImage:IMAGE(@"wode_dingdanpingjia_huang") forState:UIControlStateNormal];
//            NSLog(@"%ld星评价",(long)button.tag+1);
        }
        else
        {
            [btn setBackgroundImage:IMAGE(@"wode_dingdanpingjia_hui") forState:UIControlStateNormal];
        }
    }
    
    self.starCount=[NSString stringWithFormat:@"%ld",button.tag+1];
    NSLog(@"%@颗星",self.starCount);
}

//添加图片
-(void)addImageBtnClick
{
    if (3-self.allImageArray.count>0)
    {
        _imageVC=[[ChooseImagesViewController alloc]init];
        _imageVC.delegate=self;
        _imageVC.maxNumImage=3-self.allImageArray.count;
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:_imageVC animated:NO];
    }
    else
    {
        [self.view makeToast:@"图片最多选择3张" duration:2.0];
    }
}

-(void)withImageArray:(NSMutableArray*)imageArray withIsChoose:(BOOL)isChoose
{
    self.smallImageArray=imageArray;
    
    NSInteger imageCount=self.allImageArray.count+imageArray.count;
    
    if (imageCount<=3)
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
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*(i%4), self.bgView.bottom+WZ(15)+(imageHeight+space)*(i/4), imageWidth, imageHeight)];
                imageView.tag=i;
                imageView.image=self.allImageArray[i];
                [_bgScrollView addSubview:imageView];
                self.imageView=imageView;
                
                UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
                [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
//                deleteBtn.backgroundColor=COLOR_CYAN;
                deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
                deleteBtn.clipsToBounds=YES;
                deleteBtn.tag=i;
                [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                [_bgScrollView addSubview:deleteBtn];
                
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
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*(i%4), self.bgView.bottom+WZ(15)+(imageHeight+space)*(i/4), imageWidth, imageHeight)];
                imageView.tag=i;
                imageView.image=self.allImageArray[i];
                [_bgScrollView addSubview:imageView];
                self.imageView=imageView;
                
                UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
                [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
//                deleteBtn.backgroundColor=COLOR_CYAN;
                deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
                deleteBtn.clipsToBounds=YES;
                deleteBtn.tag=i;
                [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                [_bgScrollView addSubview:deleteBtn];
                
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
        
        self.addImageBtn.frame=CGRectMake(WZ(15), self.bgView.bottom+WZ(15), imageWidth, imageHeight);
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
