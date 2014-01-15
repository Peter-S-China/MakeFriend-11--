//
//  MoreViewController.h
//  ONE
//
//  Created by dianji on 12-12-3.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"JUJUViewController.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface MoreViewController : JUJUViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
 
    UITableView *_tableView;
    UILabel*label;
    BOOL _isHiddenTabbar;
    UIView *navView;
    UIScrollView *navScorllview;

}
@property (nonatomic , retain) UILabel *label;

-(id)initWithTitle:(NSString*)title navTitle:(NSString*)navTitle;

@end
