//
//  PictureRepository.m
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "PictureRepository.h"

#define FLICKR_API_KEY      @"edd17c0c4d413be050ffdba18c74c0e1"

@implementation PictureRepository

- (NSArray *)picturesFromArea:(FlickRArea)area {


    NSString * url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%f&lon=%f&radius=%f&per_page=300&format=json&nojsoncallback=1",
                    FLICKR_API_KEY, area.latitude, area.longitude, area.radius];

    // telechargement du contenu de l'url
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

    // Deserialization
    NSDictionary * jsonAnswer = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0
                                                                  error:nil];


    // parser le json (creation d'un tableau de Picture)
    NSArray * photoItems = ...;

    NSMutableArray * pictures = ...;

    for (NSDictionary * item in photoItems)
    {
        Picture * p = ...;

        p.title = ...;
        p.url = ...;

        [pictures addObject:p];
    }


    return pictures;
}

@end
