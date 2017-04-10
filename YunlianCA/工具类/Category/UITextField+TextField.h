//
//  UITextField+TextField.h
//  BJFZ
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TextField)

/// 是否是空的文本，空文本 → YES，非空文本 → NO
@property (nonatomic, assign, readonly) BOOL isEmptyText;


/// 标准实例化
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textAlignment:(NSTextAlignment)alignment backColor:(UIColor *)backColor;

/// 标准实例化：keyboardType
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment keyboardType:(UIKeyboardType)keyboardType;



@end
