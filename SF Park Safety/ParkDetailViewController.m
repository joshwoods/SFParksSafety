//
//  ParkDetailViewController.m
//  SF Park Safety
//
//  Created by Josh Woods on 9/25/14.
//  Copyright (c) 2014 joshwoods. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "UIColor+FlatUI.h"
#import "FUIAlertView.h"
#import "UITableViewCell+FlatUI.h"
#import "SFCrime.h"

@interface ParkDetailViewController ()

@end

@implementation ParkDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.crimeScoreView.backgroundColor = [UIColor wetAsphaltColor];
}

- (IBAction)infoButtonPressed:(id)sender{
    FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                initWithTitle:nil message:@"This score is based upon the amount of crimes committed within a mile of this park." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.titleLabel.textColor = [UIColor cloudsColor];
    errorAlert.messageLabel.textColor = [UIColor cloudsColor];
    errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    errorAlert.defaultButtonColor = [UIColor cloudsColor];
    errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
    errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
    [errorAlert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoTableView.delegate = self;
    self.view.backgroundColor = [UIColor wetAsphaltColor];
    UIImage *tree = [UIImage imageNamed:@"tree73"];
    self.infoButton.tintColor = [UIColor cloudsColor];
    self.crimeScoreView.layer.cornerRadius = 5.0;
    self.treeImage.image = tree;
    self.treeImage.image = [self.treeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.treeImage setTintColor:[UIColor nephritisColor]];
    self.nameLabel.textColor = [UIColor cloudsColor];
    self.crimeScore.textColor = [UIColor cloudsColor];
    self.nameLabel.text = [self.park.parkName capitalizedString];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self performSelector:@selector(changeCrimeScoreViewBG) withObject:nil afterDelay:0.1];
}

- (void)changeCrimeScoreViewBG{
    [UIView animateWithDuration:0.2 animations:^{
        self.crimeScoreView.backgroundColor = [UIColor redColor];
    }];
}

#pragma mark TableView Info

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    SFCrime *crime = self.park.nearbyCrimes[indexPath.row];
    [cell configureFlatCellWithColor:[UIColor wetAsphaltColor] selectedColor:[UIColor nephritisColor]];
    cell.textLabel.text = crime.crimeDescription;
    cell.textLabel.textColor = [UIColor cloudsColor];
    cell.detailTextLabel.text = crime.actualDate;
    cell.detailTextLabel.textColor = [UIColor cloudsColor];
    [cell.textLabel setHighlightedTextColor:[UIColor wetAsphaltColor]];
    [cell.detailTextLabel setHighlightedTextColor:[UIColor wetAsphaltColor]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. This is hard coded because there will only ever be 1 section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. This is hardcoded because there will only ever be 4 rows
    return [self.park.nearbyCrimes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"HI");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
