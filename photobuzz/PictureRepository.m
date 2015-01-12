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

#define ERROR_DOMAIN    @"fr.florianburel.photobuzz"

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
    return [self picturesFromArea:area error:nil];
}

- (NSArray *)picturesFromArea:(FlickRArea)area error:(NSError **)error
{


    NSMutableArray * pictures = [NSMutableArray new];
    
    NSString * url = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&lat=%f&lon=%f&radius=%f&per_page=300&format=json&nojsoncallback=1",
                    FLICKR_API_KEY, area.latitude, area.longitude, area.radius];

    // telechargement du contenu de l'url
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    
    if(!data)
    {
        *error = [NSError errorWithDomain:ERROR_DOMAIN
                                     code:1
                                 userInfo:@
        {
            NSLocalizedDescriptionKey : NSLocalizedString(@"Pas de connection internet", nil),
            NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Verifier vos paramètres résaux", nil)
        }];
    }
    else
    {
        // Deserialization
        NSDictionary * jsonAnswer = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:error];
        
        
        // parser le json (creation d'un tableau de Picture)
        NSArray * photoItems = jsonAnswer[@"photos"][@"photo"];
        
        
        
        for (NSDictionary * item in photoItems)
        {
            Picture * p = [[Picture alloc] initWithTitle:item[@"title"]
                                                    farm:item[@"farm"]
                                                  server:item[@"server"]
                                                flickrID:item[@"id"]
                                                  secret:item[@"secret"]];
            [pictures addObject:p];
        }
        
        
        
    }
    
    return pictures;
}

- (void)picturesFromArea:(FlickRArea)area
              completion:(FetchCompletion)block
{
    
    dispatch_async(dispatch_get_global_queue(2, 0), ^{
        

        NSError * error = nil;
        
        NSArray * pictures = [self picturesFromArea:area error:&error];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError * finalError = nil;
            
            if(error)
            {
                finalError = error;
            }
            else if(pictures.count == 0)
            {
                NSDictionary * userInfo = @
                {
                    NSLocalizedDescriptionKey : NSLocalizedString(@"Aucune images", nil),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Impossible de trouver d'image pour la ville demandée", nil)
                };
                
                finalError = [NSError errorWithDomain:ERROR_DOMAIN
                                            code:404
                                        userInfo:userInfo];
            }
            
            if(block)
            {
                block(pictures, finalError);
            }

        });
    });

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

