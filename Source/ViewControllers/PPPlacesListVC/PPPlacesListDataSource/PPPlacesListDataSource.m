//
//  PPPlacesListDataSource.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPlacesListDataSource.h"
#import "PPPersistentStorageControllerProtocol.h"
#import "PPPlaceTableViewCell.h"
#import "PPCDPlace.h"
#import "PPPlacesListDataSourceDelegate.h"
#import "PPActivityIndicatorFooterView.h"

#import <CoreData/CoreData.h>

@interface PPPlacesListDataSource ()<NSFetchedResultsControllerDelegate>
{
	NSUInteger currentNumberOfCells_;
	BOOL inProgress_;
}

@property (strong, nonatomic) id<PPPersistentStorageControllerProtocol> storageController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) PPActivityIndicatorFooterView *sectionFooterView;

- (void)prepareTableView;
- (void)setupFetchController;

@end

@implementation PPPlacesListDataSource

#pragma mark - Custom init

- (instancetype)initWithTableView:(UITableView *)tableView
	  persistentStorageController:(id<PPPersistentStorageControllerProtocol>)storageController
{
	if (self = [super init])
	{
		[self setTableView:tableView];
		[self setStorageController:storageController];
		
		[self prepareTableView];
		[self setupFetchController];

		currentNumberOfCells_ = 0;
		inProgress_ = NO;
	}
	
	return self;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	PPCDPlace *selectedPlace = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	
	[[self delegate] dataSource:self didSelectPlace:selectedPlace];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 50.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	[self setSectionFooterView:[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([PPActivityIndicatorFooterView class])]];
	
	return [self sectionFooterView];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
	if (inProgress_ == NO)
	{
		inProgress_ = YES;
		
		[[self sectionFooterView] startAnimating];
		
		[[self delegate] dataSource:self isRequestingForDataUpdateWithCurrentObjectsCount:currentNumberOfCells_];
	}
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
	[[self sectionFooterView] stopAnimating];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([[[self fetchedResultsController] sections] count] > 0)
	{
		id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
		
		if ([sectionInfo numberOfObjects] > 0)
			currentNumberOfCells_ = [sectionInfo numberOfObjects];
	}

	return currentNumberOfCells_;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PPPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PPPlaceTableViewCell class])];
	
	PPCDPlace *place = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	[cell setupWithPlace:place];
	
	return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	inProgress_ = NO;
	
	[[self tableView] reloadData];
}

#pragma mark - Private

- (void)prepareTableView
{
	UINib *placeCellNib = [UINib nibWithNibName:NSStringFromClass([PPPlaceTableViewCell class]) bundle:[NSBundle mainBundle]];
	UINib *footerNib = [UINib nibWithNibName:NSStringFromClass([PPActivityIndicatorFooterView class]) bundle:[NSBundle mainBundle]];
	
	[[self tableView] registerNib:placeCellNib forCellReuseIdentifier:NSStringFromClass([PPPlaceTableViewCell class])];
	[[self tableView] registerNib:footerNib forHeaderFooterViewReuseIdentifier:NSStringFromClass([PPActivityIndicatorFooterView class])];
}

- (void)setupFetchController
{
	if ([self fetchedResultsController])
	{
		return;
	}
	
	NSFetchRequest *fetchRequest = [PPCDPlace requestInContext:[[self storageController] managedObjectContext]];
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];

	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
 	[fetchRequest setFetchBatchSize:10];
 
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:[[self storageController] managedObjectContext]
																								 sectionNameKeyPath:nil
																										  cacheName:nil];
	[self setFetchedResultsController:fetchedResultsController];
	[[self fetchedResultsController] setDelegate:self];
	
	NSError *error;
	__unused BOOL success = [_fetchedResultsController performFetch:&error];
}

#pragma mark - Public

- (void)resetToIdle
{
	[[self sectionFooterView] stopAnimating];
	
	if (currentNumberOfCells_ == 0)
		return;
	
	PPWeakSelf;
	
	[UIView animateWithDuration:0.3
					 animations:^
						{
							CGFloat footerHeight = [[[weakSelf tableView] footerViewForSection:0] frame].size.height;
							UIEdgeInsets noFooterInsets = UIEdgeInsetsMake(-20, 0, -(20 + footerHeight), 0);
							
							[[weakSelf tableView] setContentInset:noFooterInsets];
						}
					 completion:^(BOOL finished)
						{
							inProgress_ = NO;
							
							[[weakSelf tableView] setContentInset:UIEdgeInsetsZero];
						}];
}

@end
