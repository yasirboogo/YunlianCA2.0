//
//  AddGoodsViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AddGoodsViewController.h"

@interface AddGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseImagesDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *_tableView;
    ChooseImagesViewController *_imageVC;
    
}

@property(nonatomic,strong)UILabel *goodsImageLabel;
@property(nonatomic,strong)UIButton * addImageBtn;
@property(nonatomic,strong)NSMutableArray *smallImageArray;
@property(nonatomic,strong)NSMutableArray *allImageArray;
@property(nonatomic,assign)BOOL isDelete;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *deleteBtnArray;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *imageDetailLabel;
@property(nonatomic,strong)UIScrollView *storeIconSV;

@property(nonatomic,strong)UITextField *goodsNameTF;
@property(nonatomic,strong)UITextView *goodsDesTV;
@property(nonatomic,strong)UITextField *oldPriceTF;
@property(nonatomic,strong)UITextField *discountPriceTF;
@property(nonatomic,strong)UITextField *repertoryTF;
@property(nonatomic,strong)UILabel *goodsDesLabel;

@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *goodsDes;
@property(nonatomic,strong)NSString *oldPrice;
@property(nonatomic,strong)NSString *discountPrice;
@property(nonatomic,strong)NSString *repertory;



@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goodsName=@"";
    self.goodsDes=@"";
    self.oldPrice=@"";
    self.discountPrice=@"";
    self.repertory=@"";
    
    
    self.smallImageArray=[NSMutableArray array];
    self.allImageArray=[NSMutableArray array];
    self.deleteBtnArray=[NSMutableArray array];
    self.imgArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=COLOR_WHITE;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(60), WZ(10), SCREEN_WIDTH-WZ(60*2), WZ(30))];
    titleLabel.font=FONT(19,17);
    titleLabel.text=@"添加商品";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(40), WZ(30))];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0 || section==3)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        static NSString *cellIdentifier=@"Cell0";
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
        
        UILabel *imageDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
        imageDetailLabel.text=[NSString stringWithFormat:@"图片详情(%lu/8张)",(unsigned long)self.allImageArray.count];
        imageDetailLabel.textColor=COLOR_LIGHTGRAY;
        imageDetailLabel.font=FONT(17, 15);
        [cell.contentView addSubview:imageDetailLabel];
        self.imageDetailLabel=imageDetailLabel;
        
        //间距
        CGFloat space=WZ(9);
        CGFloat imageWidth=(SCREEN_WIDTH-WZ(15*2)-space*3)/4.0;
        CGFloat imageHeight=imageWidth;
        
        UIScrollView *storeIconSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, imageDetailLabel.bottom, SCREEN_WIDTH, imageHeight)];
        storeIconSV.contentSize=CGSizeMake(WZ(15*2)+imageWidth*9+space*8, imageHeight);
        storeIconSV.pagingEnabled=NO;
        [cell.contentView addSubview:storeIconSV];
        self.storeIconSV=storeIconSV;
        
        UIButton * addImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), 0, imageWidth, imageHeight)];
        [addImageBtn setBackgroundImage:IMAGE(@"tianjiatupian") forState:UIControlStateNormal];
        addImageBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
        addImageBtn.layer.borderWidth=1.0;
        [addImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [storeIconSV addSubview:addImageBtn];
        self.addImageBtn=addImageBtn;
        
        for (NSInteger i=0; i<self.allImageArray.count; i++)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*i, 0, imageWidth, imageHeight)];
            imageView.tag=i;
            imageView.image=self.allImageArray[i];
            [self.storeIconSV addSubview:imageView];
            self.imageView=imageView;
            
            UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
            [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
//            deleteBtn.backgroundColor=COLOR_CYAN;
            deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
            deleteBtn.clipsToBounds=YES;
            deleteBtn.tag=i;
            [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
            [self.storeIconSV addSubview:deleteBtn];
            
            [self.imgArray addObject:imageView];
            [self.deleteBtnArray addObject:deleteBtn];
        }
        
        self.addImageBtn.frame=CGRectMake(self.imageView.right+space, self.imageView.top, imageWidth, imageHeight);
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==1)
    {
        static NSString *cellIdentifier=@"Cell1";
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
        
        if (indexPath.row==0)
        {
            cell.textLabel.text=@"商品名称";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            UITextField *goodsNameTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(260), 0, WZ(260), WZ(50))];
            goodsNameTF.delegate=self;
            goodsNameTF.text=self.goodsName;
            goodsNameTF.font=FONT(17, 15);
