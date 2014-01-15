//
//  AttentionCell.m
//  ONE
//
//  Created by dianji on 12-12-10.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "AttentionCell.h"
#import "UIImageView+WebCache.h"
#import "PersonalMessageViewController.h"
#import "UserLocation.h"
@implementation AttentionCell
@synthesize cancelButton;
@synthesize largeView;
@synthesize litleView;

- (void)dealloc
{
    RELEASE_SAFELY(_info);
    _delegate = nil;
    [_request clearDelegatesAndCancel];
    [_request release];
    
    [super dealloc];
}

-(void)jionNow:(id)sender
{
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"选择拨打电话或填写信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"填写信息",@"拨打电话" ,nil];
    alter.tag=1500;
    [alter show];
    [alter release];
    
//    if (_delegate && [_delegate respondsToSelector:@selector(attentionCell:joinWithInfo:)]) {
//        [_delegate attentionCell:self joinWithInfo:_info];
//    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1500) {
        //填写信息
        if (buttonIndex==1) {
            if (_delegate && [_delegate respondsToSelector:@selector(attentionCell:joined:)]) {
                [_delegate attentionCell:self joined:_info];
                
            }
        }
        //拨打电话
        if (buttonIndex==2) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(attentionCell:)]) {
                [_delegate attentionCell:self];
            }
            
        }


    }
}
//获取距离
- (void)getDistance
{
    NSArray*tituArray=[_info.location componentsSeparatedByString:@","];
    NSString*lantitude=[NSString stringWithFormat:@"%@",[tituArray objectAtIndex:1]];
    NSString*longtitude=[NSString stringWithFormat:@"%@",[tituArray objectAtIndex:0]];
   
  CLLocation *ogig = [[[CLLocation alloc] initWithLatitude:[[UserLocation sharedUserLocation] antitude] longitude:[[UserLocation sharedUserLocation] longtitude]] autorelease];  
    
    
    CLLocation* dist=[[[CLLocation alloc] initWithLatitude:[lantitude doubleValue] longitude:[longtitude doubleValue] ] autorelease];
    
    CLLocationDistance kilometers=[ogig distanceFromLocation:dist]/1000;
    
 //   NSLog(@"____^^^^^^_____kilometers:%0.2f 公里____________________",kilometers);
    destanceLabel.text = [NSString stringWithFormat:@"%.1fKm", kilometers];
  //  NSLog(@"...destanceLabel.....%f",[ogig distanceFromLocation:dist]);

 }
-(void)edite:(NSNotification *)notification
{

    cancelButton.hidden=NO;
}
-(void)editeDone:(NSNotification*)notification
{
    cancelButton.hidden=YES;

}

-(void)cancelButtonClicked:(UIButton*)sender
{

    if (_delegate && [_delegate respondsToSelector:@selector(attentionCell:moveWithInfo:)]) {
        [_delegate attentionCell:self moveWithInfo:_info];
    }

}

