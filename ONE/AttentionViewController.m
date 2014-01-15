//
//  AttentionViewController.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AttentionViewController.h"
#import "UIImageView+WebCache.h"
#import "JoinViewController.h"
#import "DetailViewController.h"
#import "PersonalMessageViewController.h"
#import "AddEventViewController.h"
#import "MessageInfo.h"
#import "ClassNameListViewController.h"
#import "ListViewController.h"

@interface AttentionViewController ()

@end

@implementation AttentionViewController
@synthesize attentionTable;
@synthesize message;
@synthesize attentionArray;
@synthesize cell;

-(void)dealloc
{
    [attentionArray release];
    attentionArray=nil;
    [attentionTable release];
    [super dealloc];

}
-(void)backButtonClicked:(UIButton*)sender
{
    [[MyTableBarController sharedTabBarController] setMySelectedIndex:0];
//   [self.navigationController popToRootViewControllerAnimated:YES];
    
}
//完成就恢复常态，变成编辑按钮
-(void)doneButtonClicked:(UIButton*)sender
{
    editeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editeButton setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    editeButton.frame = CGRectMake(0, 10, 45,25);
    [editeButton setTitle:@"删除" forState:UIControlStateNormal];
    [editeButton setTitle:@"删除" forState:UIControlStateHighlighted];
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
    [editeButton setBackgroundImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateHighlighted];
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
    
    
    
    //给所有controller发送广播
    NSString *bcastName = @"editData";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:bcastName object:self];
}

-(void)moveAllButtonClicked:(UIButton*)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [attentionArray removeAllObjects];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:attentionArray] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
       
    [attentionTable reloadData];

}

//接收通知删除atten里的元素
-(void)removeAttionData:(NSNotification *)notification
{
    NSString *mode = [notification.userInfo objectForKey:@"attentionInfo"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    for(MessageInfo*info in attentionArray){
        if ([mode intValue]==[info.idNumber intValue]) {
            [attentionArray removeObject:info];
           [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:attentionArray] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
        }
    
    }
    [attentionTable reloadData];
}

-(void)clean:(NSNotification *)notification
{
    [attentionArray removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:attentionArray ] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
    
    [attentionTable reloadData];

}

-(void)classNameList:(UIButton*)sender
{
    //从本地把数据拿到
    NSMutableArray*_buttonTitleArray=[[[NSMutableArray alloc]initWithObjects:@"时尚聚会",@"展会",@"演出",@"夜生活",@"电影",@"公益",@"运动",@"拍卖",@"其他", nil]autorelease];
    NSDictionary*_infosDic1=[[[NSDictionary alloc]init]autorelease];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"];
    NSMutableDictionary*  allDict = [[[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
 /*
    if (!allDict){
        for (int i=0; i<[_buttonTitleArray count]; i++) {
            _infosDic1=[[defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"]objectForKey:[_buttonTitleArray objectAtIndex:i]];
        }
        

    }
    else
    {
        
            if ([[defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"]isKindOfClass:[NSMutableArray class]]) {
                for (int i=0; i<[_buttonTitleArray count]; i++) {                
               _infosDic1=[[defaults objectForKey:@"ALLDICT_MESSAGEINFO_TO_LOCAL"]objectForKey:[_buttonTitleArray objectAtIndex:i]]; 
            }
            
        }
        
    }
  */  
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
    NSData *data = [defaults objectForKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
    NSMutableArray*  attionArray = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
    
    ListViewController*list=[[ListViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    list.listInfos=attionArray;
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
[[MyTableBarController sharedTabBarController] setMySelectedIndex:4];            break;
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
    
    if (_isHiddenTabbar) {//如果隐藏，就不隐藏自定的nav
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
        rect2.origin.y = -navScorllview.contentSize.height;
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
//    [self.view addGestureRecognizer:[MyTableBarController sharedTabBarController].doubleTap];
   
 
    //添加上标签
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 100, 40)];
    title.text=@"我的关注";
    title.font=[UIFont systemFontOfSize:22];
    title.backgroundColor=[UIColor clearColor];
  
    self.navigationItem.title=title.text;
    [title release];
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
    
    //添加tableview的列表
    //创建tableview
    attentionTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,  460+[Tools isIphone5]) style:UITableViewStylePlain];
    attentionTable.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    attentionTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [attentionTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]]];
    attentionTable.delegate=self;
    attentionTable.dataSource=self;
    [self.view addSubview:attentionTable];
    [attentionTable release];
 //在参与提交数据的时候清楚attentioncell的东西
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAttionData:) name:@"cleanAttention" object:nil];
   
  //在更多清理缓存时，清除attencell的东西
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
        [self.navigationController setNavigationBarHidden:NO animated:YES];
       
    }
       [self hiddenCoverView];
    //读取本地数据
    //初始化存传过来的关注信息的array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
    
    if (data.length>0) {
      [attentionArray release];
 //       attentionArray=nil;
        attentionArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
    }
    else{
    
        attentionArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    
    }

[attentionTable reloadData];
}

#pragma mark - TableView Delegate
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [attentionArray count];
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=nil;
    if ([attentionArray count]<=indexPath.row) {
        return cell;
    }
    MessageInfo *info = [attentionArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[[AttentionCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:nil message:info delegate:self] autorelease];
      
    }
    
  
    return cell;
}


