//
//  PPObservableProtocol.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/19/15.
//  Copyright © 2015 Company. All rights reserved.
//

@protocol PPObservableProtocol <NSObject>

@optional
- (void)addObservables;
- (void)removeObservables;

@end
