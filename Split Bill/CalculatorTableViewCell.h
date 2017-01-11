//
//  CalculatorTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VENCalculatorInputView/VENCalculatorInputTextField.h>

@interface CalculatorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet VENCalculatorInputTextField *calculatorTextField;

- (void)setup;

@end
