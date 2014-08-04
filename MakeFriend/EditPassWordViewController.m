//
//  EditPassWordViewController.m
//  MakeFriend
//
//  Created by dianji on 13-9-6.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "EditPassWordViewController.h"

@interface EditPassWordViewController ()

@end

@implementation EditPassWordViewController

//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)wrongButtonClicked:(UIButton *)sender
{

    [self.navigationController popViewControllerAnimated:NO];
}
-(void)sendPassWordClicked:(UIButton *)sender
{
    NSUserDefaults*defaut=[NSUserDefaults standardUserDefaults];
    NSString *number=[defaut objectForKey:@"PHONE_NUMBER"];
  //把密码存本地方便开启后链接聊天服务器
    NSUserDefaults *defalts=[NSUserDefaults standardUserDefaults];
    [defalts setObject:after.text forKey:@"PASS_WORD"];
    
    NSString*url1=[[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?upd_user=%@&New_pwd=%@",number,after.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *newURL=[NSURL URLWithString:url1];
    NSLog(@"sendNumber urlo:%@",url1);
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        
        [Tools showPrompt:@"连接服务器失败" inView:self.navigationController.view delay:0.4];
        
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        if ([requst.responseString isEqualToString:@"0"]) {
            [Tools showPrompt:@"修改成功" inView:self.view delay:0.4];
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController: [MyTableBarController sharedTabBarController] animated:YES];
        }
    }];
    


}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title=@"修改密码";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"wrong.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(8, 8, 15,15);
    [left addTarget:self action:@selector(wrongButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    UIButton*right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake(5, 8, 18,15);
    [right addTarget:self action:@selector(sendPassWordClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item2;
    [item2 autorelease];
    
    //创建修改密码框
    UIView *beforeBackaview=[[UIView alloc]initWithFrame:CGRectMake(15, 30, 290, 40)];
    beforeBackaview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"passWordEdit.png"]];
    [self.view addSubview:beforeBackaview];
    [beforeBackaview release];
    before=[[UITextField alloc]initWithFrame:CGRectMake(5, 10, 290, 30)];
    before.delegate=self;
    before.secureTextEntry=YES;
    before.tag=601;
    before.backgroundColor=[UIColor clearColor];
    before.placeholder=@"输入旧密码";
    [beforeBackaview addSubview:before];
    [before release];
    //输入新密码
    UIView *afterBackaview=[[UIView alloc]initWithFrame:CGRectMake(15, 90, 290, 40)];
    afterBackaview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"passWordEdit.png"]];
    [self.view addSubview:afterBackaview];
    [afterBackaview release];
    
    after=[[UITextField alloc]initWithFrame:CGRectMake(5, 10, 290, 30)];
    after.delegate=self;
    after.secureTextEntry=YES;
    after.tag=602;
    after.backgroundColor=[UIColor clearColor];
    after.placeholder=@"输入新密码";
    [afterBackaview addSubview:after];
    [after release];
   //再次确认新密码
    UIView *aginBackaview=[[UIView alloc]initWithFrame:CGRectMake(15, 150, 290, 40)];
    aginBackaview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"passWordEdit.png"]];
    [self.view addSubview:aginBackaview];
    [aginBackaview release];
    
    agin=[[UITextField alloc]initWithFrame:CGRectMake(5, 10, 290, 30)];
    agin.delegate=self;
    agin.secureTextEntry=YES;
    agin.tag=603;
    agin.backgroundColor=[UIColor clearColor];
    agin.placeholder=@"确认新密码";
    [aginBackaview addSubview:agin];
    [agin release];
    
    
}
#pragma mark--UITextfildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag==603) {
        if (![agin.text isEqualToString:after.text]) {
            [Tools showPrompt:@"新密码输入不一致" inView:self.view delay:0.8];
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
