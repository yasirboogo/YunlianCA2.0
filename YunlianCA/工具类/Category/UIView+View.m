//
//  UIView+View.m
//  BJFZ
//
//  Created by QinJun on 15/7/21.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "UIView+View.h"

@implementation UIView (View)

//横着的线
+(UIView *)lineViewWithFrame:(CGRect)frame
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)];
    lineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    lineView.layer.borderWidth=1;
    
    return lineView;
    
    
}

//竖着的线
+(UIView *)shuXianWithFrame:(CGRect)frame
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 1, frame.size.height)];
    lineView.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    lineView.layer.borderWidth=1;
    
    return lineView;
}


/// 实例化 Frame + backgroundColor
+ (UIView *)viewWithFrame:(CGRect)rect backColor:(UIColor *)backColor
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    return view;
}

+ (UIView *)imageViewWithFrame:(CGRect)rect backColor:(UIColor *)backColor imageName:(NSString *)name imageRect:(CGRect)iRect
{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    
    view.backgroundColor = backColor;
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = COLOR(201, 201, 201, 1).CGColor;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:iRect];
    // 声明图片用原图(别渲染)

    image.image = [image.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    image.image = [UIImage imageNamed:name];
    
  
    
    [view addSubview:image];
    
    return view;
}

//////////////////////////////////////////////////////


/// 重设x起点
- (void)resetOrigin_x:(float)x animated:(BOOL)animated
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    
    if(animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = rect;
        }];
    }
    else
    {
        self.frame = rect;
    }
}

/// 重设y起点
- (void)resetOrigin_y:(float)y animated:(BOOL)animated
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    if(animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = rect;
        }];
    }
    else
    {
        self.frame = rect;
    }
}


//////////////////////////////////////////////////////


/// 设置顶部两个圆角
- (void)setUpRadii:(int)radii
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/// 设置底部两个圆角
- (void)setDownRadii:(int)radii
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/// 设置四个圆角   边框宽度,边框颜色
- (void)setCornerRadius:(float)Radius andBorderWidth:(float)Width andBorderColor:(UIColor *)BorderColor
{
    self.clipsToBounds = YES;
    
    [self.layer setCornerRadius:Radius];
    
    if(Width)
        [self.layer setBorderWidth:Width];
    
    if (BorderColor)
        [self.layer setBorderColor:[BorderColor CGColor]];
}


//////////////////////////////////////////////////////


/// 获取相同大小的Frame 在右边还是下边 + 间隔
- (CGRect)getFrameWithInterval:(float)interval isRight:(BOOL)is
{
    CGRect rect;
    if(is)
    {
        rect = CGRectMake(self.right+interval, self.top, self.width, self.height);
    }
    else
    {
        rect = CGRectMake(self.left, self.bottom+interval, self.width, self.height);
    }
    return rect;
}

/// 判断某个点是否在当前View以内
- (BOOL)pointIsInSelfFrame:(CGPoint)p
{
    return ((p.x > self.left) && (p.x < self.right) && (p.y > self.top) && (p.y < self.bottom));
}

/// 在底部添加一条分隔线
- (void)addLine
{
    UIView *line = [UIView viewWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5) backColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]];
    [self addSubview:line];
}

@end




#pragma mark - 视图坐标扩展 -
@implementation UIView (ViewGeometry)

/// 获取rect中心点
CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

/// rect移动到中心点
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x - CGRectGetMidX(rect);
    newrect.origin.y = center.y - CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

/// 坐标
- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;
}

// 大小
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

/// x坐标
- (CGFloat)left {
    //    return self.frame.origin.x;
    return CGRectGetMinX(self.frame);
}
- (void)setLeft:(CGFloat)x{
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}

/// y坐标
- (CGFloat)top{
    //    return self.frame.origin.y;
    return CGRectGetMinY(self.frame);
}
- (void)setTop:(CGFloat)y{
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}

