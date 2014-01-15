//
//  AttentionViewController.h
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "AttentionCell.h"
#import"JUJUViewController.h"
@interface AttentionViewController : JUJUViewController<UITableViewDataSource,UITableViewDelegate,AttentionCellDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UITableView * attentionTable;
    MessageInfo * message;
    NSMutableArray*attentionArray;
    NSMutableDictionary *dict;
    UIBarButtonItem*left;
    ASIHTTPRequest *_request;
    UIButton *editeButton;
    UIButton*leftButton;
    BOOL _isHiddenTabbar;
    UIView *navView;
    UIScrollView *navScorllview;
}
@property(nonatomic,strong) MessageInfo * message;
@property(nonatomic,retain) NSMutableArray*attentionArray;
@property(nonatomic,strong) UITableView * attentionTable;
@property(nonatomic,strong) AttentionCell*cell;

-(id)initWithTitle:(NSString*)title navTitle:(NSString*)navTitle;

@end
