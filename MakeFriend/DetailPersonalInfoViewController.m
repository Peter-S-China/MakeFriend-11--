//
//  DetailPersonalInfoViewController.m
//  MakeFriend
//
//  Created by dianji on 13-8-28.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "DetailPersonalInfoViewController.h"
#import "UIButton+WebCache.h"
#import "AllWishsViewController.h"
@interface DetailPersonalInfoViewController ()

@end

@implementation DetailPersonalInfoViewController
@synthesize info,constellatory;
//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)backButtonClicked:(UIButton*)sender
{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)creatDetailViewNavGationView
{
    
    //自定义导航条
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    //加上x和钩和标题
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 90, 35)];
    titleLabel.text=@"详细资料";
    titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:18];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [navView addSubview:titleLabel];
    [titleLabel release];
    //加上返回按钮和钩
    leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame=CGRectMake(10, 10, 30, 27);
    [navView addSubview:leftButton];
}
-(NSString *)getAstroWithMonth:(int)m day:(int)d
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
    
}

//处理生日转化为星座
-(void)handleBirthday
{
    NSArray *birthArray=[[NSArray alloc]init];
    birthArray=[info.userBirth componentsSeparatedByString:@"-"];
    int month=[[birthArray objectAtIndex:1]intValue];
    int day=[[birthArray objectAtIndex:2]intValue];
    NSLog(@"month:%d  day:%d",month,day);
    self.constellatory=[self getAstroWithMonth:month day:day];
    NSLog(@"%@",self.constellatory);
}

-(UIImage*)chooseConstellationImage:(NSString*)constellation
{
    if ([constellation isEqualToString:@"魔羯"]) {
        return [UIImage imageNamed:@"mojie.png"];
    }
    if ([constellation isEqualToString:@"水瓶"]) {
        return [UIImage imageNamed:@"shuipin.png"];
    }
    if ([constellation isEqualToString:@"双鱼"]) {
        return [UIImage imageNamed:@"shuangyu.png"];
    }
    if ([constellation isEqualToString:@"白羊"]) {
        return [UIImage imageNamed:@"baiyang.png"];
    }
    if ([constellation isEqualToString:@"金牛"]) {
        return [UIImage imageNamed:@"jinniu.png"];
    }
    if ([constellation isEqualToString:@"双子"]) {
        return [UIImage imageNamed:@"shuangzi.png"];
    }
    if ([constellation isEqualToString:@"巨蟹"]) {
        return [UIImage imageNamed:@"juxie.png"];
    }
    if ([constellation isEqualToString:@"狮子"]) {
        return [UIImage imageNamed:@"shizi.png"];
    }
    if ([constellation isEqualToString:@"处女"]) {
        return [UIImage imageNamed:@"chunv.png"];
    }
    if ([constellation isEqualToString:@"天秤"]) {
        return [UIImage imageNamed:@"tianping.png"];
    }
    if ([constellation isEqualToString:@"天蝎"]) {
        return [UIImage imageNamed:@"tianxie.png"];
    }
    if ([constellation isEqualToString:@"射手"]) {
        return [UIImage imageNamed:@"sheshou.png"];
    }
    return nil;
}
-(UIImage*)chooseSexImage:(NSString*)sexStr
{
    switch ([sexStr intValue]) {
        case 0://男性
        {
            return [UIImage imageNamed:@"man.png"];
            break;
        }
        case 1://女性
        {
            return [UIImage imageNamed:@"woman.png"];
            break;
        }
        default:
            break;
    }
    return nil;
    
}
-(void)allWishsClicked:(UIButton*)sender
{
    AllWishsViewController*nac=[[AllWishsViewController alloc]init];
    nac.info=self.info;
    [self.navigationController pushViewController:nac animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [nac release];
    
}
//把自己的手机号和聊天对象的号发给后台，让后台连接
-(void)chatClicked:(UIButton*)sender
{


}
-(void)creatDetailView
{
    //上方的基本资料布局
    UIButton*littleImage=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    littleImage.frame=CGRectMake(20, 44+30, 58, 58);
    [littleImage setImageWithURL:[NSURL URLWithString:info.useraLitleImageURL]];
    [self.view addSubview:littleImage];
    //昵称
    UILabel* nickName=[[UILabel alloc]initWithFrame:CGRectMake(80, 44+30, 40, 20)];
    nickName.text=info.userName;
    nickName.textColor=[UIColor whiteColor];
    nickName.backgroundColor=[UIColor clearColor];
    nickName.font=[UIFont fontWithName:@"Arial-BoldMT" size:12];
    [self.view addSubview:nickName];
    [nickName release];
    //星座
    UIImageView*constellation=[[UIImageView alloc]initWithFrame:CGRectMake(80+40, 44+30+5, 10, 10)];
    constellation.image=[self chooseConstellationImage:self.constellatory];
    [self.view addSubview:constellation];
    [constellation release];
    //性别
    UIImageView *sexImage=[[UIImageView alloc]initWithFrame:CGRectMake(83, 44+30+5+20, 10, 12)];
    sexImage.image=[self chooseSexImage:info.userSex];
    [self.view addSubview:sexImage];
    [sexImage release];
   //地区，个性签名，所有心愿
    UIView *infoView=[[UIView alloc]initWithFrame:CGRectMake(15, 74+58+30, 290, 121)];
    infoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"detailInfo.png"]];
    [self.view addSubview:infoView];
    [infoView release];
//在地区和 个性签名上面加label，在所有心愿上面加button
    UILabel*address=[[UILabel alloc]initWithFrame:CGRectMake(infoView.bounds.size.width-70, 10, 65, 30)];
    address.text=info.userAddress;
    address.textColor=[UIColor blackColor];
    address.backgroundColor=[UIColor clearColor];
    address.font=[UIFont systemFontOfSize:12];
    [infoView addSubview:address];
    [address release];
    
    UILabel*signature=[[UILabel alloc]initWithFrame:CGRectMake(infoView.bounds.size.width-180, 10+40, 175, 30)];
    signature.text=info.userSignature;
    signature.textColor=[UIColor blackColor];
    signature.textAlignment=NSTextAlignmentRight;
    signature.backgroundColor=[UIColor clearColor];
    signature.font=[UIFont systemFontOfSize:12];
    [infoView addSubview:signature];
    [signature release];

    UIButton *allWishs=[UIButton buttonWithType:UIButtonTypeCustom];
    allWishs.frame=CGRectMake(0, 80, 290, 40);
    [allWishs addTarget:self action:@selector(allWishsClicked:) forControlEvents:UIControlEventTouchUpInside];
    allWishs.backgroundColor=[UIColor clearColor];
    [infoView addSubview:allWishs];
    //发起会话
    UIButton *chat=[UIButton buttonWithType:UIButtonTypeCustom];
    chat.frame=CGRectMake(15,281+40, 290, 40);
    [chat setImage:[UIImage imageNamed:@"chat.png"] forState:UIControlStateNormal];
    [chat addTarget:self action:@selector(chatClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chat];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
    //处理生日转化为星座
    [self handleBirthday];
    [self creatDetailViewNavGationView];
    [self creatDetailView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
