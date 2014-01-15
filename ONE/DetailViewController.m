//
//  MapViewController.m
//  ONE
//
//  Created by dianji on 12-12-4.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "DetailViewController.h"
#import "MessagesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "AttentionViewController.h"
#import "PersonalMessageViewController.h"
#import "MapListViewController.h"
#import "JoinViewController.h"
#import "PersonalMessageViewController.h"
#import "ButtonDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "MessageInfo.h"
#import "ListViewController.h"
#import "LargeImageViewController.h"
@interface DetailViewController ()

@end
#define kDuration 0.4   // 动画持续时间(秒)

@implementation DetailViewController
@synthesize message;
@synthesize readView;
@synthesize addView;
@synthesize joinView;
@synthesize addFavArray;
@synthesize scView;
@synthesize pageCon;
@synthesize infosDict;
@synthesize _reloadInfo;
@synthesize navTitle;
@synthesize blueView;
@synthesize greenView;
@synthesize largeImageview;
@synthesize mediaFocusManager;

-(void)dealloc
{
    message=nil;
    readView=nil;
    self.mediaFocusManager = nil;
    [addView release];
    [joinView release];
    [addFavArray release];
    [scView release];
    [pageCon release];
    [infosDict release];
    [_reloadInfo release];
    [_info release];
    [super dealloc];
}
-(void)backButtonClicked:(UIButton*)sender
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

-(void)mapClicked:(id)sender
{
   //找到当前显示的信息，既messageInfo
    MapListViewController*map=[[MapListViewController alloc] initAndHiddenTabBar:YES hiddenLeftButton:YES];
    map.infos = [NSArray arrayWithObject:_info];
    [self.navigationController pushViewController:map animated:YES];
    
    [map release];
   
}
- (void)preImage:(id)sender
{
    if (scView.contentOffset.x < 270) {
        [Tools showPrompt:@"已经是第一页了" inView:self.view delay:1.4];
        return;
    }
    else {
        CGPoint point = scView.contentOffset;
        int page = floorf(point.x / 280);
        [scView setContentOffset:CGPointMake((page - 1) * 280, 0) animated:YES];
        MessageInfo *info = [[infosDict objectForKey:message.className] objectAtIndex:(point.x - 280)/280];
        _nameLabel.text = info.buttonTitle;
        [_info release];
        _info = [info retain];
        self.navigationItem.title = info.className;
    }
}

- (void)nextImage:(id)sender
{
    
    if (scView.contentOffset.x >= scView.contentSize.width - 280) {
        [Tools showPrompt:@"已经是最后一页了" inView:self.view delay:1.4];
        return;
    }
    else {
        CGPoint point = scView.contentOffset;
        int page = floorf(point.x / 280);
        [scView setContentOffset:CGPointMake((page + 1) * 280, 0) animated:YES];
        MessageInfo *info = [[infosDict objectForKey:message.className] objectAtIndex:(point.x + 280)/280];
        _nameLabel.text = info.buttonTitle;
        [_info release];
        _info = [info retain];
        self.navigationItem.title = info.className;
    }
}

//获取距离
- (void)getDistance
{
    NSArray*tituArray=[_info.location componentsSeparatedByString:@","];
    NSString*lantitude=[NSString stringWithFormat:@"%@",[tituArray objectAtIndex:1]];
    NSString*longtitude=[NSString stringWithFormat:@"%@",[tituArray objectAtIndex:0]];
    
    CLLocation *ogig = [[[CLLocation alloc] initWithLatitude:[[UserLocation sharedUserLocation] antitude] longitude:[[UserLocation sharedUserLocation] longtitude]] autorelease];
    
    
    CLLocation* dist=[[[CLLocation alloc] initWithLatitude:[lantitude doubleValue] longitude:[longtitude doubleValue] ] autorelease];
    
    CLLocationDistance kilometers=[ogig distanceFromLocation:dist]/1000000;

    detailDestance.text = [NSString stringWithFormat:@"%.1fKm", kilometers];
  //  NSLog(@"...destanceLabel.....%f",[ogig distanceFromLocation:dist]);
}

- (NSArray *)visiblePhotoViews
{
    NSMutableArray *vpv = [[NSMutableArray alloc] init];
    for (UIView *subview in scView.subviews) {
        if ([subview isKindOfClass:[DetailView class]] && CGRectIntersectsRect(scView.bounds, subview.frame)) {
            [vpv addObject:subview];
        }
    }
    return [vpv autorelease];
}
#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //初始化数据
    _showInfos = [infosDict objectForKey:message.className];
    
    UIImageView*detailview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460+[Tools isIphone5])];
    detailview.image=[UIImage imageNamed:@"BJ.png"];
    [self.view addSubview:detailview];
    [detailview release];
   
