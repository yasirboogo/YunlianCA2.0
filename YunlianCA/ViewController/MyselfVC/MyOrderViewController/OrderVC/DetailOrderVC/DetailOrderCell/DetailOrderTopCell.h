//
//  DetailOrderTopCell.h
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOrderTopCell : UITableViewCell


/**
 *  顶部红色背景
 */
@property(nonatomic,strong)UIView *topView;
/**
 *  订单状态
 */
@property(nonatomic,strong)UILabel *statusLabel;
/**
 *  订单编号
 */
@property(nonatomic,strong)UILabel *orderNumLabel;
/**
 *  流水编号
 */
@property(nonatomic,strong)UILabel *tradeNumLabel;
/**
 *  下单时间
 */
@property(nonatomic,strong)UILabel *orderTimeLabel;
/**
 *  支付方式
 */
//@property(nonatomic,strong)UILabel *payTypeLabel;
/**
 *  收货人
 */
@property(nonatomic,strong)UILabel *consigneeLabel;
/**
 *  手机号
 */
@property(nonatomic,strong)UILabel *mobileLabel;
/**
 *  位置图标
 */
@property(nonatomic,strong)UIImageView *addressIV;
/**
 *  收货地址
 */
@property(nonatomic,strong)UILabel *addressLabel;




@end
