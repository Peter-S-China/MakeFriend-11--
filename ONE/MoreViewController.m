//
//  MoreViewController.m
//  ONE
//
//  Created by dianji on 12-12-3.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "MoreViewController.h"
#import "MailViewController.h"
#import "UserMessageViewController.h"
#import "AboutUsViewController.h"
#import "SelectedClassViewController.h"
#import "ClassNameListViewController.h"
#import "ListViewController.h"
#import "AddEventViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

@synthesize label;
-(void)locationYes:(NSNotification*)notifacation
{
   
   self.label.text=@"已开启";
     
}
-(void)locationNo:(NSNotification*)notifacation
{
 self.label.text=@"已关闭";
    
}
-(void)classNameList:(UIButton*)sender
{
    //从本地把数据拿到
    NSMutableArray*_buttonTitleArray=[[[NSMutableArray alloc]initWithObjects:@"时尚聚会",@"展会",@"演出",@"夜生活",@"电影",@"公益",@"运动",@"拍卖",@"其他", nil]autorelease];
    NSDictionary*_infosDic1=[[[NSDictionary alloc]init]autorelease];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"];
    NSMutableDictionary*  allDict = [[[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
    
    if ([_buttonTitleArray count]>0) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"cube";
        animation.subtype = kCATransitionFromRight;
        
        ClassNameListViewController*clv=[[ClassNameListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
        NSLog(@"1234567:%@",_infosDic1);
        clv.classDict=allDict;
        clv.titleArray = _buttonTitleArray;
        [self.navigationController pushViewController:clv animated:YES];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        [clv release];
    }
    else
    {
        [Tools showPrompt:@"没有数据，不能显示分类信息" inView:self.view delay:1.4];
        
    }
}

-(void)MaplistButtonClicked:(id)sender
{
    /*
    ListViewController*list=[[ListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    list.listInfos=self._searschInfos;
    [self.navigationController pushViewController:list animated:YES];
    [list release];
     */
}
-(void)turnOffButtonClicked:(id)sender
{
    
    if (_isHiddenTabbar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _isHiddenTabbar = NO;
    }
    else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect2=navScorllview.frame;
            rect2.origin.y = -self.view.bounds.size.height;
            navScorllview.frame=rect2;
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = YES;
        }];
        
    }
    
}


-(void)navButtonClicked:(UIButton*)sender
{
    switch (sender.tag) {
        case 800:
        {
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:0];
            
            break;
        }
        case 801:
        {
            [self MaplistButtonClicked:sender];
            break;
        }
        case 802://跳转到用户添加活动页面
        {
            AddEventViewController*add=[[AddEventViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
            [self.navigationController pushViewController:add animated:YES];
            [add release];
            
            break;
        }
        case 803:
        {
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:2];
            break;
        }
        case 804:
        {
            [self classNameList:sender];
            
            break;
        }
        case 805:
        {
            
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:1];
            
            
            break;
        }
        case 806:
        {
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:3];
            break;
        }
        case 807:
        {
            //      [self reloadClicked];
            break;
        }
        default:
            break;
    }
    
    
}


-(void)creatNavView
{
    //自定义navView,最下面一层是一个scrollew，一滑动就让navview消失
    navScorllview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    [navScorllview setContentSize: CGSizeMake(320, 600)] ;
    navScorllview.bounces=NO;
    navScorllview.backgroundColor=[UIColor clearColor];
    navScorllview.delegate=self;
    navScorllview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:navScorllview];
    [navScorllview release];
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 175)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navView.png"]];
    [navScorllview addSubview:navView];
    [navView release];
    for (int i=0; i<9; i++) {
        UIButton*navButton=[UIButton buttonWithType:UIButtonTypeCustom];
        navButton.frame=CGRectMake(12+(i%4)*88, 30+i/4*70, 32, 40);
        navButton.tag=800+i;
        [navButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"light%i",i+1]] forState:UIControlStateHighlighted];
        [navButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"norm%i",i+1]] forState:UIControlStateNormal];
        [navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:navButton];
        
    }
    UIButton*turnOffButton=[UIButton buttonWithType:UIButtonTypeCustom];
    turnOffButton.frame=CGRectMake(284, 148, 37, 35);
    [turnOffButton setImage:[UIImage imageNamed:@"turnOff-light.png"] forState:UIControlStateHighlighted];
    [turnOffButton setImage:[UIImage imageNamed:@"turnOff-norm.png"] forState:UIControlStateNormal];
    [turnOffButton addTarget:self action:@selector(turnOffButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:turnOffButton];
    
    
}


