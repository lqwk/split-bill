//
//  GroupDetailsViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/25/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "GroupDetailsViewController.h"
#import "AppDelegate.h"
#import "Group+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "Person+CoreDataClass.h"
#import "Payment+CoreDataClass.h"
#import "AddPersonTableViewController.h"
#import "AddExpenseTableViewController.h"

@interface GroupDetailsViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) BOOL showExpenses;

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation GroupDetailsViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.group.name;

    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loadFetchResultsController];

    self.tableView.rowHeight = 56.f;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(addNewCell) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Actions

- (void)addNewCell
{
    if (self.showExpenses) {
        [self performSegueWithIdentifier:@"AddExpense" sender:self];
    } else {
        [self performSegueWithIdentifier:@"AddPerson" sender:self];
    }
}

- (IBAction)valueChangedForSegmentedControl:(UISegmentedControl *)sender
{
    [self loadFetchResultsController];
    [self.tableView reloadData];
}

- (void)loadFetchResultsController
{
    self.showExpenses = self.segmentedControl.selectedSegmentIndex == 0;

    NSFetchRequest *req = nil;
    if (self.showExpenses) {
        // Fetch expenses
        req = [[NSFetchRequest alloc] initWithEntityName:@"Expense"];
    } else {
        // Fetch people
        req = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    }

    req.predicate = [NSPredicate predicateWithFormat:@"unique CONTAINS %@", self.group.name];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"unique" ascending:NO selector:@selector(localizedStandardCompare:)]];

    NSError *error;

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:self.delegate.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;

    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.showExpenses) {
        // Configure for Expense
        Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = expense.name;
        cell.detailTextLabel.text = expense.unique;
    } else {
        // Configure for Person
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = person.name;
        cell.detailTextLabel.text = person.unique;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    NSInteger numberOfObjects = [sectionInfo numberOfObjects];
    return numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    if (self.showExpenses) {
        // Use ExpenseCell
        cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell"];
    } else {
        // Use PersonCell
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    }

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        default: break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications,
    // so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.showExpenses) {
            // Delete an Expense
            Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.delegate.persistentContainer.viewContext deleteObject:person];
            [self.delegate saveContext];
        } else {
            // Delete a Person
            Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.delegate.persistentContainer.viewContext deleteObject:expense];
            [self.delegate saveContext];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.showExpenses) {
        // Show Expense
        NSLog(@"=========================================");
        Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"EXPENSE: %@", expense);
        for (Person *p in expense.peopleInvolved)
            NSLog(@"PERSON INVOLVED: %@", p);
        for (Payment *pm in expense.paymentsInvolved)
            NSLog(@"PAYMENT INVOLVED: %@", pm);
        NSLog(@"=========================================");
    } else {
        // Show Person
        NSLog(@"=========================================");
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"PERSON: %@", person);
        for (Expense *e in person.expensesInvolved)
            NSLog(@"EXPENSE INVOLVED: %@", e);
        for (Payment *p in person.paymentsMade)
            NSLog(@"PAYMENT MADE: %@", p);
        NSLog(@"=========================================");
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
        vc.people = [self.group.people.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
}

@end
