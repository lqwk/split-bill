//
//  CalculatorTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VENCalculatorInputView/VENCalculatorInputTextField.h>

@class CalculatorTableViewCell;

@protocol CalculatorTableViewCellDelegate <NSObject>

@optional

- (void)calculatorCell:(CalculatorTableViewCell *)cell calculatorTextFieldDidChange:(NSString *)text;

@end

@interface CalculatorTableViewCell : UITableViewCell

@property (nonatomic, assign) id <CalculatorTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *calculatorTextField;

- (void)setup;

@end
