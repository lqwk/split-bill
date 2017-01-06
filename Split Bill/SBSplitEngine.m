//
//  SBSplitEngine.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBSplitEngine.h"

@interface SBSplitEngine ()

@property (nonatomic, strong) NSArray<SBPerson *> *people;
@property (nonatomic, strong) NSArray<SBExpense *> *expenses;

@end

@implementation SBSplitEngine

+ (SBSplitEngine *)engineWithPeople:(NSArray<SBPerson *> *)people andExpenses:(NSArray<SBExpense *> *)expenses
{
    SBSplitEngine *engine = [[SBSplitEngine alloc] init];
    engine.people = people;
    engine.expenses = expenses;
    return engine;
}

@end
