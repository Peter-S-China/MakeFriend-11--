//
//  ContentViewController.h
//  ONE
//
//  Created by dianji on 13-5-10.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentViewController;
@protocol ContentViewControllerDelegate <NSObject>

- (void)ContentViewController:(ContentViewController *)controller addWithInfo:(NSString *)text withTag:(NSString*)tag;
@end

@interface ContentViewController : JUJUViewController<UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIButton *backButton;
    UITextView *textView2;
    UITextView *startTexview;
    UITextView *endTexview;
    UIButton *startTimeButton;
    UIButton *endTimeButton;
    id<ContentViewControllerDelegate>delegate;
   //时间选择器
    UIPickerView *_pickerView;
    NSArray *yearArray;
    NSArray *monthArray;
    NSArray *dayArray;
    NSArray *hourArray;
    NSArray *miniteArray;
    UIView*_timeView;
    NSString*year;
    NSString*month;
    NSString*day;
    NSString*hour;
    NSString*minite;
    int _whitchPicker;//记录现在是哪一个PickerVIew在显示
}
@property(nonatomic,copy)NSString * navTitle;
@property(nonatomic,copy)NSString * tag;
@property(nonatomic,strong)id delegate;
@property(nonatomic,copy)NSString * textView;


@end
