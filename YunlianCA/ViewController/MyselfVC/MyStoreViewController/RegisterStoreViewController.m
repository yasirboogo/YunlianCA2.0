//
//  RegisterStoreViewController.m
//  YunlianCA
//
//  Created by QinJun on 16/8/18.
//  Copyright © 2016年 QinJun. All rights reserved.
//

#import "RegisterStoreViewController.h"

#import "MyStoreViewController.h"
#import "MyselfViewController.h"

@interface RegisterStoreViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    
}

@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,strong)UIButton *ghfsBtn;
@property(nonatomic,strong)UIButton *sfshBtn;
@property(nonatomic,strong)UIButton *sfkpBtn;
@property(nonatomic,strong)UIButton *checkBtn;
@property(nonatomic,strong)UIButton *registerBtn;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *placeholderArray;
@property(nonatomic,strong)NSMutableArray *textFieldArray;

@property(nonatomic,strong)NSString *shmc;
@property(nonatomic,strong)NSString *lxr;
@property(nonatomic,strong)NSString *lxdh;
@property(nonatomic,strong)NSString *ylhid;
@property(nonatomic,strong)NSString *dz;
@property(nonatomic,strong)NSString *jyfw;
@property(nonatomic,strong)NSString *ghfs;
@property(nonatomic,strong)NSString *ghfs1;
@property(nonatomic,strong)NSString *ghgxl;
@property(nonatomic,strong)NSString *zjrxm;
@property(nonatomic,strong)NSString *zjhm;
@property(nonatomic,strong)NSString *frsjhm;
@property(nonatomic,strong)NSString *khyhjzh;
@property(nonatomic,strong)NSString *khhh;
@property(nonatomic,strong)NSString *sfsh;
@property(nonatomic,strong)NSString *sfsh1;
@property(nonatomic,strong)NSString *khmc;
@property(nonatomic,strong)NSString *khzh;
@property(nonatomic,strong)NSString *yyzzh;
@property(nonatomic,strong)NSString *yyzzszd;
@property(nonatomic,strong)NSString *yyqx;
@property(nonatomic,strong)NSString *zzjgdm;
@property(nonatomic,strong)NSString *khxkzh;
@property(nonatomic,strong)NSString *swdjzh;
@property(nonatomic,strong)NSString *sfkp;
@property(nonatomic,strong)NSString *sfkp1;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *merId;

@property(nonatomic,assign)BOOL isEdit;

@end

@implementation RegisterStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isMyselfInfoVC==YES)
    {
        self.isEdit=NO;
    }
    
    self.shmc=@"";
    self.lxr=@"";
    self.lxdh=[UserInfoData getUserInfoFromArchive].username;
    self.ylhid=@"";
    self.dz=@"";
    self.jyfw=@"";
    self.ghfs=@"1";
    self.ghfs1=@"纯折扣供货";
    self.ghgxl=@"";
    self.zjrxm=@"";
    self.zjhm=@"";
    self.frsjhm=@"";
    self.khyhjzh=@"";
    self.khhh=@"";
    self.sfsh=@"1";
    self.sfsh1=@"是";
    self.khmc=@"";
    self.khzh=@"";
    self.yyzzh=@"";
    self.yyzzszd=@"";
    self.yyqx=@"";
    self.zzjgdm=@"";
    self.khxkzh=@"";
    self.swdjzh=@"";
    self.sfkp=@"1";
    self.sfkp1=@"是";
    self.token=@"";
    self.merId=@"";
    self.merId=@"";
    self.textFieldArray=[NSMutableArray array];
    
    self.titleArray=[[NSArray alloc]initWithObjects:@"*商户名称",@"*联系人",@"*联系电话",@"云联惠ID",@"*地址",@"经营范围",@"*供货方式",@"*供货贡献率",@"*证件人姓名",@"*证件号码",@"*法人手机号码",@"*开户银行及支行",@"开户行号",@"*是否私户",@"*开户名称",@"*开户账号",@"营业执照号",@"营业执照所在地",@"营业期限",@"组织机构代码",@"开户许可证号",@"税务登记证号",@"是否开票", nil];
    self.placeholderArray=[[NSArray alloc]initWithObjects:@"请输入商户名称",@"请输入联系人姓名",@"请输入联系电话",@"请输入云联惠ID",@"请输入地址",@"请输入经营范围",@"",@"请输入供货贡献率",@"请输入证件人姓名",@"请输入证件号码",@"请输入法人手机号码",@"请输入开户银行及支行",@"请输入开户行号",@"",@"请输入开户名称",@"请输入开户账号",@"请输入营业执照号",@"请输入营业执照所在地",@"请输入营业期限",@"请输入组织机构代码",@"请输入开户许可证号",@"请输入税务登记证号",@"", nil];
    
    [self createNavigationBar];
    [self createScrollView];
    
    
    
}

