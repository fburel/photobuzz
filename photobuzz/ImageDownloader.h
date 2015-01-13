//
// Created by Florian BUREL on 13/01/15.
// Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Picture;


@interface ImageDownloader : NSOperation

@property (strong, nonatomic) Picture * picture;
@property (strong, nonatomic) NSData * imageData;

- (instancetype)initWithPicture:(Picture *)picture;


@end