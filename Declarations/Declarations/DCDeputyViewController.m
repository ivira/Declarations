//
//  DCFirstViewController.m
//  Declarations
//
//  Created by Vera Tkachenko on 5/19/14.
//  Copyright (c) 2014 Chesno. All rights reserved.
//

#import "DCDeputyViewController.h"
#import "DCDeputy.h"

@interface DCDeputyViewController ()

@property (strong) NSMutableArray *deputies;
@property (strong) NSArray *displayedDeputies;

@end

@implementation DCDeputyViewController

- (void)generateTestData
{
    self.deputies = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        DCDeputy *deputy = [DCDeputy new];
        deputy.name = @"Михайло";
        deputy.surname = [@"Добкін" stringByAppendingFormat:@" - %i", i];
        [self.deputies addObject:deputy];
    }
    self.displayedDeputies = self.deputies;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self generateTestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayedDeputies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DeputyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	DCDeputy *deputy = (self.displayedDeputies)[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", deputy.surname, deputy.name];
    
    return cell;
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterResultsUsingString:searchText];
}

- (void)filterResultsUsingString:(NSString *)filterString
{
    if ([filterString length] == 0)
    {
        self.displayedDeputies = self.deputies;
    }
    else
    {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(self.name CONTAINS[cd] %@) or (self.surname CONTAINS[cd] %@)", filterString, filterString];
        NSArray *filteredDeputies = [self.deputies filteredArrayUsingPredicate:filterPredicate];
        self.displayedDeputies = filteredDeputies;
    }
    [self.tableView reloadData];
}

@end
