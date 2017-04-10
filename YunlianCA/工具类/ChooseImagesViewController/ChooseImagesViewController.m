//
//  ChooseImagesViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/13.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "ChooseImagesViewController.h"

@interface ChooseImagesViewController ()

@end

@implementation ChooseImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor=COLOR_WHITE;
    [self.view.window addSubview:bgView];
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = self.maxNumImage;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)dismissImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    //    NSLog(@"*** imagePickerController:didSelectAsset:");
    //    NSLog(@"%@", asset);
    
    [self dismissImagePickerController];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets withChoose:(BOOL)isChoose
{
    
    NSMutableArray*mulArray=[NSMutableArray array];
    
    //    NSLog(@"666666*** imagePickerController:didSelectAssets:");
    //    NSLog(@"99999999%@", assets);
    for (int i=0; i<assets.count; i++)
    {
        ALAssetRepresentation *assetRep = [assets[i] defaultRepresentation];
        CGImageRef imgRef = [assetRep fullResolutionImage];
        UIImage *img = [UIImage imageWithCGImage:imgRef
                                           scale:assetRep.scale
                                     orientation:(UIImageOrientation)assetRep.orientation];
        
        [mulArray insertObject:img atIndex:0];
        
    }
    
    if(self.delegate&&[self.delegate respondsToSelector:@selector(withImageArray:withIsChoose:)])
    {
        [self.delegate withImageArray:mulArray withIsChoose:isChoose];
    }
    
    
    
    
    [self dismissImagePickerController];
    [self.navigationController popViewControllerAnimated:NO];
    
    
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"*** imagePickerControllerDidCancel:");
    
    [self dismissImagePickerController];
    [self.navigationController popViewControllerAnimated:NO];
}































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
