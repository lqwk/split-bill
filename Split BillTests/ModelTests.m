//
//  ModelTests.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/5/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBMoney.h"
#import "SBPerson.h"
#import "SBPayment.h"
#import "SBExpense.h"

@interface ModelTests : XCTestCase

@end

@implementation ModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMoneyAdd {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBMoney *m1 = [SBMoney moneyWithWhole:10 andDecimal:10];
    SBMoney *m2 = [SBMoney moneyWithWhole:5 andDecimal:50];
    XCTAssertEqual(m1.val, 1010);
    XCTAssertEqual(m2.val, 550);

    SBMoney *m = [m1 add:m2];
    XCTAssertEqual(m.val, 1560);
    XCTAssertEqual(m2.val, 550);

    m = [m add:m2];
    XCTAssertEqual(m.val, 2110);
    XCTAssertEqual(m2.val, 550);
}

- (void)testMoneySubtract {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBMoney *m1 = [SBMoney moneyWithWhole:10 andDecimal:10];
    SBMoney *m2 = [SBMoney moneyWithWhole:5 andDecimal:50];
    XCTAssertEqual(m1.val, 1010);
    XCTAssertEqual(m2.val, 550);

    SBMoney *m = [m1 subtract:m2];
    XCTAssertEqual(m.val, 460);
    XCTAssertEqual(m2.val, 550);

    m = [m subtract:m2];
    XCTAssertEqual(m.val, -90);
    XCTAssertEqual(m2.val, 550);
}

- (void)testMoneyMultiply {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBMoney *m1 = [SBMoney moneyWithWhole:10 andDecimal:10];
    XCTAssertEqual(m1.val, 1010);

    SBMoney *m = [m1 multiply:2];
    XCTAssertEqual(m.val, 2020);

    m = [m multiply:7];
    XCTAssertEqual(m.val, 14140);
}

- (void)testMoneyDivide {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBMoney *m1 = [SBMoney moneyWithWhole:10 andDecimal:10];
    XCTAssertEqual(m1.val, 1010);

    SBMoney *m = [m1 divide:2];
    XCTAssertEqual(m.val, 505);

    m = [m divide:3];
    XCTAssertEqual(m.val, 168);
}

- (void)testExpenseEvalutation1 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBPerson *person1 = [SBPerson personWithName:@"Lan" andWeight:2];
    SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
    SBMoney *money1 = [SBMoney moneyWithWhole:10 andDecimal:20];
    SBMoney *money2 = [SBMoney moneyWithWhole:15 andDecimal:55];
    SBPayment *payment1 = [SBPayment paymentWithPerson:person1 andAmount:money1];
    SBPayment *payment2 = [SBPayment paymentWithPerson:person2 andAmount:money2];
    SBExpense *expense = [SBExpense expenseWithName:@"Frenchie" andPayments:[NSArray arrayWithObjects:payment1, payment2, nil]];
    NSArray *results = [expense resultsForEvaluation];
    NSLog(@"%@", results);
}

- (void)testExpenseEvalutation2 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    SBPerson *person1 = [SBPerson personWithName:@"Lan" andWeight:2];
    SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
    SBPerson *person3 = [SBPerson personWithName:@"Chen" andWeight:1];
    SBMoney *money1 = [SBMoney moneyWithWhole:40 andDecimal:0];
    SBMoney *money2 = [SBMoney moneyWithWhole:0 andDecimal:0];
    SBPayment *payment1 = [SBPayment paymentWithPerson:person1 andAmount:money1];
    SBPayment *payment2 = [SBPayment paymentWithPerson:person2 andAmount:money2];
    SBPayment *payment3 = [SBPayment paymentWithPerson:person3 andAmount:money2];
    SBExpense *expense = [SBExpense expenseWithName:@"Frenchie" andPayments:[NSArray arrayWithObjects:payment1, payment2, payment3, nil]];
    NSArray *results = [expense resultsForEvaluation];
    NSLog(@"%@", results);
}

@end
