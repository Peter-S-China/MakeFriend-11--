//
//  SettingViewController.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "SearchViewController.h"
#import "TimeView.h"
#import "Tools.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "MessageInfo.h"
#import "SearchCell.h"
#import "SubSearchViewController.h"
#import "ButtonDetailViewController.h"
#import "AddEventViewController.h"
#import "ClassNameListViewController.h"
#import "ListViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize timeButton;
@synthesize classButton;
@synthesize areaButton;
@synthesize _searschInfos;
- (void)dealloc
{
    RELEASE_SAFELY(timeArray);
    RELEASE_SAFELY(classArray);
    RELEASE_SAFELY(areaArray);
    RELEASE_SAFELY(_middleWord);
    [_timeWord release];
    [_classWord release];
    [_areaWord release];
    RELEASE_SAFELY(_dataArray);
    
    [super dealloc];
}

-(void)loadMoreFinished
{
    _loadMore = NO;
    _footerView.frame=CGRectMake(0, _tableView.contentSize.height, 320, 120);
    [_footerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    int count=0;
    count+=[_searschInfos count];
    [Tools showPrompt:[NSString stringWithFormat:@"加载后共有%i条活动信息等着你阅读",count] inView:self.view delay:1.4];
}
-(void)loadData:(NSString *)url Count:(int)count start:(int)startNumber
{
    [Tools showSpinnerInView:self.navigationController.view prompt:@"加载中..."];
    NSString*url2=[[NSString stringWithFormat:@"%@&count=%i&startNumber=%i",url,count,startNumber]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   NSLog(@"newURL = %@",url2);
    
    NSURL *newURL=[NSURL URLWithString:url2];
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        NSLog(@"请求数据失败");
        [Tools hideSpinnerInView:self.navigationController.view];
        [Tools showPrompt:@"加载失败" inView:self.navigationController.view delay:1.4];
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        NSLog(@"请求数据成功");
        [Tools hideSpinnerInView:self.navigationController.view];
        //开始sbjson解析
        SBJsonParser*sbjs=[[[SBJsonParser alloc]init]autorelease];
        
       NSString*date=[[NSString alloc]initWithData:[requst responseData]encoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSArray *array = [sbjs objectWithString:date error:&error];
        NSLog(@"...array count...%i",[array count]);
        [date release];
        if (_searschInfos == nil) {
            _searschInfos = [[NSMutableArray alloc] init];
        }
        if (startNumber == 0) {
            [_searschInfos removeAllObjects];
        }
        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
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
                [fm setDateFormat:@"yyyy年MM月dd日"];
                info.startTime=[fm stringFromDate:date];
                info.endTime=[fm stringFromDate:enddate];
                [fm release];
                //关注度
                info.attention=[NSString stringWithFormat:
                                @"%@",[dic objectForKey:@"seecount"]];
                //图片海报url
                info.detailPhotoURL=[dic objectForKey:@"pic"];
                //类别
                info.className=[dic objectForKey:@"classname"];
                
                //地点
                info.dest=[dic objectForKey:@"cityaddress"];
                
                //内容
                info.abstract=[dic objectForKey:@"contents"];
                //经纬度
                info.location = [dic objectForKey:@"tudu"];
                [_searschInfos addObject:info];
                [info release];
            }
        }
        else {
        //    [Tools showPrompt:@"没有搜索到您要的内容" inView:self.view delay:1.4];
            if ([_searschInfos count]>0) {
                _timeWord=@"";
                _areaWord=@"";
                _classWord=@"";
                UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，没有更多的相关信息了" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alter.tag=1402;
                [alter show];
                [alter release];
            }
        
        }
        int count=[_searschInfos count]-1;
        [Tools showPrompt:[NSString stringWithFormat:@"你刚刚获得了%i条活动信息",count] inView:self.view delay:1.4];
        [_tableView reloadData];
        [self loadMoreFinished];
    
    }];
    
  
    


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1401) {
        if (buttonIndex==1) {
          [self loadData:@"http://matrix.clickharbour.com/pages/index.aspx?" Count:10 start:0];
                    
        }
    }

}
//放下pickerView
- (void)hidePickerView
{
	[UIView beginAnimations:@"AnimationDOWN" context:nil];
	[UIView setAnimationDuration:0.3];
	_timeView.frame = CGRectMake(0, 460+[Tools isIphone5], 320, 260);
	[UIView commitAnimations];
}

