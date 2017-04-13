//
//  HTTPManager.m
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "HTTPManager.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@implementation HTTPManager

+(NSString *)getUrlWithString:(NSString*)string
{
    NSString *url=[NSString stringWithFormat:@"%@%@",HOST,string];
    
    return url;
}

/**
 *  获取验证码 type:register（注册） forgetPSW（忘记密码）
 */
+(void)getVerifyCodeWithName:(NSString*)name type:(NSString*)type complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/verifyCode.api"];
    NSDictionary *parameters = @{@"name":name,@"type":type};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取验证码===%@",responseObject);
        
        complete(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取验证码失败====%@",error);
    }];
}

/**
 *  注册 选择省份和城市
 */
+(void)chooseCityWithParentId:(NSString*)parentId complete:(void(^)(NSMutableArray *array))complete
{
    NSString *url=[self getUrlWithString:@"user/regAreaCity.api"];
    NSDictionary *parameters = @{@"parentId":parentId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"选择省份和城市===%@",responseObject);
        
        NSString *result=[responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"ok"])
        {
            NSArray *listArray=[responseObject objectForKey:@"list"];
            
            NSMutableArray *provinceArray=[NSMutableArray array];
            for (NSInteger i=0; i<listArray.count; i++)
            {
                NSDictionary *dict=listArray[i];
                [provinceArray addObject:dict];
            }
            
            complete(provinceArray);
        }
        else
        {
            complete(nil);
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"选择省份和城市失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  注册 选择片区
 */
+(void)chooseAreaWithParentId:(NSString*)parentId complete:(void(^)(NSMutableArray *array))complete
{
    NSString *url=[self getUrlWithString:@"user/regAreaPQ.api"];
    NSDictionary *parameters = @{@"parentId":parentId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取片区===%@",responseObject);
        
        NSString *result=[responseObject objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSArray *listArray=[responseObject objectForKey:@"list"];
            
            NSMutableArray *areaArray=[NSMutableArray array];
            for (NSInteger i=0; i<listArray.count; i++)
            {
                NSDictionary *dict=listArray[i];
                [areaArray addObject:dict];
            }
            
            complete(areaArray);
        }
        else
        {
            complete(nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取片区失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  注册 选择小区
 */
+(void)chooseCommunityWithParentId:(NSString*)parentId complete:(void(^)(NSMutableArray *array))complete
{
    NSString *url=[self getUrlWithString:@"user/regAreaXQ.api"];
    NSDictionary *parameters = @{@"parentId":parentId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取小区===%@",responseObject);
        
        NSString *result=[responseObject objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSArray *listArray=[responseObject objectForKey:@"list"];
            
            NSMutableArray *communityArray=[NSMutableArray array];
            for (NSInteger i=0; i<listArray.count; i++)
            {
                NSDictionary *dict=listArray[i];
                [communityArray addObject:dict];
            }
            
            complete(communityArray);
        }
        else
        {
            complete(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取小区失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  提交注册
 */
+(void)registerWithName:(NSString*)name password:(NSString*)password ylPayPass:(NSString*)ylPayPass areaId:(NSString*)areaId inviteCode:(NSString*)inviteCode provinceId:(NSString*)provinceId cityId:(NSString*)cityId qyId:(NSString*)qyId xqId:(NSString*)xqId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/register.api"];
//    NSDictionary *parameters = @{@"name":name,@"password":password,@"ylPayPass":ylPayPass,@"areaId":areaId,@"inviteCode":inviteCode,@"xqId":xqId,@"provinceId":provinceId,@"cityId":cityId,@"qyId":qyId};
    NSDictionary *parameters = @{@"name":name,@"password":password,@"ylPayPass":ylPayPass,@"inviteCode":inviteCode};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"注册===%@",responseObject);
        
        NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
        NSMutableDictionary *loginDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:name,@"name",password,@"password",ylPayPass,@"ylPayPass", nil];
        [loginDict writeToFile:filePath atomically:YES];
        
        complete(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"注册失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  登录
 */
+(void)loginWithName:(NSString*)name password:(NSString*)password complete:(void(^)(User *user))complete
{
    NSString *url=[self getUrlWithString:@"user/login.api"];
    NSDictionary *parameters = @{@"name":name,@"password":password};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"登录===%@",responseObject);
        
        User *user=[User user];
        user.result=[responseObject objectForKey:@"result"];
        if ([user.result isEqualToString:STATUS_SUCCESS])
        {
            user.areaName=[responseObject objectForKey:@"areaName"];
            user.smaAreaName=[responseObject objectForKey:@"smaAreaName"];
            user.isMerchant=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isMerchant"]];
            user.ylToken=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ylToken"]];
            user.state=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"state"]];
            
            NSDictionary *userDict=[responseObject objectForKey:@"user"];
            user.address=[userDict objectForKey:@"address"];
            user.areaId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"areaId"]];
            user.brokerage=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"brokerage"]];
            user.code=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"code"]];
            user.explain=[userDict objectForKey:@"explain"];
            user.headImage=[userDict objectForKey:@"headimg"];
            user.userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
            user.isPush=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"isPush"]];
            user.merchantId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"merId"]];
            user.username=[userDict objectForKey:@"name"];
            user.nickname=[userDict objectForKey:@"nickname"];
            user.acceptAddress=[userDict objectForKey:@"receiptInfoName"];
            user.sex=[userDict objectForKey:@"sex"];
            user.sign=[userDict objectForKey:@"sign"];
            user.token=[userDict objectForKey:@"token"];
            user.type=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"type"]];
            user.userMoney=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"userMoney"]];
            user.vipName=[userDict objectForKey:@"vipName"];
            user.xqId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"xqId"]];
            user.ylCardNo=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylCardNo"]];
            user.ylPayPass=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylPayPass"]];
            user.referrer=[userDict objectForKey:@"referrer"];
            
            user.password=password;
//            NSString *filePath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"loginInfo.plist"];
//            NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:filePath];
//            user.password=[dict objectForKey:@"password"];
            
            [UserInfoData saveUserInfoWithUser:user];
            
        }
        else
        {
            user.msg=[responseObject objectForKey:@"msg"];
        }
        
        complete(user);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"登录失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  社区广场数据
 */
+(void)getSquareDataWithUserId:(NSString*)userId areaId:(NSString*)areaId complete:(void(^)(NSMutableArray *mutableArray))complete
{
    NSString *url=[self getUrlWithString:@"index/indexModule.api"];
    NSDictionary *parameters = @{@"userId":userId,@"areaId":areaId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSMutableArray *moduleListArray=[responseObject objectForKey:@"moduleList"];
            
            complete(moduleListArray);
        }
        
//        NSLog(@"主页广场数据===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"无法获取主页广场数据====%@",error);
    }];
    
    
}

/**
 *  首页和帖子列表里的广告 首页moduleId传1
 */
+(void)getAdWithModuleId:(NSString*)moduleId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(Model *model))complete
{
    NSString *url=[self getUrlWithString:@"index/adList.api"];
    NSDictionary *parameters = @{@"moduleId":moduleId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Model *model=[Model model];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *adListDict=[responseObject objectForKey:@"adList"];
            model.adListArray=[[adListDict objectForKey:@"data"] mutableCopy];
            model.pageNum=[adListDict objectForKey:@"pageNum"];
            model.pageSize=[adListDict objectForKey:@"pageSize"];
            model.totalItems=[adListDict objectForKey:@"totalItems"];
            model.totalPages=[adListDict objectForKey:@"totalPages"];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
//        NSLog(@"获取广告===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取广告失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  帖子列表文章列表 pxType：Zxfb（最新发布）,zjhf（最近回复）,jqzr（近期最热）,qwzr（全网最热）
 */
+(void)getArticleListWithUserId:(NSString*)userId moduleId:(NSString*)moduleId pxType:(NSString*)pxType pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize areaId:(NSString*)areaId keyword:(NSString*)keyword complete:(void(^)(Model *model))complete
{
    NSString *url=[self getUrlWithString:@"index/findArticle.api"];
    
    NSDictionary *parameters;
    if (keyword==nil)
    {
        parameters= @{@"userId":userId,@"moduleId":moduleId,@"pageNum":pageNum,@"pageSize":pageSize,@"pxType":pxType,@"areaId":areaId};
    }
    else
    {
        parameters= @{@"userId":userId,@"moduleId":moduleId,@"pageNum":pageNum,@"pageSize":pageSize,@"pxType":pxType,@"areaId":areaId,@"keyWord":keyword};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Model *model=[Model model];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *articleListDict=[responseObject objectForKey:@"articleList"];
            model.articleListArray=[[articleListDict objectForKey:@"data"] mutableCopy];
            model.pageNum=[articleListDict objectForKey:@"pageNum"];
            model.pageSize=[articleListDict objectForKey:@"pageSize"];
            model.totalItems=[articleListDict objectForKey:@"totalItems"];
            model.totalPages=[articleListDict objectForKey:@"totalPages"];
            model.smallModuleArray=[[responseObject objectForKey:@"moduleList"] mutableCopy];
            
            complete(model);
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
            complete(model);
        }
        
        if (keyword==nil)
        {
            NSLog(@"获取文章列表===%@",responseObject);
        }
        else
        {
            NSLog(@"搜索帖子列表===%@",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取文章列表失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  发布帖子
 */
+(void)addArticleWithCreateUserId:(NSString*)createUserId moduleId:(NSString*)moduleId areaId:(NSString*)areaId title:(NSString*)title content:(NSString*)content imgSet:(NSArray*)imgSet complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/addArticle.api"];
    
    NSDictionary *parameters = @{@"createuser":createUserId,@"moduleId":moduleId,@"areaId":areaId,@"title":title,@"content":content};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 1) 取当前系统时间
        NSDate *date = [NSDate date];
        // 2) 使用日期格式化工具
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 3) 指定日期格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        for (NSInteger i=0; i<imgSet.count; i++)
        {
            UIImage *image=imgSet[i];
            NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
            // 4) 使用系统时间生成一个文件名
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", dateStr,i + 1];
            [formData appendPartWithFileData:imageData name:@"imgSet" fileName:fileName mimeType:@"image/png/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        NSLog(@"发布帖子===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发布帖子失败===%@",error.localizedDescription);
    }];
    
    
}

/**
 *  添加评论
 */
+(void)addCommentWithUserId:(NSString*)userId userName:(NSString*)userName payInfoId:(NSString*)payInfoId objectId:(NSString*)objectId parentId:(NSString*)parentId type:(NSString*)type storeId:(NSString*)storeId content:(NSString*)content star:(NSString*)star imageArray:(NSArray*)imageArray complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"comment/saveComment.api"];
    
    NSDictionary *parameters = @{@"content":content,@"userName":userName,@"payInfoId":payInfoId,@"star":star,@"objectid":objectId,@"parentId":parentId,@"userId":userId,@"type":type,@"storeId":storeId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 1) 取当前系统时间
        NSDate *date = [NSDate date];
        // 2) 使用日期格式化工具
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 3) 指定日期格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        if (imageArray!=nil && imageArray.count>0)
        {
            for (NSInteger i=0; i<imageArray.count; i++)
            {
                UIImage *image=imageArray[i];
                NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
                // 4) 使用系统时间生成一个文件名
                NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", dateStr,i + 1];
                [formData appendPartWithFileData:imageData name:@"imgs" fileName:fileName mimeType:@"image/png/jpg"];
            }
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"添加评论===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加评论失败===%@",error.localizedDescription);
    }];
    
    
}

