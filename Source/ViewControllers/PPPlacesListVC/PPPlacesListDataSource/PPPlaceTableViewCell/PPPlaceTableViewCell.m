//
//  PPPlaceTableViewCell.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPlaceTableViewCell.h"
#import "PPCDPlace.h"

@interface PPPlaceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@end

@implementation PPPlaceTableViewCell

#pragma mark - Setup

- (void)setupWithPlace:(PPCDPlace *)place
{
	[[self placeName] setText:[place name]];
	[[self distance] setText:[NSString stringWithFormat:@"%@ m", [place distance]]];
	
	NSString *rating = [[place rating] floatValue] > 0 ? [NSString stringWithFormat:@"%@/10", [place rating]] : @"Not rated yet";
	[[self rating] setText:rating];
}

@end
