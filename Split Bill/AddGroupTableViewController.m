//
//  AddGroupTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "AddGroupTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "AppDelegate.h"
#import "Group+CoreDataClass.h"
#import "NSDate+SBHelper.h"

@interface AddGroupTableViewController ()

@end

@implementation AddGroupTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)cancelAddingGroup:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addGroup:(UIBarButtonItem *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TextFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *groupName = [cell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([groupName isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Group Name Cannot Be Blank" message:@"Please enter a non-blank name for your group." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        Group *group = [Group groupWithName:groupName unique:[NSString stringWithFormat:@"%@/%@", [[NSDate date] dateID], groupName] inManagedObjectContext:delegate.persistentContainer.viewContext];
        [delegate saveContext];
        NSLog(@"%@", group);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddGroupTextCell" forIndexPath:indexPath];

    [cell setup];
    cell.textField.placeholder = @"Group Name";
    
    return cell;
}

@end
