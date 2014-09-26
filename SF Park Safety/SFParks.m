//
//  SFParks.m
//  SF Park Safety
//
//  Created by Josh Woods on 9/20/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import "SFParks.h"

@implementation SFParks

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.parkType = dict[@"parktype"];
        self.parkName = dict[@"parkname"];
        self.phoneNumber = dict[@"number"];
        NSDictionary *location = dict[@"location_1"];
        self.parkLatitude = [location objectForKey:@"latitude"];
        self.parkLongitude = [location objectForKey:@"longitude"];
        self.nearbyCrimes = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
