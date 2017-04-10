//
//  Model.h
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

+ (id)model;
+ (id)modelWithDictionary:(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  手机号码
 */
@property(nonatomic,copy)NSString *mobile;
/**
 *  昵称
 */
@property(nonatomic,copy)NSString *nickname;
/**
 *  验证码
 */
@property(nonatomic,copy)NSString *randCode;
/**
 *  密码
 */
@property(nonatomic,copy)NSString *password;
/**
 *  用户ID
 */
@property(nonatomic,copy)NSString *userId;
/**
 *  性别
 */
@property(nonatomic,copy)NSString *sex;
/**
 *  个性签名
 */
@property(nonatomic,copy)NSString *sign;
/**
 *  收货地址
 */
@property(nonatomic,copy)NSString *acceptAddress;
/**
 *  经度
 */
@property(nonatomic,copy)NSString *longitude;
/**
 *  纬度
 */
@property(nonatomic,copy)NSString *latitude;
/**
 *  头像
 */
@property(nonatomic,copy)NSString *headImage;
/**
 *  返回状态
 */
@property(nonatomic,copy)NSString *result;
/**
 *  广告列表
 */
@property(nonatomic,strong)NSArray *adListArray;
/**
 *  页数
 */
@property(nonatomic,copy)NSString *pageNum;
/**
 *  每页几张
 */
@property(nonatomic,copy)NSString *pageSize;
/**
 *  总个数
 */
@property(nonatomic,copy)NSString *totalItems;
/**
 *  总页数
 */
@property(nonatomic,copy)NSString *totalPages;
/**
 *  错误信息
 */
@property(nonatomic,copy)NSString *error;
/**
 *  是否门店 1不是 0是
 */
@property(nonatomic,copy)NSString *status;
/**
 *  有几个子模块
 */
@property(nonatomic,copy)NSString *lowercount;
/**
 *  主页大类下面的子模块数组
 */
@property(nonatomic,strong)NSMutableArray *smallModuleArray;
/**
 *  子模块下的文章列表数组
 */
@property(nonatomic,strong)NSMutableArray *articleListArray;
/**
 *  收货地址列表数组
 */
@property(nonatomic,strong)NSMutableArray *shippingAddressArray;
///**
// *  银行卡列表
// */
//@property(nonatomic,strong)NSMutableArray *bankListArray;





















@end
