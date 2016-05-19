//
//  GoogleMapViewController.m
//  HereIAm
//
//  Created by Nav Pillai on 5/3/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PlacesModel.h"

@import GoogleMaps;
@import Social;

@interface GoogleMapViewController ()
@property (strong, nonatomic) PlacesModel* model; //gotten by singleton
@property (strong, nonatomic) GMSMapView* mapView; //Google Map
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation* currentLocation; //holds current location
@property (strong, nonatomic) GMSMarker* marker; //marker with current location
@property (strong, nonatomic) GMSPlacePicker *placePicker; //place picker from Google
@property (strong, nonatomic) SLComposeViewController* mySLComposerSheet; //allows user to make fB post
@end

@implementation GoogleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = PlacesModel.sharedModel;
    self.locationManager = [[CLLocationManager alloc] init];
    
    //requests permission from user for location updates
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager requestWhenInUseAuthorization];
    
    //Set this controller as delegate for the location manager
    [self.locationManager setDelegate:self];
    
    self.currentLocation = [[CLLocation alloc] init];

    //set some parameters for the location object.
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //starts updating location
    [self.locationManager startUpdatingLocation];

    //set the camera to the default starting coordinates, these will quickly vanish when
    //updates are received
    CLLocationCoordinate2D startCoordinates = CLLocationCoordinate2DMake(34.0273270, -118.2893760);
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithTarget:startCoordinates zoom:17];
    
    //set mapView to camera, enable locations, set view to the mapView
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.view = self.mapView;
    
    //initialize marker for current location
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = startCoordinates;
    self.marker.title = @"Current Location";
    self.marker.map = self.mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//every time a location is received
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    //gets most recent location
    CLLocation* newLocation = [locations lastObject];
    
    //checks to make sure distance change is a significant one
    if (fabs(self.currentLocation.coordinate.latitude-newLocation.coordinate.latitude)>1
        ||fabs(self.currentLocation.coordinate.longitude-newLocation.coordinate.longitude)>1) {
        
        //sets new coordinates and puts marker there
        self.currentLocation = [locations lastObject];
        CLLocationCoordinate2D newCoordinates = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
        self.marker.position = newCoordinates;

        //updates camera with animation
        GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:newCoordinates zoom:17];
        [self.mapView animateWithCameraUpdate:cameraUpdate];
    }
}

//If this option is selected, the closest location is posted.
- (IBAction)nearestLocationPressed:(id)sender {
    GMSPlacesClient* placesClient = [[GMSPlacesClient alloc] init];

    [placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        //there is a likely place nearby
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
                NSLog(@"Place name: %@", place.name);
                NSLog(@"Address: %@", place.formattedAddress);
                [self postToFacebook:place.name]; //posts that place to Facebook
            }
        }
        else {
            NSLog(@"No nearby places!");
        }
    }];
}

//If this option is pressed, user can choose location with place picker
- (IBAction)chooseLocationPressed:(id)sender {
    //sets viewport for place picker based off current location
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude + 0.001, self.currentLocation.coordinate.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude - 0.001, self.currentLocation.coordinate.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        //Valid place is selected
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            [self postToFacebook:place.name]; //post that place to Facebook
        } else {
            NSLog(@"No place selected");
        }
    }];

}

//Handles posting to Facebook
- (void)postToFacebook: (NSString*)placeName {
    [self.model addPlace:placeName date:[NSDate date]]; //adds place visited to model
    
    if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])  {
        NSLog(@"log output of your choice here");
    }

    //Prompts user to compose a post
    self.mySLComposerSheet = [[SLComposeViewController alloc] init];
    self.mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    //sets if postDescription has not been set
    if (self.postDescription == NULL) {
        self.postDescription = @"";
    }
    //sets default text with placeName and postDescription
    [self.mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Here I Am! at %@. %@", placeName, self.postDescription]];
    
    [self presentViewController:self.mySLComposerSheet animated:YES completion:nil];
    
    [self.mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successful";
                break;
            default:
                break;
        }
        if (![output isEqualToString:@"Action Cancelled"]) {
            NSLog(@"Successfully posted.");
        }
    }];
}
@end
