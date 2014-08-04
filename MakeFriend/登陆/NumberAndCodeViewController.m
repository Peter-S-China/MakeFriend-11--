//
//  NumberAndCodeViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "NumberAndCodeViewController.h"
#import "CodeViewController.h"
@interface NumberAndCodeViewController ()

@end

@implementation NumberAndCodeViewController

-(void)sendPhoneNumberToBack:(NSString*)number
{
    NSString*url1=[[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?reg_username=%@",number]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    NSURL *newURL=[NSURL URLWithString:url1];
    NSLog(@"sendNumber urlo:%@",url1);
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        
        [Tools showPrompt:@"发送失败" inView:self.navigationController.view delay:0.4];
               
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        
        [Tools showPrompt:@"发送成功" inView:self.navigationController.view delay:0.4];
        NSLog(@"requst.responseString:%@",requst.responseString);
        
        if ([requst.responseString isEqualToString:@"ok"]) {//已经注册过了
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"此帐号已经注册过，返回登陆？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=304;
            [alter show];
            [alter release];
        }
        else
        {
            CodeViewController*code=[[CodeViewController alloc]init];
            [self.navigationController pushViewController:code animated:YES];
            [code release];

        }
    }];
   
}
//把手机号码发给服务器，并返回验证码
-(void)nextButtonClicked:(UIButton *)sender
{
    if (_phoneNumber.text.length>0) {
        
    //把手机号码也存在本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString*userName=[defaults objectForKey:@"PHONE_NUMBER"];

    if (userName.length>0){//如果有shouji，表示不是第一次提交数据
        if ([userName isEqualToString:_phoneNumber.text]) {//
            [self sendPhoneNumberToBack:_phoneNumber.text];
        }
        else
        {
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"使用最新的手机号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=301;
            [alter show];
            [alter release];
            
        }

    }
    else
    {
        [defaults setObject:_phoneNumber.text forKey:@"PHONE_NUMBER"];
        [defaults synchronize];
        [self sendPhoneNumberToBack:_phoneNumber.text];
    }
 
    }
    else
    {
        
        //使用本地手机号码
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString*userName=[defaults objectForKey:@"PHONE_NUMBER"];
        if (userName.length>0){//本地有，用本地手机号码
            NSLog(@"PHONE_NUMBER:///%@///",[defaults objectForKey:@"PHONE_NUMBER"]);
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"使用本地手机号码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=302;
            [alter show];
            [alter release];
        
        }
        else{
        
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"没有监测到本地储存的用户名，请输入手机号码。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.tag=303;
        [alter show];
        [alter release];
        

        }
    }
   }
#pragma mark-alterviewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==301) {
  
    if (buttonIndex==1) {//使用最新的号码，覆盖本地的号码
        [self sendPhoneNumberToBack:_phoneNumber.text];
        [[NSUserDefaults standardUserDefaults]setObject:_phoneNumber.text forKey:@"PHONE_NUMBER"];
            }
    }
    if(alertView.tag==302)
    {
    if (buttonIndex==1) {//使用本地手机号码
     [self sendPhoneNumberToBack:[[NSUserDefaults standardUserDefaults] objectForKey:@"PHONE_NUMBER"]];
       

    }
    
    
    }
    if(alertView.tag==303)
    {
        if (buttonIndex==1) {//没有监测到本地储存的用户名，请输入手机号码
            return;
            
        }
    }
    if (alertView.tag==304) {
        
        if (buttonIndex==1) {//返回登陆页面
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}
-(void)backButtonClicked:(UIButton*)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];

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
    self.navigationController.rotatingHeaderView.backgroundColor=[UIColor blackColor];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title=@"注册";
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(5, 8, 12,15);
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];

 //承载_phoneNumber的imageview
    UIImageView*phoneNumberBackView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 275, 51)];
    phoneNumberBackView.image=[UIImage imageNamed:@"phoneNumber.png"];
    phoneNumberBackView.userInteractionEnabled=YES;
    [self.view addSubview:phoneNumberBackView];
    [phoneNumberBackView release];
    
    _phoneNumber=[[UITextField alloc]initWithFrame:CGRectMake(65, 15, 150, 30)];
    _phoneNumber.backgroundColor=[UIColor clearColor];
    _phoneNumber.placeholder=@"请输入手机号码";
    _phoneNumber.delegate=self;
    [phoneNumberBackView addSubview:_phoneNumber];
    [_phoneNumber release];
    
    UIButton*nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(90, 105, 130, 30);
    [nextButton setImage:[UIImage imageNamed:@"nexSteptButton.png"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}
#pragma mark -textfildDelegate
//当敲打回车键时，开始搜索并收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
