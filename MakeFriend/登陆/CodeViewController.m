//
//  CodeViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-17.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "CodeViewController.h"
#import "FillPersonMessageViewController.h"
@interface CodeViewController ()

@end

@implementation CodeViewController

-(void)doneButtonClicked:(UIButton *)sender
{
    FillPersonMessageViewController*nac=[[FillPersonMessageViewController alloc]init];
    [self.navigationController pushViewController:nac animated:YES];
    [nac release];

    
/*
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController: [MyTableBarController sharedTabBarController] animated:YES];
*/
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 //  [[MyTableBarController sharedTabBarController].navigationController setNavigationBarHidden:YES];

}
-(void)backButtonClicked:(UIButton*)sender
{
 
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([Tools isIphone5]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView5.png"]];
    }
    else
    {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView.png"]];
    }
    self.navigationItem.title=@"注册";
    [self.navigationController setNavigationBarHidden:NO];
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(5, 8, 12,15);
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
    //承载codeField的imageview
    UIImageView*codeFieldBackView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 275, 51)];
    codeFieldBackView.image=[UIImage imageNamed:@"codeFieldBackView.png"];
    codeFieldBackView.userInteractionEnabled=YES;
    [self.view addSubview:codeFieldBackView];
    [codeFieldBackView release];
    
    codeField=[[UITextField alloc]initWithFrame:CGRectMake(70, 15, 150, 30)];
    codeField.backgroundColor=[UIColor clearColor];
    codeField.delegate=self;
    codeField.placeholder=@"请输入验证码";
    [codeFieldBackView addSubview:codeField];
    [codeField release];
    
    UIButton*doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame=CGRectMake(90, 105, 130, 30);
    [doneButton setImage:[UIImage imageNamed:@"doneButton.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];


}
#pragma mark -textfildDelegate
//当敲打回车键时，开始搜索并收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
