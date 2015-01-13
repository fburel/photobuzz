//
// Created by Florian BUREL on 13/01/15.
// Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "ImageDownloader.h"
#import "Picture.h"


@implementation ImageDownloader

- (instancetype)initWithPicture:(Picture *)picture {
    self = [super init];
    if (self) {
        self.picture = picture;
    }
    return self;
}

// Code de l'operation
- (void)main
{
    NSURL * url = [NSURL URLWithString:self.picture.url];

    self.imageData = [NSData dataWithContentsOfURL:url];

}

@end