/**
 *  添加点赞
 */
+(void)addPraiseWithUserId:(NSString*)userId type:(NSString*)type objectId:(NSString*)objectId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"comment/savePraise.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"type":type,@"objectId":objectId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"添加点赞===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"添加点赞失败====%@",error.localizedDescription);
    }];
    
    
}
/**
 *  获取红包记录
 */
+(void)getRedEnvelopeListWithReqDic:(NSMutableDictionary *)reqDic WithUrl:(NSString *)url complete:(void (^)(NSDictionary *resultDict))complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *url2=[self getUrlWithString:url];
    [manager POST:url2 parameters:reqDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取评论列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取评论列表失败====%@",error.localizedDescription);
    }];

}
/**
 *  获取评论
 */
+(void)getCommentWithUserId:(NSString*)userId objectId:(NSString*)objectId type:(NSString*)type storeId:(NSString*)storeId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize pxType:(NSString*)pxType complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"comment/findComment.api"];
    NSDictionary *parameters = @{@"userId":userId==nil?@"":userId,@"objectId":objectId==nil?@"":objectId,@"type":type==nil?@"":type,@"storeId":storeId==nil?@"":storeId,@"pageNum":pageNum,@"pageSize":pageSize,@"pxType":pxType==nil?@"":pxType};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取评论列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取评论列表失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  商铺列表 pxType：moduleList为空才传递
 */
+(void)getStoreListWithModuleId:(NSString*)moduleId areaId:(NSString*)areaId lng:(NSString*)lng lat:(NSString*)lat pxType:(NSString*)pxType pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize keyword:(NSString*)keyword complete:(void(^)(StoreModel *model))complete
{
    NSString *url=[self getUrlWithString:@"index/findStore.api"];
    
    NSDictionary *parameters;
    if (keyword==nil)
    {
        parameters = @{@"moduleId":moduleId==nil?@"":moduleId,@"areaId":areaId==nil?@"":areaId,@"lng":lng==nil?@"":lng,@"lat":lat==nil?@"":lat,@"pxType":pxType==nil?@"":pxType,@"pageNum":pageNum,@"pageSize":pageSize};
    }
    else
    {
        parameters = @{@"moduleId":moduleId==nil?@"":moduleId,@"areaId":areaId==nil?@"":areaId,@"lng":lng==nil?@"":lng,@"lat":lat==nil?@"":lat,@"pxType":pxType==nil?@"":pxType,@"pageNum":pageNum,@"pageSize":pageSize,@"keyWord":keyword};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        StoreModel *model=[[StoreModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[responseObject objectForKey:@"list"];
            model.storeListArray=[[listDict objectForKey:@"data"] mutableCopy];
            model.pageNum=[listDict objectForKey:@"pageNum"];
            model.pageSize=[listDict objectForKey:@"pageSize"];
            model.totalItems=[listDict objectForKey:@"totalItems"];
            model.totalPages=[listDict objectForKey:@"totalPages"];
            model.moduleListArray=[[responseObject objectForKey:@"moduleList"] mutableCopy];//家家淘宝栏目不固定
            model.moduleList1Array=[[responseObject objectForKey:@"moduleList1"] mutableCopy];//云超市栏目固定
            
//            NSLog(@"model.moduleListArray===%@",model.moduleListArray);
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        if (keyword==nil)
        {
            NSLog(@"获取商铺列表===%@",responseObject);
        }
        else
        {
            NSLog(@"搜索商铺列表===%@",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取商铺列表失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  商铺详情
 */
+(void)getStoreDetailInfoWithUserId:(NSString*)userId storeId:(NSString*)storeId complete:(void(^)(StoreModel *model))complete
{
    NSString *url=[self getUrlWithString:@"index/storeInfo.api"];
    NSDictionary *parameters = @{@"userId":userId,@"storeId":storeId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        StoreModel *model=[[StoreModel alloc]init];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *storeDict=[responseObject objectForKey:@"store"];
            model.moduleName1=[storeDict objectForKey:@"ModuleName1"];
            model.moduleName2=[storeDict objectForKey:@"ModuleName2"];
            model.address=[storeDict objectForKey:@"address"];
            model.areaId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"areaId"]];
            model.callNum=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"callNum"]];
            model.storeCreateTime=[storeDict objectForKey:@"createtime"];
            model.storeExplains=[storeDict objectForKey:@"explains"];
            model.headImg=[storeDict objectForKey:@"headImg"];
            model.storeId=[storeDict objectForKey:@"id"];
            model.storeImageUrl=[storeDict objectForKey:@"img"];
            model.storeIsDel=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"isDel"]];
            model.storeIsCollect=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"iscollect"]];
            model.latitude=[storeDict objectForKey:@"latitude"];
            model.longitude=[storeDict objectForKey:@"longitude"];
            model.mobile=[storeDict objectForKey:@"mobile"];
            model.moduleId=[storeDict objectForKey:@"moduleId"];
            model.storeName=[storeDict objectForKey:@"name"];
            model.opentime=[storeDict objectForKey:@"opentime"];
            model.userId=[storeDict objectForKey:@"userId"];
            model.username=[storeDict objectForKey:@"username"];
            model.merchantId=[NSString stringWithFormat:@"%@",[storeDict objectForKey:@"merchantId"]];
            model.merchantName=[storeDict objectForKey:@"merchantName"];
            
            model.couponArray=[NSMutableArray array];
            NSArray *listArray=[responseObject objectForKey:@"list"];
            model.couponArray=[listArray mutableCopy];
            
            
