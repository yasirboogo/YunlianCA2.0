//
//  ArticleModel.h
//  YunlianCA
//
//  Created by QinJun on 16/7/18.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject


/**
 *  返回状态
 */
@property(nonatomic,strong)NSString *result;
/**
 *  页数
 */
@property(nonatomic,strong)NSString *pageNum;
/**
 *  每页几张
 */
@property(nonatomic,strong)NSString *pageSize;
/**
 *  总个数
 */
@property(nonatomic,strong)NSString *totalItems;
/**
 *  总页数
 */
@property(nonatomic,strong)NSString *totalPages;
/**
 *  错误信息
 */
@property(nonatomic,strong)NSString *error;
/**
 *  我的文章列表
 */
@property(nonatomic,strong)NSMutableArray *articleArray;







































@end
