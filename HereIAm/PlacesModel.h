//
//  PlacesModel.h
//  HereIAm
//
//  Created by Nav Pillai on 5/4/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//
/*
 Model class designed to hold a place. Each place consists of the place name
 and the date it was visited by the user. Includes methods for the number of
 places, place at each index, adding a place, and removing a place at an index.
 */

#import <Foundation/Foundation.h>

static NSString * const kNameKey = @"name";
static NSString * const kDateKey = @"date";

@interface PlacesModel : NSObject
+ (instancetype) sharedModel;
- (NSUInteger) numberOfPlaces;
- (NSDictionary *) placeAtIndex: (NSUInteger) index;
- (void) addPlace: (NSString*) name
           date: (NSDate*) date;
- (void) removePlaceAtIndex: (NSUInteger) index;
@end