//
//  RefundDetailViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/17.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RefundDetailViewController.h"

@interface RefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}

@property(nonatomic,strong)NSDictionary *payInfoDict;
@property(nonatomic,strong)NSString *goodsMoney;
@property(nonatomic,strong)NSString *money;

@end

@implementation RefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self createNavigationBar];
    [self createTableView];
    
    NSLog(@"退货字典===%@",self.orderDict);
    
    [HTTPManager getOrderMoneyWithPayInfoId:[self.orderDict objectForKey:@"id"] complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            self.payInfoDict=[resultDict objectForKey:@"payInfo"];
            self.goodsMoney=[self.payInfoDict objectForKey:@"goodsMoney"];
            self.money=[self.payInfoDict objectForKey:@"money"];
            [_tableView reloadData];
        }
        else
        {
            [self.view makeToast:@"获取信息失败" duration:1.0];
        }
    }];
    
}

-(void)createNavigationBar
{
    self.title=@"退货详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
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
    if (section==2)
    {
        return 2;
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
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(80))];
        cellView.backgroundColor=COLOR(254, 153, 160, 1);
        [cell.contentView addSubview:cellView];
        
        CGFloat circleWidth=WZ(16);
        CGFloat lineWidth=WZ(110);
        CGFloat lineHeight=WZ(2);
        CGFloat space=WZ(5);
        
        UIView *circleView0=[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-circleWidth*3-lineWidth*2-space*4)/2.0, WZ(25), circleWidth, circleWidth)];
        circleView0.backgroundColor=COLOR_WHITE;
        circleView0.clipsToBounds=YES;
        circleView0.layer.cornerRadius=circleWidth/2;
        [cellView addSubview:circleView0];
        
        CGSize sqtkSize=[ViewController sizeWithString:@"申请退款" font:FONT(13,11) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *sqtkLabel=[[UILabel alloc]init];
        sqtkLabel.center=CGPointMake(circleView0.center.x-sqtkSize.width/2.0, circleView0.center.y+circleView0.height/2.0+WZ(10));
        sqtkLabel.size=sqtkSize;
        sqtkLabel.text=@"申请退款";
        sqtkLabel.textColor=COLOR_WHITE;
        sqtkLabel.font=FONT(13,11);
        sqtkLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:sqtkLabel];
        
        UIView *lineView0=[[UIView alloc]initWithFrame:CGRectMake(circleView0.right+space, circleView0.top+WZ(7), lineWidth, lineHeight)];
        lineView0.backgroundColor=COLOR_WHITE;
        [cellView addSubview:lineView0];
        
        UIView *circleView1=[[UIView alloc]initWithFrame:CGRectMake(lineView0.right+space, circleView0.top, circleWidth, circleWidth)];
        circleView1.backgroundColor=COLOR_WHITE;
        circleView1.clipsToBounds=YES;
        circleView1.layer.cornerRadius=circleWidth/2;
        [cellView addSubview:circleView1];
        
        CGSize ddtkSize=[ViewController sizeWithString:@"等待退款" font:FONT(13,11) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *ddtkLabel=[[UILabel alloc]init];
        ddtkLabel.center=CGPointMake(circleView1.center.x-ddtkSize.width/2.0, circleView1.center.y+circleView1.height/2.0+WZ(10));
        ddtkLabel.size=ddtkSize;
        ddtkLabel.text=@"等待退款";
        ddtkLabel.textColor=COLOR_WHITE;
        ddtkLabel.font=FONT(13,11);
        ddtkLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:ddtkLabel];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(circleView1.right+space, lineView0.top, lineWidth, lineHeight)];
        [cellView addSubview:lineView1];
        
        UIView *circleView2=[[UIView alloc]initWithFrame:CGRectMake(lineView1.right+space, circleView0.top, circleWidth, circleWidth)];
        circleView2.clipsToBounds=YES;
        circleView2.layer.cornerRadius=circleWidth/2;
        [cellView addSubview:circleView2];
        
        CGSize cgtkSize=[ViewController sizeWithString:@"成功退款" font:FONT(13,11) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *cgtkLabel=[[UILabel alloc]init];
        cgtkLabel.center=CGPointMake(circleView2.center.x-cgtkSize.width/2.0, circleView2.center.y+circleView2.height/2.0+WZ(10));
        cgtkLabel.size=cgtkSize;
        cgtkLabel.text=@"成功退款";
        cgtkLabel.font=FONT(13,11);
        cgtkLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:cgtkLabel];
        
        NSInteger status=[[self.payInfoDict objectForKey:@"status"] integerValue];
        if (status==4)
        {
            lineView1.backgroundColor=COLOR(205, 0, 39, 1);
            circleView2.backgroundColor=COLOR(205, 0, 39, 1);
            cgtkLabel.textColor=COLOR(205, 0, 39, 1);
        }
        if (status==5)
        {
            lineView1.backgroundColor=COLOR_WHITE;
            circleView2.backgroundColor=COLOR_WHITE;
            cgtkLabel.textColor=COLOR_WHITE;
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
        
        NSInteger status=[[self.payInfoDict objectForKey:@"status"] integerValue];
        
        NSString *titleString;
        NSString *detailString;
        NSString *timeString;
        
        if (status==4)
        {
            titleString=@"申请已通过审核，请等待办理退款。";
            detailString=@"大约需要3-5个工作日完成办理，请耐心等待。";
            timeString=[self.orderDict objectForKey:@"thTime"];
        }
        if (status==5)
        {
            titleString=@"申请已通过审核，成功办理退款。";
            detailString=@"退款完成，请注意查看账户余额。";
            timeString=[self.orderDict objectForKey:@"thTime"];
        }
        
        
        CGSize titleSize=[ViewController sizeWithString:titleString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(100))];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), titleSize.height)];
        titleLabel.text=titleString;
        
        titleLabel.font=FONT(15, 13);
        [cell.contentView addSubview:titleLabel];
        
        
        CGSize detailSize=[ViewController sizeWithString:detailString font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(100))];
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+WZ(8), SCREEN_WIDTH-WZ(15*2), detailSize.height)];
        detailLabel.text=detailString;
        detailLabel.textColor=COLOR_LIGHTGRAY;
        detailLabel.font=FONT(13, 11);
        [cell.contentView addSubview:detailLabel];
        
        
        CGSize timeSize=[ViewController sizeWithString:timeString font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(100))];
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, detailLabel.bottom+WZ(8), SCREEN_WIDTH-WZ(15*2), timeSize.height)];
        timeLabel.text=timeString;
        timeLabel.textColor=COLOR_LIGHTGRAY;
        timeLabel.font=FONT(13, 11);
        [cell.contentView addSubview:timeLabel];
        
        
        
        cell.contentView.backgroundColor=COLOR(250, 250, 250, 1);
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
        
        if (indexPath.row==0)
        {
            NSString *titleString=@"应退款项";
            CGSize textLabelSize=[ViewController sizeWithString:titleString font:FONT(17,15) maxSize:CGSizeMake(WZ(220),WZ(50))];
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, textLabelSize.width, WZ(50))];
            titleLabel.text=titleString;
            titleLabel.font=FONT(17, 15);
            [cell.contentView addSubview:titleLabel];
            
            NSString *totalMoney=[NSString stringWithFormat:@"总金额：￥%@",self.money];
            CGSize totalMoneySize=[ViewController sizeWithString:totalMoney font:FONT(17, 15) maxSize:CGSizeMake(WZ(220),WZ(50))];
            UILabel *totalMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-totalMoneySize.width, 0, totalMoneySize.width, WZ(50))];
            totalMoneyLabel.text=totalMoney;
            totalMoneyLabel.textColor=COLOR_ORANGE;
            totalMoneyLabel.textAlignment=NSTextAlignmentRight;
            totalMoneyLabel.font=FONT(17, 15);
