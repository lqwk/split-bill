//
//  PeopleInvolvedTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VENCalculatorInputView/VENCalculatorInputTextField.h>

@class Person;

@interface PeopleInvolvedTableViewCell : UITableViewCell

@property (nonatomic, strong) Person *person;
@property (nonatomic) double each;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *weightTextField;
@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *shouldPayTextField;

@property (nonatomic) BOOL chosen;

- (void)setup;

@end
