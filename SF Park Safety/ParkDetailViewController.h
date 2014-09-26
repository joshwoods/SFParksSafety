//
//  ParkDetailViewController.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/25/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFParks.h"

@interface ParkDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *treeImage;
@property (nonatomic, weak) IBOutlet UITableView *infoTableView;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, weak) IBOutlet UIButton *phoneButton;
@property (nonatomic, weak) IBOutlet UILabel *parkTypeLabel;
@property (nonatomic, weak) IBOutlet UIView *crimeScoreView;
@property (nonatomic, weak) IBOutlet UILabel *crimeScore;

@property (nonatomic, strong) SFParks *park;

@end
