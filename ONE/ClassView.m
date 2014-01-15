//
//  ClassView.m
//  ONE
//
//  Created by Liang Wei on 12/27/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import "ClassView.h"

@implementation ClassView

- (void)dealloc
{
    RELEASE_SAFELY(_titlesArray);
    
    [super dealloc];
}

#pragma mark - Customs Methods
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

#pragma mark - init
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles_
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView*bakgroundImage1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 196+12)];
        bakgroundImage1.image=[UIImage imageNamed:@"left_bj"];
        [self addSubview:bakgroundImage1];
        [bakgroundImage1 release];
        
        _titlesArray = [titles_ retain];
        //开始布局NSString *title in _titlesArray
        for (NSString *title in _titlesArray) {
            int i = [_titlesArray indexOfObject:title];
            UIImageView*bakgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, i*(196+12)+196, 25, 196+12)];
            bakgroundImage.image=[UIImage imageNamed:@"left_bj"];
            [self addSubview:bakgroundImage];
            [bakgroundImage release];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 6 , 18, 18)];
            imageView.image = [self handleTitle:title];
            [bakgroundImage addSubview:imageView];
            [imageView release];
            CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(16, MAXFLOAT)];
            
            UILabel *label = [Tools createLabel:title frame:CGRectMake(2, 28 , 16, size.height) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:12] aliment:UITextAlignmentCenter];
            label.numberOfLines = 0;
            [bakgroundImage addSubview:label];
        }
    }
    return self;
}



@end
