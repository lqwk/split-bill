//
//  ResultsViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/30/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "ResultsViewController.h"
#import "ResultTableViewCell.h"
#import "AddPaybackTableViewController.h"
#import "UIColor+SBHelper.h"
#import "Group+CoreDataClass.h"
#import "SBResult.h"
#import "SBPerson.h"
#import "SBMoney.h"

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ResultsViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 64.f;
    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(addPayback)];
    header.stateLabel.font = [UIFont boldSystemFontOfSize:14];
    header.stateLabel.textColor = [UIColor defaultColor];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"Pull down to add new Payback" forState:MJRefreshStateIdle];
    [header setTitle:@"Release to add new Payback" forState:MJRefreshStatePulling];
    [header setTitle:@"Adding new Payback" forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
}

#pragma mark - Actions

- (void)addPayback
{
    [self.tableView.mj_header endRefreshing];
    [self performSegueWithIdentifier:@"AddPayback" sender:nil];
}

- (IBAction)dismissResults:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultTableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];

    SBResult *r = [self.results objectAtIndex:indexPath.row];
    cell.lendeeName.text = r.lendee.name;
    cell.lenderName.text = r.lender.name;
    cell.amount.text = [NSString stringWithFormat:@"%@", r.amount];
    cell.lendeeName.textColor = [UIColor darkRedColor];
    cell.lenderName.textColor = [UIColor darkGreenColor];
    cell.amount.textColor = [UIColor defaultColor];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ResultTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"AddPayback" sender:cell];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"Pull down or click on any result to create a Payback.";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPayback"]) {
        UINavigationController *navc = segue.destinationViewController;
        AddPaybackTableViewController *vc = (AddPaybackTableViewController *)navc.topViewController;
        vc.group = self.group;
        vc.people = [self.group.people.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        if ([sender isKindOfClass:[ResultTableViewCell class]]) {

        } else {
            
        }
    }
}

@end
