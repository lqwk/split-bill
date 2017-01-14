//
//  PeoplePaymentTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VENCalculatorInputView/VENCalculatorInputTextField.h>

@class Person, PeoplePaymentTableViewCell;

@protocol PeoplePaymentCellDelegate <NSObject>

@optional

- (void)weightDidChangeForPeoplePaymentCell:(PeoplePaymentTableViewCell *)cell;

@end

@interface PeoplePaymentTableViewCell : UITableViewCell

@property (nonatomic, assign) id <PeoplePaymentCellDelegate> delegate;

@property (nonatomic, strong) Person *person;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *paymentTextfield;

@property (nonatomic) double eachPayment;

@property (nonatomic) BOOL chosen;

- (void)setup;

@end
