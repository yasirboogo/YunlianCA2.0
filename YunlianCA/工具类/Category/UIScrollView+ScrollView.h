//
//  UIScrollView+ScrollView.h
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ScrollView)

// 实例化 背景色 + 代理
+ (UIScrollView *)scrollViewWithFrame:(CGRect)rect contentSize:(CGSize)size backColor:(UIColor *)backcolor delegate:(id<UIScrollViewDelegate>)delegate;


@end
