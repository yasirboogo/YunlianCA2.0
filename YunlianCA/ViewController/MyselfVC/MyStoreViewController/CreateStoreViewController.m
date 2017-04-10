//
//  CreateStoreViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/7/13.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "CreateStoreViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "StoreManageViewController.h"
#import "MapViewController.h"

@interface CreateStoreViewController ()<UITableViewDelegate,UITableViewDataSource,ChooseImagesDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *_tableView;
    ChooseImagesViewController *_imageVC;
    UITableView *_smallTableView;
}

@property(nonatomic,assign)NSInteger myStoreCount;

@property(nonatomic,strong)UIButton * addImageBtn;
@property(nonatomic,strong)NSMutableArray *smallImageArray;
@property(nonatomic,strong)NSMutableArray *allImageArray;
@property(nonatomic,assign)BOOL isDelete;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,strong)NSMutableArray *deleteBtnArray;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *imageDetailLabel;
@property(nonatomic,strong)UIView *smallBgView;

@property(nonatomic,strong)NSMutableArray *categoryArray;
@property(nonatomic,assign)NSInteger selectedRow;
@property(nonatomic,strong)UILabel *lanmuLabel;
@property(nonatomic,strong)UILabel *erjilanmuLabel;
@property(nonatomic,strong)NSString *lanmu;
@property(nonatomic,strong)NSString *erjilanmu;
@property(nonatomic,strong)NSString *firstCategoryId;
@property(nonatomic,strong)NSString *secondCategoryId;

@property(nonatomic,strong)UIImageView *headIV;
@property(nonatomic,strong)UIImage *storeIcon;
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,strong)NSString *storeDes;
@property(nonatomic,strong)NSString *storeMobile;
@property(nonatomic,strong)NSString *storeContact;
@property(nonatomic,strong)NSString *storeAddress;
@property(nonatomic,strong)NSString *storeMapAddress;
@property(nonatomic,strong)UITextField *storeNameTF;
@property(nonatomic,strong)UITextView *jianjieTV;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *contactTF;
@property(nonatomic,strong)UITextField *addressTF;
@property(nonatomic,strong)NSString *openTime;

@property(nonatomic,strong)UIScrollView *storeIconSV;
@property(nonatomic,strong)UIImageView *checkIV;
@property(nonatomic,strong)UILabel *startTimeLabel;
@property(nonatomic,strong)UILabel *endTimeLabel;
@property(nonatomic,assign)BOOL isAllDay;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;
@property(nonatomic,assign)NSInteger dateSelectedRow;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *longitudeString;
@property(nonatomic,strong)NSString *latitudeString;

@end

@implementation CreateStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myStoreCount=0;
    self.lanmu=@"";
    self.erjilanmu=@"";
    self.storeName=@"";
    self.storeDes=@"";
    self.storeMobile=@"";
    self.storeContact=@"";
    self.storeAddress=@"";
    self.storeMapAddress=@"";
    self.longitudeString=@"";
    self.latitudeString=@"";
    
    self.isAllDay=YES;
    
    
    self.smallImageArray=[NSMutableArray array];
    self.allImageArray=[NSMutableArray array];
    self.deleteBtnArray=[NSMutableArray array];
    self.imgArray=[NSMutableArray array];
    self.categoryArray=[NSMutableArray array];
    
    [self createNavigationBar];
    [self createTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAddressNotification:) name:@"address" object:nil];
    
}

