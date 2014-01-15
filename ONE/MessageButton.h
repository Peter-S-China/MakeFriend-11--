//
//  MessageButton.h
//  ONE
//
//  Created by dianji on 12-11-29.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"

@class MessageButton;

//协议，为了知道到时候点击了哪一个button
@protocol  MessageButtonDelegate<NSObject>

-(void)messageButton:(MessageButton *)button selectedInfo:(MessageInfo*)info ;

@end

@interface MessageButton : UIView
{
    UIButton*_button;
    
    MessageInfo*buttonInfo;
   
    id _delegate;
    
    UIActivityIndicatorView *_indictorView;
    
    UIImageView *_back;
}
@property(nonatomic,strong)MessageInfo*buttonInfo;

-(id)initWithFrame:(CGRect)frame messageinfo:(MessageInfo*)info delegate:(id<MessageButtonDelegate>)delegate_;
-(void)appear;
@end
