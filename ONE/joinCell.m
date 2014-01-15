//
//  joinCell.m
//  ONE
//
//  Created by dianji on 12-12-18.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "joinCell.h"
#import "UIImageView+WebCache.h"

@implementation joinCell
@synthesize largeView;
@synthesize litleView;
@synthesize cancelButton;

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

//获取距离
- (void)getDistance
{
    NSArray*tituArray=[_info.location componentsSeparatedByString:@","];
    NSString*lantitude=[NSString stringWithFormat:@"%@",[tituArray objectAtIndex:1]];
    NSString*longtitude=[NSString stringWithFormat:@"%@",[tituArray objectAtIndex:0]];
    
    CLLocation *ogig = [[[CLLocation alloc] initWithLatitude:[[UserLocation sharedUserLocation] antitude] longitude:[[UserLocation sharedUserLocation] longtitude]] autorelease];
    
    
    CLLocation* dist=[[[CLLocation alloc] initWithLatitude:[lantitude doubleValue] longitude:[longtitude doubleValue] ] autorelease];
    
    CLLocationDistance kilometers=[ogig distanceFromLocation:dist]/1000;
    
    NSLog(@"____^^^^^^_____kilometers:%0.2f 公里____________________",kilometers);
    destanceLabel.text = [NSString stringWithFormat:@"%.1fKm", kilometers];
    NSLog(@"...destanceLabel.....%f",[ogig distanceFromLocation:dist]);
    
    
 /*
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://218.246.34.29:8026/pages/index.aspx?eventTudu=%@&joinTudu=%f,%f",_info.location,[[UserLocation sharedUserLocation] longtitude],[[UserLocation sharedUserLocation] antitude]]];
    NSLog(@"位置的url = %@",url);
    [_request clearDelegatesAndCancel];
    [_request release];
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request startAsynchronous];
    
    [_request setFailedBlock:^{
        NSLog(@"获取位置信息失败");
    }];
    [_request setCompletionBlock:^{
        NSLog(@"获取位置信息成功");
        NSLog(@"%@",_request.responseString);
        if (_request.responseString.length > 0) {
            destanceLabel.text = [NSString stringWithFormat:@"%.1fKm", [_request.responseString floatValue]];
        
        }
    }];

  */
  }
-(void)cancelButtonClicked:(UIButton*)sender
{
 if (_delegate && [_delegate respondsToSelector:@selector(detailCell:moveWithInfo:)]) {
        NSLog(@"123456789");
        [_delegate detailCell:self moveWithInfo:_info];
   }
    
}
-(void)detail:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(detailCell:WithInfo:)]) {
        [_delegate detailCell:self WithInfo:_info];
    }
}
-(void)careIdentfData:(id)sender
{
    if (identView.hidden) {
        [self getIdentfireData];
         identView.hidden=!identView.hidden;
    }
    else
    {
    identView.hidden=!identView.hidden;    
    }
   
}
-(void)edite:(NSNotification *)notification
{
    cancelButton.hidden=NO;
}
-(void)editeDone:(NSNotification*)notification
{
    cancelButton.hidden=YES;
    
}
-(void)getIdentfireData
{
    NSString *strIdentifier;
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"UUID"]) {
        strIdentifier=[defaults objectForKey:@"UUID"];
    }
    else
    {
        strIdentifier = [Tools getUdid];
        [defaults setObject:strIdentifier forKey:@"UUID"];
        [defaults synchronize];
    }
    
    NSString*url1=[[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?yzmeventid=%@&yzmidentfier=%@",_info.idNumber,strIdentifier]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *newURL=[NSURL URLWithString
                   :url1];
    NSLog(@"%@",newURL);
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        [Tools showPrompt:@"获取验证码信息失败" inView:self.largeView delay:1.4];
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        NSLog(@"responseString%@",requst.responseString);
        if ([requst.responseString isEqualToString:@"0"]) {
            [Tools showPrompt:@"获取验证码失败" inView:self.largeView delay:1.4];
                   }
       else if ([requst.responseString length]>10) {
            [Tools showPrompt:@"获取验证码失败" inView:self.largeView delay:1.4];
        }
        else {
            identifData.text=requst.responseString;
            identifData.textColor=[UIColor blackColor];
        }
    }];


}
-(void)litleViewClicked:(UIButton*)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(detailCell:selectedInfo:)]) {
        [_delegate detailCell:self selectedInfo:_info];
        
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
        
        titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
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
        destanceImage=[[UIImageView alloc]initWithFrame:CGRectMake(110, 75, 15, 15)];
        destanceImage.image=[UIImage imageNamed:@"howlong.png"];
        [largeView addSubview:destanceImage];
        
        destanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 75, 45, 15)];
        [largeView addSubview:destanceLabel];
        destanceLabel.text=_request.responseString;
        destanceLabel.textColor=[UIColor whiteColor];
        destanceLabel.backgroundColor=[UIColor clearColor];
        destanceLabel.font=[UIFont systemFontOfSize:12];
        [destanceImage release];
        [destanceLabel release];
        //纪录状态
        [self handleDate];
  */
        //加上按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"验证码" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        [button setBackgroundImage:[UIImage imageNamed:@"joinButton.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(250, largeView.bounds.size.height-20, 60, 18);
        [button addTarget:self action:@selector(careIdentfData:) forControlEvents:UIControlEventTouchUpInside];
        [largeView addSubview:button];
        [self getDistance];
 
        //马上参加的button转变为删除按钮
        cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(248, largeView.bounds.size.height-20, 60, 18);
        [cancelButton setTitle:@"删除" forState:UIControlStateNormal];
        cancelButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.hidden=YES;
        [largeView addSubview:cancelButton];
      //有一个隐藏view显示验证码
       identView=[[UIView alloc]initWithFrame:CGRectMake(115, 100, 153, 60)];
        identView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ident.png"]];
        identView.hidden=YES;
        [largeView addSubview:identView];
        [identView release];
        //上面加上一个“验证码”和显示内容的label
        identfireTitle=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        identfireTitle.text=@"验证码:";
        identfireTitle.backgroundColor=[UIColor clearColor];
        identfireTitle.textColor=[UIColor blackColor];
        [identView addSubview:identfireTitle];
        [identfireTitle release];
        
        identifData=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, 140, 25)];
        identifData.backgroundColor=[UIColor clearColor];
        [identView addSubview:identifData];
        [identifData release];
        
        //注册通知把参与按钮变为删除按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(edite:) name:@"editData" object:nil];
        //注册通知把删除按钮变为参与按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editeDone:) name:@"editDoneData" object:nil];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
