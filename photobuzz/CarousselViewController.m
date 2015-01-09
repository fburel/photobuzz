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

    FlickRArea moscow;
    moscow.latitude = 36.175;
    moscow.longitude = -115.136389;
    moscow.radius = 10;
    
    self.title = @"Moscow";
    
    self.repository = [PictureRepository sharedInstance];
    
    self.caroussel.hidden = YES;
    

    dispatch_queue_t netQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(netQ, ^{
        
        // Code en async
        self.pictures = [self.repository picturesFromArea:moscow];
        
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
    
    // Affichage du titre de l'image dans le champs d'en-tête
    self.title = picture.title;
    
    UIImageView * imageView = [[UIImageView alloc]init];

    // Verifie si l'image est en cache
    NSData * data = [self.repository cachedDataForPicture:picture];
    
    if(data) // Affiche l'image
    {
        UIImage * image = [UIImage imageWithData:data];
        imageView.image = image;
    }
    else // Affiche une image de chargement
    {
        UIImage * image = [UIImage imageNamed:@"loading"];
        imageView.image = image;
        
        // Telechargement et sauvefgarde en cache en async
        dispatch_queue_t netQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        dispatch_async(netQ, ^
        {
            
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.repository registerCacheData:imageData forPicture:picture];
                imageView.image = [UIImage imageWithData:imageData];
                
            });
        });

    }
    return imageView;
}

- (IBAction)handleShare:(id)sender {
    
    int idxForCurrentPic = self.caroussel.currentPageIndex;
    Picture * picture = self.pictures[idxForCurrentPic];
    
    NSArray * items = @[
                       picture.title,
                       [NSURL URLWithString:picture.url],
                       [self.repository cachedDataForPicture:picture]
                       ];
    

    UIActivityViewController * avc = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // Exclut le partage par mail
    avc.excludedActivityTypes = @[UIActivityTypeMail];
    
    [self presentViewController:avc animated:YES completion:nil];
}

@end











