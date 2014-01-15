//
//  ClassNameListViewController.m
//  ONE
//
//  Created by dianji on 13-1-31.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "ClassNameListViewController.h"
#import "DetailViewController.h"
#import "MessageInfo.h"

@interface ClassNameListViewController ()

@end

@implementation ClassNameListViewController
@synthesize classDict;

- (void)dealloc
{
    RELEASE_SAFELY(classDict);
    RELEASE_SAFELY(_titleArray);
    
    [super dealloc];
}

-(void)classNameClick:(UIButton*)button
{
    NSLog(@"%i",button.tag-600);
     NSString *title= [_titleArray objectAtIndex:([button tag] - 600)];
    NSLog(@"title%@",title);
    NSArray *array = [classDict objectForKey:title];
    if ([array count] > 0) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"cube";
        animation.subtype = kCATransitionFromRight;
                
        MessageInfo *firstInfo = [array objectAtIndex:0];
        DetailViewController *dvc=[[DetailViewController alloc]initAndHiddenTabBar:YES hiddenLeftButton:YES];
        dvc.message = firstInfo;
        dvc.navTitle = firstInfo.className;
        dvc.infosDict = self.classDict;
        [self.navigationController pushViewController:dvc animated:YES];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        [dvc release];
    }
 }
- (UIImage *)handleTitle:(int)tag
{
    NSLog(@"%i",tag);
    NSLog(@"%@",[_titleArray objectAtIndex:tag]);
    UIImage *image = nil;
   
    if ([[_titleArray objectAtIndex:tag]isEqualToString:@"运动"]) {
            image = [[UIImage imageNamed:@"sport1.png"] retain];
            [but setBackgroundImage:image forState:UIControlStateNormal];
        }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"公益"]) {
        image = [[UIImage imageNamed:@"charity1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"电影"]) {
        image = [[UIImage imageNamed:@"moves1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"拍卖"]) {
        image = [[UIImage imageNamed:@"sale1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"其他"]) {
        image = [[UIImage imageNamed:@"other1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"时尚聚会"]) {
        image = [[UIImage imageNamed:@"party1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"演出"]) {
        image = [[UIImage imageNamed:@"concert1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"夜生活"]) {
        image = [[UIImage imageNamed:@"nightlife1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    else if ([[_titleArray objectAtIndex:tag]isEqualToString:@"展会"]) {
        image = [[UIImage imageNamed:@"exhibition1.png"] retain];
        [but setBackgroundImage:image forState:UIControlStateNormal];
    }
    return [image autorelease];

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    
   self.navigationItem.title=@"分类列表";
    for (int i=0; i<9; i++) {
         but=[UIButton buttonWithType:UIButtonTypeCustom];
        but.tag=600+i;
        NSLog(@"cdgth%i",i);
        but.backgroundColor=[UIColor whiteColor];
        but.frame=CGRectMake(i%3*104+7, i/3*(135+[Tools isIphone5]/3)+8, 98, 130+[Tools isIphone5]/3);
        [but addTarget:self action:@selector(classNameClick:) forControlEvents:UIControlEventTouchUpInside];
        [self handleTitle:i];
        [self.view addSubview:but];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
