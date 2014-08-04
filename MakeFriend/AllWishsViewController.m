//
//  AllWishsViewController.m
//  MakeFriend
//
//  Created by dianji on 13-8-29.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AllWishsViewController.h"
#import "MyCommentViewController.h"
#import "CJSONDeserializer.h"
#import "AllWishInfo.h"
#import "ConmentInfo.h"
@interface AllWishsViewController ()

@end

@implementation AllWishsViewController
@synthesize info,allWishArray,cell;
-(void)dealloc
{
    [allWishArray release];
    allWishArray=nil;

    [super dealloc];
}
//为了隐藏系统自身的tabbar
- (id)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)backButtonClicked:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)creatAllWishViewNavGationView
{
    
    //自定义导航条
    navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
    [self.view addSubview:navView];
    [navView release];
    //加上x和钩和标题
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 90, 35)];
    titleLabel.text=@"所有愿望";
    titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:18];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [navView addSubview:titleLabel];
    [titleLabel release];
    //加上返回按钮和钩
    leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame=CGRectMake(10, 10, 30, 27);
    [navView addSubview:leftButton];
}
-(void)parseAllWishDataByPhonenumber
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://218.246.35.203:8011/pages/json.aspx?show_username=%@&load_wish='dd'",self.info.userRegestName]]];
    NSLog(@"http://218.246.35.203:8011/pages/json.aspx?show_username=%@&load_wish='dd'",self.info.userRegestName);
    [request startAsynchronous];
    
    [request setFailedBlock:^{
        NSLog(@"request info failed");
    }];
    
    [request setCompletionBlock:^{
        __autoreleasing NSError *error = nil;
        CJSONDeserializer *deseri = [CJSONDeserializer deserializer];
        deseri.nullObject = @"";
        NSArray *momentArray = [deseri deserializeAsArray:request.responseData error:&error];
 //       NSLog(@"momentArray = %@",momentArray);
        
        if ([momentArray isKindOfClass:[NSArray class]] && [momentArray count] > 0) {
          
            for (NSDictionary *dic in momentArray) {
               
                AllWishInfo *allWishInfo = [[AllWishInfo alloc] init];
                allWishInfo.wishContent=[dic objectForKey:@"wishname"];
                allWishInfo.wishId = [dic objectForKey:@"wishid"];
                allWishInfo.wishLittelImageUrl = [dic objectForKey:@"wish_picurl"];
                allWishInfo.wishTime=[[[dic objectForKey:@"wishdate"]componentsSeparatedByString:@" "]objectAtIndex:0];
                //解析评论
//                NSMutableArray*allConmments=[[NSMutableArray alloc]initWithCapacity:0];
                NSArray *allConmments = [dic objectForKey:@"comments"];
                for(NSDictionary *commentDic in allConmments){
                    ConmentInfo *allWishCommentInfo=[[ConmentInfo alloc]init];
                    allWishCommentInfo.commentStr = [commentDic objectForKey:@"comment_content"];
                    NSLog(@"allWishCommentInfo.commentStr:%@",allWishCommentInfo.commentStr);
                    allWishCommentInfo.commentTime = [commentDic objectForKey:@"comment_date"];
                    allWishCommentInfo.commentAddress = [commentDic objectForKey:@"user_address"];
                    allWishCommentInfo.commenterBirth=[commentDic objectForKey:@"user_birth"];
                    allWishCommentInfo.commenterWish=[commentDic objectForKey:@"user_defwish"];
                    allWishCommentInfo.commenterNickName=[commentDic objectForKey:@"user_nickname"];
                    allWishCommentInfo.commenterLittelImageUrl = [commentDic objectForKey:@"user_picid"];
                    allWishCommentInfo.commenterSex = [commentDic objectForKey:@"user_sex"];
                    [allWishInfo.allCommentInfos addObject:allWishCommentInfo];
                    NSLog(@"[allWishInfo.allCommentInfos count] = %d",[allWishInfo.allCommentInfos count]);
                    //把wishid和评论分别作为键和值存入本地字典
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    if (![defaults objectForKey:allWishInfo.wishId]) {
                        [defaults setObject:allWishCommentInfo forKey:allWishInfo.wishId];
                    }
                    [defaults synchronize];
                    [allWishCommentInfo release];
                }
                [self.allWishArray addObject:allWishInfo];
                NSLog(@"%d",[allWishArray count]);
    //            NSLog(@"url = %@",info.commenterLittelImageUrl);
            }
            [allWishTable reloadData];
        }
    }];
    


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    allWishArray=[[NSMutableArray alloc]initWithCapacity:0];
   [self creatAllWishViewNavGationView];
     self.view.backgroundColor=[UIColor blackColor];
    [self parseAllWishDataByPhonenumber];
   
    //创建显示所有心愿的table；
    allWishTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44) style:UITableViewStylePlain ];
    allWishTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    allWishTable.separatorColor=[UIColor blackColor];
    allWishTable.delegate=self;
    allWishTable.dataSource=self;
    UIView* groundView = [[[UIView alloc]initWithFrame:allWishTable.bounds] autorelease];
    groundView.backgroundColor=[UIColor blackColor];
    allWishTable.backgroundView=groundView;
//    allWishTable.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentBakGroung.png"]];
    [self.view addSubview:allWishTable];
    [allWishTable release];

}
#pragma mark - TableView Delegate
//三个必需实现的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [allWishArray count];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129.0f;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell=nil;
    if ([allWishArray count]<=indexPath.row) {
        return cell;
    }
   
    NSLog(@"allWishArray count%@",allWishArray);
    AllWishInfo *_winfo = [allWishArray objectAtIndex:indexPath.row];
     NSString *count=[NSString stringWithFormat:@"%d",[_winfo.allCommentInfos count]];
    NSLog(@"commentCount:%d",[_winfo.allCommentInfos count]);
    NSLog(@"_winfo.wishContent:%@",_winfo.wishContent);
    NSLog(@"_winfo.wishLittelImageUrl:%@",_winfo.wishLittelImageUrl);
    if (cell == nil) {
        cell = [[[AllWishTableCell alloc]initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:nil message:_winfo commentCount:count delegate:self] autorelease];
        
    }
    
    
    return cell;
}
#pragma mark--allWishTableCellDelagate
- (void)commentInfoCell:(AllWishTableCell *)cell checkWithInfo:(AllWishInfo *)allWishinfo
{
    MyCommentViewController *MyWishVc=[[MyCommentViewController alloc]init];
    MyWishVc.wishInfo = self.info;
    MyWishVc.conmmtArray=[[NSMutableArray alloc]initWithArray: allWishinfo.allCommentInfos];
    NSLog(@"allWishinfo.allCommentInfos = %@",allWishinfo.allCommentInfos);
    [self.navigationController pushViewController:MyWishVc animated:YES];
    [[MyTableBarController sharedTabBarController]hideTabbar:YES];
    [MyWishVc release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
