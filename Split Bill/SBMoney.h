//
//  SBMoney.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBMoney : NSObject

@property (nonatomic, readonly) NSInteger whole;
@property (nonatomic, readonly) NSInteger decimal;

+ (SBMoney *)moneyWithWhole:(NSInteger)whole andDecimal:(NSInteger)decimal;

- (void)add:(SBMoney *)amount;
- (void)subtract:(SBMoney *)amount;
- (void)multiply:(NSInteger)amount;
- (void)divide:(NSInteger)amount;

@end
