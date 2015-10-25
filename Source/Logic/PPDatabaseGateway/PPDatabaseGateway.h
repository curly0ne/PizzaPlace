//
//  PPDatabaseGateway.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/19/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseGateway.h"

@protocol PPPersistentStorageControllerProtocol;

@interface PPDatabaseGateway : PPBaseGateway

- (instancetype)initWithStorageController:(id<PPPersistentStorageControllerProtocol>)storageController;

- (NSUInteger)savePlaces:(NSArray *)places;

@end
