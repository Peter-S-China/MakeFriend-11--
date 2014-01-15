//
//  ClassNameListViewController.h
//  ONE
//
//  Created by dianji on 13-1-31.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageInfo.h"
@interface ClassNameListViewController : JUJUViewController
{
    UIButton*but;
    MessageInfo*classNameLIstinfo;
    NSMutableArray*classNamearray;
   
}
@property(nonatomic, strong) NSDictionary *classDict;
@property(nonatomic, strong) NSArray *titleArray;
@end
