//
//  NSManagedObject+Request.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/23/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Request)

+ (NSFetchRequest *)requestInContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context error:(NSError **)error;

@end
