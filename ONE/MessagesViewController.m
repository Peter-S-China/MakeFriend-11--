//
//  MessagesViewController.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "MessagesViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "MessageInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "MapListViewController.h"
#import "UserLocation.h"
#import "MobClick.h"
#import "Reachability.h"
#import "ListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ClassNameListViewController.h"
#import "AddEventViewController.h"
#import "UIImageView+WebCache.h"
@implementation MessagesViewController


#define kDuration 0.4   // 动画持续时间(秒)

@synthesize _infosDic,_infos,classNameArray,pageScrollView,selectedName,player,messageScrollView;

-(void)dealloc
{
    [messageScrollView release];
    [classNameArray release];
    [_infos release];
    [_infosDic release];
    [super dealloc];

}

-(id)initWithTitle:(NSString*)title navTitle:(NSString*)navTitle
{
    if (self=[super initAndHiddenTabBar:YES hiddenLeftButton:YES]) {
        self.title=title;
        self.navigationItem.title=navTitle;
        UIImage*image=nil;
        //fa_norm.png
        image=[UIImage imageNamed:@"fa_norm.png"];
        self.tabBarItem.image=image;
    }
    return self;

}



//影藏和显示classView
- (void)handleClassView:(id)sender
{
    if (CGRectGetMinX(_classView.frame) >= 0) {
        //影藏
        [_arrowButton setImage:[UIImage imageNamed: @"hiddenNo.png"]forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = _classView.frame;
            rect.origin.x = -25;
            _classView.frame = rect;
            rect = _arrowButton.frame;
            rect.origin.x = 0;
            _arrowButton.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        //出现
        [UIView animateWithDuration:1 animations:^{
            CGRect rect = _classView.frame;
            rect.origin.x = 0;
            _classView.frame = rect;
            rect = _arrowButton.frame;
            rect.origin.x = 25;
            _arrowButton.frame = rect;
     [_arrowButton setImage:[UIImage imageNamed: @"hiddenYes.png" ]forState:UIControlStateNormal];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
//选择分类
- (void)chooseClass
{
    NSMutableArray*array9=[NSMutableArray array];
    if ([selectedName isEqualToString:@"全部"]) {
        [array9 addObjectsFromArray:allArray];
    }
    else {
        for(MessageInfo*info in allArray){
            if ([selectedName hasPrefix:info.className]) {
                [array9 addObject:info];
                
            }
            
        }
    }
        
    self.selectedName = @"";
    NSLog(@"%i",[array9 count]);
    for (int i=0; i < ceil([array9 count]/6.0); i++) {
        
        NSMutableArray*array=[NSMutableArray array];
        NSRange range = NSMakeRange(0, 0);
        range.location = i * 6;
        range.length = [array9 count] - i * 6 >=6 ? 6 : [array9 count] - i * 6;
        [array addObjectsFromArray:[array9 subarrayWithRange:range]];
        MessageCell *cell=[[MessageCell alloc]initWithFrame:CGRectMake(0,i*(245+2)+151, 320 , 245) title:nil infos:array delegate:self];
        [_scrollView addSubview:cell];
        [cell release];
        CGSize size = _scrollView.contentSize;
        size.height = 151+(i + 1)*(246+6);
        _scrollView.contentSize = size;
    }
        NSArray *pvs = [self visiblePhotoViews];
        for (MessageCell *pv in pvs) {
            if ([pv isKindOfClass:[MessageCell class]]) {
                [pv appear];
            }
        }
    
}
//上啦加载更多，下拉刷新完成时调用得
-(void)refreshFinished
{
    _refreshing = NO;
//    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
    NSMutableArray*array=[[NSMutableArray alloc]initWithCapacity:0];
    int count=0;
    for (int i=0; i<[_buttonTitleArray count]; i++) {
        array=[_infosDic objectForKey:[_buttonTitleArray objectAtIndex:i]];
        count+=[array count];
    }
    [array release];
    [Tools showPrompt:[NSString stringWithFormat:@"你刚刚获得了%i条活动信息",count] inView:self.view delay:1.4];
}

//将下载的数据解析出来
- (void)parseInfoToModal:(NSArray *)array
{
    if (_infosDic == nil) {
        _infosDic = [[NSMutableDictionary alloc] init];
        _buttonTitleArray=[[NSMutableArray alloc]initWithCapacity:10];
        classNameArray=[[NSMutableArray alloc]initWithCapacity:10];
        
    }
    else {
        [_infosDic removeAllObjects];
        [_buttonTitleArray removeAllObjects];
        [classNameArray removeAllObjects];
    }
    //
    if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
        allArray=[[NSMutableArray alloc]initWithCapacity:0];        
        for(NSDictionary *dic in array) {
            MessageInfo *info = [[MessageInfo alloc] init];
            //标题
            info.buttonTitle=[dic objectForKey:@"title"];
            
            //开始结束时间
            NSString*starttime = [dic objectForKey:@"starttime"];
            NSRange range = NSMakeRange(6, 10);
            starttime = [starttime substringWithRange:range];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[starttime doubleValue]];
            
            //结束时间
            NSString*endtime=[dic objectForKey:@"endtime"];
            NSRange range1=NSMakeRange(6, 10);
            endtime=[endtime substringWithRange:range1];
            NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:[endtime doubleValue]];
            
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"yyyy年MM月dd日HH时mm分"];
            info.startTime=[fm stringFromDate:date];
            info.endTime=[fm stringFromDate:enddate];
            
            [fm release];
            
            
            //关注度
            info.attention=[NSString stringWithFormat:
                            @"%@",[dic objectForKey:@"seecount"]];
            //参与人数
            info.joinedNumber=[NSString stringWithFormat:
                               @"%@",[dic objectForKey:@"joincount"]];
            
            
            //图片海报url
            info.photoURL=[dic objectForKey:@"pic"];
            info.detailPhotoURL=[dic objectForKey:@"dataits"];
            //类别
            info.className=[dic objectForKey:@"classname"];
            [classNameArray addObject:info.className];
            
            //地点
            info.dest=[dic objectForKey:@"cityaddress"];
            
            //内容
            info.abstract=[dic objectForKey:@"contents"];
            //经纬度
            info.location = [dic objectForKey:@"tudu"];
          
            //存时间id号
            info.idNumber=[dic objectForKey:@"id"];
            //主办方的联系方式
            info.tel=[dic objectForKey:@"tel"];
            
            [allArray addObject:info];
            if (![info.className isKindOfClass:[NSNull class]] && info.className.length > 0) {
                //把一行存入一个分类
                if (![_buttonTitleArray containsObject:info.className]) {
                    [_buttonTitleArray addObject:info.className];
                }
                if ([_infosDic objectForKey:info.className] == nil) {
                    NSLog(@"%@",info.className);
                    _infos = [[[NSMutableArray alloc] init] autorelease];
                    [_infos addObject:info];
                    [_infosDic setObject:_infos forKey:info.className];
                    //把所有字典存入本地
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (![[defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"]isEqual:_infosDic]){
                        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_infosDic ] forKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"];
                        [defaults synchronize];
                    
                    }
                
                }
                else {
                    NSMutableArray *infos = [_infosDic objectForKey:info.className];
                    [infos addObject:info];
                    [_infosDic setObject:infos forKey:info.className];
                    //把所有字典存入本地
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (![[defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"]isEqual:_infosDic]){
                        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_infosDic ] forKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"];
                        [defaults synchronize];
                    
                    }
                }
            }
            
            [info release];
            
        }
    }
     NSLog(@"%i",[allArray count]);
    //首先移除scrollView上的东西
   
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[MessageCell class]]) {
            [view removeFromSuperview];
        }
        
    }

   //如果是进入过最后的设置页面
    if (selectedName.length>0) {
        [self chooseClass];
    }
   else{//没有进入过，正常情况下
    
     for (int i=0; i< ceil([allArray count]/6.0); i++) {
        NSMutableArray*array=[NSMutableArray array];
        NSRange range = NSMakeRange(0, 0);
        range.location = i * 6;
        range.length = [allArray count] - i * 6 >=6 ? 6 : [allArray count] - i * 6;
        [array addObjectsFromArray:[allArray subarrayWithRange:range]];
        MessageCell *cell=[[MessageCell alloc]initWithFrame:CGRectMake(0,i*(218)+151, 320, 218) title:nil infos:array delegate:self];
        [_scrollView addSubview:cell];
        [cell release];
        CGSize size = _scrollView.contentSize;
        size.height = (i + 1)*(218)+151;
        _scrollView.contentSize = size;
    }
}
 
    //加载完成后停止显示headerView
//    [self refreshFinished];

}
- (void) playBackgroundSoundEffect {
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource: @"SE007"
                                    ofType: @"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    [fileURL release];
    self.player = newPlayer;
    [newPlayer release];
    [self.player prepareToPlay];
    
    [self.player setDelegate: self];
    self.player.numberOfLoops =0;    // Loop playback until invoke stop method
    [self.player play];
}
-(void)requstAddInfo
{
    [Tools showSpinnerInView:self.navigationController.view prompt:nil];
    NSString *downLoadURL = nil;
    downLoadURL=[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?advert=w&count=4"];
    NSURL*url=[NSURL URLWithString:downLoadURL];
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:url];
    //启动异步下载
//    requst.downloadProgressDelegate=self;
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
     NSLog(@"请求数据失败");
    [Tools hideSpinnerInView:self.navigationController.view];
    [self creatMessagePageScrollView:addArray];
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        [Tools hideSpinnerInView:self.navigationController.view];
        //开始sbjson解析
        SBJsonParser*sbjs=[[[SBJsonParser alloc]init]autorelease];
        
        NSString*date=[[NSString alloc]initWithData:[requst responseData] encoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSArray *array = [sbjs objectWithString:date error:&error];
        [date release];
        NSLog(@"%i",[array count]);
        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
            addArray=[[NSMutableArray alloc]initWithCapacity:0];
            for(NSDictionary *dic in array) {
                AddInfo *info = [[AddInfo alloc] init];
                //标题
                info.adName=[dic objectForKey:@"ad_name"];
                //广告内容
                info.adContent=[dic objectForKey:@"ad_content"];
                //时间
                info.adDate=[dic objectForKey:@"ad_date"];
                //广告图片链接地址
                info.adPictureUrl=[dic objectForKey:@"pic_route"];
                NSLog(@"....adPictureUrl....:%@",info.adPictureUrl);
                [addArray addObject:info];

                
            }
            NSLog(@"%i",[addArray count]);
            NSLog(@"%i",[addArray count]);
            [self creatMessagePageScrollView:addArray];
        }
        else
        {
         NSLog(@"数据为空 ");
            if (requestAddCount>2) {
                [Tools showPrompt:@"服务器返回数据为空" inView:self.view delay:0.4];
            }
            else
            {
                [self requstAddInfo];
            }
            requestAddCount++;
        }
     
    }];
    
}
-(void)requestFirstInfo
{
    
    _progressBar.hidden = NO;
    _progressLabel.hidden = NO;
    _progressBar.progress = 0;
    _progressLabel.text = @"0.0%";
    [Tools showSpinnerInView:self.navigationController.view prompt:@"加载中..."];
    // http://matrix.clickharbour.com/pages/index.aspx?title=all&count=180
    NSString *downLoadURL = nil;
    
    downLoadURL=[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?title=all&count=180"];
       
  
    NSLog(@"...downLoadURL...%@",downLoadURL);
    NSURL*url=[NSURL URLWithString:downLoadURL];
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:url];
    //启动异步下载
    requst.downloadProgressDelegate=self;
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        NSLog(@"请求数据失败");
        [Tools hideSpinnerInView:self.navigationController.view];
        _progressBar.hidden=YES;
        _progressLabel.hidden=YES;
        //显示上面的navigationbar
        if (images!= nil) {
            images.hidden=YES;
            images = nil;
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
            // 这里判断是否第一次
  //          pageScrollView.hidden=NO;
        }
        else{
            pageScrollView.hidden=YES;
        }
   //这里判断加载失败是网络问题还是暂时的问题
        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
        if ([r currentReachabilityStatus]==NotReachable) {//没有网络

            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，你当前的网络好像不给力额，是否读取本地数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alter show];
            [alter release];
        }
        else{//有网络
         
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"RE_ADD_MESSAGEINFO_TO_LOCAL"] == nil) {
            //有可能请求失败只是暂时的，多请求几次，三次以上不成功就判定为网络问题
            if (requestCount>2) {
                  [Tools showPrompt:@"亲，您当前的网络好像不给力额，请点击刷新按钮重试" inView:pageScrollView delay:0.3];            }
            else{
                
            [self reloadClicked];
                
            }
            requestCount++;
        }
        else {
            
           
               UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，连接服务器失败，是否读取本地数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]; 
                [alter show];
                [alter release];
          
            
        }
            
 
        }
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
            
        [Tools hideSpinnerInView:self.navigationController.view];        
          NSLog(@"请求数据成功");
  

        _progressLabel.hidden=YES;
        _progressBar.hidden=YES;
        //显示上面的navigationbar
        [Tools hideSpinnerInView:self.navigationController.view];
        if (images!= nil) {
            images.hidden=YES ;
            images = nil;
        }
        // 这里判断是否第一次登陆
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
            // 这里判断是否第一次
   //         pageScrollView.hidden=NO;
        }
        else{
            pageScrollView.hidden=YES;
        }
        
        //开始sbjson解析
        SBJsonParser*sbjs=[[[SBJsonParser alloc]init]autorelease];
        
        NSString*date=[[NSString alloc]initWithData:[requst responseData] encoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSArray *array = [sbjs objectWithString:date error:&error];
        [date release];
        if ([array count] > 0) {
            
            [self parseInfoToModal:array];
            //先把数据保存在本地,只要成功就覆盖原来旧的信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:array ] forKey:@"RE_ADD_MESSAGEINFO_TO_LOCAL"];
            [defaults synchronize];
            
        }
        else{
           
            if (requestCount>2) {
                [Tools showPrompt:@"请求数据成功，服务器没有数据返回，请稍后重试" inView:pageScrollView delay:0.3];
            }
            else{
                [self reloadClicked];
            }
            requestCount++;
            
        }
        NSArray *pvs = [self visiblePhotoViews];
        for (MessageCell *pv in pvs) {
            if ([pv isKindOfClass:[MessageCell class]]) {
                [pv appear];
            }
          }
        
    }];
    
}

