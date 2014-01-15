//
//  TimeView.m
//  ONE
//
//  Created by dianji on 12-12-20.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "TimeView.h"

@implementation TimeView

-(void)dealloc
{
    [super dealloc];

}

#pragma mark - Customs Methods
- (UIButton *)createButtonWithTitle:(NSString *)title
                                   target:(id)target
                                   action:(SEL)action
{
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:10];
    button.titleLabel.textAlignment = UITextAlignmentLeft;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor magentaColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor magentaColor] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:10]];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    return [button autorelease];
}

-(void)searchNow:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(timelView:withTime:withClass:withArea:)]) {
        [_delegate timelView:self withTime:_selectedTime withClass:_selectedClass withArea:_selectedArea];
    }
}
- (void)chooseTime:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.tag < 200) {//时间
        int num = button.tag -100;
        _selectedTime = [[_titleDic objectForKey:@"time"] objectAtIndex:num];
        for (UIView *view in _timeView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *bt = (UIButton *)view;
                if (view.tag == button.tag) {
                    bt.selected = YES;
                }
                else {
                    bt.selected = NO;
                }
            }
        }
        
    }
    else if (button.tag >= 200 && button.tag < 300) {//类别
        int num = button.tag -200;
        _selectedClass = [[_titleDic objectForKey:@"class"] objectAtIndex:num];
        for (UIView *view in _classView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *bt = (UIButton *)view;
                if (view.tag == button.tag) {
                    bt.selected = YES;
                }
                else {
                    bt.selected = NO;
                }
            }
        }
    }
    else if (button.tag >= 300){
        int num = button.tag -300;
        _selectedArea = [[_titleDic objectForKey:@"area"] objectAtIndex:num];
        for (UIView *view in _areaView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *bt = (UIButton *)view;
                if (view.tag == button.tag) {
                    bt.selected = YES;
                }
                else {
                    bt.selected = NO;
                }
            }
        }
    }
}

//初始化时间
- (void)initTimeView:(NSArray *)titles
{
    _timeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_timeView];
//    _timeView = [UIColor blueColor];
    [_timeView release];
    //对时间布局
    if ([titles count] > 0) {
        float _x = 0;
        float _max = 0;
        _selectedTime = [titles objectAtIndex:0];
        for (int i = 0; i < 2; i ++) {
            for (int j = 0; j < 6; j++) {
                if (j * 2 + i < [titles count]) {
                    int num = j * 2 + i;
                    NSString *str = [titles objectAtIndex:num];
                    UIButton *button = [self createButtonWithTitle:str target:self action:@selector(chooseTime:)];
                    button.tag = num + 100;
                    if (num == 0) {
                        button.selected = YES;
                    }
                    _max = MAX(_max, CGRectGetWidth(button.frame) + 5);
                    button.frame = CGRectMake(_x, j * (CGRectGetHeight(button.frame) + 20), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
                    _timeView.frame = CGRectMake(0, 30, MAX(_x, _max), (j + 2) * (button.frame.size.height + 20));
                    [_timeView addSubview:button];

                }
            }
            _x += _max;
            _max = 0;
        }
        CGRect rect = _timeView.frame;
        rect.size.width = _x - 10;
        rect.size.height -= 40;
        _timeView.frame = rect;
        
        _timeView.center = CGPointMake(CGRectGetWidth(self.bounds) / 6 + 5, 130);
    }
}
//初始化类别
- (void)initClassView:(NSArray *)titles
{
    _classView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_classView];
