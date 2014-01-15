//
//  ButtonDetailViewController.m
//  ONE
//
//  Created by dianji on 12-12-17.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "ButtonDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "Tools.h"
#import "SBJson.h"
#import "Comment.h"
#import "CommentViewController.h"
#define useAppkey @"50ee1376527015619400000c"

@interface ButtonDetailViewController ()

@end

@implementation ButtonDetailViewController

@synthesize _info;
@synthesize delegate=_delegate;
-(void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//点击查看评论
-(void)commitButtonClicked:(id)sender
{
    if ([_commentArray count]>0) {
        CommentViewController *cvc = [[CommentViewController alloc] initWithInfo:_info comments:_commentArray];
        [self.navigationController pushViewController:cvc animated:YES];
        [cvc release];
    }
    else
    {
        [Tools showPrompt:@"没有评论信息，赶快评论吧" inView:self.view delay:0.7];
    
    }
    
}

-(void)getConmment
{
    NSString*url1=[[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?comeventid=%@&comcount=%i&comstartnum=%i",_info.idNumber,20,0]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSURL *newURL=[NSURL URLWithString:url1];
    NSLog(@"%@",newURL);
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        [Tools showPrompt:@"获取评论信息失败" inView:self.navigationController.view delay:1.4];
        [careButton1 setTitle:@"0条" forState:UIControlStateNormal];
        
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        
        if ([requst.responseString isEqualToString:@"暂时没有该活动的评论内容"]) {
            [Tools showPrompt:@"暂时没有该活动的评论内容" inView:self.navigationController.view delay:1.4];
            [careButton1 setTitle:@"0条" forState:UIControlStateNormal];
            commentTableView.frame=CGRectMake(0, 130+size.height + 20+30, 320, 50);
            
        }
        else{
        [Tools showPrompt:@"获取评论信息成功" inView:self.navigationController.view delay:1.4];
            //解析数据
           SBJsonParser*sbjs=[[[SBJsonParser alloc]init]autorelease];  
            NSString*date=[[NSString alloc]initWithData:[requst responseData] encoding:NSUTF8StringEncoding];
            
            NSError *error = nil;
            NSArray *array = [sbjs objectWithString:date error:&error];
            [date release];
          
            _commentArray=[[NSMutableArray alloc]initWithCapacity:10];            
          
            if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
                for(NSDictionary *dic in array) {
                Comment*commetInfo=[[Comment alloc]init];
                //时间
                   NSString*time =[dic objectForKey:@"addtime"];
                    NSRange range = NSMakeRange(6, 10);
                    time = [time substringWithRange:range];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
                    NSLog(@"time%@",time);
                    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
                    [fm setDateFormat:@"yyyy-MM-dd"];
                    commetInfo.commentTime=[fm stringFromDate:date];
                    [fm release];
                //评论人的名字
                    commetInfo.userName=[dic objectForKey:@"name"];
                //评论事件id
                    commetInfo.eventId=[dic objectForKey:@"eventid"];
                //评论内容
                    commetInfo.contents=[dic objectForKey:@"contents"];
                    [_commentArray addObject:commetInfo];
                   [careButton1 setTitle:[NSString stringWithFormat:@"%i条",[_commentArray count]] forState:UIControlStateNormal];
                    [commetInfo release];
                }
            }
            
        }
    }];
}

