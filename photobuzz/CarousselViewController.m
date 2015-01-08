//
//  CarousselViewController.m
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "CarousselViewController.h"
#import "FBImageCaroussel.h"
#import "PictureRepository.h"
#import "Picture.h"

@interface CarousselViewController ()
<FBImageCarousselDataSource>

@property (weak, nonatomic) IBOutlet FBImageCaroussel *caroussel;

@property (strong, nonatomic) NSArray * pictures;

@property (strong, nonatomic) PictureRepository * repository;
@end

@implementation CarousselViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FlickRArea area;
    area.latitude = 55.7525;
    area.longitude = 37.623086;
    area.radius = 10;
    
    self.repository = [PictureRepository sharedInstance];
    
    self.caroussel.hidden = YES;
    

    dispatch_queue_t netQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(netQ, ^{
        
        // Code en async
        self.pictures = [self.repository picturesFromArea:area];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Callback
            self.caroussel.hidden = NO;
            if(self.pictures.count > 0)
            {
                [self.caroussel displayPageAtIndex:0];
            }
            
        });
        
    });
    
    self.caroussel.dataSource = self;
    
}

- (int)numberOfPages
{
    return self.pictures.count;
}

- (UIView *)viewForPageIndex:(int)pageIdx
{
    Picture * picture = self.pictures[pageIdx];
    
    // Verifie si l'image est en cache
    NSData * data = [self.repository cachedDataForPicture:picture];
    
    if(!data)
    {
        // Téléchargement et enregistrement en cache
        NSString * url = picture.url;
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        [self.repository registerCacheData:data forPicture:picture];
    }
    
    UIImage * image = [UIImage imageWithData:data];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    
    return imageView;
}

@end











