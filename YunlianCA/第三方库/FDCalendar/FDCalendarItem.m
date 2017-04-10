//
//  FDCalendarItem.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDCalendarItem.h"

//@interface FDCalendarCell : UICollectionViewCell
//
//- (UILabel *)dayLabel;
//- (UILabel *)chineseDayLabel;
//- (UIImageView *)yqdIV;
//
//@end
//
//@implementation FDCalendarCell {
//    UILabel *_dayLabel;
//    UILabel *_chineseDayLabel;
//    UIImageView *_yqdIV;
//}
//
//- (UILabel *)dayLabel {
//    if (!_dayLabel) {
//        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//        _dayLabel.textAlignment = NSTextAlignmentCenter;
//        _dayLabel.font = [UIFont systemFontOfSize:15];
//        _dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 3);
//        [self.contentView addSubview:_dayLabel];
//    }
//    return _dayLabel;
//}
//
//- (UILabel *)chineseDayLabel {
//    if (!_chineseDayLabel) {
//        _chineseDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
//        _chineseDayLabel.textAlignment = NSTextAlignmentCenter;
//        _chineseDayLabel.font = [UIFont boldSystemFontOfSize:9];
//        
//        CGPoint point = _dayLabel.center;
//        point.y += 15;
//        _chineseDayLabel.center = point;
//        [self.contentView addSubview:_chineseDayLabel];
//    }
//    return _chineseDayLabel;
//}
//
//-(UIImageView*)yqdIV
//{
//    if (!_yqdIV)
//    {
//        CGFloat itemTopMargin=15;
//        CGFloat itemWidth = (DeviceWidth - 5 * 2) / 7-5*2;
//        CGFloat itemHeight = itemWidth-5*2;
//        _yqdIV=[[UIImageView alloc]initWithFrame:CGRectMake(5, itemTopMargin, itemWidth, itemHeight)];
//        _yqdIV.image=IMAGE(@"wode_yiqiandao");
//        _yqdIV.backgroundColor=COLOR_CLEAR;
//        [self.contentView addSubview:_yqdIV];
//        _yqdIV.hidden=YES;
//    }
//    
//    return _yqdIV;
//}
//
//@end

#define CollectionViewHorizonMargin 5
#define CollectionViewVerticalMargin 5

#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]
//#define Days @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31"]


typedef NS_ENUM(NSUInteger, FDCalendarMonth) {
    FDCalendarMonthPrevious = 0,
    FDCalendarMonthCurrent = 1,
    FDCalendarMonthNext = 2,
};

#import "KVNProgress.h"

@interface FDCalendarItem () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSTimer *_signInTimer;
    
}

@property (strong, nonatomic) UICollectionView *collectionView;

@property(nonatomic,strong)UIImageView *todaySignInIV;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSMutableArray *dayArray;

@end

@implementation FDCalendarItem

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        //获取沙盒里保存的签到记录
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"signIn.plist"];
        NSArray *dateArray=[NSArray arrayWithContentsOfFile:filePath];
        
        self.dayArray=[NSMutableArray array];
        for (NSInteger i=0; i<dateArray.count; i++)
        {
            NSString *dateString=dateArray[i];
            NSArray *smallArray=[dateString componentsSeparatedByString:@"-"];
            if (smallArray.count==3)
            {
                NSString *dayString=[smallArray lastObject];
                [self.dayArray addObject:dayString];
            }
        }
        
//        NSLog(@"签到天===%@",self.dayArray);
        
        [self setupCollectionView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, self.collectionView.frame.size.height + CollectionViewVerticalMargin * 2)];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setDate:(NSDate *)date {
    _date = date;
    [self.collectionView reloadData];
}

#pragma mark - Public 

// 获取date的下个月日期
- (NSDate *)nextMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return nextMonthDate;
}

// 获取date的上个月日期
- (NSDate *)previousMonthDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *previousMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self.date options:NSCalendarMatchStrictly];
    return previousMonthDate;
}

#pragma mark - Private

// collectionView显示日期单元，设置其属性
- (void)setupCollectionView {
    CGFloat itemWidth = (DeviceWidth - CollectionViewHorizonMargin * 2) / 7;
    CGFloat itemHeight = itemWidth;
    
    UICollectionViewFlowLayout *flowLayot = [[UICollectionViewFlowLayout alloc] init];
    flowLayot.sectionInset = UIEdgeInsetsZero;
    flowLayot.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayot.minimumLineSpacing = 0;
    flowLayot.minimumInteritemSpacing = 0;
    
    CGRect collectionViewFrame = CGRectMake(CollectionViewHorizonMargin, CollectionViewVerticalMargin, DeviceWidth - CollectionViewHorizonMargin * 2, itemHeight * 6);
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayot];
    [self addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
//    NSLog(@"高度===%f",self.collectionView.frame.size.height);
}

