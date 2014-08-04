//
//  StartViewController.m
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "StartViewController.h"
#import "ASIHTTPRequest.h"
#import "MyWishViewController.h"
#import "CJSONDeserializer.h"
@interface StartViewController ()

@end

@implementation StartViewController

#pragma mark - Customs Methods
- (void)initWaterFlowView
{
    _photoWall = [[BSPhotoWall alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height)];
    _photoWall.delegate = self;
    _photoWall.bsWaterViewDataSource = self;
    [self.view addSubview:_photoWall];
    [_photoWall reloadData];
}

- (void)loadDataByUserID
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
 //       NSLog(@"momentArray = %@",momentArray);
        
        if ([momentArray isKindOfClass:[NSArray class]] && [momentArray count] > 0) {
//
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
                
                [_dataArray addObject:info];
//                NSLog(@"url = %@",info.useraLargeImageURL);
            }
            [_photoWall insertAtEnd:YES];
        }
    }];
}
-(void)serchButtonClicked:(UIButton*)sender
{


}
-(void)sortByTimeButtonClicked:(UIButton *)sender
{


}
-(void)sortByAddressButtonClicked:(UIButton *)sender
{



}

-(void)creNav
{
    //自定义导航条
    startNavView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    startNavView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar_background1.png"]];
   // startNavView.hidden=YES;
    [self.view addSubview:startNavView];
    [startNavView release];
  //布置导航条上面的搜索，排序，地图按钮
    UITextField *serchText=[[UITextField alloc]initWithFrame:CGRectMake(5, 10, 220, 20)];
    serchText.backgroundColor=[UIColor grayColor];
    serchText.font=[UIFont systemFontOfSize:12];
    serchText.delegate=self;
    serchText.borderStyle=UITextBorderStyleRoundedRect;
    serchText.textAlignment=NSTextAlignmentRight;
    serchText.textColor=[UIColor whiteColor];
    [startNavView addSubview:serchText];
    [serchText release];
    
    UIButton *serchBut=[UIButton buttonWithType:UIButtonTypeCustom];
    serchBut.frame=CGRectMake(230, 10, 20, 20);
    [serchBut setImage:[UIImage imageNamed:@"serchBut.png"] forState:UIControlStateNormal];
    [serchBut addTarget:self action:@selector(serchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [startNavView addSubview:serchBut];
   
    UIButton *sortByTime=[UIButton buttonWithType:UIButtonTypeCustom];
    sortByTime.frame=CGRectMake(260, 10, 20, 20);
    [sortByTime setImage:[UIImage imageNamed:@"sortByTimeBut.png"] forState:UIControlStateNormal];
    [sortByTime addTarget:self action:@selector(sortByTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [startNavView addSubview:sortByTime];
    
    UIButton *sortByAddress=[UIButton buttonWithType:UIButtonTypeCustom];
    sortByAddress.frame=CGRectMake(290, 10, 15, 20);
    [sortByAddress setImage:[UIImage imageNamed:@"sortByAddressBut.png"] forState:UIControlStateNormal];
    [sortByAddress addTarget:self action:@selector(sortByAddressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [startNavView addSubview:sortByAddress];
     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([Tools isIphone5]) {
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView5.png"]];
    }
    else
    {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundView.png"]];
    }
    //隐藏上面的navigationbar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //自定义navgation
    [self creNav];
    _dataArray =[[NSMutableArray alloc] init];
    
    [self initWaterFlowView];
    
    [self loadDataByUserID];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BSWalterFlow DataSourse
- (NSInteger)numberOfViewsInCollectionView:(BSPhotoWall *)collectionView
{
    NSLog(@"count = %i",[_dataArray count]);
    return [_dataArray count];
}

- (BSPhotoView *)collectionView:(BSPhotoWall *)collectionView viewAtIndex:(NSInteger)index
{
    PhotoInfo *info = [_dataArray objectAtIndex:index];
    BSPhotoView *view = (BSPhotoView *)[_photoWall dequeueReusableView];
    if (!view) {
        view = [[BSPhotoView alloc] initWithFrame:CGRectZero];
    }
    [view fillViewWithObject:info];
    return view;
}

- (CGFloat)heightForViewAtIndex:(NSInteger)index
{
    PhotoInfo *info = [_dataArray objectAtIndex:index];
    return [BSPhotoView heightForViewWithObject:info inColumnWidth:147];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    float offSetY = scrollView.contentOffset.y;

    if (_beginDrag > offSetY) {
 //       [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = startNavView.frame;
            rect.origin.y =0;
            startNavView.frame = rect;
            
            CGRect rect1=_photoWall.frame;
            rect1.origin.y=44;
            _photoWall.frame=rect1;
        }
                         completion:^(BOOL finished) {
                         }];
        
    }
    else {
 //       [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = startNavView.frame;
            rect.origin.y =-44;
            startNavView.frame = rect;
           
            CGRect rect1=_photoWall.frame;
            rect1.origin.y=0;
            _photoWall.frame=rect1;
            
        }
                         completion:^(BOOL finished) {
                         }];
        
    }
    //设置要不要刷新图片墙
    if (offSetY < 0.0f) {
        return;
    }
    else if (offSetY + _photoWall.frame.size.height > _photoWall.contentSize.height) {
        return;
    }
    else if(abs(offSetY - _beginDrag) >= 30) {
        _beginDrag = offSetY;
        [_photoWall removeAndAddCellsIfNecessary];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _beginDrag = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scroll.contentSize = %f =====height =  %f ======contentOffset = %f",scrollView.contentSize.height,scrollView.frame.size.height,scrollView.contentOffset.y);
    if (scrollView.contentSize.height <= scrollView.frame.size.height + scrollView.contentOffset.y + 1) {
        [self loadDataByUserID];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate && scrollView.contentSize.height <= scrollView.frame.size.height + scrollView.contentOffset.y + 1) {
        [self loadDataByUserID];
    }
}

#pragma mark - BSPhotoView Delegate
- (void)BSPhotoView:(BSPhotoView *)view handleWithInfo:(PhotoInfo *)info
{
    if (info) {
        MyWishViewController *MyWishVc=[[MyWishViewController alloc]init];
        MyWishVc.wishInfo=info;
        [self.navigationController pushViewController:MyWishVc animated:YES];
        [[MyTableBarController sharedTabBarController]hideTabbar:YES];
        [MyWishVc release];

    }
}
#pragma mark--textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
