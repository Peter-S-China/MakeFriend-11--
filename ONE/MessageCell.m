//
//  MessageCell.m
//  ONE
//
//  Created by dianji on 12-11-29.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

#pragma mark - Customs Methods
-(NSArray*)visiblePhotoViews
{
    NSMutableArray*vpv=[[NSMutableArray alloc]init];
    for (UIView*subview in _scrollView.subviews) {
        if ([subview isKindOfClass:[MessageButton class]]&&CGRectIntersectsRect(_scrollView.bounds, subview.frame)) {
            [vpv addObject:subview];
        }
    }

    return [vpv autorelease];
}
-(void)appear
{
    NSArray*pvs=[self visiblePhotoViews];
    for(MessageButton*pv in pvs){
        if ([pv isKindOfClass:[MessageButton class]]) {
            [pv appear];
        }
    }
}

//根据标题，得到悬浮图片
- (UIImage *)handleTitle:(NSString *)title
{
    UIImage *image = nil;
    if ([title isEqualToString:@"运动"]) {
        image = [[UIImage imageNamed:@"sport.png"] retain];
        
    }
    else if ([title isEqualToString:@"公益"]) {
        image = [[UIImage imageNamed:@"charity.png"] retain];
    }
    else if ([title isEqualToString:@"电影"]) {
        image = [[UIImage imageNamed:@"moves.png"] retain];
    }
    else if ([title isEqualToString:@"拍卖"]) {
        image = [[UIImage imageNamed:@"sale.png"] retain];
    }
    else if ([title isEqualToString:@"其他"]) {
        image = [[UIImage imageNamed:@"other.png"] retain];
    }
    else if ([title isEqualToString:@"时尚聚会"]) {
        image = [[UIImage imageNamed:@"party.png"] retain];
    }
    else if ([title isEqualToString:@"演出"]) {
        image = [[UIImage imageNamed:@"concert.png"] retain];
    }
    else if ([title isEqualToString:@"夜生活"]) {
        image = [[UIImage imageNamed:@"nightlife.png"] retain];
    }
    else if ([title isEqualToString:@"展会"]) {
        image = [[UIImage imageNamed:@"exhibition.png"] retain];
    }
    return [image autorelease];
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              infos:(NSArray *)infos
           delegate:(id)delegate_;
{
    self = [super initWithFrame:frame];
    if (self) {
        //在每个横者的scrollview下面加上一张view
        UIImageView*backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"messageBackgroud.png"]];
        backgroundView.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:backgroundView];
        [backgroundView release];
        //在view上加载一个指示箭头
//        UIImageView*row=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"row.png"]];
//        row.frame=CGRectMake(CGRectGetMaxX(backgroundView.frame)-25, CGRectGetMaxY(backgroundView.frame)-15, 21, 11);
//        [backgroundView addSubview:row];
//        [row release];
        
         //初始化的是九个横着的小的scrollView,
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize=CGSizeMake((138+5) * [infos count]+5, 196);
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        [_scrollView release];
            for (int j=0; j<[infos count]; j++) {
                MessageInfo *info = [infos objectAtIndex:j];
                NSLog(@"%i",[infos count]);
                NSLog(@"%@",info);
                //在每一个scollview上编排6个类信息的button
                MessageButton *button = [[MessageButton alloc]initWithFrame: CGRectMake(j*(139+3)+3.0, 10, 139, 206) messageinfo:info delegate:delegate_];
                [_scrollView addSubview:button];
                [button release];
            }

    }
    return self;
}

- (void)setScorollViewContentWidth:(float)width
{
    CGSize size = _scrollView.contentSize;
    size.width += width;
    _scrollView.contentSize = size;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
//    for (MessageButton *subview in scrollView.subviews) {
//        if ([subview isKindOfClass:[MessageButton class]] && CGRectIntersectsRect(scrollView.bounds, subview.frame)) {
//            NSLog(@"appear");
//            [subview appear];
//        }
//    }
    [self appear];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (!decelerate) {
//        for (MessageButton *subview in scrollView.subviews) {
//            if ([subview isKindOfClass:[MessageButton class]] && CGRectIntersectsRect(scrollView.bounds, subview.frame)) {
//                [subview appear];
//            }
//        }
        [self appear];
    }
}



@end
