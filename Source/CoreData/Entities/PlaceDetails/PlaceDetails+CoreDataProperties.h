//
//  PlaceDetails+CoreDataProperties.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/21/15.
//  Copyright © 2015 Company. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlaceDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *menuUrl;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) PizzaPlace *place;

@end

NS_ASSUME_NONNULL_END
