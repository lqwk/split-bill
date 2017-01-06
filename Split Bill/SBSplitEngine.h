//
//  SBSplitEngine.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPerson;
@class SBExpense;

@interface SBSplitEngine : NSObject

+ (SBSplitEngine *)engineWithPeople:(NSArray<SBPerson *> *)people andExpenses:(NSArray<SBExpense *> *)expenses;

@end
