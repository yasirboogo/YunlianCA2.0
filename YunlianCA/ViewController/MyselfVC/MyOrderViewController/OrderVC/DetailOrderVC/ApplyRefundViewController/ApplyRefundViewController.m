//
//  ApplyRefundViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/20.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ApplyRefundViewController.h"

@interface ApplyRefundViewController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate>
{
    UITableView *_tableView;
    
    
    
}

@property(nonatomic,strong)NSArray *goodsArray;
@property(nonatomic,strong)NSString *reason;
@property(nonatomic,strong)YYTextView *textView;


@end

@implementation ApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reason=@"";
    self.goodsArray=[self.orderDict objectForKey:@"orderItemSet"];
    
    [self createNavigationBar];
    [self createTableView];
    
    
    
    
    
    
    
}

-(void)createNavigationBar
{
    self.title=@"办理退货";
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
    _tableView.backgroundColor=COLOR_HEADVIEW;
    [self.view addSubview:_tableView];
    
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1)
    {
        return self.goodsArray.count;
    }
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
        lineView0.backgroundColor=COLOR(205, 0, 39, 1);
        [cellView addSubview:lineView0];
        
        UIView *circleView1=[[UIView alloc]initWithFrame:CGRectMake(lineView0.right+space, circleView0.top, circleWidth, circleWidth)];
        circleView1.backgroundColor=COLOR(205, 0, 39, 1);
        circleView1.clipsToBounds=YES;
        circleView1.layer.cornerRadius=circleWidth/2;
        [cellView addSubview:circleView1];
        
        CGSize ddtkSize=[ViewController sizeWithString:@"等待退款" font:FONT(13,11) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *ddtkLabel=[[UILabel alloc]init];
        ddtkLabel.center=CGPointMake(circleView1.center.x-ddtkSize.width/2.0, circleView1.center.y+circleView1.height/2.0+WZ(10));
        ddtkLabel.size=ddtkSize;
        ddtkLabel.text=@"等待退款";
        ddtkLabel.textColor=COLOR(205, 0, 39, 1);
        ddtkLabel.font=FONT(13,11);
        ddtkLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:ddtkLabel];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(circleView1.right+space, lineView0.top, lineWidth, lineHeight)];
        lineView1.backgroundColor=COLOR(205, 0, 39, 1);
        [cellView addSubview:lineView1];
        
        UIView *circleView2=[[UIView alloc]initWithFrame:CGRectMake(lineView1.right+space, circleView0.top, circleWidth, circleWidth)];
        circleView2.backgroundColor=COLOR(205, 0, 39, 1);
        circleView2.clipsToBounds=YES;
        circleView2.layer.cornerRadius=circleWidth/2;
        [cellView addSubview:circleView2];
        
        CGSize cgtkSize=[ViewController sizeWithString:@"成功退款" font:FONT(13,11) maxSize:CGSizeMake(WZ(100),WZ(25))];
        UILabel *cgtkLabel=[[UILabel alloc]init];
        cgtkLabel.center=CGPointMake(circleView2.center.x-cgtkSize.width/2.0, circleView2.center.y+circleView2.height/2.0+WZ(10));
        cgtkLabel.size=cgtkSize;
        cgtkLabel.text=@"成功退款";
        cgtkLabel.textColor=COLOR(205, 0, 39, 1);
        cgtkLabel.font=FONT(13,11);
        cgtkLabel.textAlignment=NSTextAlignmentCenter;
        [cellView addSubview:cgtkLabel];
        
        
        
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
        
        NSDictionary *goodsDict=self.goodsArray[indexPath.row];
        NSString *goodsName=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"itemName"]];
        NSString *goodsImg=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"itemImg"]];
        NSString *goodsCount=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"count"]];
        NSString *goodsAmount=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"amount"]];
        
        UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(80))];
        cellView.backgroundColor=COLOR(250, 250, 250, 1);
        [cell.contentView addSubview:cellView];
        
        UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(50), WZ(50))];
        iconIV.layer.cornerRadius=3;
        iconIV.clipsToBounds=YES;
        [iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsImg]] placeholderImage:IMAGE(@"morentouxiang")];
        [cellView addSubview:iconIV];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10)-WZ(50), WZ(25))];
        nameLabel.text=goodsName;
        nameLabel.font=FONT(17,15);
        [cell.contentView addSubview:nameLabel];
        
        UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(5), nameLabel.width, WZ(20))];
        priceLabel.text=[NSString stringWithFormat:@"¥ %@ x %@",goodsAmount,goodsCount];
        priceLabel.font=FONT(15,13);
        priceLabel.textColor=COLOR_LIGHTGRAY;
        [cell.contentView addSubview:priceLabel];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, cellView.bottom, SCREEN_WIDTH, 1)];
        lineView.backgroundColor=COLOR(235, 235, 235, 1);
        [cell.contentView addSubview:lineView];
        
        
        
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
        
        if (indexPath.row==0)
        {
            UILabel *thlyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(90), WZ(50))];
            thlyLabel.text=@"退货理由：";
            thlyLabel.font=FONT(17, 15);
            [cell.contentView addSubview:thlyLabel];
        }
        if (indexPath.row==1)
        {
            YYTextView *textView=[[YYTextView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(60))];
            textView.delegate=self;
            textView.placeholderText=@"请填写问题描述";
            textView.placeholderTextColor=COLOR_LIGHTGRAY;
            textView.placeholderFont=FONT(17,15);
            textView.font=FONT(17,15);
            [cell.contentView addSubview:textView];
            self.textView=textView;
        }
        
        
        
        
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
        
        UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(35), SCREEN_WIDTH-WZ(15*2), WZ(50))];
        submitBtn.backgroundColor=COLOR(254, 167, 173, 1);
        submitBtn.layer.cornerRadius=5.0;
        submitBtn.clipsToBounds=YES;
        [submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:submitBtn];
        
        cell.backgroundColor=COLOR_HEADVIEW;
        
        
        
        
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
    if (section==0 || section==3)
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
        return WZ(80);
    }
    if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            return WZ(50);
        }
        else
        {
            return WZ(90);
        }
    }
    else
    {
        return WZ(120);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0 || section==3)
    {
        return 0;
    }
    else
    {
        return WZ(15);
    }
}

- (void)textViewDidChange:(YYTextView *)textView;
{
    self.reason=textView.text;
}

#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
-(void)submitBtnClick
{
    [self.textView resignFirstResponder];
    
    NSString *orderId=[self.orderDict objectForKey:@"id"];
    if ([self.reason isEqualToString:@""])
    {
        [self.view makeToast:@"请填写退货理由" duration:1.0];
    }
    else
    {
        [HTTPManager refundWithOrderId:orderId refundDes:self.reason complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.navigationController popViewControllerAnimated:YES];
                [self.view.window makeToast:@"已提交退货请求" duration:1.0];
            }
            else
            {
                [self.view makeToast:@"请求退货失败，请重试。" duration:1.0];
            }
        }];
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
