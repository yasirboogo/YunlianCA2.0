//
//  DetailOrderGoodsCell.h
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOrderGoodsCell : UITableViewCell


/**
 *  顶部商家名称
 */
@property(nonatomic,strong)UILabel *topLabel;
/**
 *  订单状态（待付款、待收货、待评价（已完成））
 */
@property(nonatomic,strong)UILabel *ztLabel;
/**
 *  灰色背景view
 */
@property(nonatomic,strong)UIView *bgView;
/**
 *  商品图片
 */
@property(nonatomic,strong)UIImageView *iconIV;
/**
 *  商品名
 */
@property(nonatomic,strong)UILabel *nameLabel;
/**
 *  商品价格 ¥ 50*1形式
 */
@property(nonatomic,strong)UILabel *priceLabel;
/**
 *  退款按钮
 */
@property(nonatomic,strong)UIButton *tuikuanBtn;


@end
