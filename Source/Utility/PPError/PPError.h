//
//  PPError.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 11/1/15.
//  Copyright © 2015 Company. All rights reserved.
//

FOUNDATION_EXPORT NSString *PPNetworkErrorDomain;
FOUNDATION_EXPORT NSString *PPLocationErrorDomain;
FOUNDATION_EXPORT NSString *PPOtherErrorDomain;
FOUNDATION_EXPORT NSString *PPDatabaseErrorDomain;

@interface PPError : NSObject

@property (copy, nonatomic, readonly) NSString *domain;
@property (nonatomic, readonly) NSInteger code;

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code;

@end
