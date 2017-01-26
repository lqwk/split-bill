//
//  AddPersonTableViewController.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface AddPersonTableViewController : UITableViewController

// This property can never be nil.
// Always need to be set when view is created.
@property (nonatomic, strong) Group *group;

@end
