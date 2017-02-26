//
//  ResultsViewController.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/30/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBResult, Group;

@interface ResultsViewController : UIViewController

@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) NSArray *results;

@end
