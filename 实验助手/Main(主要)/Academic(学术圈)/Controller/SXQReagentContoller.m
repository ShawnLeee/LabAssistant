//
//  SXQReagentContoller.m
//  实验助手
//
//  Created by sxq on 15/9/14.
//  Copyright (c) 2015年 SXQ. All rights reserved.
//
@import MapKit;
#import "SXQReagentContoller.h"
#import "SXQAnnotation.h"
#import "SXQAnnotationView.h"
@interface SXQReagentContoller ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,assign) CGFloat regionRadius;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation SXQReagentContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    _regionRadius = 1000;
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:31.13 longitude:121.26];
    [self centerMapOnLocation:initialLocation];
    [self addMyAnnotation];
    [self locateSelf];
    _mapView.showsUserLocation = YES;
    
}
- (void)locateSelf
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    
}
- (void)addMyAnnotation
{
    SXQAnnotation *annotation = [SXQAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake(31.13, 121.26);
    annotation.title = @"first show";
    [_mapView addAnnotation:annotation];
}
- (void)centerMapOnLocation:(CLLocation *)location
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, _regionRadius * 2.0, _regionRadius * 2.0);
    [_mapView setRegion:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotionView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sss"];
    annotionView.pinColor = MKPinAnnotationColorGreen;
    annotionView.canShowCallout = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    annotionView.rightCalloutAccessoryView = button;
    return annotionView;
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currenLocation = [locations firstObject];
    SXQAnnotation *annotation = [[SXQAnnotation alloc] init];
    annotation.coordinate = currenLocation.coordinate;
    [_mapView addAnnotation:annotation];
}
@end
