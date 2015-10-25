//
//  PPPlacesListDataSource.h
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/17/15.
//  Copyright © 2015 Company. All rights reserved.
//

@protocol PPPersistentStorageControllerProtocol;
@protocol PPPlacesListDataSourceDelegate;

@interface PPPlacesListDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<PPPlacesListDataSourceDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView
	  persistentStorageController:(id<PPPersistentStorageControllerProtocol>)storageController;

- (void)resetToIdle;

@end
