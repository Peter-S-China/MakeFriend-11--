//
//  TabBarView.h
//  ONE
//
//  Created by Liang Wei on 12/23/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarView;
@protocol TabbarDelegate <NSObject>
//点击某一个tabBar上的图标，进入相应的viewController
- (void)tabbar:(TabBarView *)tabBar didSelectIndex:(int)index;

@end
//自定义的Tabbar，上边的几个按钮是固定的
@interface TabBarView : UIView
{
@private
    UIImageView *tabbarViewCenter;
    UIButton *button_center;
    UIButton *_indexButton;//首页的按钮
    UIButton *_myFriendButton;//关注的按钮
    UIButton *_addFriendButton;//参与的按钮
    UIButton *_messageButton;//搜索的按钮
    UIButton *_moreButton;//更多的按钮
    UIImageView *_selectedView;
}

@property (nonatomic, assign) int index;
@property (nonatomic, assign) id<TabbarDelegate> delegate;

@end
