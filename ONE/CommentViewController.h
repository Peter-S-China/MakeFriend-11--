//
//  CommentViewController.h
//  ONE
//
//  Created by Liang Wei on 1/24/13.
//  Copyright (c) 2013 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "Comment.h"

@interface CommentViewController : JUJUViewController
{
@private
    MessageInfo *_info;
    NSArray *_comments;
    UITextView *_commentView;
}

- (id)initWithInfo:(MessageInfo *)info comments:(NSArray *)array;

@end
