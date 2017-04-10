//
//  ShareView.h
//  UEnjoyCustomer
//
//  Created by 马JL on 2016/11/8.
//  Copyright © 2016年 马JL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^shareToAdjacentBlock) (UIButton * button);
@interface ShareView : UIView

@property(copy,nonatomic)NSString * shareTitle;
@property(copy,nonatomic)NSString * shareContent;
@property(copy,nonatomic)NSString * shareUrl;
@property(strong,nonatomic)UIButton * lastButton;
@property(strong,nonatomic)NSMutableArray * buttonArray;
@property(assign,nonatomic)BOOL isShowAdjacent;
@property(assign,nonatomic)BOOL isSelectBtn;
@property(strong,nonatomic)NSString * shareImageStr;
@property(strong,nonatomic)UIView * backView;
@property(strong,nonatomic)UIImage * image;
@property(copy,nonatomic)shareToAdjacentBlock block;
+(instancetype)sharedInstance;
-(instancetype)initWithFrame:(CGRect)frame;
-(void)showView;
-(void)dismissView;
-(void)shareWithImageUrlArray:(NSArray*)imageUrlArray title:(NSString*)title content:(NSString*)content url:(NSString*)url;
@end
