//
//  ViewController.m
//  SF Park Safety
//
//  Created by Josh Woods on 9/20/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "ViewController.h"
#import "SFCrime.h"
#import "UIColor+FlatUI.h"
#import "FUIAlertView.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSString *userLatitude;
    NSString *userLongitude;
    CABasicAnimation *theAnimation;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self theAnimation];
    self.treeButton.tintColor = [UIColor nephritisColor];
    self.nearbyParksButton.tintColor = [UIColor cloudsColor];
    self.viewDetails.tintColor = [UIColor cloudsColor];
    self.allParksButton.tintColor = [UIColor cloudsColor];
    self.closestParkNameLabel.tintColor = [UIColor cloudsColor];
    self.closestParkNameLabel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.closestParkNameLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.theClosestParkIs.textColor = [UIColor cloudsColor];
    self.view.backgroundColor = [UIColor wetAsphaltColor];
    self.viewDetails.hidden = YES;
    self.closestParkNameLabel.alpha = 0;
    self.theClosestParkIs.alpha = 0;
    
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)theAnimation
{
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
}

- (IBAction)nearbyPressed:(id)sender
{
    NSLog(@"Nearby Pressed");
    //    [self getTreeData];
    [self.locationManager startUpdatingLocation];
}

- (IBAction)allPressed:(id)sender
{
    NSLog(@"All pressed");
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self performSelector:@selector(noLocationAlert) withObject:nil afterDelay:5];
    NSLog(@"didFailWithError: %@", error);
}

- (void)noLocationAlert
{
    FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                initWithTitle:@"Uh oh..." message:@"Looks like there is an error getting your location.\n\n Check your settings or try again later!\n\n If the problem persists, please contact me ASAP on twitter @sdoowhsoj!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.titleLabel.textColor = [UIColor cloudsColor];
    errorAlert.messageLabel.textColor = [UIColor cloudsColor];
    errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    errorAlert.defaultButtonColor = [UIColor cloudsColor];
    errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
    errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
    [self.locationManager stopUpdatingLocation];
    //    [self.activityIndicator stopAnimating];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@ old %@", newLocation, oldLocation);
    CLLocation *currentLocation = newLocation;
    userLatitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    userLongitude = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
    
    NSString *crimeURLString = @"http://data.sfgov.org/resource/tmnf-yvry.json";
    NSURL *crimeURL = [NSURL URLWithString:crimeURLString];
    dispatch_async(kBgQueue, ^{
        NSData* crimeData = [NSData dataWithContentsOfURL:crimeURL];
        [self performSelectorOnMainThread:@selector(fetchedCrimeData:) withObject:crimeData waitUntilDone:YES];
    });
}

#pragma mark - JSON Parsing

-(void)fetchedTreeData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    //filtering out nil data and figuring the distance between the user and the parks
    self.allParksArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in json) {
        SFParks *park = [[SFParks alloc] initWithDictionary:dict];
        if (![park.parkName isEqualToString:@"ParkName"]) {
            if(!(park.parkLatitude == nil)){
                CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:[userLatitude doubleValue] longitude:[userLongitude doubleValue]];
                CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:[park.parkLatitude doubleValue] longitude:[park.parkLongitude doubleValue]];
                CLLocationDistance userParkDistance = [secondLocation distanceFromLocation:firstLocation];
                park.distanceFromUser = [NSString stringWithFormat:@"%f", userParkDistance];
                park.intDistanceFromUser = [park.distanceFromUser intValue];
                for (SFCrime *crime in self.allCrimesArray) {
                    CLLocation *parkLocation = [[CLLocation alloc] initWithLatitude:[park.parkLatitude doubleValue] longitude:[park.parkLongitude doubleValue]];
                    CLLocation *crimeLocation = [[CLLocation alloc] initWithLatitude:[crime.latitude doubleValue] longitude:[crime.longitude doubleValue]];
                    CLLocationDistance parkCrimeDistance = [crimeLocation distanceFromLocation:parkLocation];
                    crime.distanceFromPark = [NSString stringWithFormat:@"%f", parkCrimeDistance];
                    crime.intDistanceFromPark = [crime.distanceFromPark intValue];
                    if ([crime.distanceFromPark intValue] < 1609) {
                        [park.nearbyCrimes addObject:crime];
                    }
                }
                park.crimeRating = [NSString stringWithFormat:@"%lu", [park.nearbyCrimes count]];
                [self.allParksArray addObject:park];
                
            }
        }
    }
    
    //        [self.activityIndicator stopAnimating];
    
    self.intermediateArray = [[NSMutableArray alloc] init];
    
    for (SFParks *parks in self.allParksArray) {
        if ([parks.distanceFromUser intValue] < 804) {
            [self.intermediateArray addObject:parks];
        }
    }
    
    
    //sorting!
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"intDistanceFromUser" ascending:YES];
    
    self.parksNearUser = [[self.intermediateArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]mutableCopy];
    
    //    self.parksNearUser = [[self.intermediateArray sortedArrayUsingComparator:^NSComparisonResult(SFParks *obj1, SFParks *obj2) {
    //        return [obj1.intDistanceFromUser compare:obj2.intDistanceFromUser];
    //    }] mutableCopy];
    
    if ([self.parksNearUser count] == 0) {
        FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                    initWithTitle:@"Uh oh..." message:@"There are no parks near you within a half mile!\n\n Try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        errorAlert.titleLabel.textColor = [UIColor cloudsColor];
        errorAlert.messageLabel.textColor = [UIColor cloudsColor];
        errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        errorAlert.defaultButtonColor = [UIColor cloudsColor];
        errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
        errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
        [errorAlert show];
    } else {
        self.closestPark = self.parksNearUser[0];
        NSLog(@"Name: %@\n Distance from User: %@\n Crime: %lu", self.closestPark.parkName, self.closestPark.distanceFromUser, (unsigned long)[self.closestPark.nearbyCrimes count]);
        
        
        [UIView animateWithDuration:0.5 animations:^{
            self.treeButton.alpha = 0.5;
            if ([self.closestPark.distanceFromUser doubleValue] < 805.0) {
                [self.closestParkNameLabel setTitle:[self.closestPark.parkName capitalizedString] forState:UIControlStateNormal];
                self.closestParkNameLabel.alpha = 1.0;
                self.theClosestParkIs.alpha = 1.0;
                self.nearbyParksButton.hidden = YES;
                self.viewDetails.hidden = NO;
                [self.viewDetails.layer addAnimation:theAnimation forKey:@"animateOpacity"];
                self.nearbyParksButton.enabled = NO;
            }
        }];
    }
}

-(void)fetchedCrimeData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    NSLog(@"%@", json);
    self.allCrimesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in json) {
        SFCrime *crime = [[SFCrime alloc] initWithDictionary:dict];
        NSTimeInterval timestamp = [crime.timestamp integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        crime.actualDate = [formatter stringFromDate:date];
        [self.allCrimesArray addObject:crime];
    }
    
    NSLog(@"There are %lu total crimes", (unsigned long)[self.allCrimesArray count]);
    
    NSString *treeURLString = @"http://data.sfgov.org/resource/z76i-7s65.json";
    NSURL *treeURL = [NSURL URLWithString:treeURLString];
    dispatch_async(kBgQueue, ^{
        NSData* treeData = [NSData dataWithContentsOfURL:treeURL];
        [self performSelectorOnMainThread:@selector(fetchedTreeData:) withObject:treeData waitUntilDone:YES];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewDetailsSegue"]) {
        TableViewController *controller = segue.destinationViewController;
        controller.allParksArray = self.parksNearUser;
    }
    
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
