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
#import "City.h"

#define DEFAULT_RADIUS  5

@interface CarousselViewController ()
<FBImageCarousselDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet FBImageCaroussel *caroussel;

@property (strong, nonatomic) NSArray * pictures;

@property (strong, nonatomic) PictureRepository * repository;

@end

@implementation CarousselViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    FlickRArea area;
    area.latitude = self.city.latitude.doubleValue;
    area.longitude = self.city.longitude.doubleValue;
    area.radius = DEFAULT_RADIUS;
    
    self.title = self.city.name;
    self.repository = [PictureRepository sharedInstance];
    self.caroussel.hidden = YES;


    [self.repository picturesFromArea:area
                           completion:^(NSArray *pictures, NSError *error)
                           {
                               if(error)
                               {
                                   // error
                                   UIAlertView * alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                                                    message:error.localizedFailureReason
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil];
                                   [alert show];

                               }
                               else
                               {
                                   self.pictures = pictures;
                                   self.caroussel.hidden = NO;
                                   [self.caroussel displayPageAtIndex:0];
                               }



                           }];
    
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
        
        [self.repository downloadImageForPicture:picture
                                      completion:^(NSData *data, NSError *error)
        {
            if(error)
            {
                // affichage d'une image "cassée" ou alert, ou autre...
            }
            else{
                imageView.image = [UIImage imageWithData:data];
            }
        }];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
@end











