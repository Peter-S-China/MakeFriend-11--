//
//  preViewViewController.h
//  ONE
//
//  Created by dianji on 13-5-10.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "JUJUViewController.h"

@interface preViewViewController : JUJUViewController
{
    UIImageView*imageview1;
}
@property(nonatomic,strong)UIImage * _image;
@property(nonatomic,copy)NSString * _titlle;
@property(nonatomic,copy)NSString * _time;
@property(nonatomic,copy)NSString * _address;
@property(nonatomic,copy)NSString * _tel;
@property(nonatomic,copy)NSString * _abstrct;


@end
