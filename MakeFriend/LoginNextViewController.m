//
//  LoginNextViewController.m
//  MakeFriend
//
//  Created by dianji on 13-9-3.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "LoginNextViewController.h"

@interface LoginNextViewController ()

@end

@implementation LoginNextViewController

-(void)backButtonClicked:(UIButton*)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}
//此处服务器方法未完成，把两个参数传送至后台，并作出是否是注册用户得判断，如果不是请注册。
-(void)sendPhoneNumberToBack:(NSString*)number password:(NSString*)passWord
{

    NSString*url1=[[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?log_user=%@&log_pwd='1a2b3c'",number]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    NSURL *newURL=[NSURL URLWithString:url1];
    NSLog(@"sendNumber urlo:%@",url1);
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        
        [Tools showPrompt:@"登陆失败" inView:self.navigationController.view delay:0.4];
        
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
       
            [Tools showPrompt:@"登陆成功" inView:self.view delay:0.4];
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController: [MyTableBarController sharedTabBarController] animated:YES];
        
    }];
    
    
}
-(void)rightButtonClicked:(UIButton*)sender
{
    [self sendPhoneNumberToBack:_phoneNumber.text password:_password.text];

}
-(void)creatLoginView
{
    //承载_phoneNumber的imageview
    UIImageView*phoneNumberBackView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 275, 41)];
    phoneNumberBackView.image=[UIImage imageNamed:@"phoneNumber.png"];
    phoneNumberBackView.userInteractionEnabled=YES;
    [self.view addSubview:phoneNumberBackView];
    [phoneNumberBackView release];
    
    _phoneNumber=[[UITextField alloc]initWithFrame:CGRectMake(65, 10, 150, 30)];
    _phoneNumber.backgroundColor=[UIColor clearColor];
    _phoneNumber.placeholder=@"请输入手机号码";
    _phoneNumber.delegate=self;
    _phoneNumber.tag=510;
    [phoneNumberBackView addSubview:_phoneNumber];
    [_phoneNumber release];

    //承载_phoneNumber的imageview
    UIImageView*passWordBackView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 61+30, 275, 41)];
    passWordBackView.image=[UIImage imageNamed:@"passWord.png"];
    passWordBackView.userInteractionEnabled=YES;
    [self.view addSubview:passWordBackView];
    [passWordBackView release];
    
    _password=[[UITextField alloc]initWithFrame:CGRectMake(65, 10, 150, 30)];
    _password.backgroundColor=[UIColor clearColor];
    _password.placeholder=@"请输入密码";
    _password.delegate=self;
    _password.tag=511;
    _password.secureTextEntry = YES;
    [passWordBackView addSubview:_password];
    [_password release];
    
    UILabel *alter=[[UILabel alloc]initWithFrame:CGRectMake(25, 91+40+10, 270, 50)];
    alter.text=@"如果你已经是注册用户初次登陆，验证码是你的初始密码,欢迎你的使用";
    alter.numberOfLines=0;
    alter.backgroundColor=[UIColor clearColor];
    alter.textColor=[UIColor whiteColor];
    alter.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:alter];
    [alter release];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([Tools isIphone5]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView5.png"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView.png"]];
    }
    //创建登陆view
    [self creatLoginView];
    
    self.navigationController.rotatingHeaderView.backgroundColor=[UIColor blackColor];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title=@"登陆";
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(5, 8, 12,15);
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    UIButton*right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake(5, 8, 18,15);
    [right addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item2;
    [item2 autorelease];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==510) {
        _phoneNumber.text=textField.text;
    }
    else
    {
        _password.text=textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}
@end
