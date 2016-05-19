//
//  PlacesModel.m
//  HereIAm
//
//  Created by Nav Pillai on 5/4/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//

#import "PlacesModel.h"

static NSString *const kPlacesPlist = @"Places.plist"; //Plist used for data persistence


@interface PlacesModel()
@property (strong, nonatomic) NSMutableArray *places; //holds list of places
@property (strong, nonatomic) NSString *filepath; //filepath for persistent data
@end

@implementation PlacesModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //reads from kPlacesPlist to load places
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filepath = [documentsDirectory stringByAppendingPathComponent:kPlacesPlist];
        _places = [NSMutableArray arrayWithContentsOfFile:_filepath];
        
        //if there are no places to be loaded, alloc and init the places array
        if (!_places) {
            _places = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

//singleton method
+ (instancetype) sharedModel {
    static PlacesModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

//saves the places array to the filepath
- (void) save {
    [self.places writeToFile:self.filepath atomically:YES];
}

- (NSUInteger) numberOfPlaces {
    return [self.places count];
}

- (NSDictionary *) placeAtIndex: (NSUInteger) index {
    if (index < self.numberOfPlaces)
        return self.places[index];
    else
        return NULL;
}

- (void) addPlace: (NSString*) name
             date: (NSDate*) date {
    NSDictionary* place = [NSDictionary dictionaryWithObjectsAndKeys:
                          name, kNameKey, date, kDateKey, nil];
    [self.places insertObject:place atIndex:0]; //orders from most recent to least recent
    [self save];
}

- (void) removePlaceAtIndex: (NSUInteger) index {
    if (index < self.numberOfPlaces) {
        [self.places removeObjectAtIndex: index];
        [self save];
    }
}
@end
