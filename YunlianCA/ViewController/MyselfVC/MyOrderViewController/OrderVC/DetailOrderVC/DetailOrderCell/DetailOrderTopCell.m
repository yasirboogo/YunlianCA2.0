//
//  DetailOrderTopCell.m
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "DetailOrderTopCell.h"

@implementation DetailOrderTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(110))];
    topView.backgroundColor=COLOR(254, 167, 173, 1);
    [self.contentView addSubview:topView];
    self.topView=topView;
    
    UILabel *statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), SCREEN_WIDTH-WZ(15*2), WZ(25))];
    statusLabel.font=FONT(17,15);
    statusLabel.textColor=COLOR_WHITE;
    [topView addSubview:statusLabel];
    self.statusLabel=statusLabel;
    
    UILabel *tradeNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), statusLabel.bottom+WZ(5), SCREEN_WIDTH-WZ(15*2), WZ(20))];
    tradeNumLabel.font=FONT(13,11);
    tradeNumLabel.textColor=COLOR_WHITE;
    [topView addSubview:tradeNumLabel];
    self.tradeNumLabel=tradeNumLabel;
    
    NSString *ddbhString=@"订单编号：";
    CGSize ddbhSize=[ViewController sizeWithString:ddbhString font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(20))];
    UILabel *ddbhLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), tradeNumLabel.bottom, ddbhSize.width, WZ(20))];
    ddbhLabel.text=ddbhString;
    ddbhLabel.font=FONT(13,11);
    ddbhLabel.textColor=COLOR_WHITE;
    [topView addSubview:ddbhLabel];
    
    UILabel *orderNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(ddbhLabel.right, ddbhLabel.top, SCREEN_WIDTH-WZ(15*2)-ddbhSize.width, WZ(20))];
    orderNumLabel.font=FONT(13,11);
    orderNumLabel.textColor=COLOR_WHITE;
    [topView addSubview:orderNumLabel];
    self.orderNumLabel=orderNumLabel;
    
    NSString *xdsjString=@"下单时间：";
    CGSize xdsjSize=[ViewController sizeWithString:xdsjString font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(20))];
    UILabel *xdsjLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), orderNumLabel.bottom, xdsjSize.width, WZ(20))];
    xdsjLabel.text=xdsjString;
    xdsjLabel.font=FONT(13,11);
    xdsjLabel.textColor=COLOR_WHITE;
    [topView addSubview:xdsjLabel];
    
    UILabel *orderTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(xdsjLabel.right, xdsjLabel.top, SCREEN_WIDTH-WZ(15*2)-xdsjSize.width, WZ(20))];
    orderTimeLabel.font=FONT(13,11);
    orderTimeLabel.textColor=COLOR_WHITE;
    [topView addSubview:orderTimeLabel];
    self.orderTimeLabel=orderTimeLabel;
    
//    NSString *zffsString=@"支付方式：";
//    CGSize zffsSize=[ViewController sizeWithString:zffsString font:FONT(13,11) maxSize:CGSizeMake(WZ(120), WZ(20))];
//    UILabel *zffsLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), xdsjLabel.bottom+WZ(5), zffsSize.width, WZ(20))];
//    zffsLabel.text=zffsString;
//    zffsLabel.font=FONT(13,11);
//    zffsLabel.textColor=COLOR_WHITE;
//    [topView addSubview:zffsLabel];
//    
//    UILabel *payTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(zffsLabel.right, zffsLabel.top, SCREEN_WIDTH-WZ(15*2)-zffsSize.width, WZ(20))];
//    payTypeLabel.font=FONT(13,11);
//    payTypeLabel.textColor=COLOR_WHITE;
//    [topView addSubview:payTypeLabel];
//    self.payTypeLabel=payTypeLabel;
    
    NSString *shrString=@"收货人：";
    CGSize shrSize=[ViewController sizeWithString:shrString font:FONT(17,15) maxSize:CGSizeMake(WZ(120), WZ(25))];
    UILabel *shrLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), topView.bottom+WZ(15), shrSize.width, WZ(25))];
    shrLabel.text=shrString;
    shrLabel.font=FONT(17,15);
    [self.contentView addSubview:shrLabel];
    
    UILabel *consigneeLabel=[[UILabel alloc]initWithFrame:CGRectMake(shrLabel.right, shrLabel.top, WZ(150), WZ(25))];
    consigneeLabel.font=FONT(17,15);
    [self.contentView addSubview:consigneeLabel];
    self.consigneeLabel=consigneeLabel;
    
    UILabel *mobileLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(150), shrLabel.top, WZ(150), WZ(25))];
    mobileLabel.font=FONT(17,15);
    mobileLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:mobileLabel];
    self.mobileLabel=mobileLabel;
    
    UIImageView *addressIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), shrLabel.bottom+WZ(20), WZ(20), WZ(20))];
    addressIV.image=IMAGE(@"dingwei");
    [self.contentView addSubview:addressIV];
    self.addressIV=addressIV;
    
    UILabel *addressLabel=[[UILabel alloc]init];//WithFrame:CGRectMake(addressIV.right+WZ(10), shrLabel.bottom+WZ(15), SCREEN_WIDTH-WZ(15*2+10+20), WZ(40))
    addressLabel.font=FONT(13,11);
    addressLabel.numberOfLines=0;
    [self.contentView addSubview:addressLabel];
    self.addressLabel=addressLabel;
    
    
    
}








@end
