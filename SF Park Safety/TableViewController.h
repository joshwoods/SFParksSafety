//
//  TableViewController.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/24/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFParks.h"

@interface TableViewController : UITableViewController

@property (nonatomic, strong) SFParks *park;

@property (nonatomic, strong) NSMutableArray *allParksArray;

@end