//获取支付端商户资料
-(void)getMerStoreInfo
{
    MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"加载中..." detail:nil];
    [hud show:YES];
    [hud hide:YES afterDelay:20];
    [HTTPManager getMerStoreInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId complete:^(NSDictionary *resultDict) {
        NSString *result=[resultDict objectForKey:@"result"];
        if ([result isEqualToString:STATUS_SUCCESS])
        {
            NSDictionary *merchantDict=[resultDict objectForKey:@"merchant"];
            self.shmc=[merchantDict objectForKey:@"name"];
            self.lxr=[merchantDict objectForKey:@"conPerName"];
            self.lxdh=[merchantDict objectForKey:@"conPerTeleNo"];
            self.ylhid=[merchantDict objectForKey:@"ylhId"];
            self.dz=[merchantDict objectForKey:@"address"];
            self.jyfw=[merchantDict objectForKey:@"bscope"];
            self.ghfs=[merchantDict objectForKey:@"supplyType"];
            self.ghgxl=[merchantDict objectForKey:@"rakeRate"];
            self.zjrxm=[merchantDict objectForKey:@"lgName"];
            self.zjhm=[merchantDict objectForKey:@"lgIdcard"];
            self.frsjhm=[merchantDict objectForKey:@"lgTelephone"];
            self.khyhjzh=[merchantDict objectForKey:@"bankName"];
            self.khhh=[merchantDict objectForKey:@"bankLineNum"];
            self.sfsh=[merchantDict objectForKey:@"isPrivate"];
            self.khmc=[merchantDict objectForKey:@"bankUser"];
            self.khzh=[merchantDict objectForKey:@"bankAccountNo"];
            self.yyzzh=[merchantDict objectForKey:@"bnumber"];
            self.yyzzszd=[merchantDict objectForKey:@"blicenceAddr"];
            self.yyqx=[merchantDict objectForKey:@"openLimit"];
            self.zzjgdm=[merchantDict objectForKey:@"orgCode"];
            self.khxkzh=[merchantDict objectForKey:@"knumber"];
            self.swdjzh=[merchantDict objectForKey:@"snumber"];
            self.sfkp=[merchantDict objectForKey:@"isInvoice"];
            self.token=[merchantDict objectForKey:@"token"];
            self.merId=[merchantDict objectForKey:@"merId"];
            self.status=[merchantDict objectForKey:@"status"];
            
            if ([self.ghfs integerValue]==0)
            {
                self.ghfs1=@"无";
            }
            if ([self.ghfs integerValue]==1)
            {
                self.ghfs1=@"纯折扣供货";
            }
            if ([self.ghfs integerValue]==2)
            {
                self.ghfs1=@"云联惠返还25%供货";
            }
            
            if ([self.sfsh integerValue]==0)
            {
                self.sfsh1=@"否";
            }
            if ([self.sfsh integerValue]==1)
            {
                self.sfsh1=@"是";
            }
            
            if ([self.sfkp integerValue]==0)
            {
                self.sfkp1=@"否";
            }
            if ([self.sfkp integerValue]==1)
            {
                self.sfkp1=@"是";
            }
            
            if ([self.status integerValue]==1)
            {
                self.rightBtn.hidden=YES;
            }
            
            NSMutableArray *contentArray=[[NSMutableArray alloc]initWithObjects:self.shmc,self.lxr,self.lxdh,self.ylhid,self.dz,self.jyfw,self.ghgxl,self.zjrxm,self.zjhm,self.frsjhm,self.khyhjzh,self.khhh,self.khmc,self.khzh,self.yyzzh,self.yyzzszd,self.yyqx,self.zzjgdm,self.khxkzh,self.swdjzh,nil];
            
            for (NSInteger i=0; i<contentArray.count; i++)
            {
                UITextField *textField=self.textFieldArray[i];
                textField.text=contentArray[i];
            }
            
            [self.ghfsBtn setTitle:self.ghfs1 forState:UIControlStateNormal];
            [self.sfshBtn setTitle:self.sfsh1 forState:UIControlStateNormal];
            [self.sfkpBtn setTitle:self.sfkp1 forState:UIControlStateNormal];
            
        }
        else
        {
            NSString *msg=[resultDict objectForKey:@"msg"];
            [self.view.window makeToast:msg duration:2.0];
        }
        
        [hud hide:YES];
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_BLACK}];
    self.navigationController.navigationBar.barTintColor=COLOR_NAVIGATION;
    
    if (self.isMyselfInfoVC==YES)
    {
        [self getMerStoreInfo];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FONT(19,17),NSForegroundColorAttributeName:COLOR_WHITE}];
    self.navigationController.navigationBar.barTintColor=COLOR(255, 63, 94, 1);
}

