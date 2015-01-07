//
//  PictureRepository.h
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct{
    double longitude;
    double latitude;
    double radius;
} FlickRArea;

@interface PictureRepository : NSObject

/// Download pictures
- (NSArray *) picturesFromArea:(FlickRArea)area;

@end