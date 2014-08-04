//
//  DetailPersonalInfoViewController.h
//  MakeFriend
//
//  Created by dianji on 13-8-28.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"
@interface DetailPersonalInfoViewController : UIViewController
{
    UIView *navView;
    UILabel *titleLabel;
    UIButton *rightButton;
    UIButton *leftButton;
 
}
@property(nonatomic,strong)PhotoInfo *info;
@property(nonatomic,copy)NSString *constellatory;
@end
