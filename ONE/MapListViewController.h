//
//  MapListViewController.h
//  ONE
//
//  Created by dianji on 12-12-6.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JUJUViewController.h"
#import "RegexKitLite.h"
#import "Place.h"
#import "PlaceMark.h"
@interface MapListViewController :JUJUViewController <MKMapViewDelegate,CLLocationManagerDelegate>
{
    
    MKMapView * myMapView;
    CLLocationManager *_locationManager;
    NSMutableArray *_annomations;
    NSArray* routes;
    UIImageView* routeView;
    Place *local;
    Place* toDest;
}

@property (nonatomic, retain) NSMutableArray *infos;

-(void) showRouteFrom: (Place*) f to:(Place*) t;

@end
