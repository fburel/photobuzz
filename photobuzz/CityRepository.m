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
#import "CityLocationManager.h"

@implementation CityRepository

- (NSManagedObjectContext *) context
{
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}


- (void)populate
{
    for(int i = 0; i < 300000; i++)
    {
        City * c = [self newCity];
        NSArray * names = @[@"Moscow", @"Paris", @"Nantes", @"Bordeaux", @"Gagny", @"Budapest", @"New York", @"Yangon", @"Beijin", @"Los Angeles", @"Amsterdam", @"Praha", @"Ankara", @"Bamako"];
        
        c.name = names[i%names.count];
    }
}

- (City *)newCity
{
    City * city = [NSEntityDescription insertNewObjectForEntityForName:@"City"
                                                inManagedObjectContext:self.context];
    
    /*
    CityLocationManager * manager;
    manager = [CityLocationManager sharedInstance];
    [manager locate:city];
    */
    
    return city;
}

- (NSArray *)allCity
{
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"City"];
    request.fetchBatchSize = 200;
    return [[self context] executeFetchRequest:request
                                  error:nil];
}

- (void)deleteCity:(City *)city
{
    [[self context]deleteObject:city];
}

@end
