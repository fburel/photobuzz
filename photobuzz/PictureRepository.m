//
//  PictureRepository.m
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "PictureRepository.h"
#import "Picture.h"

#define FLICKR_API_KEY      @"edd17c0c4d413be050ffdba18c74c0e1"

@interface PictureRepository ()

@property (strong, nonatomic) NSMutableDictionary * cache;

@end

@implementation Picture (FlickRBuilder)

- (id)initWithTitle:(NSString *)title farm:(id)farm server:(id)server flickrID:(id)ID secret:(id)secret{

    self = [super init];
    if(self)
    {
       self.title =  title;
       self.url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farm,server, ID, secret];
    }
    return self;
}
@end


@implementation PictureRepository

+ (id)sharedInstance
{
    static id __SharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __SharedInstance = [[self alloc] init];
    });
    return __SharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [NSMutableDictionary new];
    }
    return self;
}


- (NSArray *)picturesFromArea:(FlickRArea)area
{


    NSString * url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%f&lon=%f&radius=%f&per_page=300&format=json&nojsoncallback=1",
                    FLICKR_API_KEY, area.latitude, area.longitude, area.radius];

    // telechargement du contenu de l'url
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

    // Deserialization
    NSDictionary * jsonAnswer = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0
                                                                  error:nil];


    // parser le json (creation d'un tableau de Picture)
    NSArray * photoItems = jsonAnswer[@"photos"][@"photo"];

    NSMutableArray * pictures = [NSMutableArray new];

    for (NSDictionary * item in photoItems)
    {
        Picture * p = [[Picture alloc] initWithTitle:item[@"title"]
                                                farm:item[@"farm"]
                                              server:item[@"server"]
                                            flickrID:item[@"id"]
                                              secret:item[@"secret"]];
        [pictures addObject:p];
    }


    return pictures;
}

- (void)registerCacheData:(NSData *)data forPicture:(Picture *)picture
{
    [self.cache setObject:data forKey:picture.url];
}

- (NSData *)cachedDataForPicture:(Picture *)picture
{
    return self.cache[picture.url];
}
@end

