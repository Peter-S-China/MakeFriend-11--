//
//  MapViewController.h
//  ONE
//
//  Created by dianji on 12-12-4.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "DetailView.h"
#import "ASIHTTPRequest.h"
#import "JUJUViewController.h"
#import "ASMediaFocusManager.h"
@interface DetailViewController :JUJUViewController <UIScrollViewDelegate,UIActionSheetDelegate,ASMediasFocusDelegate>
{
    //为接收button协议传过来的值
    MessageInfo*message;
    //三个小view
    UIView*readView;
    UIView*addView;
    UIView*joinView;
    //保存点击了加入关注的数据
    NSMutableArray*addFavArray;
    
    //可以滑动的scolleview,在上面加载东西
    UIScrollView*scView;
    UIPageControl *pageCon;    
    //存储所有imageview的数组
    NSMutableArray*views;
    int currentPage_; //当前页
	int totalPages_; //总图片数量
    //为了接收存有classname和value的的字典
    NSMutableDictionary*infosDict;
    UILabel *_nameLabel;
    ASIHTTPRequest *_request;
    
    NSMutableArray *_buttonTitleArray;
    NSMutableDictionary *_infosDic;//存放下载数据归类后的字典
    NSMutableArray *classNameArray;//存所有的类别名

    MessageInfo*_reloadInfo;
    MessageInfo * _info;
    BOOL _isFinished;//标记是否动画完成
    NSMutableArray *_showInfos;//需要显示的MessageInfo
    UILabel*detailDestance;
    UIButton* right;
    UIButton*left;
    
}
//每张图片的标题
@property (nonatomic, strong) MessageInfo *message;
@property (nonatomic, strong) MessageInfo *_reloadInfo;
@property (nonatomic, strong) UIView *readView;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIView *joinView;
@property (nonatomic, retain) NSMutableArray *addFavArray;
@property (nonatomic, retain) UIScrollView *scView;
@property (nonatomic, retain) UIPageControl *pageCon;
@property (nonatomic, retain) NSDictionary *infosDict;
@property (nonatomic, copy)  NSString *navTitle;
@property (nonatomic, retain)  UIImageView *blueView;
@property (nonatomic, retain)  UIImageView *greenView;
@property (nonatomic, strong)  UIImageView*largeImageview;
@property (nonatomic, strong) ASMediaFocusManager *mediaFocusManager;

@end
