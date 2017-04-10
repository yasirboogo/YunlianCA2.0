//
//  SquareViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

@interface SquareViewController : ViewController

//是否从邻里圈里来
@property(nonatomic,assign)BOOL isNearbyVC;
@property(nonatomic,strong)NSString *nearbyAreaId;
@property(nonatomic,strong)NSString *nearbyAreaName;


@end
