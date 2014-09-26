//
//  SFCrime.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/20/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface SFCrime : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *crimeDescription;
@property (nonatomic, strong) NSString *dayOfWeek;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *actualDate;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *distanceFromPark;
@property (nonatomic, assign) int intDistanceFromPark;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
