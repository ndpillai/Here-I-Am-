//
//  PlacesTableViewController.m
//  HereIAm
//
//  Created by Nav Pillai on 5/5/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PlacesModel.h"

@interface PlacesTableViewController ()
@property (strong, nonatomic) PlacesModel* model;
@end

@implementation PlacesTableViewController

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberOfPlaces];
}

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    static NSString *CellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //configure cell
    NSDictionary* place = [self.model placeAtIndex:indexPath.row];
    cell.textLabel.text = place[kNameKey];
    //format date appropriately
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    cell.detailTextLabel.text = [dateFormat stringFromDate:place[kDateKey]];
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.model removePlaceAtIndex:indexPath.row];
        
        // Delete the row from the tableView
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.model = PlacesModel.sharedModel;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

@end
