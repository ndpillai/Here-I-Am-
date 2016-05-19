//
//  MapViewController.h
//  HereIAm
//
//  Created by Nav Pillai on 5/2/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) GMSPlacePicker *placePicker;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end
