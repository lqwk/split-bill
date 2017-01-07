//
//  SBSplitEngine.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBExpense, SBResult;

@interface SBSplitEngine : NSObject

+ (SBSplitEngine *)engineWithExpenses:(NSArray<SBExpense *> *)expenses;

// Returns a list of results after evaluating each expense.
- (NSArray<SBResult *> *)resultsForEvaluation;

+ (NSArray<SBResult *> *)reducedResults:(NSArray<SBResult *> *)results;

@end
