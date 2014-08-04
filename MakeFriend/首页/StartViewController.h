//
//  StartViewController.h
//  MakeFriend
//
//  Created by dianji on 13-7-16.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"MFViewController.h"
#import "BSPhotoWall.h"
@interface StartViewController : MFViewController<UIScrollViewDelegate,BSWaterViewDataSourse,BSPhotoViewDelegate,UITextFieldDelegate>
{
@private
    BSPhotoWall *_photoWall;
    float _beginDrag;
    NSMutableArray *_dataArray;
    BOOL _isEnterNextView;
@public
    UIView *startNavView;
    
    
}


@end
