//
//  AllWishInfo.m
//  MakeFriend
//
//  Created by dianji on 13-8-29.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "AllWishInfo.h"

@implementation AllWishInfo
@synthesize wishContent,wishLittelImageUrl;

- (void)dealloc
{
    self.wishId = nil;
    self.wishContent = nil;
    self.wishTime = nil;
    self.wishLittelImageUrl = nil;
    self.allCommentInfos = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.allCommentInfos = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

@end
