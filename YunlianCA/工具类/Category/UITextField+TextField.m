//
//  UITextField+TextField.m
//  BJFZ
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "UITextField+TextField.h"
#import "NSString+String.h"

@implementation UITextField (TextField)

/// 是否是空的文本，空文本 → YES，非空文本 → NO
- (BOOL)isEmptyText
{
    return ![self.text isNotEmpty];
}


/// 标准实例化
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment backColor:(UIColor *)backColor {
    UITextField *textField = [UITextField textFieldWithFrame:frame placeholder:placeholder font:font textAlignment:textAlignment keyboardType:UIKeyboardTypeDefault];
    textField.backgroundColor = backColor;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = COLOR_LIGHTGRAY.CGColor;
    return textField;
}

/// 标准实例化：keyboardType
+ (UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment keyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder  = placeholder;
    textField.font = font;
    textField.textAlignment = textAlignment;
    textField.keyboardType = keyboardType;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = COLOR(201, 201, 201, 1).CGColor;
    // default
    textField.backgroundColor = COLOR_CLEAR;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.text = @"";    // iOS6下text没有默认值，为nil
    
    return textField;
}





@end
