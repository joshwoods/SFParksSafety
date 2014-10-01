//
//  TableViewController.m
//  SF Park Safety
//
//  Created by Josh Woods on 9/24/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import "TableViewController.h"
#import "ParkDetailViewController.h"
#import "UIColor+FlatUI.h"
#import "SFTableCell.h"
#import "UITableViewCell+FlatUI.h"

@interface TableViewController ()

@end

@implementation TableViewController

#pragma mark - Views Loading

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor wetAsphaltColor];
    self.tableView.backgroundColor = [UIColor wetAsphaltColor];
    self.navigationController.navigationBar.barTintColor = [UIColor cloudsColor];
    self.navigationController.navigationBar.tintColor = [UIColor wetAsphaltColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    NSLog(@"%lu", (unsigned long)[self.allParksArray count]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allParksArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SFTableCell";
    SFTableCell *cell = (SFTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SFTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIRectCorner corners = 0;
    if (tableView.style == UITableViewStyleGrouped) {
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            corners = UIRectCornerAllCorners;
        } else if (indexPath.row == 0) {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
    }
    SFParks *park = self.allParksArray[indexPath.row];
    [cell configureFlatCellWithColor:[UIColor wetAsphaltColor] selectedColor:[UIColor nephritisColor]];
    cell.nameLabel.text = [park.parkName capitalizedString];
    cell.nameLabel.textColor = [UIColor cloudsColor];
    [cell.nameLabel setHighlightedTextColor:[UIColor wetAsphaltColor]];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f Meters ~ %.2f miles", [park.distanceFromUser floatValue], [park.distanceFromUser floatValue] * 0.000621371192];
    cell.distanceLabel.textColor = [UIColor cloudsColor];
    [cell.distanceLabel setHighlightedTextColor:[UIColor wetAsphaltColor]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.park = self.allParksArray[indexPath.row];
    [self performSegueWithIdentifier:@"selectRowSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectRowSegue"]) {
        ParkDetailViewController *controller = segue.destinationViewController;
        controller.park = self.park;
    }
}

@end
