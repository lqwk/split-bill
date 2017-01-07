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
    } else if ([self.lender.name isEqualToString:result.lendee.name] && ![self.lendee.name isEqualToString:result.lender.name]) {
        return 3;
    } else if ([self.lendee.name isEqualToString:result.lender.name] && ![self.lender.name isEqualToString:result.lendee.name]) {
        return 4;
    }

    return 0;
}

- (NSArray<SBResult *> *)aggregateWith:(SBResult *)result withFlag:(NSInteger)flag
{
    if (flag == 1) {
        SBMoney *total = [self.amount add:result.amount];
        return [NSArray arrayWithObject:[SBResult resultWithLendee:self.lendee andLender:self.lender andAmount:total]];
    } else if (flag == 2) {
        SBMoney *total = [self.amount subtract:result.amount];
        if (total.val >= 0) {
            return [NSArray arrayWithObject:[SBResult resultWithLendee:self.lendee andLender:self.lender andAmount:total]];
        } else {
            return [NSArray arrayWithObject:[SBResult resultWithLendee:result.lendee andLender:result.lender andAmount:[total abs]]];
        }
    } else if (flag == 3 || flag == 4) {
        SBResult *r1 = nil;
        SBResult *r2 = nil;

        if (flag == 3) {
            r1 = self;
            r2 = result;
        } else {
            r1 = result;
            r2 = self;
        }

        if (r1.amount.val == r2.amount.val) {
            return [NSArray arrayWithObject:[SBResult resultWithLendee:r1.lendee andLender:r2.lender andAmount:r1.amount]];
        } else if (r1.amount.val < r2.amount.val) {
            SBMoney *delta = [r2.amount subtract:r1.amount];
            return [NSArray arrayWithObjects:[SBResult resultWithLendee:r1.lendee andLender:r2.lender andAmount:r1.amount], [SBResult resultWithLendee:r1.lender andLender:r2.lender andAmount:delta], nil];
        } else if (r1.amount.val > r2.amount.val) {
            SBMoney *delta = [r1.amount subtract:r2.amount];
            return [NSArray arrayWithObjects:[SBResult resultWithLendee:r1.lendee andLender:r1.lender andAmount:delta], [SBResult resultWithLendee:r1.lendee andLender:r2.lender andAmount:r2.amount], nil];
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
