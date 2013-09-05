//
//  CommentInfoCell.h
//  MakeFriend
//
//  Created by dianji on 13-8-26.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConmentInfo.h"
@class CommentInfoCell;
@protocol CommentInfoCellDelegate <NSObject>
//查看评论这个人的基本信息
- (void)commentInfoCell:(CommentInfoCell *)cell checkWithInfo:(ConmentInfo *)info;

@end
@interface CommentInfoCell : UITableViewCell
{
    UIButton *littleImageButton;
    UILabel *commenterName;
    UILabel *commetStr;
    ConmentInfo *_info;
    id<CommentInfoCellDelegate> _delegate;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(ConmentInfo *)info delegate:(id)delegate_;
@end
