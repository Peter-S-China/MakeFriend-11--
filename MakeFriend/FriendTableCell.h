//
//  FriendTableCell.h
//  MakeFriend
//
//  Created by dianji on 13-9-11.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
@class FriendTableCell;
@protocol FriendTableCellDelegate <NSObject>
//查看这个愿望的所有评论
- (void)FriendTableCell:(FriendTableCell *)cell detalWithInfo:(PhotoInfo *)friendInfo;
- (void)FriendTableCell:(FriendTableCell *)cell moveWithInfo:(PhotoInfo *)info;
@end
@interface FriendTableCell : UITableViewCell
{
    UIView *friendCellbackView;
    UIImageView*friendCellImageview;
    UILabel *fnickName;
    UIImageView *fsex;
    UILabel *fwish;
    PhotoInfo *_info;
    UIButton *cancelButton;
    id<FriendTableCellDelegate> _delegate;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(PhotoInfo *)finfo delegate:(id)delegate_;
@end
