//
//  AddGroupTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "AddGroupTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "AppDelegate.h"
#import "UIColor+SBHelper.h"
#import "Group+CoreDataClass.h"
#import "NSDate+SBHelper.h"
#import "CurrencySelectionTableViewController.h"

@interface AddGroupTableViewController () <CurrencySelectionDelegate>

@end

@implementation AddGroupTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Actions

- (IBAction)cancelAddingGroup:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addGroup:(UIBarButtonItem *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *groupName = [cell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([groupName isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Group Name Cannot Be Blank" message:@"Please enter a non-blank name for your group." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSString *currency = cell.detailTextLabel.text;
        Group *group = [Group groupWithName:groupName unique:[NSString stringWithFormat:@"%@/%@", [[NSDate date] dateID], groupName] currency:currency inManagedObjectContext:delegate.persistentContainer.viewContext];
        [delegate saveContext];
        NSLog(@"%@", group);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    switch (indexPath.section) {
        case 0:
        {
            TextFieldTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddGroupTextCell" forIndexPath:indexPath];
            [temp setup];
            temp.textField.placeholder = @"Group Name";
            cell = temp;
            break;
        }

        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCurrencyCell"];
            cell.textLabel.text = @"Default Currency";
            cell.detailTextLabel.text = @"USD";
            cell.textLabel.textColor = [UIColor defaultColor];
            cell.detailTextLabel.textColor = [UIColor headerColor];
            break;
        }

        default: break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"ChooseGroupCurrency" sender:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Basic Information"; break;
        case 1: return @"Currency"; break;
        default: break;
    }
    return @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ChooseGroupCurrency"]) {
        UINavigationController *nvc = segue.destinationViewController;
        CurrencySelectionTableViewController *vc = (CurrencySelectionTableViewController *)nvc.topViewController;
        vc.delegate = self;
    }
}

#pragma mark - CurrencySelectionDelegate

- (void)currencySelectionTableViewController:(CurrencySelectionTableViewController *)vc didChooseCurrency:(NSString *)currency
{
    NSLog(@"CHOSEN DEFAULT CURRENCY: %@", currency);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = currency;
}

@end
