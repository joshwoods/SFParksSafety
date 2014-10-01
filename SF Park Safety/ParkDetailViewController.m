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
#import "MapViewController.h"

@interface ParkDetailViewController () <UIAlertViewDelegate>

@end

@implementation ParkDetailViewController

#pragma mark - IBActions

- (IBAction)showMapView:(id)sender{
    [self performSegueWithIdentifier:@"mapViewSegue" sender:self];
}

- (IBAction)phoneButtonPressed:(id)sender
{
    UIAlertView *phoneAlert = [[UIAlertView alloc]
                               initWithTitle:@"Are you sure?" message:@"You are about to call this park...click okay to proceed!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay!", nil];
    [phoneAlert show];
}

- (IBAction)infoButtonPressed:(id)sender{
    FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                initWithTitle:nil message:@"This score is based upon the percentage of crimes committed throughout San Francisco within a mile of this park.\n\n0 - 25: Green\n26-50: Yellow\n51-75: Orange\n76-100: Red" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.titleLabel.textColor = [UIColor cloudsColor];
    errorAlert.messageLabel.textColor = [UIColor cloudsColor];
    errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    errorAlert.defaultButtonColor = [UIColor cloudsColor];
    errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
    errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
    [errorAlert show];
}

#pragma mark - Views Loading

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor wetAsphaltColor];
    self.crimeScoreView.backgroundColor = [UIColor wetAsphaltColor];
    self.parkTypeLabel.text = [self.park.parkType capitalizedString];
    self.infoButton.alpha = 0;
    self.phoneNumberHeader.alpha = 0;
    self.parkTypeHeader.alpha = 0;
    self.phoneButton.alpha = 0;
    self.mapButton.alpha = 0;
    self.parkTypeLabel.alpha = 0;
    self.crimeScoreHeader.alpha = 0;
    self.crimeRatingLabel.alpha = 0;
    self.crimeRatingLabel.textColor = [UIColor wetAsphaltColor];
    self.crimeRatingLabel.text = self.park.crimeRating;
    
    if(self.park.phoneNumber != nil){
        [self.phoneButton setTitle:self.park.phoneNumber forState:UIControlStateNormal];
    } else {
        [self.phoneButton setTitle:@"N/A" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoTableView.delegate = self;
    self.infoTableView.backgroundColor = [UIColor wetAsphaltColor];
    self.view.backgroundColor = [UIColor wetAsphaltColor];
    self.infoButton.tintColor = [UIColor cloudsColor];
    self.mapButton.tintColor = [UIColor cloudsColor];
    self.phoneNumberHeader.textColor = [UIColor cloudsColor];
    self.parkTypeHeader.textColor = [UIColor cloudsColor];
    self.phoneButton.tintColor = [UIColor cloudsColor];
    self.parkTypeLabel.textColor = [UIColor cloudsColor];
    self.crimeScoreView.layer.cornerRadius = 5.0;
    UIImage *tree = [UIImage imageNamed:@"tree73"];
    self.treeImage.image = tree;
    self.treeImage.image = [self.treeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.treeImage setTintColor:[UIColor nephritisColor]];
    self.nameLabel.textColor = [UIColor cloudsColor];
    self.crimeScoreHeader.textColor = [UIColor cloudsColor];
    self.nameLabel.text = [self.park.parkName capitalizedString];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self performSelector:@selector(changeCrimeScoreViewBG) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(infoButtonAppear) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(parkTypeAppearing) withObject:nil afterDelay:0.6];
    [self performSelector:@selector(phoneAppearing) withObject:nil afterDelay:0.8];
}

#pragma mark - Tiered Animations

- (void)infoButtonAppear{
    [UIView animateWithDuration:0.2 animations:^{
        self.infoButton.alpha = 1.0;
    }];
}

- (void)changeCrimeScoreViewBG{
    [UIView animateWithDuration:0.2 animations:^{
        self.crimeScoreHeader.alpha = 1.0;
        if ([self.park.crimeRating floatValue] < 25) {
            self.crimeScoreView.backgroundColor = [UIColor nephritisColor];
        } else if ([self.park.crimeRating floatValue] < 50) {
            self.crimeScoreView.backgroundColor = [UIColor sunflowerColor];
        } else if ([self.park.crimeRating floatValue] < 75) {
            self.crimeScoreView.backgroundColor = [UIColor carrotColor];
        } else {
            self.crimeScoreView.backgroundColor = [UIColor alizarinColor];
        }
    }];
}

- (void)parkTypeAppearing
{
    [UIView animateWithDuration:0.2 animations:^{
        self.parkTypeLabel.alpha = 1.0;
        self.parkTypeHeader.alpha = 1.0;
        self.infoButton.alpha = 1.0;
        self.crimeRatingLabel.alpha = 1.0;
    }];
}

- (void)phoneAppearing
{
    [UIView animateWithDuration:0.2 animations:^{
        self.phoneButton.alpha = 1.0;
        self.phoneNumberHeader.alpha = 1.0;
        self.mapButton.alpha = 1.0;
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
    cell.textLabel.text = [crime.crimeDescription capitalizedString];
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
    SFCrime *crime = self.park.nearbyCrimes[indexPath.row];
    FUIAlertView *errorAlert = [[FUIAlertView alloc]
                                initWithTitle:@"Information:" message:[NSString stringWithFormat:@"This crime occurred about %.2f meters (~%.2f miles) from the park.", [crime.distanceFromPark floatValue], [crime.distanceFromPark floatValue] * 0.000621371192] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.titleLabel.textColor = [UIColor cloudsColor];
    errorAlert.messageLabel.textColor = [UIColor cloudsColor];
    errorAlert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    errorAlert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    errorAlert.defaultButtonColor = [UIColor cloudsColor];
    errorAlert.defaultButtonShadowColor = [UIColor asbestosColor];
    errorAlert.defaultButtonTitleColor = [UIColor asbestosColor];
    [errorAlert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex]){
        NSLog(@"Cancelled.");
    } else {
        NSString *string = [[self.park.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *phoneString = [NSString stringWithFormat:@"tel://%@", string];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapViewSegue"]) {
        MapViewController *controller = segue.destinationViewController;
        controller.park = self.park;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
