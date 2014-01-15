//
//  SearchViewController.h
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"JUJUViewController.h"
#import "EGORefreshTableFooterView.h"
#import"SearchCell.h"
@interface SearchViewController : JUJUViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource,EGORefreshTableFooterDelegate,searchCellDelegate,UIScrollViewDelegate>
{
    NSString *searchWord;
    UITextField *_textField;
    UIImageView*searchImage;
    NSInteger statIndex;
    NSMutableArray *mDateArray;
//    TimeView *_timeView;
    UITableView *_tableView;//显示搜索结果
    NSMutableArray *_searschInfos;//保存搜索的信息
    UIButton *_titleButton;
    UIButton *_backButton;
    //三个pickerView
    UIView *_timeView;//加了时间段选取器和带确定和取消按钮的toolBar
    UIPickerView *_pickerView;
    NSArray * timeArray;
    NSArray * classArray;
    NSArray * areaArray;
    NSArray *_dataArray;
    int _whitchPicker;//记录现在是哪一个PickerVIew在显示
    NSString *_middleWord;//临时记录picker选择的值
    //记录最终的值
    NSString *_timeWord;
    NSString *_classWord;
    NSString *_areaWord;
    //下拉加载更多
    EGORefreshTableFooterView *_footerView;
    BOOL _loadMore;
    BOOL _isHiddenTabbar;
    UIView *navView;
    UIScrollView *navScorllview;
    
}
@property(nonatomic, strong) UIButton *timeButton;
@property(nonatomic, strong) UIButton *classButton;
@property(nonatomic, strong) UIButton *areaButton;
@property(nonatomic, retain) NSMutableArray *_searschInfos;

-(id)initWithTitle:(NSString*)title navTitle:(NSString*)navTitle;

@end
