//
//  Created by Josh Woods on 8/20/14.
//  Copyright (c) 2014 sdoowhsoj. All rights reserved.
//

#import "MapViewController.h"
#import "UIColor+FlatUI.h"

@interface MapViewController () <MKMapViewDelegate, UINavigationBarDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UINavigationBar *navBar;

@end

@implementation MapViewController
{
    MKPlacemark *_globalPlacemark;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)closeScreen:(id)sender{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)getDirections
{
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:_globalPlacemark];
    [mapItem openInMapsWithLaunchOptions:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navBar.barTintColor = [UIColor cloudsColor];
    self.navBar.tintColor = [UIColor wetAsphaltColor];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.park.parkLatitude doubleValue] longitude:[self.park.parkLongitude doubleValue]];
    [self updateMapView:location];
    CLLocation *parkLocation = [[CLLocation alloc] initWithLatitude:[self.park.parkLatitude doubleValue] longitude:[self.park.parkLongitude doubleValue]];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:parkLocation.coordinate addressDictionary:nil];
    _globalPlacemark = placemark;
    [self.mapView addAnnotation:placemark];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    [self.mapView selectAnnotation:[[self.mapView annotations] firstObject] animated:YES];
//}

- (void)updateMapView:(CLLocation *)location
{
    MKCoordinateRegion region;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.latitudeDelta = 0.001;
    region.span.longitudeDelta = 0.001;
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)dealloc
{
    NSLog(@"Dealloc %@", self);
}

@end
