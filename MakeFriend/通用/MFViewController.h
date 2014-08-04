//
//  MFViewController.h
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFViewController : UIViewController
{
    
    BOOL _hideTabbar;//用来控制底部的Tabbar是否隐藏
    BOOL _hideLeftButton;//用来控制是否隐藏返回按钮
    
}

- (id)initAndHiddenTabBar:(BOOL)hiddenTabBar hiddenLeftButton:(BOOL)hideLeft;
- (id)init __attribute__((deprecated));//这个方法标记为过时了

- (void)setMFTabBarHidden:(BOOL)hidden;
- (void)backButtonPressed:(id)sender;

@end
