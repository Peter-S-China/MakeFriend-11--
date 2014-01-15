//
//  UserMessageViewController.h
//  ONE
//
//  Created by dianji on 13-1-17.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMessageViewController : JUJUViewController<UITextFieldDelegate>
{
    UITextField *nameField;
    UITextField *phoneField;
    ASIHTTPRequest*_upDateRequest;
    UIActivityIndicatorView *_indictorView;
}
@end
