//
//  ArticleBottomView.m
//  YunlianCA
//
//  Created by QinJun on 16/6/12.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ArticleBottomView.h"

@implementation ArticleBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:CGRectMake(0, frame.origin.y, SCREEN_WIDTH, WZ(30))])
    {
        self.backgroundColor=COLOR_WHITE;
        [self createArticleBottomView];
    }
    
    return self;
}

-(void)createArticleBottomView
{
    CGFloat height=WZ(15);
//    UIImageView *addressIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(15), WZ(15), WZ(15), height)];
//    addressIV.image=IMAGE(@"dingwei");
//    [self addSubview:addressIV];
    
//    UILabel *addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(addressIV.right+WZ(5), addressIV.top, WZ(100), height)];
//    addressLabel.font=FONT(12);
//    [self addSubview:addressLabel];
//    self.addressLabel=addressLabel;
    
    UIImageView *pageViewIV=[[UIImageView alloc]initWithFrame:CGRectMake(WZ(90), WZ(7.5), WZ(22), height)];
    pageViewIV.image=IMAGE(@"liulanrenshu");
    [self addSubview:pageViewIV];
    self.pageViewIV=pageViewIV;
    
    UILabel *pageViewLabel=[[UILabel alloc]initWithFrame:CGRectMake(pageViewIV.right+WZ(5), WZ(7.5), WZ(40), height)];
    pageViewLabel.font=Font(12);
    [self addSubview:pageViewLabel];
    self.pageViewLabel=pageViewLabel;
    
    UIButton *praiseBtn=[[UIButton alloc]initWithFrame:CGRectMake(pageViewLabel.right+WZ(10), WZ(7.5), height, height)];
    [praiseBtn setBackgroundImage:IMAGE(@"dianzanrenshu_hui") forState:UIControlStateNormal];
    [self addSubview:praiseBtn];
    self.praiseBtn=praiseBtn;
    
    ArticlePraiseLabel *praiseLabel=[[ArticlePraiseLabel alloc]initWithFrame:CGRectMake(praiseBtn.right+WZ(5), praiseBtn.top, WZ(40), height)];
    praiseLabel.font=Font(12);
    [self addSubview:praiseLabel];
    self.praiseLabel=praiseLabel;
    
    UIImageView *commentIV=[[UIImageView alloc]initWithFrame:CGRectMake(praiseLabel.right+WZ(10), WZ(7.5), height, height)];
    commentIV.contentMode = UIViewContentModeScaleAspectFit;
    commentIV.image=IMAGE(@"pinglunrenshu");
    [self addSubview:commentIV];
    self.commentIV=commentIV;
    
    UILabel *commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(commentIV.right+WZ(5), commentIV.top, WZ(40), height)];
    commentLabel.font=Font(12);
    [self addSubview:commentLabel];
    self.commentLabel=commentLabel;
    
    UIImageView *zuiIV=[[UIImageView alloc]initWithFrame:CGRectMake(commentLabel.right+WZ(10), WZ(7.5), height, height)];
    zuiIV.contentMode = UIViewContentModeScaleAspectFit;
    zuiIV.image=IMAGE(@"pinglunrenshu");
    [self addSubview:zuiIV];
    self.zuiIV=zuiIV;
    
    UILabel *zuiLabel=[[UILabel alloc]initWithFrame:CGRectMake(zuiIV.right+WZ(5), zuiIV.top, WZ(40), height)];
    zuiLabel.font=Font(12);
   
    [self addSubview:zuiLabel];
    self.zuiLabel=zuiLabel;
    
    UIButton *zuiBtn=[[UIButton alloc]initWithFrame:CGRectMake(zuiIV.left, zuiIV.top, zuiLabel.right-zuiIV.left, height)];
     zuiIV.image=IMAGE(@"zuichun");
    
    [self addSubview:zuiBtn];
    self.zuiBtn=zuiBtn;
//    zuiBtn.backgroundColor=COLOR_CYAN;
    
    
    
    
    
}
-(UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.commentIV.frame), CGRectGetMinY(self.commentIV.frame), CGRectGetMaxX(self.commentLabel.frame)-CGRectGetMinX(self.commentIV.frame), CGRectGetHeight(self.commentLabel.frame))];
    }
    
    NSLog(@"commentBtn===%@",NSStringFromCGRect(_commentBtn.frame));
    //_commentBtn.backgroundColor = [UIColor redColor];
    [self addSubview:_commentBtn];
    return _commentBtn;
}
















@end

@implementation ArticlePraiseLabel

@synthesize cellRow;

@end