//调出pickerView
- (void)showPickerView
{
	[UIView beginAnimations: @"AnimationUP" context:nil];
	[UIView setAnimationDuration:0.3];
	_timeView.frame = CGRectMake(0, 156+[Tools isIphone5], 320, 260);
	[UIView commitAnimations];
}

//点击完成
- (void)choosePickerDone
{
    [UIView beginAnimations:@"AnimationDOWN" context:nil];
	[UIView setAnimationDuration:0.3];
	_timeView.frame = CGRectMake(0, 460+[Tools isIphone5], 320, 260);
	[UIView commitAnimations];
    if (_whitchPicker == 0) {//时间
       if (_middleWord.length <= 0) {
         /*   //给一个默认值
            NSDate *now = [NSDate date];
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"yyyy-MM-dd"];
            [_middleWord release];
            _middleWord=[[fm stringFromDate:now] copy];*/
           _middleWord=@"";
           [timeButton setTitle:@"所有时间" forState:UIControlStateNormal];
           [_timeWord release];
           _timeWord = [_middleWord copy];
       }
       else{
        [_timeWord release];
        _timeWord = [_middleWord copy];
       }
    }
    else if (_whitchPicker == 1) {//分类
        if (_middleWord.length <= 0) {
        //    _middleWord = [[classArray objectAtIndex:0] copy];
            _middleWord=@"";
           [classButton setTitle:@"所有分类" forState:UIControlStateNormal];
            [_classWord release];
            _classWord = [_middleWord copy];
            
        }
        else{
        [_classWord release];
        _classWord = [_middleWord copy];
        [classButton setTitle:_classWord forState:UIControlStateNormal];
        }
    }
    else if (_whitchPicker == 2) {
        if (_middleWord.length <= 0) {
       //     _middleWord = [[areaArray objectAtIndex:0] copy];
        _middleWord=@"";
        [areaButton setTitle:@"所有地区" forState:UIControlStateNormal];
            [_areaWord release];
            _areaWord = [_middleWord copy];
        }
        else{
        [_areaWord release];
        _areaWord = [_middleWord copy];
        [areaButton setTitle:_areaWord forState:UIControlStateNormal];
        }
    }
}

-(void)buttonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 101) {//时间
        [_dataArray release];
        _dataArray = [[NSArray alloc] initWithArray:timeArray];
        _whitchPicker=0;
        [_pickerView reloadAllComponents];
        [self showPickerView];
    }
    else if (button.tag == 102) {//分类
        [_dataArray release];
        _dataArray = [[NSArray alloc] initWithArray:classArray];
        _whitchPicker=1;
        [_pickerView reloadAllComponents];
        [self showPickerView];
    }
    else if (button.tag == 103) {//区域
        [_dataArray release];
        _dataArray = [[NSArray alloc] initWithArray:areaArray];
        _whitchPicker=2;
        [_pickerView reloadAllComponents];
        [self showPickerView];
    }
}


