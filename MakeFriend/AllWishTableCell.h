//
//  AllWishTableCell.h
//  MakeFriend
//
//  Created by dianji on 13-8-29.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllWishInfo.h"
@class AllWishTableCell;
@protocol AllWishTableCellDelegate <NSObject>
//查看这个愿望的所有评论
- (void)commentInfoCell:(AllWishTableCell *)cell checkWithInfo:(AllWishInfo *)info;

@end
@interface AllWishTableCell : UITableViewCell
{
    UIView *backGroundView;
    UIImageView*imageview;
    UILabel *allWishContent;
    AllWishInfo *_info;
    NSString *commentCount;
    id<AllWishTableCellDelegate> _delegate;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(AllWishInfo *)info commentCount:(NSString*)count delegate:(id)delegate_;
@end
