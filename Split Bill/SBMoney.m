//
//  SBMoney.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBMoney.h"

@implementation SBMoney

+ (SBMoney *)moneyWithWhole:(NSInteger)whole andDecimal:(NSInteger)decimal
{
    SBMoney *money = [[SBMoney alloc] init];
    money.whole = whole;
    money.decimal = decimal;
    return money;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld.%ld", self.whole, self.decimal];
}

@end
