//
//  PPLocationGateway.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPLocationGateway.h"
#import "PPError.h"

#import <CoreLocation/CoreLocation.h>

NSString *PPLocationErrorDomain= @"PPLocationErrorDomain";

@interface PPLocationGateway ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (copy, nonatomic) PPLocationCallbackBlock locationCallback;

@end

@implementation PPLocationGateway

#pragma mark - Boilerplate

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		[self setLocationManager:[CLLocationManager new]];
		[[self locationManager] setDelegate:self];
	}
	
	return self;
}

#pragma mark - User location

- (void)requestLocationWithCallback:(PPLocationCallbackBlock)callback
{
	[self setLocationCallback:callback];
	
	switch ([CLLocationManager authorizationStatus])
	{
		case kCLAuthorizationStatusNotDetermined:
		{
			[[self locationManager] requestWhenInUseAuthorization];
			[[self locationManager] requestLocation];
			
			break;
		}
		case kCLAuthorizationStatusAuthorizedWhenInUse:
		{
			[[self locationManager] requestLocation];

			break;
		}
		default:
			break;
	}
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse)
	{
		[[self locationManager] requestLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
	if ([self locationCallback])
	{
		NSNumber *latitude = @([[locations lastObject] coordinate].latitude);
		NSNumber *longitude = @([[locations lastObject] coordinate].longitude);
		
		NSDictionary *location = @{@"latitude" : latitude,
								   @"longitude" : longitude};
		
		[self locationCallback](location, nil);
		[self setLocationCallback:nil]; // prevents multiple location callbacks
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if ([self locationCallback])
	{
		PPError *customError = [PPError errorWithDomain:PPLocationErrorDomain code:0];
		
		[self locationCallback](nil, customError);
	}
}

@end
