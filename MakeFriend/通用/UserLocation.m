//
//  UserLocation.m
//  ONE
//
//  Created by Liang Wei on 12/25/12.
//  Copyright (c) 2012 dianji. All rights reserved.
//

#import "UserLocation.h"

static UserLocation *sharedUserLocation = nil;

@implementation UserLocation

@synthesize longtitude = _longtitude;
@synthesize antitude = _antitude;
@synthesize locationSucsess = _locationSucsess;

- (void)dealloc
{
    [_locationManager stopUpdatingLocation];
    RELEASE_SAFELY(_locationManager);
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        //初始化定位
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0;
        _locationSucsess = NO;
    }
    return self;
}

+ (UserLocation *)sharedUserLocation
{
    @synchronized(self)
    {
        if (!sharedUserLocation) {
            sharedUserLocation = [[self alloc] init];
        }
    }
    return sharedUserLocation;
}
- (void)startGetLocation
{
    [_locationManager startUpdatingLocation];
}
- (void)stopGetLocation
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    _longtitude = newLocation.coordinate.longitude;
    _antitude = newLocation.coordinate.latitude;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:_longtitude forKey:@"USER_LOCATION_LONG"];
    [defaults setFloat:_antitude forKey:@"USER_LOCATION_ANTITUDE"];
    _locationSucsess = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locError:%@", error);
    _locationSucsess = NO;
}



@end
