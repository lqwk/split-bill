//
//  ModelPrintingTests.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/5/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBPerson.h"
#import "SBMoney.h"
#import "SBPayment.h"
#import "SBExpense.h"
#import "SBResult.h"

@interface ModelPrintingTests : XCTestCase

@end

@implementation ModelPrintingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPrint {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBPerson *person = [SBPerson personWithName:@"Lan" andWeight:2];
    SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
    SBMoney *money = [SBMoney moneyWithWhole:10 andDecimal:20];
    SBPayment *payment = [SBPayment paymentWithPerson:person andAmount:money];
    SBExpense *expense = [SBExpense expenseWithName:@"Frenchie" andPayments:[NSArray arrayWithObjects:payment, payment, payment, payment, nil] andPeople:[NSArray arrayWithObjects:person, person2, nil]];
    SBResult *result = [SBResult resultWithLendee:person2 andLender:person andAmount:money];

    NSLog(@"%@, %@", person, person2);
    NSLog(@"%@", money);
    NSLog(@"%@", payment);
    NSLog(@"%@", expense);
    NSLog(@"%@", result);
}

@end
