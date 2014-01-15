//
//  AddInfo.m
//  ONE
//
//  Created by dianji on 13-7-9.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AddInfo.h"

@implementation AddInfo
@synthesize adName;
@synthesize adContent;
@synthesize adDate;
@synthesize adPictureUrl;

-(void)dealloc
{
    RELEASE_SAFELY(adContent);
    RELEASE_SAFELY(adDate);
    RELEASE_SAFELY(adName);
    RELEASE_SAFELY(adPictureUrl);
 
    [super dealloc];
}
@end
