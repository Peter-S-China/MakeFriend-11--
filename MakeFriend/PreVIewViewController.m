//
//  PreVIewViewController.m
//  MakeFriend
//
//  Created by dianji on 13-8-14.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "PreVIewViewController.h"
#import "ASIFormDataRequest.h"
@interface PreVIewViewController ()

@end

@implementation PreVIewViewController
@synthesize selctedImage,wishString,preMonth,preDay,preYear,preAddress,isPublic;

//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
//提交数据
-(void)PrerightButtonClicked:(UIButton*)sender
{
    //获取用户名username
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString*PhoneNum=[defaults objectForKey:@"PHONE_NUMBER"];
    NSLog(@".....PhoneNum.....%@",PhoneNum);
     //获取图片data
    UIImage* theImage = [Tools imageWithImageSimple:self.selctedImage scaledToSize:CGSizeMake(200.0, 300.0)];
    NSData *imageData = UIImageJPEGRepresentation(theImage, 0.8);
    
    NSString*url=@"http://218.246.35.203:8011/pages/json.aspx?pub_wish='aa'";
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL: [NSURL URLWithString:url]];
    [request addData:imageData forKey:@"wishinfor"];
    [request setPostValue:[NSString stringWithFormat:@"%@%@%@",self.preMonth,self.preDay,self.preYear] forKey:@"wish_birth"];
    [request setPostValue:[NSString stringWithFormat:@"%@",PhoneNum] forKey:@"wish_userid"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self.preAddress] forKey:@"wish_address"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self.wishString] forKey:@"wish_content"];
   [request setPostValue:[NSString stringWithFormat:@"%d",self.isPublic] forKey:@"wish_public"];
 //   [request setPostValue:[NSString stringWithFormat:@"1"] forKey:@"public"];
    
    [request setDelegate:self];
    
       [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"已经提交到后台进行审核，请耐心等候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        [alter release];
        
        
    }];
    [request setFailedBlock:^{
        NSLog(@"asi error: %@",request.error.debugDescription);
        [Tools showPrompt:@"上传超时，请点击上传按钮再试一次，谢谢你的配合" inView:self.view delay:0.5];
        
    }];
    
    [request buildRequestHeaders];
    [request startAsynchronous];
    NSLog(@"responseString = %@", request.responseString);
    


}
-(void)PreBackButtonClicked:(UIButton*)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatPreViewNavGationView
{
    
    //自定义导航条
    PreNavView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    PreNavView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:PreNavView];
    [PreNavView release];
    //加上x和钩和标题
    PreNavTitle=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 90, 35)];
    PreNavTitle.text=@"预览";
    PreNavTitle.font=[UIFont fontWithName:@"Arial-BoldMT" size:18];
    PreNavTitle.textColor=[UIColor whiteColor];
    PreNavTitle.backgroundColor=[UIColor clearColor];
    [PreNavView addSubview:PreNavTitle];
    [PreNavTitle release];
    //加上x和钩
    PrerightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [PrerightButton setImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    [PrerightButton addTarget:self action:@selector(PrerightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    PrerightButton.frame=CGRectMake(self.view.bounds.size.width-30, 13, 20, 16);
    [PreNavView addSubview:PrerightButton];
    PreBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [PreBackButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [PreBackButton addTarget:self action:@selector(PreBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    PreBackButton.frame=CGRectMake(10, 10, 30, 27);
    [PreNavView addSubview:PreBackButton];
    
    
}
-(void)fillBirthLabel
{
   birthLabel.text=self.preMonth;
   birthLabel1.text=self.preDay;
   birthLabel2.text=self.preYear;
         
}
-(void)creatPreView
{
    UIView*imageBackeView=[[UIView alloc]initWithFrame:CGRectMake(5, 44+10, 310, 174)];
    imageBackeView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"imageBack.png"]];
    [self.view addSubview:imageBackeView];
    [imageBackeView release];
    
    UIImageView*photo=[[UIImageView alloc]initWithFrame:imageBackeView.frame];
    photo.image=self.selctedImage;
    photo.backgroundColor=[UIColor clearColor];
    [self.view addSubview:photo];
    [photo release];
    //加上透明黑条
    UIImageView*aphView=[[UIImageView alloc]initWithFrame:CGRectMake(0, photo.frame.size.height-30, 310, 32)];
    aphView.image=[UIImage imageNamed:@"aphVIew.png"];
    [photo addSubview:aphView];
    [aphView release];
    //在黑条上面加上地址label
    UILabel*addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 5, 100, 20)];
    addressLabel.text=self.preAddress;
    addressLabel.font=[UIFont systemFontOfSize:10];
    addressLabel.backgroundColor=[UIColor whiteColor];
    [aphView addSubview:addressLabel];
    [addressLabel release];
    
    
    //加上我的生日
    UIImageView*birthView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-167-[Tools isIphone5], 320, 147)];
    birthView.image=[UIImage imageNamed:@"birthView.png"];
    [self.view addSubview:birthView];
    [birthView release];
    //在生日条上加上生日label

        birthLabel=[[UILabel alloc]initWithFrame:CGRectMake(30+0*100, 70, 60, 40)];
        birthLabel.textAlignment=NSTextAlignmentCenter;
        birthLabel.backgroundColor=[UIColor whiteColor];
        [birthView addSubview:birthLabel];
        [birthLabel release];
    
        birthLabel1=[[UILabel alloc]initWithFrame:CGRectMake(30+1*100, 70, 60, 40)];
        birthLabel1.textAlignment=NSTextAlignmentCenter;
        birthLabel1.backgroundColor=[UIColor whiteColor];
        [birthView addSubview:birthLabel1];
        [birthLabel1 release];
       
        birthLabel2=[[UILabel alloc]initWithFrame:CGRectMake(30+2*100, 70, 60, 40)];
        birthLabel2.textAlignment=NSTextAlignmentCenter;
        birthLabel2.backgroundColor=[UIColor whiteColor];
        [birthView addSubview:birthLabel2];
        [birthLabel2 release];
    
        [self fillBirthLabel];
    //加上愿望条
    UILabel*wishLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 50+174+20, 310, 50)];
    wishLabel.text=self.wishString;
    wishLabel.font=[UIFont systemFontOfSize:10];
    wishLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishLabel.png"]];
    [self.view addSubview:wishLabel];
    [wishLabel release];
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@,%@,%@",self.preMonth,self.preDay,self.preYear);
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
	[self creatPreViewNavGationView];
    [self creatPreView];
    
}

@end
