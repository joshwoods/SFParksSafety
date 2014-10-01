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
#import "ParkDetailViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndictor;

@end

@implementation ViewController
{
    NSString *userLatitude;
    NSString *userLongitude;
    CABasicAnimation *theAnimation;
}

#pragma mark - IBAction

- (IBAction)textEntered:(id)sender
{
    self.textFieldString = self.textField.text;
    NSLog(@"%@", self.textFieldString);
    if ([self.textFieldString length] > 0) {
        self.textfieldSearchButton.enabled = YES;
    } else {
        self.textfieldSearchButton.enabled = NO;
    }
}

- (IBAction)textfieldSearchButtonPressed:(id)sender
{
    NSLog(@"TextField Search Pressed");
    [self loadingSetup];
    dispatch_async(kBgQueue, ^{
        [self forwardGeocode];
    });
}

- (IBAction)gpsSearchButtonPressed:(id)sender
{
    NSLog(@"GPS Search Pressed");
    [self loadingSetup];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - Views Loading

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //color the tree button
    self.activityIndictor.alpha = 0;
    
    self.textField.delegate = self;
    UIImage *tree = [UIImage imageNamed:@"tree73"];
    self.treeImage.image = tree;
    self.treeImage.image = [self.treeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.treeImage setTintColor:[UIColor nephritisColor]];
    
    self.gpsSearchButton.tintColor = [UIColor cloudsColor];
    self.textfieldSearchButton.tintColor = [UIColor cloudsColor];
    self.viewDetails.tintColor = [UIColor cloudsColor];
    self.closestParkNameLabel.tintColor = [UIColor cloudsColor];
    self.closestParkNameLabel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.closestParkNameLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.theClosestParkIs.textColor = [UIColor cloudsColor];
    
    self.view.backgroundColor = [UIColor wetAsphaltColor];
    
    self.textfieldSearchButton.enabled = NO;
    
    self.viewDetails.alpha = 0;
    self.closestParkNameLabel.alpha = 0;
    self.theClosestParkIs.alpha = 0;
    
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Geocoding

- (void)forwardGeocode
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.textFieldString completionHandler:^(NSArray *placemarks, NSError *error){
        NSLog(@"Finding LAT/LONG");
        if([placemarks count]){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            userLatitude = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
            userLongitude = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
            NSLog(@"%@ %@", userLatitude, userLongitude);
            NSString *crimeURLString = @"http://data.sfgov.org/resource/tmnf-yvry.json";
            NSURL *crimeURL = [NSURL URLWithString:crimeURLString];
            dispatch_async(kBgQueue, ^{
                NSData* crimeData = [NSData dataWithContentsOfURL:crimeURL];
                [self performSelectorOnMainThread:@selector(fetchedCrimeData:) withObject:crimeData waitUntilDone:YES];
            });
        } else {
            [self performSelector:@selector(noLocationAlert) withObject:nil afterDelay:5];
            NSLog(@"didFailWithError: %@", error);
        }
    }];
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
    [self failedLoadSetup];
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

-(void)fetchedCrimeData:(NSData *)responseData
{
    if(responseData)
    {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:&error];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        self.allCrimesArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in json) {
            SFCrime *crime = [[SFCrime alloc] initWithDictionary:dict];
            NSTimeInterval timestamp = [crime.timestamp integerValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
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
    } else
    {
        FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                    initWithTitle:nil message:@"Looks like there is an issue with your connection and we were unable to get the necesary data.\n\nPlease try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        errorAlert.titleLabel.textColor = [UIColor cloudsColor];
        errorAlert.messageLabel.textColor = [UIColor cloudsColor];
        errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        errorAlert.defaultButtonColor = [UIColor cloudsColor];
        errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
        errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
        [self.locationManager stopUpdatingLocation];
        [self failedLoadSetup];
        [errorAlert show];
    }
}

