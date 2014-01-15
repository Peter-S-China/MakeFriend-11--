//
//  joinCell.h
//  ONE
//
//  Created by dianji on 12-12-18.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "ASIHTTPRequest.h"

@class joinCell;
@protocol joinCellDelegate <NSObject>
@optional
- (void)detailCell:(joinCell *)cell WithInfo:(MessageInfo *)info;
- (void)detailCell:(joinCell *)cell moveWithInfo:(MessageInfo *)info;
- (void)detailCell:(joinCell *)cell selectedInfo:(MessageInfo*)info;
@end


@interface joinCell : UITableViewCell
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
    UIView*identView;
    UILabel*identfireTitle;
    UILabel*identifData;
    
    UIView*litleView;
    UIView*largeView;
    id<joinCellDelegate> _delegate;
    
    ASIHTTPRequest*_request;
    
    UIButton*littleViewBUtton;
}
@property(nonatomic,strong)UIView *litleView;
@property(nonatomic,strong)UIView *largeView;
@property (nonatomic, strong) UIButton *cancelButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier message:(MessageInfo *)info delegate:(id)delegate_;

@end
