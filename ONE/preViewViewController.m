//
//  preViewViewController.m
//  ONE
//
//  Created by dianji on 13-5-10.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "preViewViewController.h"
#import "ASIFormDataRequest.h"
@interface preViewViewController ()

@end

@implementation preViewViewController
@synthesize _titlle,_abstrct,_address,_image,_tel,_time;

-(void)backButtonClicked:(UIButton*)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
   
    
}

-(void)creatnavgation
{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]];
    //自定义的navbar
    UIView*navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    
    UIButton* backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    backButton.frame=CGRectMake(0, 8, 60,30);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UILabel*navtitle=[[UILabel alloc]initWithFrame:CGRectMake(100, 3, 200, 40)];
    navtitle.backgroundColor=[UIColor clearColor];
    navtitle.text=@"我的活动信息预览";
    navtitle.textColor=[UIColor whiteColor];
    navtitle.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [navView addSubview:navtitle];
    [navtitle release];

}
-(void)urlRequestFailed:(ASIHTTPRequest *)request
{
    NSError *error =[request error];
    NSLog(@"%@",error);
    NSLog(@"连接失败！");
    UIAlertView * alt=[[UIAlertView alloc] initWithTitle:@"提示" message:@"连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alt show];
    [alt release];
}

//请求成功
-(void)urlRequestSucceeded:(ASIHTTPRequest *)request
{
     [Tools showPrompt:@"已经提交到后台进行审核，请耐心等候" inView:self.view delay:0.32];
}
-(void)commitInfo
{
     
   UIImage* theImage = [Tools imageWithImageSimple:self._image scaledToSize:CGSizeMake(200.0, 300.0)];
   NSData *imageData = UIImageJPEGRepresentation(theImage, 0.8);
/*//存进本地
 NSString *temppath = [NSString stringWithFormat:@"%@/%@.png",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/updateImage"],@"56"];
    [imageData writeToFile:temppath atomically:YES];*/

//http://10.0.0.67:8028/pages/index.aspx?addevent=dd
//http://matrix.clickharbour.com/pages/index.aspx?addevent=dd
    
    NSString*url=@"http://matrix.clickharbour.com/pages/index.aspx?addevent=dd";
    ASIFormDataRequest *request= [ASIFormDataRequest requestWithURL: [NSURL URLWithString:url]];
   [request addData:imageData forKey:@"addpic"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self._titlle] forKey:@"addtitle"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self._time] forKey:@"addtime"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self._abstrct] forKey:@"addcontent"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self._address] forKey:@"address"];
    [request setPostValue:[NSString stringWithFormat:@"%@",self._tel] forKey:@"addtel"];
    [request setDelegate:self];
/*    //配置代理为本类
    [request setTimeOutSeconds:10];
    //设置超时
    [request setDidFailSelector:@selector(urlRequestFailed:)];
    [request setDidFinishSelector:@selector(urlRequestSucceeded:)];
    */
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        UIAlertView*alter=[[UIAlertView alloc]initWithTitle:nil message:@"已经提交到后台进行审核，请耐心等候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alter show];
        [alter release];
      
    
    }];
    [request setFailedBlock:^{
        NSLog(@"asi error: %@",request.error.debugDescription);
        [Tools showPrompt:@"上传超时，请点击上传按钮再试一次，谢谢你的配合" inView:self.view delay:0.5];
      
    }];
 
    [request buildRequestHeaders];
    [request startAsynchronous];
    NSLog(@"responseString = %@", request.responseString);


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //给上级controller发送广播
    NSString *bcastName = @"cleanData";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:bcastName object:self];
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)addSomeThingOnImageview1
{
    UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(10, 6+[Tools isIphone5]/8, 295, 20)];
    title.backgroundColor=[UIColor clearColor];
    title.text=self._titlle;
    title.font=[UIFont systemFontOfSize:12];
    title.textColor=[UIColor blackColor];
    [imageview1 addSubview:title];
    [title release];
    
    UILabel*time=[[UILabel alloc]initWithFrame:CGRectMake(10, 32+[Tools isIphone5]/7, 295, 15)];
    time.backgroundColor=[UIColor clearColor];
    time.font=[UIFont systemFontOfSize:12];
    time.text=self._time;
    time.textColor=[UIColor blackColor];
    [imageview1 addSubview:time];
    [time release];
    
    UILabel*address=[[UILabel alloc]initWithFrame:CGRectMake(10, 55+[Tools isIphone5]/4, 295, 20)];
    address.backgroundColor=[UIColor clearColor];
    address.font=[UIFont systemFontOfSize:12];
    address.text=self._address;
    address.textColor=[UIColor blackColor];
    [imageview1 addSubview:address];
    [address release];
    
    UILabel*tel=[[UILabel alloc]initWithFrame:CGRectMake(10, 80+[Tools isIphone5]/3, 295, 15)];
    tel.backgroundColor=[UIColor clearColor];
    tel.font=[UIFont systemFontOfSize:12];
    tel.text=self._tel;
    tel.textColor=[UIColor blackColor];
    [imageview1 addSubview:tel];
    [tel release];
    
    UILabel*abstract=[[UILabel alloc]initWithFrame:CGRectMake(10, 110+[Tools isIphone5]/2, 295, 150+[Tools isIphone5]/3)];
    abstract.backgroundColor=[UIColor clearColor];
    abstract.font=[UIFont systemFontOfSize:12];
    abstract.text=self._abstrct;
    abstract.numberOfLines=0;
    abstract.textColor=[UIColor blackColor];
    [imageview1 addSubview:abstract];
    [abstract release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self creatnavgation];
    
    UIImageView*imageview=[[UIImageView alloc]init];
    if (self._image) {
        imageview.image=self._image;
    }
    else {
        imageview.image=[UIImage imageNamed:@"noneImage.png"];
    }
    imageview.frame=CGRectMake(5, 44, self.view.bounds.size.width-10, 100);
    [self.view addSubview:imageview];
    [imageview release];
    
    imageview1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"previewImage.png"]];
    imageview1.frame=CGRectMake(5, 144, self.view.bounds.size.width-10, 270+[Tools isIphone5]);
    [self.view addSubview:imageview1];
    [imageview1 release];
    [self addSomeThingOnImageview1];
    
    
    UIButton*commentInfo=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentInfo setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [commentInfo setTitle:@"上传" forState:UIControlStateNormal];
    commentInfo.titleLabel.font=[UIFont systemFontOfSize:16];    commentInfo.frame=CGRectMake(120, 270+[Tools isIphone5]+144+5,70 , 40);
    [commentInfo addTarget:self action:@selector(commitInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
