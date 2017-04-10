//
//  CreateGroupViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/2.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "CreateGroupViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "RCConversationDetailsVC.h"


@interface CreateGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    
    
}

@property(nonatomic,strong)UIImageView *groupIV;
@property(nonatomic,strong)UITextField *groupNameTF;
@property(nonatomic,strong)UITextField *groupDesTF;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *groupDes;
@property(nonatomic,strong)UIImage *groupImage;
@property(nonatomic,strong)NSData *groupImageData;



@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupName=@"";
    self.groupDes=@"";
    
    
    [self createNavigationBar];
    [self createTableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
}

-(void)createNavigationBar
{
    self.title=@"创建群";
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(40), WZ(30))];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font=FONT(17, 15);
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}

#pragma mark ===UITableViewDataSource===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    NSArray *titleArray=[[NSArray alloc]initWithObjects:@"群头像",@"群名称",@"群简介", nil];
    cell.textLabel.text=titleArray[indexPath.row];
    
    if (indexPath.row==0)
    {
        UIImageView *groupIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+10+10)-WZ(50), WZ(10), WZ(50), WZ(50))];
        groupIV.clipsToBounds=YES;
        groupIV.layer.cornerRadius=groupIV.width/2.0;
        [cell.contentView addSubview:groupIV];
        self.groupIV=groupIV;
        
        if (self.groupImage==nil)
        {
            groupIV.image=IMAGE(@"tabbar_wode_nor");
        }
        else
        {
            groupIV.image=self.groupImage;
        }
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==1)
    {
        UITextField *groupNameTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(90), WZ(10), SCREEN_WIDTH-WZ(15*2+10)-WZ(65), WZ(30))];
        groupNameTF.delegate=self;
        groupNameTF.text=self.groupName;
        groupNameTF.textColor=COLOR_LIGHTGRAY;
        groupNameTF.font=FONT(15,13);
        groupNameTF.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:groupNameTF];
        self.groupNameTF=groupNameTF;
    }
    if (indexPath.row==2)
    {
        UITextField *groupDesTF=[[UITextField alloc]initWithFrame:CGRectMake(WZ(90), WZ(10), SCREEN_WIDTH-WZ(15*2+10)-WZ(65), WZ(30))];
        groupDesTF.delegate=self;
        groupDesTF.text=self.groupDes;
        groupDesTF.textColor=COLOR_LIGHTGRAY;
        groupDesTF.font=FONT(15,13);
        groupDesTF.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:groupDesTF];
        self.groupDesTF=groupDesTF;
    }
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        //选择头像
        [self changeHeadImage];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return WZ(75);
    }
    else
    {
        return WZ(50);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.groupNameTF)
    {
        self.groupName=textField.text;
    }
    if (textField==self.groupDesTF)
    {
        self.groupDes=textField.text;
    }
}









#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//创建群
-(void)rightBtnClick
{
    [self.groupNameTF resignFirstResponder];
    [self.groupDesTF resignFirstResponder];
    
    if (self.userIds==nil || [self.userIds isEqualToString:@""])
    {
        self.userIds=[UserInfoData getUserInfoFromArchive].userId;
    }
    
    if ([self.groupNameTF.text isEqualToString:@""] || self.groupNameTF.text==nil)
    {
        [self.view makeToast:@"请输入群名称" duration:2.0];
    } else {
        if ([self.groupDesTF.text isEqualToString:@""] || self.groupDesTF.text==nil)
        {
            [self.view makeToast:@"请输入群简介" duration:2.0];
        } else {
            self.groupName=[NSString stringWithFormat:@"[群]%@",self.groupName];
            
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"创建中..." detail:nil];
            [hud show:YES];
            [hud hide:YES afterDelay:20];
            [HTTPManager createGroupWithIds:self.userIds groupName:self.groupName logoImg:self.groupImageData groupDes:self.groupDesTF.text complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    NSDictionary *groupDict=[resultDict objectForKey:@"imGroup"];
                    NSString *groupId=[NSString stringWithFormat:@"%@",[groupDict objectForKey:@"id"]];
                    NSString *groupName=[groupDict objectForKey:@"name"];
                    
                    //跳转到群组聊天界面
                    RCConversationDetailsVC *conversationVC = [[RCConversationDetailsVC alloc]init];
                    conversationVC.conversationType=ConversationType_GROUP;
                    conversationVC.targetId = groupId;
                    conversationVC.title = groupName;
                    conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
                    conversationVC.enableUnreadMessageIcon=YES;
                    conversationVC.hidesBottomBarWhenPushed=YES;
                    conversationVC.isGroup=YES;
                    conversationVC.isCreateGroup=YES;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                }
                else
                {
                    [self.view makeToast:@"创建群失败，请重试。" duration:1.0];
                }
                [hud hide:YES];
            }];
        }
    }
    
    
    
    
}

#pragma mark ===点击更换头像的方法===
-(void)changeHeadImage
{
    NSLog(@"点击了选择群头像按钮");
    
    //弹出actionsheet。选择获取头像的方式
    //从相册获取图片
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"本地相册",nil];
    [actionSheet showInView:self.view];
}

#pragma mark ===UIActionSheet Delegate===
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        //相机
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = sourceType;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else
            {
                NSLog(@"模拟其中无法打开照相机,请在真机中使用");
            }
        }
            break;
            //本地相册
        case 1:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

//当选择一张图片后进入这里
#pragma mark ===UIImagePickerController Delegate===
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage])
    {
        self.groupImage = [info objectForKey:UIImagePickerControllerEditedImage];
        self.groupImageData = UIImageJPEGRepresentation(self.groupImage, 0.5f);
        self.groupIV.image=self.groupImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
