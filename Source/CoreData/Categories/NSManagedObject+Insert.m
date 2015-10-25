//
//  NSManagedObject+Insert.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/23/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "NSManagedObject+Insert.h"

@implementation NSManagedObject (Insert)

+ (NSString *)managedObjectName
{
	return NSStringFromClass(self);
}

+ (__kindof NSManagedObject *)insertInContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
										 inManagedObjectContext:context];
}

@end
