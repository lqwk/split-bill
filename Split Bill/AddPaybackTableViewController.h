//
//  AddPaybackTableViewController.h
//  Split Bill
//
//  Created by Qingwei Lan on 2/25/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface AddPaybackTableViewController : UITableViewController

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) NSArray *people;

@end