#pragma mark - AlterViewDelegate
//没有数据时，点击确定读取本地的数据
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (buttonIndex==1) {
        //本地有数据，那就解析出来
    NSData *data = [defaults objectForKey:@"RE_ADD_MESSAGEINFO_TO_LOCAL"];
        NSArray *infos = [[[NSArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
        if ([infos count]>0) {
            [self parseInfoToModal:infos];

        }
        else
        {
            
            [Tools showPrompt:@"本地也没有数据，请稍后重试" inView:self.view delay:1.4];
        }
            }

}
-(void)MaplistButtonClicked:(id)sender
{
    NSMutableArray *infos = [NSMutableArray array];
    for(NSString * className in _buttonTitleArray){
        NSArray *array=[_infosDic objectForKey:className];
        for (MessageInfo *info in array) {
            [infos addObject:info];
        }
        NSLog(@"array = %i",[array count]);
    }
    
    ListViewController*list=[[ListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    list.listInfos=infos;
    [self.navigationController pushViewController:list animated:YES];
    [list release];
  }
-(void)reloadClicked
{
    if ([_buttonTitleArray count] > 0) {
        for (UIView * cell in _scrollView.subviews) {
            if ([cell isKindOfClass:[MessageCell class]]) {
                [cell removeFromSuperview];
            }
        }
        _scrollView.contentSize = CGSizeMake(0, 0);
    }
    //设置button
    if (_arrowButton != nil) {
        CGRect rect = _arrowButton.frame;
        rect.origin.x = 0;
        _arrowButton.frame = rect;
        _arrowButton.hidden = YES;
    }
    //清除classView
    if (_classView != nil) {
        [_classView removeFromSuperview];
    }
    [self requestFirstInfo];
    
}
//接受通知调用方法
-(void)clean:(NSNotification *)notification
{
    
    [self reloadClicked];

}
-(void)comeInNow:(UIButton*)sender
{
    
    if (CGRectGetMaxX(pageScrollView.frame) > 0){
        //隐藏
        [UIView animateWithDuration:1 animations:^{
            CGRect rect = pageScrollView.frame;
            rect.origin.x = -5*320;
            rect.size.width = 320;
            pageScrollView.frame = rect;
            
        } completion:^(BOOL finished) {
           
        }];
    }
/*
    
    if (pageScrollView!=nil) {
        pageScrollView.hidden=YES;
        pageScrollView=nil;
    }
    if (pageControl!=nil) {
        pageControl.hidden=YES;
        pageControl=nil;
     }
*/
}
-(void)classNameList:(UIButton*)sender
{
    if ([_buttonTitleArray count]>0) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"cube";
        animation.subtype = kCATransitionFromRight;
        
        ClassNameListViewController*clv=[[ClassNameListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
        clv.classDict=_infosDic;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[MyTableBarController sharedTabBarController] hideTabbar:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isHiddenTabbar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self hiddenCoverView];
     _tabBarView.index = 0;
    if (selectedName.length > 0) {
        if ([allArray count] > 0) {
            //首先移除scrollView上的东西
            for (UIView *view in _scrollView.subviews) {
                [view removeFromSuperview];
            }
            [self chooseClass];

        }
        else {
            [self requestFirstInfo];
        }
    }
    
}
#pragma mark DDPageControl triggered actions

- (void)pageControlClicked:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	
	// we need to scroll to the new index
	[messageScrollView setContentOffset: CGPointMake(messageScrollView.bounds.size.width * thePageControl.currentPage, messageScrollView.contentOffset.y) animated: YES] ;
}
-(void)scrollScrollView:(NSTimer *)timer
{
    if (curentPage>3) {
        curentPage=0;
        [messageScrollView setContentOffset: CGPointMake(messageScrollView.bounds.size.width * curentPage, messageScrollView.contentOffset.y) animated: YES] ;
        curentPage++;
    }
    else{
  [messageScrollView setContentOffset: CGPointMake(messageScrollView.bounds.size.width * curentPage, messageScrollView.contentOffset.y) animated: YES] ;
        curentPage++;
    }

}
- (void)showTabBarAndNavi:(id)sender
{
    
    if (_isHiddenTabbar) {//如果隐藏，就不隐藏tabbar和自定的nav
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect2=navScorllview.frame;
            rect2.origin.y =0;
            navScorllview.frame=rect2;
            
            navScorllview.contentOffset=CGPointMake(0, 0);
            
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = NO;
        }];
        
    }
    else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect2=navScorllview.frame;
            rect2.origin.y = -self.view.bounds.size.height;
            navScorllview.frame=rect2;
            
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = YES;
        }];
    }
    
}