//主view的一些布局

    //添加上返回按钮
    
    left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 8, 60,30);
    [left setTitle:@"返回" forState:UIControlStateNormal];
    [left setTitle:@"返回" forState:UIControlStateHighlighted];
    left.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
  //添加聚聚的logo
    self.navigationItem.title = message.className;
    _info = [message retain];
   //把标题按钮和地图按钮加载一个imageview上
   
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    imageView.image=[UIImage imageNamed:@"detail_title.png"];
    [self.view addSubview:imageView];
    [imageView release];
    imageView.userInteractionEnabled=YES;
    
    //初始化视图上面的标题和地图按钮
    _nameLabel = [Tools createLabel:message.buttonTitle frame:CGRectMake(10, 0, CGRectGetWidth(self.view.bounds) - 125, 35) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] aliment:UITextAlignmentLeft];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [imageView addSubview:_nameLabel];
    
    UIButton *mapButton = [Tools createButtonWithNormalImage:@"Map" highlitedImage:@"Map" target:self action:@selector(mapClicked:)];
    mapButton.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame)+70, 0, 40, 35);
    [imageView addSubview:mapButton];
    //初始化scollview
    CGRect rect = CGRectMake(0, 45, 287, 357);
 //   rect.origin.x -= 10;
 //   rect.size.width += 20;
    scView=[[UIScrollView alloc]initWithFrame:rect];//CGRectMake(30, 40, 260, 300)];
    scView.pagingEnabled = YES;
    scView.clipsToBounds = NO;
    
    scView.showsHorizontalScrollIndicator = NO;
    currentPage_ = 0;
    totalPages_ = [[infosDict objectForKey:message.className]count];
    //设置scrollview的宽度，为n页内容
	//当前scrollview位置为第2页
	[self.scView setContentSize:CGSizeMake((rect.size.width) * [[infosDict objectForKey:message.className] count], 357)];
    self.scView.delegate = self;
    [self.view addSubview:scView];
    
    //初始化每个view
    //接收每个类de数据
    NSMutableArray *array=[infosDict objectForKey:message.className];
    int location = [array indexOfObject:self.message];
    self.scView.contentOffset = CGPointMake(rect.size.width * location , 0);
    
    for (MessageInfo*info in array) {
        int i = [array indexOfObject:info];
        DetailView *view = [[DetailView alloc] initWithFrame:CGRectMake(rect.size.width * i + 26.5, 0+[Tools isIphone5]/2, 267, 357) messageInfo:info delegate:self];
        
        [scView addSubview:view];
        [view release];
        
    }
    NSArray *pvs = [self visiblePhotoViews];
    for (DetailView *pv in pvs) {
        if ([pv isKindOfClass:[DetailView class]]) {
            [pv detailappear];
    
        }
    }
    self.pageCon.numberOfPages = totalPages_;
	self.pageCon.currentPage = 0;
 /*   //初始化左右两侧的按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(-8, 160, 40, 80);
    [leftButton addTarget:self action:@selector(preImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"right1.png"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(320 - 5-30 , 160, 40, 80);
    [rightButton addTarget:self action:@selector(nextImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
*/
_isFinished = YES;
    self.mediaFocusManager = [[[ASMediaFocusManager alloc] init] autorelease];
    self.mediaFocusManager.delegate = self;
    self.mediaFocusManager.elasticAnimation = NO;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationItem.title =self.navTitle;
    }