//            model.couponAmount=[listDict objectForKey:@"amount"];
//            model.couponAmountYLQ=[listDict objectForKey:@"amountYLQ"];
//            model.couponCreateTime=[listDict objectForKey:@"createTime"];
//            model.couponId=[listDict objectForKey:@"id"];
//            model.couponKqStartTime=[listDict objectForKey:@"kqStartTime"];
//            model.couponMinMoney=[listDict objectForKey:@"minMoney"];
//            model.couponMoney=[listDict objectForKey:@"money"];
//            model.couponType=[listDict objectForKey:@"type"];
//            model.couponYxEndTime=[listDict objectForKey:@"yxEndTime"];
//            model.couponYxStartTime=[listDict objectForKey:@"yxStartTime"];
            
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"获取商铺详情===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         complete(nil);
        NSLog(@"获取商铺详情失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  商品列表
 */
+(void)getGoodsInStoreDetailInfoWithStoreId:(NSString*)storeId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(StoreModel *model))complete
{
    NSString *url=[self getUrlWithString:@"index/findItemByStoreId.api"];
    NSDictionary *parameters = @{@"storeId":storeId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        StoreModel *model=[[StoreModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *itemDict=[responseObject objectForKey:@"itemList"];
            model.goodsArray=[[itemDict objectForKey:@"data"] mutableCopy];
            model.pageNum=[itemDict objectForKey:@"pageNum"];
            model.pageSize=[itemDict objectForKey:@"pageSize"];
            model.totalItems=[itemDict objectForKey:@"totalItems"];
            model.totalPages=[itemDict objectForKey:@"totalPages"];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"获取商品列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取商品列表失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  商品详细信息
 */
+(void)getGoodsDetailInfoWithUserId:(NSString*)userId goodsId:(NSString*)goodsId complete:(void(^)(StoreModel *model))complete
{
    NSString *url=[self getUrlWithString:@"index/itemInfo.api"];
    NSDictionary *parameters = @{@"userId":userId,@"id":goodsId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        StoreModel *model=[[StoreModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *itemDict=[responseObject objectForKey:@"item"];
            model.goodsCreateTime=[itemDict objectForKey:@"createtime"];
            model.goodsExplains=[itemDict objectForKey:@"explains"];
            model.goodsId=[itemDict objectForKey:@"id"];
            model.goodsIcon=[itemDict objectForKey:@"img"];
            model.goodsImageUrl=[itemDict objectForKey:@"imgset"];
            model.goodsIsDel=[NSString stringWithFormat:@"%@",[itemDict objectForKey:@"isDel"]];
            model.goodsIsCollect=[NSString stringWithFormat:@"%@",[itemDict objectForKey:@"iscollect"]];
            model.goodsName=[itemDict objectForKey:@"name"];
            model.price=[itemDict objectForKey:@"price"];
            model.priceZH=[itemDict objectForKey:@"priceZH"];
            model.sales=[itemDict objectForKey:@"sales"];
            model.storeId=[itemDict objectForKey:@"storeId"];
            
            NSDictionary *storeDict=[responseObject objectForKey:@"store"];
            model.moduleName1=[storeDict objectForKey:@"ModuleName1"];
            model.moduleName2=[storeDict objectForKey:@"ModuleName2"];
            model.address=[storeDict objectForKey:@"address"];
            model.areaId=[storeDict objectForKey:@"areaId"];
            model.callNum=[storeDict objectForKey:@"callNum"];
            model.storeCreateTime=[storeDict objectForKey:@"createtime"];
            model.storeExplains=[storeDict objectForKey:@"explains"];
            model.headImg=[storeDict objectForKey:@"headImg"];
            model.storeId=[storeDict objectForKey:@"id"];
            model.storeIsDel=[NSString stringWithFormat:@"%@",[itemDict objectForKey:@"isDel"]];
            model.latitude=[storeDict objectForKey:@"latitude"];
            model.longitude=[storeDict objectForKey:@"longitude"];
            model.merchantId=[storeDict objectForKey:@"merchantId"];
            model.mobile=[storeDict objectForKey:@"mobile"];
            model.moduleId=[storeDict objectForKey:@"moduleId"];
            model.storeName=[storeDict objectForKey:@"name"];
            model.opentime=[storeDict objectForKey:@"opentime"];
            model.userId=[storeDict objectForKey:@"userId"];
            model.username=[storeDict objectForKey:@"username"];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"获取商品详情===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取商品详情失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  添加店铺里的获取一级分类
 */
+(void)getFirstCategoryForAddStore:(void(^)(StoreModel *model))complete
{
    NSString *url=[self getUrlWithString:@"index/getModuleList.api"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result=[responseObject objectForKey:@"result"];
        StoreModel *model=[[StoreModel alloc]init];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            model.firstCategoryArray=[[responseObject objectForKey:@"list"] mutableCopy];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"添加店铺里的获取一级分类===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"添加店铺里的获取一级分类失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  添加店铺里的获取二级分类
 */
+(void)getSecondCategoryForAddStoreWithPatentId:(NSString*)parentId complete:(void(^)(StoreModel *model))complete
{
    NSString *url=[self getUrlWithString:@"index/getModuleList.api"];
    NSDictionary *parameters = @{@"id":parentId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result=[responseObject objectForKey:@"result"];
        StoreModel *model=[[StoreModel alloc]init];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            model.secondCategoryArray=[[responseObject objectForKey:@"list"] mutableCopy];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"添加店铺里的获取二级分类===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"添加店铺里的获取二级分类失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  添加店铺
 */
+(void)addStoreWithName:(NSString*)name explain:(NSString*)explain address:(NSString*)address longitude:(NSString*)longitude latitude:(NSString*)latitude userName:(NSString*)userName mobile:(NSString*)mobile opentime:(NSString*)opentime userId:(NSString*)userId areaId:(NSString*)areaId moduleId:(NSString*)moduleId headImg:(NSData*)headImg imgs:(NSMutableArray*)imgs merchantId:(NSString*)merchantId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/addStore.api"];
    NSDictionary *parameters = @{@"name":name,@"explains":explain,@"address":address,@"longitude":longitude,@"latitude":latitude,@"username":userName,@"mobile":mobile,@"opentime":opentime,@"userId":userId,@"areaId":areaId,@"moduleId":moduleId,@"merchantId":merchantId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:headImg name:@"headImgs" fileName:@"headImage.png" mimeType:@"image/png/jpg"];
        // 1) 取当前系统时间
        NSDate *date = [NSDate date];
        // 2) 使用日期格式化工具
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 3) 指定日期格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        for (NSInteger i=0; i<imgs.count; i++)
        {
            UIImage *image=imgs[i];
            NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
            // 4) 使用系统时间生成一个文件名
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", dateStr,i + 1];
            [formData appendPartWithFileData:imageData name:@"imgs" fileName:fileName mimeType:@"image/png/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        
        NSLog(@"添加店铺===%@",responseObject);
        
        complete(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加店铺失败====%@",error.localizedDescription);
    }];
    
}
//分享红包截图
+(void)shareRedEnvelopeImage:(UIImage*)image userId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v3/shareHb.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * imageData =UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:@"img" fileName:@"headImage.png" mimeType:@"image/png/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"添加店铺===%@",responseObject);
        
        complete(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加店铺失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  删除店铺 ids为店铺id 多个店铺id之间用,隔开
 */
+(void)deleteStoreWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/delStore.api"];
    NSDictionary *parameters = @{@"ids":ids};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除店铺===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除店铺失败====%@",error);
    }];
}

/**
 *  添加商品
 */
+(void)addGoodsInStoreWithName:(NSString*)name explain:(NSString*)explain price:(NSString*)price priceZH:(NSString*)priceZH repertory:(NSString*)repertory storeId:(NSString*)storeId imgs:(NSMutableArray*)imgs complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/addStoreItem.api"];
    NSDictionary *parameters = @{@"name":name,@"explains":explain,@"price":price,@"priceZH":priceZH,@"repertory":repertory,@"storeId":storeId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 1) 取当前系统时间
        NSDate *date = [NSDate date];
        // 2) 使用日期格式化工具
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 3) 指定日期格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        for (NSInteger i=0; i<imgs.count; i++)
        {
            UIImage *image=imgs[i];
            NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
            // 4) 使用系统时间生成一个文件名
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", dateStr,i + 1];
            [formData appendPartWithFileData:imageData name:@"imgs" fileName:fileName mimeType:@"image/png/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"添加商品===%@",responseObject);
        
        complete(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加商品失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  删除店铺商品 多个对象id用,隔开
 */
+(void)deleteGoodsWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/delStoreItem.api"];
    NSDictionary *parameters = @{@"ids":ids};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除店铺商品===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除店铺商品失败====%@",error);
    }];
}

/**
 *  发送添加好友请求
 */
+(void)addFriendRequestWithUserId:(NSString*)userId toUserId:(NSString*)toUserId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/addUserfriend.api"];
    NSDictionary *parameters = @{@"userId":userId,@"toUserId":toUserId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"发送添加好友请求===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"发送添加好友请求失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  是否同意对方的添加好友请求 status:1 同意 0 删除
 */
+(void)ifAgreeAddFriendWithUserId:(NSString*)userId toUserId:(NSString*)toUserId status:(NSString*)status complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/isAgreeMyfriend.api"];
    NSDictionary *parameters = @{@"userId":userId,@"toUserId":toUserId,@"status":status};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"是否同意对方的添加好友请求===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"是否同意对方的添加好友请求失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  获取我的好友列表
 */
+(void)getMyFriendsListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/myUserFriendList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"获取我的好友列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的好友列表失败====%@",error.localizedDescription);
    }];
}

/**
 *  想要加我为好友的人
 */
+(void)getUserMakeMeFriendWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/myUserfriendRecord.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取想要加我为好友的人列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取想要加我为好友的人列表失败====%@",error.localizedDescription);
    }];
}

/**
 *  搜索好友
 */
+(void)searchFriendsWithUserId:(NSString*)userId keyWord:(NSString*)keyWord pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSMutableArray *array))complete
{
    NSString *url=[self getUrlWithString:@"index/searchUserList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize,@"keyWord":keyWord};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"搜索好友===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"搜索好友失败====%@",error.localizedDescription);
    }];
}

/**
 *  好友推荐
 */
+(void)recomendFriendsWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/recommendUserList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"好友推荐===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"好友推荐失败====%@",error.localizedDescription);
    }];
}

/**
 *  周边服务
 */
+(void)surroundingService:(void(^)(NSMutableArray *bigClassArray))complete
{
    NSString *url=[self getUrlWithString:@"index/rimModuleList.api"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result=[responseObject objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSArray *listArray=[responseObject objectForKey:@"list"];
            NSMutableArray *bigClassArray=[NSMutableArray array];
            for (NSInteger i=0; i<listArray.count; i++)
            {
                NSDictionary *bigClassDict=listArray[i];
                AroundModel *model=[[AroundModel alloc]init];
                model.bigClassCreateTime=[bigClassDict objectForKey:@"carettime"];
                model.bigClassId=[bigClassDict objectForKey:@"id"];
                model.bigClassImage=[bigClassDict objectForKey:@"img"];
                model.isHome=[bigClassDict objectForKey:@"isHome"];
                model.smallClassArray=[bigClassDict objectForKey:@"mList"];
                model.bigClassParentId=[bigClassDict objectForKey:@"parentId"];
                model.bigClassName=[bigClassDict objectForKey:@"name"];
                
                [bigClassArray addObject:model];
                
//                NSLog(@"model.smallClassArray===%@",model.smallClassArray);
            }
            
            complete(bigClassArray);
        }
        
//        NSLog(@"获取周边服务===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取周边服务失败====%@",error.localizedDescription);
    }];
}

/**
 *  周边服务 门店列表(快递类)
 */
+(void)surroundingServiceForStoreListWithModuleId:(NSString*)moduleId areaId:(NSString*)areaId lng:(NSString*)lng lat:(NSString*)lat pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/storeListByrim.api"];
    NSDictionary *parameters = @{@"moduleId":moduleId,@"areaId":areaId,@"lng":lng,@"lat":lat,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"获取周边服务门店列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取周边服务门店列表失败====%@",error.localizedDescription);
    }];
}




/**
 *  商户添加优惠券 type:1商家 0平台
 */
+(void)storeAddCouponWithMoney:(NSString*)money minMoney:(NSString*)minMoney type:(NSString*)type storeId:(NSString*)storeId yxETimeStr:(NSString*)yxETimeStr yxSTimeStr:(NSString*)yxSTimeStr amount:(NSString*)amount  kqSTimeStr:(NSString*)kqSTimeStr complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/addCoupon.api"];
    NSDictionary *parameters = @{@"minMoney":minMoney,@"money":money,@"type":type,@"storeId":storeId,@"yxETimeStr":yxETimeStr,@"yxSTimeStr":yxSTimeStr,@"amount":amount,@"kqSTimeStr":kqSTimeStr};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"商户添加优惠券===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"商户添加优惠券失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  商户优惠券列表
 */
