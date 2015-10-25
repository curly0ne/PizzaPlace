//
//  PPPersistentStorageControllerProtocol.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/20/15.
//  Copyright © 2015 Company. All rights reserved.
//

@protocol PPPersistentStorageControllerProtocol <NSObject>

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)save;

@end
