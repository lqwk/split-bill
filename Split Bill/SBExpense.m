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

@interface SBExpense ()

@property (nonatomic, strong) NSArray<SBPayment *> *payments;
@property (nonatomic, strong) NSArray<SBPerson *> *people;

@end

@implementation SBExpense

+ (SBExpense *)expenseWithPayments:(NSArray<SBPayment *> *)payments andPeople:(NSArray *)people
{
    SBExpense *expense = [[SBExpense alloc] init];
    expense.payments = payments;
    expense.people = people;
    return expense;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Expense with payments: %@ for people: %@", self.payments, self.people];
}

@end
