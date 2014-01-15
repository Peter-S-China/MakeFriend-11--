//
//  Catogry.m
//  ONE
//
//  Created by dianji on 13-2-22.
//  Copyright (c) 2013年 dianji. All rights reserved.
//

#import "Catogry.h"

@implementation Catogry

- (void)dealloc
{
    RELEASE_SAFELY(_name);
    [super dealloc];
}
@end
