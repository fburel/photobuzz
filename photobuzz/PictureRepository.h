//
//  PictureRepository.h
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Picture;

typedef struct{
    double longitude;
    double latitude;
    double radius;
} FlickRArea;

typedef void (^FetchCompletion)(NSArray * pictures, NSError * error);

@interface PictureRepository : NSObject

+ (id) sharedInstance;

/// Download pictures
- (NSArray *) picturesFromArea:(FlickRArea)area;

- (NSArray *) picturesFromArea:(FlickRArea)area error:(NSError **)error;

- (void) picturesFromArea:(FlickRArea)area
               completion:(FetchCompletion)block;

/// Cache
- (NSData *) cachedDataForPicture:(Picture *)picture;
- (void) registerCacheData:(NSData *)data forPicture:(Picture *)picture;

// Image Download

- (void) downloadImageForPicture:(Picture *)picture completion:(ImageDowloadBlock)block;

@end
