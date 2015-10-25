//
//  PPDataGateway.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseGateway.h"
#import "PPPlacesFetcherProtocol.h"

@protocol PPPersistentStorageControllerProtocol;

@interface PPDataGateway : PPBaseGateway<PPPlacesFetcherProtocol>

- (instancetype)initWithStorageController:(id<PPPersistentStorageControllerProtocol>)storageController;

@end
