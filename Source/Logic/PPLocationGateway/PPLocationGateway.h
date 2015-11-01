//
//  PPLocationGateway.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseGateway.h"

@class PPError;

typedef void (^PPLocationCallbackBlock)(NSDictionary *location, PPError *error);

@interface PPLocationGateway : PPBaseGateway

- (void)requestLocationWithCallback:(PPLocationCallbackBlock)callback;

@end