-(void)createNavigationBar
{
    if (self.isMyselfInfoVC==YES)
    {
        self.title=@"商户资料";
        
        
        UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+40), WZ(10), WZ(40), WZ(30))];
        [rightBtn setTitleColor:COLOR(254, 167, 173, 1) forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font=FONT(17, 15);
        self.rightBtn=rightBtn;
        
        if (self.isEdit==NO)
        {
            [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }
        else
        {
            [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        }
        
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem=rightItem;
    }
    else
    {
        self.title=@"商户注册";
    }
    
    UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(20), WZ(10), WZ(12), WZ(25))];
    [backBtn setBackgroundImage:IMAGE(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
}

-(void)createScrollView
{
    NSString *label9String=@"供货方式：\n1、纯折扣供货，供货贡献率请填≥0.12\n2、云联惠返还25%供货，供货贡献率请填≥0.16";
    CGSize label9Size=[ViewController sizeWithString:label9String font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(200))];
    CGFloat label9Height=WZ(10*2)+label9Size.height;
    //请按供货方式
    NSString *label111String=@"请按供货方式填写供货贡献率。例：0.2代表20%";
    CGSize label111Size=[ViewController sizeWithString:label111String font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(50))];
    NSString *label112String=@"商户实名信息";
    CGSize label112Size=[ViewController sizeWithString:label112String font:FONT(17,15) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(200))];
    CGFloat label11Height=WZ(10*2+20)+label111Size.height+label112Size.height;
    
    NSString *label17String=@"填写样例：中国XX银行+城市+支行，不用填省份。如：“中国工商银行广州市花都雅居乐支行”，注意城市名称以 “市” 字结尾。";
    CGSize label17Size=[ViewController sizeWithString:label17String font:FONT(15,13) maxSize:CGSizeMake(SCREEN_WIDTH-WZ(15*2), WZ(200))];
    CGFloat label17Height=WZ(10*2)+label17Size.height;
    
    CGFloat scrollHeight=label9Height+label11Height+label17Height+WZ(40)*3+WZ(50)*23+WZ(25+20+25+50)+WZ(50);
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, scrollHeight);
    _scrollView.delegate=self;
    _scrollView.backgroundColor=COLOR_WHITE;
    [self.view addSubview:_scrollView];
    
    UILabel *label0=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WZ(40))];
    label0.text=@"商户基本信息";
    label0.textAlignment=NSTextAlignmentCenter;
    label0.font=FONT(17, 15);
    label0.backgroundColor=COLOR_HEADVIEW;
    [_scrollView addSubview:label0];
    
    CGFloat titleWidth=WZ(90);
    for (NSInteger i=0; i<23; i++)
    {
        NSString *titleString=self.titleArray[i];
        
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=titleString;
        titleLabel.font=FONT(15, 13);
        titleLabel.numberOfLines=2;
//        titleLabel.backgroundColor=COLOR_CYAN;
        [_scrollView addSubview:titleLabel];
        
        if (i>=0 && i<=2)
        {
            titleLabel.frame=CGRectMake(WZ(15), WZ(40)+WZ(50)*i, titleWidth, WZ(50));
            
            UITextField *textField0=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10)-titleWidth, titleLabel.height)];
            textField0.placeholder=self.placeholderArray[i];
            textField0.font=FONT(15, 13);
            textField0.tag=i;
//            textField0.delegate=self;
//            textField0.backgroundColor=COLOR_CYAN;
            [_scrollView addSubview:textField0];
            [self.textFieldArray addObject:textField0];
            
            
            if (i==2)
            {
                textField0.keyboardType=UIKeyboardTypeNumberPad;
                textField0.userInteractionEnabled=NO;
                textField0.text=self.lxdh;
                
                UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, WZ(40))];
                label4.text=@"    请填写与云联惠同号";
                label4.textColor=COLOR_RED;
                label4.font=FONT(15, 13);
                label4.backgroundColor=COLOR_HEADVIEW;
                [_scrollView addSubview:label4];
                
                if (self.isMyselfInfoVC==YES)
                {
                    label4.textColor=COLOR_LIGHTGRAY;
                }
                
            }
        }
        if (i>=3 && i<=6)
        {
            titleLabel.frame=CGRectMake(WZ(15), WZ(40*2)+WZ(50)*i, titleWidth, WZ(50));
            
            if (i>=3 && i<6)
            {
                UITextField *textField1=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10)-titleWidth, titleLabel.height)];
                textField1.placeholder=self.placeholderArray[i];
                textField1.font=FONT(15, 13);
                textField1.tag=i;
