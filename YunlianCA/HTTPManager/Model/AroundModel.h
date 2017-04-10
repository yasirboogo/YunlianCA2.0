//
//  AroundModel.h
//  YunlianCA
//
//  Created by QinJun on 16/7/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AroundModel : NSObject


/**
 *  返回状态
 */
@property(nonatomic,strong)NSString *result;
/**
 *  错误信息
 */
@property(nonatomic,strong)NSString *error;
/**
 *  大类创建时间
 */
@property(nonatomic,strong)NSString *bigClassCreateTime;
/**
 *  小类创建时间
 */
@property(nonatomic,strong)NSString *smallClassCreateTime;
/**
 *  大类图片
 */
@property(nonatomic,strong)NSString *bigClassImage;
/**
 *  大类ID
 */
@property(nonatomic,strong)NSString *bigClassId;
/**
 *  大类名字
 */
@property(nonatomic,strong)NSString *bigClassName;
/**
 *  大类的父类ID
 */
@property(nonatomic,strong)NSString *bigClassParentId;
/**
 *  大类数组
 */
@property(nonatomic,strong)NSMutableArray *bigClassArray;
/**
 *  大类下面的小类数组
 */
@property(nonatomic,strong)NSMutableArray *smallClassArray;
/**
 *  是否在主页
 */
@property(nonatomic,strong)NSString *isHome;












@end
