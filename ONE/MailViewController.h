//
//  MailViewController.h
//  ONE
//
//  Created by dianji on 13-1-8.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JUJUViewController.h"
@interface MailViewController : JUJUViewController<UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *attentField;
    UITextField *summeryField;
    UITextView *commentField;
}

@end
