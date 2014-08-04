//
//  UserLocation.h
//  ONE
//
//  Created by Liang Wei on 12/25/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserLocation : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@property (nonatomic, assign) float longtitude;
@property (nonatomic, assign) float antitude;
@property (nonatomic, assign) BOOL locationSucsess;//标记位置信息是否获取成功

+ (UserLocation *)sharedUserLocation;
- (void)startGetLocation;
- (void)stopGetLocation;

@end
