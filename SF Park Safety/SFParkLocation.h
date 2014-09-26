//
//  SFParkLocation.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/21/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFParkLocation : NSObject

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
