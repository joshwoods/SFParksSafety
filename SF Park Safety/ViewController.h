//
//  ViewController.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/20/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFParks.h"
@import QuartzCore;
@import MapKit;
@import CoreLocation;


@interface ViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *allCrimesArray;
@property (nonatomic, strong) NSMutableArray *crimesNearParks;
@property (nonatomic, strong) NSMutableArray *allParksArray;
@property (nonatomic, strong) NSMutableArray *intermediateArray;
@property (nonatomic, strong) NSMutableArray *parksNearUser;

@property (nonatomic, strong) IBOutlet UIImageView *treeImage;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) IBOutlet UIButton *textfieldSearchButton;
@property (strong, nonatomic) IBOutlet UIButton *gpsSearchButton;
@property (strong, nonatomic) IBOutlet UIButton *viewDetails;
@property (nonatomic, strong) IBOutlet UIButton *closestParkNameLabel;

@property (nonatomic, strong) IBOutlet UILabel *theClosestParkIs;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) SFParks *closestPark;

@property (nonatomic, strong) NSString *textFieldString;

@end

