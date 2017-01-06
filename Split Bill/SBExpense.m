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
@property (nonatomic, strong) NSArray<SBPerson *> *people;

@end

@implementation SBExpense

+ (SBExpense *)expenseWithName:(NSString *)name andPayments:(NSArray<SBPayment *> *)payments andPeople:(NSArray<SBPerson *> *)people;
{
    SBExpense *expense = [[SBExpense alloc] init];
    expense.name = name;
    expense.payments = payments;
    expense.people = people;
    return expense;
}

#pragma mark - Main Methods

- (NSArray *)resultsForEvaluation
{
    NSMutableArray<SBResult *> *results = [NSMutableArray<SBResult *> arrayWithCapacity:0];

    SBMoney *total = [SBMoney moneyWithWhole:0 andDecimal:0];
    for (SBPayment *payment in self.payments) {
        [total add:payment.amount];
    }

    return results;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Expense \"%@\" with payments: %@ for people: %@", self.name, self.payments, self.people];
}

@end