//点击搜索按钮调用
- (void)handleSearchButton:(id)sender
{
    NSString*url=[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?searchTime=%@&searchClassName=%@&searchPlace=%@",_timeWord,_classWord,_areaWord];
    NSLog(@"搜索的url = %@",url);
    [_searschInfos removeAllObjects];
    [_tableView reloadData];
    [self loadData:url Count:10 start:0];
    
    [timeButton setTitle:@"时间" forState:UIControlStateNormal];
    [classButton setTitle:@"类别" forState:UIControlStateNormal];
    [areaButton setTitle:@"区域" forState:UIControlStateNormal];
  
}

-(void)moreCuretSearch:(id)sender
{
    SubSearchViewController *svc = [[SubSearchViewController alloc] initAndHiddenTabBar:YES hiddenLeftButton:YES];
        [self.navigationController pushViewController:svc animated:YES];
        [svc release];

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
    ListViewController*list=[[ListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    list.listInfos=self._searschInfos;
    [self.navigationController pushViewController:list animated:YES];
    [list release];
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
            
            _tableView.frame=CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
            
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
            
            _tableView.frame=CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40);
            
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

#pragma mark - init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //中文也可以搜索
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    searchWord=[_textField.text stringByAddingPercentEscapesUsingEncoding:encoding];
    
    //首先创建tileVIew
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setTitle:@"搜索" forState:UIControlStateNormal];
    _titleButton.titleLabel.font=[UIFont systemFontOfSize:24];
    _titleButton.frame = CGRectMake(0, 0, 80, 30);
    self.navigationItem.titleView = _titleButton;
   
    UIBarButtonItem *right = [Tools createNavButtonItem:@"search_no" selected:@"search_clicked" target:self action:@selector(moreCuretSearch:)];
    right.width=20.0f;
    self.navigationItem.rightBarButtonItem = right;
    
    
    //底层是一个view
    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    view1.backgroundColor=[UIColor grayColor];
    view1.userInteractionEnabled=YES;
    [self.view addSubview:view1];
    [view1 release];
   
    //初始化三个button（时间，类别，区域）
    
    timeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.tag = 101;
    [timeButton setTitle:@"时间" forState:UIControlStateNormal];
    [timeButton setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
    [timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        timeButton.titleLabel.font=[UIFont systemFontOfSize:16];
    timeButton.frame=CGRectMake(10, 5, 70, 30);
    [timeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:timeButton];
    
    classButton=[UIButton buttonWithType:UIButtonTypeCustom];
    classButton.tag = 102;
    [classButton setTitle:@"类别" forState:UIControlStateNormal];
    [classButton setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
    [classButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    classButton.titleLabel.font=[UIFont systemFontOfSize:16];
    classButton.frame=CGRectMake(90, 5, 70, 30);
    [classButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:classButton];
    
    areaButton=[UIButton buttonWithType:UIButtonTypeCustom];
    areaButton.tag = 103;
    [areaButton setTitle:@"区域" forState:UIControlStateNormal];
    [areaButton setBackgroundImage:[UIImage imageNamed:@"pulldown.png"] forState:UIControlStateNormal];
    [areaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    areaButton.titleLabel.font=[UIFont systemFontOfSize:16];
    areaButton.frame=CGRectMake(170, 5, 70, 30);
    [areaButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:areaButton];
    
    //添加搜索按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(250, 5, 60, 30);
    [searchButton addTarget:self action:@selector(handleSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [searchButton setTitle:@"确定" forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"pickerGlass.png"] forState:UIControlStateNormal];
    [view1 addSubview:searchButton];
    
    timeArray=[[NSArray alloc]initWithObjects:@"所有时间",@"今天",@"明天",@"这周末",@"下周末", nil];
    classArray=[[NSArray alloc]initWithObjects:@"所有分类",@"运动",@"公益",@"电影",@"拍卖",@"时尚聚会",@"演出",@"夜生活",@"展会",@"其他", nil];
    areaArray=[[NSArray alloc]initWithObjects:@"所有地区",@"东城区",@"西城区",@"宣武区",@"崇文区",@"朝阳区",@"海淀区",@"丰台区",@"石景山区",@"通州区",@"大兴区",@"房山区",@"门头沟区",@"昌平区",@"延庆县",@"怀柔区",@"顺义区",@"平谷区",@"密云县", nil];
   //添加默认值
    _timeWord =@"";
    _classWord = @"";
    _areaWord = @"";
    //加上显示搜索结果的tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40 ) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    [self.view addSubview:_tableView];
    [_tableView release];
     //[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?&count=%i&startNumber=%i",10,0]];
    //创建pickerView
    
    //初始化选取器
    _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 460+[Tools isIphone5], 320, 260)];
    
    UIToolbar *keybordBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, 320, 44)];
    keybordBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(hidePickerView)];
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(choosePickerDone)];
    keybordBar.items = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,hiddenButtonItem, nil];
    [_timeView addSubview:keybordBar];
    [spaceButtonItem release];
    [cancelButtonItem release];
    [hiddenButtonItem release];
    [keybordBar release];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    [_timeView addSubview:_pickerView];
    [self.view addSubview:_timeView];
    [_pickerView release];
    [_timeView release];
    
    //初始化上拉加载更多
    _footerView=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0,460+[Tools isIphone5], 320, 130) footerName:@"INDEX_REFRESH_FOOTERER"];
    _footerView.delegate=self;
    [_tableView addSubview:_footerView];
    [_footerView release];
    [_footerView refreshLastUpdatedDate];
    
     [self creatNavView];
    
    UIButton*showNavButton=[UIButton buttonWithType:UIButtonTypeCustom];
    showNavButton.frame=CGRectMake(280, 0, 34, 20);
    [showNavButton setImage:[UIImage imageNamed:@"showaNav.png"] forState:UIControlStateNormal];
    [showNavButton addTarget:self action:@selector(showTabBarAndNavi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showNavButton];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
 
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isHiddenTabbar = YES;
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 28);
    [button setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateHighlighted];
    [button setTitle:@"导航" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(showTabBarAndNavi:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightItem;
    [rightItem release];
    */
    
    [self hiddenCoverView];
    
    if (_isHiddenTabbar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if ([_searschInfos count]<1) {
        [self loadData:@"http://matrix.clickharbour.com/pages/index.aspx?" Count:20 start:[_searschInfos count]];
    }
    else
    {
        return;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//前两个是下拉刷新应该实现得方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
      [_footerView egoRefreshScrollViewDidScroll:scrollView];
    
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
    
    [_footerView egoRefreshScrollViewDidEndDragging:scrollView];

    
}

#pragma mark - TableView Delegate
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_searschInfos count]-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188.0f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *info = [_searschInfos objectAtIndex:indexPath.row];
    SearchCell *cell = [[[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil withMessageInfo:info delegate:self]autorelease];

    return cell;
}

#pragma mark searchCellDelgeta
- (void)searchCell:(SearchCell *)cell selectedInfo:(MessageInfo*)info
{

    DetailViewController*button=[[DetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    button.message=info;
    button.infosDict = [NSDictionary dictionaryWithObject:_searschInfos forKey:button.message.className];
    [self.navigationController pushViewController:button animated:YES];
    [button release];
}

#pragma mark PickerView DataSource

//返回pickerview的组件数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

//返回每个组件上的行数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [_dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"...._dataArray....%i",[_dataArray count]);
	return [_dataArray objectAtIndex:row];
}

//传入参数判断是星期几
-(int)week:(NSInteger)week
{
    int weekDay = 0;
    if(week==1)
    {
        weekDay = 7;//星期天
        
    }else if(week==2){
        weekDay = 1;//星期一
        
    }else if(week==3){
        weekDay = 2;//星期二
        
    }else if(week==4){
        weekDay = 3;//星期三
        
    }else if(week==5){
        weekDay = 4;
        
    }else if(week==6){
        weekDay = 5;
        
    }else if(week==7){
        weekDay = 6;//星期六
        
    }
    return weekDay;
}


#pragma mark - PickerView Delegate
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen
{
	NSLog(@"You select row %d vaniv = %@",row,[_dataArray objectAtIndex:row]);
    
    if (_whitchPicker == 0) {//表示选择了时间
        //给timebutton赋值
        [timeButton setTitle:[_dataArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row==0) {
            _middleWord=@"";
            NSLog(@"%@",_middleWord);
        }
        else if (row == 1) {//今天
            NSDate *now = [NSDate date];
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"yyyy-MM-dd"];
            [_middleWord release];
            _middleWord=[[fm stringFromDate:now] copy];
            [fm release];
        }
        else if (row == 2) {//明天
            NSDate *tom = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60];
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"yyyy-MM-dd"];
            [_middleWord release];
            _middleWord=[[fm stringFromDate:tom] copy];
            [fm release];
        }
        else if (row == 3) {//这周末
            NSDate *dateNow = [NSDate date];
            NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
            NSInteger unitFlags = NSEraCalendarUnit |
                                 NSYearCalendarUnit |
                                NSMonthCalendarUnit |
                                  NSDayCalendarUnit |
                                 NSHourCalendarUnit |
                               NSMinuteCalendarUnit |
                              NSWeekdayCalendarUnit |
                                 NSWeekCalendarUnit ;
            NSDateComponents *comps = [calendar components:unitFlags fromDate:dateNow];
            int weekDay = [self week:[comps weekday]];
            [comps setDay: [comps day] + (7 - weekDay)];//在原来的日期上加多少天到本周末
            NSDate *sunday = [calendar dateFromComponents:comps];//星期日
            NSDate *saterDay = [sunday dateByAddingTimeInterval:- 24 * 60 *60];//星期天
            //下面的和上面一样
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"yyyy-MM-dd"];
            [_middleWord release];
            _middleWord=[[NSString stringWithFormat:@"%@@%@",[fm stringFromDate:saterDay],[fm stringFromDate:sunday]] copy];
            [fm release];
            
        }
        else if (row == 4) {//下周末
            NSDate *dateNow = [NSDate date];
            NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
            NSInteger unitFlags = NSEraCalendarUnit |
                                 NSYearCalendarUnit |
                                NSMonthCalendarUnit |
                                  NSDayCalendarUnit |
                                 NSHourCalendarUnit |
                               NSMinuteCalendarUnit |
                              NSWeekdayCalendarUnit |
                                 NSWeekCalendarUnit ;
            NSDateComponents *comps = [calendar components:unitFlags fromDate:dateNow];
            int weekDay = [self week:[comps weekday]];
            [comps setDay: [comps day] + (7 * 2 - weekDay)];//在原来的日期上加多少天到本周末
            NSDate *sunday = [calendar dateFromComponents:comps];//星期日
            NSDate *saterDay = [sunday dateByAddingTimeInterval:- 24 * 60 *60];//星期天
            //下面的和上面一样
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setDateFormat:@"yyyy-MM-dd"];
            [_middleWord release];
            _middleWord=[[NSString stringWithFormat:@"%@@%@",[fm stringFromDate:saterDay],[fm stringFromDate:sunday]] copy];
            [fm release];
        }
        NSLog(@"date = %@",_middleWord);
    }
    else {
        NSLog(@"其他情况");
        if (_middleWord != nil) {
            [_middleWord release];
        }
        if (row==0) {
            _middleWord=@"";
        }
        else{
            _middleWord = [[_dataArray objectAtIndex:row] copy];
        }
    }
}
#pragma mark-EGORefreshTableFooterDelegate

-(void)EGORefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view
{
    _loadMore = YES;
   
    [self loadData:[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?searchTime=%@&searchClassName=%@&searchPlace=%@",_timeWord,_classWord,_areaWord]Count:10 start:[_searschInfos count]+1];
   
}
-(BOOL)EGORefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view
{
    return _loadMore;
}
- (NSDate*)EGORefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view;
{
    return [NSDate date];
    
}

@end
