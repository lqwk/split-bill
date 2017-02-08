//
//  AddPersonTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "AddPersonTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "StepperTableViewCell.h"
#import "AppDelegate.h"
#import "UIColor+SBHelper.h"
#import "Person+CoreDataClass.h"
#import "Group+CoreDataClass.h"

@interface AddPersonTableViewController ()

@end

@implementation AddPersonTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - Actions

- (IBAction)cancelAddingPerson:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addPerson:(UIBarButtonItem *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TextFieldTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:nameIndexPath];
    NSString *name = [nameCell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSIndexPath *weightIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    StepperTableViewCell *weightCell = [self.tableView cellForRowAtIndexPath:weightIndexPath];
    NSInteger weight = [weightCell.weightLabel.text integerValue];

    if ([name isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Person Name Cannot Be Blank" message:@"Please enter a non-blank name for the person." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if (weight < 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Person Weight Cannot Be Zero" message:@"Please enter a non-zero weight for the person." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            Person *person = [Person personWithName:name unique:[NSString stringWithFormat:@"%@+%@", self.group.unique, name] weight:weight group:self.group inManagedObjectContext:delegate.persistentContainer.viewContext];
            [delegate saveContext];
            NSLog(@"%@", person);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            TextFieldTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddPersonTextCell" forIndexPath:indexPath];
            [temp setup];
            temp.textField.placeholder = @"Person Name";
            cell = temp;
            break;
        }

        case 1:
        {
            StepperTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddPersonStepperCell" forIndexPath:indexPath];
            temp.weightLabel.textColor = [UIColor defaultColor];
            temp.weightDescriptionLabel.textColor = [UIColor defaultColor];
            temp.stepper.tintColor = [UIColor defaultColor];
            cell = temp;
            break;
        }

        default: break;
    }

    return cell;
}

@end
