//
//  UINavigationBar+Background.m
//  Reader
//
//  Created by liangw on 9/4/12.
//  Copyright (c) 2012 qinyh. All rights reserved.
//

#import "UINavigationBar+Background.h"

@implementation UINavigationBar (Background)

- (void)drawRect:(CGRect)rect
{
    UIImage *img = [UIImage imageNamed:@"navbar_background1.png"];
    [img drawInRect:CGRectMake(0, 0, 320, 44)];

}

- (void)didMoveToSuperview
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:[UIImage imageNamed:@"navbar_background1.png"] forBarMetrics:UIBarMetricsDefault];
        
    }
}

@end
