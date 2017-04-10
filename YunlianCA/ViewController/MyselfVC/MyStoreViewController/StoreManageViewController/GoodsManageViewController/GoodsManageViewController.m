//
//  GoodsManageViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/6/22.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "GoodsManageViewController.h"

#import "AddGoodsViewController.h"
#import "GoodsManageCell.h"
#import "GoodsDetailViewController.h"

@interface GoodsManageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    
}

@property(nonatomic,strong)StoreModel *goodsModel;
@property(nonatomic,strong)NSDictionary *deleteDict;

@end

@implementation GoodsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBar];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    self.storeId=[NSString stringWithFormat:@"%@",self.storeId];
    [HTTPManager getGoodsInStoreDetailInfoWithStoreId:self.storeId pageNum:@"1" pageSize:@"20" complete:^(StoreModel *model) {
        self.goodsModel=model;
        if ([model.result isEqualToString:STATUS_SUCCESS])
        {
            if (self.goodsModel.goodsArray.count>0)
            {
                [self createTableView];
            }
            else
            {
                UILabel *noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(200), SCREEN_WIDTH-WZ(15*2), WZ(30))];
                noticeLabel.text=@"空空如也，快去添加吧~~~";
                noticeLabel.font=FONT(17, 15);
                noticeLabel.textAlignment=NSTextAlignmentCenter;
                noticeLabel.textColor=COLOR_LIGHTGRAY;
                [self.view addSubview:noticeLabel];
            }
        }
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WZ(60), WZ(10), SCREEN_WIDTH-WZ(60*2), WZ(30))];
    titleLabel.font=FONT(19,17);
    titleLabel.text=@"商品管理";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleLabel;
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(40), WZ(30))];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
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
    return self.goodsModel.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"GoodsManageCell";
    GoodsManageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell=[[GoodsManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *goodsDict=self.goodsModel.goodsArray[indexPath.row];
//    NSString *createtime=[goodsDict objectForKey:@"createtime"];
//    NSString *explain=[goodsDict objectForKey:@"explain"];
//    NSString *goodsId=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"id"]];
    NSString *goodsIcon=[goodsDict objectForKey:@"img"];
    NSString *goodsName=[goodsDict objectForKey:@"name"];
//    NSString *price=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"price"]];
    NSString *priceZH=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"priceZH"]];
    NSString *repertory=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"repertory"]];
    NSString *sales=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"sales"]];
//    NSString *storeId=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"storeId"]];
//    NSString *userId=[NSString stringWithFormat:@"%@",[goodsDict objectForKey:@"userId"]];
    
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOSTIMAGE,goodsIcon]] placeholderImage:IMAGE(@"morentupian")];
    cell.nameLabel.text=goodsName;
    cell.priceLabel.text=[NSString stringWithFormat:@"¥ %@",priceZH];
    cell.priceLabel.textColor=COLOR_ORANGE;
    
    NSString *salesString=[NSString stringWithFormat:@"销量 %@单",sales];
    CGSize xlSize=[ViewController sizeWithString:salesString font:FONT(11,9) maxSize:CGSizeMake(WZ(120), WZ(14))];
    cell.xlLabel.frame=CGRectMake(cell.nameLabel.left, cell.priceLabel.bottom, xlSize.width, WZ(14));
    cell.xlLabel.text=salesString;
    
    NSString *repertoryString=[NSString stringWithFormat:@"库存：%@",repertory];
    CGSize kcSize=[ViewController sizeWithString:repertoryString font:FONT(11,9) maxSize:CGSizeMake(WZ(120), WZ(14))];
    cell.kcLabel.frame=CGRectMake(cell.xlLabel.right+WZ(15), cell.priceLabel.bottom, kcSize.width, WZ(14));
    cell.kcLabel.text=repertoryString;
    
    cell.deleteBtn.goodsDict=goodsDict;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark ===UITableViewDelegate===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *goodsDict=self.goodsModel.goodsArray[indexPath.row];
    NSString *goodsId=[goodsDict objectForKey:@"id"];
    //NSString *storeId=[goodsDict objectForKey:@"storeId"];
    //跳转商品详情界面
    GoodsDetailViewController *vc=[[GoodsDetailViewController alloc]init];
    vc.goodsId=goodsId;
    vc.storeId=self.storeId;
    [self.navigationController pushViewController:vc animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(15))];
    titleView.backgroundColor=COLOR_HEADVIEW;
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WZ(80+45);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return WZ(15);
}


#pragma mark ===buttonClick===
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加商品
-(void)rightBtnClick
{
    NSLog(@"添加商品");
    AddGoodsViewController *vc=[[AddGoodsViewController alloc]init];
    vc.storeId=self.storeId;
    [self.navigationController pushViewController:vc animated:YES];
}

//删除商品
-(void)deleteBtnClick:(GoodsDeleteBtn*)deleteBtn
{
    self.deleteDict=deleteBtn.goodsDict;
//    NSString *goodsId=[NSString stringWithFormat:@"%@",[deleteBtn.goodsDict objectForKey:@"id"]];
    NSString *goodsName=[deleteBtn.goodsDict objectForKey:@"name"];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否删除 %@？",goodsName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSString *goodsId=[NSString stringWithFormat:@"%@",[self.deleteDict objectForKey:@"id"]];
        NSString *goodsName=[self.deleteDict objectForKey:@"name"];
        //删除商品
        [HTTPManager deleteGoodsWithIds:goodsId complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                [self.goodsModel.goodsArray removeObject:self.deleteDict];
                [_tableView reloadData];
                [self.view makeToast:[NSString stringWithFormat:@"已删除 %@",goodsName] duration:1.0];
            }
            else
            {
                [self.view makeToast:[NSString stringWithFormat:@"删除%@失败，请重试",goodsName] duration:1.0];
            }
        }];
    }
}


////编辑商品
//-(void)editBtnClick
//{
//    
//    
//    
//    
//}










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
