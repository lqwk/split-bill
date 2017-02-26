//
//  AddPaybackTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 2/25/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "AddPaybackTableViewController.h"
#import "CalculatorTableViewCell.h"
#import "PersonTableViewCell.h"
#import "UIColor+SBHelper.h"
#import "Person+CoreDataClass.h"

@interface AddPaybackTableViewController () <CalculatorTableViewCellDelegate>

@end

@implementation AddPaybackTableViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%@", self.people);

    self.tableView.rowHeight = 42.f;
    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Actions

- (IBAction)addPayback:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAddingPayback:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 1; break;
        case 1: return self.people.count; break;
        case 2: return self.people.count; break;
        default: break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    switch (indexPath.section) {
        case 0:
        {
            CalculatorTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddPaybackCalculatorCell"];
            [temp setup];
            temp.delegate = self;
            temp.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = temp;
            break;
        }

        case 1:
        {
            // Who paid
            PersonTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
            temp.person = [self.people objectAtIndex:indexPath.row];
            temp.textLabel.text = temp.person.name;
            temp.textLabel.textColor = [UIColor defaultColor];
            cell = temp;
            break;
        }

        case 2:
        {
            // Who received
            PersonTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
            temp.person = [self.people objectAtIndex:indexPath.row];
            temp.textLabel.text = temp.person.name;
            temp.textLabel.textColor = [UIColor defaultColor];
            cell = temp;
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
        // Who paid
        PersonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chosen = YES;
    } else if (indexPath.section == 2) {
        // Who received
        PersonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chosen = YES;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Payback Amount"; break;
        case 1: return @"Who's Paying"; break;
        case 2: return @"Who's Receiving"; break;

        default: break;
    }
    return @"";
}

@end
