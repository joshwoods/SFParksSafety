
//  Created by Josh Woods on 8/20/14.
//  Copyright (c) 2014 sdoowhsoj. All rights reserved.
//

@import MapKit;
#import <UIKit/UIKit.h>
#import "SFParks.h"

@interface MapViewController : UIViewController

@property (nonatomic, weak) SFParks *park;
@property (nonatomic, assign) MKCoordinateRegion *boundingRegion;

@end
