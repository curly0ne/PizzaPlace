//
//  PPActivityIndicatorFooterView.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/24/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPActivityIndicatorFooterView.h"

@interface PPActivityIndicatorFooterView ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PPActivityIndicatorFooterView

#pragma mark - Public

- (void)startAnimating
{
	[[self activityIndicator] startAnimating];
}

- (void)stopAnimating
{
	[[self activityIndicator] stopAnimating];
}

@end
