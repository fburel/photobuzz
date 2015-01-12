//
//  CityRepository.h
//  photobuzz
//
//  Created by Florian BUREL on 09/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

@interface CityRepository : NSObject


- (void) populate;

/// Insert & return a new city
- (City *) newCity;

/// Returns all the city in the database
- (NSArray *) allCity;

/// Remove a given city from the database
- (void) deleteCity:(City*)city;

@end
