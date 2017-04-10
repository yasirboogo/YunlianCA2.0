//
//  OrderConfirmViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/7/25.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

@interface OrderConfirmViewController : ViewController

@property(nonatomic,strong)NSString *merchantId;
@property(nonatomic,strong)NSMutableDictionary *orderDict;
@property(nonatomic,strong)NSMutableArray *goodsInfoArray;
@property(nonatomic,assign)BOOL isStoreDetailVC;
@property(nonatomic,assign)BOOL isGoodsDetailVC;

@end
