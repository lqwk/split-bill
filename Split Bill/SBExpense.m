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
#import "SBSplitEngine.h"

@interface SBExpense ()

@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) SBMoney *amount;
@property (nonatomic) NSInteger weight;
@property (nonatomic, strong) NSArray<SBPayment *> *payments;
@property (nonatomic, strong) NSArray<SBPerson *> *people;

@property (nonatomic, strong) NSArray<SBPayment *> *involved;
@property (nonatomic, strong) NSArray<SBPayment *> *uninvolved;

@end

@implementation SBExpense

+ (SBExpense *)expenseWithName:(NSString *)name andPayments:(NSArray<SBPayment *> *)payments andPeople:(NSArray<SBPerson *> *)people
{
    SBExpense *expense = [[SBExpense alloc] init];

    expense.name = name;
    expense.people = people;
    expense.payments = payments;

    NSInteger totalWeight = 0;
    for (SBPerson *p in people) {
        totalWeight += p.weight;
    }
    expense.weight = totalWeight;

    SBMoney *total = [SBMoney moneyWithWhole:0 andDecimal:0];
    for (SBPayment *payment in payments) {
        total = [total add:payment.amount];
    }
    expense.amount = total;

    NSMutableArray *involved = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *uninvolved = [NSMutableArray arrayWithCapacity:0];
    for (SBPayment *payment in payments) {
        if ([people containsObject:payment.person]) {
            [involved addObject:payment];
        } else {
            [uninvolved addObject:payment];
        }
    }
    for (SBPerson *p in people) {
        BOOL found = NO;
        for (SBPayment *pp in involved) {
            if ([pp.person.name isEqualToString:p.name]) {
                found = YES;
                break;
            }
        }
        if (!found) {
            [involved addObject:[SBPayment paymentWithPerson:p andAmount:[SBMoney moneyWithVal:0]]];
        }
    }

    expense.involved = involved;
    expense.uninvolved = uninvolved;

    return expense;
}

#pragma mark - Main Methods

- (NSArray *)resultsForEvaluation
{
    NSMutableArray<SBResult *> *results = [NSMutableArray<SBResult *> arrayWithCapacity:0];

    // Find amount each person should pay
    SBMoney *each = [self.amount divide:self.weight];
    NSLog(@"Total expense: %@, each should pay: %@", self.amount, each);

    NSLog(@"Involved: %@", self.involved);
    NSLog(@"Uninvolved: %@", self.uninvolved);


    // delta may be positive or negative depending on how much they paid
    for (SBPayment *payment in self.involved) {
        NSMutableArray *ps = [NSMutableArray arrayWithCapacity:0];
        for (SBPayment *p in self.involved) {
            if (![payment.person.name isEqualToString:p.person.name]) {
                [ps addObject:p];
            }
        }
        NSLog(@"Non-self people payments: %@", ps);

        SBMoney *shouldPay = [each multiply:payment.person.weight];
        SBMoney *delta = [payment.amount subtract:shouldPay];
        NSLog(@"%@ paid %@, should pay %@, delta: %@", payment.person, payment.amount, shouldPay, delta);

        if (delta.val < 0) { // owes other people money
            SBMoney *eachDelta = [[delta abs] divide:self.weight];
            for (SBPayment *p in ps) {
                SBResult *result = [SBResult resultWithLendee:payment.person andLender:p.person andAmount:[eachDelta multiply:p.person.weight]];
                [results addObject:result];
            }
        } else if (delta.val > 0) { // other people owe money
            SBMoney *eachDelta = [delta divide:self.weight];
            for (SBPayment *p in ps) {
                SBResult *result = [SBResult resultWithLendee:p.person andLender:payment.person andAmount:[eachDelta multiply:p.person.weight]];
                [results addObject:result];
            }
        } else {
            continue;
        }
    }

    // delta should always be positive
    // because these uninvolved people paid for other people's expenses
    for (SBPayment *payment in self.uninvolved) {
        NSArray *ps = [self.involved copy];
        NSLog(@"Non-self people payments: %@", ps);

        SBMoney *shouldPay = [each multiply:0];
        SBMoney *delta = [payment.amount subtract:shouldPay];
        NSLog(@"%@ paid %@, should pay %@, delta: %@", payment.person, payment.amount, shouldPay, delta);

        if (delta.val == 0) {
            continue;
        } else {
            SBMoney *eachDelta = [delta divide:self.weight];
            for (SBPayment *p in ps) {
                SBResult *result = [SBResult resultWithLendee:p.person andLender:payment.person andAmount:[eachDelta multiply:p.person.weight]];
                [results addObject:result];
            }
        }
    }

    NSLog(@"Original Results: %@", results);

    return [SBSplitEngine reducedResults:results];
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Expense \"%@\" with total %@, with people: %@", self.name, self.amount, self.people];
}

@end
