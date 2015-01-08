//
//  CarousselViewController.m
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "CarousselViewController.h"
#import "FBImageCaroussel.h"

@interface CarousselViewController ()

@property (weak, nonatomic) IBOutlet FBImageCaroussel *caroussel;

//TODO: Ajouter une property NSArray * pictures

@end

@implementation CarousselViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //TODO: Récuperer la liste des Pictures via la repository (location au choix)
    
    // TODO: Se declarer en datasource du caroussel
    
}

//TODO: Implementer le FBImageCarousselDataSource

@end
