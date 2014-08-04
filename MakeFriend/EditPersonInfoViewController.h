//
//  EditPersonInfoViewController.h
//  MakeFriend
//
//  Created by dianji on 13-9-2.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
@interface EditPersonInfoViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *litleImageBut;
    UITextField *nickNameText;
    UITextField *birthText;
    UITextField *sexText;
    UITextField *signatureText;
    UITextField *addressText;

}
@property(nonatomic,strong)UIImage *selctedImage;
@property(nonatomic,strong)PhotoInfo *_personInfo;
@end
