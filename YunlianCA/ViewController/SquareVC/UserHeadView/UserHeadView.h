//
//  UserHeadView.h
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UHVAddFriendBtn;
@class UHVGoBtn;

@interface UserHeadView : UIView

-(instancetype)initWithFrame:(CGRect)frame;


/**
 *  用户头像
 */
@property(nonatomic,strong)UIButton *headImageBtn;
/**
 *  用户名
 */
@property(nonatomic,strong)UILabel *nameLabel;
/**
 *  发帖时间
 */
@property(nonatomic,strong)UILabel *timeLabel;
/**
 *  添加好友
 */
@property(nonatomic,strong)UHVAddFriendBtn *addFriendBtn;
/**
 *  时间和地点间的竖线
 */
@property(nonatomic,strong)UIView *lineView;
/**
 *  用户所在省市
 */
@property(nonatomic,strong)UILabel *addressLabel;
/**
 *  串门
 */
@property(nonatomic,strong)UHVGoBtn *goBtn;











@end

@interface UHVAddFriendBtn : UIButton
@property(nonatomic,strong)NSDictionary *dict;
@end

@interface UHVGoBtn : UIButton
@property(nonatomic,strong)NSDictionary *dict;
@end
