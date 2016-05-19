//
//  GoogleMapViewController.h
//  HereIAm
//
//  Created by Nav Pillai on 5/3/16.
//  Copyright © 2016 Nav Pillai. All rights reserved.
//
/*
 Displays a Google Map of user's current location using CLLocationManager.
 Allows user to make a post to Facebook either with their nearest location or 
 with a nearby selected location. The latter is implemented with the GooglePlaces 
 API.
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GoogleMapViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) NSString* postDescription; //set by LoginViewController
@end
