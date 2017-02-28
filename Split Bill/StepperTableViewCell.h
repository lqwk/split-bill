//
//  StepperTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepperTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end
