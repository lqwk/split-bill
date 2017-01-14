//
//  StepperTableViewCell.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "StepperTableViewCell.h"

@implementation StepperTableViewCell

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

- (IBAction)valueChanged:(UIStepper *)sender
{
    NSInteger val = sender.value;
    self.weightLabel.text = [NSString stringWithFormat:@"%ld", val];
}

@end
