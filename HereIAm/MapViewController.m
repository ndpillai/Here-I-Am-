//
//  MapViewController.m
//  HereIAm
//
//  Created by Nav Pillai on 5/2/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;

@interface MapViewController ()
@end

@implementation MapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    // Ensure that you can view your own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Request authorization
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
            [self.locationManager requestWhenInUseAuthorization];
    
    //Make this controller the delegate for the location manager.
    [self.locationManager setDelegate:self];
    
    //Set some parameters for the location object.
   // [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
   // [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [self.locationManager startUpdatingLocation];
    
    //    GMSPlacesClient* placesClient;
    //    _placesClient = [[GMSPlacesClient alloc] init];
}
#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate,1000,1000);
    
    
    [mv setRegion:region animated:YES];
}

// Add a UIButton in Interface Builder to call this function
/*- (IBAction)getCurrentPlace:(UIButton *)sender {
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        self.nameLabel.text = @"No current place";
        self.addressLabel.text = @"";
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                self.nameLabel.text = place.name;
                self.addressLabel.text = [[place.formattedAddress componentsSeparatedByString:@", "]
                                          componentsJoinedByString:@"\n"];
            }
        }
    }];
} */
- (IBAction)pickPlace:(id)sender {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(51.5108396, -0.0922251);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
        } else {
            NSLog(@"No place selected");
        }
    }];
}
@end

