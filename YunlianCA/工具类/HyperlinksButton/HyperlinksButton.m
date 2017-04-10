//
//  HyperlinksButton.m
//  BJFZ
//
//  Created by user on 15/8/20.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "HyperlinksButton.h"

@implementation HyperlinksButton


-(void)setColor:(UIColor *)color
{
    lineColor = [color copy];
    [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect
{
    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    
    if([lineColor isKindOfClass:[UIColor class]])
    {
        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+5);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+5);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
