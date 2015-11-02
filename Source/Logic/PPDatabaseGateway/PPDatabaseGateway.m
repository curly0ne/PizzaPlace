//
//  PPDatabaseGateway.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/19/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPDatabaseGateway.h"
#import "PPPersistentStorageControllerProtocol.h"
#import "PPCDPlace.h"
#import "PPCDPlaceDetails.h"

#import <CoreData/CoreData.h>

NSString *PPDatabaseErrorDomain = @"PPDatabaseErrorDomain";

@interface PPDatabaseGateway ()

@property (strong, nonatomic) id<PPPersistentStorageControllerProtocol> storageController;

@property (strong, nonatomic) NSFetchRequest *storedRequest;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation PPDatabaseGateway

#pragma mark - Custom init

- (instancetype)initWithStorageController:(id<PPPersistentStorageControllerProtocol>)storageController
{
	self = [super init];
	
	if (self)
	{
		[self setStorageController:storageController];
	}
	
	return self;
}

#pragma mark - Save places

- (NSUInteger)savePlaces:(NSArray *)places
{
	NSUInteger savedCounter = 0;
	
	for (NSDictionary *place in places)
	{
		NSPredicate *placesPredicate = [NSPredicate predicateWithFormat:@"name = %@ AND distance = %@", place[@"name"], place[@"location"][@"distance"]];
		[[self storedRequest] setPredicate:placesPredicate];
		
		NSError *error;
		NSArray *existingEntries = [PPCDPlace executeFetchRequest:[self storedRequest]
														inContext:[self context]
															error:&error];
		
		NSAssert(!error, @"Places request execution failure");
		
		if ([existingEntries count] > 0)
			continue;
		
		PPCDPlace *pizzaPlace = [PPCDPlace insertInContext:[self context]];
		[pizzaPlace setName:place[@"name"]];
		[pizzaPlace setDistance:place[@"location"][@"distance"]];
		[pizzaPlace setRating:![place[@"rating"] isEqualToNumber:@(0)] ? place[@"rating"] : nil];
		
		PPCDPlaceDetails *placeDetails = [PPCDPlaceDetails insertInContext:[self context]];
		[placeDetails setAddress:[place[@"location"][@"formattedAddress"] componentsJoinedByString:@",\n"]];
		[placeDetails setPhone:place[@"contact"][@"phone"] ? : nil];
		[placeDetails setUrl:place[@"url"] ? : nil];
		[placeDetails setMenuUrl:place[@"menu"][@"url"] ? : nil];
		
		[placeDetails setPlace:pizzaPlace];
		[pizzaPlace setDetails:placeDetails];
		
		savedCounter++;
	}
	
	PPWeakSelf;

	dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^
	{
		[[weakSelf storageController] save];
	});
	
	return savedCounter;
}

#pragma mark - Overridden

- (NSManagedObjectContext *)context
{
	if (_context)
		return _context;
	
	return _context = [[self storageController] managedObjectContext];
}

- (NSFetchRequest *)storedRequest
{
	if (_storedRequest)
		return _storedRequest;
	
	_storedRequest = [PPCDPlace requestInContext:[self context]];
	
	return _storedRequest;
}

@end
