//
//  PersonalMessageViewController.h
//  ONE
//
//  Created by dianji on 12-12-11.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
#import "ASIHTTPRequest.h"
@interface PersonalMessageViewController : JUJUViewController<UITextFieldDelegate,UIAlertViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MessageInfo * _info;
    ASIHTTPRequest*_request;
    UITextField*nameField;
    UITextField*phoneField;
    UITextView*commentField;
    
    NSMutableArray *_buttonTitleArray;
    NSMutableDictionary *_infosDic;//存放下载数据归类后的字典
    NSMutableArray *classNameArray;//存所有的类别名
    
    UIScrollView*scoller;
}
@property(nonatomic,strong) MessageInfo * _info;
//@property(nonatomic,strong) MessageInfo * info;

@end
