//
//  User.h
//  YunlianCA
//
//  Created by QinJun on 16/6/29.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+(User*)user;

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
@property(nonatomic,copy)NSString *age;
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
 *  返回状态 ok error
 */
@property(nonatomic,strong)NSString *result;
/**
 *  用户地址
 */
@property(nonatomic,strong)NSString *address;
/**
 *  片区id
 */
@property(nonatomic,strong)NSString *areaId;
/**
 *  推荐码
 */
@property(nonatomic,strong)NSString *code;
/**
 *  注册时间
 */
@property(nonatomic,strong)NSString *createTime;
/**
 *  说明
 */
@property(nonatomic,strong)NSString *explain;
/**
 *  用户名
 */
@property(nonatomic,strong)NSString *username;
/**
 *
 */
@property(nonatomic,strong)NSString *mark;
/**
 *  上级ID 推荐人id
 */
@property(nonatomic,strong)NSString *supId;
/**
 *  类型
 */
@property(nonatomic,strong)NSString *type;
/**
 *  融云token
 */
@property(nonatomic,strong)NSString *token;
/**
 *  小区id
 */
@property(nonatomic,strong)NSString *xqId;
/**
 *  错误信息
 */
@property(nonatomic,strong)NSString *error;
/**
 *  佣金
 */
@property(nonatomic,strong)NSString *brokerage;
/**
 *  用户账户余额
 */
@property(nonatomic,strong)NSString *userMoney;
/**
 *  片区名
 */
@property(nonatomic,strong)NSString *areaName;
/**
 *  小区名
 */
@property(nonatomic,strong)NSString *smaAreaName;
/**
 *  是否是注册商户
 */
@property(nonatomic,strong)NSString *isMerchant;
/**
 *  云联token
 */
@property(nonatomic,strong)NSString *ylToken;
/**
 *  推荐码
 */
@property(nonatomic,strong)NSString *ylCardNo;
/**
 *  支付密码
 */
@property(nonatomic,strong)NSString *ylPayPass;
/**
 *  云联账号创建时间
 */
@property(nonatomic,strong)NSString *ylTime;
/**
 *  商户ID
 */
@property(nonatomic,strong)NSString *merchantId;
/**
 *  错误信息
 */
@property(nonatomic,strong)NSString *msg;
/**
 *  是否第一次第三方登录
 */
@property(nonatomic,strong)NSString *status;
/**
 *  是否开启推送 0是开启 1是关闭
 */
@property(nonatomic,strong)NSString *isPush;
/**
 *  商户ID
 */
//@property(nonatomic,strong)NSString *merId;
/**
 *  账号是否存在 1是后台和云联惠都存在，直接登录 2是云联惠存在，后台不存在，跳到注册界面，需要支付密码确认 3是云联惠和后台都不存在，跳到注册界面，新注册
 */
@property(nonatomic,strong)NSString *state;
/**
 *  用户vip等级
 */
@property(nonatomic,strong)NSString *vipName;
/**
 *  修改小区审核状态 1审核中 0已审核
 */
@property(nonatomic,strong)NSString *isChangeArea;
/**
 *  申请修改的片区名
 */
@property(nonatomic,strong)NSString *changeAreaName;
/**
 *  申请修改的小区名
 */
@property(nonatomic,strong)NSString *changeXqName;
/**
 *  推荐人手机号
 */
@property(nonatomic,strong)NSString *referrer;















@end
