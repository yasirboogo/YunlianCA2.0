//
//  GoodsManageCell.m
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "GoodsManageCell.h"

#import "ViewController.h"

@implementation GoodsManageCell

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
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [self createUI];
        
        
        
        
        
    }
    return self;
}

-(void)createUI
{
    UIImageView *iconIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(50), WZ(50))];
    iconIV.layer.cornerRadius=3;
    iconIV.clipsToBounds=YES;
    [self.contentView addSubview:iconIV];
    self.iconIV=iconIV;
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(iconIV.right+WZ(10), iconIV.top, SCREEN_WIDTH-WZ(15*2+10)-WZ(50), WZ(18))];
    nameLabel.font=FONT(15,13);
    [self.contentView addSubview:nameLabel];
    self.nameLabel=nameLabel;
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, WZ(18))];
    priceLabel.font=FONT(15,13);
    priceLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:priceLabel];
    self.priceLabel=priceLabel;
    
    UILabel *xlLabel=[[UILabel alloc]init];
    xlLabel.font=FONT(11,9);
    xlLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:xlLabel];
    self.xlLabel=xlLabel;
    
    UILabel *kcLabel=[[UILabel alloc]init];
    kcLabel.font=FONT(11,9);
    kcLabel.textColor=COLOR_LIGHTGRAY;
    [self.contentView addSubview:kcLabel];
    self.kcLabel=kcLabel;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(iconIV.left, iconIV.bottom+WZ(15), SCREEN_WIDTH-iconIV.left, 1)];
    lineView.backgroundColor=COLOR(230, 230, 230, 1);
    [self.contentView addSubview:lineView];
    self.lineView=lineView;
    
    CGSize deleteSize=[ViewController sizeWithString:@"删除" font:FONT(17,15) maxSize:CGSizeMake(WZ(100), WZ(25))];
    UILabel *deleteLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-deleteSize.width, lineView.bottom+WZ(10), deleteSize.width, WZ(25))];
    deleteLabel.text=@"删除";
    deleteLabel.font=FONT(17,15);
    [self.contentView addSubview:deleteLabel];
    
    UIImageView *deleteIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-deleteSize.width-WZ(15+5+20), lineView.bottom+WZ(12.5), WZ(20), WZ(20))];
    deleteIV.image=IMAGE(@"shanchu");
    [self.contentView addSubview:deleteIV];
    
    GoodsDeleteBtn *deleteBtn=[[GoodsDeleteBtn alloc]initWithFrame:CGRectMake(deleteIV.left, deleteIV.top, deleteIV.width+WZ(5)+deleteSize.width, deleteIV.height)];
    deleteBtn.backgroundColor=COLOR_CLEAR;
    [self.contentView addSubview:deleteBtn];
    self.deleteBtn=deleteBtn;
    
//    CGSize editSize=[ViewController sizeWithString:@"编辑" font:FONT(17,15) maxSize:CGSizeMake(WZ(100), WZ(25))];
//    UILabel *editLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-deleteSize.width-deleteIV.width-editSize.width-WZ(15+5+30), lineView.bottom+WZ(10), editSize.width, WZ(25))];
//    editLabel.text=@"编辑";
//    editLabel.font=FONT(17,15);
//    [self.contentView addSubview:editLabel];
//    
//    UIImageView *editIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-deleteSize.width-deleteIV.width-editSize.width-WZ(15+5+30+5+20), lineView.bottom+WZ(12.5), WZ(20), WZ(20))];
//    editIV.image=IMAGE(@"bianji");
//    [self.contentView addSubview:editIV];
//    
//    UIButton *editBtn=[[UIButton alloc]initWithFrame:CGRectMake(editIV.left, editIV.top, editIV.width+WZ(5)+editSize.width, editIV.height)];
//    editBtn.backgroundColor=COLOR_CLEAR;
//    [self.contentView addSubview:editBtn];
//    self.editBtn=editBtn;
    
    
    
    
    
}























@end

@implementation GoodsDeleteBtn

@synthesize goodsDict;

@end