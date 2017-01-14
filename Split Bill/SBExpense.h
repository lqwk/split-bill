//
//  SBExpense.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPayment, SBPerson, SBResult, SBMoney;
@class Expense;

@interface SBExpense : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) SBMoney *amount;

+ (SBExpense *)expenseWithName:(NSString *)name andPayments:(NSArray<SBPayment *> *)payments andPeople:(NSArray<SBPerson *> *)people;

// Convert Core Data <Expense> to <SBExpense>
+ (SBExpense *)expenseFromCDExpense:(Expense *)expense;

// Returns a list of results after evaluating each payment in the expense.
- (NSArray<SBResult *> *)resultsForEvaluation;

@end
