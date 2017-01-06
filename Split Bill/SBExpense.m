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
    NSLog(@"Total expense: %@, each should pay: %@", total, each);

    for (SBPayment *payment in self.payments) {
        NSMutableArray *people = [[NSMutableArray alloc] initWithCapacity:0];
        for (SBPayment *p in self.payments) {
            if (![payment isEqual:p]) {
                [people addObject:p.person];
            }
        }
        NSLog(@"%@", people);

        SBMoney *shouldPay = [each multiply:payment.person.weight];
        SBMoney *delta = [payment.amount subtract:shouldPay];
        NSLog(@"%@ paid %@, should pay %@, delta: %@", payment.person, payment.amount, shouldPay, delta);

        if (delta.val < 0) { // owes other people money
            SBMoney *eachDelta = [[delta abs] divide:totalWeight];
            for (SBPerson *person in people) {
                SBResult *result = [SBResult resultWithLendee:payment.person andLender:person andAmount:[eachDelta multiply:person.weight]];
                [results addObject:result];
            }
        } else if (delta.val > 0) { // other people owe money
            SBMoney *eachDelta = [delta divide:totalWeight];
            for (SBPerson *person in people) {
                SBResult *result = [SBResult resultWithLendee:person andLender:payment.person andAmount:[eachDelta multiply:person.weight]];
                [results addObject:result];
            }
        }
    }

    NSLog(@"Original Results: %@", results);

    NSMutableArray *aggregatedResults = [[NSMutableArray alloc] initWithCapacity:0];

    // Aggregate the reults
    while (results.count) {
        SBResult *r1 = results[0];
        for (int i = 1; i < results.count; ++i) {
            SBResult *r2 = results[i];
            NSInteger flag = [r1 canAggregateWith:r2];
            if (flag) {
                SBResult *ar = [r1 aggregateWith:r2 withFlag:flag];
                if (ar.amount.val != 0) {
                    [aggregatedResults addObject:ar];
                }
                [results removeObject:r1];
                [results removeObject:r2];
                break;
            }
            if (i == results.count-1) {
                [aggregatedResults addObject:r1];
                [results removeObject:r1];
            }
        }
    }

    return aggregatedResults;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Expense \"%@\" with payments: %@", self.name, self.payments];
}

@end