//    _classView = [UIColor blueColor];
    [_classView release];
    //对时间布局
    if ([titles count] > 0) {
        float _x = 0;
        float _max = 0;
        int lie = [titles count] % 2 == 0 ? [titles count] / 2 : [titles count] / 2 + 1;
        _selectedClass = [titles objectAtIndex:0];
        for (int i = 0; i < 2; i ++) {
            for (int j = 0; j < lie; j++) {
                if (j * 2 + i < [titles count]) {
                    int num = j * 2 + i;
                    NSString *str = [titles objectAtIndex:num];
                    UIButton *button = [self createButtonWithTitle:str target:self action:@selector(chooseTime:)];
                    button.tag = num + 200;
                    if (num == 0) {
                        button.selected = YES;
                    }
                    _max = MAX(_max, CGRectGetWidth(button.frame) + 5);
                    button.frame = CGRectMake(_x, j * (CGRectGetHeight(button.frame) + 20), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
                    _classView.frame = CGRectMake(0, 30, MAX(_x, _max), (j + 2) * (button.frame.size.height + 20));
                    [_classView addSubview:button];
                    
                }
            }
            _x += _max;
            _max = 0;
        }
        CGRect rect = _classView.frame;
        rect.size.width = _x - 5;
        _classView.frame = rect;
        
        _classView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2 + 5, 115);
    }

}
//初始化区域
- (void)initAreaView:(NSArray *)titles
{
    _areaView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_areaView];
//    _areaView.backgroundColor = [UIColor blueColor];
    [_areaView release];
    //对时间布局
    if ([titles count] > 0) {
        float _x = 0;
        float _max = 0;
        int lie = [titles count] % 2 == 0 ? [titles count] / 2 : [titles count] / 2 + 1;
        _selectedArea = [titles objectAtIndex:0];
        for (int i = 0; i < 2; i ++) {
            for (int j = 0; j < lie; j++) {
                if (j * 2 + i < [titles count]) {
                    int num = j * 2 + i;
                    NSString *str = [titles objectAtIndex:num];
                    UIButton *button = [self createButtonWithTitle:str target:self action:@selector(chooseTime:)];
                    button.tag = num + 300;
                    if (num == 0) {
                        button.selected = YES;
                    }
                    _max = MAX(_max, CGRectGetWidth(button.frame) + 5);
                    button.frame = CGRectMake(_x, j * (CGRectGetHeight(button.frame) + 10), CGRectGetWidth(button.frame), CGRectGetHeight(button.frame));
                    _areaView.frame = CGRectMake(0, 30, MAX(_x, _max), (j + 2) * (button.frame.size.height+4));
                    [_areaView addSubview:button];
                    
                }
            }
            _x += _max;
            _max = 0;
        }
        CGRect rect = _areaView.frame;
        rect.size.width = _x - 5;
        _areaView.frame = rect;
        
        _areaView.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bounds) / 6, 115);
    }

}

//初始化头部标题
- (void)initHeadView
{
    UILabel *time = [Tools createLabel:@"时间" frame:CGRectMake(0, 0, CGRectGetWidth(self.frame) / 3, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:16] aliment:UITextAlignmentCenter];
    [self addSubview:time];
    
    UILabel *class = [Tools createLabel:@"分类" frame:CGRectMake(CGRectGetMaxX(time.frame), 0, CGRectGetWidth(self.frame) / 3, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:16] aliment:UITextAlignmentCenter];
    [self addSubview:class];
    
    UILabel *area = [Tools createLabel:@"区域" frame:CGRectMake(CGRectGetMaxX(class.frame), 0, CGRectGetWidth(self.frame) / 3, 30) color:[UIColor blackColor] font:[UIFont systemFontOfSize:16] aliment:UITextAlignmentCenter];
    [self addSubview:area];
    
}

#pragma mark - init
-(id)initWithFrame:(CGRect)frame infoDic:(NSDictionary *)infoDic delegate:(id)delegate_
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _titleDic = [infoDic retain];
        _delegate=delegate_;
        //加上背景image。待实现
        [self initHeadView];
        //初始化三个view
        [self initTimeView:[_titleDic objectForKey:@"time"]];
        [self initClassView:[_titleDic objectForKey:@"class"]];
        [self initAreaView:[_titleDic objectForKey:@"area"]];
        self.backgroundColor = [UIColor whiteColor];
        //添加搜索button
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        searchButton.frame = CGRectMake(0, 0, 100, 50);
        [searchButton setTitle:@"立即搜索" forState:UIControlStateNormal];
        searchButton.center = CGPointMake(160, CGRectGetHeight(self.frame) - 20 - 25);
        [searchButton addTarget:self action:@selector(searchNow:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchButton];
        }
    
    return self;
}

@end
