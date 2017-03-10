//
//  CurrencySelectionTableViewController.m
//  Split Bill
//
//  Created by Qingwei Lan on 3/9/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "CurrencySelectionTableViewController.h"
#import "UIColor+SBHelper.h"
#import "AppDelegate.h"

@interface CurrencySelectionTableViewController ()

@property (nonatomic, strong) NSDictionary *currencies;
@property (nonatomic, strong) NSArray *orderedCurrencyKeys;
@property (nonatomic, strong) NSIndexPath *chosenIndexPath;

@property (nonatomic, strong) NSArray *sectionNames;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic, strong) NSDictionary *sectionsDictionary;

@end

@implementation CurrencySelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor backgroundColor]];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    NSMutableDictionary *sectionsDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    self.sectionNames = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    for (NSString *sectionName in self.sectionNames) {
        [sectionsDictionary setObject:[NSMutableArray arrayWithCapacity:0] forKey:sectionName];
    }

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.currencies = delegate.currencies;
    self.orderedCurrencyKeys = [self.currencies keysSortedByValueUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSString *c1 = [obj1 objectAtIndex:0];
        NSString *c2 = [obj2 objectAtIndex:0];
        return [c1 localizedCompare:c2];
    }];

    for (NSString *key in self.orderedCurrencyKeys) {
        NSArray *currencyDetails = [self.currencies objectForKey:key];
        NSString *currencyName = [currencyDetails objectAtIndex:0];
        NSString *startingLetter = [currencyName substringToIndex:1];
        [((NSMutableArray *)[sectionsDictionary objectForKey:startingLetter]) addObject:key];
    }

    for (NSString *key in sectionsDictionary.allKeys) {
        NSArray *values = [sectionsDictionary objectForKey:key];
        if (values.count == 0) {
            [sectionsDictionary removeObjectForKey:key];
        }
    }

    self.sectionsDictionary = sectionsDictionary;
    NSArray *sortedKeys = [self.sectionsDictionary.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    self.sortedKeys = sortedKeys;

    NSLog(@"%@", self.currency);
    if (self.currency) {
        NSIndexPath *indexPath = [self indexPathForCurrency:self.currency];
        self.chosenIndexPath = indexPath;
    } else {
        self.chosenIndexPath = [NSIndexPath indexPathForRow:2 inSection:20];
    }
}

#pragma mark - Actions

- (IBAction)chooseCurrency:(UIBarButtonItem *)sender
{
    UITableViewCell *chosenCell = [self.tableView cellForRowAtIndexPath:self.chosenIndexPath];
    NSString *currency = [chosenCell.detailTextLabel.text substringToIndex:3];
    if ([self.delegate respondsToSelector:@selector(currencySelectionTableViewController:didChooseCurrency:)]) {
        [self.delegate currencySelectionTableViewController:self didChooseCurrency:currency];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelCurrencySelection:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setChosenIndexPath:(NSIndexPath *)chosenIndexPath
{
    _chosenIndexPath = chosenIndexPath;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.chosenIndexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortedKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.sortedKeys objectAtIndex:section];
    NSArray *values = [self.sectionsDictionary objectForKey:key];
    return values.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencySelectionCell" forIndexPath:indexPath];


    NSString *key = [self.sortedKeys objectAtIndex:indexPath.section];
    NSString *currency = [[self.sectionsDictionary objectForKey:key] objectAtIndex:indexPath.row];
    NSArray *currencyDetails = [self.currencies objectForKey:currency];
    cell.textLabel.text = [currencyDetails objectAtIndex:0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@", currency, [currencyDetails objectAtIndex:1]];
    if ([indexPath compare:self.chosenIndexPath] == NSOrderedSame) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.textColor = [UIColor defaultColor];
    cell.detailTextLabel.textColor = [UIColor headerColor];

    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionNames;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.sectionNames indexOfObject:title];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sortedKeys objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.chosenIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    self.chosenIndexPath = indexPath;
}

#pragma mark - Helpers

- (NSIndexPath *)indexPathForCurrency:(NSString *)currency
{
    NSArray *currencyDetails = [self.currencies objectForKey:currency];
    NSString *currencyName = [currencyDetails objectAtIndex:0];
    NSString *startingChar = [currencyName substringToIndex:1];
    NSUInteger section = [self.sortedKeys indexOfObject:startingChar];
    NSArray *sectionInfo = [self.sectionsDictionary objectForKey:startingChar];
    NSUInteger row = [sectionInfo indexOfObject:currency];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return indexPath;
}

@end
