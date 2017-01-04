//
//  SBPayment.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBMoney;
@class SBPerson;

@interface SBPayment : NSObject

@property (nonatomic, strong) SBPerson *person;
@property (nonatomic, strong) SBMoney *amount;

@end
