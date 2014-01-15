//
//  SelectedClassViewController.h
//  ONE
//
//  Created by dianji on 13-2-20.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedClassViewController :JUJUViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray*classArray;
    NSArray*classArray1;
    NSString* selctedListName;
//    UIButton*selctedButton;
//    UITableViewCell *cell;
//    UIButton*right;
//    UIButton*sure;
}

@property(nonatomic,copy) NSString* selctedListName;

@end
