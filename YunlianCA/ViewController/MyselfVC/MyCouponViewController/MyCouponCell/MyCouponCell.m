//
//  MyCouponCell.m
//  YunlianCA
//
//  Created by QinJun on 16/6/17.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "MyCouponCell.h"

@implementation MyCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createUI];
        
    }
    
    
    return self;
}

-(void)createUI
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(130))];
//    bgView.backgroundColor=COLOR_HEADVIEW;
    [self.contentView addSubview:bgView];
    
    UIImageView *bgIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2), bgView.height-WZ(10*2))];
    [self.contentView addSubview:bgIV];
    self.bgIV=bgIV;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15+15), bgIV.top+WZ(15), WZ(200), WZ(25))];
    titleLabel.font=FONT(17,15);
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    UILabel *pointLabel0=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, WZ(10), WZ(20))];
    pointLabel0.text=@"·";
    pointLabel0.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:pointLabel0];
    
    UILabel *tjLabel=[[UILabel alloc]initWithFrame:CGRectMake(pointLabel0.right, pointLabel0.top, WZ(190), WZ(20))];
    tjLabel.font=FONT(11,9);
    tjLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:tjLabel];
    self.tjLabel=tjLabel;
    
    UILabel *pointLabel1=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, pointLabel0.bottom, WZ(10), WZ(20))];
    pointLabel1.text=@"·";
    pointLabel1.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:pointLabel1];
    
    UILabel *yxqLabel=[[UILabel alloc]initWithFrame:CGRectMake(pointLabel1.right, pointLabel1.top, WZ(190), WZ(20))];
    yxqLabel.font=FONT(11,9);
    yxqLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:yxqLabel];
    self.yxqLabel=yxqLabel;
    
    UILabel *pointLabel2=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.left, pointLabel1.bottom, WZ(10), WZ(20))];
    pointLabel2.text=@"·";
    pointLabel2.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:pointLabel2];
    
    UILabel *zcsjLabel=[[UILabel alloc]initWithFrame:CGRectMake(pointLabel2.right, pointLabel2.top, WZ(190), WZ(20))];
    zcsjLabel.font=FONT(11,9);
    zcsjLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:zcsjLabel];
    self.zcsjLabel=zcsjLabel;
    
    UILabel *yhjgLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(125), bgView.height/2.0-WZ(30)/2.0, WZ(125), WZ(30))];
    yhjgLabel.textColor=COLOR_WHITE;
    yhjgLabel.font=FONT(19,17);
    yhjgLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:yhjgLabel];
    self.yhjgLabel=yhjgLabel;
    
    
    
    
    
}










































@end
