//
//  CurrencySelectionTableViewController.h
//  Split Bill
//
//  Created by Qingwei Lan on 3/9/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrencySelectionTableViewController;

@protocol CurrencySelectionDelegate <NSObject>

@optional

- (void)currencySelectionTableViewController:(CurrencySelectionTableViewController *)vc didChooseCurrency:(NSString *)currency;

@end

@interface CurrencySelectionTableViewController : UITableViewController

@property (nonatomic, assign) id <CurrencySelectionDelegate> delegate;

@end