-(void)fetchedTreeData:(NSData *)responseData
{
    //if response data exists, then move on
    if(responseData)
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
                        if (parkCrimeDistance < 1609) {
                            crime.distanceFromPark = [NSString stringWithFormat:@"%f", parkCrimeDistance];
                            [park.nearbyCrimes addObject:crime];
//                            NSLog(@"%@ %@", park.parkName, crime.distanceFromPark);
//                            NSLog(@" This park has %lu crimes", (unsigned long)[park.nearbyCrimes count]);
                        }
                    }
                    NSNumber *nearbyCrimeCount = [[NSNumber alloc] initWithDouble:[park.nearbyCrimes count]];
                    NSNumber *allCrimeCount = [[NSNumber alloc] initWithDouble:[self.allCrimesArray count]];
                    NSNumber *crimeRating = @(([nearbyCrimeCount floatValue]/[allCrimeCount floatValue]) * 100);
                    park.crimeRating = [NSString stringWithFormat:@"%@", crimeRating];
                    [self.allParksArray addObject:park];
                }
            }
        }
        
        self.intermediateArray = [[NSMutableArray alloc] init];
        
        for (SFParks *parks in self.allParksArray) {
            if ([parks.distanceFromUser intValue] < 804) {
                [self.intermediateArray addObject:parks];
            }
        }
        
        //sorting!
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"intDistanceFromUser" ascending:YES];
        
        self.parksNearUser = [[self.intermediateArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]mutableCopy];
        
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
            [self failedLoadSetup];
            [errorAlert show];
        } else {
            self.closestPark = self.parksNearUser[0];
            NSLog(@"Name: %@\n Distance from User: %@\n Crime: %@\n", self.closestPark.parkName, self.closestPark.distanceFromUser, self.closestPark.crimeRating);
            for (SFCrime *crime in self.closestPark.nearbyCrimes) {
                NSLog(@"%@", crime.distanceFromPark);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                if ([self.closestPark.distanceFromUser doubleValue] < 805.0) {
                    [self.closestParkNameLabel setTitle:[self.closestPark.parkName capitalizedString] forState:UIControlStateNormal];
                    [self successLoadSetup];
                }
            }];
        }
    } else {
        FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                    initWithTitle:nil message:@"Looks like there is an issue with your connection and we were unable to get the necesary data.\n\nPlease try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        errorAlert.titleLabel.textColor = [UIColor cloudsColor];
        errorAlert.messageLabel.textColor = [UIColor cloudsColor];
        errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        errorAlert.defaultButtonColor = [UIColor cloudsColor];
        errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
        errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
        [self.locationManager stopUpdatingLocation];
        [self.allCrimesArray removeAllObjects];
        [self failedLoadSetup];
        [errorAlert show];
    }
}

#pragma mark - Animations

- (void)loadingSetup
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.activityIndictor startAnimating];
        self.activityIndictor.alpha = 1.0;
        self.textField.alpha = 0.0;
        self.textfieldSearchButton.alpha = 0.0;
        self.gpsSearchButton.alpha = 0.0;
        self.treeImage.alpha = 0.0;
    }];
}

- (void)failedLoadSetup
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.activityIndictor stopAnimating];
        self.activityIndictor.alpha = 0;
        self.textField.alpha = 1.0;
        self.textfieldSearchButton.alpha = 1.0;
        self.gpsSearchButton.alpha = 1.0;
        self.treeImage.alpha = 1.0;
    }];
}

- (void)successLoadSetup
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.activityIndictor stopAnimating];
        self.activityIndictor.alpha = 0;
        self.textField.alpha = 0;
        self.textfieldSearchButton.alpha = 0;
        self.gpsSearchButton.alpha = 0;
        self.treeImage.alpha = 0.5;
        self.viewDetails.alpha = 1.0;
        self.closestParkNameLabel.alpha = 1.0;
        self.theClosestParkIs.alpha = 1.0;
    }];
}

#pragma mark - Segue Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewDetailsSegue"]) {
        TableViewController *controller = segue.destinationViewController;
        controller.allParksArray = self.parksNearUser;
    } else if ([segue.identifier isEqualToString:@"closestDetailSegue"]){
        ParkDetailViewController *controller = segue.destinationViewController;
        controller.navigationController.navigationBarHidden = NO;
        controller.park = self.closestPark;
    }
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
