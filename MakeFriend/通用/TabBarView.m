//
//  TabBarView.m
//  ONE
//
//  Created by Liang Wei on 12/23/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import "TabBarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TabBarView

//定义按钮的大小
#define TABBAR_BUTTON_RECT CGRectMake(0, 0, 42.5, 30)
#define TABBAR_BACK_RECT CGRectMake(0, 28, 64, 30)
//tabbar上的中心距离
#define TABBAR_CENTER_HEIGHT 15
//动画时间
#define TABBAR_ANIMATION_TIME 0.2

@synthesize index = _index;
@synthesize delegate = _delegate;

- (void)dealloc
{
    RELEASE_SAFELY(_indexButton);
    RELEASE_SAFELY(_myFriendButton);
    RELEASE_SAFELY(_addFriendButton);
    RELEASE_SAFELY(_messageButton);
    RELEASE_SAFELY(_moreButton);
    RELEASE_SAFELY(_selectedView);
    _delegate = nil;
    
    [super dealloc];
}

#pragma mark - Custom Methods
//设置选择某一个按钮的动画
- (void)setIndex:(int)index
{
    NSLog(@"选择了 %i",index);
    _indexButton.selected = _indexButton.tag == index ? YES : NO;
    _myFriendButton.selected = _myFriendButton.tag == index ? YES :NO;
    _addFriendButton.selected = _addFriendButton.tag == index ? YES :NO;
    _messageButton.selected = _messageButton.tag == index ? YES :NO;
    _moreButton.selected = _moreButton.tag == index ? YES :NO;
    _index = index;
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabbar:didSelectIndex:)]) {
        [_delegate tabbar:self didSelectIndex:index];
    }

    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:TABBAR_ANIMATION_TIME];
	[UIView setAnimationDelegate:self];
    _selectedView.center = CGPointMake(index * 64 + 32, TABBAR_CENTER_HEIGHT);
	[UIView commitAnimations];
}

//点击了tabbar上面的一个按钮的动画
- (void)buttonPressed:(id)sender
{
    if ([sender tag] == self.index) {
        return;
    }
    [self setIndex:[sender tag]];
//        UIButton *btn = (UIButton *)sender;
//    	CAKeyframeAnimation * animation = nil;
//    	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    	animation.duration = TABBAR_ANIMATION_TIME * 2;
//    	animation.delegate = self;
//    	animation.removedOnCompletion = YES;
//    	animation.fillMode = kCAFillModeForwards;
//    	NSMutableArray *values = [NSMutableArray array];
//    	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
//    	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    	animation.values = values;
//    	[btn.layer addAnimation:animation forKey:nil];
}

#pragma mark- init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,14, 320, 49)];
        background.image = [Tools imageWithName:@"tabbar_back"];
        [self addSubview:background];
        [background release];
        //初始化中心的异形按钮
        tabbarViewCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_mainbtn_bg"]];
        
        tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
        
        [tabbarViewCenter setUserInteractionEnabled:YES];
        [self addSubview:tabbarViewCenter];
        [tabbarViewCenter release];
/*
        //初始化选择图标
        _selectedView = [[UIImageView alloc] initWithFrame:TABBAR_BACK_RECT];
        _selectedView.image = [Tools imageWithName:@"tablebar_back"];
        //64.49
        _selectedView.center = CGPointMake(32, 30);
        [self addSubview:_selectedView];
  */      
        //首页
        _indexButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 14, 58, 49)];
        [_indexButton setImage:[Tools imageWithName:NSLocalizedString(@"start_norm", @"tabbar上面首页未选中图片")] forState:UIControlStateNormal];
        [_indexButton setImage:[Tools imageWithName:NSLocalizedString(@"start_light", @"tabbar上面首页选中图片")] forState:UIControlStateSelected];
        _indexButton.tag = 0;
        _indexButton.selected = YES;
        [_indexButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_indexButton];
        
        //我的好友
        _myFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(58, 14, 58, 49)];
        [_myFriendButton setImage:[Tools imageWithName:NSLocalizedString(@"myFriend_norm", @"tabbar上面排名未选中图片")] forState:UIControlStateNormal];
        [_myFriendButton setImage:[Tools imageWithName:NSLocalizedString(@"myFriend_light", @"tabbar上面排名选中图片")] forState:UIControlStateSelected];
        _myFriendButton.tag = 1;
        [_myFriendButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_myFriendButton];
        //加好友
        _addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(132, 3, 55, 55)];
        [_addFriendButton setImage:[Tools imageWithName:NSLocalizedString(@"addFriend_norm", @"tabbar上面分类未选中图片")] forState:UIControlStateNormal];
        _addFriendButton.tag = 2;
        [_addFriendButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_addFriendButton];
        //发消息（聊天）
        _messageButton = [[UIButton alloc] initWithFrame:CGRectMake(320-116, 14, 58, 49)];
        [_messageButton setImage:[Tools imageWithName:NSLocalizedString(@"message_norm", @"tabbar上面书架未选中图片")] forState:UIControlStateNormal];
        [_messageButton setImage:[Tools imageWithName:NSLocalizedString(@"message_light", @"tabbar上面书架选中图片")] forState:UIControlStateSelected];
        _messageButton.tag = 3;
        [_messageButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_messageButton];
        //设置
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(320-58, 14, 58, 49)];
        [_moreButton setImage:[Tools imageWithName:NSLocalizedString(@"more_norm", @"tabbar上面设置未选中图片")] forState:UIControlStateNormal];
        [_moreButton setImage:[Tools imageWithName:NSLocalizedString(@"more_light", @"tabbar上面设置选中图片")] forState:UIControlStateSelected];
        _moreButton.tag = 4;
        [_moreButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_moreButton];
    }
    return self;
}

@end