// 获取date当前月的第一天是星期几
- (NSInteger)weekdayOfFirstDayInDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    [components setDay:1];
    NSDate *firstDate = [calendar dateFromComponents:components];
    NSDateComponents *firstComponents = [calendar components:NSCalendarUnitWeekday fromDate:firstDate];
    return firstComponents.weekday - 1;
}

// 获取date当前月的总天数
- (NSInteger)totalDaysInMonthOfDate:(NSDate *)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

// 获取某月day的日期
- (NSDate *)dateOfMonth:(FDCalendarMonth)calendarMonth WithDay:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date;
    
    switch (calendarMonth) {
        case FDCalendarMonthPrevious:
            date = [self previousMonthDate];
            break;
            
        case FDCalendarMonthCurrent:
            date = self.date;
            break;
            
        case FDCalendarMonthNext:
            date = [self nextMonthDate];
            break;
        default:
            break;
    }
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [components setDay:day];
    NSDate *dateOfDay = [calendar dateFromComponents:components];
    return dateOfDay;
}

// 获取date当天的农历
- (NSString *)chineseCalendarOfDate:(NSDate *)date {
    NSString *day;
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    if (components.day == 1) {
        day = ChineseMonths[components.month - 1];
    } else {
        day = ChineseDays[components.day - 1];
    }

    return day;
}

#pragma mark - UICollectionDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.tag=indexPath.row;
    
    CGFloat itemWidth = (DeviceWidth - CollectionViewHorizonMargin * 2) / 7;
    CGFloat itemHeight = itemWidth;
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, itemWidth, itemHeight/2-5)];
    dayLabel.textColor = [UIColor blackColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.font = [UIFont systemFontOfSize:15];
//    dayLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - 3);
    [cell.contentView addSubview:dayLabel];
//    dayLabel.backgroundColor=COLOR_CYAN;
    
    UILabel *chineseDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dayLabel.bottom, itemWidth, itemHeight/2-5)];
    chineseDayLabel.textColor = [UIColor grayColor];
    chineseDayLabel.textAlignment = NSTextAlignmentCenter;
    chineseDayLabel.font = [UIFont boldSystemFontOfSize:9];
//    CGPoint point = dayLabel.center;
//    point.y += 15;
//    chineseDayLabel.center = point;
    [cell.contentView addSubview:chineseDayLabel];
    
    UIImageView *yqdIV=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, itemWidth-5*2, itemHeight-10*2)];
    yqdIV.image=IMAGE(@"wode_yiqiandao");
    yqdIV.backgroundColor=COLOR_CLEAR;
    [cell.contentView addSubview:yqdIV];
    yqdIV.hidden=YES;
    
    
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    NSInteger totalDaysOfMonth = [self totalDaysInMonthOfDate:self.date];
    NSInteger totalDaysOfLastMonth = [self totalDaysInMonthOfDate:[self previousMonthDate]];
    
    cell.userInteractionEnabled=YES;
    
    if (indexPath.row < firstWeekday)
    {    // 小于这个月的第一天
        NSInteger day = totalDaysOfLastMonth - firstWeekday + indexPath.row + 1;
        dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        dayLabel.textColor = [UIColor grayColor];
        chineseDayLabel.text = [self chineseCalendarOfDate:[self dateOfMonth:FDCalendarMonthPrevious WithDay:day]];
        cell.userInteractionEnabled=NO;
        
//        cell.yqdIV.hidden=NO;
    }
    else if (indexPath.row >= totalDaysOfMonth + firstWeekday)
    {    // 大于这个月的最后一天
        NSInteger day = indexPath.row - totalDaysOfMonth - firstWeekday + 1;
        dayLabel.text = [NSString stringWithFormat:@"%ld", day];
        dayLabel.textColor = [UIColor grayColor];
        chineseDayLabel.text = [self chineseCalendarOfDate:[self dateOfMonth:FDCalendarMonthNext WithDay:day]];
        cell.userInteractionEnabled=NO;
    }
    else
    {    // 属于这个月
        NSInteger day = indexPath.row - firstWeekday + 1;
        dayLabel.text= [NSString stringWithFormat:@"%ld", day];
        dayLabel.textColor = COLOR_BLACK;
        
        NSString *dayString;
        if (day<=9)
        {
            dayString=[NSString stringWithFormat:@"0%ld",(long)day];
        }
        else
        {
            dayString=[NSString stringWithFormat:@"%ld",(long)day];
        }
        
        if ([self.dayArray containsObject:dayString])
        {
            CGFloat itemWidth = (DeviceWidth - CollectionViewHorizonMargin * 2) / 7;
            CGFloat itemHeight = itemWidth;
            UIImageView *todaySignInIV=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, itemWidth-5*2, itemHeight-10*2)];
            todaySignInIV.image=IMAGE(@"wode_yiqiandao");
            [cell.contentView addSubview:todaySignInIV];
        }
        
        // 将当前日期的那天高亮显示
        if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]])
        {
            dayLabel.textColor = [UIColor redColor];
        }
        else
        {
//            yqdIV.hidden=NO;
        }
        
        chineseDayLabel.text = [self chineseCalendarOfDate:[self dateOfMonth:FDCalendarMonthCurrent WithDay:day]];
    }
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.date];
    
    NSInteger firstWeekday = [self weekdayOfFirstDayInDate];
    [components setDay:indexPath.row - firstWeekday + 1];
    
    