//                textField1.delegate=self;
//                textField1.backgroundColor=COLOR_CYAN;
                [_scrollView addSubview:textField1];
                [self.textFieldArray addObject:textField1];
                
            }
            if (i==6)
            {
                UIButton *ghfsBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10+30)-titleWidth, titleLabel.height)];
                ghfsBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [ghfsBtn setTitle:self.ghfs1 forState:UIControlStateNormal];
                [ghfsBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                ghfsBtn.titleLabel.font=FONT(15, 13);
                [ghfsBtn addTarget:self action:@selector(ghfsBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                ghfsBtn.backgroundColor=COLOR_CYAN;
                [_scrollView addSubview:ghfsBtn];
                self.ghfsBtn=ghfsBtn;
                
                UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+17), ghfsBtn.top+WZ(20), WZ(17), WZ(10))];
                jiantouIV.image=IMAGE(@"xiajiantou_hui");
                [_scrollView addSubview:jiantouIV];
                
                
                UIView *aView9=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, label9Height)];
                aView9.backgroundColor=COLOR_HEADVIEW;
                [_scrollView addSubview:aView9];
                
                UILabel *label9=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2), label9Size.height)];
                label9.text=label9String;
                label9.font=FONT(15, 13);
                label9.numberOfLines=0;
                [aView9 addSubview:label9];
            }
        }
        if (i==7)
        {
            titleLabel.frame=CGRectMake(WZ(15), WZ(40*2)+label9Height+WZ(50)*i, titleWidth, WZ(50));
            
            UITextField *textField2=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10)-titleWidth, titleLabel.height)];
            textField2.placeholder=self.placeholderArray[i];
            textField2.font=FONT(15, 13);
            textField2.tag=i;
//            textField2.delegate=self;
//            textField2.backgroundColor=COLOR_CYAN;
            textField2.keyboardType=UIKeyboardTypeDecimalPad;
            [_scrollView addSubview:textField2];
            [self.textFieldArray addObject:textField2];
            
            UIView *aView11=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, label11Height)];
            aView11.backgroundColor=COLOR_HEADVIEW;
            [_scrollView addSubview:aView11];
            
            UILabel *label111=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2), label111Size.height)];
            label111.text=label111String;
            label111.font=FONT(15, 13);
            label111.numberOfLines=0;
            label111.textColor=COLOR_RED;
            [aView11 addSubview:label111];
            
            if (self.isMyselfInfoVC==YES)
            {
                label111.textColor=COLOR_LIGHTGRAY;
            }
            
            UILabel *label112=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), label111.bottom+WZ(20), SCREEN_WIDTH-WZ(15*2), label112Size.height)];
            label112.text=label112String;
            label112.textAlignment=NSTextAlignmentCenter;
            label112.font=FONT(17, 15);
            [aView11 addSubview:label112];
        }
        if (i>=8 && i<=9)
        {
            titleLabel.frame=CGRectMake(WZ(15), WZ(40*2)+label9Height+label11Height+WZ(50)*i, titleWidth, WZ(50));
            
            UITextField *textField3=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10)-titleWidth, titleLabel.height)];
            textField3.placeholder=self.placeholderArray[i];
            textField3.font=FONT(15, 13);
            textField3.tag=i;
//            textField3.delegate=self;
//            textField3.backgroundColor=COLOR_CYAN;
            [_scrollView addSubview:textField3];
            [self.textFieldArray addObject:textField3];
            
            if (i==9)
            {
                textField3.keyboardType=UIKeyboardTypeNumberPad;
                UILabel *label14=[[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, WZ(40))];
                label14.text=@"收款信息";
                label14.textAlignment=NSTextAlignmentCenter;
                label14.font=FONT(15, 13);
                label14.backgroundColor=COLOR_HEADVIEW;
                [_scrollView addSubview:label14];
            }
        }
        if (i>=10 && i<=11)
        {
            titleLabel.frame=CGRectMake(WZ(15), WZ(40*3)+label9Height+label11Height+WZ(50)*i, titleWidth, WZ(50));
            
            UITextField *textField4=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10)-titleWidth, titleLabel.height)];
            textField4.placeholder=self.placeholderArray[i];
            textField4.font=FONT(15, 13);
            textField4.tag=i;
