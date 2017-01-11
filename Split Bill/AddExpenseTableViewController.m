//
//  AddExpenseTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "AddExpenseTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "CalculatorTableViewCell.h"
#import "PeopleInvolvedTableViewCell.h"
#import "PeoplePaymentTableViewCell.h"
#import "AppDelegate.h"
#import "Person+CoreDataClass.h"

@interface AddExpenseTableViewController ()

@end

@implementation AddExpenseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 44.f;
}

#pragma mark - Actions

- (IBAction)cancelAddingExpense:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addExpense:(UIBarButtonItem *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // TextFieldTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:nameIndexPath];
    // NSString *name = [nameCell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    // NSIndexPath *weightIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    // StepperTableViewCell *weightCell = [self.tableView cellForRowAtIndexPath:weightIndexPath];
    // NSInteger weight = [weightCell.weightLabel.text integerValue];

    // if ([name isEqualToString:@""]) {
    //     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Person Name Cannot Be Blank" message:@"Please enter a non-blank name for the person." preferredStyle:UIAlertControllerStyleAlert];
    //     UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    //     [alert addAction:action];
    //     [self presentViewController:alert animated:YES completion:nil];
    // } else {
    //     if (weight < 1) {
    //         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Person Weight Cannot Be Zero" message:@"Please enter a non-zero weight for the person." preferredStyle:UIAlertControllerStyleAlert];
    //         UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    //         [alert addAction:action];
    //         [self presentViewController:alert animated:YES completion:nil];
    //     } else {
    //         Person *person = [Person personWithName:name unique:[NSString stringWithFormat:@"%@+%@", self.group.unique, name] weight:weight group:self.group inManagedObjectContext:delegate.persistentContainer.viewContext];
    //         [delegate saveContext];
    //         NSLog(@"%@", person);
    //         [self dismissViewControllerAnimated:YES completion:nil];
    //     }
    // }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    switch (section) {
        case 0: return 2; break;
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
            switch (indexPath.row) {
                case 0:
                {
                    TextFieldTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddExpenseTextCell" forIndexPath:indexPath];
                    [temp setup];
                    temp.textField.placeholder = @"Name of Expense";
                    temp.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = temp;
                    break;
                }

                case 1:
                {
                    CalculatorTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddExpenseCalculatorCell" forIndexPath:indexPath];
                    [temp setup];
                    temp.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell = temp;
                    break;
                }

                default: break;
            }

            break;
        }

        case 1:
        {
            Person *p = [self.people objectAtIndex:indexPath.row];
            PeopleInvolvedTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"PeopleInvolvedCell" forIndexPath:indexPath];
            temp.person = p;
            [temp setup];
            // temp.each = self.total / self.totalWeight;
            temp.chosen = YES;
            cell = temp;
            break;
        }

        case 2:
        {
            Person *p = [self.people objectAtIndex:indexPath.row];
            PeoplePaymentTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"PeoplePaymentCell" forIndexPath:indexPath];
            [temp setup];
            temp.person = p;
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
        PeopleInvolvedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.chosen = !cell.chosen;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"Basic Details"; break;
        case 1: return @"People Who Should Pay"; break;
        case 2: return @"People Who Paid"; break;
        default: break;
    }

    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0: break;
        case 1: return @"Click on the person to remove from \"Who Should Pay\". Click again to re-add."; break;
        case 2: return @"Click on the person to remove from \"Who Paid\". Click again to re-add."; break;
        default: break;
    }

    return @"";
}

@end
