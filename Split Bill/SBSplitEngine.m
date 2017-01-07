//
//  SBSplitEngine.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBSplitEngine.h"
#import "SBExpense.h"
#import "SBResult.h"
#import "SBMoney.h"

@interface SBSplitEngine ()

@property (nonatomic, strong) NSArray<SBExpense *> *expenses;

@end

@implementation SBSplitEngine

+ (SBSplitEngine *)engineWithExpenses:(NSArray<SBExpense *> *)expenses;
{
    SBSplitEngine *engine = [[SBSplitEngine alloc] init];
    engine.expenses = expenses;
    return engine;
}

#pragma mark - Main Methods

- (NSArray<SBResult *> *)resultsForEvaluation
{
    NSMutableArray<SBResult *> *results = [NSMutableArray<SBResult *> arrayWithCapacity:0];

    for (SBExpense *expense in self.expenses) {
        [results addObjectsFromArray:[expense resultsForEvaluation]];
    }

    NSLog(@"Total Results: %@", results);

    return [SBSplitEngine reducedResults:results];
}

+ (NSArray<SBResult *> *)reducedResults:(NSArray<SBResult *> *)results
{
    NSMutableArray *reducedResults = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempResults = [results mutableCopy];

    while (tempResults.count > 1) {
        SBResult *r1 = tempResults[0];
        for (int i = 1; i < tempResults.count; ++i) {
            SBResult *r2 = tempResults[i];
            NSInteger flag = [r1 canAggregateWith:r2];
            if (flag) {
                NSArray *ar = [r1 aggregateWith:r2 withFlag:flag];
                for (SBResult *a in ar) {
                    if (a.amount.val != 0) {
                        [tempResults addObject:a];
                    }
                }
                [tempResults removeObject:r1];
                [tempResults removeObject:r2];
                break;
            }
            if (i >= results.count-1) {
                [reducedResults addObject:r1];
                [tempResults removeObject:r1];
            }
        }
    }

    if (tempResults.count == 1) {
        [reducedResults addObject:tempResults[0]];
    }

    return reducedResults;
}

@end
