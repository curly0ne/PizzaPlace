//
//  PPPersistentStorageController.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/19/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPersistentStorageController.h"

#import <CoreData/CoreData.h>

@interface PPPersistentStorageController ()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *privateContext;

@property (copy, nonatomic) PPInitCallbackBlock initCallback;

- (NSURL *)applicationDocumentsDirectory;
- (void)initializeCoreDataStack;

@end

@implementation PPPersistentStorageController

#pragma mark - Custom init

- (instancetype)initWithCallback:(PPInitCallbackBlock)callback
{
	if (self = [super init])
	{
		[self setInitCallback:callback];
		[self initializeCoreDataStack];
	}
	
	return self;
}

#pragma mark - Core Data stack

- (void)initializeCoreDataStack
{
	if ([self managedObjectContext])
		return;
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PizzaPlace" withExtension:@"momd"];
	NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	NSAssert(mom, @"%@:%@ No model to generate from", [self class], NSStringFromSelector(_cmd));
	
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
	NSAssert(coordinator, @"Failed to initialize coordinator");
	
	[self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
	
	[self setPrivateContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
	[[self privateContext] setPersistentStoreCoordinator:coordinator];
	[[self managedObjectContext] setParentContext:[self privateContext]];
	
	PPWeakSelf;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
	{
		NSPersistentStoreCoordinator *psc = [[weakSelf privateContext] persistentStoreCoordinator];
		NSMutableDictionary *options = [NSMutableDictionary dictionary];
		options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
		options[NSInferMappingModelAutomaticallyOption] = @YES;
		options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };
		
		NSURL *storeURL = [[weakSelf applicationDocumentsDirectory] URLByAppendingPathComponent:@"PizzaPlace.sqlite"];
		
		NSError *error = nil;
		NSAssert([psc addPersistentStoreWithType:NSSQLiteStoreType
								   configuration:nil
											 URL:storeURL
										 options:options
										   error:&error], @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
		
		if (![weakSelf initCallback])
			return;
		
		dispatch_sync(dispatch_get_main_queue(), ^
		{
			[weakSelf initCallback]();
		});
	});
}

#pragma mark - Save

- (void)save
{
	if (![[self privateContext] hasChanges] && ![[self managedObjectContext] hasChanges]) return;
	
	PPWeakSelf;
	
	[[self managedObjectContext] performBlockAndWait:^
	 {
		 NSError *error = nil;
		 
		 NSAssert([[weakSelf managedObjectContext] save:&error], @"Failed to save main context: %@\n%@", [error localizedDescription], [error userInfo]);
		 
		 [[weakSelf privateContext] performBlock:^
		 {
			 NSError *privateError = nil;
			 NSAssert([[weakSelf privateContext] save:&privateError], @"Failed to save private context: %@\n%@", [privateError localizedDescription], [privateError userInfo]);
		 }];
	 }];
}

#pragma mark - Utility

- (NSURL *)applicationDocumentsDirectory
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