//    NSInteger day = indexPath.row - firstWeekday + 1;
//    
//    if (day == [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:[NSDate date]])
//    {
//        UICollectionViewCell *cell=[collectionView cellForItemAtIndexPath:indexPath];
////        cell.yqdIV.hidden=NO;
//        NSLog(@"今天的日期======%ld\n今天的tag==%ld",day,(long)cell.tag);
//        
//        if (!self.todaySignInIV)
//        {
//            //发送签到请求
//            
//            CGFloat itemWidth = (DeviceWidth - CollectionViewHorizonMargin * 2) / 7;
//            CGFloat itemHeight = itemWidth;
//            
//            UIImageView *todaySignInIV=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, itemWidth-5*2, itemHeight-10*2)];
//            todaySignInIV.image=IMAGE(@"wode_yiqiandao");
//            [cell.contentView addSubview:todaySignInIV];
//            self.todaySignInIV=todaySignInIV;
//            //        todaySignInIV.backgroundColor=COLOR_CYAN;
//            
//            [self signInView];
//            
//            _signInTimer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(signInTimer) userInfo:nil repeats:NO];
//            
//            
//        }
//        else
//        {
//            [self.window makeToast:@"今天已签到~O(∩_∩)O~" duration:1.0];
//        }
//        
//        
//        
//    }
//    else
//    {
////        [self.window makeToast:@"请选择今天签到" duration:2.0];
//    }
    
}

//创建签到弹出view
-(void)signInView
{
    UIView *parentView = [[UIView alloc]init];
    UIWindow *window=[UIApplication sharedApplication].windows[0];
    if (window.subviews.count > 0)
    {
        parentView = [window.subviews objectAtIndex:0];
    }
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=[COLOR_BLACK colorWithAlphaComponent:0.5];
    [parentView addSubview:bgView];
    self.bgView=bgView;
    
    UIView *signInView=[[UIView alloc]initWithFrame:CGRectMake(WZ(40), WZ(200), WZ(295), WZ(190))];
    signInView.backgroundColor=COLOR_WHITE;
    signInView.layer.cornerRadius=10;
    signInView.clipsToBounds=YES;
    [bgView addSubview:signInView];
    
//    [KVNProgress showSuccessWithStatus:@"Success"];
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(125), WZ(25), WZ(45), WZ(45))];
    iconIV.image=IMAGE(@"wode_bangdingchenggong");
    [signInView addSubview:iconIV];
    
    UIButton *closeBtn=[[UIButton alloc]initWithFrame:CGRectMake(signInView.width-WZ(15+20), WZ(15), WZ(20), WZ(20))];
    [closeBtn setBackgroundImage:IMAGE(@"close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [signInView addSubview:closeBtn];
    
    UILabel *successLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), iconIV.bottom+WZ(15), signInView.width-WZ(15*2), WZ(25))];
    successLabel.text=@"签到成功";
    successLabel.font=FONT(15,13);
    successLabel.textAlignment=NSTextAlignmentCenter;
    [signInView addSubview:successLabel];
    
    UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(successLabel.left, successLabel.bottom+WZ(20), successLabel.width, successLabel.height)];
    subLabel.text=@"恭喜您获得20个积分！";
    subLabel.font=FONT(15,13);
    subLabel.textAlignment=NSTextAlignmentCenter;
    [signInView addSubview:subLabel];
    
    
    
    
    
    
    
}

//关闭按钮
-(void)closeBtnClick
{
    self.bgView.hidden=YES;
    
    
    
}

-(void)signInTimer
{
    self.bgView.hidden=YES;
}












@end
