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
#import "Expense+CoreDataClass.h"
#import "NSDate+SBHelper.h"
#import "AppDelegate.h"
#import "Group+CoreDataClass.h"
#import "Payment+CoreDataClass.h"

@interface AddPaybackTableViewController () <CalculatorTableViewCellDelegate>

@property (nonatomic, strong) Person *payer;
@property (nonatomic, strong) Person *receiver;
@property (nonatomic) double amount;

@end

@implementation AddPaybackTableViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.payer = nil;
    self.receiver = nil;
    if (self.setupAmount) {
        self.amount = [self.setupAmount floatValue];
    } else {
        self.amount = 0;
    }

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
    NSLog(@"Payer: %@", self.payer.name);
    NSLog(@"Receiver: %@", self.receiver.name);
    NSLog(@"Amount: %f", self.amount);

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (!self.payer || !self.receiver) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payer or Receiver Not Selected" message:@"Please select both a payer and receiver." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if ([self.payer.name isEqualToString:self.receiver.name]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payer and Receiver Cannot be the Same" message:@"Please select a receiver different from the payer." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else if (self.amount <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payback Amount Cannot be Zero" message:@"Please enter a non-zero payback amount." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    NSSet *peopleInvolved = [NSSet setWithObjects:self.receiver, nil];
    NSString *expenseName = @"Payback";

    Expense *expense = [Expense expenseWithName:expenseName
                                         unique:[NSString stringWithFormat:@"%@$%@*%@", self.group.unique, [[NSDate date] dateID], expenseName]
                                       currency:@"USD"
                                      isPayback:YES
                                          group:self.group
                                 peopleInvolved:peopleInvolved
                         inManagedObjectContext:delegate.persistentContainer.viewContext];
    int64_t amount = self.amount * 100;
    Payment *payment = [Payment paymentWithAmount:amount
                                           person:self.payer
                                          expense:expense
                           inManagedObjectContext:delegate.persistentContainer.viewContext];
    [delegate saveContext];

    NSLog(@"PAYBACK PAYMENT: %@", payment);
    NSLog(@"PAYBACK: %@", expense);

    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
            if (self.setupAmount) {
                temp.calculatorTextField.text = self.setupAmount;
            } else {
                temp.calculatorTextField.placeholder = @"Payback Amount";
            }
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
            temp.isLendee = YES;
            temp.textLabel.text = temp.person.name;
            temp.textLabel.textColor = [UIColor defaultColor];
            if (self.setupLenderName && [temp.person.name isEqualToString:self.setupLenderName]) {
                temp.chosen = YES;
                self.payer = temp.person;
            } else {
                temp.chosen = NO;
            }
            cell = temp;
            break;
        }

        case 2:
        {
            // Who received
            PersonTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
            temp.person = [self.people objectAtIndex:indexPath.row];
            temp.isLendee = NO;
            temp.textLabel.text = temp.person.name;
            temp.textLabel.textColor = [UIColor defaultColor];
            if (self.setupLendeeName && [temp.person.name isEqualToString:self.setupLendeeName]) {
                temp.chosen = YES;
                self.receiver = temp.person;
            } else {
                temp.chosen = NO;
            }
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

    if (indexPath.section == 1 || indexPath.section == 2) {
        for (int i = 0; i < self.people.count; i++) {
            PersonTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            if (i == indexPath.row) {
                cell.chosen = YES;
                if (indexPath.section == 1) {
                    // Payer
                    self.payer = cell.person;
                } else if (indexPath.section == 2) {
                    // Receiver
                    self.receiver = cell.person;
                }
            } else {
                cell.chosen = NO;
            }
        }
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

#pragma mark - CalculatorTableViewCellDelegate

- (void)calculatorCell:(CalculatorTableViewCell *)cell calculatorTextFieldDidChange:(NSString *)text
{
    double amount = [text doubleValue];
    self.amount = amount;

    NSLog(@"CalculatorDelegate -> Total Cost: %f", amount);
}

@end
