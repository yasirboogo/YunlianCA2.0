//
//  UILabel+Label.h
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Label)


/// 标准实例化
+ (UILabel *)labelTextCenterWithFrame:(CGRect)rect text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment backColor:(UIColor *)backColor;

/**
 *  创建自适应高度的label，frame的高度将会被忽略
 */
//+ (UILabel *)labelAdaptionWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;

/**
 *  自适应高度的label(多行) 忽略frame的宽和高
 */
+(UILabel *)labelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;
/**
 *  自适应高度的label(一行) 忽略frame的宽 高固定
 */
+(UILabel *)aLabelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;



@end

#pragma mark - VerticalAlign

@interface UILabel (VerticalAlign)

///**
// *  顶部对齐
// */
//-(void)alignTop;
//
///**
// *  底部对齐
// */
//-(void)alignBottom;





@end
