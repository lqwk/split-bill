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
#import "UIColor+SBHelper.h"
#import "Person+CoreDataClass.h"
#import "Payment+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "Group+CoreDataClass.h"
#import "NSDate+SBHelper.h"

@interface AddExpenseTableViewController () <CalculatorTableViewCellDelegate, PeopleInvolvedCellDelegate, PeoplePaymentCellDelegate, TextFieldTableViewCellDelegate>

@property (nonatomic) double totalCost;
@property (nonatomic) double totalWeight;
@property (nonatomic) double eachCost;

@property (nonatomic) double totalPaymentWeight;
@property (nonatomic) double eachPayment;

@property (nonatomic, strong) NSString *expenseName;

@end

@implementation AddExpenseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 42.f;
    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.expenseName = @"";

    self.totalCost = 0;
    double totalWeight = 0;
    for (Person *p in self.people) {
        totalWeight += p.weight;
    }
    self.totalWeight = totalWeight;
    self.totalPaymentWeight = totalWeight;

    if (self.totalWeight == 0) {
        self.eachCost = 0;
    } else {
        self.eachCost = self.totalCost / self.totalWeight;
    }

    if (self.totalPaymentWeight == 0) {
        self.eachPayment = 0;
    } else {
        self.eachPayment = self.totalCost / self.totalPaymentWeight;
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

- (void)setEachPayment:(double)eachPayment
{
    _eachPayment = eachPayment;

    // update each cell
    for (int i = 0; i < self.people.count; ++i) {
        PeoplePaymentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        cell.eachPayment = self.eachPayment;
    }
}

- (IBAction)cancelAddingExpense:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addExpense:(UIBarButtonItem *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (!self.expenseName || [self.expenseName isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Expense Name Cannot Be Blank" message:@"Please enter a non-blank name for the expense." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else {
        NSMutableArray *payments = [NSMutableArray arrayWithCapacity:0];
        NSMutableSet *people = [NSMutableSet setWithCapacity:0];

        for (int i = 0; i < self.people.count; ++i) {
            PeopleInvolvedTableViewCell *cellInvolved = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            if (cellInvolved.chosen) {
                [people addObject:cellInvolved.person];
            }
        }

        // create the Expense
        if (people.count != 0) {
            NSLog(@"EXPENSE NAME: %@", self.expenseName);
            NSString *unique = [NSString stringWithFormat:@"%@$%@*%@", self.group.unique, [[NSDate date] dateID], self.expenseName];
            NSLog(@"EXPENSE UNIQUE: %@", unique);
            Expense *expense = [Expense expenseWithName:self.expenseName
                                                 unique:unique
                                                  group:self.group
                                         peopleInvolved:people
                                 inManagedObjectContext:delegate.persistentContainer.viewContext];
            NSLog(@"Expense: %@", expense);

            for (int i = 0; i < self.people.count; ++i) {
                PeoplePaymentTableViewCell *cellPayment = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
                if (cellPayment.chosen) {
                    double amountDouble = [cellPayment.paymentTextfield.text doubleValue];
                    int64_t amount = amountDouble * 100;
                    Payment *payment = [Payment paymentWithAmount:amount
                                                           person:cellPayment.person
                                                          expense:expense
                                           inManagedObjectContext:delegate.persistentContainer.viewContext];
                    [payments addObject:payment];
                }
            }

            if (payments.count == 0) {

                [delegate.persistentContainer.viewContext deleteObject:expense];
                [delegate saveContext];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payments Made Cannot Be Zero" message:@"There has to be at least one payment made in the expense." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }

            [delegate saveContext];
            NSLog(@"Expense Saved: %@", expense);
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"People Involved Cannot Be Zero" message:@"There has to be at least one person involved in the expense." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
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
                    temp.delegate = self;
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
            temp.delegate = self;
            temp.eachPayment = self.eachPayment;
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
        cell.chosen = !cell.chosen;
    } else if (indexPath.section == 2) {
        PeoplePaymentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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

    if (self.totalPaymentWeight == 0) {
        self.eachPayment = 0;
    } else {
        self.eachPayment = self.totalCost / self.totalPaymentWeight;
    }

    NSLog(@"CalculatorDelegate -> Total Cost: %f", totalCost);
    NSLog(@"CalculatorDelegate -> Total Weight: %f", self.totalWeight);
    NSLog(@"CalculatorDelegate -> Each Cost: %f", self.eachCost);
    NSLog(@"CalculatorDelegate -> Total Payment Weight: %f", self.totalPaymentWeight);
    NSLog(@"CalculatorDelegate -> Each Payment Cost: %f", self.eachPayment);
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

#pragma mark - PeoplePaymentCellDelegate

- (void)weightDidChangeForPeoplePaymentCell:(PeoplePaymentTableViewCell *)cell
{
    // recalculate `totalPaymentWeight` and `eachPayment`
    double totalPaymentWeight = 0.0;
    for (int i = 0; i < self.people.count; ++i) {
        PeoplePaymentTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        if (cell.chosen) {
            totalPaymentWeight += cell.person.weight;
        }
    }
    self.totalPaymentWeight = totalPaymentWeight;
    if (self.totalPaymentWeight == 0) {
        self.eachPayment = 0;
    } else {
        self.eachPayment = self.totalCost / self.totalPaymentWeight;
    }

    NSLog(@"PeoplePaymentDelegate -> Weight Changed: %f", self.totalPaymentWeight);
}

#pragma mark - TextFieldTableViewCellDelegate

- (void)textFieldCell:(TextFieldTableViewCell *)cell textFieldDidChange:(NSString *)text
{
    self.expenseName = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
