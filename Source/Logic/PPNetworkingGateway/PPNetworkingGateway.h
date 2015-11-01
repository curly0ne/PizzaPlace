//
//  PPNetworkingGateway.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPBaseGateway.h"
#import "PPPlaceTypeEnum.h"

@class PPError;

@interface PPNetworkingGateway : PPBaseGateway

- (void)loadPlacesWithType:(PPPlaceType)type
			 startingIndex:(NSUInteger)index
					amount:(NSUInteger)amount
			  userLocation:(NSDictionary *)userLocation
				   success:(void (^)(NSArray *places))successBlock
				   failure:(void (^)(PPError *error))failureBlock;

@end
