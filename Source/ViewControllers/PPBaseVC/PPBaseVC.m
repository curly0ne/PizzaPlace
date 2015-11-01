//
//  PPBaseVC.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/20/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseVC.h"
#import "PPBaseVCProtected.h"
#import "PPError.h"

typedef NS_ENUM(NSUInteger, PPAlertType)
{
	PPAlertTypeNoMorePlacesError,
	PPAlertTypeNetworkError,
	PPAlertTypeLocationError,
	PPAlertTypeDatabaseEror
};

@interface PPBaseVC ()

- (void)showAlertOfType:(PPAlertType)type withActionBlock:(void (^)(void))actionBlock;

@end

@implementation PPBaseVC

#pragma mark - Error handling

- (void)handleError:(PPError *)error withHandlerBlock:(void (^)(void))handler
{
	if ([[error domain] isEqualToString:PPNetworkErrorDomain])
		[self showAlertOfType:PPAlertTypeNetworkError withActionBlock:handler];
	
	else if ([[error domain] isEqualToString:PPLocationErrorDomain])
		[self showAlertOfType:PPAlertTypeLocationError withActionBlock:handler];
	
	else
		[self showAlertOfType:PPAlertTypeNoMorePlacesError withActionBlock:handler];
}

#pragma mark - Private

- (void)showAlertOfType:(PPAlertType)type withActionBlock:(void (^)(void))actionBlock
{
	NSString *alertTitle, *alertMessage;
	
	switch (type)
	{
		case PPAlertTypeNetworkError:
			alertTitle = @"Sorry";
			alertMessage = @"Something went wrong on those Internets";
			break;

		case PPAlertTypeDatabaseEror:
			alertTitle = @"Sorry";
			alertMessage = @"The data aren't ready to be presented";
			break;
		
		case PPAlertTypeLocationError:
			alertTitle = @"Hey";
			alertMessage = @"We still need your location to get the job done";
			break;

		case PPAlertTypeNoMorePlacesError:
			alertTitle = @"Wooah";
			alertMessage = @"Pretty enough to choose from";
			break;
			
		default:
			alertTitle = @"Oops";
			alertMessage = @"Something unexpected has just happenned";
			
	}
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
																   message:alertMessage
															preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Okay"
													 style:UIAlertActionStyleDefault
												   handler:^(UIAlertAction * _Nonnull action)
													{
														if (actionBlock)
															actionBlock();
													}];
	
	[alert addAction:alertAction];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
