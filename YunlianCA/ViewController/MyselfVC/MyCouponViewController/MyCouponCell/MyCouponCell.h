//
//  MyCouponCell.h
//  YunlianCA
//
//  Created by QinJun on 16/6/17.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponCell : UITableViewCell




/**
 *  优惠券名称
 */
@property(nonatomic,strong)UILabel *titleLabel;
/**
 *  优惠券背景
 */
@property(nonatomic,strong)UIImageView *bgIV;
/**
 *  优惠券条件 满多少钱可用
 */
@property(nonatomic,strong)UILabel *tjLabel;
/**
 *  优惠券有效期
 */
@property(nonatomic,strong)UILabel *yxqLabel;
/**
 *  优惠券所支持的商家
 */
@property(nonatomic,strong)UILabel *zcsjLabel;
/**
 *  优惠价格 如优惠50元
 */
@property(nonatomic,strong)UILabel *yhjgLabel;








@end
