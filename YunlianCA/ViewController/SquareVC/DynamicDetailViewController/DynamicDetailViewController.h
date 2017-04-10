//
//  DynamicDetailViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/27.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

@interface DynamicDetailViewController : ViewController

//@property(nonatomic,strong)NSDictionary *articleDict;
@property(nonatomic,strong)NSString *articleId;
@property(nonatomic,strong)NSString *iscollect;
@property(nonatomic,assign)BOOL isLinLiVC;



@end

@interface DynDetailImageBtn : UIButton

@property(nonatomic,strong)NSArray *imageBtnArray;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