/// 宽度
- (CGFloat)width{
    //    return self.frame.size.width;
    return CGRectGetWidth(self.frame);
}
- (void)setWidth:(CGFloat)width{
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

/// 高度
- (CGFloat)height{
    //    return self.frame.size.height;
    return CGRectGetHeight(self.frame);
}
- (void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

/// 右面
- (CGFloat)right {
    //    return self.frame.origin.x + self.frame.size.width;
    return CGRectGetMaxX(self.frame);
}
- (void)setRight:(CGFloat)right {
    CGFloat delta = right - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

/// 下面
- (CGFloat)bottom {
    //    return self.frame.origin.y + self.frame.size.height;
    return CGRectGetMaxY(self.frame);
}
- (void)setBottom:(CGFloat)bottom {
    CGRect newframe = self.frame;
    newframe.origin.y = bottom - self.frame.size.height;
    self.frame = newframe;
}

/// 左下角
- (CGPoint)bottomLeft {
    CGFloat x = CGRectGetMinX(self.frame);
    CGFloat y = CGRectGetMaxY(self.frame);
    return CGPointMake(x, y);
}
/// 右下角
- (CGPoint)bottomRight {
    CGFloat x = CGRectGetMaxX(self.frame);
    CGFloat y = CGRectGetMaxY(self.frame);
    return CGPointMake(x, y);
}
/// 右上角
- (CGPoint)topRight {
    CGFloat x = CGRectGetMaxX(self.frame);
    CGFloat y = CGRectGetMinY(self.frame);
    return CGPointMake(x, y);
}


/// 距离屏幕的left
- (CGFloat)screenLeft {
    CGFloat x = 0;
    for (UIView *view = self; view; view = view.superview){
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}
/// 距离屏幕的top
- (CGFloat)screenTop {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview){
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y - [UIApplication sharedApplication].statusBarFrame.size.height;
}
/// 距离屏幕的frame
- (CGRect)screenFrame {
    return CGRectMake(self.screenLeft, self.screenTop, self.width, self.height);
}


/// 根据传入的子视图与当前视图计算出水平中心开始点
- (CGFloat)centerHorizontalWithSubView:(UIView *)subView {
    return (self.width - subView.width) / 2;
}
/// 根据传入的子视图与当前视图计算出垂直中心开始点
- (CGFloat)centerVerticalWithSubView:(UIView *)subView {
    return (self.height - subView.height) / 2;
}
/// 根据传入的子视图与当前视图计算出中心点
- (CGPoint)centerWithSubView:(UIView *)subView {
    return CGPointMake([self centerHorizontalWithSubView:subView],[self centerVerticalWithSubView:subView]);
}


/// 居中增加子视图
- (void)addSubViewToCenter:(UIView *)subView {
    CGRect rect = subView.frame;
    rect.origin = [self centerWithSubView:subView];
    subView.frame = rect;
    [self addSubview:subView];
}
/// 水平居中增加子视图
- (void)addSubViewToHorizontalCenter:(UIView *)subView {
    CGRect rect = subView.frame;
    rect.origin.x = [self centerHorizontalWithSubView:subView];
    subView.frame = rect;
    [self addSubview:subView];
}
/// 垂直居中增加子视图
- (void)addSubViewToVerticalCenter:(UIView *)subView {
    CGRect rect = subView.frame;
    rect.origin.y = [self centerVerticalWithSubView:subView];
    subView.frame = rect;
    [self addSubview:subView];
}


/// 移动 offset 的距离
- (void)moveBy:(CGPoint)offset {
    CGPoint newCenter = self.center;
    newCenter.x += offset.x;
    newCenter.y += offset.y;
    self.center = newCenter;
}
/// 宽高等比例缩放
- (void)scaleBy:(CGFloat)scaleFactor {
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}
/// 给定的尺寸按比例缩小
- (void)fitInSize:(CGSize)aSize {
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


@end


#pragma mark - 视图层次扩展 -
@implementation UIView (ZOrder)

/// 当前视图在父视图中的索引
- (NSUInteger)getSubviewIndex {
    return [self.superview.subviews indexOfObject:self];
}

/// 将视图置于父视图最上面
- (void)bringToFront {
    [self.superview bringSubviewToFront:self];
}

/// 将视图置于父视图最下面
- (void)sendToBack {
    [self.superview sendSubviewToBack:self];
}

/// 视图层次上移一层
- (void)bringOneLevelUp
{
    NSInteger currentIndex = [self getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex+1];
}

/// 视图层次下移一层
- (void)sendOneLevelDown {
    NSInteger currentIndex = [self getSubviewIndex];
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex-1];
}

/// 是否在最上面
- (BOOL)isInFront {
    return [self.superview.subviews lastObject] == self;
}

/// 是否在最下面
- (BOOL)isAtBack {
    return [self.superview.subviews objectAtIndex:0] == self;
}

/// 视图交换层次
- (void)swapDepthsWithView:(UIView*)swapView {
    [self.superview exchangeSubviewAtIndex:[self getSubviewIndex] withSubviewAtIndex:[swapView getSubviewIndex]];
}










@end
