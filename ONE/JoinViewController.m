//
//  JoinViewController.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "JoinViewController.h"
#import "UIImageView+WebCache.h"
#import "joinCell.h"
#import "ButtonDetailViewController.h"
#import "AddEventViewController.h"
#import "ListViewController.h"
#import "ClassNameListViewController.h"
@interface JoinViewController ()

@end

@implementation JoinViewController

@synthesize _info;
@synthesize joinedArray;
@synthesize joinedTabelView;
@synthesize cell;
-(void)dealloc
{
    [_info release];
    [joinedArray release];
    joinedArray=nil;
    [super dealloc];


}

-(void)backButtonClicked:(UIButton*)sender
{
    [[MyTableBarController sharedTabBarController] setMySelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
//更多页面清理缓存，joincell里也清除缓存
-(void)clean:(NSNotification *)notification
{
  [joinedArray removeAllObjects];
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:joinedArray ] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];

  [joinedTabelView reloadData];
}
//完成就恢复常态，变成编辑按钮
-(void)doneButtonClicked:(UIButton*)sender
{
    editeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editeButton setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    editeButton.frame = CGRectMake(0, 10, 45,25);
    [editeButton setTitle:@"删除" forState:UIControlStateNormal];
    editeButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [editeButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:editeButton];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.leftBarButtonItem=nil;
    [item autorelease];

    //给所有controller发送广播
    NSString *bcastName = @"editDoneData";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:bcastName object:self];
    
}
//编辑按钮，可以单个删除
-(void)editButtonClicked:(UIButton*)sender
{
    
    [editeButton setTitle:@"完成" forState:UIControlStateNormal];
    [editeButton setTitle:@"完成" forState:UIControlStateHighlighted];
    [editeButton setBackgroundImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [editeButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //添加全部删除按钮
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"removeAllNorm.png"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 10, 65,25);
    [leftButton setTitle:@"全部删除" forState:UIControlStateNormal];
    [leftButton setTitle:@"全部删除" forState:UIControlStateHighlighted];
    leftButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [leftButton addTarget:self action:@selector(moveAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = item;
    [item autorelease];
    
    //给所有cell发送广播出现删除按钮
    NSString *bcastName = @"editData";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:bcastName object:self];

}

-(void)moveAllButtonClicked:(UIButton*)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [joinedArray removeAllObjects];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:joinedArray] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
    
    [joinedTabelView reloadData];
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
    NSMutableArray*  joinArray = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
    
    ListViewController*list=[[ListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    list.listInfos=joinArray;
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
    
    _isHiddenTabbar = YES;
//    [MyTableBarController sharedTabBarController].doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTabBarAndNavi:)] autorelease];
//    [MyTableBarController sharedTabBarController].doubleTap.numberOfTapsRequired = 2;
//    [self.navigationController.view addGestureRecognizer:[MyTableBarController sharedTabBarController].doubleTap];
    //添加编辑按钮
    
    editeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editeButton setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    editeButton.frame = CGRectMake(0, 10, 45,25);
    [editeButton setTitle:@"删除" forState:UIControlStateNormal];
    [editeButton setTitle:@"删除" forState:UIControlStateHighlighted];
    editeButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [editeButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:editeButton];
    
    self.navigationItem.rightBarButtonItem = item;
    [item autorelease];

    
    
    //添加上标签
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 100, 40)];
    title.text=@"我的参与";
    title.font=[UIFont systemFontOfSize:22];
    title.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.title=title.text;
    [title release];
 
    //添加tableview的列表
    //创建tableview
    joinedTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,  460+[Tools isIphone5]) style:UITableViewStylePlain];
    joinedTabelView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [joinedTabelView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
     joinedTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    joinedTabelView.delegate=self;
    joinedTabelView.dataSource=self;
    [self.view addSubview:joinedTabelView];
    
    //在更多清理缓存时，清除joincell的东西
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clean:) name:@"reloadData" object:nil];
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
    if (_isHiddenTabbar) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self hiddenCoverView];
    //读取本地数据
    //初始化存传过来的关注信息的array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
    if (data.length > 0) {
  //      [joinedArray release];
        joinedArray=nil;
        joinedArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
        [joinedTabelView reloadData];
    }
    
}
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [joinedArray count];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=nil;
    if ([joinedArray count]<=indexPath.row) {
        return cell;
    }
    _info=[joinedArray objectAtIndex:indexPath.row];
    if (cell==nil) {
        cell=[[[joinCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:nil message:self._info delegate:self]autorelease];
        
    }
    
    
    return cell;
}

#pragma mark - joinedCell Delegate
/*
-(void)detailCell:(joinCell *)cell WithInfo:(MessageInfo *)info
{
    ButtonDetailViewController*button=[[ButtonDetailViewController alloc]init];
    button._info=info;
    [self.navigationController pushViewController:button animated:YES];
    [button release];

}
*/
- (void)detailCell:(joinCell *)cell selectedInfo:(MessageInfo*)info
{
    DetailViewController*button=[[DetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    button.message=info;
    button.infosDict = [NSDictionary dictionaryWithObject:joinedArray forKey:button.message.className];
    button.navTitle=@"我的参与";
    [self.navigationController pushViewController:button animated:YES];
    [button release];
    
    
}
-(void)detailCell:(joinCell *)cell moveWithInfo:(MessageInfo *)info
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([joinedArray containsObject:info])
    {
        [joinedArray removeObject:info];
        NSLog(@"...array....%@",joinedArray);
        //从本地删除
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:joinedArray] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
        
    }
    [joinedTabelView reloadData];
    
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
