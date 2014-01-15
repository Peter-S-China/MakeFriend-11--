//
//  MessageButton.m
//  ONE
//
//  Created by dianji on 12-11-29.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "MessageButton.h"
#import "UIButton+WebCache.h"

@implementation MessageButton
@synthesize buttonInfo;
-(void)dealloc
{
    RELEASE_SAFELY(buttonInfo);
    _delegate = nil;
    [super dealloc];
    

}
-(void)appear
{
    if (![_button imageForState:UIControlStateNormal]) {
        [_indictorView startAnimating];
        NSLog(@"_indictorView = %@",_indictorView);
    [_button setImageWithURL:[NSURL URLWithString:buttonInfo.photoURL] success:^(UIImage *image) {
        [_indictorView stopAnimating];
        if ([buttonInfo.photoURL isEqualToString:@"http://matrix.clickharbour.com/eventPic/image/0711dzh6.jpg"]) {
            NSLog(@"首页图片下载成功的 url= %@",buttonInfo.photoURL);
            NSData *data = UIImageJPEGRepresentation(image, 0.8);
            if (data.length > 0) {
                NSLog(@"123 = %lu",(unsigned long)[data length]);
            }
            [data writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1.png"] atomically:NO];
            NSLog(@"path = %@",[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"1.png"]);
        }
    } failure:^(NSError *error) {
        [_button setImage:[UIImage imageNamed:@"noneImage.png"] forState:UIControlStateNormal];
        [_indictorView stopAnimating];
        NSLog(@"首页图片下载失败的 url= %@",buttonInfo.photoURL);
    }];
    }
}
- (void)handleDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fm = [[[NSDateFormatter alloc] init] autorelease];
    [fm setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowtime = [fm stringFromDate:now];
    
    if ([nowtime compare:buttonInfo.endTime] > 0) {
   /*     //结束
        UIImageView*overView=[[UIImageView alloc]initWithFrame:CGRectMake(-5, -15, 35, 28)];
        overView.image=[UIImage imageNamed:@"began1.png"];
        [self addSubview:overView];
        [overView release];*/
    }
    else if ([nowtime compare:buttonInfo.startTime] > 0 && [nowtime compare:buttonInfo.endTime] <= 0) {
        //进行中
        UIImageView*goingView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-52, 0, 53.5, 48)];
        goingView.image=[UIImage imageNamed:@"goingOn1.png"];
        [self addSubview:goingView];
        [goingView release];
        
    }
    else {
        //还没开始
        UIImageView*willBeginView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-52, 0, 53.5, 48)];
        willBeginView.image=[UIImage imageNamed:@"will_began1.png"];
        [self addSubview:willBeginView];
        [willBeginView release];
        
    }
}
-(void)buttonClicked:(id)sender
{
    //被点击后，通过每一行独特的buttontitle去识别
    if (_delegate && [_delegate respondsToSelector:@selector(messageButton:selectedInfo:)]) {
        [_delegate messageButton:self selectedInfo:buttonInfo];
    }

}

- (void)changeBackGray:(id)sender
{
    _back.image = [UIImage imageNamed:@"button_background.png"];
}

- (void)changeBackYellow:(id)sender
{
    _back.image = [UIImage imageNamed:@"selctedButton.png"];
}

-(id)initWithFrame:(CGRect)frame messageinfo:(MessageInfo*)info delegate:(id<MessageButtonDelegate>)delegate_;
{
    self = [super initWithFrame:frame];
    if (self) {
       
        buttonInfo = [info retain];
        _delegate = delegate_;
        
        _back = [[UIImageView alloc] init];
        _back.image = [UIImage imageNamed:@"button_background.png"];
        _back.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:_back];
        [_back release];
        //初始化button
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, self.bounds.size.width, frame.size.height);
//        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_button addTarget:self action:@selector(changeBackGray:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchDragOutside|UIControlEventTouchUpInside];
//        [_button addTarget:self action:@selector(changeBackYellow:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
        [_button addGestureRecognizer:tap];
 //       [tap requireGestureRecognizerToFail:[MyTableBarController sharedTabBarController].doubleTap];
        [tap release];
        _indictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indictorView.center = _button.center;
        [_button addSubview:_indictorView];
        [_indictorView release];

        [self addSubview:_button];
        
        //添加状态
        [self handleDate];
        
        //每个按钮下面有一个label显示活动标题
        UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_button.frame.size.height-35,_button.frame.size.width , 35)];
        titleLabel.text = buttonInfo.buttonTitle;
        titleLabel.font=[UIFont fontWithName:@"Verdana-Bold" size:14];
        titleLabel.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
       titleLabel.textColor = [UIColor whiteColor];
    //    titleLabel.textColor = [UIColor colorWithRed:0.88 green:0.6 blue:0.15 alpha:1.0];
        titleLabel.textAlignment=UITextAlignmentCenter;
       // [_button addSubview:titleLabel];
        [titleLabel release];
    }
    return self;
}



@end