//            totalMoneyLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:totalMoneyLabel];
            
        }
        if (indexPath.row==1)
        {
            NSString *titleString=@"商品金额";
            CGSize textLabelSize=[ViewController sizeWithString:titleString font:FONT(17,15) maxSize:CGSizeMake(WZ(220),WZ(50))];
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, textLabelSize.width, WZ(50))];
            titleLabel.text=titleString;
            titleLabel.font=FONT(17, 15);
            [cell.contentView addSubview:titleLabel];
            
            NSString *goodsMoney=[NSString stringWithFormat:@"￥%@",self.goodsMoney];
            CGSize goodsMoneySize=[ViewController sizeWithString:goodsMoney font:FONT(17, 15) maxSize:CGSizeMake(WZ(220),WZ(50))];
            UILabel *goodsMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-goodsMoneySize.width, 0, goodsMoneySize.width, WZ(50))];
            goodsMoneyLabel.text=goodsMoney;
            goodsMoneyLabel.textColor=COLOR_LIGHTGRAY;
            goodsMoneyLabel.textAlignment=NSTextAlignmentRight;
            goodsMoneyLabel.font=FONT(17, 15);
//            goodsMoneyLabel.backgroundColor=COLOR_CYAN;
            [cell.contentView addSubview:goodsMoneyLabel];
            
        }
        
        
        
        
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
        return WZ(80);
    }
    if (indexPath.section==1)
    {
        NSInteger status=[[self.payInfoDict objectForKey:@"status"] integerValue];
        
        NSString *titleString;
        NSString *detailString;
        NSString *timeString;
        if (status==4)
        {
            titleString=@"申请已通过审核，请等待办理退款。";
            detailString=@"大约需要3-5个工作日完成办理，请耐心等待。";
            timeString=[self.orderDict objectForKey:@"thTime"];
        }
        if (status==5)
        {
            titleString=@"申请已通过审核，成功办理退款。";
            detailString=@"退款完成，请注意查看账户余额。";
            timeString=[self.orderDict objectForKey:@"thTime"];
        }
        
        CGSize titleSize=[ViewController sizeWithString:titleString font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(100))];
        CGSize detailSize=[ViewController sizeWithString:detailString font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(100))];
        CGSize timeSize=[ViewController sizeWithString:timeString font:FONT(13,11) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2),WZ(100))];
        
        return WZ(15*2)+WZ(5*2)+titleSize.height+detailSize.height+timeSize.height;
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
    else
    {
        return WZ(15);
    }
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
