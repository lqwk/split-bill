//
//  TextFieldTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextFieldTableViewCell;

@protocol TextFieldTableViewCellDelegate <NSObject>

@optional

- (void)textFieldCell:(TextFieldTableViewCell *)cell textFieldDidChange:(NSString *)text;

@end

@interface TextFieldTableViewCell : UITableViewCell

@property (nonatomic, assign) id <TextFieldTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)setup;

@end
