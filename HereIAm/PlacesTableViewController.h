//
//  PlacesTableViewController.h
//  HereIAm
//
//  Created by Nav Pillai on 5/5/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//
/*
 TableViewController that displays the places visited from PlacesModel.
 Includes standard delegate and data source methods.
 */
#import <UIKit/UIKit.h>

@interface PlacesTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

- (NSInteger) numberOfSectionsInTableView:
(UITableView *) tableView;

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section;

- (UITableViewCell *) tableView:
(UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath;

@end
