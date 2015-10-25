//
//  PPPlacesListDataSourceDelegate.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/20/15.
//  Copyright © 2015 Company. All rights reserved.
//

@class PPPlacesListDataSource;
@class PizzaPlace;

@protocol PPPlacesListDataSourceDelegate <NSObject>

@optional
- (void)dataSource:(PPPlacesListDataSource *)dataSource didSelectPlace:(PizzaPlace *)place;

@required
- (void)dataSource:(PPPlacesListDataSource *)dataSource isRequestingForDataUpdateWithCurrentObjectsCount:(NSUInteger)count;

@end