//
//  ChooseImagesViewController.h
//  YunlianCA
//
//  Created by QinJun on 16/6/13.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ViewController.h"


@protocol ChooseImagesDelegate <NSObject>

@optional

-(void)withImageArray:(NSMutableArray*)imageArray withIsChoose:(BOOL)isChoose;

@end


@interface ChooseImagesViewController : ViewController<QBImagePickerControllerDelegate>

@property(nonatomic,strong)NSMutableArray*photosArray;
@property(nonatomic,assign)NSInteger maxNumImage;

@property(nonatomic,weak)id<ChooseImagesDelegate>delegate;







@end
