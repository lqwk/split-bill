//
//  ExpenseDetailTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/31/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "ExpenseDetailTableViewController.h"
#import "UIColor+SBHelper.h"
#import "Expense+CoreDataClass.h"
#import "SBExpense.h"
#import "SBPayment.h"
#import "SBPerson.h"
#import "SBMoney.h"

@interface ExpenseDetailTableViewController ()

@property (nonatomic, strong) SBExpense *sbe;

@end

@implementation ExpenseDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.navigationItem.title = self.expense.name;
    self.sbe = [SBExpense expenseFromCDExpense:self.expense];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 3; break;
        case 1: return self.sbe.payments.count; break;
        case 2: return self.sbe.people.count; break;
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseBasicCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.textColor = [UIColor headerColor];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text = self.expense.name;
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Date";
                NSRange dollarRange = [self.expense.unique rangeOfString:@"$"];
                NSRange dateRange = NSMakeRange(dollarRange.location+1, 10);
                NSString *dateString = [self.expense.unique substringWithRange:dateRange];
                cell.detailTextLabel.text = dateString;
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Total Amount";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.sbe.amount];
            }
            break;
        }

        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseBasicCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.textColor = [UIColor darkGreenColor];
            SBPayment *payment = [self.sbe.payments objectAtIndex:indexPath.row];
            cell.textLabel.text = payment.person.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", payment.amount];
            break;
        }

        default: break;

        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseBasicCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.textColor = [UIColor darkRedColor];
            SBPerson *person = [self.sbe.people objectAtIndex:indexPath.row];
            cell.textLabel.text = person.name;
            SBMoney *each = [[self.sbe.amount divide:self.sbe.weight] multiply:person.weight];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", each];
            break;
        }
    }

    cell.textLabel.textColor = [UIColor defaultColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0: return @"General Information"; break;
        case 1: return @"People Who Paid"; break;
        case 2: return @"People Who Should Pay"; break;
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