-(void)getAddressNotification:(NSNotification*)notification
{
    NSDictionary *addressDict=[notification userInfo];
    NSString *pcaAddress=[addressDict objectForKey:@"pca"];
    NSString *detailAddress=[addressDict objectForKey:@"street"];
    self.storeMapAddress=[NSString stringWithFormat:@"%@%@",pcaAddress,detailAddress];
    self.longitudeString=[addressDict objectForKey:@"lon"];
    self.latitudeString=[addressDict objectForKey:@"lat"];
    
    [_tableView reloadData];
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
    titleLabel.text=@"创建店铺";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(40), WZ(30))];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
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

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    if (self.myStoreCount==0)
    {
        _tableView.tag=0;
    }
    if (self.myStoreCount>0)
    {
        _tableView.tag=1;
    }
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_tableView)
    {
        return 8;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_tableView)
    {
        if (section==7)
        {
            return 3;
        }
        if (section==0 || section==1 || section==4)
        {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return self.categoryArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"栏目",@"二级栏目", nil];
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            if (indexPath.row==0)
            {
                UILabel *lanmuLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
                lanmuLabel.text=self.lanmu;
                //            lanmuLabel.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:lanmuLabel];
                self.lanmuLabel=lanmuLabel;
                
                UIImageView *sanjiaoIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+13), WZ(20), WZ(13), WZ(10))];
                sanjiaoIV.image=IMAGE(@"");
                //            sanjiaoIV.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:sanjiaoIV];
            }
            else
            {
                UILabel *erjilanmuLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
                erjilanmuLabel.text=self.erjilanmu;
                //            erjilanmuLabel.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:erjilanmuLabel];
                self.erjilanmuLabel=erjilanmuLabel;
                
                UIImageView *sanjiaoIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+13), WZ(20), WZ(13), WZ(10))];
                sanjiaoIV.image=IMAGE(@"");
                //            sanjiaoIV.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:sanjiaoIV];
            }
            
            
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"店铺头像",@"店铺名称", nil];
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            if (indexPath.row==0)
            {
                UIImageView *headIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(50), WZ(10), WZ(50), WZ(50))];
                headIV.image=self.storeIcon;
                headIV.image=IMAGE(@"dianputouxiang");
                headIV.clipsToBounds=YES;
                headIV.layer.cornerRadius=headIV.width/2.0;
                [cell.contentView addSubview:headIV];
                self.headIV=headIV;
                
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row==1)
            {
                UITextField *storeNameTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
                storeNameTF.delegate=self;
                storeNameTF.text=self.storeName;
                storeNameTF.font=FONT(15, 13);
                //            storeNameTF.placeholder=@"请输入店铺名称";
                //            storeNameTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:storeNameTF];
                self.storeNameTF=storeNameTF;
            }
            
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
            
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            titleLabel.text=@"店铺简介";
            titleLabel.textColor=COLOR_LIGHTGRAY;
            [cell.contentView addSubview:titleLabel];
            
            UITextView *jianjieTV=[[UITextView alloc]initWithFrame:CGRectMake(WZ(15), titleLabel.bottom, SCREEN_WIDTH-WZ(15*2), WZ(90))];
            jianjieTV.delegate=self;
            jianjieTV.text=self.storeDes;
            jianjieTV.font=FONT(15, 13);
            //        jianjieTV.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:jianjieTV];
            self.jianjieTV=jianjieTV;
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==3)
        {
            UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            
            UILabel *imageDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), WZ(50))];
            imageDetailLabel.text=[NSString stringWithFormat:@"图片详情(%lu/8张)",(unsigned long)self.allImageArray.count];
            imageDetailLabel.textColor=COLOR_LIGHTGRAY;
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
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==4)
        {
            static NSString *cellIdentifier=@"Cell4";
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
            
            NSArray *titleArray=[[NSArray alloc]initWithObjects:@"联系电话",@"联系人", nil];
            cell.textLabel.text=titleArray[indexPath.row];
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            if (indexPath.row==0)
            {
                UITextField *phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
                phoneTF.text=self.storeMobile;
                phoneTF.font=FONT(15, 13);
                phoneTF.delegate=self;
                //            lxdhTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:phoneTF];
                self.phoneTF=phoneTF;
            }
            if (indexPath.row==1)
            {
                UITextField *contactTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
                contactTF.text=self.storeContact;
                contactTF.font=FONT(15, 13);
                contactTF.delegate=self;
                //            lxrTF.backgroundColor=COLOR_CYAN;
                [cell.contentView addSubview:contactTF];
                self.contactTF=contactTF;
            }
            
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==5)
        {
            static NSString *cellIdentifier=@"Cell5";
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
            
            cell.textLabel.text=@"地址";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            UITextField *addressTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
            addressTF.delegate=self;
            addressTF.text=self.storeAddress;
            addressTF.font=FONT(15, 13);
            //        addressTF.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:addressTF];
            self.addressTF=addressTF;
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.section==6)
        {
            static NSString *cellIdentifier=@"Cell6";
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
            
            cell.textLabel.text=@"地图选址";
            cell.textLabel.textColor=COLOR_LIGHTGRAY;
            
            UILabel *dtxzLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(240), 0, WZ(240), WZ(50))];
            dtxzLabel.text=self.storeMapAddress;
            dtxzLabel.font=FONT(15,13);
            dtxzLabel.numberOfLines=2;
            //        dtxzLabel.textAlignment=NSTextAlignmentRight;
            //        dtxzLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:dtxzLabel];
            
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            static NSString *cellIdentifier=@"Cell7";
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
            
            NSArray *timeArray=[[NSArray alloc]initWithObjects:@"全天",@"开始",@"结束", nil];
            cell.textLabel.text=timeArray[indexPath.row];
            
            if (indexPath.row==0)
            {
                UIImageView *checkIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(20), WZ(17.5), WZ(15), WZ(15))];
                checkIV.image=IMAGE(@"xuanzhong");
