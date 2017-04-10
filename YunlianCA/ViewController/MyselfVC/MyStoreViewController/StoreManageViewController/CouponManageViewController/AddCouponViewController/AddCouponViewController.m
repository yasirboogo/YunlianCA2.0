//
//  AddCouponViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "AddCouponViewController.h"

@interface AddCouponViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    
}


@property(nonatomic,strong)UITextField *minAmountTF;
@property(nonatomic,strong)UITextField *amountTF;
@property(nonatomic,strong)UILabel *startTimeLabel;
@property(nonatomic,strong)UILabel *endTimeLabel;
@property(nonatomic,strong)UILabel *rushTimeLabel;
@property(nonatomic,strong)UITextField *countTF;
@property(nonatomic,strong)NSString *minAmount;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *rushTime;
@property(nonatomic,strong)NSString *count;
@property(nonatomic,strong)UIImageView *indateIV;
@property(nonatomic,strong)UIImageView *rushIV;
@property(nonatomic,assign)BOOL isIndate;
@property(nonatomic,assign)BOOL isRush;
@property(nonatomic,assign)NSInteger dateSelectedRow;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *smallView;


@end

@implementation AddCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.amount=@"";
    self.minAmount=@"";
    self.count=@"";
    
    self.isIndate=YES;
    self.isRush=YES;
    
    [self createNavigationBar];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

