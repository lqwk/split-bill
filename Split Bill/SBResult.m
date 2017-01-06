//
//  SBResult.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/5/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBResult.h"
#import "SBPerson.h"
#import "SBMoney.h"

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

#pragma mark - Main Methods

- (NSInteger)canAggregateWith:(SBResult *)result
{
    if ([self.lendee.name isEqualToString:result.lendee.name] && [self.lender.name isEqualToString:result.lender.name]) {
        return 1;
    } else if ([self.lendee.name isEqualToString:result.lender.name] && [self.lender.name isEqualToString:result.lendee.name]) {
        return 2;
    }

    return 0;
}

- (SBResult *)aggregateWith:(SBResult *)result withFlag:(NSInteger)flag
{
    if (flag == 1) {
        SBMoney *total = [self.amount add:result.amount];
        return [SBResult resultWithLendee:self.lendee andLender:self.lender andAmount:total];
    } else if (flag == 2) {
        SBMoney *total = [self.amount subtract:result.amount];
        if (total.val >= 0) {
            return [SBResult resultWithLendee:self.lendee andLender:self.lender andAmount:total];
        } else {
            return [SBResult resultWithLendee:result.lendee andLender:result.lender andAmount:[total abs]];
        }
    }

    return nil;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Result: %@ owes %@ %@", self.lendee, self.lender, self.amount];
}

@end
