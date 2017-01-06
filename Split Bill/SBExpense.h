//
//  SBExpense.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPayment;
@class SBMoney;

@interface SBExpense : NSObject

@property (nonatomic, strong) SBMoney *amount;
@property (nonatomic, strong) NSArray<SBPayment *> *payments;

+ (SBExpense *)expenseWithPayments:(NSArray<SBPayment *> *)payments;

@end
