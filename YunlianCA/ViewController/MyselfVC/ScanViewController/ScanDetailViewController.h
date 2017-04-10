//
//  ScanDetailViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/9/8.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"

@interface ScanDetailViewController : ViewController

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,assign)BOOL isMyUrlVC;
@property(nonatomic,assign)BOOL isKuaiqian;
@property(nonatomic,strong)NSString *html;

@end