+(void)getStoreCouponListWithStoreId:(NSString*)storeId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(StoreModel *storeModel))complete
{
    NSString *url=[self getUrlWithString:@"index/couponListByStoreId.api"];
    NSDictionary *parameters = @{@"storeId":storeId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result=[responseObject objectForKey:@"result"];
        StoreModel *model=[[StoreModel alloc]init];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *couponListDict=[responseObject objectForKey:@"couponList"];
            model.storeCouponArray=[[couponListDict objectForKey:@"data"] mutableCopy];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        complete(model);
        
        NSLog(@"获取商家优惠券列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取商家优惠券列表失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  用户领取优惠券
 */
+(void)getCouponFromStoreWithUserId:(NSString*)userId couponId:(NSString*)couponId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/addUserCoupon.api"];
    NSDictionary *parameters = @{@"couponId":couponId,@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"用户领取优惠券===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"用户领取优惠券失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  用户优惠券列表
 */
+(void)getUserCouponListWithUserId:(NSString*)userId type:(NSString*)type pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize amount:(NSString*)amount storeId:(NSString*)storeId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/getUserCouponList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"type":type,@"pageNum":pageNum,@"pageSize":pageSize,@"amount":amount,@"storeId":storeId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        if ([type isEqualToString:@"1"])
        {
            NSLog(@"获取商家优惠券列表===%@",responseObject);
        }
        if ([type isEqualToString:@"0"])
        {
            NSLog(@"获取平台优惠券列表===%@",responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([type isEqualToString:@"1"])
        {
            NSLog(@"获取商家优惠券列表失败===%@",error.localizedDescription);
        }
        if ([type isEqualToString:@"0"])
        {
            NSLog(@"获取平台优惠券列表失败===%@",error.localizedDescription);
        }
    }];
    
    
}

/**
 *  添加修改收货地址
 */
+(void)addOrEditShippingAddressWidhUserId:(NSString*)userId userName:(NSString*)userName userPhone:(NSString*)userPhone city:(NSString*)city address:(NSString*)address addressId:(NSString*)addressId status:(NSString*)status complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/saveReceiptInfo.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"username":userName,@"userphone":userPhone,@"city":city,@"address":address,@"status":status,@"id":addressId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        complete(responseObject);
        
        NSLog(@"添加修改收货地址===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"添加修改收货地址失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  收货地址列表
 */
+(void)getShippingAddressListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(Model *model))complete
{
    NSString *url=[self getUrlWithString:@"order/receiptInfoList.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Model *model=[Model model];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[responseObject objectForKey:@"list"];
            model.shippingAddressArray=[[listDict objectForKey:@"data"] mutableCopy];
            model.pageNum=[listDict objectForKey:@"pageNum"];
            model.pageSize=[listDict objectForKey:@"pageSize"];
            model.totalItems=[listDict objectForKey:@"totalItems"];
            model.totalPages=[listDict objectForKey:@"totalPages"];
            
//            NSLog(@"收货地址列表===%@",model.shippingAddressArray);
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        
        
        
        complete(model);
        
        NSLog(@"收货地址列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"收货地址列表获取失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  收货地址详情
 */
+(void)getShippingAddressDetailInfoWithAddressId:(NSString*)addressId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/receiptInfo.api"];
    
    NSDictionary *parameters = @{@"id":addressId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
        }
        else
        {
            
        }
        
        
        
        
        complete(responseObject);
        
        NSLog(@"获取收货地址详情===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取收货地址详情失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  删除收货地址
 */
+(void)deleteShippingAddressWithAddressId:(NSString*)addressId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/delReceiptInfo.api"];
    
    NSDictionary *parameters = @{@"id":addressId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
        }
        else
        {
            
        }
        
        complete(responseObject);
        
        NSLog(@"删除收货地址===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除收货地址失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  获取指定用户的默认收货地址
 */
+(void)getUserDefaultShippingAddressWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/defaultReceiptInfoByUserId.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"获取指定用户的默认收货地址===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取指定用户的默认收货地址失败====%@",error.localizedDescription);
    }];
}

/**
 *  绑定提现银行卡（添加、修改）
 */
+(void)bindBankCardWithBankName:(NSString*)bankName cardNumber:(NSString*)cardNumber bankCity:(NSString*)bankCity subBranch:(NSString*)subBranch khUserName:(NSString*)khUserName phone:(NSString*)phone idCard:(NSString*)idCard userId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/userBDBank.api"];
    
    NSDictionary *parameters = @{@"bankName":bankName,@"cardNumber":cardNumber,@"bankCity":bankCity,@"subBranch":subBranch,@"khUserName":khUserName,@"phone":phone,@"idCard":idCard,@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"绑定提现银行卡===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"绑定提现银行卡失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  获取银行名
 */
+(void)getBankName:(void(^)(NSMutableArray *mutableArray))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/getBankList.api"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
        }
        
        NSLog(@"获取银行名===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取银行名失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  获取已绑定银行卡列表
 */
+(void)getBindBankCardListWithUserId:(NSString*)userId complete:(void(^)(NSMutableArray *mutableArray))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/userBankList.api"];
    
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSArray *listArray=[responseObject objectForKey:@"list"];
            NSMutableArray *bankListArray=[NSMutableArray array];
            bankListArray=[listArray mutableCopy];
            complete(bankListArray);
        }
        
        NSLog(@"获取已绑定银行卡列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取已绑定银行卡列表失败====%@",error.localizedDescription);
    }];
    
    
}

/**
 *  获取开户银行列表
 */
+(void)getOpeningBankList:(void(^)(NSMutableArray *mutableArray))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/getBankList.api"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSMutableArray *array=[NSMutableArray array];
            NSArray *listArray=[responseObject objectForKey:@"list"];
            array=[listArray mutableCopy];
            
            complete(array);
        }
        
        NSLog(@"获取开户银行列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取开户银行列表失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  获取用户信息
 */
+(void)getUserInfoWithUserId:(NSString*)userId complete:(void(^)(User *user))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/userInfo.api"];
    
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        User *user=[UserInfoData getUserInfoFromArchive];
        user.result=[responseObject objectForKey:@"result"];
        if ([user.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userDict=[responseObject objectForKey:@"user"];
            NSLog(@"userDict==%@",userDict);
            user.address=[userDict objectForKey:@"address"];
            user.areaId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"areaId"]];
            user.brokerage=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"brokerage"]];
            user.code=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"code"]];
            user.explain=[userDict objectForKey:@"explain"];
            user.headImage=[userDict objectForKey:@"headimg"];
            user.userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
            user.isPush=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"isPush"]];
            user.merchantId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"merId"]];//merId为0说明用户未注册商户 不等于0时说明已经注册商户了
            user.age=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"age"]];
            user.username=[userDict objectForKey:@"name"];
            user.nickname=[userDict objectForKey:@"nickname"];
            user.acceptAddress=[userDict objectForKey:@"receiptInfoName"];
            user.sex=[userDict objectForKey:@"sex"];
            user.sign=[userDict objectForKey:@"sign"];
            user.token=[userDict objectForKey:@"token"];
            user.userMoney=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"userMoney"]];
            user.vipName=[userDict objectForKey:@"vipName"];
            user.xqId=[userDict objectForKey:@"xqId"];
            user.ylCardNo=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylCardNo"]];
            user.ylPayPass=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylPayPass"]];
            user.ylTime=[userDict objectForKey:@"ylTime"];
            user.ylToken=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylToken"]];
            user.referrer=[userDict objectForKey:@"referrer"];
            user.isChangeArea=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ischangeArea"]];
            user.changeAreaName=[userDict objectForKey:@"changeAreaName"];
            user.changeXqName=[userDict objectForKey:@"changeXqName"];
        }
        else
        {
            user.error=[responseObject objectForKey:@"error"];
        }
        
        complete(user);
        
//        NSLog(@"获取用户信息===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取用户信息失败====%@",error);
    }];
    
    
}

/**
 *  更新用户信息
 */
+(void)updateUserInfoWithUserId:(NSString*)userId nickname:(NSString*)nickname sex:(NSString*)sex age:(NSString*)age address:(NSString*)address sign:(NSString*)sign img:(NSData*)img complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/updateUser.api"];
    if ([age isEqualToString:@"(null)"]||age==nil) {
        age = @"";
    }
    NSDictionary *parameters = @{@"id":userId,@"nickname":nickname,@"sex":sex,@"address":address,@"sign":sign,@"age":age};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (img!=nil)
        {
            [formData appendPartWithFileData:img name:@"img" fileName:@"image.png" mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"更新用户信息===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary * responseObject = [NSDictionary dictionaryWithObjectsAndKeys:error.localizedDescription,@"msg", nil];
        complete(responseObject);
        NSLog(@"更新用户信息失败====%@====%@",error.localizedDescription,error);
    }];
}

/**
 *  充值记录
 */
+(void)getPayRecordWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myCZrecord.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取充值记录===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取充值记录失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  佣金提现记录
 */
+(void)commissionWithdrawRecordWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myTXrecord.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            
            
        }
        
        complete(responseObject);
        
        NSLog(@"获取佣金提现记录===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取佣金提现记录失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  佣金提现
 */
+(void)commissionWithdrawWithUserId:(NSString*)userId money:(NSString*)money bankUserName:(NSString*)bankUserName bankCode:(NSString*)bankCode bankName:(NSString*)bankName bankCity:(NSString*)bankCity subBranch:(NSString*)subBranch complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/addTXrecord.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"money":money,@"bankUserName":bankUserName,@"bankCode":bankCode,@"bankName":bankName,@"bankCity":bankCity,@"subBranch":subBranch};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"佣金提现===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"佣金提现失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  我的发文列表
 */
+(void)getMyArticleListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(ArticleModel *model))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myFWrecord.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ArticleModel *model=[[ArticleModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[responseObject objectForKey:@"articleList"];
            NSArray *dataArray=[listDict objectForKey:@"data"];
            model.articleArray=[NSMutableArray array];
            for (NSInteger i=0; i<dataArray.count; i++)
            {
                NSDictionary *articleDict=dataArray[i];
                [model.articleArray addObject:articleDict];
            }
            model.pageNum=[listDict objectForKey:@"pageNum"];
            model.pageSize=[listDict objectForKey:@"pageSize"];
            model.totalItems=[listDict objectForKey:@"totalItems"];
            model.totalPages=[listDict objectForKey:@"totalPages"];
            
            complete(model);
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
            complete(model);
        }
        
        NSLog(@"获取我的发文列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的发文列表失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  我的信息、提醒 邻居界面系统消息、评论和赞的消息
 */
+(void)getMyMessageOrAlertWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myMessageRemind.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"获取我的信息、提醒 邻居界面系统消息、评论和赞的消息===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的信息、提醒 邻居界面系统消息、评论和赞的消息失败====%@",error);
    }];
    
}

/**
 *  我的信息 系统消息、评论和赞点进去的详细信息 type:0 系统信息 1 评论信息 2 点赞信息
 */
+(void)getMyMessageOrAlertWithUserId:(NSString*)userId type:(NSString*)type pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myMessageList.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"type":type,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取我的信息 系统消息、评论和赞点进去的详细信息===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的信息 系统消息、评论和赞点进去的详细信息失败====%@",error);
    }];
    
}

/**
 *  获取用户的签到记录
 */
+(void)getSignInRecordWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/userLogList.api"];
    
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result=[responseObject objectForKey:@"result"];
        
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            complete(responseObject);
        }
        else
        {
            
        }
        
        complete(responseObject);
        
//        NSLog(@"获取用户的签到记录===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取用户的签到记录失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  创建订单 orderData是json字符串
 */
+(void)addOrderWithOrderData:(NSString*)orderData complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/saveOrder.api"];
    
    NSDictionary *parameters = @{@"orderData":orderData};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"创建订单===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"创建订单失败====%@",error);
    }];
    
    //@"{\"couponId\":\"\",\"list\":[{\"count\":\"1\",\"amount\":12,\"itemId\":17}],\"sellerid\":9,\"storeId\":3,\"buyerid\":\"17\",\"receiptId\":\"21\",\"money\":\"0.00\",\"explains\":\"\"}"
}

