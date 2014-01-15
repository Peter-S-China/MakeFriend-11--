//
//  LoginViewController.m
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "LoginViewController.h"
#import "MyTableBarController.h"

@implementation LoginViewController
@synthesize myTableView,wihteButton;
#pragma mark Customs Methdes
//点击事件
- (void)sureTologin:(id)sender
{
    [self.navigationController pushViewController:[MyTableBarController sharedTabBarController] animated:YES];
}

#pragma mark init
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor=[UIColor colorWithRed:238.12/255 green:137.77/255 blue:0 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"聚吧登录";
    
    //创建登陆页面
    myTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //设置tableview的背景颜色，ios6只能这么设定
    UIView *view = [[UIView alloc] initWithFrame:myTableView.frame];
    view.backgroundColor = [UIColor colorWithRed:0.89 green:0.6 blue:0.78 alpha:0.9];
    myTableView.backgroundView = view;
    [view release];
    
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    [myTableView release];
    

    //创建一个按钮，然后就是点击登录
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 200, 300, 50);
    [button setTitle:@"登录" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(sureTologin:) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:button];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //影藏自己的navagationBar
    self.navigationController.navigationBar.hidden = YES;
}
//tableview的必须实现的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else {
        return 1;
    }
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;

}
-(void)buttonPressed
{
    static int count=0;
    count++;
    if (count%2==1) {
        [wihteButton setBackgroundImage:[UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateNormal];
    }else{
    [wihteButton setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];    
    }


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*id=@"id";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:id];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:id] autorelease];
    }
    cell.backgroundColor=[UIColor colorWithRed:0.86 green:0.48 blue:0.46 alpha:0.8];
  //设置用户名和密码是lable，后面是textfield
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
            nameLabel.text=@"用户名";
            nameLabel.font=[UIFont systemFontOfSize:18];
            //设置字的颜色
            nameLabel.textColor=[UIColor colorWithRed:235.12/225 green:237.77/255 blue:115.5/255 alpha:1];
            nameLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:nameLabel];
            [nameLabel release];
            //设置可填写框textfield
            UITextField*nameText=[[UITextField alloc]initWithFrame:CGRectMake(100, 10, 150, 30)];
            nameText.backgroundColor=[UIColor clearColor];
            nameText.delegate=self;
            //对齐
            nameText.textAlignment=0;
            [cell.contentView addSubview:nameText];}
          //第二行
            if (indexPath.row==1) {
                UILabel*passWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
                passWordLabel.text=@"密码";
                passWordLabel.font=[UIFont systemFontOfSize:18];
                //设置字的颜色
                passWordLabel.textColor=[UIColor colorWithRed:235.12/225 green:237.77/225 blue:115.5/225 alpha:1];
                passWordLabel.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:passWordLabel];
                [passWordLabel release];
                //设置可填写框textfield
                UITextField*passWordText=[[UITextField alloc]initWithFrame:CGRectMake(100, 10, 150, 30)];
                passWordText.backgroundColor=[UIColor clearColor];
                passWordText.delegate=self;
                //对齐
                passWordText.textAlignment=0;
                [cell.contentView addSubview:passWordText];
            }
    }
    //是否记住密码项
        if (indexPath.section==1) {
            UILabel*remberWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 30)];
            remberWordLabel.text=@"是否记住密码";
            remberWordLabel.font=[UIFont systemFontOfSize:18];
            //设置字的颜色
            remberWordLabel.textColor=[UIColor colorWithRed:235.12/225 green:237.77/255 blue:115.5/255 alpha:1];
            remberWordLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:remberWordLabel];
            [remberWordLabel release];
       //打钩的选项,是由2个图片组成的
           wihteButton=[[UIButton alloc]initWithFrame:CGRectMake(170, 15, 20, 20)];
            [wihteButton setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
            wihteButton.backgroundColor=[UIColor whiteColor];
            [wihteButton addTarget:self action:@selector(buttonPressed) forControlEvents: UIControlEventTouchUpInside];
        [cell.contentView addSubview:wihteButton];
            [wihteButton release];
   
    
    }
   
    return cell;
}
//当敲打回车键时，开始搜索并收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    [textField resignFirstResponder];
   
    return YES;
}



@end
