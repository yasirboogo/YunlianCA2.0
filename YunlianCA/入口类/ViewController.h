//
//  ViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface ViewController : UIViewController
{
    
}

//@property(nonatomic,strong)UIView *selfView;
/**
 *  用户当前所在维度
 */
@property(nonatomic,assign)CGFloat latitude;
/**
 *  用户当前所在经度
 */
@property(nonatomic,assign)CGFloat longitude;
///**
// *  用户当前所在城市
// */
//@property(nonatomic,strong)NSString *city;
/**
 *  网络监测
 */
@property(nonatomic,strong)UIView *netStatusBar;


/**
 *  横着的线
 *
 *  @param frame 横线的frame
 *
 *  @return 横线
 */
-(UIView*)lineViewWithFrame:(CGRect)frame;
/**
 *  横着的线
 *
 *  @param frame 横线的frame
 *
 *  @return 横线
 */
+(UIView*)lineViewWithFrame:(CGRect)frame;
/**
 *  竖着的线
 *
 *  @param frame 竖线的frame
 *
 *  @return 横线
 */
-(UIView *)shuXianWithFrame:(CGRect)frame;
/**
 *  自适应高度的label 忽略frame的宽和高
 *
 *  @param frame     label的frame
 *  @param labelSize label上字符串的size
 *  @param text      label上的字符串
 *  @param textColor label上字符串颜色
 *  @param bgColor   label背景色
 *  @param font      label字体大小
 *  @param alignment label上文字对齐方式
 *
 *  @return 自适应高度的label
 */
-(UILabel *)labelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;
/**
 *  自适应高度的label 忽略frame的宽 高固定
 *
 *  @param frame     label的frame
 *  @param labelSize label上字符串的size
 *  @param text      label上的字符串
 *  @param textColor label上字符串颜色
 *  @param bgColor   label背景色
 *  @param font      label字体大小
 *  @param alignment label上文字对齐方式
 *
 *  @return 自适应高度的label
 */
-(UILabel *)aLabelWithFrame:(CGRect)frame labelSize:(CGSize)labelSize text:(NSString *)text textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;
/**
 *  正则判断手机号码格式
 *
 *  @param mobile 手机号码
 *
 *  @return 手机号码是否正确
 */
+(BOOL)validateMobile:(NSString *)mobile;
/**
 *  判断邮箱格式
 *
 *  @param email 邮箱
 *
 *  @return 邮箱格式是否正确
 */
+(BOOL)validateEmail:(NSString *)email;
/**
 *  判断银行卡号
 *
 *  @param bankCardNumber 银行卡号
 *
 *  @return 银行卡号是否正确
 */
+(BOOL)validateBankCardNumber:(NSString*)bankCardNumber;
/**
 *  判断身份证号
 *
 *  @param identityCard 身份证号
 *
 *  @return 身份证号是否正确
 */
+(BOOL)validateIdentityCard:(NSString *)identityCard;
/**
 *  车牌号验证
 *
 *  @param carNum 车牌号
 *
 *  @return 车牌号是否正确
 */
+(BOOL)validateCarNum:(NSString *)carNum;
/**
 *  判断车型
 *
 *  @param carType 车型
 *
 *  @return 车型是否正确
 */
+(BOOL)validateCarType:(NSString *)carType;
/**
 *  判断用户名
 *
 *  @param userName 用户名
 *
 *  @return 用户名是否符合规则
 */
+(BOOL)validateUserName:(NSString *)userName;
/**
 *  判断密码
 *
 *  @param passWord 密码
 *
 *  @return 密码是否符合规则
 */
+(BOOL)validatePassword:(NSString *)passWord;
/**
 *  判断昵称
 *
 *  @param nickname 昵称
 *
 *  @return 昵称是否符合规则
 */
+(BOOL)validateNickname:(NSString *)nickname;
/**
 *  字符串MD5加密
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)md5:(NSString *)string;
/**
 *  获取手机型号
 *
 *  @return 手机型号
 */
+(NSString*)getPhoneModel;
/**
 *  获取屏幕分辨率
 *
 *  @return 屏幕分辨率
 */
+(NSString*)getScreenResolution;
/**
  *  根据生日计算星座
  *
  *  @param month 月份
  *  @param day   日期
  *
  *  @return 星座名称
  */
+(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;
/**
 *  计算字符串的size
 *
 *  @param string  字符串内容
 *  @param font    字体大小
 *  @param maxSize 内容所允许的最大大小
 *
 *  @return 字符串大小
 */
+(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;
/**
 *  处理发布时间
 *
 *  @param timeStr 传进去一个时间
 *
 *  @return 返回处理后的时间
 */
+ (NSString *)getTimeWithTimeString:(NSString *)timeStr;
/**
 *  左右两根线 中间有内容的view
 *
 *  @param frame       view的位置
 *  @param labelString 中间内容
 *  @param font        字体大小
 *  @param color       view的背景
 *
 *  @return 返回一个view
 */
+(UIView*)lineLabelviewWithFrame:(CGRect)frame labelString:(NSString*)labelString font:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;
/**
 *  图片浏览器
 *
 *  @param images     图片路径或者图片数组
 *  @param photoIndex 选择放大的图片索引
 */
+(void)photoBrowserWithImages:(NSArray*)images photoIndex:(NSInteger)photoIndex;
/**
 *  提示框
 *
 *  @param view   提示框所加在的view
 *  @param title  提示框标题
 *  @param detail 提示框子标题
 *
 *  @return 返回一个提示框
 */
-(MBProgressHUD*)MBProgressHUDAddToView:(UIView*)view title:(NSString*)title detail:(NSString*)detail;
/**
 *  监测网络连接
 */
-(void)startMonitorNewWorkWithTarget:(ViewController *)trage;
/**
 *  shareSDK第三方分享
 *
 *  @param imageUrlArray 图片URL数组
 *  @param title         分享标题
 *  @param content       分享内容
 *  @param url           点击分享内容跳转到的URL
 */
//-(void)shareWithImageUrlArray:(NSArray*)imageUrlArray title:(NSString*)title content:(NSString*)content url:(NSString*)url;
/**
 *  计算单个文件大小
 *
 *  @param path 传进去一个文件路径
 *
 *  @return 返回文件大小（Mb）
 */
+(CGFloat)fileSizeAtPath:(NSString *)path;
/**
 *  计算文件夹大小
 *
 *  @param path 传进去一个文件夹路径
 *
 *  @return 返回文件夹大小（Mb）
 */
+(CGFloat)folderSizeAtPath:(NSString *)path;
/**
 *  清理缓存
 *  @param path 传进去一个文件夹路径
 */
+(void)clearCache:(NSString *)path;
/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
+ (BOOL)isBetweenFromHour:(NSInteger)fromHour FromMinute:(NSInteger)fromMin toHour:(NSInteger)toHour toMinute:(NSInteger)toMin;
/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute;
/**
 *  是否注册时候的片区
 *
 *  @return 是否注册时候的片区
 */
+(BOOL)ifRegisterArea;














//创建键盘下去按钮
-(UIView *)creatDoneView;
-(void)topUpTFDonBtnClicked;













@end

