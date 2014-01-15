//
//  SelectedClassViewController.m
//  ONE
//
//  Created by dianji on 13-2-20.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "SelectedClassViewController.h"
#import "MessagesViewController.h"
#import "Catogry.h"
@interface SelectedClassViewController ()

@end

@implementation SelectedClassViewController
@synthesize selctedListName;
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
//创建需要展示的东西
- (void)initShowArray
{
    NSArray *array = [NSArray arrayWithObjects:@"全部",@"运动",@"时尚聚会",@"电影",@"演出",@"夜生活",@"展会",@"公益",@"拍卖",@"其他", nil];
    NSMutableArray *mutableArray = [NSMutableArray array];
   //把选择的信息从本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *localClassName = [defaults objectForKey:@"USER_CHOOSED_CLASS_NAME"];
    for (NSString *str in array) {
        Catogry *c = [[Catogry alloc] init];
        c.name = str;
        
        if (localClassName.length > 0 && [localClassName isEqualToString:str]) {
            c.isSelected = YES;
        }
        else {
            c.isSelected = NO;
        }
        if (localClassName.length < 1 && [str isEqualToString:@"全部"]) {
            
            c.isSelected = YES;
            
        }
        
        [mutableArray addObject:c];
        [c release];
    }
    classArray=[[NSArray alloc]initWithArray:mutableArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        
    //添加上标签
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 100, 40)];
    title.text=@"设置首页默认分类";
    title.font=[UIFont systemFontOfSize:22];
    title.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.title=title.text;
    [title release];
    self.view.backgroundColor=[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    classArray1=[[NSArray alloc]initWithObjects:@"all",@"yundong",@"jvhui",@"dianying",@"yanchu",@"yishenghuo",@"zhanhui",@"gongyi",@"paimai",@"qita", nil];
    
    [self initShowArray];
//tableView
    UITableView* selctedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)- 44) style:UITableViewStylePlain];
    selctedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    selctedTableView.delegate = self;
    selctedTableView.dataSource = self;
    [self.view addSubview:selctedTableView];
    [selctedTableView release];
}
#pragma mark - TableView Delegate
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [classArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(void)sureButtonClicked:(UIButton*)button
{
    NSInteger tag = [button tag] - 100;
    if ([classArray count] > tag) {//防止越界
        Catogry *ca = [classArray objectAtIndex:tag];
        UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
        if ([nav.visibleViewController isKindOfClass:[MessagesViewController class]]) {
            MessagesViewController*mvc = (MessagesViewController *)nav.visibleViewController;
            self.selctedListName=ca.name;
            mvc.selectedName=ca.name;
            NSLog(@"%@",mvc.selectedName);
            //把选择的东西保存在本地
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:ca.name forKey:@"USER_CHOOSED_CLASS_NAME"];
            [[MyTableBarController sharedTabBarController] setMySelectedIndex:0];

        }
        
    }


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
UITableViewCell*cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
    cell.userInteractionEnabled=YES;
    cell.contentView.userInteractionEnabled=YES;
    cell.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Catogry *ca = [classArray objectAtIndex:row];
   //打勾只是一张图片的交替
    UIImageView *right= [[UIImageView alloc] initWithFrame:CGRectMake(175, 10, 25, 25)];
    if (ca.isSelected) {
        right.image = [UIImage imageNamed:@"on.png"];
    }
    else {
        right.image = [UIImage imageNamed:@"off.png"];
    }
    [cell.contentView addSubview:right];
    [right release];
    
    UIButton*sure=[UIButton buttonWithType:UIButtonTypeCustom];
    [sure setBackgroundImage:[[UIImage imageNamed:@"comeInBUtton.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sure setTag:row + 100];
    sure.titleLabel.textColor=[UIColor blackColor];
    sure.frame=CGRectMake(260, 10, 50, 30);
    if (ca.isSelected) {
        sure.hidden = NO;
    }
    else {
        sure.hidden = YES;
    }
    [cell.contentView addSubview:sure];
    
    UILabel*leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 10, 150, 30)];
    leftLabel.text=ca.name;
    leftLabel.font=[UIFont systemFontOfSize:22];
    [cell.contentView addSubview:leftLabel];
    [leftLabel release];
    

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row=[indexPath row];
    Catogry *ca = [classArray objectAtIndex:row];
    //选择一个，把其他的都设为没有选择
    for (Catogry *cato in classArray) {
        if ([cato isEqual:ca]) {
            cato.isSelected = !cato.isSelected;
        }
        else {
            cato.isSelected = NO;
        }
    }
    [tableView reloadData];
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
