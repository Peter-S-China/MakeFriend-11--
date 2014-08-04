//
//  ChatViewController.m
//  MakeFriend
//
//  Created by dianji on 13-9-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "ChatViewController.h"
#import "AppDelegate.h"
#import "Statics.h"
#import "KKMessageCell.h"

#define padding 20

@interface ChatViewController ()
{
    NSMutableArray *messages;
}
@end

@implementation ChatViewController
@synthesize chatWithUser;
@synthesize tView;
@synthesize messageTextField;

//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)sendButtonCliked:(UIButton *)sender
{
    
    //本地输入框中的信息
    NSString *message = self.messageTextField.text;
    NSLog(@"%@",message);
    if (message.length > 0) {
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:chatWithUser];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        //组合
        [mes addChild:body];
        
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.messageTextField.text = @"";
        [self.messageTextField resignFirstResponder];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setObject:message forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        [dictionary setObject:[Statics getCurrentTime] forKey:@"time"];
        
        [messages addObject:dictionary];
        
        //重新刷新tableView
        [self.tView reloadData];
        
    }



}
//布置textField，sendBut，tableView；
-(void)creatChatView
{
    messageTextField=[[UITextField alloc]initWithFrame:CGRectMake(15, 53, 213, 31)];
    messageTextField.delegate=self;
    messageTextField.font=[UIFont systemFontOfSize:17];
    messageTextField.borderStyle=UITextBorderStyleRoundedRect;
    messageTextField.textColor=[UIColor blackColor];
    messageTextField.textAlignment=NSTextAlignmentLeft;
    [messageTextField becomeFirstResponder];
    [self.view addSubview:messageTextField];
    [messageTextField release];
    
    UIButton *sendBut=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBut.frame=CGRectMake(236, 49, 72, 35);
    [sendBut setTitle:@"send" forState:UIControlStateNormal];
    sendBut.titleLabel.font=[UIFont fontWithName:@"System Bold" size:15];
    [sendBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendBut addTarget:self action:@selector(sendButtonCliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBut];
    
    tView=[[UITableView alloc]initWithFrame:CGRectMake(0, 92, 320, 369) style:UITableViewStylePlain];
    tView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tView.dataSource=self;
    tView.delegate=self;
    [self.view addSubview:tView];
    [tView release];
    

}
-(void)closeButClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    if ([Tools isIphone5]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView5.png"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView.png"]];
    }
    //自定义导航条
    UIView*navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    //加上close按钮
    
    UIButton *closeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeBut setImage:[UIImage imageNamed:@"sortBut.png"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(closeButClicked:) forControlEvents:UIControlEventTouchUpInside];
    closeBut.frame=CGRectMake(10, 10, 30, 27);
    [navView addSubview:closeBut];
     messages = [NSMutableArray array];
    
    [self creatChatView];
    AppDelegate *del = [self appDelegate];
    del.messageDelegate = self;
    
}
- (void)viewDidUnload
{
    [self setTView:nil];
    [self setMessageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}
#pragma mark--TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"msgCell";
    
    KKMessageCell *cell =(KKMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[KKMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    
    //发送者
    NSString *sender = [dict objectForKey:@"sender"];
    //消息
    NSString *message = [dict objectForKey:@"msg"];
    //时间
    NSString *time = [dict objectForKey:@"time"];
    
    CGSize textSize = {260.0 ,10000.0};
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.width +=(padding/2);
    
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    UIImage *bgImage = nil;
    
    //发送消息
    if ([sender isEqualToString:@"you"]) {
        //背景图
        bgImage = [[UIImage imageNamed:@"BlueBubble2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width+100, size.height)];
        
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2, size.width + padding, size.height + padding)];
    }else {
        
        bgImage = [[UIImage imageNamed:@"GreenBubble2.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
        
        [cell.messageContentView setFrame:CGRectMake(320-size.width - padding, padding*2, size.width+100, size.height)];
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2, size.width + padding, size.height + padding)];
    }
    
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    
    return cell;
    
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict  = [messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];
    
    CGSize textSize = {260.0 , 10000.0};
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.height += padding*2;
    
    CGFloat height = size.height < 65 ? 65 : size.height;
    
    return height;
    
}

#pragma mark--UITextfieldDelgate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
#pragma mark KKMessageDelegate
-(void)newMessageReceived:(NSDictionary *)messageCotent{
    
    [messages addObject:messageCotent];
    
    
    [self.tView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
