//
//  OrderTableViewCell.h
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderLeftBtn;
@class OrderRightBtn;


@interface OrderTableViewCell : UITableViewCell

/**
 *  订单号
 */
@property(nonatomic,strong)UILabel *ddhLabel;
/**
 *  订单状态（待付款、待收货、待评价（已完成））
 */
@property(nonatomic,strong)UILabel *ztLabel;
/**
 *  流水号
 */
@property(nonatomic,strong)UILabel *lsLabel;
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
 *  实付价格
 */
@property(nonatomic,strong)UILabel *sfLabel;
/**
 *  商品数量
 */
@property(nonatomic,strong)UILabel *slLabel;
/**
 *  收款人
 */
@property(nonatomic,strong)UILabel *skrLabel;
/**
 *  订单列表底部左边按钮
 */
@property(nonatomic,strong)OrderLeftBtn *orderLeftBtn;
/**
 *  订单列表底部右边按钮
 */
@property(nonatomic,strong)OrderRightBtn *orderRightBtn;
/**
 *  退款说明
 */
@property(nonatomic,strong)UILabel *smLabel;








@end

@interface OrderLeftBtn : UIButton

@property(nonatomic,strong)NSDictionary *orderDict;

@end

@interface OrderRightBtn : UIButton

@property(nonatomic,strong)NSDictionary *orderDict;

@end








