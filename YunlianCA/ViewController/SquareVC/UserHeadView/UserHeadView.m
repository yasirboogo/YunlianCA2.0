//
//  UserHeadView.m
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "UserHeadView.h"

@implementation UserHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor=COLOR_WHITE;
        [self createUserHeadView];
    }
    
    return self;
}

-(void)createUserHeadView
{
    UIButton *headImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), WZ(40), WZ(40))];
    headImageBtn.layer.cornerRadius=headImageBtn.width/2.0;
    headImageBtn.clipsToBounds=YES;
    [self addSubview:headImageBtn];
    self.headImageBtn=headImageBtn;
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImageBtn.right+WZ(10), headImageBtn.top, SCREEN_WIDTH-headImageBtn.right-WZ(10+15+60+15+60+10), WZ(25))];
    nameLabel.font=FONT(17,15);
    nameLabel.textColor=COLOR(255, 150, 158, 1);
    [self addSubview:nameLabel];
    self.nameLabel=nameLabel;
    
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, WZ(68), WZ(20))];
    timeLabel.font=FONT(11,9);
//    timeLabel.backgroundColor=COLOR_CYAN;
    [self addSubview:timeLabel];
    self.timeLabel=timeLabel;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(timeLabel.right, timeLabel.top+WZ(4), 1, timeLabel.height-WZ(4*2))];
    lineView.backgroundColor=COLOR_LIGHTGRAY;
    [self addSubview:lineView];
    self.lineView=lineView;
    
    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(lineView.right+WZ(6), timeLabel.top, WZ(70), timeLabel.height)];
    addressLabel.font=FONT(11,9);
    addressLabel.textColor=COLOR(66, 151, 222, 1);
//    addressLabel.backgroundColor=COLOR_LIGHTGRAY;
    [self addSubview:addressLabel];
    self.addressLabel=addressLabel;
    
    UHVAddFriendBtn *addFriendBtn=[[UHVAddFriendBtn alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15)-WZ(60), WZ(19), WZ(60), WZ(22))];
    addFriendBtn.layer.cornerRadius=3.0;
    addFriendBtn.clipsToBounds=YES;
    addFriendBtn.titleLabel.font=FONT(13,11);
    [self addSubview:addFriendBtn];
    self.addFriendBtn=addFriendBtn;
    
    UHVGoBtn *goBtn=[[UHVGoBtn alloc]initWithFrame:CGRectMake(addFriendBtn.left-WZ(8+60), addFriendBtn.top, addFriendBtn.width, addFriendBtn.height)];
    [goBtn setTitle:@"串门" forState:UIControlStateNormal];
    [goBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
    goBtn.layer.cornerRadius=3.0;
    goBtn.layer.borderColor=COLOR_LIGHTGRAY.CGColor;
    goBtn.layer.borderWidth=1;
    goBtn.clipsToBounds=YES;
    goBtn.titleLabel.font=FONT(13,11);
    [self addSubview:goBtn];
    self.goBtn=goBtn;
    
    
    
    
}




























@end

@implementation UHVAddFriendBtn

@synthesize dict;

@end


@implementation UHVGoBtn

@synthesize dict;

@end