- (void)handleDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fm = [[[NSDateFormatter alloc] init] autorelease];
    [fm setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowtime = [fm stringFromDate:now];
    
    if ([nowtime compare:_info.endTime] > 0) {
        //结束
        UIImageView*overView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.largeView.frame) - 40, 0, 40, 32)];
        overView.image=[UIImage imageNamed:@"over.png"];
        [self.largeView addSubview:overView];
        [overView release];
    }
    else if ([nowtime compare:_info.startTime] >= 0 && [nowtime compare:_info.endTime] <= 0) {
        //进行中
        UIImageView*goingView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.largeView.frame) - 40, 0, 40, 32)];
        goingView.image=[UIImage imageNamed:@"goingOn.png"];
        [self.largeView addSubview:goingView];
        [goingView release];
        
    }
    else {
        //还没开始
        UIImageView*willBeginView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.largeView.frame) - 40, 0, 40, 32)];
        willBeginView.image=[UIImage imageNamed:@"will_began.png"];
        [self.largeView addSubview:willBeginView];
        [willBeginView release];
        
    }
}
-(void)litleViewClicked:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(attentionCell:selectedInfo:)]) {
        [_delegate attentionCell:self selectedInfo:_info];
        
    }


}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(MessageInfo *)info delegate:(id)delegate_
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        _info=[info retain];
        _delegate = delegate_;
        
    //最底层是两个view。一个放图片，一个放文字，为了有隔页的效果

        largeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 188)];
        UIImageView*imageview1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 188)];
        imageview1.image=[[UIImage imageNamed:@"largeViewBackground.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:100];
        [largeView addSubview:imageview1];
        [imageview1 release];
        
        [self addSubview:largeView];
        [largeView release];
        
       //放海报的背景图片
        litleView=[[UIView alloc]initWithFrame:CGRectMake(10, 20, 105,148)];
        [largeView addSubview:litleView];
        [litleView release];
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, litleView.bounds.size.width, litleView.bounds.size.height)];
        imageview.userInteractionEnabled=YES;
        imageview.image=[[UIImage imageNamed:@"littleVIewBackgroun.png"]stretchableImageWithLeftCapWidth:100 topCapHeight:100];
        [litleView addSubview:imageview];
        [imageview release];
        
        //放宣传海报图片的位置
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 105,148)];
        NSString *url =[NSString stringWithFormat:@"%@",_info.photoURL];
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"tidai"]];
        [imageview addSubview:imageView];
        [imageView release];
    //在每个图片上放一个button
        littleViewBUtton=[UIButton buttonWithType:UIButtonTypeCustom];
        littleViewBUtton.frame=imageview.frame;
        littleViewBUtton.backgroundColor=[UIColor clearColor];
        [littleViewBUtton addTarget:self action:@selector(litleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:littleViewBUtton];
        
    //布置标题时间地点等信息
        
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 22, 200, 15)];
        timeLabel.text=[NSString stringWithFormat:@"%@",_info.startTime];
        
        timeLabel.textColor=[UIColor whiteColor];
        timeLabel.backgroundColor=[UIColor clearColor];
        timeLabel.font=[UIFont systemFontOfSize:12];
        [largeView addSubview:timeLabel];
        [timeLabel release];
        
        
        
        CGSize titleSize=[[NSString stringWithFormat:@"%@",_info.buttonTitle] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] constrainedToSize:CGSizeMake(170, 35)];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 55, 170, titleSize.height)];
        titleLabel.text=_info.buttonTitle;
        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.backgroundColor=[UIColor clearColor];
    //    titleLabel.textColor=[UIColor colorWithRed:0.89 green:0.56 blue:0.1 alpha:1];
        titleLabel.textColor=[UIColor whiteColor];
        
        titleLabel.font=[UIFont systemFontOfSize:18];
        [largeView addSubview:titleLabel];
        [titleLabel release];
        
               
        abstractLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 40+titleSize.height+20, 170, 50)];
        abstractLabel.backgroundColor=[UIColor clearColor];
        NSRange range=NSMakeRange(0,32);
        abstractLabel.text=[_info.abstract substringWithRange:range];
        abstractLabel.font=[UIFont systemFontOfSize:12];
        abstractLabel.textColor=[UIColor whiteColor];
        abstractLabel.numberOfLines=0;
        [largeView addSubview:abstractLabel];
        [abstractLabel release];
        
   //布局关注度，参加人数，距离信息
        attentionImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, largeView.bounds.size.height-18, 20, 13)];
        attentionImage.image=[UIImage imageNamed:@"norm6.png"];
        [largeView addSubview:attentionImage];
        
        attentionLabel=[[UILabel alloc]initWithFrame:CGRectMake(45, largeView.bounds.size.height-18,25, 15)];
        attentionLabel.textColor=[UIColor whiteColor];
        attentionLabel.text=_info.attention;
        attentionLabel.font=[UIFont systemFontOfSize:12];
        attentionLabel.backgroundColor=[UIColor clearColor];
        [largeView addSubview:attentionLabel];
        [attentionLabel release];
        [attentionImage release];
        
        
        joinImage=[[UIImageView alloc]initWithFrame:CGRectMake(145, largeView.bounds.size.height-20, 15, 17)];
        joinImage.image=[UIImage imageNamed:@"norm4.png"];
        [largeView addSubview:joinImage];
        
        joinLabel=[[UILabel alloc]initWithFrame:CGRectMake(165,largeView.bounds.size.height-18, 25, 15)];
        joinLabel.backgroundColor=[UIColor clearColor];
        joinLabel.font=[UIFont systemFontOfSize:12];
        joinLabel.text=_info.joinedNumber;
        joinLabel.textColor=[UIColor whiteColor];
        [largeView addSubview:joinLabel];
        [joinLabel release];
        [joinImage release];
/*
        destanceImage=[[UIImageView alloc]initWithFrame:CGRectMake(215, 75, 15, 15)];
        destanceImage.image=[UIImage imageNamed:@"howlong.png"];
        [largeView addSubview:destanceImage];
        
        destanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(230, 75, 45, 15)];
        destanceLabel.backgroundColor=[UIColor clearColor];
        destanceLabel.textColor = [UIColor whiteColor];
        [largeView addSubview:destanceLabel];
        destanceLabel.font=[UIFont systemFontOfSize:12];
        [destanceImage release];
        [destanceLabel release];
 */       
        //纪录状态
 //       [self handleDate];
        
        //马上参加的button,一个view上加button
        
        UIButton*joinButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [joinButton setBackgroundImage:[UIImage imageNamed:@"joinButton.png"] forState:UIControlStateNormal];
        joinButton.frame=CGRectMake(250, largeView.bounds.size.height-20, 60, 18);
        [joinButton setTitle:@"马上参加" forState:UIControlStateNormal];
        [joinButton setTitleColor:[UIColor colorWithRed:0.89 green:0.56 blue:0.1 alpha:1] forState:UIControlStateNormal];
        
        joinButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [joinButton addTarget:self action:@selector(jionNow:) forControlEvents:UIControlEventTouchUpInside];
        [largeView addSubview:joinButton];
        [self getDistance];
     //马上参加的button转变为删除按钮
        cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        cancelButton.frame=CGRectMake(248, largeView.bounds.size.height-20, 62, 20);
        [cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        cancelButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.hidden=YES;
        [largeView addSubview:cancelButton];
       
 //注册通知把参与按钮变为删除按钮
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(edite:) name:@"editData" object:nil];
//注册通知把删除按钮变为参与按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editeDone:) name:@"editDoneData" object:nil];
        
    }
    return self;
    
}


@end
