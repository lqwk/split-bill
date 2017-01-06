//
//  SBExpense.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPayment;
@class SBResult;

@interface SBExpense : NSObject

@property (nonatomic, strong, readonly) NSString *name;

+ (SBExpense *)expenseWithName:(NSString *)name andPayments:(NSArray<SBPayment *> *)payments;

// Returns a list of results after evaluating each payment in the expense.
- (NSArray<SBResult *> *)resultsForEvaluation;

@end