-(void)createNavigationBar
{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(60), WZ(10), SCREEN_WIDTH-WZ(60*2), WZ(30))];
    titleLabel.font=FONT(19,17);
    titleLabel.text=@"添加优惠券";
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    if (section==1)
    {
        return 5;
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
        
        NSArray *moneyArray=[[NSArray alloc]initWithObjects:@"优惠券金额",@"最低限额",nil];
        cell.textLabel.text=moneyArray[indexPath.row];
        cell.textLabel.textColor=COLOR_LIGHTGRAY;
        cell.textLabel.font=FONT(17, 15);
        
        if (indexPath.row==0)
        {
            UITextField *amountTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(110), 0, WZ(250), WZ(50))];
            amountTF.inputAccessoryView = [self creatDoneView];
            amountTF.keyboardType = UIKeyboardTypeDecimalPad;
            //        amountTF.backgroundColor=COLOR_CYAN;
            amountTF.font=FONT(17, 15);
            amountTF.text=self.amount;
            amountTF.delegate=self;
            [cell.contentView addSubview:amountTF];
            self.amountTF=amountTF;
        }
        if (indexPath.row==1)
        {
            UITextField *minAmountTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(110), 0, WZ(250), WZ(50))];
            minAmountTF.inputAccessoryView = [self creatDoneView];
            minAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
            //        minAmountTF.backgroundColor=COLOR_CYAN;
            minAmountTF.placeholder=@"超过此限额可用";
            minAmountTF.font=FONT(17, 15);
            minAmountTF.text=self.minAmount;
            minAmountTF.delegate=self;
            [cell.contentView addSubview:minAmountTF];
            self.minAmountTF=minAmountTF;
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
        
        NSArray *timeArray=[[NSArray alloc]initWithObjects:@"不限时间",@"开始时间",@"结束时间",@"抢购",
                            @"开抢时间" ,nil];
        cell.textLabel.text=timeArray[indexPath.row];
        
        if (indexPath.row==0)
        {
            UIImageView *indateIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(15), WZ(17.5), WZ(15), WZ(15))];
            indateIV.image=IMAGE(@"xuanzhong");
            [cell.contentView addSubview:indateIV];
            self.indateIV=indateIV;
            indateIV.hidden=!self.isIndate;
        }
        if (indexPath.row==1)
        {
            UILabel *startTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(240), 0, WZ(240), WZ(50))];
            startTimeLabel.font=FONT(17, 15);
            startTimeLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:startTimeLabel];
            self.startTimeLabel=startTimeLabel;
            
            if (self.isIndate==YES)
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
                [formatter setDateFormat:@"YYYY-MM-dd"];
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
            UILabel *endTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(240), 0, WZ(240), WZ(50))];
            endTimeLabel.font=FONT(17, 15);
            endTimeLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:endTimeLabel];
            self.endTimeLabel=endTimeLabel;
            
            if (self.isIndate==YES)
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
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
                NSString *endDate=[formatter stringFromDate:[NSDate dateWithTimeInterval:86400 sinceDate:currentTime]];
                endTimeLabel.text=endDate;
            }
            else
            {
                endTimeLabel.text=self.endTime;
            }
            
            cell.userInteractionEnabled=NO;
        }
        if (indexPath.row==3)
        {
            UIImageView *rushIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(15), WZ(17.5), WZ(15), WZ(15))];
            rushIV.image=IMAGE(@"xuanzhong");
            [cell.contentView addSubview:rushIV];
            self.rushIV=rushIV;
            rushIV.hidden=!self.isRush;
        }
        if (indexPath.row==4)
        {
            UILabel *rushTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(240), 0, WZ(240), WZ(50))];
            rushTimeLabel.font=FONT(17, 15);
            rushTimeLabel.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:rushTimeLabel];
            self.rushTimeLabel=rushTimeLabel;
            
            if (self.isRush==YES)
            {
                rushTimeLabel.textColor=COLOR_LIGHTGRAY;
            }
            else
            {
                rushTimeLabel.textColor=COLOR_RED;
            }
            
            if (self.rushTime==nil || [self.rushTime isEqualToString:@""])
            {
                NSDate *currentTime=[NSDate date];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
                NSString *endDate=[formatter stringFromDate:currentTime];
                rushTimeLabel.text=endDate;
            }
            else
            {
                rushTimeLabel.text=self.rushTime;
            }
            
            cell.userInteractionEnabled=NO;
        }
        
        
        cell.textLabel.font=FONT(17, 15);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
        
        cell.textLabel.text=@"数量";
        cell.textLabel.font=FONT(17, 15);
        
        UITextField *countTF=[[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(240), 0, WZ(240), WZ(50))];
        countTF.inputAccessoryView = [self creatDoneView];
        countTF.font=FONT(17, 15);
        countTF.text=self.count;
        countTF.delegate=self;
        countTF.textAlignment=NSTextAlignmentRight;
        countTF.textColor=COLOR_RED;
        //            countTF.backgroundColor=COLOR_CYAN;
        [cell.contentView addSubview:countTF];
        self.countTF=countTF;
        
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        self.dateSelectedRow=indexPath.row;
        
        if (indexPath.row==0)
        {
            //不限时间
            if (self.isIndate==YES)
            {
                self.indateIV.hidden=YES;
                self.startTimeLabel.textColor=COLOR_RED;
                self.endTimeLabel.textColor=COLOR_RED;
                
                NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:1 inSection:1];
                UITableViewCell *cell1=[tableView cellForRowAtIndexPath:indexPath1];
                cell1.userInteractionEnabled=YES;
                
                NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:1];
                UITableViewCell *cell2=[tableView cellForRowAtIndexPath:indexPath2];
                cell2.userInteractionEnabled=YES;
            }
            else
            {
                self.indateIV.hidden=NO;
                self.startTimeLabel.textColor=COLOR_LIGHTGRAY;
                self.endTimeLabel.textColor=COLOR_LIGHTGRAY;
                
                NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:1 inSection:1];
                UITableViewCell *cell1=[tableView cellForRowAtIndexPath:indexPath1];
                cell1.userInteractionEnabled=NO;
                
                NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:1];
                UITableViewCell *cell2=[tableView cellForRowAtIndexPath:indexPath2];
                cell2.userInteractionEnabled=NO;
                
                //不限时间就传空字符串
                self.startTime=@"";
                self.endTime=@"";
                
                NSLog(@"不限时间默认开始时间和结束时间为空===%@===%@",self.startTime,self.endTime);
            }
            self.isIndate=!self.isIndate;
            
        }
        if (indexPath.row==1)
        {
            //有效期开始时间
            CGFloat viewWidth=SCREEN_WIDTH-WZ(30*2);
            CGFloat viewHeight=SCREEN_WIDTH-WZ(30*2);
            
            [self createBackgroundViewWithSmallViewFrame:CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight) titleString:@"有效期开始时间" datePickerMode:1];
        }
        if (indexPath.row==2)
        {
            //有效期结束时间
            CGFloat viewWidth=SCREEN_WIDTH-WZ(30*2);
            CGFloat viewHeight=SCREEN_WIDTH-WZ(30*2);
            
            [self createBackgroundViewWithSmallViewFrame:CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight) titleString:@"有效期结束时间" datePickerMode:1];
        }
        if (indexPath.row==3)
        {
            //不设置开抢时间
            if (self.isRush==YES)
            {
                self.rushIV.hidden=YES;
                self.rushTimeLabel.textColor=COLOR_RED;
                
                NSIndexPath *indexPath4=[NSIndexPath indexPathForRow:4 inSection:1];
                UITableViewCell *cell4=[tableView cellForRowAtIndexPath:indexPath4];
                cell4.userInteractionEnabled=YES;
            }
            else
            {
                self.rushIV.hidden=NO;
                self.rushTimeLabel.textColor=COLOR_LIGHTGRAY;
                
                NSIndexPath *indexPath4=[NSIndexPath indexPathForRow:4 inSection:1];
                UITableViewCell *cell4=[tableView cellForRowAtIndexPath:indexPath4];
                cell4.userInteractionEnabled=NO;
                
                //不设置开抢时间就传当前时间
                NSDate *currentTime=[NSDate date];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
                self.rushTime = [formatter stringFromDate:currentTime];
                
                NSLog(@"不设置开抢时间默认当前时间===%@",self.rushTime);
            }
            self.isRush=!self.isRush;
            
        }
        if (indexPath.row==4)
        {
            //优惠券开抢时间
            CGFloat viewWidth=SCREEN_WIDTH-WZ(30*2);
            CGFloat viewHeight=SCREEN_WIDTH-WZ(30*2);
            
            [self createBackgroundViewWithSmallViewFrame:CGRectMake(WZ(30), WZ(180), viewWidth, viewHeight) titleString:@"优惠券开抢时间" datePickerMode:1];
        }
        
    }
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return nil;
    }
    else
    {
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(60))];
        titleView.backgroundColor=COLOR_HEADVIEW;
        
        UIView *aView=[[UIView alloc]initWithFrame:CGRectMake(0, WZ(10), SCREEN_WIDTH, WZ(50))];
        aView.backgroundColor=COLOR_WHITE;
        [titleView addSubview:aView];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, SCREEN_WIDTH-WZ(15*2), aView.height)];
        
        titleLabel.textColor=COLOR_LIGHTGRAY;
        titleLabel.font=FONT(15,13);
        [aView addSubview:titleLabel];
        
        if (section==1)
        {
            titleLabel.text=@"优惠券有效期";
        }
        if (section==2)
        {
            titleLabel.text=@"发放数量";
        }
        
        return titleView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    else
    {
        return WZ(60);
    }
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 70  - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.5f];
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//    self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//}
//
////当用户按下return键或者按回车键，keyboard消失
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.amountTF)
    {
        self.amount=textField.text;
    }
    if (textField==self.minAmountTF)
    {
        self.minAmount=textField.text;
    }
    if (textField==self.countTF)
    {
        self.count=textField.text;
    }
    
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
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
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(WZ(20), WZ(40)+WZ(10), self.smallView.width-WZ(20*2), WZ(200))];
//    datePicker.frame=CGRectMake(-WZ(20), WZ(40)+WZ(10), self.smallView.width+WZ(20), WZ(200));
    //    datePicker.backgroundColor=COLOR_CYAN;
    NSDate *currentTime=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [datePicker setDate:currentTime animated:YES];
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    [datePicker setDatePickerMode:datePickerMode];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.smallView addSubview:datePicker];
    
    if ([titleString isEqualToString:@"有效期开始时间"])
    {
        [datePicker setMinimumDate:currentTime];
    }
    if ([titleString isEqualToString:@"有效期结束时间"])
    {
        [datePicker setMinimumDate:[NSDate dateWithTimeInterval:86400 sinceDate:currentTime]];
    }
    
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
        [formatter1 setDateFormat:@"YYYY-MM-dd"];
        self.startTime = [formatter1 stringFromDate:datePicker.date];
        
        NSLog(@"选择的有效期开始时间: %@", self.startTime);
    }
    if (self.dateSelectedRow==2)
    {
        NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
        [formatter2 setDateFormat:@"YYYY-MM-dd"];
        self.endTime = [formatter2 stringFromDate:datePicker.date];
        
        NSLog(@"选择的有效期结束时间: %@", self.endTime);
    }
    if (self.dateSelectedRow==4)
    {
        NSDateFormatter *formatter4=[[NSDateFormatter alloc]init];
        [formatter4 setDateFormat:@"YYYY-MM-dd"];
        self.rushTime = [formatter4 stringFromDate:datePicker.date];
        
        NSLog(@"选择的优惠券开抢时间: %@", self.rushTime);
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
        if (self.dateSelectedRow==4)
        {
            self.rushTimeLabel.text=self.rushTime;
        }
    }
    
    
    
}



