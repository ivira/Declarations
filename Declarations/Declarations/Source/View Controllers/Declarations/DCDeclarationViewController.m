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
#import "DCPerson.h"
#import "DCValueTransformer.h"

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

- (IBAction)shareAction:(id)sender
{
    NSString *text = [NSString stringWithFormat:@"Декларація %@", self.declaration.person.fullName];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://chesno.org/profile/%lu/?section=person_property&year=%lu", (unsigned long)self.declaration.person.identifier, (unsigned long)self.declaration.year]];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]
     initWithActivityItems:@[text, url]
     applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - TableView datasource/delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.declaration.categories.count + ((self.declaration.originalURL != nil) ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.declaration.originalURL != nil && indexPath.row == self.declaration.categories.count)
    {
        return [tableView dequeueReusableCellWithIdentifier:@"OriginalPDFCell"];
    }
    else
    {
        DCCategoryCell *cell = (DCCategoryCell *)[tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
        cell.backgroundColor = [UIColor clearColor];
        DCCategory *category = (DCCategory *)self.declaration.categories[indexPath.row];
        if (category.isEmpty)
        {
            cell.userInteractionEnabled = NO;
            cell.alpha = 0.5f;
            cell.categoryLabel.enabled = NO;
            cell.categoryIconView.alpha = 0.5f;
        }
        cell.categoryLabel.text = category.name;
        cell.categoryIconView.image = category.icon;
        cell.totalValueLabel.text = [[DCValueTransformer new] transformedValue:category.totalValue];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.declaration.originalURL != nil && indexPath.row == self.declaration.categories.count)
    {
        [[UIApplication sharedApplication] openURL:self.declaration.originalURL];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else
    {
        DCCategory *category = (DCCategory *)self.declaration.categories[indexPath.row];
        [self performSegueWithIdentifier:@"DeclarationCategorySegue" sender:category];
    }
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
