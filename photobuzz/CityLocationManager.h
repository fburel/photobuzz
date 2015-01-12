//
// Created by Florian BUREL on 12/01/15.
// Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

@interface CityLocationManager : NSObject

+ (instancetype)sharedInstance;

- (void)locate:(City *)city;

@end