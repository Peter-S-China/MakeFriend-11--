//
//  MessageInfo.m
//  ONE
//
//  Created by dianji on 12-11-29.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

@synthesize buttonTitle;
@synthesize photoURL;
@synthesize startTime;
@synthesize endTime;
@synthesize attention;
@synthesize abstract;
@synthesize dest;
@synthesize className;
@synthesize location;
@synthesize joinedNumber;
@synthesize idNumber;
@synthesize tel;
@synthesize detailPhotoURL;
-(void)dealloc
{
    RELEASE_SAFELY(buttonTitle);
    RELEASE_SAFELY(photoURL);
    RELEASE_SAFELY(startTime);
    RELEASE_SAFELY(endTime);
    RELEASE_SAFELY(attention);
    RELEASE_SAFELY(abstract);
    RELEASE_SAFELY(dest);
    RELEASE_SAFELY(location);
    RELEASE_SAFELY(idNumber);
    RELEASE_SAFELY(tel);
    [super dealloc];
}
@end
