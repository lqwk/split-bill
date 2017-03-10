//
//  PersonTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 2/25/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PersonTableViewCell : UITableViewCell

@property (nonatomic) BOOL chosen;
@property (nonatomic, strong) Person *person;

@end
