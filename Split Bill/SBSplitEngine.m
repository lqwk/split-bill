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

- (NSArray<SBResult *> *)resultsForEvaluation
{
    NSMutableArray<SBResult *> *results = [NSMutableArray<SBResult *> arrayWithCapacity:0];

    for (SBExpense *expense in self.expenses) {
        [results addObjectsFromArray:[expense resultsForEvaluation]];
    }

    NSLog(@"Total Results: %@", results);

    NSMutableArray *aggregatedResults = [[NSMutableArray alloc] initWithCapacity:0];

    // Aggregate the reults
    while (results.count > 1) {
        SBResult *r1 = results[0];
        for (int i = 1; i < results.count; ++i) {
            SBResult *r2 = results[i];
            NSInteger flag = [r1 canAggregateWith:r2];
            if (flag) {
                SBResult *ar = [r1 aggregateWith:r2 withFlag:flag];
                if (ar.amount.val != 0) {
                    [results addObject:ar];
                    // [aggregatedResults addObject:ar];
                }
                [results removeObject:r1];
                [results removeObject:r2];
                break;
            }
            if (i >= results.count-1) {
                [aggregatedResults addObject:r1];
                [results removeObject:r1];
            }
        }
    }

    if (results.count == 1) {
        [aggregatedResults addObject:results[0]];
    }

    return aggregatedResults;
}

@end