//            textField4.delegate=self;
//            textField4.backgroundColor=COLOR_CYAN;
            [_scrollView addSubview:textField4];
            [self.textFieldArray addObject:textField4];
            
            if (i==10)
            {
                textField4.keyboardType=UIKeyboardTypeNumberPad;
            }
            if (i==11)
            {
                UIView *aView17=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, label17Height)];
                aView17.backgroundColor=COLOR_HEADVIEW;
                [_scrollView addSubview:aView17];
                
                UILabel *label17=[[UILabel alloc]initWithFrame:CGRectMake(WZ(15), WZ(10), SCREEN_WIDTH-WZ(15*2), label17Size.height)];
                label17.text=label17String;
                label17.font=FONT(15, 13);
                label17.numberOfLines=0;
                label17.textColor=COLOR_RED;
                [aView17 addSubview:label17];
                
                if (self.isMyselfInfoVC==YES)
                {
                    label17.textColor=COLOR_LIGHTGRAY;
                }
            }
        }
        if (i>=12)
        {
            titleLabel.frame=CGRectMake(WZ(15), WZ(40*3)+label9Height+label11Height+label17Height+WZ(50)*i, titleWidth, WZ(50));
            
            if (i!=13 && i!=22)
            {
                UITextField *textField5=[[UITextField alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10)-titleWidth, titleLabel.height)];
                textField5.placeholder=self.placeholderArray[i];
                textField5.font=FONT(15, 13);
                textField5.tag=i;
//                textField5.delegate=self;
//                textField5.backgroundColor=COLOR_CYAN;
                [_scrollView addSubview:textField5];
                [self.textFieldArray addObject:textField5];
                if (i==12 || i==15)
                {
                    textField5.keyboardType=UIKeyboardTypeNumberPad;
                }
            }
            if (i==13)
            {
                UIButton *sfshBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10+30)-titleWidth, titleLabel.height)];
                sfshBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [sfshBtn setTitle:self.sfsh1 forState:UIControlStateNormal];
                [sfshBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                sfshBtn.titleLabel.font=FONT(15, 13);
                [sfshBtn addTarget:self action:@selector(sfshBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                sfshBtn.backgroundColor=COLOR_CYAN;
                [_scrollView addSubview:sfshBtn];
                self.sfshBtn=sfshBtn;
                
                UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+17), sfshBtn.top+WZ(20), WZ(17), WZ(10))];
                jiantouIV.image=IMAGE(@"xiajiantou_hui");
                [_scrollView addSubview:jiantouIV];
            }
            if (i==22)
            {
                UIButton *sfkpBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(15+10)+titleWidth, titleLabel.top, SCREEN_WIDTH-WZ(15*2+10+30)-titleWidth, titleLabel.height)];
                sfkpBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                [sfkpBtn setTitle:self.sfkp1 forState:UIControlStateNormal];
                [sfkpBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
                sfkpBtn.titleLabel.font=FONT(15, 13);
                [sfkpBtn addTarget:self action:@selector(sfkpBtnClick) forControlEvents:UIControlEventTouchUpInside];
//                sfkpBtn.backgroundColor=COLOR_CYAN;
                [_scrollView addSubview:sfkpBtn];
                self.sfkpBtn=sfkpBtn;
                
                UIImageView *jiantouIV=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-WZ(15+17), sfkpBtn.top+WZ(20), WZ(17), WZ(10))];
                jiantouIV.image=IMAGE(@"xiajiantou_hui");
                [_scrollView addSubview:jiantouIV];
                
                UIView *aView29=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.bottom, SCREEN_WIDTH, WZ(25+20+25+50))];
                aView29.backgroundColor=COLOR_HEADVIEW;
                [_scrollView addSubview:aView29];
                
                NSString *ydString=@"我已阅读并接受";
                NSString *xyString=@"《商户协议》";
                CGSize ydSize=[ViewController sizeWithString:ydString font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(30))];
                CGSize xySize=[ViewController sizeWithString:xyString font:FONT(15,13) maxSize:CGSizeMake(WZ(200), WZ(30))];
                
                UIButton *checkBtn=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-WZ(20+10+5)-ydSize.width-xySize.width)/2.0, WZ(25), WZ(20), WZ(20))];
