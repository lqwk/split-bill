//
//  SBPayment.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBPayment.h"

@implementation SBPayment

+ (SBPayment *)paymentWithPerson:(SBPerson *)person andAmount:(SBMoney *)amount
{
    SBPayment *payment = [[SBPayment alloc] init];
    payment.person = person;
    payment.amount = amount;
    return payment;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"Payment: %@ paid %@", self.person, self.amount];
}

@end
