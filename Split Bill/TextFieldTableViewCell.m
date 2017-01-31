//
//  TextFieldTableViewCell.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell () <UITextFieldDelegate>

@end

@implementation TextFieldTableViewCell

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
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.textField.inputView.frame.size.width, 50.f)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePad)]];
    [toolBar sizeToFit];
    self.textField.inputAccessoryView = toolBar;
    self.textField.delegate = self;
}

- (void)donePad
{
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"TEXT FIELD: %@", textField.text);
    if ([self.delegate respondsToSelector:@selector(textFieldCell:textFieldDidChange:)]) {
        [self.delegate textFieldCell:self textFieldDidChange:textField.text];
    }
}

@end
