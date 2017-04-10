//
//  StoreModel.h
//  YunlianCA
//
//  Created by QinJun on 16/7/7.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreModel : NSObject



/**
 *  顶部栏目数组（家家淘宝那种栏目不固定）
 */
@property(nonatomic,strong)NSMutableArray *moduleListArray;
/**
 *  顶部栏目数组(云超市那种栏目固定)
 */
@property(nonatomic,strong)NSMutableArray *moduleList1Array;
/**
 *  每个栏目下的店铺列表
 */
@property(nonatomic,strong)NSMutableArray *storeListArray;
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
 *  店铺地址
 */
@property(nonatomic,strong)NSString *address;
/**
 *  片区id
 */
@property(nonatomic,strong)NSString *areaId;
/**
 *  被拨打电话次数
 */
@property(nonatomic,strong)NSString *callNum;
/**
 *  店铺创建时间
 */
@property(nonatomic,strong)NSString *storeCreateTime;
/**
 *  店铺说明
 */
@property(nonatomic,strong)NSString *storeExplains;
/**
 *  店铺头像
 */
@property(nonatomic,strong)NSString *headImg;
/**
 *  店铺好评
 */
@property(nonatomic,strong)NSString *hpNum;
/**
 *  店铺id
 */
@property(nonatomic,strong)NSString *storeId;
/**
 *  店铺图片展示路径
 */
@property(nonatomic,strong)NSString *storeImageUrl;
/**
 *  店铺所在维度
 */
@property(nonatomic,strong)NSString *latitude;
/**
 *  店铺所在经度
 */
@property(nonatomic,strong)NSString *longitude;
/**
 *  店铺联系电话
 */
@property(nonatomic,strong)NSString *mobile;
/**
 *  模块id
 */
@property(nonatomic,strong)NSString *moduleId;
/**
 *  店铺名称
 */
@property(nonatomic,strong)NSString *storeName;
/**
 *  店铺营业时间
 */
@property(nonatomic,strong)NSString *opentime;
/**
 *  店铺签名
 */
@property(nonatomic,strong)NSString *sign;
/**
 *  联系人id
 */
@property(nonatomic,strong)NSString *userId;
/**
 *  联系人
 */
@property(nonatomic,strong)NSString *username;
/**
 *  店铺商品数组
 */
@property(nonatomic,strong)NSMutableArray *goodsArray;
/**
 *  商品id
 */
@property(nonatomic,strong)NSString *goodsId;
/**
 *  商品图标
 */
@property(nonatomic,strong)NSString *goodsIcon;
/**
 *  商品展示图片
 */
//@property(nonatomic,strong)NSMutableArray *goodsImageArray;
/**
 *  商品展示图片路径
 */
@property(nonatomic,strong)NSString *goodsImageUrl;
/**
 *  商品价格
 */
@property(nonatomic,strong)NSString *price;
/**
 *  商品折后价
 */
@property(nonatomic,strong)NSString *priceZH;
/**
 *  商品销量
 */
@property(nonatomic,strong)NSString *sales;
/**
 *  商品名称
 */
@property(nonatomic,strong)NSString *goodsName;
/**
 *  商品创建时间
 */
@property(nonatomic,strong)NSString *goodsCreateTime;
/**
 *  商品说明
 */
@property(nonatomic,strong)NSString *goodsExplains;
/**
 *  优惠券数组
 */
@property(nonatomic,strong)NSMutableArray *couponArray;
/**
 *  店铺一级栏目
 */
@property(nonatomic,strong)NSMutableArray *firstCategoryArray;
/**
 *  店铺二级栏目
 */
@property(nonatomic,strong)NSMutableArray *secondCategoryArray;
/**
 *  我的店铺列表数组
 */
@property(nonatomic,strong)NSMutableArray *myStoreArray;
/**
 *  店铺一级栏目名
 */
@property(nonatomic,strong)NSString *moduleName1;
/**
 *  店铺二级栏目名
 */
@property(nonatomic,strong)NSString *moduleName2;
/**
 *  店铺优惠券列表
 */
@property(nonatomic,strong)NSMutableArray *storeCouponArray;
/**
 *  店铺是否已删除
 */
@property(nonatomic,strong)NSString *storeIsDel;
/**
 *  店铺是否收藏
 */
@property(nonatomic,strong)NSString *storeIsCollect;
/**
 *  商品是否已删除
 */
@property(nonatomic,strong)NSString *goodsIsDel;
/**
 *  商品是否收藏
 */
@property(nonatomic,strong)NSString *goodsIsCollect;
/**
 *  注册商户ID
 */
@property(nonatomic,strong)NSString *merchantId;
/**
 *  注册商户名称
 */
@property(nonatomic,strong)NSString *merchantName;







///**
// *  优惠券数量
// */
//@property(nonatomic,strong)NSString *couponAmount;
///**
// *  优惠券已被领取数量
// */
//@property(nonatomic,strong)NSString *couponAmountYLQ;
///**
// *  优惠券创建时间
// */
//@property(nonatomic,strong)NSString *couponCreateTime;
///**
// *  优惠券id
// */
//@property(nonatomic,strong)NSString *couponId;
///**
// *  优惠券开抢时间
// */
//@property(nonatomic,strong)NSString *couponKqStartTime;
///**
// *  优惠券满多少可用
// */
//@property(nonatomic,strong)NSString *couponMinMoney;
///**
// *  优惠券面值
// */
//@property(nonatomic,strong)NSString *couponMoney;
///**
// *  优惠券类型 平台0或者商家1
// */
//@property(nonatomic,strong)NSString *couponType;
///**
// *  优惠券有效期截止时间
// */
//@property(nonatomic,strong)NSString *couponYxEndTime;
///**
// *  优惠券有效期开始时间
// */
//@property(nonatomic,strong)NSString *couponYxStartTime;








































@end
