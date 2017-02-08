//
//  ExpenseDetailTableViewController.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/31/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface ExpenseDetailTableViewController : UITableViewController

@property (nonatomic, strong) Expense *expense;

@end
