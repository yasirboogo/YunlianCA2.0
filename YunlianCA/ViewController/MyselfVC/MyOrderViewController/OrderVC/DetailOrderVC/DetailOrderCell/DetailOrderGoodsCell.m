//
//  DetailOrderGoodsCell.m
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "DetailOrderGoodsCell.h"

@implementation DetailOrderGoodsCell

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
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), 0, WZ(250), WZ(40))];
    topLabel.font=FONT(17,15);
    [self.contentView addSubview:topLabel];
    self.topLabel=topLabel;
    
    UILabel *ztLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(50), 0, WZ(50), WZ(40))];
    ztLabel.font=FONT(11,9);
    ztLabel.textColor=COLOR(146, 135, 187, 1);
    ztLabel.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:ztLabel];
    self.ztLabel=ztLabel;
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, topLabel.bottom, SCREEN_WIDTH, WZ(80))];
    bgView.backgroundColor=COLOR(250, 250, 250, 1);
    [self.contentView addSubview:bgView];
    self.bgView=bgView;
    
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), topLabel.bottom+WZ(15), WZ(50), WZ(50))];
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
    
    UIButton *tuikuanBtn=[[UIButton alloc]init];
    [tuikuanBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    tuikuanBtn.layer.cornerRadius=5;
    tuikuanBtn.clipsToBounds=YES;
    tuikuanBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    tuikuanBtn.layer.borderWidth=1;
    tuikuanBtn.titleLabel.font=FONT(15,13);
    [self.contentView addSubview:tuikuanBtn];
    self.tuikuanBtn=tuikuanBtn;
    
    
    
    
}
























@end
