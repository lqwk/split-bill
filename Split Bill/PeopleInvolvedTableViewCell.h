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
@class PeopleInvolvedTableViewCell;

@protocol PeopleInvolvedCellDelegate <NSObject>

@optional

- (void)weightDidChangeForPeopleInvolvedCell:(PeopleInvolvedTableViewCell *)cell;

@end

@interface PeopleInvolvedTableViewCell : UITableViewCell

@property (nonatomic, assign) id <PeopleInvolvedCellDelegate> delegate;

@property (nonatomic, strong) Person *person;
@property (nonatomic) double eachCost;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *shouldPayTextField;

@property (nonatomic) BOOL chosen;

- (void)setup;

@end