//继承该方法时,左右滑动会出现删除按钮(自定义按钮),点击按钮时的操作
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < [attentionArray count]) {
        [self.attentionArray removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.attentionTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        
        //从本地删除
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:attentionArray] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return @"删除";
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AttenionCell Delegate
- (void)attentionCell:(AttentionCell *)cell joinWithInfo:(MessageInfo *)info
{
    PersonalMessageViewController*text=[[PersonalMessageViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    text._info=info;

    [self.navigationController pushViewController:text animated:YES];
    [text release];
    
 }
- (void)attentionCell:(AttentionCell *)cell moveWithInfo:(MessageInfo *)info
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([attentionArray containsObject:info])
    {
        [attentionArray removeObject:info];
        NSLog(@"...array....%@",attentionArray);
        
        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:attentionArray] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
        
    }
    [attentionTable reloadData];
    
}
- (void)attentionCell:(AttentionCell *)cell joined:(MessageInfo *)info
{
    //在跳转之前先向服务器请求用户信息数据，如果设备已经存在，就跳出alterview提示已经注册，如果没有设备号才进入填写信息页面
    //测试设备号
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"UUID"]){//如果没有uuid，表示第一次提交数据
          NSString *strIdentifier = [Tools getUdid];
        [defaults setObject:strIdentifier forKey:@"UUID"];
        [defaults synchronize];
        
        PersonalMessageViewController*text=[[PersonalMessageViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
        text._info=info;
        [self.navigationController pushViewController:text animated:YES];
        [text release];
        
    }
else
{
    NSString *strIdentifier = [defaults objectForKey:@"UUID"];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?sureidentifier=%@&sureeventid=%@",strIdentifier,info.idNumber]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    NSLog(@",,url1..%@",url);
    [_request clearDelegatesAndCancel];
    [_request release];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request startAsynchronous];
    
    [_request setFailedBlock:^{
        [Tools showPrompt:@"向服务器请求失败" inView:self.view delay:1.4];
    }];
    [_request setCompletionBlock:^{
        NSLog(@"传送参与信息成功2");
        NSLog(@" ..requst string2 ..%@",_request.responseString);
                
        if ([_request.responseString isEqualToString:@"1"] ) {// 提交过，但没有参加次活动
            NSLog(@"_request.responseString = %@",_request.responseString);
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，你已是注册用户，不需再填写信息咯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1511;
            [alter show];
            [alter release];
                        
        }
        else if([_request.responseString hasPrefix:@"<html>"])
        {
            [Tools showPrompt:@"访问的地址出错，请稍后再试" inView:self.view delay:1.4];
        
        
        }
        else{
        
        [Tools showPrompt:@"亲，你已参与此活动，恭候您的光临！" inView:self.view  delay:1.4];
                NSLog(@"123456798");
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [attentionTable reloadData];
    if(alertView.tag==1511){
        if (buttonIndex==1){
            
            UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:2];
            if ([nav.visibleViewController isKindOfClass:[JoinViewController class]]) {
                JoinViewController *attention= (JoinViewController *)nav.visibleViewController;
               attention._info=self.message;
                
                //把信息存进本地文件
                NSUserDefaults *joindefaults = [NSUserDefaults standardUserDefaults];
                if ([joindefaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"] == nil) {//表示还没有添加东西到本地
                    NSMutableArray *infou = [[NSMutableArray alloc] init];
                    message.joinedNumber= [NSString stringWithFormat:@"%i",[message.joinedNumber intValue] + 1];
                    
                    NSLog(@"......joinnumber.....%i",[message.joinedNumber intValue]);
                    
                    [infou addObject:message];
                    [joindefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infou ] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                    [self addEvent];
                    [infou release];
                }
                else {//表示找到了数组。然后看看数组里面有没有，防止重复添加
                    NSData *data = [joindefaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                    NSMutableArray *infoss = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
                    BOOL isExit = NO;
                    for (MessageInfo *sinfo in infoss) {
                        if ([sinfo.buttonTitle isEqualToString:message.buttonTitle]) {//有重复的
                            isExit = YES;
                            break;
                        }
                    }
                    if (!isExit) {//如果不存在重复的才添加进数组
                        
                        message.joinedNumber= [NSString stringWithFormat:@"%i",[message.joinedNumber intValue] + 1];
                        
                        NSLog(@"......joinnumber.....%i",[message.joinedNumber intValue]);
                        [infoss addObject:message];
                        
                        [joindefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:infoss ] forKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
                        [self addEvent];
                        
                    }
                    
                }
                //在attencell删除该元素
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                for(MessageInfo*info in attentionArray){
                    if ([message.idNumber intValue]==[info.idNumber intValue]) {
                        [attentionArray removeObject:info];
                        [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:attentionArray] forKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
                    
                    }
                    
                }
                
                
                [joindefaults synchronize];
                [[MyTableBarController sharedTabBarController] setMySelectedIndex:2];
            }
        }
    }
    
}


- (void)attentionCell:(AttentionCell *)cell
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:@"拨打电话咨询" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"Tell:010-6589029" otherButtonTitles:@"Tell:010-6589018",nil];
    action.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    
    [action showInView:self.view];
    [action release];
}
- (void)attentionCell:(AttentionCell *)cell selectedInfo:(MessageInfo*)info
{
    DetailViewController*button=[[DetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
    button.message=info;
    button.infosDict = [NSDictionary dictionaryWithObject:attentionArray forKey:button.message.className];
    button.navTitle=@"我的关注";
    [self.navigationController pushViewController:button animated:YES];
    [button release];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-6589029"]];
    }
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-6589018"]];
    }
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
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
    
}

@end