//                checkBtn.backgroundColor=COLOR_CYAN;
                [checkBtn setBackgroundImage:IMAGE(@"xuanze_xz") forState:UIControlStateNormal];
                [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
                checkBtn.selected=YES;
                [aView29 addSubview:checkBtn];
                self.checkBtn=checkBtn;
                
                UILabel *ydLabel=[[UILabel alloc]initWithFrame:CGRectMake(checkBtn.right+WZ(10), WZ(25), ydSize.width, ydSize.height)];
                ydLabel.text=ydString;
                ydLabel.font=FONT(15, 13);
                [aView29 addSubview:ydLabel];
                
                UIButton *xyBtn=[[UIButton alloc]initWithFrame:CGRectMake(ydLabel.right+WZ(5), WZ(25), xySize.width, xySize.height)];
                [xyBtn setTitle:xyString forState:UIControlStateNormal];
                [xyBtn setTitleColor:COLOR_RED forState:UIControlStateNormal];
                xyBtn.titleLabel.font=FONT(15, 13);
                [xyBtn addTarget:self action:@selector(xyBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [aView29 addSubview:xyBtn];
                
                UIButton *registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(WZ(30), xyBtn.bottom+WZ(25), SCREEN_WIDTH-WZ(25*2), WZ(50))];
                registerBtn.backgroundColor=COLOR(254, 167, 173, 1);
                registerBtn.clipsToBounds=YES;
                registerBtn.layer.cornerRadius=5;
                [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
                [registerBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [aView29 addSubview:registerBtn];
                self.registerBtn=registerBtn;
                
                if (self.isMyselfInfoVC==YES)
                {
                    self.checkBtn.hidden=YES;
                    ydLabel.hidden=YES;
                    xyBtn.hidden=YES;
                    registerBtn.hidden=YES;
                }
                
                
            }
            
        }
    }
    
    if (self.isMyselfInfoVC==YES)
    {
        if (self.isEdit==NO)
        {
            for (NSInteger i=0; i<self.textFieldArray.count; i++)
            {
                UITextField *textField=self.textFieldArray[i];
                textField.userInteractionEnabled=NO;
            }
            
            self.ghfsBtn.userInteractionEnabled=NO;
            self.sfshBtn.userInteractionEnabled=NO;
            self.sfkpBtn.userInteractionEnabled=NO;
        }
        else
        {
            for (NSInteger i=0; i<self.textFieldArray.count; i++)
            {
                UITextField *textField=self.textFieldArray[i];
                textField.userInteractionEnabled=YES;
                if (i==2)
                {
                    textField.userInteractionEnabled=NO;
                }
            }
            
            self.ghfsBtn.userInteractionEnabled=YES;
            self.sfshBtn.userInteractionEnabled=YES;
            self.sfkpBtn.userInteractionEnabled=YES;
        }
    }
    
    
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    for (NSInteger i=0; i<self.textFieldArray.count; i++)
//    {
//        UITextField *textField=self.textFieldArray[i];
//        [textField resignFirstResponder];
//        
//    }
//}

#pragma mark ===按钮点击方法
//返回
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//是否已阅读商户协议
-(void)checkBtnClick
{
    if (self.checkBtn.selected==YES)
    {
        [self.checkBtn setBackgroundImage:IMAGE(@"xuanze_wxz") forState:UIControlStateNormal];
        self.registerBtn.backgroundColor=COLOR_LIGHTGRAY;
        self.registerBtn.userInteractionEnabled=NO;
    }
    else
    {
        [self.checkBtn setBackgroundImage:IMAGE(@"xuanze_xz") forState:UIControlStateNormal];
        self.registerBtn.backgroundColor=COLOR(254, 167, 173, 1);
        self.registerBtn.userInteractionEnabled=YES;
    }
    
    self.checkBtn.selected=!self.checkBtn.selected;
}

//商户协议
-(void)xyBtnClick
{
    for (NSInteger i=0; i<self.textFieldArray.count; i++)
    {
        UITextField *textField=self.textFieldArray[i];
        [textField resignFirstResponder];
    }
}

//供货方式
-(void)ghfsBtnClick
{
    for (NSInteger i=0; i<self.textFieldArray.count; i++)
    {
        UITextField *textField=self.textFieldArray[i];
        [textField resignFirstResponder];
    }
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"供货方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"纯折扣供货",@"云联惠返还25%供货", nil];
    sheet.tag=1;
    [sheet showInView:self.view];
}

//是否私户
-(void)sfshBtnClick
{
    for (NSInteger i=0; i<self.textFieldArray.count; i++)
    {
        UITextField *textField=self.textFieldArray[i];
        [textField resignFirstResponder];
    }
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"是否私户" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
    sheet.tag=2;
    [sheet showInView:self.view];
}

//是否开票
-(void)sfkpBtnClick
{
    for (NSInteger i=0; i<self.textFieldArray.count; i++)
    {
        UITextField *textField=self.textFieldArray[i];
        [textField resignFirstResponder];
        
        NSLog(@"textField===%@",textField.text);
    }
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"是否开票" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
    sheet.tag=3;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        //供货方式
        if (buttonIndex==0)
        {
            self.ghfs=@"1";
            self.ghfs1=@"纯折扣供货";
        }
        if (buttonIndex==1)
        {
            self.ghfs=@"2";
            self.ghfs1=@"云联惠返还25%供货";
        }
        
        [self.ghfsBtn setTitle:self.ghfs1 forState:UIControlStateNormal];
    }
    if (actionSheet.tag==2)
    {
        //是否私户
        if (buttonIndex==0)
        {
            self.sfsh=@"1";
            self.sfsh1=@"是";
        }
        if (buttonIndex==1)
        {
            self.sfsh=@"0";
            self.sfsh1=@"否";
        }
        [self.sfshBtn setTitle:self.sfsh1 forState:UIControlStateNormal];
    }
    if (actionSheet.tag==3)
    {
        //是否开票
        if (buttonIndex==0)
        {
            self.sfkp=@"1";
            self.sfkp1=@"是";
        }
        if (buttonIndex==1)
        {
            self.sfkp=@"0";
            self.sfkp1=@"否";
        }
        [self.sfkpBtn setTitle:self.sfkp1 forState:UIControlStateNormal];
    }
}