/**
 *  订单列表(用户)
 */
+(void)getOrderListOfUserWithUserId:(NSString*)userId status:(NSString*)status pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(OrderModel *model))complete
{
    NSString *url=[self getUrlWithString:@"order/findPayInfoByuserId.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"status":status,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        OrderModel *model=[[OrderModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *payInfoListDict=[responseObject objectForKey:@"payInfoList"];
            model.orderListArray=[[payInfoListDict objectForKey:@"data"] mutableCopy];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"获取订单列表(用户)===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取订单列表(用户)失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  订单列表(商家)
 */
+(void)getOrderListOfStoreWithUserId:(NSString*)userId status:(NSString*)status pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(OrderModel *model))complete
{
    NSString *url=[self getUrlWithString:@"order/findPayInfoByStoreId.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"status":status,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        OrderModel *model=[[OrderModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *payInfoListDict=[responseObject objectForKey:@"payInfoList"];
            model.orderListArray=[[payInfoListDict objectForKey:@"data"] mutableCopy];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
        NSLog(@"获取订单列表(商家)===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取订单列表(商家)失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  订单详情
 */
+(void)getOrderDetailWithOrderId:(NSString*)orderId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/payInfoDetail.api"];
    
    NSDictionary *parameters = @{@"id":orderId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取订单详情===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取订单详情失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  获取我的店铺列表
 */
+(void)getMyStoreWithUserId:(NSString*)userId complete:(void(^)(StoreModel *storeModel))complete
{
    NSString *url=[self getUrlWithString:@"index/myStoreList.api"];
    
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        StoreModel *model=[[StoreModel alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[responseObject objectForKey:@"list"];
            model.myStoreArray=[[listDict objectForKey:@"data"] mutableCopy];
        }
        else
        {
            model.error=[responseObject objectForKey:@"error"];
        }
        
        complete(model);
        
//        NSLog(@"获取我的店铺列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的店铺列表失败====%@",error.localizedDescription);
    }];
}

/**
 *  获取用户收藏列表 type：1文章，2商品，3店铺
 */
+(void)getUserCollectionListWithUserId:(NSString*)userId type:(NSString*)type pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myCollectionList.api"];
    
    NSDictionary *parameters = @{@"userId":userId,@"type":type,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        if ([type isEqualToString:@"1"])
        {
            NSLog(@"获取话题收藏列表===%@",responseObject);
        }
        if ([type isEqualToString:@"2"])
        {
            NSLog(@"获取商品收藏列表===%@",responseObject);
        }
        if ([type isEqualToString:@"3"])
        {
            NSLog(@"获取店铺收藏列表===%@",responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([type isEqualToString:@"1"])
        {
            NSLog(@"获取话题收藏列表失败====%@",error.localizedDescription);
        }
        if ([type isEqualToString:@"2"])
        {
            NSLog(@"获取商品收藏列表失败====%@",error.localizedDescription);
        }
        if ([type isEqualToString:@"3"])
        {
            NSLog(@"获取店铺收藏列表失败====%@",error.localizedDescription);
        }
        
    }];
    
}

/**
 *  添加收藏 objectid:收藏对象id（文章id，商品id，店铺id）
 */
+(void)addUserCollectionWithUserId:(NSString*)userId type:(NSString*)type objectid:(NSString*)objectid complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/addCollectionList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"type":type,@"objectid":objectid};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        complete(responseObject);
        
        NSLog(@"添加收藏===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"添加收藏失败====%@",error.localizedDescription);
    }];
    
}

/**
 *  删除收藏内容 包括帖子商品店铺 多个对象id用,隔开
 */
+(void)deleteCollectionWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/delCollections.api"];
    NSDictionary *parameters = @{@"ids":ids};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除收藏内容===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除收藏内容失败====%@",error.localizedDescription);
    }];
}

/**
 *  删除我的帖子 多个对象id用,隔开
 */
+(void)deleteArticlesWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/delFWrecords.api"];
    NSDictionary *parameters = @{@"ids":ids};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除我的帖子===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除我的帖子失败====%@",error.localizedDescription);
    }];
}

/**
 *  帖子详情
 */
+(void)getArticleDetailInfoWithUserId:(NSString*)userId articleId:(NSString*)articleId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/articleInfo.api"];
    NSDictionary *parameters = @{@"userId":userId,@"articleId":articleId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取帖子详情===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取帖子详情失败====%@",error);
    }];
}

/**
 *  获取VIP信息集合
 */
+(void)getVIPListWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/userVipList.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取VIP信息集合===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取VIP信息集合失败====%@",error.localizedDescription);
    }];
}

/**
 *  购买VIP
 */
+(void)buyVIPWithUserId:(NSString*)userId usergradeId:(NSString*)usergradeId password:(NSString*)password complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/userBuyVip.api"];
    NSDictionary *parameters = @{@"userId":userId,@"usergradeId":usergradeId,@"password":password};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"购买VIP===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"购买VIP失败====%@",error.localizedDescription);
    }];
}

/**
 *  会员中心 我的会员
 */
+(void)myMemberCenterWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myUserList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"我的会员===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的会员信息失败====%@",error.localizedDescription);
    }];
}

/**
 *  创建群
 */
+(void)createGroupWithIds:(NSString*)ids groupName:(NSString*)groupName logoImg:(NSData*)logoImg groupDes:(NSString*)groupDes complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/createGroup.api"];
    NSDictionary *parameters = @{@"ids":ids,@"name":groupName,@"des":groupDes};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (logoImg!=nil)
        {
            [formData appendPartWithFileData:logoImg name:@"logoImg" fileName:@"logoImg.png" mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"创建群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"创建群失败====%@",error.localizedDescription);
    }];
}

/**
 *  加入群
 */
+(void)joinGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId groupName:(NSString*)groupName complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/joinGroup.api"];
    NSDictionary *parameters = @{@"id":userId,@"groupId":groupId,@"groupName":groupName};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"加入群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"加入群失败====%@",error.localizedDescription);
    }];
}

/**
 *  退出群
 */
+(void)exitGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/quitGroup.api"];
    NSDictionary *parameters = @{@"userId":userId,@"groupId":groupId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"退出群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"退出群失败====%@",error.localizedDescription);
    }];
}

/**
 *  解散群
 */
+(void)deleteGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/delGroup.api"];
    NSDictionary *parameters = @{@"userId":userId,@"groupId":groupId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"解散群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"解散群失败====%@",error.localizedDescription);
    }];
}

/**
 *  举报群
 */
+(void)reportGroupWithUserId:(NSString*)userId groupId:(NSString*)groupId cause:(NSString*)cause complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/reportGroup.api"];
    NSDictionary *parameters = @{@"userId":userId,@"groupId":groupId,@"cause":cause};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"举报群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"举报群失败====%@",error.localizedDescription);
    }];
}

/**
 *  我的佣金
 */
+(void)myBrokerageWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myBrokerage.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"我的佣金===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的佣金失败====%@",error.localizedDescription);
    }];
}

/**
 *  群组信息
 */
+(void)groupInfoWithUserId:(NSString*)userId groupId:(NSString*)groupId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/groupInfo.api"];
    NSDictionary *parameters = @{@"userId":userId,@"groupId":groupId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"群组信息===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取群组信息失败====%@",error.localizedDescription);
    }];
}

/**
 *  发现群
 */
+(void)findGroupWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/groupList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"发现群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"发现群失败====%@",error.localizedDescription);
    }];
}

/**
 *  选择群
 */
+(void)chooseGroupWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"im/checkGroupList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"选择群===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"选择群失败====%@",error.localizedDescription);
    }];
}

/**
 *  删除订单
 */
+(void)deleteOrderWithOrderId:(NSString*)orderId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/delPayInfo.api"];
    NSDictionary *parameters = @{@"payInfoId":orderId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除订单===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除订单失败====%@",error.localizedDescription);
    }];
}

/**
 *  退款
 */
+(void)refundWithOrderId:(NSString*)orderId refundDes:(NSString*)refundDes complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/refundPayInfo.api"];
    NSDictionary *parameters = @{@"payInfoId":orderId,@"refundDes":refundDes};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"退款===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"退款失败====%@",error.localizedDescription);
    }];
}

/**
 *  我的邻居
 */
+(void)myNeighborWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/myNeighbor.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"我的邻居列表===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取我的邻居列表失败====%@",error.localizedDescription);
    }];
}

/**
 *  账户余额
 */
+(void)accountBalanceWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/userMoney.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"账户余额===%@",responseObject);
        complete(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取账户余额失败====%@",error.localizedDescription);
    }];
}

/**
 *  删除银行卡
 */
+(void)deleteBindingBankCardWithBankCardId:(NSString*)bankCardId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/delUserBank.api"];
    NSDictionary *parameters = @{@"id":bankCardId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除银行卡===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除银行卡失败====%@",error.localizedDescription);
    }];
}

/**
 *  确认发货
 */
+(void)confirmSendOutWithPayInfoId:(NSString*)payInfoId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/affirmFhOrder.api"];
    NSDictionary *parameters = @{@"payInfoId":payInfoId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"确认发货===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"确认发货失败====%@",error.localizedDescription);
    }];
}

/**
 *  确认收货
 */
+(void)confirmReceivingWithPayInfoId:(NSString*)payInfoId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/affirmOrder.api"];
    NSDictionary *parameters = @{@"payInfoId":payInfoId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
//        NSLog(@"确认收货===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"确认收货失败====%@",error.localizedDescription);
    }];
}

/**
 *  支付宝/微信/银联充值 payType:1、微信 2、支付宝 3、银行卡 4、佣金 5、快钱 backType:充值模式id
 */
