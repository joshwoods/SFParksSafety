//
//  SFParkLocation.m
//  SF Park Safety
//
//  Created by Josh Woods on 9/21/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import "SFParkLocation.h"

@implementation SFParkLocation

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.latitude = dict[@"latitude"];
        self.longitude = dict[@"longitude"];
    }
    return self;
}

@end
