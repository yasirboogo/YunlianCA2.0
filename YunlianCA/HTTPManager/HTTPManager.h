//
//  HTTPManager.h
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Model.h"
#import "StoreModel.h"
#import "ArticleModel.h"
#import "OrderModel.h"


@interface HTTPManager : NSObject


/**
 *  获取验证码 type:register（注册） forgetPSW（忘记密码）
 */
+(void)getVerifyCodeWithName:(NSString*)name type:(NSString*)type complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  注册 选择省份和城市
 */
+(void)chooseCityWithParentId:(NSString*)parentId complete:(void(^)(NSMutableArray *array))complete;
/**
 *  注册 选择片区
 */
+(void)chooseAreaWithParentId:(NSString*)parentId complete:(void(^)(NSMutableArray *array))complete;

/**
 *  注册 选择小区
 */
+(void)chooseCommunityWithParentId:(NSString*)parentId complete:(void(^)(NSMutableArray *array))complete;
/**
 *  提交注册
 */
+(void)registerWithName:(NSString*)name password:(NSString*)password ylPayPass:(NSString*)ylPayPass areaId:(NSString*)areaId inviteCode:(NSString*)inviteCode provinceId:(NSString*)provinceId cityId:(NSString*)cityId qyId:(NSString*)qyId xqId:(NSString*)xqId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  登录
 */
+(void)loginWithName:(NSString*)name password:(NSString*)password complete:(void(^)(User *user))complete;
/**
 *  社区广场数据
 */
+(void)getSquareDataWithUserId:(NSString*)userId areaId:(NSString*)areaId complete:(void(^)(NSMutableArray *mutableArray))complete;
/**
 *  帖子列表里的广告
 */
+(void)getAdWithModuleId:(NSString*)moduleId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(Model *model))complete;
/**
 *  帖子列表文章列表 pxType：Zxfb（最新发布）,zjhf（最近回复）,jqzr（近期最热）,qwzr（全网最热）
 */
+(void)getArticleListWithUserId:(NSString*)userId moduleId:(NSString*)moduleId pxType:(NSString*)pxType pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize areaId:(NSString*)areaId keyword:(NSString*)keyword complete:(void(^)(Model *model))complete;
/**
 *  发布帖子
 */
+(void)addArticleWithCreateUserId:(NSString*)createUserId moduleId:(NSString*)moduleId areaId:(NSString*)areaId title:(NSString*)title content:(NSString*)content imgSet:(NSArray*)imgSet complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  添加评论
 */
+(void)addCommentWithUserId:(NSString*)userId userName:(NSString*)userName payInfoId:(NSString*)payInfoId objectId:(NSString*)objectId parentId:(NSString*)parentId type:(NSString*)type storeId:(NSString*)storeId content:(NSString*)content star:(NSString*)star imageArray:(NSArray*)imageArray complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  添加点赞
 */
+(void)addPraiseWithUserId:(NSString*)userId type:(NSString*)type objectId:(NSString*)objectId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取评论
 */
+(void)getCommentWithUserId:(NSString*)userId objectId:(NSString*)objectId type:(NSString*)type storeId:(NSString*)storeId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize pxType:(NSString*)pxType complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  商铺列表 pxType：moduleList为空才传递
 */
+(void)getStoreListWithModuleId:(NSString*)moduleId areaId:(NSString*)areaId lng:(NSString*)lng lat:(NSString*)lat pxType:(NSString*)pxType pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize keyword:(NSString*)keyword complete:(void(^)(StoreModel *model))complete;
/**
 *  商铺详情
 */
+(void)getStoreDetailInfoWithUserId:(NSString*)userId storeId:(NSString*)storeId complete:(void(^)(StoreModel *model))complete;
/**
 *  商铺详情里的商品列表
 */
+(void)getGoodsInStoreDetailInfoWithStoreId:(NSString*)storeId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(StoreModel *model))complete;
/**
 *  商品详细信息
 */
+(void)getGoodsDetailInfoWithUserId:(NSString*)userId goodsId:(NSString*)goodsId complete:(void(^)(StoreModel *model))complete;
/**
 *  添加店铺里的获取一级分类
 */
+(void)getFirstCategoryForAddStore:(void(^)(StoreModel *model))complete;
/**
 *  添加店铺里的获取二级分类
 */
+(void)getSecondCategoryForAddStoreWithPatentId:(NSString*)parentId complete:(void(^)(StoreModel *model))complete;
/**
 *  添加店铺
 */
