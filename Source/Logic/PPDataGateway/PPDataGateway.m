//
//  PPDataGateway.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPDataGateway.h"
#import "PPLocationGateway.h"
#import "PPNetworkingGateway.h"
#import "PPDatabaseGateway.h"
#import "PPError.h"

NSString *PPOtherErrorDomain = @"PPOtherErrorDomain";

@interface PPDataGateway ()

@property (strong, nonatomic) PPLocationGateway *locationGateway;
@property (strong, nonatomic) PPNetworkingGateway *networkingGateway;
@property (strong, nonatomic) PPDatabaseGateway *databaseGateway;

@end

@implementation PPDataGateway

#pragma mark - Custom init

- (instancetype)initWithStorageController:(id<PPPersistentStorageControllerProtocol>)storageController
{
	self = [super init];
	
	if (self)
	{
		[self setLocationGateway:[PPLocationGateway new]];
		[self setNetworkingGateway:[PPNetworkingGateway new]];
		[self setDatabaseGateway:[[PPDatabaseGateway alloc] initWithStorageController:storageController]];
	}
	
	return self;
}

#pragma mark - PPPlacesFetcherProtocol

- (void)loadPlacesWithType:(PPPlaceType)placeType startingIndex:(NSUInteger)index amount:(NSUInteger)amount completion:(void (^)(PPError *))completionHandler
{
	PPWeakSelf;
	
	[[self locationGateway] requestLocationWithCallback:^(NSDictionary *location, PPError *error)
	{
		if (!error)
		{
			void (^successBlock)(NSArray *) = ^(NSArray *places)
			{
				if ([[weakSelf databaseGateway] savePlaces:places] == 0)
					completionHandler([PPError errorWithDomain:PPOtherErrorDomain code:0]);
			};
			
			void (^failureBlock)(PPError *) = ^(PPError *error)
			{
				completionHandler(error);
			};
			
			[[weakSelf networkingGateway] loadPlacesWithType:placeType
											   startingIndex:index
													  amount:amount
												userLocation:location
													 success:successBlock
													 failure:failureBlock];
		}
		else
		{
			completionHandler(error);
		}
	}];
}

@end
