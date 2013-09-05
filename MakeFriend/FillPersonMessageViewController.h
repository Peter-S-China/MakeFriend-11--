//
//  FillPersonMessageViewController.h
//  MakeFriend
//
//  Created by dianji on 13-8-28.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillPersonMessageViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIButton *takePhoto;
    UIImage *selctedimage;//被选中的照片
    UITextField *nickTextFild;
}
@property(nonatomic,strong)UIImage *selctedImage;
@end
