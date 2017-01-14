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

@interface AddExpenseTableViewController () <CalculatorTableViewCellDelegate, PeopleInvolvedCellDelegate>

@property (nonatomic) double totalCost;
@property (nonatomic) double totalWeight;
@property (nonatomic) double eachCost;

@end

@implementation AddExpenseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 42.f;

    self.totalCost = 0;
    double totalWeight = 0;
    for (Person *p in self.people) {
        totalWeight += p.weight;
    }
    self.totalWeight = totalWeight;

    if (self.totalWeight == 0) {
        self.eachCost = 0;
    } else {
        self.eachCost = self.totalCost / self.totalWeight;
    }
}

#pragma mark - Actions

- (void)setEachCost:(double)eachCost
{
    _eachCost = eachCost;

    // update each cell
    for (int i = 0; i < self.people.count; ++i) {
        PeopleInvolvedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        cell.eachCost = self.eachCost;
    }
}

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
                    temp.delegate = self;
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
            temp.delegate = self;
            temp.eachCost = self.eachCost;
            [temp setup];
            cell = temp;
            break;
        }

        case 2:
        {
            Person *p = [self.people objectAtIndex:indexPath.row];
            PeoplePaymentTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"PeoplePaymentCell" forIndexPath:indexPath];
            temp.person = p;
            [temp setup];
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
        cell.notChosen = !cell.notChosen;
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

#pragma mark - CalculatorTableViewCellDelegate

- (void)calculatorCell:(CalculatorTableViewCell *)cell calculatorTextFieldDidChange:(NSString *)text
{
    double totalCost = [text doubleValue];
    self.totalCost = totalCost;
    if (self.totalWeight == 0) {
        self.eachCost = 0;
    } else {
        self.eachCost = self.totalCost / self.totalWeight;
    }
    NSLog(@"CalculatorDelegate -> Total Cost: %f", totalCost);
    NSLog(@"CalculatorDelegate -> Total Weight: %f", self.totalWeight);
    NSLog(@"CalculatorDelegate -> Each Cost: %f", self.eachCost);
}

#pragma mark - PeopleInvolvedCellDelegate

- (void)weightDidChangeForPeopleInvolvedCell:(PeopleInvolvedTableViewCell *)cell
{
    // recalculate `weight` and `each` payment
    double totalWeight = 0.0;
    for (int i = 0; i < self.people.count; ++i) {
        PeopleInvolvedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        double weight = [cell.weightLabel.text doubleValue];
        totalWeight += weight;
    }
    self.totalWeight = totalWeight;
    if (self.totalWeight == 0) {
        self.eachCost = 0;
    } else {
        self.eachCost = self.totalCost / self.totalWeight;
    }

    NSLog(@"PeopleInvolvedDelegate -> Weight Changed: %f", self.totalWeight);
}

@end