+(void)rechargeWithUserId:(NSString*)userId money:(NSString*)money payType:(NSString*)payType backType:(NSString*)backType password:(NSString*)password complete:(void(^)(NSDictionary *resultDict))complete;
{
    NSString *url=[self getUrlWithString:@"pay/recharge.api"];
    NSDictionary *parameters;
    if ([payType isEqualToString:@"4"])
    {
        parameters = @{@"userId":userId,@"money":money,@"payType":payType,@"backType":backType,@"pwd":password};
    }
    else
    {
        parameters = @{@"userId":userId,@"money":money,@"payType":payType,@"backType":backType};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        if ([payType isEqualToString:@"1"])
        {
            NSLog(@"微信充值===%@",responseObject);
        }
        if ([payType isEqualToString:@"2"])
        {
            NSLog(@"支付宝充值===%@",responseObject);
        }
        if ([payType isEqualToString:@"4"])
        {
            NSLog(@"佣金充值===%@",responseObject);
        }
        if ([payType isEqualToString:@"5"])
        {
            NSLog(@"快钱充值===%@",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([payType isEqualToString:@"1"])
        {
            NSLog(@"微信充值失败===%@",error);
        }
        if ([payType isEqualToString:@"2"])
        {
            NSLog(@"支付宝充值失败===%@",error);
        }
        if ([payType isEqualToString:@"4"])
        {
            NSLog(@"佣金充值失败===%@",error);
        }
        if ([payType isEqualToString:@"5"])
        {
            NSLog(@"快钱充值失败===%@",error);
        }
    }];
}

/**
 *  获取退货订单中的商品总额和应退款项
 */
+(void)getOrderMoneyWithPayInfoId:(NSString*)payInfoId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/payInfo.api"];
    NSDictionary *parameters = @{@"payInfoId":payInfoId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取退货订单中的商品总额和应退款项===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取退货订单中的商品总额和应退款项失败====%@",error.localizedDescription);
    }];
}

/**
 *  注册商户
 */
+(void)registerStoreWithUserId:(NSString*)userId registerDict:(NSMutableDictionary*)registerDict complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/addMerchant.api"];
    
    NSString *shmc=[registerDict objectForKey:@"shmc"];
    NSString *lxr=[registerDict objectForKey:@"lxr"];
    NSString *lxdh=[registerDict objectForKey:@"lxdh"];
    NSString *ylhid=[registerDict objectForKey:@"ylhid"];
    NSString *dz=[registerDict objectForKey:@"dz"];
    NSString *jyfw=[registerDict objectForKey:@"jyfw"];
    NSString *ghfs=[registerDict objectForKey:@"ghfs"];
    NSString *ghgxl=[registerDict objectForKey:@"ghgxl"];
    NSString *zjrxm=[registerDict objectForKey:@"zjrxm"];
    NSString *zjhm=[registerDict objectForKey:@"zjhm"];
    NSString *frsjhm=[registerDict objectForKey:@"frsjhm"];
    NSString *khyhjzh=[registerDict objectForKey:@"khyhjzh"];
    NSString *khhh=[registerDict objectForKey:@"khhh"];
    NSString *sfsh=[registerDict objectForKey:@"sfsh"];
    NSString *khmc=[registerDict objectForKey:@"khmc"];
    NSString *khzh=[registerDict objectForKey:@"khzh"];
    NSString *yyzzh=[registerDict objectForKey:@"yyzzh"];
    NSString *yyzzszd=[registerDict objectForKey:@"yyzzszd"];
    NSString *yyqx=[registerDict objectForKey:@"yyqx"];
    NSString *zzjgdm=[registerDict objectForKey:@"zzjgdm"];
    NSString *khxkzh=[registerDict objectForKey:@"khxkzh"];
    NSString *swdjzh=[registerDict objectForKey:@"swdjzh"];
    NSString *sfkp=[registerDict objectForKey:@"sfkp"];
    
    NSDictionary *parameters = @{@"userId":userId,@"name":shmc,@"conPerName":lxr,@"conPerTeleNo":lxdh,@"ylhId":ylhid,@"address":dz,@"bscope":jyfw,@"supplyType":ghfs,@"rakeRate":ghgxl,@"lgName":zjrxm,@"lgIdcard":zjhm,@"lgTelephone":frsjhm,@"bankName":khyhjzh,@"bankLineNum":khhh,@"isPrivate":sfsh,@"bankUser":khmc,@"bankAccountNo":khzh,@"bnumber":yyzzh,@"blicenceAddr":yyzzszd,@"openLimit":yyqx,@"orgCode":zzjgdm,@"knumber":khxkzh,@"snumber":swdjzh,@"isInvoice":sfkp};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"注册商户===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"注册商户失败====%@",error.localizedDescription);
    }];
}

/**
 *  用户收入明细
 */
+(void)getIncomeRecordsWithUserId:(NSString*)userId pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"pay/qurMerTrades.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取用户收入明细===%@",responseObject);
        
        complete(responseObject);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取用户收入明细失败====%@",error.localizedDescription);
    }];
}

/**
 *  用户提现明细
 */
+(void)getWithdrawRecordsWithUserId:(NSString*)userId pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"pay/qurSettleTrades.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取用户提现明细===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取用户提现明细失败====%@",error.localizedDescription);
    }];
}

/**
 *  支付订单
 */
+(void)payOrderWithPayInfoId:(NSString*)payInfoId ymlPayPass:(NSString*)ymlPayPass complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/payOrder.api"];
    NSDictionary *parameters = @{@"payInfoId":payInfoId,@"ymlPayPass":ymlPayPass};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"支付订单===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"支付订单失败====%@",error.localizedDescription);
    }];
}

///**
// *  分享帖子
// */
//+(void)shareArticleWithArticleId:(NSString*)articleId complete:(void(^)(NSDictionary *resultDict))complete
//{
//    NSString *url=[self getUrlWithString:@"share/articleInfo.api"];
//    NSDictionary *parameters = @{@"id":articleId};
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        complete(responseObject);
//        
//        NSLog(@"分享帖子===%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"分享帖子失败====%@",error);
//    }];
//}
//
///**
// *  分享商品
// */
//+(void)shareGoodsWithGoodsId:(NSString*)goodsId complete:(void(^)(NSDictionary *resultDict))complete
//{
//    NSString *url=[self getUrlWithString:@"share/proInfo.api"];
//    NSDictionary *parameters = @{@"id":goodsId};
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        complete(responseObject);
//        
//        NSLog(@"分享商品===%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"分享商品失败====%@",error.localizedDescription);
//    }];
//}
//
///**
// *  分享店铺
// */
//+(void)shareStoreWithStoreId:(NSString*)storeId complete:(void(^)(NSDictionary *resultDict))complete
//{
//    NSString *url=[self getUrlWithString:@"share/storeInfo.api"];
//    NSDictionary *parameters = @{@"id":storeId};
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        complete(responseObject);
//        
//        NSLog(@"分享店铺===%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"分享店铺失败====%@",error.localizedDescription);
//    }];
//}

/**
 *  判断是否是第一次第三方登录
 */
+(void)ifFirstThirdLoginWithName:(NSString*)name complete:(void(^)(User *user))complete
{
    NSString *url=[self getUrlWithString:@"user/firstThirdLogin.api"];
    NSDictionary *parameters = @{@"name":name};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        User *user=[User user];
        user.result=[responseObject objectForKey:@"result"];
        if ([user.result isEqualToString:STATUS_SUCCESS])
        {
            user.status=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
            
//            if ([user.status isEqualToString:@"1"])
//            {
//                
//            }
            
            user.areaName=[responseObject objectForKey:@"areaName"];
            user.smaAreaName=[responseObject objectForKey:@"smaAreaName"];
            user.isMerchant=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isMerchant"]];
            user.ylToken=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ylToken"]];
            
            NSDictionary *userDict=[responseObject objectForKey:@"user"];
            user.address=[userDict objectForKey:@"address"];
            user.areaId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"areaId"]];
            user.brokerage=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"brokerage"]];
            user.code=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"code"]];
            user.explain=[userDict objectForKey:@"explain"];
            user.headImage=[userDict objectForKey:@"headimg"];
            user.userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
            user.username=[userDict objectForKey:@"name"];
            user.nickname=[userDict objectForKey:@"nickname"];
            user.acceptAddress=[userDict objectForKey:@"receiptInfoName"];
            user.sex=[userDict objectForKey:@"sex"];
            user.sign=[userDict objectForKey:@"sign"];
            user.token=[userDict objectForKey:@"token"];
            user.userMoney=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"userMoney"]];
            user.xqId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"xqId"]];
            user.ylCardNo=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylCardNo"]];
            user.ylPayPass=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylPayPass"]];
            user.referrer=[userDict objectForKey:@"referrer"];
            
            [UserInfoData saveUserInfoWithUser:user];
        }
        else
        {
            user.msg=[responseObject objectForKey:@"msg"];
        }
        
        complete(user);
        
        NSLog(@"判断是否是第一次第三方登录===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断是否是第一次第三方登录失败====%@",error.localizedDescription);
    }];
}

/**
 *  首次第三方登录请求
 */
+(void)firstThirdLoginWithNickname:(NSString*)nickname name:(NSString*)name img:(NSString*)img areaId:(NSString*)areaId xqId:(NSString*)xqId phone:(NSString*)phone payPassword:(NSString*)payPassword complete:(void(^)(User *user))complete
{
    NSString *url=[self getUrlWithString:@"user/ThirdLogin.api"];
    NSDictionary *parameters = @{@"nickname":nickname,@"name":name,@"img":img,@"areaId":areaId,@"xqId":xqId,@"phone":phone,@"passWord":payPassword};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        User *user=[User user];
        user.result=[responseObject objectForKey:@"result"];
        if ([user.result isEqualToString:STATUS_SUCCESS])
        {
            user.areaName=[responseObject objectForKey:@"areaName"];
            user.smaAreaName=[responseObject objectForKey:@"smaAreaName"];
            user.isMerchant=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"isMerchant"]];
            user.ylToken=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ylToken"]];
            user.status=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
            
            NSDictionary *userDict=[responseObject objectForKey:@"user"];
            user.address=[userDict objectForKey:@"address"];
            user.areaId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"areaId"]];
            user.brokerage=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"brokerage"]];
            user.code=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"code"]];
            user.explain=[userDict objectForKey:@"explain"];
            user.headImage=[userDict objectForKey:@"headimg"];
            user.userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
            user.username=[userDict objectForKey:@"name"];
            user.nickname=[userDict objectForKey:@"nickname"];
            user.acceptAddress=[userDict objectForKey:@"receiptInfoName"];
            user.sex=[userDict objectForKey:@"sex"];
            user.sign=[userDict objectForKey:@"sign"];
            user.token=[userDict objectForKey:@"token"];
            user.userMoney=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"userMoney"]];
            user.xqId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"xqId"]];
            user.ylCardNo=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylCardNo"]];
            user.ylPayPass=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"ylPayPass"]];
            user.referrer=[userDict objectForKey:@"referrer"];
            
            [UserInfoData saveUserInfoWithUser:user];
        }
        else
        {
            user.msg=[responseObject objectForKey:@"msg"];
        }
        
        complete(user);
        
        NSLog(@"首次第三方登录请求===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"首次第三方登录请求失败====%@",error.localizedDescription);
    }];
}

