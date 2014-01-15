//
//  MyTableBarController.h
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewController.h"
#import "AttentionViewController.h"
#import "JoinViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "TabBarView.h"

//创建4个tablebar，包括消息，聚会，好友，设置四个界面
//单列模式，方便
@interface MyTableBarController : UITabBarController<TabbarDelegate>
{
@private
    TabBarView *_myTabbar;
}
@property(nonatomic,retain)NSMutableArray*_viewControllers;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTap;

- (void)hideTabbar:(BOOL)hidden;
- (void)setMySelectedIndex:(NSInteger)index;
- (void)setSelectedIndex:(NSUInteger)selectedIndex __attribute__((deprecated));

+ (MyTableBarController *)sharedTabBarController;

@end