-(void)creatMessagePageScrollView:(NSMutableArray*)array
{
    int numberOfPages = 4;
    messageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320 , 151)];
    messageScrollView.backgroundColor=[UIColor whiteColor];
    messageScrollView.delegate=self;
    [messageScrollView setPagingEnabled: YES] ;
    //滚动到达边界会立刻停止，以免看到下面的东西
    messageScrollView.bounces=NO;
	[messageScrollView setContentSize: CGSizeMake(messageScrollView.bounds.size.width * numberOfPages, messageScrollView.bounds.size.height)] ;
  
    if ([array count] > 0) {
        numberOfPages = [array count];
        for (int i = 0 ; i < numberOfPages ; i++) {
            AddInfo *info=[array objectAtIndex:i];
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i * messageScrollView.bounds.size.width, 0.0f, messageScrollView.bounds.size.width, messageScrollView.bounds.size.height)];
            [imageview setImageWithURL:[NSURL URLWithString:info.adPictureUrl] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",31+i]]];
            messageScrollView.hidden=NO;
            [messageScrollView addSubview:imageview];
            [imageview release];
            
            
        }

    }
/*    else{
        for (int i = 0 ; i < numberOfPages+1 ; i++) {
            UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i * messageScrollView.bounds.size.width, 0.0f, messageScrollView.bounds.size.width, messageScrollView.bounds.size.height)];
           imageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",31+i]];
            messageScrollView.hidden=NO;
            [messageScrollView addSubview:imageview];
            [imageview release];
            
            
        }

    
    
    }*/
    messageScrollView.showsHorizontalScrollIndicator=NO;
    [_scrollView addSubview:messageScrollView];
    [messageScrollView release];
    
    messagePageControl = [[DDPageControl alloc] init] ;
	[messagePageControl setCenter: CGPointMake(self.view.center.x, messageScrollView.bounds.size.height-15.0f)] ;
	[messagePageControl setNumberOfPages: numberOfPages] ;
	[messagePageControl setCurrentPage: 0] ;
	[messagePageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[messagePageControl setDefersCurrentPageDisplay: YES] ;
	[messagePageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[messagePageControl setOnColor: [UIColor yellowColor]] ;
	[messagePageControl setOffColor: [UIColor whiteColor]] ;
	[messagePageControl setIndicatorDiameter: 8.0f] ;
	[messagePageControl setIndicatorSpace: 10.0f] ;
	[_scrollView addSubview: messagePageControl] ;
	[messagePageControl release] ;
    

    
     [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
}

- (void)hiddenCoverView
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect2=navScorllview.frame;
        rect2.origin.y = -navScorllview.contentSize.height;
        navScorllview.frame=rect2;
        
        
    } completion:^(BOOL finished) {
        _isHiddenTabbar = YES;
    }];
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
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:4];
            break;
        }
        default:
            break;
    }


}
-(void)turnOffButtonClicked:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect2=navScorllview.frame;
        rect2.origin.y = -self.view.bounds.size.height;
        navScorllview.frame=rect2;
        
    } completion:^(BOOL finished) {
        _isHiddenTabbar = YES;
    }];


}
-(void)creatNavView
{
    //自定义navView,最下面一层是一个scrollew，一滑动就让navview消失
    navScorllview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    [navScorllview setContentSize: CGSizeMake(320, 600)] ;
    navScorllview.bounces=NO;
    navScorllview.backgroundColor=[UIColor colorWithWhite:0 alpha:0.4];
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
turnOffButton.frame=CGRectMake(285, 145, 37, 32);
[turnOffButton setImage:[UIImage imageNamed:@"turnOff-light.png"] forState:UIControlStateHighlighted];
[turnOffButton setImage:[UIImage imageNamed:@"turnOff-norm.png"] forState:UIControlStateNormal];
[turnOffButton addTarget:self action:@selector(turnOffButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
[navView addSubview:turnOffButton];


}
-(void)viewDidLoad
{
    [super viewDidLoad];
    requestCount=0;
    requestAddCount=0;
    curentPage=0;
    [MobClick event:@"load"];
//   [MyTableBarController sharedTabBarController].doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTabBarAndNavi:)] autorelease];
//   [MyTableBarController sharedTabBarController].doubleTap.numberOfTapsRequired = 2;
//    [self.view addGestureRecognizer:[MyTableBarController sharedTabBarController].doubleTap];
      
    //一加载就有声音
//    [self playBackgroundSoundEffect];
  //发通知告诉最后一个页面是否开启位置服务信息
    if ([CLLocationManager locationServicesEnabled]) {
        [[UserLocation sharedUserLocation] startGetLocation];
       
        NSString *bcastName = @"LOCATIONYES";
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:bcastName object:self];
        
    }
    else
    {
        [[UserLocation sharedUserLocation] stopGetLocation];
        NSString *bcastName = @"LOCATIONNO";
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:bcastName object:self];
    }

  //隐藏上面的navigationbar
   [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[MyTableBarController sharedTabBarController] hideTabbar:YES];
    _isHiddenTabbar = YES;
//在imageview上添加三个按钮
    UIBarButtonItem *left = [Tools createNavButtonItem:@"FAN3" selected:@"FAN2" target:self action:@selector(MaplistButtonClicked:)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [Tools createNavButtonItem:@"reload_nom" selected:@"reload_selected" target:self action:@selector(reloadClicked)];
    self.navigationItem.rightBarButtonItem = right;
//添加logo view
   
    UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOGO.png"]];
    UIButton*listButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [listButton addTarget:self action:@selector(classNameList:) forControlEvents:UIControlEventTouchUpInside];
    listButton.frame=imageview.frame;
    listButton.backgroundColor=[UIColor clearColor];
    imageview.userInteractionEnabled=YES;
    [imageview addSubview:listButton];
    self.navigationItem.titleView=imageview;
    [imageview release];
  
    //创建scorllview并在大的scorllview上加载小的scollview，5行，一行四个view，可显示区域为2个
 //再创建一个带pagecontroll的scrollview
    

    
    //创建大的scollview
    
    
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.delegate=self;
      if (_isHiddenTabbar) {//460-151+[Tools isIphone5]
          _scrollView.frame=CGRectMake(0, 0, 320 ,self.view.bounds.size.height );
    }
    else{
        _scrollView.frame=CGRectMake(0, 0, 320 , 460 - 44 - 49+[Tools isIphone5]);
    }
    _scrollView.delegate=self;
    _scrollView.bounces=NO;
    //backLight.png
    UIImage*img=[UIImage imageNamed:@"background1.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    [self.view addSubview:_scrollView];
    
    
//在进度条的下面才有一个layer，是scrollview，pagecontroller
     NSUInteger numberOfPages1 = 4;
    //加载scrollview
    pageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480+[Tools isIphone5])];
    [pageScrollView setPagingEnabled: YES] ;
    //滚动到达边界会立刻停止，以免看到下面的东西
   
	[pageScrollView setContentSize: CGSizeMake(pageScrollView.bounds.size.width * numberOfPages1, pageScrollView.bounds.size.height)] ;
    
    for (int i = 0 ; i < numberOfPages1 ; i++) {
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(i * pageScrollView.bounds.size.width, 0.0f, pageScrollView.bounds.size.width, pageScrollView.bounds.size.height)];
        imageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i",11+i]];
        UIButton*comeIn=[UIButton buttonWithType:UIButtonTypeCustom];
        comeIn.frame=CGRectMake(4 * pageScrollView.bounds.size.width-200, 393, 80, 40);
        [comeIn setTitle:@"点击进入" forState:UIControlStateNormal];
        [comeIn setBackgroundImage:[UIImage imageNamed:@"comeInBUtton.png"] forState:UIControlStateNormal];
        [comeIn setBackgroundImage:[UIImage imageNamed:@"comeInClicked.png"] forState:UIControlStateSelected];
        [comeIn addTarget:self action:@selector(comeInNow:) forControlEvents:UIControlEventTouchUpInside];
        pageScrollView.hidden=YES;
        [pageScrollView addSubview:imageview];
        [pageScrollView addSubview:comeIn];
        [imageview release];
        
        
    }
    pageScrollView.showsHorizontalScrollIndicator=NO;
     pageScrollView.bounces=NO;
    [self.view addSubview:pageScrollView];
    [pageScrollView release];
    
    //承载进度条得imageview
    images=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480+[Tools isIphone5])];
    images.image=[UIImage imageNamed:@"firstImage.png"];
    [self.view addSubview:images];
