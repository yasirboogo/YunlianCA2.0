//
//  TapImageView.h
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>

- (void) tappedWithObject:(id) sender;

@end

@interface TapImageView : UIImageView

@property (nonatomic, strong) id identifier;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (weak) id<TapImageViewDelegate> t_delegate;
@property (nonatomic, assign) NSInteger buttonTag;
@property(nonatomic,strong)NSArray *imageBtnArray;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
