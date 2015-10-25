//
//  PPPersistentStorageController.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/19/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPersistentStorageControllerProtocol.h"

typedef void (^PPInitCallbackBlock)(void);

@interface PPPersistentStorageController : NSObject<PPPersistentStorageControllerProtocol>

- (instancetype)initWithCallback:(PPInitCallbackBlock)callback;

@end
