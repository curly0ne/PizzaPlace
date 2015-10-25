//
//  NSManagedObject+Insert.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/23/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Insert)

+ (NSString *)managedObjectName;
+ (__kindof NSManagedObject *)insertInContext:(NSManagedObjectContext *)context;

@end
