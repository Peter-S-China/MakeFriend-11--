//
//  SearchCell.h
//  ONE
//
//  Created by dianji on 12-12-20.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
/**
 * Description : 显示搜索信息的一行，相当于一个cell
 *
 */

@class SearchCell;
@protocol searchCellDelegate <NSObject>
@optional

- (void)searchCell:(SearchCell *)cell selectedInfo:(MessageInfo*)info;
@end

@interface SearchCell : UITableViewCell
{
    id<searchCellDelegate> _delegate;
    MessageInfo *_info;
    UIButton*littleViewBUtton;
}

@property (nonatomic, strong) UIImageView *leftBack;
@property (nonatomic, strong) UIImageView *rightBack;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMessageInfo:(MessageInfo *)info delegate:(id)delegate_;

@end
