//
//  UIImage+Image.h
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

/// 1. 等比绽放图片     照相出来时 1936.000000  2592.000000
+ (UIImage *)getScaleImage:(UIImage *)image toSize:(CGSize)size;

/// 2. 截取图中某部分小图
+ (UIImage *)getSubImageFromImage:(UIImage *)oldImage withRect:(CGRect)rect;

/// 3. 固定某张图片方向 向上
+ (UIImage *)fixOrientationForImage:(UIImage *)image;

/// 4. 获取自适应大小的图片
+ (UIImage *)getResizableImage:(NSString *)name;

/// 缩放图片
- (UIImage*)scaleToSize:(CGSize)size;

/// 将view转为image
+ (UIImage *)getImageFromView:(UIView *)view;

///
+ (UIImage *)resizeImage:(NSString *)imageName;




@end
