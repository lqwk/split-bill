//
//  SBMoney.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "SBMoney.h"

@interface SBMoney ()

@property (nonatomic, readwrite) NSInteger whole;
@property (nonatomic, readwrite) NSInteger decimal;

@end

@implementation SBMoney

+ (SBMoney *)moneyWithWhole:(NSInteger)whole andDecimal:(NSInteger)decimal
{
    SBMoney *money = [[SBMoney alloc] init];
    money.whole = whole;
    money.decimal = decimal;
    return money;
}

#pragma mark - Main Methods

- (void)add:(SBMoney *)amount
{
    self.decimal += amount.decimal;
    if (self.decimal >= 100) {
        self.decimal -= 100;
        self.whole += 1;
    }
    self.whole += amount.whole;
}

- (void)subtract:(SBMoney *)amount
{
    self.decimal -= amount.decimal;
    if (self.decimal < 0) {
        self.decimal += 100;
        self.whole -= 1;
    }
    self.whole -= amount.whole;
}

- (void)multiply:(NSInteger)amount
{
    self.decimal *= amount;
    self.whole *= amount;
    if (self.decimal >= 100) {
        self.decimal -= 100;
        self.whole += 1;
    }
}

- (void)divide:(NSInteger)amount
{
    NSInteger absolute = self.whole * 100 + self.decimal;
    NSInteger val = (double)absolute / (double)amount + 0.5;
    self.whole = val / 100;
    self.decimal = val % 100;
}

#pragma mark - DEBUG

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld.%ld", self.whole, self.decimal];
}

@end