//            goodsNameTF.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:goodsNameTF];
            self.goodsNameTF=goodsNameTF;
        }
        if (indexPath.row==1)
        {
            UILabel *goodsDesLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            goodsDesLabel.text=[NSString stringWithFormat:@"商品简介(0/150)"];
            goodsDesLabel.textColor=COLOR_LIGHTGRAY;
            goodsDesLabel.font=FONT(17, 15);
            [cell.contentView addSubview:goodsDesLabel];
            self.goodsDesLabel=goodsDesLabel;
            
            UITextView *goodsDesTV=[[UITextView alloc]initWithFrame:CGRectMake(WZ(15), goodsDesLabel.bottom, SCREEN_WIDTH-WZ(15*2), WZ(90))];
            goodsDesTV.delegate=self;
            goodsDesTV.text=self.goodsDes;
            goodsDesTV.font=FONT(17, 15);
            //        goodsDesTV.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:goodsDesTV];
            self.goodsDesTV=goodsDesTV;
        }
        
        
        
        cell.textLabel.font=FONT(17, 15);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section==2)
    {
        static NSString *cellIdentifier=@"Cell2";
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
        
        NSArray *titleArray=[[NSArray alloc]initWithObjects:@"原价",@"折后价", nil];
        cell.textLabel.text=titleArray[indexPath.row];
        cell.textLabel.textColor=COLOR_LIGHTGRAY;
        
        if (indexPath.row==0)
        {
            UITextField *oldPriceTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(260), 0, WZ(260), WZ(50))];
            oldPriceTF.delegate=self;
            oldPriceTF.text=self.oldPrice;
            oldPriceTF.font=FONT(17, 15);
//            oldPriceTF.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:oldPriceTF];
            self.oldPriceTF=oldPriceTF;
        }
        if (indexPath.row==1)
        {
            UITextField *discountPriceTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(260), 0, WZ(260), WZ(50))];
            discountPriceTF.delegate=self;
            discountPriceTF.text=self.discountPrice;
            discountPriceTF.font=FONT(17, 15);
//            discountPriceTF.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:discountPriceTF];
            self.discountPriceTF=discountPriceTF;
        }
        
        cell.textLabel.font=FONT(17, 15);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"Cell3";
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
        
        cell.textLabel.text=@"库存";
        cell.textLabel.textColor=COLOR_LIGHTGRAY;
        
        UITextField *repertoryTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(260), 0, WZ(260), WZ(50))];
        repertoryTF.delegate=self;
        repertoryTF.text=self.repertory;
        repertoryTF.font=FONT(17, 15);
        [cell.contentView addSubview:repertoryTF];
        self.repertoryTF=repertoryTF;
        
        cell.textLabel.font=FONT(17, 15);
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
    if (section==0)
    {
        return nil;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return WZ(145);
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            return WZ(50);
        }
        else
        {
            return WZ(120);
        }
    }
    else
    {
        return WZ(50);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(15);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.goodsNameTF)
    {
        self.goodsName=textField.text;
    }
    if (textField==self.oldPriceTF)
    {
        self.oldPrice=textField.text;
    }
    if (textField==self.discountPriceTF)
    {
        self.discountPrice=textField.text;
    }
    if (textField==self.repertoryTF)
    {
        self.repertory=textField.text;
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==self.goodsDesTV)
    {
        self.goodsDes=textView.text;
    }
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存商品
-(void)rightBtnClick
{
    NSLog(@"保存商品");
    
    [self.goodsNameTF resignFirstResponder];
    [self.goodsDesTV resignFirstResponder];
    [self.oldPriceTF resignFirstResponder];
    [self.discountPriceTF resignFirstResponder];
    [self.repertoryTF resignFirstResponder];
    
    self.storeId=[NSString stringWithFormat:@"%@",self.storeId];
    
    if ([self.storeId isEqualToString:@""] || [self.goodsName isEqualToString:@""] || [self.goodsDes isEqualToString:@""] || [self.oldPrice isEqualToString:@""] || [self.discountPrice isEqualToString:@""] || [self.repertory isEqualToString:@""] || self.allImageArray.count<=0)
    {
        [self.view makeToast:@"请填写完整商品信息" duration:2.0];
    }
    else
    {
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在添加..." detail:nil];
        [hud show:YES];
        [HTTPManager addGoodsInStoreWithName:self.goodsName explain:self.goodsDes price:self.oldPrice priceZH:self.discountPrice repertory:self.repertory storeId:self.storeId imgs:self.allImageArray complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
            else
            {
                [self.view makeToast:[resultDict objectForKey:@"error"] duration:2.0];
            }
            [hud hide:YES];
        }];
        [hud hide:YES afterDelay:20];
    }
    
}