/**
 *  反馈意见
 */
+(void)addSuggestionWithUserId:(NSString*)userId content:(NSString*)content complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/addFeedback.api"];
    NSDictionary *parameters = @{@"userId":userId,@"content":content};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"反馈意见===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"反馈意见失败====%@",error.localizedDescription);
    }];
}

/**
 *  申请开放社区
 */
+(void)applyAreaWithUserId:(NSString*)userId content:(NSString*)content complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/applyArea.api"];
    NSDictionary *parameters = @{@"userId":userId,@"content":content};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"申请开放社区===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"申请开放社区失败====%@",error.localizedDescription);
    }];
}

/**
 *  扫码成为会员
 */
+(void)becomeMemberWithUserId:(NSString*)userId code:(NSString*)code complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/addMyUser.api"];
    NSDictionary *parameters = @{@"userId":userId,@"code":code};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"扫码成为会员===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"扫码成为会员失败====%@",error.localizedDescription);
    }];
}

/**
 *  获取广告详情
 */
+(void)getAdDetailWithAdid:(NSString*)adId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"share/loadAd.api"];
    NSDictionary *parameters = @{@"id":adId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取广告详情===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取广告详情失败====%@",error);
    }];
}

/**
 *  添加打电话次数
 */
+(void)addCallNumberWithStoreId:(NSString*)storeId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/updCallNum.api"];
    NSDictionary *parameters = @{@"storeId":storeId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"添加打电话次数===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"添加打电话次数失败====%@",error);
    }];
}

/**
 *  开启关闭远程推送
 */
+(void)ifReceiveRemoteNotificationsWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/isPush.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"开启关闭远程推送===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"开启关闭远程推送失败====%@",error);
    }];
}

/**
 *  忘记密码
 */
+(void)forgotPswWithName:(NSString*)name password:(NSString*)password complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/forgetPWD.api"];
    NSDictionary *parameters = @{@"name":name,@"password":password};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"忘记密码===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"忘记密码修改失败====%@",error);
    }];
}

/**
 *  充值模式
 */
+(void)rechargeModeWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"pay/rechCard.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取充值模式===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取充值模式失败====%@",error);
    }];
}

/**
 *  删除系统消息、评论消息、点赞消息
 */
+(void)deleteMessageWithIds:(NSString*)ids complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/delMyMessage.api"];
    NSDictionary *parameters = @{@"ids":ids};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"删除消息===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"删除消息失败====%@",error);
    }];
}

/**
 *  判断商户是否存在
 */
+(void)ifMerchantExistWithUserId:(NSString*)userId phone:(NSString*)phone complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/isMerchant.api"];
    NSDictionary *parameters = @{@"userId":userId,@"phone":phone};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"判断商户是否存在===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断商户是否存在失败====%@",error);
    }];
}

/**
 *  判断用户是否存在
 */
+(void)ifUserExistWithPhone:(NSString*)phone complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/isUser.api"];
    NSDictionary *parameters = @{@"phone":phone};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"判断用户是否存在===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断用户是否存在失败====%@",error);
    }];
}

/**
 *  判断用户支付密码是否存在 第三方登录state为1的情况
 */
+(void)ifPayPassword01ExistWithPassword:(NSString*)password phone:(NSString*)phone token:(NSString*)token complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/isAPPUserPass.api"];
    NSDictionary *parameters=@{@"password":password,@"phone":phone,@"thirdToken":token};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        User *user=[User user];
        user.result=[responseObject objectForKey:@"result"];
        if ([user.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *userDict=[responseObject objectForKey:@"user"];
            user.address=[userDict objectForKey:@"address"];
            user.areaId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"areaId"]];
            user.brokerage=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"brokerage"]];
            user.code=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"code"]];
            user.explain=[userDict objectForKey:@"explain"];
            user.headImage=[userDict objectForKey:@"headimg"];
            user.userId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"id"]];
            user.isPush=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"isPush"]];
            user.merchantId=[NSString stringWithFormat:@"%@",[userDict objectForKey:@"merId"]];
            user.username=[userDict objectForKey:@"name"];
            user.nickname=[userDict objectForKey:@"nickname"];
            user.password=password;
            user.acceptAddress=[userDict objectForKey:@"receiptInfoName"];
            user.sex=[userDict objectForKey:@"sex"];
            user.sign=[userDict objectForKey:@"sign"];
            user.token=[userDict objectForKey:@"token"];
            user.areaName=[responseObject objectForKey:@"areaName"];
            user.smaAreaName=[responseObject objectForKey:@"smaAreaName"];
            user.referrer=[userDict objectForKey:@"referrer"];
            
            [UserInfoData saveUserInfoWithUser:user];
            
        }
        
        complete(responseObject);
        
        NSLog(@"判断用户支付密码是否存在（state=1）===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断用户支付密码是否存在（state=1）====%@",error);
    }];
}

/**
 *  判断用户支付密码是否存在 第三方登录state为2的情况
 */
+(void)ifPayPassword02ExistWithPassword:(NSString*)password phone:(NSString*)phone token:(NSString*)token complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/isUserPass.api"];
    NSDictionary *parameters;
    if ([token isEqualToString:@""])
    {
        parameters=@{@"password":password,@"phone":phone};
    }
    else
    {
        parameters=@{@"password":password,@"phone":phone,@"thirdToken":token};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"判断用户支付密码是否存在（state=2）===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断用户支付密码是否存在（state=2）====%@",error);
    }];
}

/**
 *  判断当前用户是否已添加商户 isMerchant:0 无审核 1审核中 2审核通过 3审核不通过
 */
+(void)ifAddStoreWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/isMerchant.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"判断当前用户是否已添加商户===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断当前用户是否已添加商户失败====%@",error);
    }];
}

/**
 *  修改支付密码
 */
+(void)changePayPasswordWithUserId:(NSString*)userId oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/changePass.api"];
    NSDictionary *parameters = @{@"userId":userId,@"oldPass":oldPassword,@"newPass":newPassword};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"修改支付密码===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"修改支付密码失败====%@",error);
    }];
}

/**
 *  修改用户注册小区
 */
+(void)changeUserCommunityWithUserId:(NSString*)userId areaId:(NSString*)areaId xqId:(NSString*)xqId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/chang.api"];
    NSDictionary *parameters = @{@"userId":userId,@"areaId":areaId,@"xqId":xqId};
    
    NSLog(@"用户id===%@\n片区id===%@\n小区id===%@",userId,areaId,xqId);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"修改用户注册小区===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"修改用户注册小区失败====%@",error);
    }];
    
}

/**
 *  发帖界面获取栏目
 */
+(void)getLanmuDataWithFatherId:(NSString*)fatherId WithUrl:(NSString *)url complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url1=[self getUrlWithString:url];
    NSDictionary *parameters;
     if (fatherId) {
    if ([url containsString:@"getModuleListOfShareArticle"]) {
       
        parameters = @{@"id":fatherId};
        
    }else{
        parameters = @{@"fatherId":fatherId};
    }
}
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url1 parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"发帖界面获取栏目===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"发帖界面获取栏目失败====%@",error);
    }];
}

/**
 *  佣金明细
 */
+(void)getYongJinRecordsWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"userCenter/myYJrecord.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"佣金明细===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取佣金明细失败====%@",error);
    }];
}

/**
 *  小红点更新
 */
+(void)hongdianWithUserId:(NSString*)userId moduleId:(NSString*)moduleId areaId:(NSString*)areaId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/indexIn.api"];
    NSDictionary *parameters = @{@"userId":userId,@"moduleId":moduleId,@"areaId":areaId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"小红点更新===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"小红点更新失败====%@",error);
    }];
}

/**
 *  获取付款码
 */
+(void)getPayQRCodeWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/createQRcode.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取付款码===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取付款码失败====%@",error);
    }];
}

/**
 *  扫码付款
 */
+(void)scanQRCodePayWithUserId:(NSString*)userId merId:(NSString*)merId termId:(NSString*)termId money:(NSString*)money sfMoney:(NSString*)sfMoney ymlPayPass:(NSString*)ymlPayPass complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/payOrderByQRcode.api"];
    NSDictionary *parameters = @{@"userId":userId,@"merId":merId,@"termId":termId,@"money":money,@"sfMoney":sfMoney,@"ymlPayPass":ymlPayPass};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"扫码付款===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"扫码付款失败====%@",error);
    }];
}

/**
 *  获取商户名
 */
+(void)getStoreNameWithMerId:(NSString*)merId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/getMerName.api"];
    NSDictionary *parameters = @{@"merId":merId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取商户名===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取商户名失败====%@",error);
    }];
}

/**
 *  根据商户号(支付系统商户id)获取商户优惠
 */
+(void)getMerStoreDiscountWithUserId:(NSString*)userId merId:(NSString*)merId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/getMerDiscount.api"];
    NSDictionary *parameters = @{@"userId":userId,@"merId":merId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"根据商户号获取商户优惠===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"根据商户号获取商户优惠失败====%@",error);
    }];
}

/**
 *  根据本地商户id获取商户优惠
 */
+(void)getMerStoreDiscountWithMerId:(NSString*)merId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"order/getMerDiscount.api"];
    NSDictionary *parameters = @{@"merId":merId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"根据本地商户id获取商户优惠===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"根据本地商户id获取商户优惠失败====%@",error);
    }];
}

/**
 *  获取支付端商户资料
 */
+(void)getMerStoreInfoWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/getMerchant.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取支付端商户资料===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取支付端商户资料失败====%@",error);
    }];
    
}

/**
 *  修改支付端商户资料
 */