- (void)showTabBarAndNavi:(id)sender
{
    
    if (_isHiddenTabbar) {//如果隐藏，就不隐藏tabbar和自定的nav
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect rect2=navScorllview.frame;
            rect2.origin.y =0;
            navScorllview.frame=rect2;
            
            navScorllview.contentOffset=CGPointMake(0, 0);
            
            _tableView.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = NO;
        }];
        
    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect rect2=navScorllview.frame;
            rect2.origin.y = -self.view.bounds.size.height;
            navScorllview.frame=rect2;
            
            _tableView.frame=CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = YES;
        }];
    }
    
}

- (void)hiddenCoverView
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect2=navScorllview.frame;
        rect2.origin.y = -self.view.bounds.size.height;
        navScorllview.frame=rect2;
        
        
    } completion:^(BOOL finished) {
        _isHiddenTabbar = YES;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"更多";
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 28);
    [button setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateHighlighted];
    [button setTitle:@"导航" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(showTabBarAndNavi:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    */
    //创建登陆页面
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
   
    //设置tableview的背景颜色，ios6只能这么设定
    UIView* groundView = [[[UIView alloc]initWithFrame:_tableView.bounds] autorelease];
    UIImageView*back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addbackground.png"]];
    back.frame=groundView.bounds;
    [groundView addSubview:back];
    [back release];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor blackColor];
    _tableView.backgroundView = groundView;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.frame=CGRectMake(0, 0, 320, self.view.bounds.size.height -44);
    [self.view addSubview:_tableView];
    [_tableView release];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationYes:) name:@"LOCATIONYES" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNo:) name:@"LOCATIONNO" object:nil];
    
    _isHiddenTabbar = YES;
    [self creatNavView];
    UIButton*showNavButton=[UIButton buttonWithType:UIButtonTypeCustom];
    showNavButton.frame=CGRectMake(280, 0, 34, 20);
    [showNavButton setImage:[UIImage imageNamed:@"showaNav.png"] forState:UIControlStateNormal];
    [showNavButton addTarget:self action:@selector(showTabBarAndNavi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showNavButton];
    


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenCoverView];
    
  
    
}

