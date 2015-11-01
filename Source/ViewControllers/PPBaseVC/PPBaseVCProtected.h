//
//  PPBaseVCProtected.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 11/1/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseVC.h"

@class PPError;

@interface PPBaseVC ()

- (void)handleError:(PPError *)error withHandlerBlock:(void (^)(void))handler;

@end
