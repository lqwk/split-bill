//
//  SBMoney.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBMoney : NSObject

@property (nonatomic, readonly) NSInteger val;

+ (SBMoney *)moneyWithWhole:(NSInteger)whole andDecimal:(NSInteger)decimal;
+ (SBMoney *)moneyWithVal:(NSInteger)val;

- (SBMoney *)add:(SBMoney *)amount;
- (SBMoney *)subtract:(SBMoney *)amount;
- (SBMoney *)multiply:(NSInteger)amount;
- (SBMoney *)divide:(NSInteger)amount;

- (SBMoney *)abs;

@end
