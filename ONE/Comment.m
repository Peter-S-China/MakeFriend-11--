//
//  Comment.m
//  ONE
//
//  Created by dianji on 13-1-21.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@synthesize userName;
@synthesize eventId;
@synthesize commentTime;
@synthesize contents;

-(void)dealloc
{
    RELEASE_SAFELY(userName);
    RELEASE_SAFELY(eventId);
    RELEASE_SAFELY(commentTime);
    RELEASE_SAFELY(contents);

    [super dealloc];
}

@end
