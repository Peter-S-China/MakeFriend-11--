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
#define TABBAR_BUTTON_RECT CGRectMake(0, 0, 64, 49)
#define TABBAR_BACK_RECT CGRectMake(0, 0, 64, 49)
//tabbar上的中心距离
#define TABBAR_CENTER_HEIGHT 25
//动画时间
#define TABBAR_ANIMATION_TIME 0.2

@synthesize index = _index;
@synthesize delegate = _delegate;

- (void)dealloc
{
    RELEASE_SAFELY(_indexButton);
    RELEASE_SAFELY(_attentionButton);
    RELEASE_SAFELY(_joinButton);
    RELEASE_SAFELY(_searchButton);
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
    _attentionButton.selected = _attentionButton.tag == index ? YES :NO;
    _joinButton.selected = _joinButton.tag == index ? YES :NO;
    _searchButton.selected = _searchButton.tag == index ? YES :NO;
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
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
        background.image = [Tools imageWithName:@"navbar_back"];
        [self addSubview:background];
        [background release];
        //初始化选择图标
        _selectedView = [[UIImageView alloc] initWithFrame:TABBAR_BACK_RECT];
        _selectedView.image = [Tools imageWithName:@"tablebar_back"];
        _selectedView.center = CGPointMake(32, 24.5);
        [self addSubview:_selectedView];
        
        //首页
        _indexButton = [[UIButton alloc] initWithFrame:TABBAR_BUTTON_RECT];
        _indexButton.center = CGPointMake(32, self.bounds.size.height - TABBAR_CENTER_HEIGHT);
        [_indexButton setImage:[Tools imageWithName:NSLocalizedString(@"fa_norm", @"tabbar上面首页未选中图片")] forState:UIControlStateNormal];
        [_indexButton setImage:[Tools imageWithName:NSLocalizedString(@"fa1", @"tabbar上面首页选中图片")] forState:UIControlStateSelected];
        _indexButton.tag = 0;
        _indexButton.selected = YES;
        [_indexButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_indexButton];
        
        //关注
        _attentionButton = [[UIButton alloc] initWithFrame:TABBAR_BUTTON_RECT];
        _attentionButton.center = CGPointMake(96, self.bounds.size.height - TABBAR_CENTER_HEIGHT);
        [_attentionButton setImage:[Tools imageWithName:NSLocalizedString(@"attention_norm", @"tabbar上面排名未选中图片")] forState:UIControlStateNormal];
        [_attentionButton setImage:[Tools imageWithName:NSLocalizedString(@"attention_light", @"tabbar上面排名选中图片")] forState:UIControlStateSelected];
        _attentionButton.tag = 1;
        [_attentionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_attentionButton];
        //参与
        _joinButton = [[UIButton alloc] initWithFrame:TABBAR_BUTTON_RECT];
        _joinButton.center = CGPointMake(160, self.bounds.size.height - TABBAR_CENTER_HEIGHT);
        [_joinButton setImage:[Tools imageWithName:NSLocalizedString(@"joined_norm", @"tabbar上面分类未选中图片")] forState:UIControlStateNormal];
        [_joinButton setImage:[Tools imageWithName:NSLocalizedString(@"joined_light", @"tabbar上面分分类选中图片")] forState:UIControlStateSelected];
        _joinButton.tag = 2;
        [_joinButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_joinButton];
        //搜索
        _searchButton = [[UIButton alloc] initWithFrame:TABBAR_BUTTON_RECT];
        _searchButton.center = CGPointMake(224, self.bounds.size.height - TABBAR_CENTER_HEIGHT);
        [_searchButton setImage:[Tools imageWithName:NSLocalizedString(@"search_norm", @"tabbar上面书架未选中图片")] forState:UIControlStateNormal];
        [_searchButton setImage:[Tools imageWithName:NSLocalizedString(@"serch2", @"tabbar上面书架选中图片")] forState:UIControlStateSelected];
        _searchButton.tag = 3;
        [_searchButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_searchButton];
        //更多
        _moreButton = [[UIButton alloc] initWithFrame:TABBAR_BUTTON_RECT];
        _moreButton.center = CGPointMake(288, self.bounds.size.height - TABBAR_CENTER_HEIGHT);
        [_moreButton setImage:[Tools imageWithName:NSLocalizedString(@"more_norm", @"tabbar上面设置未选中图片")] forState:UIControlStateNormal];
        [_moreButton setImage:[Tools imageWithName:NSLocalizedString(@"more_light", @"tabbar上面设置选中图片")] forState:UIControlStateSelected];
        _moreButton.tag = 4;
        [_moreButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_moreButton];
    }
    return self;
}

@end
