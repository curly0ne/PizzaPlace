//
//  PizzaPlace+CoreDataProperties.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/23/15.
//  Copyright © 2015 Company. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PizzaPlace.h"

NS_ASSUME_NONNULL_BEGIN

@interface PizzaPlace (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) PlaceDetails *details;

@end

NS_ASSUME_NONNULL_END
