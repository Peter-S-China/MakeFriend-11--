//
//  UserMessageViewController.m
//  ONE
//
//  Created by dianji on 13-1-17.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "UserMessageViewController.h"
#import "RegexKitLite.h"
@interface UserMessageViewController ()

@end

@implementation UserMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backButtonClicked:(UIButton*)sender
{
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration =0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"cube";
        animation.subtype = kCATransitionFromLeft;
        
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
}
-(void)reSetting:(id)sender
{
    nameField.text=nil;
    phoneField.text=nil;
    
}
-(BOOL)isMobileNumber:(NSString*)mobileNum
{
    
    return [mobileNum isMatchedByRegex:@"^1[0-9]{10}$"];
    
}
//传送参与的信息给服务器
-(void)addEvent
{
    //测试设备号
    NSString *strIdentifier;
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"UUID"]) {//如果没有，就创建并储存
        strIdentifier = [Tools getUdid];
        [defaults setObject:strIdentifier forKey:@"UUID"];
        [defaults synchronize];
    }
    else
    {
        strIdentifier=[defaults objectForKey:@"UUID"];
    }

    NSLog(@"..strIdentifier..%@.....",strIdentifier);
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat: @"http://matrix.clickharbour.com/pages/index.aspx?upname=%@&uptel=%@& upidentifier=%@",nameField.text,phoneField.text,strIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"传参与的的事件url = %@",url);
    [_upDateRequest clearDelegatesAndCancel];
    [_upDateRequest release];
    _upDateRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    [_upDateRequest startAsynchronous];
  //转圈圈动画
    _indictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indictorView.center = self.view.center;
    [self.view addSubview:_indictorView];
    [_indictorView release];
    [_indictorView startAnimating];
    
    [_upDateRequest setFailedBlock:^{
        NSLog(@"传送参与信息失败");
        [_indictorView stopAnimating];
        [Tools showPrompt:@"发送失败" inView:self.navigationController.view delay:1.4];
    }];
    [_upDateRequest setCompletionBlock:^{
        NSLog(@"传送参与信息成功");
        NSLog(@"%@",_upDateRequest.responseString);
        [_indictorView stopAnimating];
        [Tools hideSpinnerInView:self.navigationController.view];
        [Tools showPrompt:@"发送成功" inView:self.navigationController.view delay:1.4];
  //把本地信息也修改
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults objectForKey:@"USER_MESSAGEINFO_TO_LOCAL"] == nil){
            NSDictionary *dic = @{ @"name" : nameField.text, @"tel":phoneField.text};
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dic ] forKey:@"USER_MESSAGEINFO_TO_LOCAL"];
            [defaults synchronize];
        }
        else{
            [defaults removeObjectForKey:@"USER_MESSAGEINFO_TO_LOCAL"];
            NSDictionary *dic = @{ @"name" : nameField.text, @"tel":phoneField.text};
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dic ] forKey:@"USER_MESSAGEINFO_TO_LOCAL"];
            [defaults synchronize];
            
        }
 
    
    }];
    
}
-(void)comitData:(id)sender
{
    if (nameField.text!=nil && phoneField.text!=nil ) {
        if ([self isMobileNumber:phoneField.text]) {
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"是否提交个人信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1300;
            [alter show];
            [alter release];
            
        }
        else{
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"请检查你的手机号是否正确" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1303;
            [alter show];
            [alter release];
            
        }
    }
    else
    {
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，重要信息不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.tag=1301;
        [alter show];
        [alter release];
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1300) {
        if (buttonIndex==1) {
            [self addEvent];
        }
    }


}
-(void)getUserMessage
{
    NSString *strIdentifier = [Tools getUdid];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://matrix.clickharbour.com/pages/index.aspx?sureidentifier=%@",strIdentifier]];
 
    ASIHTTPRequest*_request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request startAsynchronous];
    
    [_request setFailedBlock:^{
        NSLog(@"传送参与信息失败");
    }];
    [_request setCompletionBlock:^{
        if (_request.responseString.length > 0) {// 表示提交过
            NSLog(@"_request.responseString = %@",_request.responseString);
            //把返回的字符串解析出来存到本地
            NSArray*respons=[_request.responseString componentsSeparatedByString:@","];
            if ([respons count] >=2) {
                nameField.text=[respons objectAtIndex:0];
                phoneField.text=[respons objectAtIndex:1];
                //存在本地
                NSDictionary *dic = @{ @"name" : [respons objectAtIndex:0], @"tel":[respons objectAtIndex:1]};
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if (![[defaults objectForKey:@"USER_MESSAGEINFO_TO_LOCAL"]isEqual:dic]){
                    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dic ] forKey:@"USER_MESSAGEINFO_TO_LOCAL"];
                    [defaults synchronize];
                }
            }
            else
            {
            [Tools showPrompt:@"没有你的相关信息额" inView:self.view delay:0.9];
            }
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      //添加上返回按钮
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 8, 60,30);
    [left setTitle:@"返回" forState:UIControlStateNormal];
    [left setTitle:@"返回" forState:UIControlStateHighlighted];
    left.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    //添加上标签
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 100, 40)];
    title.text=@"修改个人信息";
    title.font=[UIFont systemFontOfSize:22];
    title.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.title=title.text;
    [title release];
    
  
   
    //创建页面
    //姓名
    UILabel*nameLael=[[UILabel alloc]initWithFrame:CGRectMake(17, 42, 50, 35)];
    nameLael.text=@"姓名";
    nameLael.backgroundColor=[UIColor clearColor];
    nameLael.textColor=[UIColor blackColor];
    [nameLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    [self.view addSubview:nameLael];
    [nameLael release];
    
    //每个textfield下面是一个imageview
    UIImageView*nameView=[[UIImageView alloc]initWithFrame:CGRectMake(17, 77, 320-34, 40)];
    nameView.image=[UIImage imageNamed:@"textfield1.png"];
    [self.view addSubview:nameView];
    [nameView release];
    
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(20, 77, 320-34 - 6, 40)];
    nameField.textColor=[UIColor blackColor];
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.returnKeyType = UIReturnKeyDone;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"USER_MESSAGEINFO_TO_LOCAL"];
    if (data.length > 0) {
        NSDictionary *infos = [[[NSDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
            nameField.text=[infos objectForKey:@"name"];
    }
    else//根据设备号再请求一次
    {
        [self getUserMessage];
        
        
    
    }
    
    nameField.backgroundColor=[UIColor clearColor];
    [self.view addSubview:nameField];
    nameField.delegate=self;
    [nameField release];
    
    //联系方式
    UILabel*phoneLael=[[UILabel alloc]initWithFrame:CGRectMake(17, 47+40+13+30, 50, 35)];
    phoneLael.text=@"电话";
    [phoneLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    phoneLael.backgroundColor=[UIColor clearColor];
    phoneLael.textColor=[UIColor blackColor];
    [self.view addSubview:phoneLael];
    [phoneLael release];
    //每个textfield下面是一个imageview
    
    UIImageView*phoneView=[[UIImageView alloc]initWithFrame:CGRectMake(17, 47+40+13+35+2+30, 320-34, 40)];
    phoneView.image=[UIImage imageNamed:@"textfield1.png"];
    [self.view addSubview:phoneView];
    [phoneView release];
    
    phoneField=[[UITextField alloc]initWithFrame:CGRectMake(20, 47+35+13+40+2+30, 320-34 - 6, 40)];
    NSUserDefaults *defaultsPhone = [NSUserDefaults standardUserDefaults];
    NSData *data1 = [defaultsPhone objectForKey:@"USER_MESSAGEINFO_TO_LOCAL"];
    if (data1.length > 0) {
        NSDictionary *infos = [[[NSDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data1]] autorelease];
        phoneField.text=[infos objectForKey:@"tel"];
    }
    phoneField.textColor=[UIColor blackColor];
    phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneField.backgroundColor=[UIColor clearColor];
    phoneField.delegate=self;
    [self.view addSubview:phoneField];
    [phoneField release];
 
    //两个button
    UIButton*reloadData=[UIButton buttonWithType:UIButtonTypeCustom];
    [reloadData addTarget:self action:@selector(reSetting:) forControlEvents:UIControlEventTouchUpInside];
    reloadData.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [reloadData setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    reloadData.frame=CGRectMake(50,  47+35+13+40+2+40+13+35+22, 80, 30);
    [self.view addSubview:reloadData];
    
    UIButton*comitData=[UIButton buttonWithType:UIButtonTypeCustom];
    [comitData setBackgroundImage:[UIImage imageNamed:@"commit.png"] forState:UIControlStateNormal];
    comitData.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    comitData.frame=CGRectMake(50+90+35, 47+35+13+40+2+40+13+35+22, 80, 30);
    [comitData addTarget:self action:@selector(comitData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comitData];
   
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
