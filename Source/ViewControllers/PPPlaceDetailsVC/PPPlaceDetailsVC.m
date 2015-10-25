//
//  PPPlaceDetailsVC.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPlaceDetailsVC.h"
#import "PPPlaceDetailsTableViewCell.h"
#import "PizzaPlace.h"
#import "PlaceDetails.h"

#import <objc/runtime.h>

@interface PPPlaceDetailsVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *placeAttributesArray;

- (void)prepareTableView;
- (NSArray *)makeArrayOfPlaceObject:(PizzaPlace *)place;

@end

@implementation PPPlaceDetailsVC

#pragma mark - Boilerplate

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self prepareTableView];
	[self setPlaceAttributesArray:[self makeArrayOfPlaceObject:[self place]]];
	
	[[self tableView] reloadData];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self placeAttributesArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	PPPlaceDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PPPlaceDetailsTableViewCell class])];
	[cell setupWithPlaceAttribute:[self placeAttributesArray][row]];
	
	return cell;
}

#pragma mark - Private

- (void)prepareTableView
{
	UINib *placeDetailsCellNib = [UINib nibWithNibName:NSStringFromClass([PPPlaceDetailsTableViewCell class]) bundle:[NSBundle mainBundle]];
	
	[[self tableView] registerNib:placeDetailsCellNib forCellReuseIdentifier:NSStringFromClass([PPPlaceDetailsTableViewCell class])];
}

- (NSArray *)makeArrayOfPlaceObject:(PizzaPlace *)place
{
	unsigned int placePropertyCount = 0, detailsPropertyCount = 0;
	
	objc_property_t *placeProperties = class_copyPropertyList([PizzaPlace class], &placePropertyCount);
	objc_property_t *detailsProperties = class_copyPropertyList([PlaceDetails class], &detailsPropertyCount);
	
	NSMutableArray *propertyNames = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < placePropertyCount - 1; ++i)
	{
		objc_property_t property = placeProperties[i];
		const char *name = property_getName(property);
		[propertyNames addObject:[NSString stringWithUTF8String:name]];
	}
	
	for (NSUInteger i = 0; i < detailsPropertyCount - 1; i++)
	{
		objc_property_t property = detailsProperties[i];
		const char *name = property_getName(property);
		[propertyNames addObject:[NSString stringWithFormat:@"details.%@", [NSString stringWithUTF8String:name]]];
	}
	
	free(placeProperties);
	free(detailsProperties);
	
	NSMutableArray *placeDetails = [NSMutableArray array];
	
	for (NSString * __strong propertyName in propertyNames)
	{
		if (![place valueForKeyPath:propertyName])
			continue;
		
		id propertyValue = [place valueForKeyPath:propertyName];
		
		if ([[propertyName pathExtension] length] > 0)
			propertyName = [propertyName pathExtension];
		
		NSDictionary *attributeDict = @{@"key" : propertyName,
										@"value" : propertyValue};
		[placeDetails addObject:attributeDict];
	}
	
	return placeDetails;
}

@end
