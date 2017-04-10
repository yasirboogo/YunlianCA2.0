//
//  UIScrollView+ScrollView.m
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "UIScrollView+ScrollView.h"

@implementation UIScrollView (ScrollView)

+(UIScrollView*)scrollViewWithFrame:(CGRect)rect contentSize:(CGSize)size backColor:(UIColor *)backcolor delegate:(id<UIScrollViewDelegate>)delegate
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.contentSize     = size;
    scrollView.backgroundColor = backcolor;
    scrollView.delegate        = delegate;
    
    return scrollView;
    
    
}





@end