+(void)changeMerStoreInfoWithUserId:(NSString*)userId changeDict:(NSMutableDictionary*)changeDict complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/updateMerchant.api"];
    
    NSString *shmc=[changeDict objectForKey:@"shmc"];
    NSString *lxr=[changeDict objectForKey:@"lxr"];
    NSString *lxdh=[changeDict objectForKey:@"lxdh"];
    NSString *ylhid=[changeDict objectForKey:@"ylhid"];
    NSString *dz=[changeDict objectForKey:@"dz"];
    NSString *jyfw=[changeDict objectForKey:@"jyfw"];
    NSString *ghfs=[changeDict objectForKey:@"ghfs"];
    NSString *ghgxl=[changeDict objectForKey:@"ghgxl"];
    NSString *zjrxm=[changeDict objectForKey:@"zjrxm"];
    NSString *zjhm=[changeDict objectForKey:@"zjhm"];
    NSString *frsjhm=[changeDict objectForKey:@"frsjhm"];
    NSString *khyhjzh=[changeDict objectForKey:@"khyhjzh"];
    NSString *khhh=[changeDict objectForKey:@"khhh"];
    NSString *sfsh=[changeDict objectForKey:@"sfsh"];
    NSString *khmc=[changeDict objectForKey:@"khmc"];
    NSString *khzh=[changeDict objectForKey:@"khzh"];
    NSString *yyzzh=[changeDict objectForKey:@"yyzzh"];
    NSString *yyzzszd=[changeDict objectForKey:@"yyzzszd"];
    NSString *yyqx=[changeDict objectForKey:@"yyqx"];
    NSString *zzjgdm=[changeDict objectForKey:@"zzjgdm"];
    NSString *khxkzh=[changeDict objectForKey:@"khxkzh"];
    NSString *swdjzh=[changeDict objectForKey:@"swdjzh"];
    NSString *sfkp=[changeDict objectForKey:@"sfkp"];
    NSString *token=[changeDict objectForKey:@"token"];
    NSString *merId=[changeDict objectForKey:@"merId"];
    
    NSDictionary *parameters = @{@"userId":userId,@"name":shmc,@"conPerName":lxr,@"conPerTeleNo":lxdh,@"ylhId":ylhid,@"address":dz,@"bscope":jyfw,@"supplyType":ghfs,@"rakeRate":ghgxl,@"lgName":zjrxm,@"lgIdcard":zjhm,@"lgTelephone":frsjhm,@"bankName":khyhjzh,@"bankLineNum":khhh,@"isPrivate":sfsh,@"bankUser":khmc,@"bankAccountNo":khzh,@"bnumber":yyzzh,@"blicenceAddr":yyzzszd,@"openLimit":yyqx,@"orgCode":zzjgdm,@"knumber":khxkzh,@"snumber":swdjzh,@"isInvoice":sfkp,@"token":token,@"merId":merId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"修改支付端商户资料===%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"修改支付端商户资料失败====%@",error.localizedDescription);
    }];
}

/**
 *  获取支付端用户资料
 */
+(void)getMerUserInfoWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/getMemInfoByIos.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取支付端用户资料===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取支付端用户资料失败====%@",error);
    }];
}

/**
 *  修改支付端用户资料 1.身份证 2.军官证 3.护照
 */
+(void)changeMerUserInfoWithUserId:(NSString*)userId phone:(NSString*)phone email:(NSString*)email name:(NSString*)name  personType:(NSString*)personType personId:(NSString*)personId sex:(NSString*)sex birthday:(NSString*)birthday areaId:(NSString*)areaId address:(NSString*)address tjPhone:(NSString*)tjPhone ylhId:(NSString*)ylhId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/updateMemInfoByIos.api"];
    NSDictionary *parameters = @{@"userId":userId,@"phone":phone,@"email":email,@"name":name,@"personType":personType,@"personId":personId,@"sex":sex,@"birthDay":birthday,@"areaId":areaId,@"address":address,@"tjPhone":tjPhone,@"ylhId":ylhId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"修改支付端用户资料===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"修改支付端用户资料失败====%@",error);
    }];
}

/**
 *  商户提现
 */
+(void)getStoreMoneyWithUserId:(NSString*)userId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"index/doDrawals.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"商户提现===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"商户提现失败====%@",error);
    }];
}

/**
 *  客服热线
 */
+(void)getHotLines:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/cusPhone.api"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"客服热线===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取客服热线失败====%@",error);
    }];
}

/**
 *  外部链接
 */
+(void)getMoreUrl:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"user/getUrlList.api"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"外部链接===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取外部链接失败====%@",error);
    }];
}


/**
 *  社区二期接口
 */

/**
 *  获取邻里圈文章列表
 */
+(void)getNearbySquareListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize areaId:(NSString*)areaId complete:(void(^)(Model *model))complete
{
    NSString *url=[self getUrlWithString:@"v2/allArticleByAppUser.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize,@"areaId":areaId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        Model *model=[[Model alloc]init];
        model.result=[responseObject objectForKey:@"result"];
        
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[responseObject objectForKey:@"moduleList"];
            model.articleListArray=[[listDict objectForKey:@"data"] mutableCopy];
            model.pageNum=[listDict objectForKey:@"pageNum"];
            model.pageSize=[listDict objectForKey:@"pageSize"];
            model.totalItems=[listDict objectForKey:@"totalItems"];
            model.totalPages=[listDict objectForKey:@"totalPages"];
            
            complete(model);
        }
        else
        {
            model.error=[responseObject objectForKey:@"msg"];
            complete(model);
        }
        
        
//        NSLog(@"获取邻里圈文章列表===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取邻里圈文章列表失败====%@",error);
    }];
}

/**
 *  一对一发红包
 */
+(void)sendRedEnvelopeOneToOneWithUserId:(NSString*)userId money:(NSString*)money toPhone:(NSString*)toPhone theme:(NSString*)theme password:(NSString*)password payType:(NSString*)payType type:(NSString*)type  objId:(NSString*)objId complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/sendOneToOnePacket_v3.api"];
    if (!type) {
        type = @"0";
    }
    if (!objId) {
        objId = @"0";
    }
    NSDictionary *parameters = @{@"userId":userId,@"money":money,@"toPhone":toPhone,@"theme":theme,@"password":password,@"payType":payType,@"type":type,@"objId":objId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"一对一发红包===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"一对一发红包失败====%@",error);
    }];
    
}

/**
 *  拆红包
 */
+(void)openRedEnvelopeWithUserId:(NSString*)userId packetId:(NSString*)packetId type:(NSString*)type complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/openPacket.api"];
    NSDictionary *parameters = @{@"userId":userId,@"packetId":packetId,@"type":type};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"拆红包===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"拆红包失败====%@",error);
    }];
}

/**
 *  获取红包列表
 */
+(void)getRedEnvelopeListWithUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSMutableArray *listArray))complete
{
    NSString *url=[self getUrlWithString:@"v2/userPacketList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result=[responseObject objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *listDict=[responseObject objectForKey:@"list"];
            NSMutableArray *listArray=[[listDict objectForKey:@"data"] mutableCopy];
            complete(listArray);
        }else{
            complete(nil);
        }
        
        //NSLog(@"获取红包列表===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         complete(nil);
        NSLog(@"获取红包列表失败====%@",error);
    }];
    
    
}

/**
 *  获取后台红包详情
 */
+(void)getBackstageRedEnvelopeDetailWithUserId:(NSString *)userId redId:(NSString *)redId complete:(void (^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/packetInfo.api"];
    NSDictionary *parameters = @{@"userId":userId,@"id":redId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取后台红包详情===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        complete(nil);
        NSLog(@"获取后台红包详情失败====%@",error);
    }];
}

/**
 *  发出的红包记录
 */
+(void)sendRedEnvelopeListUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/userOutPacketList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSString *result=[responseObject objectForKey:@"result"];
//        if ([result isEqualToString:STATUS_SUCCESS])
//        {
//            NSDictionary *listDict=[responseObject objectForKey:@"list"];
//            NSMutableArray *listArray=[[listDict objectForKey:@"data"] mutableCopy];
//            complete(listArray);
//        }
        
        complete(responseObject);
        
        NSLog(@"获取发出的红包记录===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取发出的红包记录失败====%@",error);
    }];
}

/**
 *  收到的红包记录
 */
+(void)ReceivedRedEnvelopeListUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/userInPacketList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取收到的红包记录===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取收到的红包记录失败====%@",error);
    }];
}
/**
 *  红包退款明细记录
 */
+(void)ReceivedRedEnvelopeRefundDetailsUserId:(NSString*)userId pageNum:(NSString*)pageNum pageSize:(NSString*)pageSize complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/userTKPacketList.api"];
    NSDictionary *parameters = @{@"userId":userId,@"pageNum":pageNum,@"pageSize":pageSize};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取红包退款明细记录===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取红包退款明细失败====%@",error);
    }];
}
/**
 *  邻里圈获取地区
 */
+(void)getAreaAddressWithUserId:(NSString *)userId complete:(void (^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/userInfo.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"邻里圈获取地区===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"邻里圈获取地区失败====%@",error);
    }];
}

/**
 *  保存设备号
 */
+(void)uploadDeviceTokenUserId:(NSString*)userId jgCode:(NSString*)jgCode complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/setUserJgCode.api"];
    
    if (userId==nil)
    {
        userId=@"";
    }
    if (jgCode==nil)
    {
        jgCode=@"";
    }
    
    NSDictionary *parameters = @{@"userId":userId,@"jgCode":jgCode};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"保存设备号===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"保存设备号失败====%@",error);
    }];
}

/**
 *  判断用户支付密码是否和登录密码相同
 */
+(void)ifPayPswEqualLoginPswWithPhone:(NSString*)phone pwd:(NSString*)pwd complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/loginPwdeqPayPwd.api"];
    
    NSDictionary *parameters = @{@"phone":phone==nil?@"":phone,@"pwd":pwd==nil?@"":pwd};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"判断用户支付密码是否和登录密码相同===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"判断用户支付密码是否和登录密码相同失败====%@",error);
    }];
}

/**
 *  是否收到新红包
 */
+(void)ifReceiveNewRedEnvelopeWithUserId:(NSString *)userId complete:(void (^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/packetRemind.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"是否收到新红包===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"是否收到新红包失败====%@",error);
    }];
}

/**
 *  获取一对一发红包的所需参数
 */
+(void)getParameterOfRedEnvelopeWithUserId:(NSString *)userId complete:(void (^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/oneTooneParam.api"];
    NSDictionary *parameters = @{@"userId":userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"获取一对一发红包的所需参数===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"获取一对一发红包的所需参数失败====%@",error);
    }];
}

/**
 *  验证发红包时对方手机号是否已注册
 */
+(void)ifUserMobileExistWithPhone:(NSString*)phone complete:(void(^)(NSDictionary *resultDict))complete
{
    NSString *url=[self getUrlWithString:@"v2/hasUser.api"];
    NSDictionary *parameters = @{@"name":phone};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        complete(responseObject);
        
        NSLog(@"验证发红包时对方手机号是否已注册===%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"验证发红包时对方手机号是否已注册失败====%@",error);
    }];
}















@end
