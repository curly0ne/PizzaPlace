//
//  PPError.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 11/1/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPError.h"

@interface PPError ()

@property (copy, nonatomic, readwrite) NSString *domain;
@property (nonatomic, readwrite) NSInteger code;

@end

@implementation PPError

#pragma mark - Constructor

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code
{
	PPError *error = [PPError new];
	
	[error setDomain:domain];
	[error setCode:code];
	
	return error;
}

@end
