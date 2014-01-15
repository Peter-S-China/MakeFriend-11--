//
//  PersonalMessageViewController.m
//  ONE
//
//  Created by dianji on 12-12-11.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "PersonalMessageViewController.h"
#import "JoinViewController.h"
#import "SBJson.h"
#import "RegexKitLite.h"
@interface PersonalMessageViewController ()

@end

@implementation PersonalMessageViewController
@synthesize _info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(BOOL)isMobileNumber:(NSString*)mobileNum
{

    return [mobileNum isMatchedByRegex:@"^1[0-9]{10}$"];
    
}
-(void)comitData:(id)sender
{
    if (nameField.text!=nil && phoneField.text!=nil ) {
        if ([self isMobileNumber:phoneField.text]) {
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"是否提交个人参与信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1200;
            [alter show];
            [alter release];

        }
        else{
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"请检查你的手机号是否正确" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1203;
            [alter show];
            [alter release];
            
               }
    }
    else
    {
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，重要信息不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.tag=1201;
        [alter show];
        [alter release];
    }


}

//传送参与的信息给服务器
-(void)addEvent
{
    //改过后得带有位置得url  http://matrix.clickharbour.com/pages/index.aspx?eventid=1&name=dxm&tel=15801045721&datails=tellme&identifier=idontknow
    //从本地获得测试设备号
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
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat: @"http://matrix.clickharbour.com/pages/index.aspx?eventid=%@&name=%@&tel=%@&datails=%@&identifier=%@",_info.idNumber,nameField.text,phoneField.text,commentField.text,strIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"传参与的的事件url = %@",url);
    [_request clearDelegatesAndCancel];
    [_request release];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request startAsynchronous];
    
    [_request setFailedBlock:^{
        NSLog(@"传送参与信息失败");
    }];
    [_request setCompletionBlock:^{
        NSLog(@"传送参与信息成功");
        NSLog(@"%@",_request.responseString);
        
    }];
    
}
#pragma mark - alterViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //给attencontroller发送广播删除cell的东西
    NSString *bcastName = @"cleanAttention";
    // 内容
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          self._info.idNumber, @"attentionInfo",
                          nil];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:bcastName object:self userInfo:dict];
    
