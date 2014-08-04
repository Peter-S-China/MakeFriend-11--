//
//  ChatViewController.h
//  MakeFriend
//
//  Created by dianji on 13-9-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MFViewController.h"
#import "KKMessageDelegate.h"

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,  KKMessageDelegate,UITextFieldDelegate>

@property (nonatomic, strong)  UITableView *tView;
@property (nonatomic, strong) UITextField *messageTextField;
@property(nonatomic, retain) NSString *chatWithUser;


@end
