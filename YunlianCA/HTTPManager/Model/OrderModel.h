//
//  OrderModel.h
//  YunlianCA
//
//  Created by QinJun on 16/7/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

/**
 *  返回状态
 */
@property(nonatomic,strong)NSString *result;
/**
 *  错误信息
 */
@property(nonatomic,strong)NSString *error;
/**
 *  订单数组
 */
@property(nonatomic,strong)NSMutableArray *orderListArray;






































@end