//传送感兴趣的信息给服务器
-(void)addEvent
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://matrix.clickharbour.com/pages/index.aspx?eventIdseeCount=%@",message.idNumber]];
    NSLog(@"传感兴趣的事件url = %@",url);
    [_request clearDelegatesAndCancel];
    [_request release];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request startAsynchronous];
    
    [_request setFailedBlock:^{
        NSLog(@"传送信息失败");
    }];
    [_request setCompletionBlock:^{
        NSLog(@"传送信息成功");
        NSLog(@"%@",_request.responseString);
    }];

}
#pragma mark scroll view delegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //翻页结束，更新一下标题
    MessageInfo *info = [[infosDict objectForKey:message.className] objectAtIndex:scrollView.contentOffset.x/287];
    [_info release];
    _info = [info retain];
    self.navigationItem.title = info.className;
    _nameLabel.text = info.buttonTitle;
    
    NSArray *pvs = [self visiblePhotoViews];
    for (DetailView *pv in pvs) {
        if ([pv isKindOfClass:[DetailView class]]) {
            [pv detailappear];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (!decelerate) {
        NSArray *pvs = [self visiblePhotoViews];
        for (DetailView *pv in pvs) {
            if ([pv isKindOfClass:[DetailView class]]) {
                [pv detailappear];
            }
        }
    }
    
}

#pragma mark - DetailView Delegate
- (void)detailView:(DetailView *)view addToFav:(MessageInfo *)info
{
    self._reloadInfo = info;
   
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:1];
    if ([nav.visibleViewController isKindOfClass:[AttentionViewController class]]) {
        AttentionViewController *attention= (AttentionViewController *)nav.visibleViewController;
        attention.message=info;
        //把信息存进本地文件
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"ADD_MESSAGEINFO_TO_LOCAL"] == nil) {//表示还没有添加东西到本地
            NSMutableArray *infos = [[NSMutableArray alloc] init];
            info.attention = [NSString stringWithFormat:@"%i",[info.attention intValue] + 1];
            [self addEvent];
            [infos addObject:info];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infos ] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
            [infos release];
        }
        else {//表示找到了数组。然后看看数组里面有没有，防止重复添加
            NSData *data = [defaults objectForKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
            NSMutableArray *infos = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
            BOOL isExit = NO;
            for (MessageInfo *sinfo in infos) {
                if ([sinfo.buttonTitle isEqualToString:info.buttonTitle]) {//有重复的
                    isExit = YES;
                    break;
                }
            }
            if (!isExit) {//如果不存在重复的才添加进数组
                [self addEvent];
                info.attention = [NSString stringWithFormat:@"%i",[info.attention intValue] + 1];
                [infos addObject:info];
                [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infos ] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
            }
            
        }
        [defaults synchronize];
        [[MyTableBarController sharedTabBarController] setMySelectedIndex:1];
    }

}
-(void)saveToLocalClicked:(UIButton*)button
{
    UIImageWriteToSavedPhotosAlbum( self.largeImageview.image, self, @selector ( image:didFinishSavingWithError:contextInfo:) , nil ) ;
}
- (void)detailView:(DetailView *)view largeImageClicked:(UIImageView *)imageView
{
    //初始化小图变大图动画的控件
    NSLog(@"imageview = %@",imageView);
   [self.mediaFocusManager installOnViews:[NSArray arrayWithObject:imageView]];
    self.largeImageview=imageView;
//    
//    right = [UIButton buttonWithType:UIButtonTypeCustom];
//    [right setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
//    right.frame = CGRectMake(230, 8, 50,30);
//    [right setTitle:@"保存" forState:UIControlStateNormal];
//    [right setTitle:@"保存" forState:UIControlStateHighlighted];
//    right.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
//    [right addTarget:self action:@selector(saveToLocalClicked:) forControlEvents:UIControlEventTouchUpInside];
//   
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right];
//    
//    self.navigationItem.rightBarButtonItem = item;
//   [item autorelease];
//    left.hidden=YES;

    
   }

