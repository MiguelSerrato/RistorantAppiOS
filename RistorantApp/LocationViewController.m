//
//  LocationViewController.m
//  RistorantApp
//
//  Created by NDM on 10/3/16.
//  Copyright © 2016 NDM. All rights reserved.
//

#import "LocationViewController.h"
#import "Constants.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize coordString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //code to see current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    if (coordString.length > 0) {
        NSArray *coordinates = [coordString componentsSeparatedByString:@","];
        if (coordinates.count == 2) {
            double latitude = [[coordinates objectAtIndex:0] doubleValue];
            double longitude = [[coordinates objectAtIndex:1] doubleValue];
            
            MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
            
            dropPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            [self.mapView addAnnotation:dropPin];
        }
    }
    
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded|| sender.state == UIGestureRecognizerStateChanged)
    {
        return;
    }
    else
    {
        //remove all the previous annotations
        [self.mapView removeAnnotations:self.mapView.annotations];
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        // Then all you have to do is create the annotation and add it to the map
        MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
        
        dropPin.coordinate = CLLocationCoordinate2DMake(locCoord.latitude, locCoord.longitude);
        
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:locCoord.latitude longitude:locCoord.longitude]; //insert your coordinates
        __block NSString *locatedAt = @"";
        [ceo reverseGeocodeLocation:loc
                  completionHandler:^(NSArray *placemarks, NSError *error) {
                      CLPlacemark *placemark = [placemarks objectAtIndex:0];
                      if (placemark) {
                          locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      }
                      else {
                          locatedAt = @"Could not locate";
                      }
                      //post notification with the info of the coordinate
                      NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                      
                      [notificationCenter postNotificationName:kCoordinateNotification
                                                        object:self
                                                      userInfo:
                       @{kUserInfoCoordinateLatNotification : [NSNumber numberWithDouble:dropPin.coordinate.latitude],
                         kUserInfoCoordinateLonNotification : [NSNumber numberWithDouble:dropPin.coordinate.longitude],
                         kUserInfoCoordinateTextNotification : locatedAt}];
                  }
         ];
        
        [self.mapView addAnnotation:dropPin];
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"%@", [locations lastObject]);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
