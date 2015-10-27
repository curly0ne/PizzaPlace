//
//  PPNetworkingGateway.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPNetworkingGateway.h"

#import "AFNetworking.h"

static NSString * const PPFoursquarePlacesURLString = @"https://api.foursquare.com/v2/venues/explore";
static NSString * const PPFoursquareOAuthToken = @"OBML545RJQB5DOR50JW3NO53IVZTOAYFX0RIJVSJSZJULZ3V";
static NSString * const PPFoursquareVersion = @"20151027";

@interface PPNetworkingGateway ()

- (NSDictionary *)requestParametersWithType:(PPPlaceType)type
									 offset:(NSUInteger)offset
									 amount:(NSUInteger)amount
							   userLocation:(NSDictionary *)userLocation;

- (NSArray *)disassembleResponse:(NSDictionary *)response;

@end

@implementation PPNetworkingGateway

#pragma mark - Boilerplate

#pragma mark - Pizza places

- (void)loadPlacesWithType:(PPPlaceType)type
			 startingIndex:(NSUInteger)index
					amount:(NSUInteger)amount
			  userLocation:(NSDictionary *)userLocation
				   success:(void (^)(NSArray *))successBlock
				   failure:(void (^)(NSError *))failureBlock
{
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	
	NSDictionary *requestParameters = [self requestParametersWithType:type
															   offset:index
															   amount:amount
														 userLocation:userLocation];

	PPWeakSelf;
	
	[manager GET:PPFoursquarePlacesURLString
	  parameters:requestParameters
		 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
			{
				successBlock([weakSelf disassembleResponse:responseObject]);
			}
		 failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
			{
				failureBlock(error);
			}];
}

#pragma mark - Private

- (NSDictionary *)requestParametersWithType:(PPPlaceType)type offset:(NSUInteger)offset amount:(NSUInteger)amount userLocation:(NSDictionary *)userLocation
{
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	NSString *coordinates = [NSString stringWithFormat:@"%@, %@", userLocation[@"latitude"], userLocation[@"longitude"]];
	[parameters setObject:coordinates forKey:@"ll"];

	switch (type)
	{
		case PPPlaceTypePizza:
			[parameters setObject:@"pizza" forKey:@"query"];
			break;
			
		default:
			break;
	}
	
	[parameters setObject:@(amount) forKey:@"limit"];
	[parameters setObject:@(offset) forKey:@"offset"];
	[parameters setObject:@1 forKey:@"sortByDistance"];
	[parameters setObject:PPFoursquareOAuthToken forKey:@"oauth_token"];
	[parameters setObject:PPFoursquareVersion forKey:@"v"];
	[parameters setObject:@5000 forKey:@"radius"];
	
	return parameters;
}

- (NSArray *)disassembleResponse:(NSDictionary *)response
{
	NSDictionary *resp = response[@"response"];
	
	NSArray *groups = resp[@"groups"];
	NSArray *items = groups[0][@"items"];
	
	NSMutableArray *venues = [NSMutableArray array];
	
	[items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
	{
		[venues addObject:obj[@"venue"]];
	}];
	
	return venues;
}

@end
