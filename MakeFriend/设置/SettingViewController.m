//
//  SettingViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "SettingViewController.h"
#import "EditPersonInfoViewController.h"
#import "CJSONDeserializer.h"
#import "AllWishsViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController
//获取个人基本信息
-(void)loadDataByUserName
{
    NSUserDefaults *defaut=[NSUserDefaults standardUserDefaults];
    NSString *userName=[defaut objectForKey:@"PHONE_NUMBER"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?load_users='dd'&username=%@",userName]]];
    [request startAsynchronous];
    NSLog(@"http://218.246.35.203:8011/pages/json.aspx?load_users='dd'&username=%@",userName);
    [request setFailedBlock:^{
        NSLog(@"request info failed");
    }];
    
    [request setCompletionBlock:^{
        __autoreleasing NSError *error = nil;
        CJSONDeserializer *deseri = [CJSONDeserializer deserializer];
        deseri.nullObject = @"";
        NSArray *momentArray = [deseri deserializeAsArray:request.responseData error:&error];
        NSLog(@"momentArray = %@",momentArray);
        
        if ([momentArray isKindOfClass:[NSArray class]] && [momentArray count] > 0) {
            for (NSDictionary *dic in momentArray) {
                PhotoInfo*info=[[PhotoInfo alloc]init];
                info.userRegestName=userName;
                info.userName = [dic objectForKey:@"user_nickname"];
                info.useraLitleImageURL=[dic objectForKey:@"user_picid"];
                info.userBirth=[dic objectForKey:@"user_birth"];
                info.userSex=[dic objectForKey:@"user_sex"];
                info.userSignature=[dic objectForKey:@"user_defwish"];
                info.userAddress=[dic objectForKey:@"user_address"];
                [_personInfoArray addObject:info];
            }
            PhotoInfo*personInfo=[_personInfoArray lastObject];
            NSLog(@"personInfo.useraLitleImageURL:%@",personInfo.useraLitleImageURL);
            NSData  *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:personInfo.useraLitleImageURL]];
            littleImageView.image=[[UIImage alloc] initWithData:data];
            
        }
        
        
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadDataByUserName];
    self.title=@"设置";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
    _personInfoArray=[[NSMutableArray alloc]initWithCapacity:0];
    //创建设置页面
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    //设置tableview的背景颜色，ios6只能这么设定
    UIView* groundView = [[[UIView alloc]initWithFrame:_tableView.bounds] autorelease];
    UIImageView*back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
    back.frame=groundView.bounds;
    [groundView addSubview:back];
    [back release];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor=[UIColor blackColor];
    _tableView.backgroundView = groundView;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.frame=CGRectMake(0, 0, 320, self.view.bounds.size.height -44-49);
    [self.view addSubview:_tableView];
    [_tableView release];
    
    littleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(230,5, 45, 45)];
    
    littleImageView.layer.cornerRadius=4;
    littleImageView.layer.masksToBounds = YES;
    [littleImageView.layer setBorderWidth:1];
    [littleImageView.layer setBorderColor:[UIColor grayColor].CGColor];
    [_tableView addSubview:littleImageView];
    [littleImageView release];
   

}

