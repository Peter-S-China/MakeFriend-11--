//
//  TakeMessageViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "TakeMessageViewController.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "LoginNextViewController.h"
@interface TakeMessageViewController ()
{
    //在线用户
    NSMutableArray *onlineUsers;
    
    NSString *chatUserName;
    
}

@end

@implementation TakeMessageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    
    onlineUsers = [NSMutableArray array];
    
    //设定在线用户委托
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    [self.navigationController setNavigationBarHidden:YES];
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
    //加上排序和删除
    sortBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [sortBut setImage:[UIImage imageNamed:@"sortBut.png"] forState:UIControlStateNormal];
    [sortBut addTarget:self action:@selector(wrongButton1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    sortBut.frame=CGRectMake(10, 10, 30, 27);
    [navView addSubview:sortBut];
    
    removeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [removeBut setImage:[UIImage imageNamed:@"removeBut.png"] forState:UIControlStateNormal];
    [removeBut addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    removeBut.frame=CGRectMake(self.view.bounds.size.width-30, 13, 20, 16);
    [navView addSubview:removeBut];
    

    
   }

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    if (login) {
        
        if ([[self appDelegate] connect]) {
            NSLog(@"show buddy list");
            
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置账号" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self Account:self];
        //        [self toChat];
    }
    
    
}

- (void)viewDidUnload
{
    [self setTView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)Account:(id)sender {//跳转到登陆页面
    
//    [self performSegueWithIdentifier:@"login" sender:self];
 /*   LoginNextViewController *lgc=[[LoginNextViewController alloc]init];
    [self.navigationController pushViewController:lgc animated:NO];
    [lgc release];*/
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [onlineUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //文本
    cell.textLabel.text = [onlineUsers objectAtIndex:[indexPath row]];
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //start a Chat,把要对话的名字发给后台，跳转到chat页面
    chatUserName = (NSString *)[onlineUsers objectAtIndex:indexPath.row];
    ChatViewController *cvc=[[ChatViewController alloc]init];
    [self.navigationController pushViewController:cvc animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [cvc release];
    
 //   [self performSegueWithIdentifier:@"chat" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"chat"]) {
        
        ChatViewController *chatController = segue.destinationViewController;
        
        chatController.chatWithUser = chatUserName;
    }
}

//取得当前程序的委托
-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    
    if (![onlineUsers containsObject:buddyName]) {
        [onlineUsers addObject:buddyName];
        [self.tView reloadData];
    }
    
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    
    [onlineUsers removeObject:buddyName];
    [self.tView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
