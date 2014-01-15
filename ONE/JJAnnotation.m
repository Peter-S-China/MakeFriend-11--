//
//  JJAnnotation.m
//  ONE
//
//  Created by dianji on 12-12-17.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "JJAnnotation.h"

@implementation JJAnnotation
@synthesize _info;

-(void)dealloc
{
    self._info=nil;
    [super dealloc];
    
    
}

-(id)init
{
    return [self initWithInfo:nil];
}

-(id)initWithInfo:(MessageInfo *)info
{
    self=[super init];
    if (self) {
        self._info = info;
    }
    return self;
    
}
+(id)annotationWithMessage:(MessageInfo *)info
{
    
    return [[[[self class]alloc]initWithInfo:info]autorelease];
    
}

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D center;
    NSArray*titude=[_info.location componentsSeparatedByString:@","];
    if ([titude count] > 1) {
        center.latitude = [[titude objectAtIndex:1]doubleValue];
        center.longitude = [[titude objectAtIndex:0]doubleValue];
        NSLog(@"xxx = %f ===== %f",center.latitude,center.longitude);
    }
    else
    {
        center.latitude=40;
        center.longitude=116;
    }
    
    
    return center;
}
-(NSString*)title
{
    if (_info) {
        return [NSString stringWithString:_info.className];
    }
    return nil;
}

-(NSString*)subtitle
{
    if (_info) {
        return [NSString stringWithString:_info.buttonTitle];
    }
    return nil;
}


@end
