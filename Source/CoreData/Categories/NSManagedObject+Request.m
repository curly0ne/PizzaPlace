//
//  NSManagedObject+Request.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/23/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "NSManagedObject+Request.h"

@implementation NSManagedObject (Request)

+ (NSFetchRequest *)requestInContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [NSFetchRequest new];
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
											  inManagedObjectContext:context];
	
	[request setEntity:entity];
	
	return request;
}

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self requestInContext:context];
	[request setPredicate:predicate];
	
	return request;
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
	NSError *error;
	
	return [context executeFetchRequest:request error:&error];
}

@end