-(void)sharedClicked:(UIButton*)sender
{
   
    _snsActionSheet=[[UIActionSheet alloc]initWithTitle:@"这个活动不错额，来分享给身边的朋友一起参与吧" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信分享" otherButtonTitles:@"短信分享",nil];
    _snsActionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    _snsActionSheet.tag=900;
    [_snsActionSheet showInView:self.view];
    [_snsActionSheet release];
    
   
}

#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==900) {
        //首先找到图片
        UIImageView *imageview = [[[UIImageView alloc] init] autorelease];
        [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_info.photoURL]] placeholderImage:[UIImage imageNamed:@"aefjfjhh.png"]];//要是没有图片就给一张默认的图片
        NSData *imageData = UIImageJPEGRepresentation(imageview.image, 0.8);
        
        if (buttonIndex==0) {//微信分享
            if ([WXApi isWXAppInstalled]) {
                //发送内容给微信
                WXMediaMessage *message = [WXMediaMessage message];
                [message setThumbImage:imageview.image];
                
                WXImageObject *ext = [WXImageObject object];
                
                ext.imageData = imageData ;
                
                message.mediaObject = ext;
                
                SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
                req.bText = NO;
                req.message = message;
                req.scene = WXSceneTimeline;//分享至朋友圈
                
                [WXApi sendReq:req];
            }
            
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，你还没有安装微信额，是否立即安装？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                alertView.tag = 1006;
                [alertView show];
                [alertView release];
            }
        }
        if (buttonIndex==1) {//短信分享
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://13223345678"]];    
            }
            
            else
                
            {
                
                [Tools showPrompt:@"本机器不支持短信分享功能" inView:self.view delay:0.4];
                
            }
                      
        }
    }
    if (actionSheet.tag==901) {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_info.tel]];
        }
        
        if (buttonIndex == actionSheet.cancelButtonIndex)
        {
            return;
        }
    }

}

    
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

}
-(void)storeImage
{
    NSArray*array=[_info.photoURL componentsSeparatedByString:@"/"];
    NSString*photoName=[array lastObject];
    UIImageView*imageview=[[UIImageView alloc]init];
    NSURL*url=[NSURL URLWithString:_info.photoURL];
    [imageview setImageWithURL:url];
    //存进本地以自身的后缀命名
    [UIImagePNGRepresentation(imageview.image)writeToFile:[NSHomeDirectory()stringByAppendingPathComponent:photoName] atomically:YES];
    [imageview release];

}
-(void)telButtonClicked:(UIButton*)sender
{
    
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:@"拨打电话咨询" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"%@",_info.tel] otherButtonTitles:nil,nil];
    action.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    action.tag=901;
    [action showInView:self.view];
    [action release];
}
-(void)cancelButton
{
    [commenttextView resignFirstResponder];
    commenttextView.userInteractionEnabled=YES;
    careConment.frame=CGRectMake(0, 376+[Tools isIphone5], 320, 40);
    
}
-(void)chooseDone
{
    [commenttextView resignFirstResponder];
    commenttextView.userInteractionEnabled=YES;
    careConment.frame=CGRectMake(0, 376+[Tools isIphone5], 320, 40);
    
}
-(void)sendComment:(id)sender
{
    [Tools showSpinnerInView:self.navigationController.view prompt:@"发送中..."];
    //测试设备号
    NSString *strIdentifier;
    NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"UUID"]) {//如果没有，就创建并储存
        strIdentifier = [Tools getUdid];
        [defaults setObject:strIdentifier forKey:@"UUID"];
        [defaults synchronize];
    }
    else
    {
        strIdentifier=[defaults objectForKey:@"UUID"];
    }
    
    NSString*url1=[[NSString stringWithFormat:@"http://matrix.clickharbour.com/pages/index.aspx?comidentfier=%@&comeventid=%@&contents=%@",strIdentifier,_info.idNumber,commenttextView.text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSURL *newURL=[NSURL URLWithString:url1];
    
    ASIHTTPRequest*requst=[ASIHTTPRequest requestWithURL:newURL];
    //启动异步下载
    [requst startAsynchronous];
    [requst setFailedBlock:^(void){
        
        [Tools showPrompt:@"发送失败" inView:self.navigationController.view delay:1.4];
        [Tools hideSpinnerInView:self.navigationController.view];
        
    }];
    //请求数据成功
    [requst setCompletionBlock:^(void){
        
        [Tools showPrompt:@"发送成功" inView:self.navigationController.view delay:1.4];
        [Tools hideSpinnerInView:self.navigationController.view];
        NSLog(@"发送评论%@",requst.responseString);
        commenttextView.text=@"说点什么...";
        [commenttextView resignFirstResponder];
        commenttextView.userInteractionEnabled=YES;
        careConment.frame=CGRectMake(0, 376+[Tools isIphone5], 320, 40);
    }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getConmment];
    [self storeImage];
    UIImageView*backgroundimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1.png"]];
    backgroundimage.frame=self.view.bounds;
    [self.view addSubview:backgroundimage];
    [backgroundimage release];
  
    //背后加上一个scoreview
     size=[[NSString stringWithFormat:@"%@",_info.abstract] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(255, 600) ];
    scoll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 460-44+[Tools isIphone5])];
    scoll.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]];

	[self.view addSubview:scoll];
    

        
    //添加上标签
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 100, 40)];
    title.text=self._info.buttonTitle;
    title.font=[UIFont systemFontOfSize:22];
    title.backgroundColor=[UIColor clearColor];
    self.navigationItem.title=title.text;
    [title release];
    //评论按钮放最上面
    //微信分享按钮

    right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setBackgroundImage:[UIImage imageNamed:@"editeNorm.png"] forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 8, 50,30);
    [right setTitle:@"分享" forState:UIControlStateNormal];
    [right setTitle:@"分享" forState:UIControlStateHighlighted];
    right.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [right addTarget:self action:@selector(sharedClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:right];
    
    self.navigationItem.rightBarButtonItem = item;
    [item autorelease];
    
    
    //添加上返回按钮
    
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 8, 60,30);
    [left setTitle:@"返回" forState:UIControlStateNormal];
    [left setTitle:@"返回" forState:UIControlStateHighlighted];
    left.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
   
    //联系方式
    UIButton*telButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [telButton setBackgroundImage:[UIImage imageNamed:@"tellButton.png"] forState:UIControlStateNormal];
    telButton.frame=CGRectMake(10, 15, 300, 35);
    [telButton addTarget:self action:@selector(telButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scoll addSubview:telButton];
   
   
    UILabel*telLabel=[Tools createLabel:[NSString stringWithFormat:@"咨询电话:"] frame:CGRectMake(4, 0,80, 30) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] aliment:UITextAlignmentLeft];
    [telButton addSubview:telLabel];
    
    UILabel*tellabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 3, 150, 25)];
    tellabel.text=_info.tel;
    tellabel.font=[UIFont systemFontOfSize:16];
    tellabel.backgroundColor=[UIColor clearColor];
    tellabel.textColor=[UIColor whiteColor];
    tellabel.textAlignment=NSTextAlignmentLeft;
    [telButton addSubview:tellabel];
    [tellabel release];
    
    //起始时间
    UILabel*time=[Tools createLabel:[NSString stringWithFormat:@"时间:"] frame:CGRectMake(10, 65,50, 25) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] aliment:UITextAlignmentLeft];
    [scoll addSubview:time];
      CGSize timeSize=[[NSString stringWithFormat:@"%@ - %@",_info.startTime,_info.endTime] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 100)];
    UILabel*timeLabel=[Tools createLabel:[NSString stringWithFormat:@"%@ - %@",_info.startTime,_info.endTime] frame:CGRectMake(60, 70, 260, timeSize.height) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] aliment:UITextAlignmentLeft];
    timeLabel.numberOfLines=0;
    [scoll addSubview:timeLabel];
    //地点
    
    UILabel*dest=[Tools createLabel:[NSString stringWithFormat:@"地点:"] frame:CGRectMake(10, 80+timeSize.height,50, 25) color:[UIColor whiteColor] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] aliment:UITextAlignmentLeft];
    [scoll addSubview:dest];
    
    CGSize destSize=[_info.dest sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 100)];
    
    UILabel*destText=[[UILabel alloc]initWithFrame:CGRectMake(55, 82+timeSize.height, 255,destSize.height)];
    destText.text=_info.dest;
    destText.font=[UIFont systemFontOfSize:14];
    destText.backgroundColor=[UIColor clearColor];
    destText.textColor=[UIColor whiteColor];
    destText.textAlignment=UITextAlignmentLeft;
    destText.numberOfLines=0;
    [scoll addSubview:destText];
    [destText release];
      //摘要
    UILabel*abstract=[Tools createLabel:[NSString stringWithFormat:@"摘要:"] frame:CGRectMake(10, 80+destSize.height+timeSize.height+30,50, 25) color:[UIColor whiteColor ] font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18] aliment:UITextAlignmentLeft];
    [scoll addSubview:abstract];
    
    UILabel*abstractLabel=[Tools createLabel:[NSString stringWithFormat:@"%@",_info.abstract] frame:CGRectMake(60, 80+destSize.height+timeSize.height+30+5, 255,size.height) color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] aliment:UITextAlignmentLeft];
    abstractLabel.numberOfLines=0;
    
    [scoll addSubview:abstractLabel];
   
    scoll.contentSize=CGSizeMake(320, CGRectGetMaxY(abstractLabel.frame)+40);
