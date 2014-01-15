//
//  ButtonDetailViewController.h
//  ONE
//
//  Created by dianji on 12-12-17.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "Comment.h"
#import "WXApiObject.h"
#import "UIImageView+WebCache.h"
@protocol sendMsgToWeChatViewDelegate<NSObject>
-(void)sendImageContent;
@end

@interface ButtonDetailViewController : JUJUViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,WXApiDelegate,UIActionSheetDelegate>
{
    MessageInfo * _info;
    UIScrollView *scoll;
    //评论
    UITextView *commentField;
    UILabel *compit;
    UIImageView *commentView;
    CGSize size;
    UIButton *sendButton;
    UITableView *commentTableView;
    NSMutableArray *_commentArray;
    UIView*commentLargeView;
    enum WXScene _scene;
     UIActionSheet *_snsActionSheet;
    UIButton*careConment;
    UITextView*commenttextView;
    UIButton *careButton1;
    UIButton*right;
}
@property(nonatomic, retain)MessageInfo * _info;
@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;

@end
