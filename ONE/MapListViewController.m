//
//  ListViewController.m
//  ONE
//
//  Created by dianji on 12-12-6.
//  Copyright (c) 2012年 dianji. All rights reserved.
//

#import "MapListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JJAnnotation.h"
@interface MapListViewController ()

@end

@implementation MapListViewController

@synthesize infos;
- (void)dealloc
{
    if(routes) {
    [routes release];
               }
    [_locationManager stopUpdatingLocation];
    RELEASE_SAFELY(_locationManager);
    RELEASE_SAFELY(infos);
    RELEASE_SAFELY(_annomations);
    RELEASE_SAFELY(routeView);
    RELEASE_SAFELY(myMapView);
    [super dealloc];
}
#pragma mark - Customs Methods

//添加大头针
- (void)addAnnotations
{
    local=[[[Place alloc]init]autorelease];
    local.name=@"当前位置";
    local.latitude= [UserLocation sharedUserLocation].antitude;
    local.longitude=[UserLocation sharedUserLocation].longtitude;
    
//如果是传过来一个数组，表明是首页调用
    if ([infos count]>1) {
        for(MessageInfo*info in infos){
            toDest=[[[Place alloc]init]autorelease];
            PlaceMark* from = [[[PlaceMark alloc] initWithPlace:toDest] autorelease];
            [myMapView addAnnotation:from];
        }
    }
    else{
    for (MessageInfo *info in infos) {
        toDest=[[[Place alloc]init]autorelease];        
            NSArray*locationArray=[info.location componentsSeparatedByString:@","];
            
        toDest.latitude=[[locationArray objectAtIndex:1]floatValue];
        toDest.longitude=[[locationArray objectAtIndex:0]floatValue];

    }
    
    [self showRouteFrom:local to:toDest];
    }
}

-(void)initMap
{
    //创建一个地图
    myMapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
    myMapView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [myMapView setMapType:MKMapTypeStandard];
    myMapView.showsUserLocation=YES;
    //设置地图显示区域
    CLLocationCoordinate2D center={
        .latitude=40,
        .longitude=116.3466
    };
    //设定显示范围
    MKCoordinateSpan span={
        .latitudeDelta=0.1,
        .longitudeDelta=0.1
        
    };
    MKCoordinateRegion region = {center,span};
    [myMapView setRegion:region animated:YES];
    
    [self.view addSubview:myMapView];
    //加大头针
    myMapView.delegate=self;
    //现在添加大头针
    [self addAnnotations];
    
}
-(void)backButtonClicked:(UIButton*)sender
{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration =0.4;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}
/**///路线图
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
    CLLocation *first = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ] autorelease];
    CLLocation *end = [[[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ] autorelease];
	[array insertObject:first atIndex:0];
    [array addObject:end];
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	NSString *saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString *daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	NSString *apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL *apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:apiUrl];
    request.timeOutSeconds = 10;
    [request startSynchronous];
    if (request.error) {
        NSLog(@"error = %@",[request.error description]);
        return nil;
    }
	NSString *apiResponse = request.responseString;
	NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	return [self decodePolyLine:[[encodedPoints mutableCopy] autorelease] :f to:t];
}
-(void) updateRouteView {
    [myMapView removeOverlays:myMapView.overlays];
    
    CLLocationCoordinate2D pointsToUse[[routes count]];
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
    [myMapView addOverlay:lineOne];

}

-(void) showRouteFrom: (Place*) f to:(Place*) t {
	
	if(routes) {
		[myMapView removeAnnotations:[myMapView annotations]];
		[routes release];
	}
	
	PlaceMark* from = [[[PlaceMark alloc] initWithPlace:f] autorelease];

	PlaceMark* to = [[[PlaceMark alloc] initWithPlace:t] autorelease];
    
    [myMapView addAnnotation:from];
	[myMapView addAnnotation:to];
	
	routes = [[self calculateRoutesFrom:from.coordinate to:to.coordinate] retain];
	[self updateRouteView];
	//[self initMap];
}
/**///路线图
- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加上返回按钮
    UIButton*left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setBackgroundImage:[UIImage imageNamed:@"back_norm.png"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 8, 60,30);
    [left setTitle:@"返回" forState:UIControlStateNormal];
    [left setTitle:@"返回" forState:UIControlStateHighlighted];
    left.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    [left addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    self.navigationItem.leftBarButtonItem = item1;
    [item1 autorelease];
    
	self.title=@"地图";
    [self initMap];
    //初始化定位
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1000.0;
    [_locationManager startUpdatingLocation];
   



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -MKMapViewDelegate
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 左边一个UIView 右边一个button
    NSString *AnnotationID = @"PinViewStyle";
    if (![_annomations containsObject:annotation]) {
        return nil;
    }
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationID];
    if (pinView == nil) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationID] autorelease];
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        UIImageView *leftView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)] autorelease];
        leftView.image = [UIImage imageNamed:@"map0.png"];
        
        UIButton *rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
        pinView.leftCalloutAccessoryView = leftView;
        pinView.rightCalloutAccessoryView = rightButton;
        pinView.pinColor = MKPinAnnotationColorGreen;
        
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}


#pragma mark -CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //设置地图显示区域
    CLLocationCoordinate2D center={
        .latitude = newLocation.coordinate.latitude,
        .longitude = newLocation.coordinate.longitude
    };
    //设定显示范围
    MKCoordinateSpan span={
        .latitudeDelta=0.1,
        .longitudeDelta=0.1
        
    };
    MKCoordinateRegion region = {center,span};
    [myMapView setRegion:region animated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locError:%@", error);
    
}
#pragma mark mapView delegate functions
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[[MKPolylineView alloc] initWithOverlay:overlay] autorelease] ;
        //路线颜色
        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.9];
        lineview.lineWidth=8.0;
        return lineview;
    }
    return nil;
}
@end
