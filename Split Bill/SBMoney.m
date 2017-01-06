//
//  SBMoney.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBMoney.h"

@interface SBMoney ()

@property (nonatomic, readwrite) NSInteger val;

@end

@implementation SBMoney

+ (SBMoney *)moneyWithWhole:(NSInteger)whole andDecimal:(NSInteger)decimal
{
    SBMoney *money = [[SBMoney alloc] init];
    money.val = whole * 100 + decimal;
    return money;
}

+(SBMoney *)moneyWithVal:(NSInteger)val
{
    SBMoney *money = [[SBMoney alloc] init];
    money.val = val;
    return money;
}

#pragma mark - Main Methods

- (SBMoney *)add:(SBMoney *)amount
{
    double absolute = (double)self.val + (double)amount.val;
    if (absolute > 0) {
        absolute += 0.5;
    } else if (absolute < 0) {
        absolute -= 0.5;
    }
    NSInteger val = absolute;
    return [SBMoney moneyWithVal:val];
}

- (SBMoney *)subtract:(SBMoney *)amount
{
    double absolute = (double)self.val - (double)amount.val;
    if (absolute > 0) {
        absolute += 0.5;
    } else if (absolute < 0) {
        absolute -= 0.5;
    }
    NSInteger val = absolute;
    return [SBMoney moneyWithVal:val];
}

- (SBMoney *)multiply:(NSInteger)amount
{
    double absolute = (double)self.val * amount;
    if (absolute > 0) {
        absolute += 0.5;
    } else if (absolute < 0) {
        absolute -= 0.5;
    }
    NSInteger val = absolute;
    return [SBMoney moneyWithVal:val];
}

- (SBMoney *)divide:(NSInteger)amount
{
    double absolute = (double)self.val / amount;
    if (absolute > 0) {
        absolute += 0.5;
    } else if (absolute < 0) {
        absolute -= 0.5;
    }
    NSInteger val = absolute;
    return [SBMoney moneyWithVal:val];
}

- (SBMoney *)abs
{
    return [SBMoney moneyWithVal:labs(self.val)];
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld.%ld", self.val / 100, labs(self.val % 100)];
}

@end
