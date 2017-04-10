//
//  RegisterViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/6.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"
typedef void(^registerSuccessBlock) (NSString * ,NSString * );
@interface RegisterViewController : ViewController

//@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,copy)registerSuccessBlock block;
//@property(nonatomic,strong)NSString *password;


@end
