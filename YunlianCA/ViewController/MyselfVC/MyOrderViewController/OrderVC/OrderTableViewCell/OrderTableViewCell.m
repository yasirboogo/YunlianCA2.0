//
//  OrderTableViewCell.m
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

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
    UILabel *ddhLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(250), WZ(30))];
    ddhLabel.font=FONT(15,13);
    [self.contentView addSubview:ddhLabel];
    self.ddhLabel=ddhLabel;
    
    UILabel *ztLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(50), 0, WZ(50), WZ(30))];
    ztLabel.font=FONT(11,9);
    ztLabel.textColor=COLOR(146, 135, 187, 1);
    ztLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:ztLabel];
    self.ztLabel=ztLabel;
    
    UILabel *lsLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20))];//CGRectMake(WZ(15), WZ(30), WZ(250), WZ(20))
    lsLabel.font=FONT(15, 13);
    [self.contentView addSubview:lsLabel];
    self.lsLabel=lsLabel;
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, ddhLabel.bottom+lsLabel.height+WZ(5), SCREEN_WIDTH, WZ(80))];
    bgView.backgroundColor=COLOR(250, 250, 250, 1);
    [self.contentView addSubview:bgView];
    self.bgView=bgView;
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), ddhLabel.bottom+lsLabel.height+WZ(20), WZ(50), WZ(50))];
    iconIV.layer.cornerRadius=3;
    iconIV.clipsToBounds=YES;
    [self.contentView addSubview:iconIV];
    self.iconIV=iconIV;
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10)-WZ(50), WZ(25))];
    nameLabel.font=FONT(17,15);
    [self.contentView addSubview:nameLabel];
    self.nameLabel=nameLabel;
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom+WZ(5), nameLabel.width, WZ(20))];
    priceLabel.font=FONT(15,13);
    priceLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:priceLabel];
    self.priceLabel=priceLabel;
    
    UILabel *sfLabel=[[UILabel alloc]init];
    sfLabel.font=FONT(15,13);
    [self.contentView addSubview:sfLabel];
    self.sfLabel=sfLabel;
    
    UILabel *slLabel=[[UILabel alloc]init];
    slLabel.font=FONT(15,13);
    [self.contentView addSubview:slLabel];
    self.slLabel=slLabel;
    
    UILabel *skrLabel=[[UILabel alloc]init];
    skrLabel.font=FONT(15,13);
    [self.contentView addSubview:skrLabel];
    self.skrLabel=skrLabel;
    
    OrderRightBtn *orderRightBtn=[[OrderRightBtn alloc]init];
    [orderRightBtn setTitleColor:COLOR(254, 167, 173, 1) forState:UIControlStateNormal];
    orderRightBtn.layer.cornerRadius=5;
    orderRightBtn.clipsToBounds=YES;
    orderRightBtn.layer.borderColor=COLOR(254, 167, 173, 1).CGColor;
    orderRightBtn.layer.borderWidth=1;
    orderRightBtn.titleLabel.font=FONT(15,13);
    [self.contentView addSubview:orderRightBtn];
    self.orderRightBtn=orderRightBtn;
    
    OrderLeftBtn *orderLeftBtn=[[OrderLeftBtn alloc]init];//WithFrame:CGRectMake(SCREEN_WIDTH-WZ(15*2)-lastBtn.width-WZ(90), bgView.bottom+WZ(40+10), WZ(90), WZ(40))
    [orderLeftBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    orderLeftBtn.layer.cornerRadius=5;
    orderLeftBtn.clipsToBounds=YES;
    orderLeftBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    orderLeftBtn.layer.borderWidth=1;
    orderLeftBtn.titleLabel.font=FONT(15,13);
    [self.contentView addSubview:orderLeftBtn];
    self.orderLeftBtn=orderLeftBtn;
    
    UILabel *smLabel=[[UILabel alloc]init];
    smLabel.font=FONT(13,11);
    [self.contentView addSubview:smLabel];
    self.smLabel=smLabel;
    
    
    
    
}











@end

@implementation OrderLeftBtn

@synthesize orderDict;

@end

@implementation OrderRightBtn

@synthesize orderDict;

@end