//加一个悬浮查看评论
       
   careConment=[UIButton buttonWithType:UIButtonTypeCustom];
    [careConment setBackgroundImage:[UIImage imageNamed:@"careButton.png"] forState:UIControlStateNormal];
    careConment.frame=CGRectMake(0, 376+[Tools isIphone5], 320, 40);
    careConment.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [careConment addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:careConment];
   
    commenttextView=[[UITextView alloc]initWithFrame:CGRectMake(4, 4, 200, 32)];
    commenttextView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    commenttextView.font=[UIFont systemFontOfSize:18];
    commenttextView.textColor=[UIColor grayColor];
    //自定义键盘
    
    UIToolbar *keybordBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0, 320, 44)];
    keybordBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButton)];
    UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleDone target:self action:@selector(chooseDone)];
    keybordBar.items = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,hiddenButtonItem, nil];
    [spaceButtonItem release];
    [cancelButtonItem release];
    [hiddenButtonItem release];
    
    commenttextView.inputAccessoryView=keybordBar;
    [keybordBar release];
    commenttextView.text=@"说点什么...";
    commenttextView.delegate=self;
    [careConment addSubview:commenttextView];
    [commenttextView release];
 //有两个按钮，发表和查看
    //添加发送按钮
    UIButton *sendButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton1.frame=CGRectMake(210, 5, 50, 30);
    [sendButton1 addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton1 setBackgroundImage:[UIImage imageNamed:@"gray_button1.png"] forState:UIControlStateNormal];
    [sendButton1 setTitle:@"发送" forState:UIControlStateNormal];
    [careConment addSubview:sendButton1];

   careButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    careButton1.frame=CGRectMake(265, 5, 50, 30);
    [careButton1 addTarget:self action:@selector(commitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [careButton1 setTitle:@"0条" forState:UIControlStateNormal];
    [careButton1 setBackgroundImage:[UIImage imageNamed:@"gray_button1.png"] forState:UIControlStateNormal];
    
    [careConment addSubview:careButton1];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 微信Delegate
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}
#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    commenttextView.text=@"";
    if (CGRectGetMaxY(careConment.frame) > 0){
//          if (keyboardBounds.size.height==252) {//处于汉文输入状态
//              [UIView animateWithDuration:0.1 animations:^{
//                  CGRect rect = careConment.frame;
//                  rect.origin.y -=263+36;
//                  careConment.frame = rect;
//                  
//              }
//            completion:^(BOOL finished) {
//                               }];
//              }
//          else{
            [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = careConment.frame;
            rect.origin.y -=263;
            careConment.frame = rect;
            
            }
        completion:^(BOOL finished) {
        }];
    }
  
    
}


@end
