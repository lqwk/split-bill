//
//  AddExpenseTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "AddExpenseTableViewController.h"
#import "TextFieldTableViewCell.h"
#import "CalculatorTableViewCell.h"
#import "AppDelegate.h"

@interface AddExpenseTableViewController ()

@end

@implementation AddExpenseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)cancelAddingExpense:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addExpense:(UIBarButtonItem *)sender
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    // NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // TextFieldTableViewCell *nameCell = [self.tableView cellForRowAtIndexPath:nameIndexPath];
    // NSString *name = [nameCell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    // NSIndexPath *weightIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    // StepperTableViewCell *weightCell = [self.tableView cellForRowAtIndexPath:weightIndexPath];
    // NSInteger weight = [weightCell.weightLabel.text integerValue];

    // if ([name isEqualToString:@""]) {
    //     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Person Name Cannot Be Blank" message:@"Please enter a non-blank name for the person." preferredStyle:UIAlertControllerStyleAlert];
    //     UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    //     [alert addAction:action];
    //     [self presentViewController:alert animated:YES completion:nil];
    // } else {
    //     if (weight < 1) {
    //         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Person Weight Cannot Be Zero" message:@"Please enter a non-zero weight for the person." preferredStyle:UIAlertControllerStyleAlert];
    //         UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    //         [alert addAction:action];
    //         [self presentViewController:alert animated:YES completion:nil];
    //     } else {
    //         Person *person = [Person personWithName:name unique:[NSString stringWithFormat:@"%@+%@", self.group.unique, name] weight:weight group:self.group inManagedObjectContext:delegate.persistentContainer.viewContext];
    //         [delegate saveContext];
    //         NSLog(@"%@", person);
    //         [self dismissViewControllerAnimated:YES completion:nil];
    //     }
    // }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    switch (section) {
        case 0: return 2; break;
        case 1: return 1; break;
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
            switch (indexPath.row) {
                case 0:
                {
                    TextFieldTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddExpenseTextCell" forIndexPath:indexPath];
                    temp.textField.placeholder = @"Name of Expense";
                    cell = temp;
                    break;
                }

                case 1:
                {
                    CalculatorTableViewCell *temp = [tableView dequeueReusableCellWithIdentifier:@"AddExpenseCalculatorCell" forIndexPath:indexPath];
                    temp.calculatorTextField.placeholder = @"Total Cost of Expense";
                    cell = temp;
                    break;
                }

                default: break;
            }

            break;
        }

        default: break;
    }

    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
