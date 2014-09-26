//
//  SFTableCell.h
//  SF Park Safety
//
//  Created by Josh Woods on 9/25/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@end
