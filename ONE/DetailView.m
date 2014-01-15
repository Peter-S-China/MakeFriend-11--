//
//  DetailView.m
//  ONE
//
//  Created by dianji on 12-12-13.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "DetailView.h"
#import "UIImageView+WebCache.h"
#import "AttentionViewController.h"
#import "DetailViewController.h"
#import "Tools.h"
@implementation DetailView
@synthesize _imageVIew;

- (void)dealloc
{
    RELEASE_SAFELY(_info);
    RELEASE_SAFELY(attentionImage);
    RELEASE_SAFELY(destanceLabel);
    RELEASE_SAFELY(destanceImage);
    _delegate = nil;
    [super dealloc];
}

#pragma mark - Customs Methods

//添加喜欢
- (void)addToFav:(id)sender
{
    //纪录是否包含
    BOOL content = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
    NSMutableArray*  joinedArray = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
    for (MessageInfo * joininfo in joinedArray) {
        if ([[joininfo.idNumber description] isEqualToString: [_info.idNumber description]] ) {
            content=YES;
            break;
        }
    }
    if (content) {
        
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"亲，你已参加就不用浪费流量咯" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alter.tag=1001;
            [alter show];
            [alter release];
        }
    else{
            UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"是否确定要关注" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alter.tag=1002;
            [alter show];
            [alter release];
            
        }
    }
    
//点击确定按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1002){
    if (buttonIndex==1) {
        if (_delegate && [_delegate respondsToSelector:@selector(detailView: addToFav:)]) {
            [_delegate detailView:self addToFav:_info];
       
        }
        
    }
    
    }
    
    if (alertView.tag==1010) {
        //填写信息
        if (buttonIndex==1) {
            if (_delegate && [_delegate respondsToSelector:@selector(detailView: joined:)]) {
                [_delegate detailView:self joined:_info];
                
            }
        }
        //拨打电话
    if (buttonIndex==2) {

        if (_delegate && [_delegate respondsToSelector:@selector(detailView:)]) {
            [_delegate detailView:self];
        }
        
    }
    
    }
else {
    return;
    
}

}


-(void)detail:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(detailView:detail:)]) {
        [_delegate detailView:self  detail:_info];
    }
}

-(void)join:(id)sender
{
    
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"选择拨打电话或填写信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"填写信息",@"拨打电话" ,nil];
    alter.tag=1010;
    [alter show];
    [alter release];
   
}
 
- (void)handleDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fm = [[[NSDateFormatter alloc] init] autorelease];
    [fm setDateFormat:@"yyyy年MM月dd日"];
    NSString *nowtime = [fm stringFromDate:now];
   
        if ([nowtime compare:_info.endTime] > 0) {
            //结束
            UIImageView*overView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 2, 60, 52)];
            overView.image=[UIImage imageNamed:@"over.png"];
            [self addSubview:overView];
            [overView release];
        }
        else if ([nowtime compare:_info.startTime] >= 0 && [nowtime compare:_info.endTime] <= 0) {
            //进行中
            UIImageView*goingView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 2, 60, 52)];
            goingView.image=[UIImage imageNamed:@"goingOn.png"];
            [self addSubview:goingView];
            [goingView release];
            
        }
        else {
            //还没开始
            UIImageView*willBeginView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 60, 2, 60, 52)];
            willBeginView.image=[UIImage imageNamed:@"will_began.png"];
            [self addSubview:willBeginView];
            [willBeginView release];
            
        }
    }