+(void)addStoreWithName:(NSString*)name explain:(NSString*)explain address:(NSString*)address longitude:(NSString*)longitude latitude:(NSString*)latitude userName:(NSString*)userName mobile:(NSString*)mobile opentime:(NSString*)opentime userId:(NSString*)userId areaId:(NSString*)areaId moduleId:(NSString*)moduleId headImg:(NSData*)headImg imgs:(NSMutableArray*)imgs merchantId:(NSString*)merchantId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除店铺 ids为店铺id 多个店铺id之间用,隔开
 */
+(void)deleteStoreWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  添加商品
 */
+(void)addGoodsInStoreWithName:(NSString*)name explain:(NSString*)explain price:(NSString*)price priceZH:(NSString*)priceZH repertory:(NSString*)repertory storeId:(NSString*)storeId imgs:(NSMutableArray*)imgs complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除店铺商品 多个对象id用,隔开
 */
+(void)deleteGoodsWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  发送添加好友请求
 */
+(void)addFriendRequestWithUserId:(NSString*)userId toUserId:(NSString*)toUserId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  是否同意对方的添加好友请求 status:1 同意 0 删除
 */
+(void)ifAgreeAddFriendWithUserId:(NSString*)userId toUserId:(NSString*)toUserId status:(NSString*)status complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  我的好友列表
 */
+(void)getMyFriendsListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  想要加我为好友的人
 */
+(void)getUserMakeMeFriendWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  搜索好友
 */
+(void)searchFriendsWithUserId:(NSString*)userId keyWord:(NSString*)keyWord pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSMutableArray *array))complete;
/**
 *  好友推荐
 */
+(void)recomendFriendsWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  周边服务
 */
+(void)surroundingService:(void(^)(NSMutableArray *bigClassArray))complete;
/**
 *  周边服务 门店列表(快递类)
 */
+(void)surroundingServiceForStoreListWithModuleId:(NSString*)moduleId areaId:(NSString*)areaId lng:(NSString*)lng lat:(NSString*)lat pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;






/**
 *  商户添加优惠券 type:1商家 0平台
 */
+(void)storeAddCouponWithMoney:(NSString*)money minMoney:(NSString*)minMoney type:(NSString*)type storeId:(NSString*)storeId yxETimeStr:(NSString*)yxETimeStr yxSTimeStr:(NSString*)yxSTimeStr amount:(NSString*)amount  kqSTimeStr:(NSString*)kqSTimeStr complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  商户优惠券列表
 */
+(void)getStoreCouponListWithStoreId:(NSString*)storeId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(StoreModel *storeModel))complete;
/**
 *  用户领取优惠券
 */
+(void)getCouponFromStoreWithUserId:(NSString*)userId couponId:(NSString*)couponId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  用户优惠券列表
 */
+(void)getUserCouponListWithUserId:(NSString*)userId type:(NSString*)type pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize amount:(NSString*)amount storeId:(NSString*)storeId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  添加修改收货地址
 */
+(void)addOrEditShippingAddressWidhUserId:(NSString*)userId userName:(NSString*)userName userPhone:(NSString*)userPhone city:(NSString*)city address:(NSString*)address addressId:(NSString*)addressId status:(NSString*)status complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  收货地址列表
 */
+(void)getShippingAddressListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(Model *model))complete;
/**
 *  收货地址详情
 */
+(void)getShippingAddressDetailInfoWithAddressId:(NSString*)addressId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除收货地址
 */
+(void)deleteShippingAddressWithAddressId:(NSString*)addressId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取指定用户的默认收货地址
 */
+(void)getUserDefaultShippingAddressWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  绑定提现银行卡（添加、修改）
 */
+(void)bindBankCardWithBankName:(NSString*)bankName cardNumber:(NSString*)cardNumber bankCity:(NSString*)bankCity subBranch:(NSString*)subBranch khUserName:(NSString*)khUserName phone:(NSString*)phone idCard:(NSString*)idCard userId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取银行名
 */
+(void)getBankName:(void(^)(NSMutableArray *mutableArray))complete;
/**
 *  获取已绑定银行卡列表
 */
+(void)getBindBankCardListWithUserId:(NSString*)userId complete:(void(^)(NSMutableArray *mutableArray))complete;
/**
 *  获取开户银行列表
 */
+(void)getOpeningBankList:(void(^)(NSMutableArray *mutableArray))complete;
/**
 *  获取用户信息
 */
