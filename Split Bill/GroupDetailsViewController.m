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
#import "UIColor+SBHelper.h"
#import "Group+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "Person+CoreDataClass.h"
#import "Payment+CoreDataClass.h"
#import "AddPersonTableViewController.h"
#import "AddExpenseTableViewController.h"
#import "ResultsViewController.h"
#import "PersonDetailTableViewController.h"
#import "ExpenseDetailTableViewController.h"
#import "SBExpense.h"
#import "SBSplitEngine.h"

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

    self.showExpenses = self.segmentedControl.selectedSegmentIndex == 0;

    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loadFetchResultsController];

    self.tableView.rowHeight = 56.f;
    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-32, 0, 0, 0);

    self.segmentedControl.tintColor = [UIColor bruinColor];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor clearColor];
    [self switchRefreshControlText];
    [self.refreshControl addTarget:self action:@selector(addNewCell) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Actions

- (void)switchRefreshControlText
{
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor darkRedColor],
                                  NSFontAttributeName : [UIFont boldSystemFontOfSize:12.f] };
    if (self.showExpenses) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to add new Expense" attributes:attributes];
    } else {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull down to add new Person" attributes:attributes];
    }
}

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
    self.showExpenses = self.segmentedControl.selectedSegmentIndex == 0;
    [self switchRefreshControlText];
    [self loadFetchResultsController];
    [self.tableView reloadData];
}

- (void)loadFetchResultsController
{
    self.fetchedResultsController.delegate = self;
    self.fetchedResultsController = nil;

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
    NSLog(@"Configure %@, %@", indexPath, cell);
    if (self.showExpenses) {
        // Configure for Expense
        Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (expense.isPayback) {
            // Configure for Payback
        } else {
            // Configure for Ordinary Expense
            cell.textLabel.text = expense.name;
            SBExpense *e = [SBExpense expenseFromCDExpense:expense];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", e.amount];
        }
    } else {
        // Configure for Person
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = person.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Weight: %lld", person.weight];
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
        Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if (expense.isPayback) {
            // Use PaybackCell
            NSLog(@"IS PAYBACK");
        } else {
            // Use ExpenseCell
            NSLog(@"IS EXPENSE");
            cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell"];
        }
    } else {
        // Use PersonCell
        NSLog(@"IS PERSON");
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    }

    cell.textLabel.textColor = [UIColor defaultColor];
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (self.showExpenses) {
            // Delete an Expense
            Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.delegate.persistentContainer.viewContext deleteObject:expense];
            [self.delegate saveContext];
        } else {
            // Delete a Person
            // Delete all expenses related to the Person first
            Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
            NSString *personUnique = person.unique;

            // Fetch all related Expenses
            NSFetchRequest *expenseRequest = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
            expenseRequest.predicate = [NSPredicate predicateWithFormat:@"( ANY peopleInvolved.unique == %@ ) OR ( ANY paymentsInvolved.person.unique == %@ )", personUnique, personUnique];
            NSError *error;
            NSArray *results = [self.delegate.persistentContainer.viewContext executeFetchRequest:expenseRequest error:&error];
            if (!results || error) {
                NSLog(@"ERROR in fetching EXPENSE with personUnique: %@", personUnique);
            } else if (results.count == 0) {
                NSLog(@"Didn't find EXPENSE with personUnique: %@", personUnique);
            } else {
                for (Expense *expense in results) {
                    NSLog(@"Found expense: %@", expense);
                    [self.delegate.persistentContainer.viewContext deleteObject:expense];
                }
                [self.delegate saveContext];
            }

            // Delete the person
            [self.delegate.persistentContainer.viewContext deleteObject:person];
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
    NSLog(@"NUM OBJECTS: %lu", self.fetchedResultsController.fetchedObjects.count);

    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            NSLog(@"Deleting cell at %@", indexPath);
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            NSLog(@"Updating cell at %@", indexPath);
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
    } else if ([segue.identifier isEqualToString:@"ShowResults"]) {
        NSArray *results = [NSArray array];

        UINavigationController *navc = segue.destinationViewController;
        ResultsViewController *vc = (ResultsViewController *)navc.topViewController;

        // Evaluate the results
        // Get all Expenses from Core Data
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
        request.predicate = [NSPredicate predicateWithFormat:@"unique CONTAINS %@", self.group.name];
        NSError *error;
        NSArray *matches = [self.delegate.persistentContainer.viewContext executeFetchRequest:request error:&error];

        if (!matches || error) {
            NSLog(@"ERROR in fetching EXPENSE for GROUP: %@", self.group.name);
        } else if (matches.count == 0) {
            NSLog(@"No matches for EXPENSE for GROUP: %@", self.group.name);
        } else {
            // Convert Expenses to SBExpense
            NSMutableArray *expenses = [NSMutableArray arrayWithCapacity:0];
            for (Expense *e in matches) {
                SBExpense *expense = [SBExpense expenseFromCDExpense:e];
                [expenses addObject:expense];
                NSLog(@"CONVERTED SBEXPENSE: %@", expense);
                SBSplitEngine *se = [SBSplitEngine engineWithExpenses:expenses];
                results = [se resultsForEvaluation];
                NSLog(@"FINAL RESULTS: %@", results);
            }
        }
        vc.results = results;
        vc.group = self.group;
    } else if ([segue.identifier isEqualToString:@"ShowPersonDetail"]) {
        PersonDetailTableViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.person = person;
    } else if ([segue.identifier isEqualToString:@"ShowExpenseDetail"]) {
        ExpenseDetailTableViewController *vc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Expense *expense = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.expense = expense;
    }
}

@end
