//
//  AddEventViewController.h
//  ONE
//
//  Created by dianji on 13-5-3.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
@interface AddEventViewController :JUJUViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,ContentViewControllerDelegate>
{
    UIButton*backButton;
    UIButton*addNewEvent;
    UITextField*name;
    UITextField*address;
    UITextField*tel;
    UIButton*updateImageButton;
    UIImageView*pickImage;
    UIImagePickerController*imagePicker;
    UITableView*addEventTableView;
    
    UILabel*titleContent;
     UILabel*timeContent;
     UILabel*abstractContent;
     UILabel*addressContent;
     UILabel*telContent;
}
@end
