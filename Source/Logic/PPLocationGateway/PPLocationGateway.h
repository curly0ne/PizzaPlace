//
//  PPLocationGateway.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseGateway.h"

typedef void (^PPLocationCallbackBlock)(NSDictionary *location, NSError *error);

@interface PPLocationGateway : PPBaseGateway

- (void)requestLocationWithCallback:(PPLocationCallbackBlock)callback;

@end