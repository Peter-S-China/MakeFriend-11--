//
//  FriendViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "FriendViewController.h"
#import "CJSONDeserializer.h"
#import "DetailPersonalInfoViewController.h"
@interface FriendViewController ()
@end

@implementation FriendViewController
@synthesize friendCell;
-(void)dealloc
{
    [friendCell release];
    [_allFriendArray release];
    
    friendCell=nil;
    _allFriendArray=nil;
    
    [super dealloc];
    
}
-(void)sortButClicked:(UIButton *)sender
{


}
-(void)removeButtonClicked:(UIButton *)sender
{
    //给所有cell发送广播出现删除按钮
    NSString *bcastName = @"editData";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:bcastName object:self];

}
- (void)loadAllFriendData
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?load_show='dd'&count='0'"]]];
    [request startAsynchronous];
    
    [request setFailedBlock:^{
        NSLog(@"request info failed");
    }];
    
    [request setCompletionBlock:^{
        __autoreleasing NSError *error = nil;
        CJSONDeserializer *deseri = [CJSONDeserializer deserializer];
        deseri.nullObject = @"";
        NSArray *momentArray = [deseri deserializeAsArray:request.responseData error:&error];
//        NSLog(@"friend momentArray = %@",momentArray);
        
        if ([momentArray isKindOfClass:[NSArray class]] && [momentArray count] > 0) {
            NSLog(@"%i",[momentArray count]);
            for (NSDictionary *dic in momentArray) {
                PhotoInfo *info = [[PhotoInfo alloc] init];
                info.userID = [dic objectForKey:@"id"];
                info.userName = [dic objectForKey:@"user_nickname"];
                info.useraLargeImageURL = [dic objectForKey:@"w_picid"];
                info.useraLitleImageURL=[dic objectForKey:@"user_picid"];
                info.userRegestName=[dic objectForKey:@"user_name"];//手机号码
                info.userwishAdderess=[dic objectForKey:@"w_addressID"];
                info.userwishTime=[[[dic objectForKey:@"w_date"]componentsSeparatedByString:@" "]objectAtIndex:0];
                info.userWish = [dic objectForKey:@"w_content"];
                info.userSex=[dic objectForKey:@"user_sex"];
                info.userBirth=[dic objectForKey:@"user_birth"];
                info.userAddress=[dic objectForKey:@"user_address"];
                info.userSignature=[dic objectForKey:@"user_defwish"];
                if (info.useraLargeImageURL.length > 0) {
                    info.width = [[dic objectForKey:@"w_picwidth"]floatValue];
                    info.height = [[dic objectForKey:@"w_picheight"]floatValue];;
                }
                
                [_allFriendArray addObject:info];
 //               NSLog(@"url = %@",info.useraLargeImageURL);
                  NSLog(@"_allFriendArray = %@",_allFriendArray);
               }
            [_friendTable reloadData];

        }
    }];
}

-(void)serchButtonClick:(UIButton*)sender
{
    /*
    for(PhotoInfo *info in _allFriendArray){
        if (![searchTextFiled.text isEqualToString:info.userName]) {
            [_allFriendArray removeObject:info];

        }
        else
        {
        
        }
            
      
    }
  [_friendTable reloadData];*/
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _allFriendArray=[[NSMutableArray alloc]initWithCapacity:0];
    [self loadAllFriendData];
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
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(80, 4, 150, 40)];
    title.text=@"我的好友";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont fontWithName:@"Arial-BoldMT" size:20];
    [navView addSubview:title];
    [title release];
    
    //加上排序和删除
    sortBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [sortBut setImage:[UIImage imageNamed:@"sortBut.png"] forState:UIControlStateNormal];
    [sortBut addTarget:self action:@selector(sortButClicked:) forControlEvents:UIControlEventTouchUpInside];
    sortBut.frame=CGRectMake(10, 20, 20, 15);
    [navView addSubview:sortBut];
    
    removeBut=[UIButton buttonWithType:UIButtonTypeCustom];
    [removeBut setImage:[UIImage imageNamed:@"removeBut.png"] forState:UIControlStateNormal];
    [removeBut addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    removeBut.frame=CGRectMake(self.view.bounds.size.width-30, 13, 15, 18);
    [navView addSubview:removeBut];
    //加上搜索拦
    UIView *serchBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 20)];
    serchBackView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"serchBackView.png"]];
    [self.view addSubview:serchBackView];
    [serchBackView release];
    //在搜索拦上加上透明button和UITextfield
    UIButton *serchBut=[UIButton buttonWithType:UIButtonTypeCustom];
    serchBut.frame=CGRectMake(0, 0, 35, 20);
    [serchBut addTarget:self action:@selector(serchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    serchBut.backgroundColor=[UIColor clearColor];
    [serchBackView addSubview:serchBut];
    
    searchTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(40, 0, 250, 20)];
    searchTextFiled.delegate=self;
    searchTextFiled.backgroundColor=[UIColor clearColor];
    [serchBackView addSubview:searchTextFiled];
    [searchTextFiled release];
    //创建设置页面
    _friendTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49) style:UITableViewStylePlain];
    
    //设置tableview的背景颜色，ios6只能这么设定
    UIView* groundView = [[[UIView alloc]initWithFrame:_friendTable.bounds] autorelease];
    UIImageView*back=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"settingbackgroundView.png"]];
    back.frame=groundView.bounds;
    [groundView addSubview:back];
    [back release];
    _friendTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    _friendTable.separatorColor=[UIColor blackColor];
    _friendTable.backgroundView = groundView;
    _friendTable.delegate=self;
    _friendTable.dataSource=self;
    [self.view addSubview:_friendTable];
    [_friendTable release];
    
}
#pragma mark - TableView Delegate
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [_allFriendArray count];
    NSLog(@"_allFriendArray count:%i",[_allFriendArray count]);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    friendCell=nil;
    if ([_allFriendArray count]<=indexPath.row) {
        return friendCell;
    }
    
    NSLog(@"allWishArray count%@",_allFriendArray);
    PhotoInfo *_winfo = [_allFriendArray objectAtIndex:indexPath.row];
   NSLog(@"_winfo.useraLitleImageURL:%@",_winfo.useraLitleImageURL);
    if (friendCell == nil) {
        friendCell = [[[FriendTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil message:_winfo delegate:self]autorelease];
        
    }
    
    
    return friendCell;
}
#pragma mark--friendTableCellDelegate
- (void)FriendTableCell:(FriendTableCell *)cell detalWithInfo:(PhotoInfo *)friendInfo
{
    DetailPersonalInfoViewController *dpc=[[DetailPersonalInfoViewController alloc]init];
    dpc.info=[friendInfo retain];
    [self.navigationController pushViewController:dpc animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [dpc release];

}
- (void)FriendTableCell:(FriendTableCell *)cell moveWithInfo:(PhotoInfo *)info
{
    
        if ([_allFriendArray containsObject:info])
    {
        [_allFriendArray removeObject:info];
       
        
    }
    [_friendTable reloadData];
    
}
#pragma mark--textfildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}
@end