//    [attentionTable reloadData];
    
    if (alertView.tag==1200) {
    if (buttonIndex==1) {
          [self addEvent];
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
        if ([nav.visibleViewController isKindOfClass:[JoinViewController class]]) {
            JoinViewController *attention= (JoinViewController *)nav.visibleViewController;
            attention._info = _info;
            
            //把信息存进本地文件
            NSUserDefaults *joindefaults = [NSUserDefaults standardUserDefaults];
            if ([joindefaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"] == nil) {//表示还没有添加东西到本地
                NSMutableArray *infos = [[NSMutableArray alloc] init];
                _info.joinedNumber= [NSString stringWithFormat:@"%i",[_info.joinedNumber intValue] + 1];
                
                NSLog(@"......joinnumber.....%i",[_info.joinedNumber intValue]);
               
              
                [infos addObject:_info];
                [joindefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infos ] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                [infos release];
            }
            else {//表示找到了数组。然后看看数组里面有没有，防止重复添加
                NSData *data = [joindefaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                NSMutableArray *infos = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
                BOOL isExit = NO;
                for (MessageInfo *sinfo in infos) {
                    if ([sinfo.buttonTitle isEqualToString:_info.buttonTitle]) {//有重复的
                        isExit = YES;
                        break;
                    }
                }
                if (!isExit) {//如果不存在重复的才添加进数组
                   
                    _info.joinedNumber= [NSString stringWithFormat:@"%i",[_info.joinedNumber intValue] + 1];
                   
                    NSLog(@"......joinnumber.....%i",[_info.joinedNumber intValue]);
                    [infos addObject:_info];

                    [joindefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infos ] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                
                }
                
            }
            [joindefaults synchronize];
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:2];
        }
    }
    
    }
    if (alertView.tag==1201) {
        if (buttonIndex==1) {
            
   /*
        if (CGRectGetMidY(scoller.frame) < 0){
            [UIView animateWithDuration:0.1 animations:^{
                CGRect rect = scoller.frame;
                rect.origin.y = 100;
                rect.size.height= 460;
                scoller.frame = rect;
            } completion:^(BOOL finished) {
                
            }];
            
        }
  */
            return;
    }
        

    }
    if (alertView.tag==1203) {
        if (buttonIndex==1) {
            /*
            if (CGRectGetMidY(scoller.frame) < 0){
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect rect = scoller.frame;
                    rect.origin.y = 100;
                    rect.size.height= 460;
                    scoller.frame = rect;
                } completion:^(BOOL finished) {
                    
                }];
                
            }
           */ 
        }
        
        
    }
}
-(void)reSetting:(id)sender
{
    nameField.text=nil;
    phoneField.text=nil;
    commentField.text=nil;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//填写个人信息页面

    //添加上标签
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 100, 40)];
    title.text=self._info.buttonTitle;
    title.font=[UIFont systemFontOfSize:22];
    title.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.title=title.text;
    [title release];
    
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


    //创建登陆页面
    UITableView *myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 460+[Tools isIphone5]) style:UITableViewStyleGrouped];
    //设置tableview的背景颜色，ios6只能这么设定
    UIView *view = [[UIView alloc] initWithFrame:myTableView.frame];
    view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    self.view.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    myTableView.backgroundView = view;
    [view release];
    
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    [myTableView release];
    
    
  /*
    //背后加上一个scoreview
   
    scoller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44)];
    scoller.contentSize=CGSizeMake(320, 460-44);
    scoller.backgroundColor=[UIColor whiteColor];
	[self.view addSubview:scoller];
 
    
//创建页面
    //姓名
    UILabel*nameLael=[[UILabel alloc]initWithFrame:CGRectMake(17, 12, 50, 35)];
    nameLael.text=@"姓名";
    nameLael.backgroundColor=[UIColor clearColor];
    nameLael.textColor=[UIColor blackColor];
    [nameLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    [scoller addSubview:nameLael];
    [nameLael release];
 //每个textfield下面是一个imageview
    UIImageView*nameView=[[UIImageView alloc]initWithFrame:CGRectMake(17, 47, 320-34, 40)];
    nameView.image=[UIImage imageNamed:@"textfield1.png"];
    [scoller addSubview:nameView];
    [nameView release];
   
    nameField=[[UITextField alloc]initWithFrame:CGRectMake(17, 47, 320-34, 40)];
    nameField.textColor=[UIColor blackColor];
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.backgroundColor=[UIColor clearColor];
    [scoller addSubview:nameField];
    nameField.delegate=self;
    [nameField release];
  
    //联系方式
    UILabel*phoneLael=[[UILabel alloc]initWithFrame:CGRectMake(17, 47+40+13, 50, 35)];
    phoneLael.text=@"电话";
    [phoneLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    phoneLael.backgroundColor=[UIColor clearColor];
    phoneLael.textColor=[UIColor blackColor];
    [scoller addSubview:phoneLael];
    [phoneLael release];
    //每个textfield下面是一个imageview

    UIImageView*phoneView=[[UIImageView alloc]initWithFrame:CGRectMake(17, 47+40+13+35+2, 320-34, 40)];
    phoneView.image=[UIImage imageNamed:@"textfield1.png"];
    [scoller addSubview:phoneView];
    [phoneView release];
    
    phoneField=[[UITextField alloc]initWithFrame:CGRectMake(17, 47+35+13+40+2, 320-34, 40)];
    phoneField.textColor=[UIColor blackColor];
    phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneField.backgroundColor=[UIColor clearColor];
    phoneField.delegate=self;
    [scoller addSubview:phoneField];
    [phoneField release];
//备注
    UILabel*commentLael=[[UILabel alloc]initWithFrame:CGRectMake(17, 47+35+13+40+2+40+13, 50, 35)];
    commentLael.text=@"备注";
    [commentLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    commentLael.backgroundColor=[UIColor clearColor];
    commentLael.textColor=[UIColor blackColor];
    [scoller addSubview:commentLael];
    [commentLael release];
    
    UIImageView*commentView=[[UIImageView alloc]initWithFrame:CGRectMake(17, 47+35+13+40+2+40+13+35+2,320-34, 80)];
    commentView.image=[UIImage imageNamed:@"textView1.png"];
    [scoller addSubview:commentView];
    [commentView release];
    
    commentField=[[UITextView alloc]initWithFrame:CGRectMake(17, 47+35+13+40+2+40+13+35+2,320-34, 80)];
    commentField.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    commentField.backgroundColor=[UIColor clearColor];
    commentField.delegate=self;
    commentField.textColor=[UIColor blackColor];
    [scoller addSubview:commentField];
    [commentField release];
*/
    
    //两个button
    UIButton*reloadData=[UIButton buttonWithType:UIButtonTypeCustom];
    [reloadData addTarget:self action:@selector(reSetting:) forControlEvents:UIControlEventTouchUpInside];
    reloadData.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [reloadData setBackgroundImage:[UIImage imageNamed:@"reset.png"] forState:UIControlStateNormal];
    reloadData.frame=CGRectMake(40,  47+35+13+40+2+40+13+35, 90, 40);
    [self.view addSubview:reloadData];
    
    UIButton*comitData=[UIButton buttonWithType:UIButtonTypeCustom];
    [comitData setBackgroundImage:[UIImage imageNamed:@"commit.png"] forState:UIControlStateNormal];
    comitData.frame=CGRectMake(50+90+35, 47+35+13+40+2+40+13+35, 90, 40);
    comitData.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    [comitData addTarget:self action:@selector(comitData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comitData];

}

