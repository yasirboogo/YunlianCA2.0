//
//  UIScrollView+LH.m
//  YDT
//
//  Created by lh on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIScrollView+LH.h"

@implementation UIScrollView (LH)

/// 实例化 背景色 + 代理
+ (UIScrollView *)scrollViewWithFrame:(CGRect)rect contentSize:(CGSize)size backColor:(UIColor *)backcolor delegate:(id<UIScrollViewDelegate>)delegate
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.contentSize     = size;
    scrollView.backgroundColor = backcolor;
    scrollView.delegate        = delegate;
    
    return scrollView;
}

@end
