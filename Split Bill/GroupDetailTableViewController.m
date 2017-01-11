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
    // NSLog(@"%@", [[notification.userInfo objectForKey:@"updated"] class]);
    for (NSManagedObject *obj in [notification.userInfo objectForKey:@"updated"]) {
        if ([obj isKindOfClass:[Group class]]) {
            if (obj == self.group) {
                self.group = (Group *)obj;
            }
        }
        NSLog(@"UPDATED: %@", obj);
    }

    self.people = self.group.people.allObjects;
    self.expenses = self.group.expenses.allObjects;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.people = self.group.people.allObjects;
    self.expenses = self.group.expenses.allObjects;

    self.navigationItem.title = self.group.name;

    self.tableView.rowHeight = 56.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.people.count;
    } else {
        return self.expenses.count;
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
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell" forIndexPath:indexPath];
        Expense *expense = [self.expenses objectAtIndex:indexPath.row];
        cell.textLabel.text = expense.name;
        cell.detailTextLabel.text = expense.unique;
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
        // TODO: Delete the row from Core Data

        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
