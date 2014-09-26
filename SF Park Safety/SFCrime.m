//
//  SFCrime.m
//  SF Park Safety
//
//  Created by Josh Woods on 9/20/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import "SFCrime.h"

@implementation SFCrime

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.category = dict[@"category"];
        self.crimeDescription = dict[@"descript"];
        self.dayOfWeek = dict[@"dayofweek"];
        self.timestamp = dict[@"date"];
        self.latitude = dict[@"y"];
        self.longitude = dict[@"x"];

    }
    return self;
}

@end