-(void)joined:(id)sender
{
    UIButton*button=(UIButton*)sender;
    //弹出一个提示筐
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"你已参加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
    [alter release]; 
    button.userInteractionEnabled=NO;
}
-(void)addToFaved:(id)sender
{
    UIButton*button=(UIButton*)sender;
    //弹出一个提示筐
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"你已关注" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
    [alter release];
    button.userInteractionEnabled=NO;

}
-(void)hindenView:(id)sender
{
    UIButton*hiddenButton=(UIButton*)sender;
    if (CGRectGetMinY(view.frame)<=275) {
        //影藏
        [hiddenButton setImage:[UIImage imageNamed: @"hiddenNo1.png" ]forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = view.frame;
            rect.origin.y =325;
            view.frame = rect;
            rect = hiddenButton.frame;
            rect.origin.y =250;
            hiddenButton.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    else {
        //出现
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = view.frame;
            rect.origin.y = 225;
            view.frame = rect;
            rect = hiddenButton.frame;
            rect.origin.y = 200;
            hiddenButton.frame = rect;
            [hiddenButton setImage:[UIImage imageNamed: @"hiddenYes1.png" ]forState:UIControlStateNormal];
            
        } completion:^(BOOL finished) {
            
        }];
    }


}
-(void)largeImageCliked:(UIButton*)button
{

    if (_delegate && [_delegate respondsToSelector:@selector(detailView:largeImageClicked:)]) {
        [_delegate detailView:self  largeImageClicked:_imageVIew];
    }

}
-(void)detailappear
{
    if (!_imageVIew.image) {
        //另一种转圈方式，加载中
        [Tools showSpinnerInView:self prompt:nil];
    
    
    [_imageVIew setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_info.detailPhotoURL]] success:^(UIImage *image) {
        [Tools hideSpinnerInView:self];
    } failure:^(NSError *error) {
        [Tools hideSpinnerInView:self];
        [Tools showPrompt:@"您当前的网络不给力" inView:self delay:1.4];
    }];
    }
}
#pragma mark - init
- (id)initWithFrame:(CGRect)frame messageInfo:(MessageInfo *)info delegate:(id)delegate_
{
    self = [super initWithFrame:frame];
    if (self) {
        _info = [info retain];
        _delegate = delegate_;
        //加上背景图片
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) )];
        backImage.image = [[UIImage imageNamed:@"imageBack.png"] stretchableImageWithLeftCapWidth:250 topCapHeight:250];
        [self addSubview:backImage];
        [backImage release];
        //海报图片
        _imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 10, CGRectGetHeight(frame)-16)];
   /*
        _indictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indictorView.center = _imageVIew.center;
        [_imageVIew addSubview:_indictorView];
        [_indictorView release];
        [_indictorView startAnimating];
     */
       [self addSubview:_imageVIew];
        
        //加一个透明button在海报图片上，点击进入详情
        UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, CGRectGetWidth(_imageVIew.frame), CGRectGetHeight(_imageVIew.frame)-78);
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
        _imageVIew.userInteractionEnabled=YES;
        [_imageVIew addSubview:button];
    
        //加一个看大图的按钮
        largeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [largeButton setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        largeButton.frame=CGRectMake(220, 235, 30, 30);
        [largeButton addTarget:self action:@selector(largeImageCliked:) forControlEvents:UIControlEventTouchUpInside];
         [button addSubview:largeButton];
       //添加状态
        [self handleDate];
        
        //半透明得view上面加上两个button
        view=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageVIew.frame)-78, CGRectGetWidth(frame)-10, 73)];
        view.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        [_imageVIew addSubview:view];
        
        //显示已关注三个字
        UILabel* label=[Tools createLabel:_info.attention frame:CGRectMake(60+40, CGRectGetMaxY(_imageVIew.frame)-40, 60, 30) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12] aliment:UITextAlignmentLeft];
        label.text=@"我要关注";
        label.backgroundColor=[UIColor clearColor];
        [self addSubview:label];
        
        addToFav = [UIButton buttonWithType:UIButtonTypeCustom];
        addToFav.frame = CGRectMake(40, CGRectGetMaxY(_imageVIew.frame)-65, 55, 55);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"ADD_MESSAGEINFO_TO_LOCAL"] == nil) {
            //表示在本地没有
           [addToFav setBackgroundImage:[UIImage imageNamed:@"attentionNorm.png"] forState:UIControlStateNormal];
            [addToFav setBackgroundImage:[UIImage imageNamed:@"attentionClicked.png"] forState:UIControlStateHighlighted];
            [addToFav addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
        
        }
        else {//表示找到了数组。然后看看数组里面有没有，防止重复添加
            NSData *data = [defaults objectForKey:@"ADD_MESSAGEINFO_TO_LOCAL"];
            NSMutableArray *infos = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
            BOOL isExit = NO;
            for (MessageInfo *sinfo in infos) {
                if ([sinfo.buttonTitle isEqualToString:info.buttonTitle]) {//有重复的

                    [addToFav setBackgroundImage:[UIImage imageNamed:@"attentined.png"] forState:UIControlStateNormal];
                    label.text=@"已关注";
                    isExit=YES;
                    [addToFav addTarget:self action:@selector(addToFaved:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }
            if (!isExit) {//如果不存在重复的才添加进数组
               
                [addToFav setBackgroundImage:[UIImage imageNamed:@"attentionNorm.png"] forState:UIControlStateNormal];
                [addToFav addTarget:self action:@selector(addToFav:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        [addToFav setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addToFav setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        
        [self addSubview:addToFav];
//label显示关注人数
        attentionLabel=[Tools createLabel:_info.attention frame:CGRectMake(60+43, CGRectGetMaxY(_imageVIew.frame)-60, 40, 25) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] aliment:UITextAlignmentLeft];
        attentionLabel.text=_info.attention;
        attentionLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:attentionLabel];
 
        
        //显示已参与三个字
        UILabel* label1=[Tools createLabel:_info.attention frame:CGRectMake(150+60, CGRectGetMaxY(_imageVIew.frame)-40, 60, 30) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12] aliment:UITextAlignmentLeft];
        label1.text=@"我要参与";
        label1.backgroundColor=[UIColor clearColor];
        [self addSubview:label1];
        
        join = [UIButton buttonWithType:UIButtonTypeCustom];
        join.frame = CGRectMake(150, CGRectGetMaxY(_imageVIew.frame)-65, 55, 55);
        NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
        if ([defaults1 objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"] == nil) {//表示在本地没有
            [join setBackgroundImage:[UIImage imageNamed:@"joinedNorm.png"] forState:UIControlStateNormal];
            [join setBackgroundImage:[UIImage imageNamed:@"joinedClicked.png"] forState:UIControlStateHighlighted];
            [join addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else {//表示找到了数组。然后看看数组里面有没有，防止重复添加
            NSData *data = [defaults objectForKey:@"JOIN_MESSAGEINFO_TO_LOCAL"];
            NSMutableArray *infos = [[[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]] autorelease];
            BOOL isExit = NO;
            for (MessageInfo *sinfo in infos) {
                if ([sinfo.buttonTitle isEqualToString:info.buttonTitle]) {//有重复的
 //                   addToFav.userInteractionEnabled=NO;
                    
                    [join addTarget:self action:@selector(joined:) forControlEvents:UIControlEventTouchUpInside];
                    [join setBackgroundImage:[UIImage imageNamed:@"joinedButton.png"] forState:UIControlStateNormal];
                    label1.text=@"已参与";                    
                    isExit=YES;
               
                    
                    
                }
            }
            if (!isExit) {//如果不存在重复的才添加进数组
                [join setBackgroundImage:[UIImage imageNamed:@"joinedNorm.png"] forState:UIControlStateNormal];
                 [join addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];                
            }

        }
        [join setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [join setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
       
        [self addSubview:join];
        //label显示关注人数
        joinedLabel1=[Tools createLabel:_info.attention frame:CGRectMake(150+65, CGRectGetMaxY(_imageVIew.frame)-60, 40, 25) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16] aliment:UITextAlignmentLeft];
        joinedLabel1.text=_info.joinedNumber;
        joinedLabel1.backgroundColor=[UIColor clearColor];
        [self addSubview:joinedLabel1];
       
           
    }
    return self;
}


@end
