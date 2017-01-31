//
//  ResultsViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/30/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultTableViewCell.h"
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
}

#pragma mark - Actions

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

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
