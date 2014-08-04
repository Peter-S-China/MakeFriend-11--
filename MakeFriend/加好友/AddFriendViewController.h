//
//  AddFriendViewController.h
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MFViewController.h"
#import "MWDatePicker.h"
#import"PreVIewViewController.h"
@interface AddFriendViewController : MFViewController<MWPickerDelegate,UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *navView;
    UILabel *navTitle;
    UIButton *rightButton;
    UIButton *wrongButton;
    UIView *navView1;
    UILabel *navTitle1;
    UIButton *wrongButton1;
    UIButton *previewButton;
    UIView *chooseMyBirthdayView;
   
    NSArray * monthArray;
    NSArray * dayArray;
    NSArray * yearArray;
    NSString *month;
    NSString *day;
    NSString *year;
    NSString *labelDateSelected;
    
    UIView*wishView;
    UIButton*takePhoto;
    UIImage *selctedimage;//被选中的照片
    UITextView*writeWishField;
    UILabel*addressLabel;
    
    UITableView*addressTable;
    int count;
    NSMutableArray *addressArray;
}
@property(nonatomic,copy)NSString *month;
@property(nonatomic,copy)NSString *day;
@property(nonatomic,copy)NSString *year;

@end
