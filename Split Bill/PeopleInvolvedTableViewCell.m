//
//  PeopleInvolvedTableViewCell.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/10/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "PeopleInvolvedTableViewCell.h"
#import "Person+CoreDataClass.h"

@implementation PeopleInvolvedTableViewCell

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

#pragma mark - Actions

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    if (!chosen) {
        self.weightTextField.hidden = YES;
        self.shouldPayTextField.hidden = YES;
    } else {
        self.weightTextField.hidden = NO;
        self.shouldPayTextField.hidden = NO;
        self.weightTextField.text = [NSString stringWithFormat:@"%lld", self.person.weight];
        // self.shouldPayTextField.text = self.each * self.person.weight;
    }
}

- (void)setup
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.weightTextField.inputView.frame.size.width, 50.f)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePad)]];
    [toolBar sizeToFit];
    self.weightTextField.inputAccessoryView = toolBar;
    self.shouldPayTextField.inputAccessoryView = toolBar;
    self.nameLabel.text = self.person.name;
}

- (void)donePad
{
    if ([self.weightTextField isFirstResponder]) {
        [self.weightTextField resignFirstResponder];
    }

    if ([self.shouldPayTextField isFirstResponder]) {
        [self.shouldPayTextField resignFirstResponder];
    }
}

@end