-(void)personalMessage:(UIButton*)sender
{
    EditPersonInfoViewController *epc=[[EditPersonInfoViewController alloc]init];
    epc._personInfo=[_personInfoArray objectAtIndex:0];
    [self.navigationController pushViewController:epc animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [epc release];
}
-(void)messageSetting:(UIButton*)sender
{


}
-(void)accountManagement:(UIButton*)sender
{
    
}
-(void)moneyManagement:(UIButton*)sender
{
    
}
-(void)myWish:(UIButton*)sender
{
    [self.navigationController setNavigationBarHidden:YES];
    AllWishsViewController*nac=[[AllWishsViewController alloc]init];
    nac.info=[_personInfoArray objectAtIndex:0];
    [self.navigationController pushViewController:nac animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [nac release];
    
}
-(void)myGift:(UIButton*)sender
{
    
}

#pragma mark --tableViewDelegate
//tableview的必须实现的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section ==1) {
        return 1;
    }
    if (section==2) {
        return 2;
    }
    if (section == 3) {
        return 2;
    }
    return 0;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.userInteractionEnabled=YES;
    cell.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //设置用户名和密码是lable，后面是textfield
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UIButton*personalMessage=[UIButton buttonWithType:UIButtonTypeCustom];
            [personalMessage setTitle:@"个人信息修改" forState:UIControlStateNormal];
            [personalMessage addTarget:self action:@selector(personalMessage:) forControlEvents:UIControlEventTouchUpInside];
            personalMessage.titleLabel.font=[UIFont systemFontOfSize:18];
            [personalMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            personalMessage.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            personalMessage.frame=CGRectMake(25, 0, cell.frame.size.width-25, cell.frame.size.height);
            [cell.contentView addSubview:personalMessage];
            
            
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(290, 20, 7, 10);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
            
        }
            }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            UIButton*messageSetting=[UIButton buttonWithType:UIButtonTypeCustom];
            [messageSetting setTitle:@"消息设置" forState:UIControlStateNormal];
            [messageSetting addTarget:self action:@selector(messageSetting:) forControlEvents:UIControlEventTouchUpInside];
            messageSetting.titleLabel.font=[UIFont systemFontOfSize:18];
            [messageSetting setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            messageSetting.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            messageSetting.frame=CGRectMake(25, 0, cell.frame.size.width-25, cell.frame.size.height);
            [cell.contentView addSubview:messageSetting];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(290, 20, 7, 10);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
            
        }
    }
    

    
    //意见反馈和分享给朋友
    if (indexPath.section==2) {
        
        if (indexPath.row==0) {
            
            UIButton*accountManagement=[UIButton buttonWithType:UIButtonTypeCustom];
            [accountManagement setTitle:@"我的帐户管理" forState:UIControlStateNormal];
            [accountManagement addTarget:self action:@selector(accountManagement:) forControlEvents:UIControlEventTouchUpInside];
            accountManagement.titleLabel.font=[UIFont systemFontOfSize:18];
            [accountManagement setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [accountManagement.titleLabel setTextAlignment:NSTextAlignmentLeft];
            accountManagement.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            accountManagement.frame=CGRectMake(25, 0, cell.frame.size.width-25, cell.frame.size.height);
            [cell.contentView addSubview:accountManagement];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(290, 20, 7, 10);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
                    }
        //第二行
        if (indexPath.row==1) {
            UIButton*moneyManagement=[UIButton buttonWithType:UIButtonTypeCustom];
            [moneyManagement setTitle:@"资金管理" forState:UIControlStateNormal];
            [moneyManagement addTarget:self action:@selector(moneyManagement:) forControlEvents:UIControlEventTouchUpInside];
            [moneyManagement setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            moneyManagement.titleLabel.font=[UIFont systemFontOfSize:18];
            moneyManagement.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            moneyManagement.frame=CGRectMake(25, 0, cell.frame.size.width-25, cell.frame.size.height);
            [cell.contentView addSubview:moneyManagement];
           
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(290, 20, 7, 10);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
        
        }
               
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            
            
            UIButton*myWish=[UIButton buttonWithType:UIButtonTypeCustom];
            [myWish setTitle:@"我的愿望" forState:UIControlStateNormal];
            [myWish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            myWish.titleLabel.font=[UIFont systemFontOfSize:18];
            myWish.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            myWish.frame=CGRectMake(25, 0, cell.frame.size.width-25, cell.frame.size.height);
            [myWish addTarget:self action:@selector(myWish:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:myWish];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(290, 20, 7, 10);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
        }
        if (indexPath.row==1) {
            UIButton*myGift=[UIButton buttonWithType:UIButtonTypeCustom];
            [myGift setTitle:@"我的礼物" forState:UIControlStateNormal];
            [myGift addTarget:self action:@selector(myGift:) forControlEvents:UIControlEventTouchUpInside];
            [myGift setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            myGift.titleLabel.font=[UIFont systemFontOfSize:18];
            myGift.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            myGift.frame=CGRectMake(25, 0, cell.frame.size.width-25, cell.frame.size.height);

            [cell.contentView addSubview:myGift];
            
            UIImageView*imageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right.png"]];
            imageview.frame=CGRectMake(290, 20, 7, 10);
            imageview.backgroundColor=[UIColor clearColor];
            [cell addSubview:imageview];
            [imageview release];
            
        }

        
        
    }
    return cell;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
} - (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
