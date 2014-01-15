//
//  JoinViewController.h
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"joinCell.h"
#import "MessageInfo.h"
#import"JUJUViewController.h"

@interface JoinViewController : JUJUViewController<UITableViewDataSource,UITableViewDelegate,joinCellDelegate,UIScrollViewDelegate>
{

    MessageInfo *_info;
    UITableView *joinedTabelView;
    NSMutableArray *joinedArray;
    UIButton *editeButton;
    UIButton*leftButton;
    BOOL _isHiddenTabbar;
    UIView *navView;
    UIScrollView *navScorllview;
}
@property(nonatomic,strong) MessageInfo *_info;
@property(nonatomic,retain) NSMutableArray *joinedArray;
@property(nonatomic,strong) UITableView *joinedTabelView;
@property(nonatomic,strong)  joinCell*cell;
-(id)initWithTitle:(NSString*)title navTitle:(NSString*)navTitle;

@end