#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//保存优惠券
-(void)rightBtnClick
{
    NSLog(@"保存优惠券");
    
    [self.amountTF resignFirstResponder];
    [self.minAmountTF resignFirstResponder];
    [self.countTF resignFirstResponder];
    
    self.storeId=[NSString stringWithFormat:@"%@",self.storeId];
    
    if ([self.amountTF.text isEqualToString:@""] || [self.minAmountTF.text isEqualToString:@""] || [self.storeId isEqualToString:@""] || [self.endTimeLabel.text isEqualToString:@""] || [self.startTimeLabel.text isEqualToString:@""] || [self.countTF.text isEqualToString:@""] || [self.rushTimeLabel.text isEqualToString:@""])
    {
        [self.view makeToast:@"请填写完整优惠券信息" duration:1.0];
    }
    else
    {
        if ([self.minAmountTF.text floatValue]<[self.amountTF.text floatValue])
        {
            [self.view makeToast:@"优惠券金额不能超过最低限额" duration:1.0];
        }
        else
        {
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"正在添加..." detail:nil];
            [hud show:YES];
            [HTTPManager storeAddCouponWithMoney:self.amountTF.text minMoney:self.minAmountTF.text type:@"1" storeId:self.storeId yxETimeStr:self.endTimeLabel.text yxSTimeStr:self.startTimeLabel.text amount:self.countTF.text kqSTimeStr:self.rushTimeLabel.text complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.view.window makeToast:@"添加优惠券成功" duration:1.0];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [self.view.window makeToast:[resultDict objectForKey:@"error"] duration:1.0];
                }
                
                [hud hide:YES];
            }];
            [hud hide:YES afterDelay:20];
        }
    }
    
    
    
    
    
}


-(void)keyboardShow:(NSNotification *)note
{
    if ([self.countTF isFirstResponder]) {
        CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat deltaY=keyBoardRect.size.height;
        CGRect textRect = [self.countTF convertRect:self.countTF.bounds toView:self.bgView];
        
        NSLog(@"键盘高度===%f===%f",deltaY,CGRectGetMaxY(textRect));
        
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{

            _tableView.frame =CGRectMake(0, -134, SCREEN_WIDTH,CGRectGetHeight(_tableView.frame));
        }];
    }
   
}

-(void)keyboardHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _tableView.frame=CGRectMake(0,0, SCREEN_WIDTH, CGRectGetHeight(_tableView.frame));
    } completion:nil];
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
