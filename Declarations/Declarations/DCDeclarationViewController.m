//
//  DCDeclarationViewController.m
//  Declarations
//
//  Created by Vera Tkachenko on 5/20/14.
//  Copyright (c) 2014 Chesno. All rights reserved.
//

#import "DCDeclarationViewController.h"
#import "DCCategoryCell.h"
#import "DCCategory.h"
#import "DCCategoryViewController.h"

@implementation DCDeclarationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.declaration.title;
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView datasource/delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.declaration.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCCategoryCell *cell = (DCCategoryCell *)[tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    cell.backgroundColor = [UIColor clearColor];
    DCCategory *category = (DCCategory *)self.declaration.categories[indexPath.row];
    cell.textLabel.text = category.name;
    cell.imageView.image = category.icon;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCCategory *category = (DCCategory *)self.declaration.categories[indexPath.row];
    [self performSegueWithIdentifier:@"DeclarationCategorySegue" sender:category];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DeclarationCategorySegue"])
    {
        ((DCCategoryViewController *)segue.destinationViewController).category = sender;
    }
}

@end
