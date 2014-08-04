//
//  TakeMessageViewController.h
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MFViewController.h"
#import "KKChatDelegate.h"

@interface TakeMessageViewController : MFViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,KKChatDelegate>
{
    UIButton *removeBut;
    UIButton *sortBut;
    
}
@property (nonatomic, strong)UITableView *tView;

- (void)Account:(id)sender;


@end
