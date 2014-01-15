//
//  ListViewController.m
//  ONE
//
//  Created by dianji on 13-1-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"
#import "MapListViewController.h"
@interface ListViewController ()

@end

@implementation ListViewController
@synthesize listInfos;
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
    animation.duration = 0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
  

    //创建tableview
    listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,  460+[Tools isIphone5]) style:UITableViewStyleGrouped];
    listTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [listTableView setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.delegate=self;
    listTableView.dataSource=self;
    [self.view addSubview:listTableView];
    
}
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell*cell=nil;
   
    if (cell==nil) {
        cell=[[[ListCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:nil ]autorelease];
        
    }
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"textView.png"]];
       
    
    return cell;
}
//当一行被选中得时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        //找到当前显示的信息，既messageInfo
        MapListViewController*map=[[MapListViewController alloc] initAndHiddenTabBar:YES hiddenLeftButton:YES];
        map.infos = self.listInfos;
        [self.navigationController pushViewController:map animated:YES];
        
        [map release];
        
    }


}

@end
