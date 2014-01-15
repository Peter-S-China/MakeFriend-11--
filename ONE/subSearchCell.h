//
//  subSearchCell.h
//  ONE
//
//  Created by dianji on 12-12-24.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"

@class subSearchCell;
@protocol subSearchCellDelegate <NSObject>
@optional

- (void)subSearchCell:(subSearchCell *)cell selectedInfo:(MessageInfo*)info;
@end


@interface subSearchCell : UITableViewCell
{
    MessageInfo *_info;
    id<subSearchCellDelegate> _delegate;
    UIButton*littleViewBUtton;

}

@property (nonatomic, strong) UIImageView *leftBack;
@property (nonatomic, strong) UIImageView *rightBack;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMessageInfo:(MessageInfo *)info delegate:(id)delegate_;

@end