//                checkIV.backgroundColor=COLOR_RED;
                checkIV.clipsToBounds=YES;
                checkIV.layer.cornerRadius=checkIV.width/2.0;
                [cell.contentView addSubview:checkIV];
                checkIV.hidden=!self.isAllDay;
                self.checkIV=checkIV;
            }
            if (indexPath.row==1)
            {
                UILabel *startTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(240), 0, WZ(240), WZ(50))];
                
                startTimeLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:startTimeLabel];
                self.startTimeLabel=startTimeLabel;
                
                if (self.isAllDay==YES)
                {
                    startTimeLabel.textColor=COLOR_LIGHTGRAY;
                }
                else
                {
                    startTimeLabel.textColor=COLOR_RED;
                }
                
                if (self.startTime==nil || [self.startTime isEqualToString:@""])
                {
                    NSDate *currentTime=[NSDate date];
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"HH:mm"];
                    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
                    NSString *startDate=[formatter stringFromDate:currentTime];
                    startTimeLabel.text=startDate;
                }
                else
                {
                    startTimeLabel.text=self.startTime;
                }
                
                cell.userInteractionEnabled=NO;
            }
            if (indexPath.row==2)
            {
                UILabel *endTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10)-WZ(240), 0, WZ(240), WZ(50))];
                endTimeLabel.textColor=COLOR_LIGHTGRAY;
                endTimeLabel.textAlignment=NSTextAlignmentRight;
                [cell.contentView addSubview:endTimeLabel];
                self.endTimeLabel=endTimeLabel;
                
                if (self.isAllDay==YES)
                {
                    endTimeLabel.textColor=COLOR_LIGHTGRAY;
                }
                else
                {
                    endTimeLabel.textColor=COLOR_RED;
                }
                
                if (self.endTime==nil || [self.endTime isEqualToString:@""])
                {
                    NSDate *currentTime=[NSDate date];
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"HH:mm"];
                    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
                    NSString *endDate=[formatter stringFromDate:currentTime];
                    endTimeLabel.text=endDate;
                }
                else
                {
                    endTimeLabel.text=self.endTime;
                }
                
                cell.userInteractionEnabled=NO;
            }
            
            
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
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
        
        
        
        UILabel *lanmuLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15), WZ(50))];
        lanmuLabel.text=[self.categoryArray[indexPath.row] objectForKey:@"name"];
        lanmuLabel.font=FONT(17, 15);
        [cell.contentView addSubview:lanmuLabel];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_tableView)
    {
        if (indexPath.section==0)
        {
            self.selectedRow=indexPath.row;
            
            if (indexPath.row==0)
            {
                self.lanmu=@"";
                self.erjilanmu=@"";
                //一级栏目
                [HTTPManager getFirstCategoryForAddStore:^(StoreModel *model) {
                    self.categoryArray=model.firstCategoryArray;
                    [self createSmallTableView];
                }];
                
            }
            if (indexPath.row==1)
            {
                if ([self.lanmu isEqualToString:@""])
                {
                    [self.view makeToast:@"请先选择一级栏目" duration:2.0];
                }
                else
                {
                    //二级栏目
                    [HTTPManager getSecondCategoryForAddStoreWithPatentId:self.firstCategoryId complete:^(StoreModel *model) {
                        self.categoryArray=model.secondCategoryArray;
                        [self createSmallTableView];
                    }];
                }
            }
        }
        if (indexPath.section==1)
        {
            if (indexPath.row==0)
            {
                //店铺头像
                [self changeStoreIcon];
            }
        }
        if (indexPath.section==6)
        {
            //地图选址
            MapViewController *vc=[[MapViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.section==7)
        {
            self.dateSelectedRow=indexPath.row;
            //营业时间
            if (indexPath.row==0)
            {
                //全天
                if (self.isAllDay==YES)
                {
                    self.checkIV.hidden=YES;
                    self.startTimeLabel.textColor=COLOR_RED;
                    self.endTimeLabel.textColor=COLOR_RED;
                    
                    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:1 inSection:7];
                    UITableViewCell *cell1=[tableView cellForRowAtIndexPath:indexPath1];
                    cell1.userInteractionEnabled=YES;
                    
                    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:7];
                    UITableViewCell *cell2=[tableView cellForRowAtIndexPath:indexPath2];
                    cell2.userInteractionEnabled=YES;
                }
                else
                {
                    self.checkIV.hidden=NO;
                    self.startTimeLabel.textColor=COLOR_LIGHTGRAY;
                    self.endTimeLabel.textColor=COLOR_LIGHTGRAY;
                    
                    NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:1 inSection:7];
                    UITableViewCell *cell1=[tableView cellForRowAtIndexPath:indexPath1];
                    cell1.userInteractionEnabled=NO;
                    
                    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:7];
                    UITableViewCell *cell2=[tableView cellForRowAtIndexPath:indexPath2];
                    cell2.userInteractionEnabled=NO;
                }
                
                self.isAllDay=!self.isAllDay;
                
                
            }
            if (indexPath.row==1)
            {
                //开始营业时间
                CGFloat viewWidth=SCREEN_WIDTH-WZ(30*2);
                CGFloat viewHeight=SCREEN_WIDTH-WZ(30*2);
                
                [self createBackgroundViewWithSmallViewFrame:CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight) titleString:@"开始营业时间" datePickerMode:0];
                
                NSLog(@"开始营业时间");
            }
            if (indexPath.row==2)
            {
                //结束营业时间
                CGFloat viewWidth=SCREEN_WIDTH-WZ(30*2);
                CGFloat viewHeight=SCREEN_WIDTH-WZ(30*2);
                
                [self createBackgroundViewWithSmallViewFrame:CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight) titleString:@"结束营业时间" datePickerMode:0];
                
                NSLog(@"结束营业时间");
            }
        }
    }
    else
    {
        if (self.selectedRow==0)
        {
            self.firstCategoryId=[NSString stringWithFormat:@"%@",[self.categoryArray[indexPath.row] objectForKey:@"id"]];
            self.lanmu=[self.categoryArray[indexPath.row] objectForKey:@"name"];
            self.lanmuLabel.text=self.lanmu;
            [self.smallBgView removeFromSuperview];
            
            if (![self.lanmu isEqualToString:@""])
            {
                //把以前选择的地址置空
                self.erjilanmu=@"";
                self.erjilanmuLabel.text=@"";
            }
        }
        if (self.selectedRow==1)
        {
            self.secondCategoryId=[NSString stringWithFormat:@"%@",[self.categoryArray[indexPath.row] objectForKey:@"id"]];
            self.erjilanmu=[self.categoryArray[indexPath.row] objectForKey:@"name"];
            self.erjilanmuLabel.text=self.erjilanmu;
            [self.smallBgView removeFromSuperview];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    if (section==7)
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(65))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(15), SCREEN_WIDTH, WZ(50))];
        bgView.backgroundColor=COLOR_WHITE;
        [titleView addSubview:bgView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH, WZ(50))];
        titleLabel.text=@"营业时间";
        titleLabel.textColor=COLOR_LIGHTGRAY;
        titleLabel.backgroundColor=COLOR_WHITE;
        [bgView addSubview:titleLabel];
        
        return titleView;
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
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            return WZ(75);
        }
        else
        {
            return WZ(50);
        }
    }
    if (indexPath.section==2)
    {
        return WZ(150);
    }
    if (indexPath.section==3)
    {
        return WZ(145);
    }
    else
    {
        return WZ(50);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    if (section==7)
    {
        return WZ(65);
    }
    else
    {
        return WZ(15);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.storeNameTF)
    {
        self.storeName=textField.text;
    }
    if (textField==self.phoneTF)
    {
        self.storeMobile=textField.text;
    }
    if (textField==self.contactTF)
    {
        self.storeContact=textField.text;
    }
    if (textField==self.addressTF)
    {
        self.storeAddress=textField.text;
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==self.jianjieTV)
    {
        self.storeDes=textView.text;
    }
}

