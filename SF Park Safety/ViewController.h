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
@import CoreLocation;


@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong) NSDictionary *crimesDict;
@property (nonatomic, strong) NSMutableArray *allCrimesArray;
@property (nonatomic, strong) NSMutableArray *crimesNearParks;
@property (strong) NSDictionary *parksDict;
@property (nonatomic, strong) NSMutableArray *allParksArray;
@property (nonatomic, strong) NSMutableArray *intermediateArray;
@property (nonatomic, strong) NSMutableArray *parksNearUser;
@property (nonatomic, strong) IBOutlet UIButton *treeButton;
@property (strong, nonatomic) IBOutlet UIButton *nearbyParksButton;
@property (strong, nonatomic) IBOutlet UIButton *viewDetails;
@property (strong, nonatomic) IBOutlet UIButton *allParksButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) SFParks *closestPark;
@property (nonatomic, strong) IBOutlet UIButton *closestParkNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *theClosestParkIs;

@end

