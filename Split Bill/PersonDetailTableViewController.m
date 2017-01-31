//
//  PersonDetailTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/30/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "PersonDetailTableViewController.h"
#import "Person+CoreDataClass.h"
#import "Payment+CoreDataClass.h"
#import "UIColor+SBHelper.h"
#import "SBExpense.h"
#import "SBMoney.h"

@interface PersonDetailTableViewController ()

@end

@implementation PersonDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.navigationItem.title = self.person.name;
}

#pragma mark - Helper Methods

- (SBMoney *)totalCostForPerson:(Person *)person
{
    SBMoney *totalCost = [SBMoney moneyWithVal:0];
    for (Expense *expense in person.expensesInvolved) {
        SBExpense *e = [SBExpense expenseFromCDExpense:expense];
        SBMoney *cost = [[e.amount divide:e.weight] multiply:person.weight];
        totalCost = [totalCost add:cost];
    }
    return totalCost;
}

- (int64_t)totalPaidForPerson:(Person *)person
{
    int64_t totalPaid = 0;
    for (Payment *payment in person.paymentsMade) {
        totalPaid += payment.amount;
    }
    return totalPaid;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 2; break;
        case 1: return 3; break;
        case 2: return 0; break;
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"PersonBasicCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor defaultColor];
            cell.detailTextLabel.textColor = [UIColor headerColor];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text = self.person.name;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Weight";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lld", self.person.weight];
            }
            break;
        }

        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"PersonBasicCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor defaultColor];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Total Costs";
                SBMoney *totalCost = [self totalCostForPerson:self.person];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", totalCost];
                cell.detailTextLabel.textColor = [UIColor darkRedColor];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Total Paid";
                int64_t totalPaid = [self totalPaidForPerson:self.person];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lld.%02lld", totalPaid / 100, totalPaid % 100];
                cell.detailTextLabel.textColor = [UIColor darkGreenColor];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Total Balance";
                SBMoney *totalCost = [self totalCostForPerson:self.person];
                SBMoney *totalPaid = [SBMoney moneyWithVal:[self totalPaidForPerson:self.person]];
                SBMoney *balance = [totalPaid subtract:totalCost];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", balance];
                if (balance.val < 0) {
                    cell.detailTextLabel.textColor = [UIColor darkRedColor];
                } else {
                    cell.detailTextLabel.textColor = [UIColor darkGreenColor];
                }
            }
            break;
        }

        default: break;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"General Information"; break;
        case 1: return @"Balances"; break;
        case 2: return @"Expenses Involved"; break;
        default: break;
    }

    return @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