//添加店铺图片
-(void)addImageBtnClick
{
    if (8-self.allImageArray.count>0)
    {
        _imageVC=[[ChooseImagesViewController alloc]init];
        _imageVC.delegate=self;
        _imageVC.maxNumImage=8-self.allImageArray.count;
        self.navigationController.navigationBarHidden=YES;
        [self.navigationController pushViewController:_imageVC animated:NO];
    }
    else
    {
        [self.view makeToast:@"图片最多选择8张" duration:2.0];
    }
    
    
}

-(void)withImageArray:(NSMutableArray*)imageArray withIsChoose:(BOOL)isChoose
{
    self.smallImageArray=imageArray;
    
    NSInteger imageCount=self.allImageArray.count+imageArray.count;
    
    if (imageCount<=8)
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
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*i, 0, imageWidth, imageHeight)];
                imageView.tag=i;
                imageView.image=self.allImageArray[i];
                [self.storeIconSV addSubview:imageView];
                self.imageView=imageView;
                
                UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
                [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
                deleteBtn.backgroundColor=COLOR_CYAN;
                deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
                deleteBtn.clipsToBounds=YES;
                deleteBtn.tag=i;
                [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                [self.storeIconSV addSubview:deleteBtn];
                
                [self.imgArray addObject:imageView];
                [self.deleteBtnArray addObject:deleteBtn];
            }
            
            self.addImageBtn.frame=CGRectMake(self.imageView.right+space, self.imageView.top, imageWidth, imageHeight);
            
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
                UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15)+(space+imageWidth)*i, 0, imageWidth, imageHeight)];
                imageView.tag=i;
                imageView.image=self.allImageArray[i];
                [self.storeIconSV addSubview:imageView];
                self.imageView=imageView;
                
                UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(imageView.right-WZ(15+5), imageView.top+WZ(5), WZ(15), WZ(15))];
                [deleteBtn setBackgroundImage:IMAGE(@"shanchutupian") forState:UIControlStateNormal];
                deleteBtn.backgroundColor=COLOR_CYAN;
                deleteBtn.layer.cornerRadius=deleteBtn.width/2.0;
                deleteBtn.clipsToBounds=YES;
                deleteBtn.tag=i;
                [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                [self.storeIconSV addSubview:deleteBtn];
                
                [self.imgArray addObject:imageView];
                [self.deleteBtnArray addObject:deleteBtn];
            }
            
            self.addImageBtn.frame=CGRectMake(self.imageView.right+space, self.imageView.top, imageWidth, imageHeight);
        }
    }
    
    self.imageDetailLabel.text=[NSString stringWithFormat:@"图片详情(%lu/8张)",(unsigned long)self.allImageArray.count];
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
        
        self.addImageBtn.frame=CGRectMake(WZ(15), 0, imageWidth, imageHeight);
    }
    
    self.imageDetailLabel.text=[NSString stringWithFormat:@"图片详情(%lu/8张)",(unsigned long)self.allImageArray.count];
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
