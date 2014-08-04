//
//  MyCommentViewController.h
//  MakeFriend
//
//  Created by dianji on 13-9-2.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UIView *myCommentNav;
    UILabel *myCommentTitle;
    UIButton *myCommentBackButton;
    UITableView *_myCommentTable;
    UITextView *commenttextView;
    UIView *conmmetBackView;
    UIButton *sendButton;
    UITableViewCell *cell;
}
@property(nonatomic,retain)PhotoInfo *wishInfo;
@property(nonatomic,retain)NSMutableArray *conmmtArray;
@property(nonatomic,copy)NSString *constellatory;
@end
