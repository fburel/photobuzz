//
// Created by Florian BUREL on 12/01/15.
// Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "CityLocationManager.h"
#import "City.h"

@import CoreLocation;

@interface CityLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager * locationManager;

@property (strong, nonatomic) NSMutableArray * cities;

@end

@implementation CityLocationManager

+ (instancetype)sharedInstance {

    static id __SharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __SharedInstance = [self new];
    });

    return __SharedInstance;

}

- (void)locate:(City *)city {

    [self.cities addObject:city];
    
    

    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

}

- (CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (NSMutableArray *)cities {
    if(!_cities)
    {
        _cities = [NSMutableArray new];
    }
    return _cities;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = [locations lastObject];

    double latitude = location.coordinate.latitude;
    double longitude = location.coordinate.longitude;

    [self.locationManager stopUpdatingLocation];

    // Reverse geo-coding
    CLGeocoder * geocoder = [CLGeocoder new];

    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark * placemark = [placemarks lastObject];
                       NSString * cityName = placemark.locality;

                       [self.cities enumerateObjectsUsingBlock:^(City * city, NSUInteger idx, BOOL *stop) {
                           city.name = cityName;
                           city.longitude = @(longitude);
                           city.latitude = @(latitude);
                       }];

                       [self.cities removeAllObjects];

                   }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

}
@end