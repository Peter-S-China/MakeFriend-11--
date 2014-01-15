//
//  JJAnnotation.h
//  ONE
//
//  Created by dianji on 12-12-17.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MessageInfo.h"

@interface JJAnnotation : NSObject<MKAnnotation>

@property(nonatomic, retain) MessageInfo *_info;

-(id)initWithInfo:(MessageInfo *)info;
+(id)annotationWithMessage:(MessageInfo *)info;

@end
