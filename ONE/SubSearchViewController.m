//
//  SubSearchViewController.m
//  ONE
//
//  Created by Liang Wei on 12/23/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import "SubSearchViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "subSearchCell.h"
#import "ButtonDetailViewController.h"
#import "DetailViewController.h"
#import "AddEventViewController.h"
#import "ClassNameListViewController.h"
#import "ListViewController.h"
@interface SubSearchViewController ()

@end

@implementation SubSearchViewController
@synthesize _searschInfos;

- (void)dealloc
{
    
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)loadMoreFinished
{
    _loadMore = NO;
    if (_tableView.contentSize.height < CGRectGetHeight(self.view.bounds) - 40) {
        _tableView.contentSize = CGSizeMake(320, CGRectGetHeight(self.view.bounds) - 40);
    }
    _footerView.frame=CGRectMake(0, _tableView.contentSize.height, 320, 400);
    [_footerView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    int count=0;
    count+=[_searschInfos count];
    [Tools showPrompt:[NSString stringWithFormat:@"加载后共有%i条活动信息等着你阅读",count] inView:self.view delay:1.4];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)loadData:(NSString*)url Count:(int)count start:(int)startNumber
{
    [Tools showSpinnerInView:self.navigationController.view prompt:@"加载中..."];
    
    NSString*url1=[[NSString stringWithFormat:@"%@&count=%i&startNumber=%i",url,count,startNumber]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSURL *newURL=[NSURL URLWithString:url1];
    NSLog(@"...url....%@",newURL);
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
        [Tools hideSpinnerInView:self.navigationController.view];
        //开始sbjson解析
        SBJsonParser*sbjs=[[[SBJsonParser alloc]init]autorelease];
        
     /*   //gb123编码
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *date = [[NSString alloc] initWithData:[requst responseData] encoding:gb2312];*/
        
        NSString *date=[[NSString alloc]initWithData:[requst responseData] encoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSArray *array = [sbjs objectWithString:date error:&error];
        [date release];
        if (_searschInfos == nil) {
            _searschInfos = [[NSMutableArray alloc] init];
        }

        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
            if ([array count] < 5) {
                _footerView.hidden = YES;
            }
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
        int count=[_searschInfos count];
        [Tools showPrompt:[NSString stringWithFormat:@"你刚刚获得了%i条活动信息",(count-1)] inView:self.view delay:1.4];
     [_tableView reloadData];
    [self loadMoreFinished];

    }];
    
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
    
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 170)];
    navView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.8];
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
    turnOffButton.frame=CGRectMake(280, 150, 37, 35);
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

#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _isHiddenTabbar = YES;
//    [MyTableBarController sharedTabBarController].doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTabBarAndNavi:)] autorelease];
//    [MyTableBarController sharedTabBarController].doubleTap.numberOfTapsRequired = 2;
//    [self.navigationController.view addGestureRecognizer:[MyTableBarController sharedTabBarController].doubleTap];
    
    
    //添加上返回按钮
    
    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 8, 60,30);
    [left setTitle:@"返回" forState:UIControlStateNormal];
    [left setTitle:@"返回" forState:UIControlStateHighlighted];
    left.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    
	_searchBar = [[UISearchBar alloc] init];
    _searchBar.backgroundColor = [UIColor colorWithRed:254/255.0 green:60/255.0 blue:142/255.0 alpha:0.6];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.placeholder = @"精确查找";
    [_searchBar sizeToFit];
    [self.view addSubview:_searchBar];
    [_searchBar release];
    
    //加上显示搜索结果的tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 40 - 44) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    [self.view addSubview:_tableView];
    [_tableView release];
    //先下载一下数据试试
    [self loadData:@"http://matrix.clickharbour.com/pages/index.aspx?" Count:10 start:0];
    //初始化上拉加载更多
    _footerView=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0,460+[Tools isIphone5], 320, 130) footerName:@"INDEX_REFRESH_FOOTERER"];
    _footerView.delegate=self;
    [_tableView addSubview:_footerView];
    [_footerView release];
    [_footerView refreshLastUpdatedDate];
//    [self creatNavView];

}

#pragma mark - TableView Delegate
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_searschInfos count];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageInfo *info = [_searschInfos objectAtIndex:indexPath.row];
    subSearchCell *cell = [[[subSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil withMessageInfo:info delegate:self] autorelease];
    return cell;
}

//前两个是下拉刷新应该实现得方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    if (!scrollView.hidden) {
        [_footerView egoRefreshScrollViewDidScroll:scrollView];
    }
    
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
    
    if (!scrollView.hidden) {
        [_footerView egoRefreshScrollViewDidEndDragging:scrollView];
    }

    
    
}



#pragma searchBar procol methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:NO animated:YES];}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    NSLog(@"search = %@",searchBar.text);
  NSString*url=[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?searchword=%@",searchBar.text];
    [_searschInfos removeAllObjects];
    [self loadData:url Count:5 start:0];
}
#pragma -mark- EGORefreshTableFooterDelegate

//上啦加载更多
-(void)EGORefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view
{
    _loadMore = YES;
    if (_searchBar.text.length>0) {
        [self loadData:[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?searchword=%@",_searchBar.text] Count:5 start:[_searschInfos count]];
    }
    else{
        [self loadData:@"http://matrix.clickharbour.com/pages/index.aspx?" Count:10 start:[_searschInfos count]];
        NSLog(@"%i",[_searschInfos count]-1);
    }
}
-(BOOL)EGORefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view
{
    return _loadMore;
}
- (NSDate*)EGORefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView*)view;
{
    return [NSDate date];
    
}

#pragma mark subSearchCellDelgeta
- (void)subSearchCell:(subSearchCell *)cell selectedInfo:(MessageInfo*)info
{
    
    DetailViewController*button=[[DetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    button.message=info;
    button.infosDict = [NSDictionary dictionaryWithObject:_searschInfos forKey:button.message.className];
    [self.navigationController pushViewController:button animated:YES];
    [button release];

}
@end
