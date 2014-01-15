//
//  LoginViewController.h
//  ONE
//
//  Created by dianji on 13-11-27.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView*myTableView;
    //是否记住密码的button
    UIButton*wihteButton;
}
@property(strong,nonatomic)UITableView*myTableView;
@property(nonatomic,strong)UIButton*wihteButton;
@end
