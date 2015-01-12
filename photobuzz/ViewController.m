//
//  ViewController.m
//  photobuzz
//
//  Created by Florian BUREL on 07/01/2015.
//  Copyright (c) 2015 Florian Burel. All rights reserved.
//

#import "ViewController.h"
#import "City.h"
#import "CityRepository.h"
#import "CarousselViewController.h"


@interface ViewController ()
<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray * cities;
@property (strong, nonatomic) CityRepository * repository;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.repository = [[CityRepository alloc]init];
    
    self.cities = [self.repository allCity];
    
    self.tableView.dataSource = self;

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellID =  @"CITY_CELL";
    static NSString * WaitingCellID = @"GPS_CELL";
    
    City * city = self.cities[indexPath.row];
    
    UITableViewCell * cell;
    
    if(city.name)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellID
                                               forIndexPath:indexPath];
        cell.textLabel.text = city.name;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:WaitingCellID
                                               forIndexPath:indexPath];
        UILabel * label = (UILabel *) [cell viewWithTag:666];
        
        label.text = NSLocalizedString(@"Waiting please! We'll find you soon...", nil);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    City * city = self.cities[indexPath.row];
    
    [self.repository deleteCity:city];
    
    self.cities = [self.repository allCity];
    
    [self.tableView reloadData];
}

#pragma mark - User Interaction

- (IBAction)add:(id)sender {
    
    // TODO: Utiliser le repo pour ajouter un element et reactualiser self.cities
    City * city = [self.repository newCity];
    
    [city addObserver:self
           forKeyPath:@"name"
              options:0
              context:NULL];
    
    self.cities = [self.repository allCity];
    
    // Rafraichir la liste
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CITY_SELECTED"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        
        City * city = self.cities[indexPath.row];

        CarousselViewController * vc = segue.destinationViewController;
        
        vc.city = city;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
    
    [object removeObserver:self forKeyPath:keyPath];
    
}


@end

















