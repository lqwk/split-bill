//
//  SBExpense.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBExpense.h"

@implementation SBExpense

+ (SBExpense *)expenseWithPayments:(NSArray<SBPayment *> *)payments
{
    SBExpense *expense = [[SBExpense alloc] init];
    expense.payments = payments;
    return expense;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Expense with payments: %@", self.payments];
}

@end
