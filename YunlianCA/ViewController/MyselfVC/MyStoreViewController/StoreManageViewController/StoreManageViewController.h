//
//  StoreManageViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

@interface StoreManageViewController : ViewController

@property(nonatomic,assign)BOOL isCreateStoreVC;
@property(nonatomic,assign)BOOL isMyStoreVC;

@property(nonatomic,strong)NSString *storeId;
@property(nonatomic,strong)NSString *lanmu;
@property(nonatomic,strong)NSString *erjilanmu;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)UIImage *storeIcon;
@property(nonatomic,strong)NSString *storeIconUrl;
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,strong)NSString *openTime;
@property(nonatomic,strong)NSString *storeDes;
@property(nonatomic,strong)NSMutableArray *storeImages;
@property(nonatomic,strong)NSMutableArray *storeImagesUrl;
@property(nonatomic,strong)NSString *storeAddress;
@property(nonatomic,strong)NSString *storeMobile;
@property(nonatomic,strong)NSString *storeContact;
@property(nonatomic,strong)NSString *moduleId;
@property(nonatomic,strong)NSString *longitudeString;
@property(nonatomic,strong)NSString *latitudeString;
//@property(nonatomic,strong)NSString *areaId;












@end
