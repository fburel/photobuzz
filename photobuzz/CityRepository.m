//
//  CityRepository.m
//  photobuzz
//
//  Created by Florian BUREL on 09/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "CityRepository.h"
#import "AppDelegate.h"
#import "City.h"

@implementation CityRepository

- (NSManagedObjectContext *) context
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}


- (void)populate
{
    for(int i = 0; i < 3; i++)
    {
        [self newCity];
    }
}

- (City *)newCity
{
    City * city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.context];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        city.name = @"Moscow";
        city.longitude = @37.623086;
        city.latitude = @55.7525;

    });
    
    
    return city;
}

- (NSArray *)allCity
{
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"City"];
    return [[self context] executeFetchRequest:request
                                  error:nil];
}

- (void)deleteCity:(City *)city
{
    [[self context]deleteObject:city];
}

@end