//创建背景View
-(void)createBackgroundViewWithSmallViewFrame:(CGRect)frame titleString:(NSString *)titleString datePickerMode:(NSInteger)datePickerMode
{
    CGFloat spaceToBorder=WZ(20);
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView=bgView;
    self.bgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    [self.view.window addSubview:self.bgView];
    
    UIView *smallView=[[UIView alloc]initWithFrame:frame];//CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight)
    smallView.backgroundColor=COLOR_WHITE;
    smallView.clipsToBounds=YES;
    smallView.layer.cornerRadius=5;
    [self.bgView addSubview:smallView];
    self.smallView=smallView;
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(40)+WZ(10), self.smallView.width-spaceToBorder*2, WZ(200))];
    //    datePicker.backgroundColor=COLOR_CYAN;
    NSDate *currentTime=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [datePicker setDate:currentTime animated:YES];
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    [datePicker setDatePickerMode:datePickerMode];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.smallView addSubview:datePicker];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(spaceToBorder, WZ(10), smallView.width-WZ(spaceToBorder*2), WZ(30))];
    titleLabel.text=titleString;
    titleLabel.textColor=COLOR_LIGHTGRAY;
    titleLabel.font=FONT(17, 15);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [smallView addSubview:titleLabel];
    NSArray *qxqdArray=[[NSArray alloc]initWithObjects:@"取消",@"确定", nil];
    
    CGFloat buttonWidth=WZ(100);
    CGFloat buttonHeight=WZ(35);
    CGFloat buttonSpace=frame.size.width-buttonWidth*2-spaceToBorder*2;
    
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *qxqdBtn=[[UIButton alloc]initWithFrame:CGRectMake(spaceToBorder+(buttonWidth+buttonSpace)*(i%2), frame.size.height-buttonHeight-WZ(20), buttonWidth, buttonHeight)];
        [qxqdBtn setTitle:qxqdArray[i] forState:UIControlStateNormal];
        qxqdBtn.titleLabel.font=FONT(17, 15);
        qxqdBtn.clipsToBounds=YES;
        qxqdBtn.layer.cornerRadius=5;
        qxqdBtn.tag=i;
        [qxqdBtn addTarget:self action:@selector(qxqdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [smallView addSubview:qxqdBtn];
        
        if (i==0)
        {
            [qxqdBtn setTitleColor:COLOR(98, 99, 100, 1) forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(230, 235, 235, 1);
        }
        if (i==1)
        {
            [qxqdBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
            qxqdBtn.backgroundColor=COLOR(0, 184, 201, 1);
        }
        
        
        
    }
    
    
}

//选择时间的方法
-(void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    if (self.dateSelectedRow==1)
    {
        NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"HH:mm"];
        self.startTime = [formatter1 stringFromDate:datePicker.date];
        
        NSLog(@"选择的开始时间: %@", self.startTime);
    }
    if (self.dateSelectedRow==2)
    {
        NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
        [formatter2 setDateFormat:@"HH:mm"];
        self.endTime = [formatter2 stringFromDate:datePicker.date];
        
        NSLog(@"选择的结束时间: %@", self.endTime);
    }
    
    
    
    
}

//选择日期时间View的取消和确定按钮
-(void)qxqdBtnClick:(UIButton *)button
{
    if (button.tag==0)
    {
        [self.bgView removeFromSuperview];
    }
    else
    {
        [self.bgView removeFromSuperview];
        
        if (self.dateSelectedRow==1)
        {
            self.startTimeLabel.text=self.startTime;
        }
        if (self.dateSelectedRow==2)
        {
            self.endTimeLabel.text=self.endTime;
        }
        //        NSLog(@"活动时间====%@",self.timeString);
        
    }
    
    
    
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//跳到店铺管理界面
-(void)rightBtnClick
{
    NSLog(@"发布店铺");
    
    [self.storeNameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.contactTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.jianjieTV resignFirstResponder];
    
    NSDate *currentTime=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSString *createTime = [formatter stringFromDate:currentTime];
    //    NSLog(@"当前时间===%@",createTime);
    
    if ([self.lanmu isEqualToString:@""] || [self.erjilanmu isEqualToString:@""] || self.storeIcon==nil || [self.storeName isEqualToString:@""] || [self.storeDes isEqualToString:@""] || self.allImageArray.count<=0 || [self.storeMapAddress isEqualToString:@""] || [self.storeMobile isEqualToString:@""] || [self.storeContact isEqualToString:@""] || [self.latitudeString isEqualToString:@""] || [self.longitudeString isEqualToString:@""])
    {
        [self.view makeToast:@"请填写完整店铺信息" duration:2.0];
    }
    else
    {
        if (self.isAllDay==YES)
        {
            self.openTime=@"00:00 - 24:00";
        }
        else
        {
            self.openTime=[NSString stringWithFormat:@"%@ - %@",self.startTime,self.endTime];
        }
        
        NSData *imgData=UIImageJPEGRepresentation(self.storeIcon, 0.5);
        
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在发布..." detail:nil];
        [hud show:YES];
        //添加店铺
        [HTTPManager addStoreWithName:self.storeName explain:self.storeDes address:self.storeMapAddress longitude:self.longitudeString latitude:self.latitudeString userName:self.storeContact mobile:self.storeMobile opentime:self.openTime userId:[UserInfoData getUserInfoFromArchive].userId areaId:[UserInfoData getUserInfoFromArchive].areaId moduleId:self.secondCategoryId headImg:imgData imgs:self.allImageArray merchantId:[UserInfoData getUserInfoFromArchive].merchantId complete:^(NSDictionary *resultDict) {
            
            [hud hide:YES];
            
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                NSString *storeId=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"storeId"]];
                
                StoreManageViewController *vc=[[StoreManageViewController alloc]init];
                vc.storeId=storeId;
                vc.createTime=createTime;
                vc.lanmu=self.lanmu;
                vc.erjilanmu=self.erjilanmu;
                vc.storeIcon=self.storeIcon;
                vc.storeName=self.storeName;
                vc.storeDes=self.storeDes;
                vc.storeImages=self.allImageArray;
                vc.storeAddress=self.storeMapAddress;
                vc.storeMobile=self.storeMobile;
                vc.storeContact=self.storeContact;
                vc.latitudeString=self.latitudeString;
                vc.longitudeString=self.longitudeString;
                vc.moduleId=self.secondCategoryId;
                
                if (self.isAllDay==YES)
                {
                    vc.openTime=@"00:00 - 24:00";
                }
                else
                {
                    vc.openTime=[NSString stringWithFormat:@"%@ - %@",self.startTime,self.endTime];
                }
                vc.isCreateStoreVC=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                NSString *error=[resultDict objectForKey:@"error"];
                [self.view makeToast:error duration:2.0];
            }
            
        }];
        [hud hide:YES afterDelay:20];
    }
    
    
