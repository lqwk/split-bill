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
            Group *g = (Group *)obj;
            if ([g.unique isEqualToString:self.group.unique]) {
                self.group = g;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPerson"]) {
        UINavigationController *navc = segue.destinationViewController;
        AddPersonTableViewController *vc = (AddPersonTableViewController *)navc.topViewController;
        vc.group = self.group;
    }
}


@end
