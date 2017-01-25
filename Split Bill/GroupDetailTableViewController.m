//
//  GroupDetailTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "GroupDetailTableViewController.h"
#import "Group+CoreDataClass.h"
#import "Person+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "AddPersonTableViewController.h"
#import "AddExpenseTableViewController.h"
#import "SBExpense.h"
#import "SBSplitEngine.h"
#import "AppDelegate.h"

@interface GroupDetailTableViewController ()

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) NSArray *expenses;

@end

@implementation GroupDetailTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

- (void)handleContextChange:(NSNotification *)notification
{
    for (NSManagedObject *obj in [notification.userInfo objectForKey:@"updated"]) {
        if ([obj isKindOfClass:[Group class]]) {
            if (obj == self.group) {
                self.group = (Group *)obj;
            }
        }
        NSLog(@"UPDATED: %@", obj);
    }

    self.people = [self.group.people.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    self.expenses = [self.group.expenses.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES]]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.people = [self.group.people.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    self.expenses = [self.group.expenses.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:YES]]];

    self.navigationItem.title = self.group.name;

    self.tableView.rowHeight = 56.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.people.count;
    } else if (section == 1) {
        return self.expenses.count;
    } else {
        return 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
        Person *person = [self.people objectAtIndex:indexPath.row];
        cell.textLabel.text = person.name;
        cell.detailTextLabel.text = person.unique;
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell" forIndexPath:indexPath];
        Expense *expense = [self.expenses objectAtIndex:indexPath.row];
        cell.textLabel.text = expense.name;
        cell.detailTextLabel.text = expense.unique;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateCell" forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"People";
    } else {
        return @"Expenses";
    }

    return @"";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (indexPath.section == 0) {
            // Delete a person
            Person *person = [self.people objectAtIndex:indexPath.row];
            [delegate.persistentContainer.viewContext deleteObject:person];
            [delegate saveContext];
        } else if (indexPath.section == 1) {
            // Delete an expense
            Expense *expense = [self.expenses objectAtIndex:indexPath.row];
            [delegate.persistentContainer.viewContext deleteObject:expense];
            [delegate saveContext];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        Person *person = [self.people objectAtIndex:indexPath.row];
        NSLog(@"PERSON: %@", person);
        for (Expense *e in person.expensesInvolved) {
            NSLog(@"EXPENSE: %@", e);
        }
        for (Payment *p in person.paymentsMade) {
            NSLog(@"PAYMENT: %@", p);
        }
    } else if (indexPath.section == 2) {
        NSMutableArray *expenses = [NSMutableArray arrayWithCapacity:0];
        for (Expense *e in self.expenses) {
            SBExpense *expense = [SBExpense expenseFromCDExpense:e];
            [expenses addObject:expense];
            NSLog(@"CONVERTED SBEXPENSE: %@", expense);
        }
        SBSplitEngine *se = [SBSplitEngine engineWithExpenses:expenses];
        NSArray *results = [se resultsForEvaluation];
        NSLog(@"FINAL RESULTS: %@", results);
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPerson"]) {
        UINavigationController *navc = segue.destinationViewController;
        AddPersonTableViewController *vc = (AddPersonTableViewController *)navc.topViewController;
        vc.group = self.group;
    } else if ([segue.identifier isEqualToString:@"AddExpense"]) {
        UINavigationController *navc = segue.destinationViewController;
        AddExpenseTableViewController *vc = (AddExpenseTableViewController *)navc.topViewController;
        vc.group = self.group;
        vc.people = self.people;
    }
}


@end
