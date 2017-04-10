//
//  GoodsManageCell.h
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDeleteBtn;

@interface GoodsManageCell : UITableViewCell

/**
 *  商品图片
 */
@property(nonatomic,strong)UIImageView *iconIV;
/**
 *  商品名称
 */
@property(nonatomic,strong)UILabel *nameLabel;
/**
 *  商品价格
 */
@property(nonatomic,strong)UILabel *priceLabel;
/**
 *  商品销量
 */
@property(nonatomic,strong)UILabel *xlLabel;
/**
 *  商品库存
 */
@property(nonatomic,strong)UILabel *kcLabel;
/**
 *  分割线
 */
@property(nonatomic,strong)UIView *lineView;
/**
 *  删除商品按钮
 */
@property(nonatomic,strong)GoodsDeleteBtn *deleteBtn;
/**
 *  编辑商品按钮
 */
//@property(nonatomic,strong)UIButton *editBtn;



@end

@interface GoodsDeleteBtn : UIButton

@property(nonatomic,strong)NSDictionary *goodsDict;

@end