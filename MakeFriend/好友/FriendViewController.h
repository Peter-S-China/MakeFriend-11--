//
//  FriendViewController.h
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"FriendTableCell.h"
@interface FriendViewController : MFViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *removeBut;
    UIButton *sortBut;
    UITableView *_friendTable;
    NSMutableArray *_allFriendArray;
    UITextField *searchTextFiled;
}
@property(nonatomic,strong) FriendTableCell*friendCell;

@end
