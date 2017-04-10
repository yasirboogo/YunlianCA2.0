//
//  DetailOrderViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/16.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

@class OrderDetailLeftBtn;
@class OrderDetailRightBtn;

@interface DetailOrderViewController : ViewController


@property(nonatomic,strong)NSDictionary *orderDict;

//这两个布尔值是为了确定是从哪个界面进订单详情支付的 主要是为了判断不同界面进来支付 isMyOrderVC兼顾订单详情界面底部按钮如何摆放功能
@property(nonatomic,assign)BOOL isMyOrderVC;
@property(nonatomic,assign)BOOL isOrderDetailVC;
//这个布尔值为了判断不同界面 确定订单详情界面底部按钮如何摆放
@property(nonatomic,assign)BOOL isReceivedOrderVC;

@property(nonatomic,assign)BOOL isPaySuccessVC;

@end


@interface OrderDetailLeftBtn : UIButton

@property(nonatomic,strong)NSDictionary *orderDict;

@end

@interface OrderDetailRightBtn : UIButton

@property(nonatomic,strong)NSDictionary *orderDict;

@end