+(void)getUserInfoWithUserId:(NSString*)userId complete:(void(^)(User *user))complete;
/**
 *  修改用户信息
 */
+(void)updateUserInfoWithUserId:(NSString*)userId nickname:(NSString*)nickname sex:(NSString*)sex age:(NSString*)age address:(NSString*)address sign:(NSString*)sign img:(NSData*)img complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  充值记录
 */
+(void)getPayRecordWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  佣金提现记录
 */
+(void)commissionWithdrawRecordWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  佣金提现
 */
+(void)commissionWithdrawWithUserId:(NSString*)userId money:(NSString*)money bankUserName:(NSString*)bankUserName bankCode:(NSString*)bankCode bankName:(NSString*)bankName bankCity:(NSString*)bankCity subBranch:(NSString*)subBranch complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  我的发文列表
 */
+(void)getMyArticleListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(ArticleModel *model))complete;
/**
 *  我的信息、提醒 邻居界面系统消息、评论和赞的消息
 */
+(void)getMyMessageOrAlertWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  我的信息 系统消息、评论和赞点进去的详细信息 0 系统信息 1 评论信息 2 点赞信息
 */
+(void)getMyMessageOrAlertWithUserId:(NSString*)userId type:(NSString*)type pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取用户的签到记录
 */
+(void)getSignInRecordWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  创建订单 orderData是json字符串
 */
+(void)addOrderWithOrderData:(NSString*)orderData complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  订单列表(用户)
 */
+(void)getOrderListOfUserWithUserId:(NSString*)userId status:(NSString*)status pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(OrderModel *model))complete;
/**
 *  订单列表(商家)
 */
+(void)getOrderListOfStoreWithUserId:(NSString*)userId status:(NSString*)status pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(OrderModel *model))complete;
/**
 *  订单详情
 */
+(void)getOrderDetailWithOrderId:(NSString*)orderId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取我的店铺列表
 */
+(void)getMyStoreWithUserId:(NSString*)userId complete:(void(^)(StoreModel *storeModel))complete;
/**
 *  获取用户收藏列表 type：1文章，2商品，3店铺
 */
+(void)getUserCollectionListWithUserId:(NSString*)userId type:(NSString*)type pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  添加收藏 objectid:收藏对象id（文章id，商品id，店铺id）
 */
+(void)addUserCollectionWithUserId:(NSString*)userId type:(NSString*)type objectid:(NSString*)objectid complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除收藏内容 包括帖子商品店铺 多个对象id用,隔开
 */
+(void)deleteCollectionWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除我的帖子 多个对象id用,隔开
 */
+(void)deleteArticlesWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  帖子详情
 */
+(void)getArticleDetailInfoWithUserId:(NSString*)userId articleId:(NSString*)articleId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取VIP信息集合
 */
+(void)getVIPListWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  购买VIP
 */
+(void)buyVIPWithUserId:(NSString*)userId usergradeId:(NSString*)usergradeId password:(NSString*)password complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  我的会员
 */
+(void)myMemberCenterWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  创建群
 */
+(void)createGroupWithIds:(NSString*)ids groupName:(NSString*)groupName logoImg:(NSData*)logoImg groupDes:(NSString*)groupDes complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  加入群
 */
+(void)joinGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId groupName:(NSString*)groupName complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  退出群
 */
+(void)exitGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  解散群
 */
+(void)deleteGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  举报群
 */
+(void)reportGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId cause:(NSString*)cause complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  我的佣金
 */
+(void)myBrokerageWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  群组信息
 */
+(void)groupInfoWithUserId:(NSString*)userId groupId:(NSString*)groupId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  发现群
 */
+(void)findGroupWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  选择群
 */
+(void)chooseGroupWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除订单
 */
+(void)deleteOrderWithOrderId:(NSString*)orderId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  退货
 */
+(void)refundWithOrderId:(NSString*)orderId refundDes:(NSString*)refundDes complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  我的邻居
 */
+(void)myNeighborWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  账户余额
 */
+(void)accountBalanceWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除银行卡
 */
+(void)deleteBindingBankCardWithBankCardId:(NSString*)bankCardId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  确认发货
 */
+(void)confirmSendOutWithPayInfoId:(NSString*)payInfoId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  确认收货
 */
+(void)confirmReceivingWithPayInfoId:(NSString*)payInfoId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  支付宝/微信/银联充值 payType:1、微信 2、支付宝 3、银行卡 4、佣金 5、快钱 backType:充值模式id
 */
