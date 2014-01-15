//
//  AboutUsViewController.m
//  ONE
//
//  Created by dianji on 13-1-23.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    animation.duration =0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
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
    
    NSString*aboutStr=@"我们作力于提供最直接的本地化活动娱乐服务应用.                              简介：ClickMatrix 1.81 可以让你有最便捷的途径知道，你所在的城市，哪里有最有趣的时尚聚会，哪里有最具人气的体育活动，哪里有最前卫的艺术展览，哪里有最热门的演出，哪里有最热播的电影，哪里有最不惜血本的拍卖，哪里有最好吃的餐厅，哪里有最有影响力的公益活动等.";
    

    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    view.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [self.view addSubview:view];
    [view release];
    
    UITextView*label=[[UITextView alloc]initWithFrame:CGRectMake(10, 30, 300, 420)];
    label.backgroundColor=[UIColor clearColor];
    label.text=[NSString stringWithFormat:@"%@",aboutStr];
    label.font=[UIFont systemFontOfSize:18];
    [view addSubview:label];
    [label release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
