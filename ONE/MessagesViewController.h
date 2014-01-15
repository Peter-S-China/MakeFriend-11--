//
//  MessagesViewController.h
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "DetailViewController.h"
#import "JUJUViewController.h"
#import "ClassView.h"
#import "YLProgressBar.h"
#import "ASIProgressDelegate.h"
//#import "EGORefreshTableHeaderView.h"
//#import "EGORefreshTableFooterView.h"
#import <AVFoundation/AVFoundation.h>
#import "DDPageControl.h"
#import "TabBarView.h"
#import "AddInfo.h"

@interface MessagesViewController : JUJUViewController<UIScrollViewDelegate,MessageButtonDelegate,ASIProgressDelegate,AVAudioPlayerDelegate,TabbarDelegate>
{
    
//夜生活图片
    NSMutableArray *nightLifePhotoNameArray;
//时尚聚会
    NSMutableArray *fashionPartyPhotoNameArray;
//电影
    NSMutableArray *moviePhotoNameArray;
//演出
    NSMutableArray *showPhotoNameArray;
//慈善公益
    NSMutableArray *charityPhotoNameArray;
//拍卖会
    NSMutableArray *publicSalePhotoNameArray;
//展览会
    NSMutableArray *exhibitionPhotoNameArray;
//运动
    NSMutableArray *sportPhotoNameArray;
//其他
    NSMutableArray *otherPhotoNameArray;
//最底层，也是最下面的大的scrollview
    UIScrollView *_scrollView;
    MessageCell *cells;
    NSMutableArray *_buttonTitleArray;
//存放下载数据归类后的字典    
    NSMutableDictionary *_infosDic;
//存所有的类别名    
    NSMutableArray *classNameArray;
    UIButton *_arrowButton;
    ClassView *_classView;
//用来显示进度    
    YLProgressBar *_progressBar;
    UILabel *_progressLabel;
 //上拉刷新   
//    EGORefreshTableHeaderView *_headerView;
    BOOL _refreshing;
    //承载进度条得imageview
    UIImageView *images;
   //引导页面的scrollview
    UIScrollView * pageScrollView ;
   //首页的scrollview
    UIScrollView *messageScrollView;
    DDPageControl * messagePageControl;
    UIPageControl *_pageController;
    int requestCount;
    int requestAddCount;
    //选择后的类别名字
    NSString *selectedName;
    NSMutableArray *allArray;
    NSMutableArray* addArray;
    NSMutableArray *ChaiFenarray;
    BOOL _isHiddenTabbar;
    TabBarView *_tabBarView;
    UIView *navView;
    UIScrollView *navScorllview;
    int curentPage;
}

@property(nonatomic,strong) AVAudioPlayer * player;
@property(nonatomic,retain) NSMutableArray * _infos;
@property(nonatomic,retain) NSMutableDictionary * _infosDic;
@property(nonatomic,retain) NSMutableArray * classNameArray;
@property(nonatomic,retain) UIScrollView *  pageScrollView ;
@property(nonatomic,retain) UIScrollView *  messageScrollView ;
@property(nonatomic,copy) NSString * selectedName;

-(id)initWithTitle:(NSString*)title navTitle:(NSString*)navTitle;
//加载首页
-(void)requestFirstInfo;
-(void)writeToLocal;

@end
