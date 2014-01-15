//
//  subSearchCell.m
//  ONE
//
//  Created by dianji on 12-12-24.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "subSearchCell.h"
#import "UIImageView+WebCache.h"

@implementation subSearchCell
@synthesize rightBack;
@synthesize leftBack;
- (void)dealloc
{
    RELEASE_SAFELY(_info);
    
    [super dealloc];
}
- (void)handleDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fm = [[[NSDateFormatter alloc] init] autorelease];
    [fm setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowtime = [fm stringFromDate:now];
    
    if ([nowtime compare:_info.endTime] > 0) {
        //结束
        UIImageView*overView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.rightBack.frame) - 40, 0, 40, 32)];
        overView.image=[UIImage imageNamed:@"over.png"];
        [self.rightBack addSubview:overView];
        [overView release];
    }
    else if ([nowtime compare:_info.startTime] >= 0 && [nowtime compare:_info.endTime] <= 0) {
        //进行中
        UIImageView*goingView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.rightBack.frame) - 40, 0, 40, 32)];
        goingView.image=[UIImage imageNamed:@"goingOn.png"];
        [self.rightBack addSubview:goingView];
        [goingView release];
        
    }
    else {
        //还没开始
        UIImageView*willBeginView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.rightBack.frame) - 40, 0, 40, 32)];
        willBeginView.image=[UIImage imageNamed:@"will_began.png"];
        [self.rightBack addSubview:willBeginView];
        [willBeginView release];
        
    }
}
-(void)litleViewClicked:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(subSearchCell:selectedInfo:)]) {
        [_delegate subSearchCell:self selectedInfo:_info];
        
    }
    
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMessageInfo:(MessageInfo *)info delegate:(id)delegate_
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _info = [info retain];
        _delegate = delegate_;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        //开始布局，首先是底部的两张黑色背景
        rightBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 188)];
        rightBack.image = [[UIImage imageNamed:@"largeViewBackground.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:100];
        [self.contentView addSubview:rightBack];
        [rightBack release];
    
        
        leftBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 105,148)];
        leftBack.userInteractionEnabled=YES;
        leftBack.image = [[UIImage imageNamed:@"littleVIewBackgroun.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:100];
        [self.contentView addSubview:leftBack];
        [leftBack release];
        
        //加上图片
        UIImageView *seachImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftBack.bounds.size.width, leftBack.bounds.size.height)];
        seachImage.userInteractionEnabled=YES;
        [seachImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_info.detailPhotoURL]] placeholderImage:[UIImage imageNamed:@"noneImage.png"]];
        [leftBack addSubview:seachImage];
        [seachImage release];
        
        //在每个图片上放一个button
        littleViewBUtton=[UIButton buttonWithType:UIButtonTypeCustom];
        littleViewBUtton.frame=seachImage.frame;
        littleViewBUtton.backgroundColor=[UIColor clearColor];
        [littleViewBUtton addTarget:self action:@selector(litleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [seachImage addSubview:littleViewBUtton];
        //时间
        UILabel *time = [Tools createLabel:[NSString stringWithFormat:@"时间：%@", _info.startTime] frame:CGRectMake(125, 22, 200, 15) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:12] aliment:UITextAlignmentLeft];
        [rightBack addSubview:time];
        //标题
        CGSize titleSize=[[NSString stringWithFormat:@"%@",_info.buttonTitle] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] constrainedToSize:CGSizeMake(170, 35)];
        
        UILabel *title = [Tools createLabel:_info.buttonTitle frame:CGRectMake(125, 55, 170, titleSize.height) color:[UIColor colorWithRed:0.89 green:0.56 blue:0.1 alpha:1] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] aliment:UITextAlignmentLeft];
        [rightBack addSubview:title];
       
        //地点
        UILabel *location = [Tools createLabel:[NSString stringWithFormat:@"地点：%@",_info.dest] frame:CGRectMake(125, 40+titleSize.height+20, 170, 50) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] aliment:UITextAlignmentLeft];
        [rightBack addSubview:location];
        //纪录状态
 //       [self handleDate];
            }
    return self;
}

@end
