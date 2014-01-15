//
//  CommentViewController.m
//  ONE
//
//  Created by Liang Wei on 1/24/13.
//  Copyright (c) 2013 dianji. All rights reserved.
//

#import "CommentViewController.h"
#import "SBJson.h"
@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)dealloc
{
    RELEASE_SAFELY(_info);
    RELEASE_SAFELY(_comments);
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createCommets
{
    if (_comments.count > 0) {
        UILabel * compit=[Tools createLabel:[NSString stringWithFormat:@"大家都在说:"] frame:CGRectMake(10,0,150, 25) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] aliment:UITextAlignmentLeft];
        [self.view addSubview:compit];
    }
    for ( int i=0;i<[_comments count];i++) {
        Comment *commentInfo=[_comments objectAtIndex:i];
        NSLog(@"...commetInfo....%@",commentInfo);
        //循环创建5个小view
        UIView*commetView=[[UIView alloc]initWithFrame:CGRectMake(0, 25+5+52*i, 320, 50)];
        commetView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"textView.png"]];
        [self.view addSubview:commetView];
        [commetView release];
        
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 14, 100, 10)];
        nameLabel.text=[NSString stringWithFormat:@"%@评论:",commentInfo.userName];
        nameLabel.font=[UIFont systemFontOfSize:12];
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.backgroundColor=[UIColor clearColor];
        [commetView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 2, 100, 10)];
        timeLabel.text=[NSString stringWithFormat:@"%@",commentInfo.commentTime];
        timeLabel.font=[UIFont systemFontOfSize:12];
        timeLabel.textColor=[UIColor whiteColor];
        timeLabel.backgroundColor=[UIColor clearColor];
        [commetView addSubview:timeLabel];
        [timeLabel release];
        
        UILabel*contentLabel=[[UILabel alloc]init];
        CGSize sizer=[commentInfo.contents sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 100)];
        contentLabel.frame=CGRectMake(5, 26, 310, sizer.height);
        contentLabel.textColor=[UIColor whiteColor];
        contentLabel.font=[UIFont systemFontOfSize:12];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.text=[NSString stringWithFormat:@"  %@",commentInfo.contents];
        [commetView addSubview:contentLabel];
        [contentLabel release];
    }

}

#pragma mark - init
- (id)initWithInfo:(MessageInfo *)info comments:(NSArray *)array
{
    self = [super initAndHiddenTabBar:YES hiddenLeftButton:YES];
    if (self) {
        _info = [info retain];
        _comments = [array retain];
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
    
    [self createCommets];
//    [self creatCommentsField];
	
}

@end