+(void)rechargeWithUserId:(NSString*)userId money:(NSString*)money payType:(NSString*)payType backType:(NSString*)backType password:(NSString*)password complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取退货订单中的商品总额和应退款项
 */
+(void)getOrderMoneyWithPayInfoId:(NSString*)payInfoId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  注册商户
 */
+(void)registerStoreWithUserId:(NSString*)userId registerDict:(NSMutableDictionary*)registerDict complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  用户收入明细
 */
+(void)getIncomeRecordsWithUserId:(NSString*)userId pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  用户提现明细
 */
+(void)getWithdrawRecordsWithUserId:(NSString*)userId pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  支付订单
 */
+(void)payOrderWithPayInfoId:(NSString*)payInfoId ymlPayPass:(NSString*)ymlPayPass complete:(void(^)(NSDictionary *resultDict))complete;
///**
// *  分享帖子
// */
//+(void)shareArticleWithArticleId:(NSString*)articleId complete:(void(^)(NSDictionary *resultDict))complete;
///**
// *  分享商品
// */
//+(void)shareGoodsWithGoodsId:(NSString*)goodsId complete:(void(^)(NSDictionary *resultDict))complete;
///**
// *  分享店铺
// */
//+(void)shareStoreWithStoreId:(NSString*)storeId complete:(void(^)(NSDictionary *resultDict))complete;

/**
 *  判断是否是第一次第三方登录
 */
+(void)ifFirstThirdLoginWithName:(NSString*)name complete:(void(^)(User *user))complete;
/**
 *  首次第三方登录请求
 */
+(void)firstThirdLoginWithNickname:(NSString*)nickname name:(NSString*)name img:(NSString*)img areaId:(NSString*)areaId xqId:(NSString*)xqId phone:(NSString*)phone payPassword:(NSString*)payPassword complete:(void(^)(User *user))complete;
/**
 *  扫描二维码获取推荐码成为对方会员
 */
//+(void)
/**
 *  反馈意见
 */
+(void)addSuggestionWithUserId:(NSString*)userId content:(NSString*)content complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  申请开放社区
 */
+(void)applyAreaWithUserId:(NSString*)userId content:(NSString*)content complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  扫码成为会员
 */
+(void)becomeMemberWithUserId:(NSString*)userId code:(NSString*)code complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取广告详情
 */
+(void)getAdDetailWithAdid:(NSString*)adId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  添加打电话次数
 */
+(void)addCallNumberWithStoreId:(NSString*)storeId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  开启关闭远程推送
 */
+(void)ifReceiveRemoteNotificationsWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  忘记密码
 */
+(void)forgotPswWithName:(NSString*)name password:(NSString*)password complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  充值模式
 */
+(void)rechargeModeWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  删除系统消息、评论消息、点赞消息
 */
+(void)deleteMessageWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  判断商户是否存在
 */
+(void)ifMerchantExistWithUserId:(NSString*)userId phone:(NSString*)phone complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  判断用户是否存在
 */
+(void)ifUserExistWithPhone:(NSString*)phone complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  判断用户支付密码是否存在 第三方登录state为1的情况
 */
+(void)ifPayPassword01ExistWithPassword:(NSString*)password phone:(NSString*)phone token:(NSString*)token complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  判断用户支付密码是否存在 第三方登录state为2的情况
 */
+(void)ifPayPassword02ExistWithPassword:(NSString*)password phone:(NSString*)phone token:(NSString*)token complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  判断当前用户是否已添加商户 isMerchant:0 无审核 1审核中 2审核通过 3审核不通过
 */
+(void)ifAddStoreWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  修改支付密码
 */
+(void)changePayPasswordWithUserId:(NSString*)userId oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  修改用户注册小区
 */
+(void)changeUserCommunityWithUserId:(NSString*)userId areaId:(NSString*)areaId xqId:(NSString*)xqId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  发帖界面获取栏目
 */
+(void)getLanmuDataWithFatherId:(NSString*)fatherId WithUrl:(NSString *)url complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  佣金明细
 */
+(void)getYongJinRecordsWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  小红点更新
 */
+(void)hongdianWithUserId:(NSString*)userId moduleId:(NSString*)moduleId areaId:(NSString*)areaId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取付款码
 */
+(void)getPayQRCodeWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  扫码付款
 */
+(void)scanQRCodePayWithUserId:(NSString*)userId merId:(NSString*)merId termId:(NSString*)termId money:(NSString*)money sfMoney:(NSString*)sfMoney ymlPayPass:(NSString*)ymlPayPass complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取商户名
 */
