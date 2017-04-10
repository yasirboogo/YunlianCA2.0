//
//  ArticleBottomView.h
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticlePraiseLabel;

@interface ArticleBottomView : UIView

-(instancetype)initWithFrame:(CGRect)frame;


///**
// *  发帖地址
// */
//@property(nonatomic,strong)UILabel *addressLabel;
/**
 *  浏览人数图标
 */
@property(nonatomic,strong)UIImageView *pageViewIV;
/**
 *  浏览人数
 */
@property(nonatomic,strong)UILabel *pageViewLabel;
/**
 *  点赞人数
 */
@property(nonatomic,strong)ArticlePraiseLabel *praiseLabel;

/**
 *  评论图标
 */
@property(nonatomic,strong)UIImageView *commentIV;
@property(nonatomic,strong)UIButton *commentBtn;
/**
 *  评论人数
 */
@property(nonatomic,strong)UILabel *commentLabel;
/**
 *  点赞按钮
 */
@property(nonatomic,strong)UIButton *praiseBtn;
/**
 *  嘴人数
 */
@property(nonatomic,strong)UILabel *zuiLabel;
/**
 *  嘴按钮
 */
@property(nonatomic,strong)UIButton *zuiBtn;
/**
 *  嘴图标
 */
@property(nonatomic,strong)UIImageView *zuiIV;











@end

@interface ArticlePraiseLabel : UILabel

@property(nonatomic,assign)NSInteger cellRow;

@end
