//
//  SBResult.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/5/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBResult.h"

@interface SBResult ()

@property (nonatomic, strong, readwrite) SBPerson *lendee;
@property (nonatomic, strong, readwrite) SBPerson *lender;
@property (nonatomic, strong, readwrite) SBMoney *amount;

@end

@implementation SBResult

+ (SBResult *)resultWithLendee:(SBPerson *)lendee
                     andLender:(SBPerson *)lender
                     andAmount:(SBMoney *)amount
{
    SBResult *result = [[SBResult alloc] init];
    result.lendee = lendee;
    result.lender = lender;
    result.amount = amount;
    return result;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Result: %@ owes %@ %@", self.lendee, self.lender, self.amount];
}

@end
