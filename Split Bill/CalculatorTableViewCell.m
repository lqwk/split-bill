//
//  CalculatorTableViewCell.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "CalculatorTableViewCell.h"
#import "UIColor+SBHelper.h"

@interface CalculatorTableViewCell () <UITextFieldDelegate>

@end

@implementation CalculatorTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.calculatorTextField.inputView.frame.size.width, 50.f)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePad)]];
    [toolBar sizeToFit];
    self.calculatorTextField.inputAccessoryView = toolBar;
    self.calculatorTextField.delegate = self;

    self.calculatorTextField.placeholder = @"Total Cost of Expense";
    self.calculatorTextField.textColor = [UIColor defaultColor];
}

- (void)donePad
{
    [self.calculatorTextField resignFirstResponder];
}

# pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Called CalculatorDelegate: %@", textField.text);
    if ([self.delegate respondsToSelector:@selector(calculatorCell:calculatorTextFieldDidChange:)]) {
        [self.delegate calculatorCell:self calculatorTextFieldDidChange:textField.text];
    }
}

@end
