//
//  MyTableBarController.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "MyTableBarController.h"

@implementation MyTableBarController

@synthesize  _viewControllers;

static  MyTableBarController*sharedTabBarController = nil;

#pragma mark - Customs Methods
- (void)hideTabbar:(BOOL)hidden
{
    if (hidden) {

            _myTabbar.alpha = 0;

    }
    else {
        _myTabbar.alpha = 1;

        [self.view bringSubviewToFront:_myTabbar];
    }
}

- (void)setMySelectedIndex:(NSInteger)index
{
    [super setSelectedIndex:index];
    [_myTabbar setIndex:index];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}

-(id)init
{
    self=[super init];
    if (self) {
        self._viewControllers = [NSMutableArray arrayWithCapacity:5];
                               
        StartViewController*message=[[StartViewController alloc] initAndHiddenTabBar:NO hiddenLeftButton:YES]; //initWithTitle:@"主页" navTitle:@"主页"];
        UINavigationController*nav1=[[UINavigationController alloc]initWithRootViewController:message];
        [_viewControllers addObject:nav1];
        [message release];
        [nav1 release];
        
        FriendViewController*party=[[FriendViewController alloc]initAndHiddenTabBar:NO hiddenLeftButton:YES];
        UINavigationController*nav2=[[UINavigationController alloc]initWithRootViewController:party];
        [_viewControllers addObject:nav2];
        [party release];
        [nav2 release];
        
        
        AddFriendViewController*friend=[[AddFriendViewController alloc]initAndHiddenTabBar:NO hiddenLeftButton:YES];
        UINavigationController*nav3=[[UINavigationController alloc]initWithRootViewController:friend];
        [_viewControllers addObject:nav3];
        [friend release];
        [nav3 release];
        
        TakeMessageViewController*setting=[[TakeMessageViewController alloc]initAndHiddenTabBar:NO hiddenLeftButton:YES];
        UINavigationController*nav4=[[UINavigationController alloc]initWithRootViewController:setting];
        [_viewControllers addObject:nav4];
        [setting release];
        [nav4 release];
        
        SettingViewController*more=[[SettingViewController alloc]initAndHiddenTabBar:NO hiddenLeftButton:YES];        UINavigationController*nav5=[[UINavigationController alloc]initWithRootViewController:more];
        [_viewControllers addObject:nav5];
        [more release];
        [nav5 release];
        
        self.viewControllers=_viewControllers;
        [_viewControllers release];
        
        //初始化自定义的tabbar
        _myTabbar = [[TabBarView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 64, 320, 64)];
        _myTabbar.delegate = self;
        [self.view addSubview:_myTabbar];
        _myTabbar.index = 0;
        [_myTabbar release];
    }


     return self;
}
+ (MyTableBarController *)sharedTabBarController
{
    @synchronized(self)
    {
        if (sharedTabBarController == nil) {
            sharedTabBarController = [[self alloc] init];
        }
    }
    return sharedTabBarController;
}


#pragma mark - Customs TabBar delegate
- (void)tabbar:(TabBarView *)tabBar didSelectIndex:(int)index
{
    if (index >= 0 && index < self.viewControllers.count) {
        [super setSelectedIndex:index];
       
        for (UINavigationController *nc in self.viewControllers) {
            if ([self.viewControllers indexOfObject:nc] != index) {
                [nc popToRootViewControllerAnimated:YES];
            }
        }
    }
}

@end
