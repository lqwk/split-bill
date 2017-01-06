//
//  SBExpense.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBExpense.h"
#import "SBPayment.h"
#import "SBPerson.h"
#import "SBResult.h"
#import "SBMoney.h"

@interface SBExpense ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong) NSArray<SBPayment *> *payments;

@end

@implementation SBExpense

+ (SBExpense *)expenseWithName:(NSString *)name andPayments:(NSArray<SBPayment *> *)payments;
{
    SBExpense *expense = [[SBExpense alloc] init];
    expense.name = name;
    expense.payments = payments;
    return expense;
}

#pragma mark - Main Methods

- (NSArray *)resultsForEvaluation
{
    NSMutableArray<SBResult *> *results = [NSMutableArray<SBResult *> arrayWithCapacity:0];

    // Accumulate cost and weight
    SBMoney *total = [SBMoney moneyWithWhole:0 andDecimal:0];
    NSInteger totalWeight = 0;
    for (SBPayment *payment in self.payments) {
        total = [total add:payment.amount];
        totalWeight += payment.person.weight;
    }

    SBMoney *each = [total divide:totalWeight];
    NSLog(@"Total: %@, Each: %@", total, each);

    for (SBPayment *payment in self.payments) {
        SBMoney *shouldPay = [each multiply:payment.person.weight];
        SBMoney *delta = [payment.amount subtract:shouldPay];
        NSLog(@"%@ paid %@, should pay %@, delta: %@", payment.person, payment.amount, shouldPay, delta);

    }

    return results;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Expense \"%@\" with payments: %@", self.name, self.payments];
}

@end