//注册商户
-(void)registerBtnClick
{
    for (NSInteger i=0; i<self.textFieldArray.count; i++)
    {
        UITextField *textField=self.textFieldArray[i];
        [textField resignFirstResponder];
        
        NSLog(@"textField===%@",textField.text);
    }
    
    self.shmc=[self.textFieldArray[0] text];
    self.lxr=[self.textFieldArray[1] text];
    self.lxdh=[self.textFieldArray[2] text];
    self.ylhid=[self.textFieldArray[3] text];
    self.dz=[self.textFieldArray[4] text];
    self.jyfw=[self.textFieldArray[5] text];
    self.ghgxl=[self.textFieldArray[6] text];
    self.zjrxm=[self.textFieldArray[7] text];
    self.zjhm=[self.textFieldArray[8] text];
    self.frsjhm=[self.textFieldArray[9] text];
    self.khyhjzh=[self.textFieldArray[10] text];
    self.khhh=[self.textFieldArray[11] text];
    self.khmc=[self.textFieldArray[12] text];
    self.khzh=[self.textFieldArray[13] text];
    self.yyzzh=[self.textFieldArray[14] text];
    self.yyzzszd=[self.textFieldArray[15] text];
    self.yyqx=[self.textFieldArray[16] text];
    self.zzjgdm=[self.textFieldArray[17] text];
    self.khxkzh=[self.textFieldArray[18] text];
    self.swdjzh=[self.textFieldArray[19] text];
    
    if ([self.shmc isEqualToString:@""] || [self.lxr isEqualToString:@""] || [self.lxdh isEqualToString:@""] || [self.dz isEqualToString:@""] || [self.ghfs isEqualToString:@""] || [self.ghgxl isEqualToString:@""] || [self.zjrxm isEqualToString:@""] || [self.zjhm isEqualToString:@""] || [self.frsjhm isEqualToString:@""] || [self.khyhjzh isEqualToString:@""] || [self.sfsh isEqualToString:@""] || [self.khmc isEqualToString:@""] || [self.khzh isEqualToString:@""])
    {
        [self.view makeToast:@"带星号项目不能为空" duration:1.0];
    }
    else
    {
        MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"注册中..." detail:nil];
        [hud show:YES];
        [hud hide:YES afterDelay:20];
        //注册商户
        NSMutableDictionary *registerDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.shmc,@"shmc",self.lxr,@"lxr",self.lxdh,@"lxdh",self.ylhid,@"ylhid",self.dz,@"dz",self.jyfw,@"jyfw",self.ghfs,@"ghfs",self.ghgxl,@"ghgxl",self.zjrxm,@"zjrxm",self.zjhm,@"zjhm",self.frsjhm,@"frsjhm",self.khyhjzh,@"khyhjzh",self.khhh,@"khhh",self.sfsh,@"sfsh",self.khmc,@"khmc",self.khzh,@"khzh",self.yyzzh,@"yyzzh",self.yyzzszd,@"yyzzszd",self.yyqx,@"yyqx",self.zzjgdm,@"zzjgdm",self.khxkzh,@"khxkzh",self.swdjzh,@"swdjzh",self.sfkp,@"sfkp", nil];
        
        [HTTPManager registerStoreWithUserId:[UserInfoData getUserInfoFromArchive].userId registerDict:registerDict complete:^(NSDictionary *resultDict) {
            NSString *result=[resultDict objectForKey:@"result"];
            if ([result isEqualToString:STATUS_SUCCESS])
            {
                //注册成功之后等待审核 跳转我的界面
                for (UIViewController *controller in self.navigationController.viewControllers)
                {
                    if ([controller isKindOfClass:[MyselfViewController class]])
                    {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
                
            }
            else
            {
                NSString *msg=[resultDict objectForKey:@"msg"];
                [self.view makeToast:msg duration:1.0];
            }
            [hud hide:YES];
        }];
    }
}

