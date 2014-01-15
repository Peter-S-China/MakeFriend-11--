//
//  MessageCell.h
//  ONE
//
//  Created by dianji on 12-11-29.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageButton.h"

@interface MessageCell : UIView<UIScrollViewDelegate>
{
@private
    UIScrollView*_scrollView;
   
}
//title也应该是array，infos主要是每个button的具体信息（这里是title）
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
              infos:(NSArray *)infos
           delegate:(id)delegate_;

- (void)setScorollViewContentWidth:(float)width;
-(void)appear;
@end