//创建进度条
    _progressBar = [[YLProgressBar alloc] initWithFrame:CGRectMake(0, 0, 250, 10)];
    _progressBar.center = CGPointMake(160, 430+[Tools isIphone5]);
    [images addSubview:_progressBar];
    
    _progressLabel = [Tools createLabel:@"0.0%" frame:CGRectMake(0, 0, 200, 20) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:20] aliment:UITextAlignmentCenter];
    _progressLabel.center = CGPointMake(160, 460+[Tools isIphone5]);
    [images addSubview:_progressLabel];
   
//隐藏下面得tabbar
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	[window addSubview:images];
    [window addSubview:pageScrollView];
    
     [images release];
     [_progressBar release];
    [self requestFirstInfo];
    [self requstAddInfo];
  //  [self reloadClicked];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clean:) name:@"reloadData" object:nil];
    
    
    //自定义TabBar
    _tabBarView = [[TabBarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), 320, 49)];
    _tabBarView.delegate = self;
    [self.view addSubview:_tabBarView];
    _tabBarView.index = 0;
    [_tabBarView release];
    
     [self creatNavView];
    UIButton*showNavButton=[UIButton buttonWithType:UIButtonTypeCustom];
    showNavButton.frame=CGRectMake(280, 0, 34, 20);
    [showNavButton setImage:[UIImage imageNamed:@"showaNav.png"] forState:UIControlStateNormal];
    [showNavButton addTarget:self action:@selector(showTabBarAndNavi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showNavButton];
    
    
    
}