- (void)detailView:(DetailView *)view joined:(MessageInfo *)info
{
 //在跳转之前先向服务器请求用户信息数据，如果设备已经存在，就跳出alterview提示已经注册，如果没有设备号才进入填写信息页面
    //测试设备号
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"UUID"]) {//已经提交过UUID
        NSString *strIdentifier=[defaults objectForKey:@"UUID"];
        
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?sureidentifier=%@&sureeventid=%@",strIdentifier,info.idNumber]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        NSLog(@",,url1..%@",url);
        [_request clearDelegatesAndCancel];
        [_request release];
        _request = [[ASIHTTPRequest alloc] initWithURL:url];
        [_request startAsynchronous];
        
        [_request setFailedBlock:^{
            NSLog(@"传送参与信息失败2");
            [Tools showPrompt:@"向服务器请求失败" inView:self.view delay:1.4];
            
        }];
        [_request setCompletionBlock:^{
            NSLog(@"传送参与信息成功2");
            NSLog(@" ..requst string ..%@",_request.responseString);
           
            if ([_request.responseString isEqualToString:@"1"] ) {// 提交过，但没有参加次活动
                NSLog(@"_request.responseString = %@",_request.responseString);
                UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，你已是注册用户，不需再填写信息咯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alter.tag=1011;
                [alter show];
                [alter release];
             
                
            }
           // 提交过，同时表示已经参加过此活动
           else
           {
               
        [Tools showPrompt:@"亲，你已参与此活动，恭候您的光临！" inView:self.view delay:1.0];
                
                //把返回的字符串解析出来存到本地
                NSArray*respons=[_request.responseString componentsSeparatedByString:@","];
                if ([respons count] >=2) {
                    NSDictionary *dic = @{ @"name" : [respons objectAtIndex:0], @"tel":[respons objectAtIndex:1]};
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (![[defaults objectForKey:@"USER_MESSAGEINFO_TO_LOCAL"]isEqual:dic]){
                        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dic ] forKey:@"USER_MESSAGEINFO_TO_LOCAL"];
                        [defaults synchronize];
                    }
                }
            }
        }];
        
        
        
    }
    else
    {
        NSString *strIdentifier=[Tools getUdid];
        [defaults setObject:strIdentifier forKey:@"UUID"];
        [defaults synchronize];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://matrix.clickharbour.com/pages/index.aspx?sureidentifier=%@&sureeventid=%@",strIdentifier,info.idNumber]];
        NSLog(@",,url..%@",url);
        [_request clearDelegatesAndCancel];
        [_request release];
        _request = [[ASIHTTPRequest alloc] initWithURL:url];
        [_request startAsynchronous];
        
        [_request setFailedBlock:^{
            
        [Tools showPrompt:@"向服务器请求失败" inView:self.view delay:1.4];
            
        }];
        [_request setCompletionBlock:^{
            NSLog(@"传送参与信息成功");
            
           
            if ([_request.responseString isEqualToString:@"1"]) {
                PersonalMessageViewController*text=[[PersonalMessageViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
                text._info=info;
                [self.navigationController pushViewController:text animated:YES];
                [text release];
            }
            else if([_request.responseString hasPrefix:@"<html>"])
            {
                [Tools showPrompt:@"访问的地址出错，请稍后再试" inView:self.view delay:1.4];
                
                
            }
            // 表示已经参加过此活动
            else{
                
            [Tools showPrompt:@"亲，你已参与此活动，恭候您的光临！" inView:self.view delay:1.0];
            
                //把返回的字符串解析出来存到本地
                NSArray*respons=[_request.responseString componentsSeparatedByString:@","];
                if ([respons count] >=2) {
                    NSDictionary *dic = @{ @"name" : [respons objectAtIndex:0], @"tel":[respons objectAtIndex:1]};
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (![[defaults objectForKey:@"USER_MESSAGEINFO_TO_LOCAL"]isEqual:dic]){
                        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dic ] forKey:@"USER_MESSAGEINFO_TO_LOCAL"];
                        [defaults synchronize];
                    }
                }
            
            }
         
        }];
    }
    
 }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1011){
        if (buttonIndex==1) {
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
                    
                    [self addEvent];
                    [infos addObject:_info];
                    [joindefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infos ] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                    [self addEvent];
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
                        [self addEvent];
                        
                    }
                    
                }
                [joindefaults synchronize];
                [[MyTableBarController sharedTabBarController] setMySelectedIndex:2];
            }
        }
    }
}
- (void)detailView:(DetailView *)view detail:(MessageInfo *)info
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    
    ButtonDetailViewController*button=[[ButtonDetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    button._info=info;
    [self.navigationController pushViewController:button animated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];    
    [button release];

}
- (void)detailView:(DetailView *)view
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:@"拨打电话咨询" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:message.tel otherButtonTitles:nil,nil];
    action.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    
    [action showInView:self.view];
    [action release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.tel]];
    }
//    if (buttonIndex==1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-6589018"]];
//    }
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - ASMediaFocusDelegate
- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    return ((UIImageView *)view).image;
    
    
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y =20;
   rect.size.height -= 20;
    return rect;
//    return self.view.bounds;
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.navigationController;
    
}
-(void)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finishedClickedForView:(UIView*)view
{
    left.hidden=NO;
//    right.hidden=YES;

}
#pragma mark-SAVEIMAGE-delegate
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
 //   right.hidden=YES;
    if (error != NULL)
    {
        NSLog(@"%@",error);
        
    }
    else
    {
        [Tools showPrompt:@"图片保存成功!可以去相册看看啦!"inView:self.view delay:0.7];
    }
}



@end
