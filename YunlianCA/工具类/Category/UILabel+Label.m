//
//  UILabel+Label.m
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "UILabel+Label.h"
#import "NSString+String.h"




@implementation UILabel (Label)


/**
 *  标准实例化
 */
+ (UILabel *)labelTextCenterWithFrame:(CGRect)rect text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment backColor:(UIColor *)backColor
{
    UILabel *label        = [[UILabel alloc] initWithFrame:rect];
    label.text            = text;
    label.textColor       = textColor;
    label.font            = font;
    label.textAlignment   = alignment;
    label.backgroundColor = backColor;
    
    return label;
}

///**
// *  创建自适应高度的label，frame的高度将会被忽略
// */
//+ (UILabel *)labelAdaptionWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment {
//    // 测量高度
//    CGSize measureSize = [text getSizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, MAXFLOAT)];
//    frame.size.height = measureSize.height;
//    
//    UILabel *label = [self labelTextCenterWithFrame:frame text:text textColor:textColor font:font textAlignment:alignment backColor:[UIColor clearColor]];
//    label.numberOfLines = 0;
//    
//    return label;
//}

/**
 *  自适应高度的label(多行) 忽略frame的宽和高
 */
+(UILabel *)labelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment
{
    NSDictionary *fontDict = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil].size;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)];
    label.text=text;
    label.numberOfLines=0;
    label.font=font;
    label.textAlignment=alignment;
    label.textColor=textColor;
    label.backgroundColor=bgColor;
    label.layer.borderWidth=0;
    label.layer.borderColor=COLOR_CLEAR.CGColor;
    
    
    return label;
}

/**
 *  自适应高度的label(一行) 忽略frame的宽 高固定
 */
+(UILabel *)aLabelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment
{
    NSDictionary *fontDict = @{NSFontAttributeName:font};
    CGFloat length = [text boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil].size.width;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, length+WZ(5), frame.size.height)];
    label.text=text;
    label.font=font;
    label.textAlignment=alignment;
    label.textColor=textColor;
    label.backgroundColor=bgColor;
    label.layer.borderWidth=0;
    label.layer.borderColor=COLOR_CLEAR.CGColor;
    
    
    return label;
}










@end


#pragma mark - VerticalAlign

@implementation UILabel (VerticalAlign)

///**
// *  顶部对齐
// */
//-(void)alignTop {
//    CGSize fontSize =[self.text sizeWithFont:self.font];
//    double finalHeight = fontSize.height *self.numberOfLines;
//    double finalWidth =self.frame.size.width;//expected width of label
//    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
//    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
//    for(int i=0; i<newLinesToPad; i++)
//        self.text =[self.text stringByAppendingString:@"\n "];
//}
//
///**
// *  底部对齐
// */
//-(void)alignBottom {
//    CGSize fontSize =[self.text sizeWithFont:self.font];
//    double finalHeight = fontSize.height *self.numberOfLines;
//    double finalWidth =self.frame.size.width;//expected width of label
//    CGSize theStringSize =[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
//    int newLinesToPad =(finalHeight - theStringSize.height)/ fontSize.height;
//    for(int i=0; i<newLinesToPad; i++)
//        self.text =[NSString stringWithFormat:@" \n%@",self.text];
//}







@end