//实现button的协议方法
//如果message
#pragma mark - MessageButton Delegate
-(void)messageButton:(MessageButton *)button selectedInfo:(MessageInfo *)info
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    
    DetailViewController *dvc=[[DetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    dvc.message=info;
    dvc.navTitle = info.className;
    NSLog(@"imageUrl:%@",info.photoURL);
    NSLog(@"detailPhotoUrl:%@",info.detailPhotoURL);
    NSLog(@"stattime-endtime %@-%@",info.startTime,info.endTime);
    dvc.infosDict=self._infosDic;
    [self.navigationController pushViewController:dvc animated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [dvc release];
    //统计那一张图片被点击以及点击次数
    [MobClick event:@"clickimage"];
    
}

#pragma mark ASIHTTPRequestDelegate
- (void)setProgress:(float)newProgress {//进度条的代理
	
	NSLog(@"newProgress %g",newProgress);
    [_progressLabel setText:[NSString stringWithFormat:@"%.0f%%", (newProgress * 100)]];
    _progressBar.progress = newProgress;

}

#pragma mark - scorllview delegate

//前两个是下拉刷新应该实现得方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	[_headerView egoRefreshScrollViewDidScroll:scrollView];
    
    CGFloat pageWidth = 320 ;
    if ([scrollView isKindOfClass:[messageScrollView class]]) {
        float fractionalPage = messageScrollView.contentOffset.x / pageWidth ;
        NSInteger nearestNumber = lround(fractionalPage) ;
        
        if (messagePageControl.currentPage != nearestNumber)
        {
            messagePageControl.currentPage = nearestNumber ;
            
            // if we are dragging, we want to update the page control directly during the drag
            if (messageScrollView.dragging)
                [messagePageControl updateCurrentPageDisplay] ;
        }
        
  
    }

    
    
}
- (NSArray *)visiblePhotoViews
{
    NSMutableArray *vpv = [[NSMutableArray alloc] init];
    for (UIView *subview in _scrollView.subviews) {
        if ([subview isKindOfClass:[MessageCell class]] && CGRectIntersectsRect(_scrollView.bounds, subview.frame)) {
            [vpv addObject:subview];
        }
    }
    return [vpv autorelease];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *pvs = [self visiblePhotoViews];
    for (MessageCell *pv in pvs) {
        if ([pv isKindOfClass:[MessageCell class]]) {
            [pv appear];
        }
    }
    [messagePageControl updateCurrentPageDisplay];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
	if (!decelerate) {
        NSArray *pvs = [self visiblePhotoViews];
        for (MessageCell *pv in pvs) {
            if ([pv isKindOfClass:[MessageCell class]]) {
                [pv appear];
            }
        }
    }
    if([scrollView isKindOfClass:[navScorllview class]]){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect2=navScorllview.frame;
            rect2.origin.y = -self.view.bounds.size.height;
            navScorllview.frame=rect2;
            
        } completion:^(BOOL finished) {
            _isHiddenTabbar = YES;
        }];
        
        
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[messagePageControl updateCurrentPageDisplay] ;
}
/*
//下拉刷新必须实现得三个方法
#pragma mark - EGOHeaderView Delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    _refreshing = YES;
    [self reloadClicked];
    //加载完成后停止显示headerView
    [self refreshFinished];
}



- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _refreshing;
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}
*/
#pragma mark - Customs TabBar delegate
- (void)tabbar:(TabBarView *)tabBar didSelectIndex:(int)index
{
    
    if (index >= 0 && index < [MyTableBarController sharedTabBarController].viewControllers.count) {
        [[MyTableBarController sharedTabBarController] setMySelectedIndex:index];
        
        for (UINavigationController *nc in [MyTableBarController sharedTabBarController].viewControllers) {
            if ([[MyTableBarController sharedTabBarController].viewControllers indexOfObject:nc] != index) {
                [nc popToRootViewControllerAnimated:YES];
            }
        }
    }
}
@end
