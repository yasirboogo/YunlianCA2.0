//
//  UIView+View.h
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (View)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

//横着的线
+(UIView *)lineViewWithFrame:(CGRect)frame;
//竖着的线
+(UIView *)shuXianWithFrame:(CGRect)frame;

// 实例化 Frame + backgroundColor
+ (UIView *)viewWithFrame:(CGRect)rect backColor:(UIColor *)backColor;


+ (UIView *)imageViewWithFrame:(CGRect)rect backColor:(UIColor *)backColor imageName:(NSString *)name imageRect:(CGRect)iRect;


//////////////////////////////////////////////////////


/// 重设x起点
- (void)resetOrigin_x:(float)x animated:(BOOL)animated;

/// 重设y起点
- (void)resetOrigin_y:(float)y animated:(BOOL)animated;


//////////////////////////////////////////////////////


/// 设置顶部两个圆角
- (void)setUpRadii:(int)radii;

/// 设置底部两个圆角
- (void)setDownRadii:(int)radii;

/// 设置四个圆角 边框宽度,边框颜色
- (void)setCornerRadius:(float)Radius andBorderWidth:(float)Width andBorderColor:(UIColor *)BorderColor;


//////////////////////////////////////////////////////


/// 获取相同大小的Frame 在右边还是下边 + 间隔
- (CGRect)getFrameWithInterval:(float)interval isRight:(BOOL)is;

/// 判断某个点是否在当前View以内
- (BOOL)pointIsInSelfFrame:(CGPoint)p;

/// 在底部添加一条分隔线
//- (void)addLine;

@end


#pragma mark - 视图坐标扩展 -
@interface UIView (ViewFrameGeometry)

/// 获取rect中心点
CGPoint CGRectGetCenter(CGRect rect);
/// rect移动到中心点
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

/// 坐标
@property CGPoint origin;
/// 大小
@property CGSize size;

/// x坐标
@property CGFloat left;
/// y坐标
@property CGFloat top;
/// 宽度
@property CGFloat width;
/// 高度
@property CGFloat height;

/// 右面
@property CGFloat right;
/// 下面
@property CGFloat bottom;

/// 左下角
@property (readonly) CGPoint bottomLeft;
/// 右下角
@property (readonly) CGPoint bottomRight;
/// 右上角
@property (readonly) CGPoint topRight;


/// 距离屏幕的top
- (CGFloat)screenTop;
/// 距离屏幕的left
- (CGFloat)screenLeft;
/// 距离屏幕的frame
- (CGRect)screenFrame;


/// 根据传入的子视图与当前视图计算出水平中心开始点
- (CGFloat)centerHorizontalWithSubView:(UIView *)subView;
/// 根据传入的子视图与当前视图计算出垂直中心开始点
- (CGFloat)centerVerticalWithSubView:(UIView *)subView;
/// 根据传入的子视图与当前视图计算出中心点
- (CGPoint)centerWithSubView:(UIView *)subView;


/// 居中增加子视图
- (void)addSubViewToCenter:(UIView *)subView;
/// 水平居中增加子视图
- (void)addSubViewToHorizontalCenter:(UIView *)subView;
/// 垂直居中增加子视图
- (void)addSubViewToVerticalCenter:(UIView *)subView;


/// 移动 offset 的距离
- (void)moveBy:(CGPoint)delta;
/// 宽高等比例缩放
- (void)scaleBy:(CGFloat)scaleFactor;
/// 给定的尺寸按比例缩小
- (void)fitInSize:(CGSize)aSize;

@end



#pragma mark - 视图层次扩展 -
@interface UIView (ZOrder)

/// 当前视图在父视图中的索引
- (NSUInteger)getSubviewIndex;

/// 将视图置于父视图最上面
- (void)bringToFront;

/// 将视图置于父视图最下面
- (void)sendToBack;

/// 视图层次上移一层
- (void)bringOneLevelUp;

/// 视图层次下移一层
- (void)sendOneLevelDown;

/// 是否在最上面
- (BOOL)isInFront;

/// 是否在最下面
- (BOOL)isAtBack;

/// 视图交换层次
- (void)swapDepthsWithView:(UIView*)swapView;





@end
