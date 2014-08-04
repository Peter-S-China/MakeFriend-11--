//
//  PreVIewViewController.h
//  MakeFriend
//
//  Created by dianji on 13-8-14.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreVIewViewController : UIViewController
{
    UIView *PreNavView;
    UILabel *PreNavTitle;
    UIButton *PrerightButton;
    UIButton *PreBackButton;
    UIImage *selctedImage;
    UILabel*birthLabel;
      UILabel*birthLabel1;
      UILabel*birthLabel2;
}
@property(nonatomic,strong)UIImage *selctedImage;
@property(nonatomic,copy)NSString *preAddress;
@property(nonatomic,copy)NSString *wishString;
@property(nonatomic,copy)NSString *preMonth;
@property(nonatomic,copy)NSString *preDay;
@property(nonatomic,copy)NSString *preYear;
@property(nonatomic,assign)int  isPublic;
@end