//tableview的必须实现的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 2;
    
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*ident=@"ident";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident] autorelease];
    }
    cell.backgroundColor=[UIColor whiteColor];
    //设置用户名和密码是lable，后面是textfield
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //姓名
            UILabel*nameLael=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 35)];
            nameLael.text=@"姓名:";
            nameLael.backgroundColor=[UIColor clearColor];
            nameLael.textColor=[UIColor blackColor];
            [nameLael setFont:[UIFont systemFontOfSize:20]];
            [cell.contentView addSubview:nameLael];
             [nameLael release];
            //设置可填写框textfield
            nameField=[[UITextField alloc]initWithFrame:CGRectMake(60, 10, 150, 30)];
            nameField.backgroundColor=[UIColor clearColor];
            nameField.delegate=self;
            //对齐
            nameField.textAlignment=0;
            [cell.contentView addSubview:nameField];}
    if (indexPath.row==1) {
        //电话
        UILabel*nameLael=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 35)];
        nameLael.text=@"电话:";
        nameLael.backgroundColor=[UIColor clearColor];
        nameLael.textColor=[UIColor blackColor];
        [nameLael setFont:[UIFont systemFontOfSize:20]];
        [cell.contentView addSubview:nameLael];
        [nameLael release];
        //设置可填写框textfield
        phoneField=[[UITextField alloc]initWithFrame:CGRectMake(60, 10, 200, 30)];
        phoneField.backgroundColor=[UIColor clearColor];
        phoneField.delegate=self;
        //对齐
        phoneField.textAlignment=0;
        [cell.contentView addSubview:phoneField];
    }
   
    }
    return cell;

}

/*
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == phoneField) {
        //开始动画
        CGRect rect = scoller.frame;
        rect.origin.y = -30;
        [UIView animateWithDuration:0.3 animations:^{
            scoller.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //开始动画
    CGRect rect = scoller.frame;
    rect.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        scoller.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
    
}


#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == commentField) {
        //开始动画
        CGRect rect = scoller.frame;
        rect.origin.y = -150;
        [UIView animateWithDuration:0.3 animations:^{
            scoller.frame = rect;
        } completion:^(BOOL finished) {
            
        }];

    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        //开始动画
        CGRect rect = scoller.frame;
        rect.origin.y = 0;
        [UIView animateWithDuration:0.3 animations:^{
            scoller.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
        return NO;
        
    }
    
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
@end
