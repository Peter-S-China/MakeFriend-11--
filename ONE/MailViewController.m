//
//  MailViewController.m
//  ONE
//
//  Created by dianji on 13-1-8.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "MailViewController.h"

@interface MailViewController ()

@end

@implementation MailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加背景图片
    UIImageView*backgroundimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.png"]];
    backgroundimage.frame=self.view.bounds;
    [self.view addSubview:backgroundimage];
    [backgroundimage release];
    //创建页面
    //收件人
    UILabel*nameLael=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 50, 40)];
    nameLael.text=@"收件人";
    nameLael.backgroundColor=[UIColor clearColor];
    nameLael.textColor=[UIColor whiteColor];
    [nameLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    [self.view addSubview:nameLael];
    [nameLael release];
    
    //每个textfield下面是一个imageview
    UIImageView*nameView=[[UIImageView alloc]initWithFrame:CGRectMake(70, 30, 230, 40)];
    nameView.image=[UIImage imageNamed:@"textfield.png"];
    [self.view addSubview:nameView];
    [nameView release];
    
    attentField=[[UITextField alloc]initWithFrame:CGRectMake(70, 30, 230, 40)];
    attentField.textColor=[UIColor whiteColor];
    attentField.backgroundColor=[UIColor clearColor];
    [self.view addSubview:attentField];
    attentField.delegate=self;
    [attentField release];
    
    //主题
    UILabel*phoneLael=[[UILabel alloc]initWithFrame:CGRectMake(20, 90, 50, 40)];
    phoneLael.text=@"主题";
    [phoneLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    phoneLael.backgroundColor=[UIColor clearColor];
    phoneLael.textColor=[UIColor whiteColor];
    [self.view addSubview:phoneLael];
    [phoneLael release];
    //每个textfield下面是一个imageview
    
    UIImageView*phoneView=[[UIImageView alloc]initWithFrame:CGRectMake(70, 90, 230, 40)];
    phoneView.image=[UIImage imageNamed:@"textfield.png"];
    [self.view addSubview:phoneView];
    [phoneView release];
    
    summeryField=[[UITextField alloc]initWithFrame:CGRectMake(70, 90, 230, 40)];
    summeryField.textColor=[UIColor whiteColor];
    summeryField.backgroundColor=[UIColor clearColor];
    summeryField.delegate=self;
    [self.view addSubview:summeryField];
    [summeryField release];
    //分享内容
    UILabel*commentLael=[[UILabel alloc]initWithFrame:CGRectMake(20, 150, 50, 40)];
    commentLael.text=@"分享内容";
    [commentLael setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
    commentLael.backgroundColor=[UIColor clearColor];
    commentLael.textColor=[UIColor whiteColor];
    [self.view addSubview:commentLael];
    [commentLael release];
    
    UIImageView*commentView=[[UIImageView alloc]initWithFrame:CGRectMake(70, 160, 230, 150)];
    commentView.image=[UIImage imageNamed:@"textView.png"];
    [self.view addSubview:commentView];
    [commentView release];
    
    commentField=[[UITextView alloc]initWithFrame:CGRectMake(70, 160, 230, 150)];
    commentField.backgroundColor=[UIColor clearColor];
    commentField.delegate=self;
    [self.view addSubview:commentField];
    [commentField release];
    
    //两个button
    UIButton*reloadData=[UIButton buttonWithType:UIButtonTypeCustom];
    [reloadData setTitle:@"重置" forState:UIControlStateNormal];
    [reloadData addTarget:self action:@selector(reSetting:) forControlEvents:UIControlEventTouchUpInside];
    reloadData.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [reloadData setBackgroundImage:[UIImage imageNamed:@"textfield.png"] forState:UIControlStateNormal];
    reloadData.frame=CGRectMake(70, 350, 90, 40);
    [self.view addSubview:reloadData];
    
    UIButton*comitData=[UIButton buttonWithType:UIButtonTypeCustom];
    [comitData setTitle:@"发送" forState:UIControlStateNormal];
    [comitData setBackgroundImage:[UIImage imageNamed:@"textfield.png"] forState:UIControlStateNormal];
    comitData.frame=CGRectMake(210, 350, 90, 40);
    [comitData addTarget:self action:@selector(comitData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comitData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
