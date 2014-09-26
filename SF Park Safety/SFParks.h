//
//  SFParks.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/20/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFParkLocation.h"

@interface SFParks : NSObject

@property (nonatomic, strong) NSString *parkType;
@property (nonatomic, strong) NSString *parkName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSDictionary *location;
@property (nonatomic, strong) NSString *parkLatitude;
@property (nonatomic, strong) NSString *parkLongitude;
@property (nonatomic, strong) NSString *distanceFromUser;
@property (nonatomic, assign) int intDistanceFromUser;
@property (nonatomic, strong) NSMutableArray *nearbyCrimes;
@property (nonatomic, strong) NSString *crimeRating;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
