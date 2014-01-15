//
//  AttentionCell.h
//  ONE
//
//  Created by dianji on 12-12-10.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "ASIHTTPRequest.h"

@class AttentionCell;
@protocol AttentionCellDelegate <NSObject>

- (void)attentionCell:(AttentionCell *)cell joinWithInfo:(MessageInfo *)info;
- (void)attentionCell:(AttentionCell *)cell moveWithInfo:(MessageInfo *)info;
- (void)attentionCell:(AttentionCell *)cell joined:(MessageInfo *)info;
- (void)attentionCell:(AttentionCell *)cell;
- (void)attentionCell:(AttentionCell *)cell selectedInfo:(MessageInfo*)info;

@end

@interface AttentionCell : UITableViewCell<UIAlertViewDelegate>
{
    UIImageView*imageView;
    UILabel*titleLabel;
    UILabel*timeLabel;
    UILabel*abstractLabel;
    //关注度
    UIImageView*attentionImage;
    UILabel*attentionLabel;
    //参与人数
    UIImageView*joinImage;
    UILabel*joinLabel;
    //距离现在的位置多远
    UIImageView*destanceImage;
    UILabel*destanceLabel;
    MessageInfo*_info;
    id<AttentionCellDelegate> _delegate;
    ASIHTTPRequest*_request;
    UIButton*littleViewBUtton;
}
@property (nonatomic, strong) UIButton *cancelButton;
@property(nonatomic,strong)UIView *litleView;
@property(nonatomic,strong)UIView *largeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(MessageInfo *)info delegate:(id)delegate_;

@end