//    StoreManageViewController *vc=[[StoreManageViewController alloc]init];
//    vc.isCreateStoreVC=YES;
//    [self.navigationController pushViewController:vc animated:YES];
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
//                deleteBtn.backgroundColor=COLOR_CYAN;
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

//取消选择地址
-(void)cancelBtnClick
{
    [self.smallBgView removeFromSuperview];
}


#pragma mark ===点击更换头像的方法===
-(void)changeStoreIcon
{
    NSLog(@"点击了修改头像按钮");
    
    //弹出actionsheet。选择获取头像的方式
    //从相册获取图片
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本地相册",nil];
    actionSheet.tag=1002;
    [actionSheet showInView:self.view];
}

#pragma mark ===UIActionSheet Delegate===
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            //相机
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = sourceType;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
            }
            else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
            
        }
            break;
            //本地相册
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

//当选择一张图片后进入这里
#pragma mark ===UIImagePickerController Delegate===
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage])
    {
        self.storeIcon = [info objectForKey:UIImagePickerControllerEditedImage];
//        NSData *headData = UIImageJPEGRepresentation(self.storeIcon, 0.5f);
        self.headIV.image=self.storeIcon;
        
        [self saveImage:self.storeIcon];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image
{
    //    NSLog(@"保存头像！");
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.png"];
    //    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success)
    {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //        UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(600, 600)];
    //    [UIImageJPEGRepresentation(smallImage, 0.5f) writeToFile:imageFilePath atomically:YES];//写入文件
    [UIImagePNGRepresentation(smallImage) writeToFile:imageFilePath atomically:YES];//写入文件
    //    UIImage *photo = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    
    //    _headImageView.image=photo;
    
    
    
    
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image)
    {
        newimage = nil;
    }
    else
    {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
