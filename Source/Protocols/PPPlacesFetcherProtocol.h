//
//  PPPlacesFetcherProtocol.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPlaceTypeEnum.h"

@class PPError;

@protocol PPPlacesFetcherProtocol <NSObject>

- (void)loadPlacesWithType:(PPPlaceType)placeType
			 startingIndex:(NSUInteger)index
					amount:(NSUInteger)amount
				completion:(void (^)(PPError *error))completionHandler;

@end