//tableview的必须实现的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
   if (section==1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[[UITableViewCell alloc]init]autorelease];
    cell.userInteractionEnabled=YES;
    cell.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //设置用户名和密码是lable，后面是textfield
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UIButton*aboutJuJu=[UIButton buttonWithType:UIButtonTypeCustom];
            [aboutJuJu setTitle:@"关于我们" forState:UIControlStateNormal];
            [aboutJuJu addTarget:self action:@selector(aboutJUJU:) forControlEvents:UIControlEventTouchUpInside];
            aboutJuJu.titleLabel.font=[UIFont systemFontOfSize:18];
            [aboutJuJu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            aboutJuJu.frame=cell.frame;
            [cell.contentView addSubview:aboutJuJu];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(260, 13, 18, 18);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
            
        }
        //第二行
        if (indexPath.row==1) {
            UIButton*opinion=[UIButton buttonWithType:UIButtonTypeCustom];
            [opinion setTitle:@"意见反馈" forState:UIControlStateNormal];
            [opinion addTarget:self action:@selector(opinions:)
              forControlEvents:UIControlEventTouchUpInside];
            [opinion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            opinion.titleLabel.font=[UIFont systemFontOfSize:18];
            opinion.frame=cell.frame;
            [cell.contentView addSubview:opinion];
        }
        //第二行
        if (indexPath.row==2) {
            UIButton*share=[UIButton buttonWithType:UIButtonTypeCustom];
            [share setTitle:@"分享给朋友" forState:UIControlStateNormal];
            [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            [share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            share.titleLabel.font=[UIFont systemFontOfSize:18];
            share.frame=cell.frame;
            [cell.contentView addSubview:share];
            
            
            
        }
        
        
    }
    //意见反馈和分享给朋友
    if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            
            UIButton*message=[UIButton buttonWithType:UIButtonTypeCustom];
            [message setTitle:@"开启位置服务" forState:UIControlStateNormal];
            [message addTarget:self action:@selector(settingLocationMessage:) forControlEvents:UIControlEventTouchUpInside];
            message.titleLabel.font=[UIFont systemFontOfSize:18];
            [message setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [message.titleLabel setTextAlignment:UITextAlignmentLeft];
            message.frame=cell.frame;
            [cell.contentView addSubview:message];
            //在button上加上一个是否开放的状态
            label=[[UILabel alloc]initWithFrame:CGRectMake(260, 13, 40, 20)];
            label.textColor=[UIColor blackColor];
            label.text=@"已开启";
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:12];
            [cell addSubview:label];
            [label release];
        }
        //第二行
        if (indexPath.row==1) {
            UIButton*clean=[UIButton buttonWithType:UIButtonTypeCustom];
            [clean setTitle:@"清理缓存" forState:UIControlStateNormal];
            [clean addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
            [clean setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            clean.titleLabel.font=[UIFont systemFontOfSize:18];
            clean.frame=cell.frame;
            [cell.contentView addSubview:clean];
        }
        if (indexPath.row==2) {
            
            UIButton*userEvaluation=[UIButton buttonWithType:UIButtonTypeCustom];
            [userEvaluation setTitle:@"设置首页默认分类" forState:UIControlStateNormal];
            [userEvaluation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            userEvaluation.titleLabel.font=[UIFont systemFontOfSize:18];
            userEvaluation.frame=cell.frame;
            [userEvaluation addTarget:self action:@selector(sclectedClass:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:userEvaluation];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(260, 13, 18, 18);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
        }
        
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            
            
            UIButton*userEvaluation=[UIButton buttonWithType:UIButtonTypeCustom];
            [userEvaluation setTitle:@"用户信息修改" forState:UIControlStateNormal];
            [userEvaluation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            userEvaluation.titleLabel.font=[UIFont systemFontOfSize:18];
            userEvaluation.frame=cell.frame;
            [userEvaluation addTarget:self action:@selector(userEvaluation:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:userEvaluation];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(260, 13, 18, 18);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
        }
        
        
        
    }
    return cell;
}

-(void)settingLocationMessage:(id)sender
{
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"启动时是否对外开放位置信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开放",@"关闭", nil];
    alter.tag=1005;
    [alter show];
    [alter release];
    
    
}
-(void)aboutJUJU:(id)sender
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    AboutUsViewController*aboutus=[[AboutUsViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    [self.navigationController pushViewController:aboutus animated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];    
 
    [aboutus release];


}
-(void)userEvaluation:(id)sender
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    UserMessageViewController*list=[[UserMessageViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    [self.navigationController pushViewController:list animated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];    [list release];

}
-(void)opinions:(id)sender
{
Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
    
    
}
-(void)share:(id)sender
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:@"这款应用不错，来分享给身边的朋友吧" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"邮件分享" otherButtonTitles:nil,nil];
    action.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [action showFromTabBar:self.tabBarController.tabBar];
    [action release];

}
- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {//邮件分享
     
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        
        if (mailClass != nil)
        {
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else
        {
            [self launchMailAppOnDevice];  
        }
    }
  
    if (buttonIndex ==actionSheet.cancelButtonIndex)
    {
        actionSheet.hidden=YES;
                
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) {
        actionSheet.hidden=YES;
    }

}

//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"eMail主题"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"clickmatrix@163.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // 添加图片
    UIImage *addPic = [UIImage imageNamed: @"123.jpg"];
    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    // NSData *imageData = UIImageJPEGRepresentation(addPic, 1);    // jpeg
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"123.jpg"];
    
    NSString *emailBody = @"eMail 正文";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController: mailPicker animated:YES];
    [mailPicker release];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg = nil;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)clean:(id)sender
{
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"是否确定要清除缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag=1004;
    [alter show];
    [alter release];
    
}
-(void)sclectedClass:(id)sender
{

    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    SelectedClassViewController*list=[[SelectedClassViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    [self.navigationController pushViewController:list animated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];    [list release];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  //点击的是清理缓存按钮跳出来的alterview
    if (alertView.tag==1004 && buttonIndex == 1) {
       
 //       UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
        
        //给所有controller发送广播
        NSString *bcastName = @"reloadData";
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:bcastName object:self];
              
   [[MyTableBarController sharedTabBarController] setMySelectedIndex:0];
 }
    //点击的是设置位置信息按钮跳出来的alterview    
    
    if (alertView.tag==1005) {
        if (buttonIndex==1) {
            [[UserLocation sharedUserLocation]startGetLocation];
            label.text=@"已开启";
        }
        if (buttonIndex==2) {
            [[UserLocation sharedUserLocation]stopGetLocation];
            label.text=@"已关闭";
        }
    }
    if (alertView.tag == 1006) {
        if (buttonIndex == 1) {
            //去下载
            NSString *url = [WXApi getWXAppInstallUrl];
            NSLog(@"url = %@",url);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -ScorllViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if([scrollView isKindOfClass:[navScorllview class]]){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect2=navScorllview.frame;
            rect2.origin.y = -self.view.bounds.size.height;
            navScorllview.frame=rect2;
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = YES;
        }];
        
        
    }
       
    
    
}
@end