//编辑商户资料
-(void)rightBtnClick
{
    if (self.isEdit==NO)
    {
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        //所有右边控件开启交互
        
        for (NSInteger i=0; i<self.textFieldArray.count; i++)
        {
            UITextField *textField=self.textFieldArray[i];
            textField.userInteractionEnabled=YES;
            if (i==2)
            {
                textField.userInteractionEnabled=NO;
            }
        }
        
        self.ghfsBtn.userInteractionEnabled=YES;
        self.sfshBtn.userInteractionEnabled=YES;
        self.sfkpBtn.userInteractionEnabled=YES;
    }
    else
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        //所有右边控件关闭交互 发送修改信息请求
        for (NSInteger i=0; i<self.textFieldArray.count; i++)
        {
            UITextField *textField=self.textFieldArray[i];
            textField.userInteractionEnabled=NO;
            [textField resignFirstResponder];
        }
        self.ghfsBtn.userInteractionEnabled=NO;
        self.sfshBtn.userInteractionEnabled=NO;
        self.sfkpBtn.userInteractionEnabled=NO;
        
        //取出输入框数据 组成字典统一传给后台
        self.shmc=[self.textFieldArray[0] text];
        self.lxr=[self.textFieldArray[1] text];
        self.lxdh=[self.textFieldArray[2] text];
        self.ylhid=[self.textFieldArray[3] text];
        self.dz=[self.textFieldArray[4] text];
        self.jyfw=[self.textFieldArray[5] text];
        self.ghgxl=[self.textFieldArray[6] text];
        self.zjrxm=[self.textFieldArray[7] text];
        self.zjhm=[self.textFieldArray[8] text];
        self.frsjhm=[self.textFieldArray[9] text];
        self.khyhjzh=[self.textFieldArray[10] text];
        self.khhh=[self.textFieldArray[11] text];
        self.khmc=[self.textFieldArray[12] text];
        self.khzh=[self.textFieldArray[13] text];
        self.yyzzh=[self.textFieldArray[14] text];
        self.yyzzszd=[self.textFieldArray[15] text];
        self.yyqx=[self.textFieldArray[16] text];
        self.zzjgdm=[self.textFieldArray[17] text];
        self.khxkzh=[self.textFieldArray[18] text];
        self.swdjzh=[self.textFieldArray[19] text];
        
        if ([self.shmc isEqualToString:@""] || [self.lxr isEqualToString:@""] || [self.lxdh isEqualToString:@""] || [self.dz isEqualToString:@""] || [self.ghfs isEqualToString:@""] || [self.ghgxl isEqualToString:@""] || [self.zjrxm isEqualToString:@""] || [self.zjhm isEqualToString:@""] || [self.frsjhm isEqualToString:@""] || [self.khyhjzh isEqualToString:@""] || [self.sfsh isEqualToString:@""] || [self.khmc isEqualToString:@""] || [self.khzh isEqualToString:@""])
        {
            [self.view makeToast:@"带星号项目不能为空" duration:2.0];
        }
        else
        {
            MBProgressHUD *hud=[self MBProgressHUDAddToView:self.view title:@"保存中..." detail:nil];
            [hud show:YES];
            [hud hide:YES afterDelay:20];
            //修改支付端商户信息
            NSMutableDictionary *changeDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:self.shmc,@"shmc",self.lxr,@"lxr",self.lxdh,@"lxdh",self.ylhid,@"ylhid",self.dz,@"dz",self.jyfw,@"jyfw",self.ghfs,@"ghfs",self.ghgxl,@"ghgxl",self.zjrxm,@"zjrxm",self.zjhm,@"zjhm",self.frsjhm,@"frsjhm",self.khyhjzh,@"khyhjzh",self.khhh,@"khhh",self.sfsh,@"sfsh",self.khmc,@"khmc",self.khzh,@"khzh",self.yyzzh,@"yyzzh",self.yyzzszd,@"yyzzszd",self.yyqx,@"yyqx",self.zzjgdm,@"zzjgdm",self.khxkzh,@"khxkzh",self.swdjzh,@"swdjzh",self.sfkp,@"sfkp",self.token,@"token",self.merId,@"merId", nil];
            [HTTPManager changeMerStoreInfoWithUserId:[UserInfoData getUserInfoFromArchive].userId changeDict:changeDict complete:^(NSDictionary *resultDict) {
                NSString *result=[resultDict objectForKey:@"result"];
                if ([result isEqualToString:STATUS_SUCCESS])
                {
                    [self.view makeToast:@"修改成功" duration:2.0];
                }
                else
                {
                    NSString *msg=[resultDict objectForKey:@"msg"];
                    [self.view makeToast:msg duration:2.0];
                }
                [hud hide:YES];
            }];
        }
        
    }
    
    self.isEdit=!self.isEdit;
    
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
