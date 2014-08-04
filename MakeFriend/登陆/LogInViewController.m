//
//  LogInViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "LogInViewController.h"
#import "NumberAndCodeViewController.h"
#import "LoginNextViewController.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "LoginModel.h"
#import "UIButton+WebCache.h"
@interface LogInViewController ()

@end

@implementation LogInViewController
-(void)registButtonClicked:(UIButton*)sender
{
    NumberAndCodeViewController*nacc=[[NumberAndCodeViewController alloc]init];
    [self.navigationController pushViewController:nacc animated:YES];
    [nacc release];

}
-(void)loginClicked:(UIButton*)sender
{

    LoginNextViewController*nacc=[[LoginNextViewController alloc]init];
    [self.navigationController pushViewController:nacc animated:YES];
    [nacc release];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)parseFourImageInfo
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://218.246.35.203:8011/pages/json.aspx?load_first='dd'"]];
    [request startAsynchronous];
    
    [request setFailedBlock:^{
        NSLog(@"request info failed");
    }];
    
    [request setCompletionBlock:^{
        __autoreleasing NSError *error = nil;
        CJSONDeserializer *deseri = [CJSONDeserializer deserializer];
        deseri.nullObject = @"";
 //       NSString*date=[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];

        NSArray *momentArray = [deseri deserializeAsArray:request.responseData error:&error];
//        NSLog(@"momentArray = %@",momentArray);
        if ([momentArray isKindOfClass:[NSArray class]] && [momentArray count] > 0) {
            loginArray=[[NSMutableArray alloc]initWithCapacity:0];
            for (NSDictionary *dic in momentArray) {
                LoginModel *info = [[LoginModel alloc] init];
                info.userID = [dic objectForKey:@"user_id"];
                info.userName = [dic objectForKey:@"user_name"];
                info.userImageURL = [dic objectForKey:@"p_route1"];
                info.usernickName = [dic objectForKey:@"user_nickname"];
               
                [loginArray addObject:info];
 //               NSLog(@"url = %@",info.userImageURL);
            }
            [self creatFourBUtton:loginArray];
        }
    }];
   

}
-(void)creatFourBUtton:(NSArray*)infoArray
{
    //加四个view显示热门的
    for (int i=0; i<[loginArray count]; i++) {
        LoginModel *info=[loginArray objectAtIndex:i];
        UIButton*button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(5+i*78, 20, 75, 75);
        [button setImageWithURL:[NSURL URLWithString:info.userImageURL] success:^(UIImage*image){
           
        } failure:^(NSError *error) {
                      
        }];
        [loginView addSubview:button];
        UILabel*userName=[[UILabel alloc]initWithFrame:CGRectMake(15+i*80, 100, 50, 25)];
        userName.text=info.usernickName;
        userName.font=[UIFont fontWithName:@"Thonburi-Bold" size:14];
        userName.backgroundColor=[UIColor clearColor];
        userName.textColor=[UIColor whiteColor];
        [loginView addSubview:userName];
        [userName release];
        
    }
    


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseFourImageInfo];
    if ([Tools isIphone5]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login5.png"]];
    }
    else
    {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]];
    }
    
  //创建半透明view
   loginView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-190, self.view.bounds.size.width, 190)];
    loginView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:loginView];
    [loginView release];
      // 创建登陆注册按钮
    UIButton*loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setImage:[UIImage imageNamed:@"loginButton.png"] forState:UIControlStateNormal];
    loginButton.frame=CGRectMake(30, 140, 110, 37);
    [loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginButton];
    
    UIButton*registButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [registButton setImage:[UIImage imageNamed:@"registButton.png"] forState:UIControlStateNormal];
     [registButton addTarget:self action:@selector(registButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    registButton.frame=CGRectMake(170, 140, 110, 37);
    [loginView addSubview:registButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
