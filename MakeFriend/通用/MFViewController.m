//
//  MFViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "MFViewController.h"

@interface MFViewController ()

@end

@implementation MFViewController

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

- (void)setMFTabBarHidden:(BOOL)hidden
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
