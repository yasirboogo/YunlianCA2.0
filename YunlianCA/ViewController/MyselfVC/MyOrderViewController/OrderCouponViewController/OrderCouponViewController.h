//
//  OrderCouponViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/8/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"
typedef void(^selectCouponBlock) (NSDictionary *);
@interface OrderCouponViewController : ViewController

@property(nonatomic,strong)NSMutableDictionary *orderDict;
@property(nonatomic,copy)selectCouponBlock block;
@end
