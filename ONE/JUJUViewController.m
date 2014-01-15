//
//  JUJUViewController.m
//  ONE
//
//  Created by Liang Wei on 12/23/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import "JUJUViewController.h"

@interface JUJUViewController ()

@end

@implementation JUJUViewController

- (id)initAndHiddenTabBar:(BOOL)hiddenTabBar hiddenLeftButton:(BOOL)hideLeft 
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = hiddenTabBar;
        _hideTabbar = hiddenTabBar;
        _hideLeftButton = hideLeft;

    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setJUJUTabBarHidden:(BOOL)hidden
{
    self.hidesBottomBarWhenPushed = YES;
    if ([self.navigationController.tabBarController isKindOfClass:[MyTableBarController class]]) {
        [[MyTableBarController sharedTabBarController] hideTabbar:hidden];
    }
}
- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.tabBarController isKindOfClass:[MyTableBarController class]]) {
//        if ([self isKindOfClass:[MessagesViewController class]]) {
//            return;
//
//        }
        [[MyTableBarController sharedTabBarController] hideTabbar:_hideTabbar];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_hideLeftButton) {
        self.navigationItem.hidesBackButton = YES;
    }
    else {
        UIBarButtonItem *backButton = [Tools createNavButtonItem:@"back_norm" selected:@"back_cliked" target:self action:@selector(backButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