+(void)getStoreNameWithMerId:(NSString*)merId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  根据商户号(支付系统商户id)获取商户优惠
 */
+(void)getMerStoreDiscountWithUserId:(NSString*)userId merId:(NSString*)merId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  根据本地商户id获取商户优惠
 */
+(void)getMerStoreDiscountWithMerId:(NSString*)merId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取支付端商户资料
 */
+(void)getMerStoreInfoWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  修改支付端商户资料
 */
+(void)changeMerStoreInfoWithUserId:(NSString*)userId changeDict:(NSMutableDictionary*)changeDict complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取支付端用户资料
 */
+(void)getMerUserInfoWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  修改支付端用户资料
 */
+(void)changeMerUserInfoWithUserId:(NSString*)userId phone:(NSString*)phone email:(NSString*)email name:(NSString*)name  personType:(NSString*)personType personId:(NSString*)personId sex:(NSString*)sex birthday:(NSString*)birthday areaId:(NSString*)areaId address:(NSString*)address tjPhone:(NSString*)tjPhone ylhId:(NSString*)ylhId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  商户提现
 */
+(void)getStoreMoneyWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  客服热线
 */
+(void)getHotLines:(void(^)(NSDictionary *resultDict))complete;
/**
 *  外部链接
 */
+(void)getMoreUrl:(void(^)(NSDictionary *resultDict))complete;

/**
 *  社区二期接口
 */

/**
 *  获取邻里圈文章列表
 */
+(void)getNearbySquareListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize areaId:(NSString*)areaId complete:(void(^)(Model *model))complete;
/**
 *  一对一发红包
 */
//+(void)sendRedEnvelopeOneToOneWithUserId:(NSString*)userId money:(NSString*)money toPhone:(NSString*)toPhone theme:(NSString*)theme password:(NSString*)password type:(NSString*)type complete:(void(^)(NSDictionary *resultDict))complete;
+(void)sendRedEnvelopeOneToOneWithUserId:(NSString*)userId money:(NSString*)money toPhone:(NSString*)toPhone theme:(NSString*)theme password:(NSString*)password payType:(NSString*)payType type:(NSString*)type  objId:(NSString*)objId complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  拆红包 type:1、后台发的红包 0、用户一对一发的红包
 */
+(void)openRedEnvelopeWithUserId:(NSString*)userId packetId:(NSString*)packetId type:(NSString*)type complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  获取红包列表
 */
+(void)getRedEnvelopeListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSMutableArray *listArray))complete;
/**
 *  获取后台红包详情
 */
+(void)getBackstageRedEnvelopeDetailWithUserId:(NSString *)userId redId:(NSString *)redId complete:(void (^)(NSDictionary *resultDict))complete;
/**
 *  发出的红包记录
 */
+(void)sendRedEnvelopeListUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  收到的红包记录
 */
+(void)ReceivedRedEnvelopeListUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  红包退款明细记录
 */
+(void)ReceivedRedEnvelopeRefundDetailsUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  邻里圈获取地区
 */
+(void)getAreaAddressWithUserId:(NSString *)userId complete:(void (^)(NSDictionary *resultDict))complete;
/**
 *  保存设备号
 */
+(void)uploadDeviceTokenUserId:(NSString*)userId jgCode:(NSString*)jgCode complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  判断用户支付密码是否和登录密码相同
 */
+(void)ifPayPswEqualLoginPswWithPhone:(NSString*)phone pwd:(NSString*)pwd complete:(void(^)(NSDictionary *resultDict))complete;
/**
 *  是否收到新红包
 */
+(void)ifReceiveNewRedEnvelopeWithUserId:(NSString *)userId complete:(void (^)(NSDictionary *resultDict))complete;
/**
 *  获取一对一发红包的所需参数
 */
+(void)getParameterOfRedEnvelopeWithUserId:(NSString *)userId complete:(void (^)(NSDictionary *resultDict))complete;
/**
 *  验证发红包时对方手机号是否已注册
 */
+(void)ifUserMobileExistWithPhone:(NSString*)phone complete:(void(^)(NSDictionary *resultDict))complete;

/**
 *  获取红包记录、打开二次红包
 */
+(void)getRedEnvelopeListWithReqDic:(NSMutableDictionary *)reqDic WithUrl:(NSString *)url complete:(void (^)(NSDictionary *resultDict))complete;

//分享红包截图
+(void)shareRedEnvelopeImage:(UIImage*)image userId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete;


@end
