//
//  PPPlacesListVC.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPlacesListVC.h"
#import "PPDataGateway.h"
#import "PPPlacesFetcherProtocol.h"
#import "PPPersistentStorageController.h"
#import "PPPlacesListDataSource.h"
#import "PPPlaceTableViewCell.h"
#import "PPPlacesListDataSourceDelegate.h"
#import "PPPlaceDetailsVC.h"
#import "PPCDPlace.h"
#import "PPBaseVCProtected.h"
#import "PPError.h"

static NSUInteger const kPlacesPerRequest = 10;

@interface PPPlacesListVC ()<PPPlacesListDataSourceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PPDataGateway *dataGateway;
@property (strong, nonatomic) PPPersistentStorageController *persistentStorageController;
@property (strong, nonatomic) PPPlacesListDataSource *tableDataSource;
@property (strong, nonatomic) PPCDPlace *selectedPlace;

- (void)instantiatePersistentStorageController;
- (void)instantiateTableDataSource;

@end

@implementation PPPlacesListVC

#pragma mark - Boilerplate

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self instantiatePersistentStorageController];
}

#pragma mark - Private

-(void)instantiatePersistentStorageController
{
	PPWeakSelf;
	
	[self setPersistentStorageController:[[PPPersistentStorageController alloc] initWithCallback:^
	{
		[weakSelf setDataGateway:[[PPDataGateway alloc] initWithStorageController:[weakSelf persistentStorageController]]];
		[weakSelf instantiateTableDataSource];
	}]];
}

- (void)instantiateTableDataSource
{
	[self setTableDataSource:[[PPPlacesListDataSource alloc] initWithTableView:[self tableView]
												   persistentStorageController:[self persistentStorageController]]];
	
	[[self tableView] setDelegate:[self tableDataSource]];
	[[self tableView] setDataSource:[self tableDataSource]];
	
	[[self tableDataSource] setDelegate:self];
}

#pragma mark - PPPlacesDataSourceDelegate

- (void)dataSource:(PPPlacesListDataSource *)dataSource isRequestingForDataUpdateWithCurrentObjectsCount:(NSUInteger)count
{
	PPWeakSelf;
	
	[[self dataGateway] loadPlacesWithType:PPPlaceTypePizza
							 startingIndex:count
									amount:kPlacesPerRequest
								completion:^(PPError *error)
								{
									if (error)
									{
										[dataSource resetToIdle];
										[[weakSelf tableView] setScrollEnabled:NO]; //prevents moving to the tap point after resetting
										
										[weakSelf handleError:error withHandlerBlock:^
										{
											[[weakSelf tableView] setScrollEnabled:YES];
										}];
									}
								}];
}

- (void)dataSource:(PPPlacesListDataSource *)dataSource didSelectPlace:(PPCDPlace *)place
{
	[self setSelectedPlace:place];
	
	[self performSegueWithIdentifier:@"PPPlaceDetailsVC" sender:self];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:NSStringFromClass([PPPlaceDetailsVC class])])
	{
		PPPlaceDetailsVC *placeDetailsVC = [segue destinationViewController];
		[placeDetailsVC setPlace:[self selectedPlace]];
	}
}

@end
