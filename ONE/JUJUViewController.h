//
//  JUJUViewController.h
//  ONE
//
//  Created by Liang Wei on 12/23/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
//所有的类都需要继承自他,用来设定是否隐藏返回按钮和底部的Tabbar.
@interface JUJUViewController : UIViewController
{

    BOOL _hideTabbar;//用来控制底部的Tabbar是否隐藏
    BOOL _hideLeftButton;//用来控制是否隐藏返回按钮
    
}

- (id)initAndHiddenTabBar:(BOOL)hiddenTabBar hiddenLeftButton:(BOOL)hideLeft;
- (id)init __attribute__((deprecated));//这个方法标记为过时了

- (void)setJUJUTabBarHidden:(BOOL)hidden;
- (void)backButtonPressed:(id)sender;

@end
