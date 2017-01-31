//
//  ResultTableViewCell.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/30/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lendeeName;
@property (weak, nonatomic) IBOutlet UILabel *lenderName;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end
