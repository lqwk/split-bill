//
//  PersonTableViewCell.m
//  Split Bill
//
//  Created by Qingwei Lan on 2/25/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "UIColor+SBHelper.h"

@implementation PersonTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Initialization code
    self.chosen = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    if (self.chosen) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.textLabel.font = [UIFont boldSystemFontOfSize:15.f];
        if (self.isLendee) {
            self.textLabel.textColor = [UIColor darkRedColor];
        } else {
            self.textLabel.textColor = [UIColor darkGreenColor];
        }
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        self.textLabel.textColor = [UIColor defaultColor];
    }
}

@end
