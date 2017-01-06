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
#import "SBResult.h"
#import "SBSplitEngine.h"

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

- (void)testExpenseEvaluation {
    SBPerson *p1 = [SBPerson personWithName:@"P1" andWeight:2];
    SBPerson *p2 = [SBPerson personWithName:@"P2" andWeight:1];
    SBPerson *p3 = [SBPerson personWithName:@"P3" andWeight:1];
    SBPerson *p4 = [SBPerson personWithName:@"P4" andWeight:1];
    SBPerson *p5 = [SBPerson personWithName:@"P5" andWeight:1];

    SBMoney *m1 = [SBMoney moneyWithWhole:10 andDecimal:0];

    SBPayment *pp1 = [SBPayment paymentWithPerson:p1 andAmount:m1];
    SBPayment *pp2 = [SBPayment paymentWithPerson:p2 andAmount:m1];
    SBPayment *pp3 = [SBPayment paymentWithPerson:p3 andAmount:m1];
    SBPayment *pp4 = [SBPayment paymentWithPerson:p4 andAmount:m1];
    SBPayment *pp5 = [SBPayment paymentWithPerson:p5 andAmount:m1];

    SBExpense *e = [SBExpense expenseWithName:@"Weird" andPayments:[NSArray arrayWithObjects:pp1, pp2, pp3, pp4, pp5, nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, p4, nil]];
    NSArray *results = [e resultsForEvaluation];
    NSLog(@"%@", results);
}

// - (void)testExpenseEvalutation1 {
//     // This is an example of a functional test case.
//     // Use XCTAssert and related functions to verify your tests produce the correct results.

//     SBPerson *person1 = [SBPerson personWithName:@"Lan" andWeight:2];
//     SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
//     SBMoney *money1 = [SBMoney moneyWithWhole:10 andDecimal:20];
//     SBMoney *money2 = [SBMoney moneyWithWhole:15 andDecimal:55];
//     SBPayment *payment1 = [SBPayment paymentWithPerson:person1 andAmount:money1];
//     SBPayment *payment2 = [SBPayment paymentWithPerson:person2 andAmount:money2];
//     SBExpense *expense = [SBExpense expenseWithName:@"Frenchie" andPayments:[NSArray arrayWithObjects:payment1, payment2, nil]];
//     NSArray *results = [expense resultsForEvaluation];
//     NSLog(@"%@", results);
// }

// - (void)testExpenseEvalutation2 {
//     // This is an example of a functional test case.
//     // Use XCTAssert and related functions to verify your tests produce the correct results.

//     SBPerson *person1 = [SBPerson personWithName:@"Lan" andWeight:2];
//     SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
//     SBPerson *person3 = [SBPerson personWithName:@"Chen" andWeight:1];
//     SBMoney *money1 = [SBMoney moneyWithWhole:40 andDecimal:0];
//     SBMoney *money2 = [SBMoney moneyWithWhole:0 andDecimal:0];
//     SBPayment *payment1 = [SBPayment paymentWithPerson:person1 andAmount:money1];
//     SBPayment *payment2 = [SBPayment paymentWithPerson:person2 andAmount:money2];
//     SBPayment *payment3 = [SBPayment paymentWithPerson:person3 andAmount:money2];
//     SBExpense *expense = [SBExpense expenseWithName:@"Frenchie" andPayments:[NSArray arrayWithObjects:payment1, payment2, payment3, nil]];
//     NSArray *results = [expense resultsForEvaluation];
//     NSLog(@"%@", results);
// }

// - (void)testAggregate
// {
//     SBPerson *person1 = [SBPerson personWithName:@"Lan" andWeight:2];
//     SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
//     SBPerson *person3 = [SBPerson personWithName:@"Chen" andWeight:1];

//     SBMoney *money1 = [SBMoney moneyWithWhole:10 andDecimal:20];
//     SBMoney *money2 = [SBMoney moneyWithWhole:20 andDecimal:10];

//     SBResult *result1 = [SBResult resultWithLendee:person1 andLender:person2 andAmount:money1];
//     SBResult *result2 = [SBResult resultWithLendee:person1 andLender:person2 andAmount:money2];
//     SBResult *result3 = [SBResult resultWithLendee:person1 andLender:person3 andAmount:money2];
//     SBResult *result4 = [SBResult resultWithLendee:person2 andLender:person1 andAmount:money2];

//     XCTAssert([result1 canAggregateWith:result2] == 1);
//     XCTAssert([result2 canAggregateWith:result1] == 1);
//     XCTAssert([result1 canAggregateWith:result4] == 2);
//     XCTAssert([result4 canAggregateWith:result1] == 2);
//     XCTAssert(![result1 canAggregateWith:result3]);
//     XCTAssert(![result3 canAggregateWith:result1]);
//     XCTAssert(![result4 canAggregateWith:result3]);
//     XCTAssert(![result3 canAggregateWith:result4]);

//     NSInteger flag1 = [result1 canAggregateWith:result2];
//     SBResult *aggregatedResult1 = [result1 aggregateWith:result2 withFlag:flag1];
//     NSLog(@"1: %@", result1);
//     NSLog(@"2: %@", result2);
//     NSLog(@"T: %@", aggregatedResult1);

//     NSInteger flag2 = [result1 canAggregateWith:result4];
//     SBResult *aggregatedResult2 = [result1 aggregateWith:result4 withFlag:flag2];
//     NSLog(@"1: %@", result1);
//     NSLog(@"2: %@", result4);
//     NSLog(@"T: %@", aggregatedResult2);
// }

// - (void)testEngine
// {
//     SBPerson *person1 = [SBPerson personWithName:@"Lan" andWeight:2];
//     SBPerson *person2 = [SBPerson personWithName:@"Man" andWeight:1];
//     SBPerson *person3 = [SBPerson personWithName:@"Chen" andWeight:1];

//     SBMoney *money1 = [SBMoney moneyWithWhole:40 andDecimal:0];
//     SBMoney *money2 = [SBMoney moneyWithWhole:0 andDecimal:0];
//     SBPayment *payment1 = [SBPayment paymentWithPerson:person1 andAmount:money1];
//     SBPayment *payment2 = [SBPayment paymentWithPerson:person2 andAmount:money2];
//     SBPayment *payment3 = [SBPayment paymentWithPerson:person3 andAmount:money2];
//     SBExpense *expense1 = [SBExpense expenseWithName:@"Frenchie" andPayments:[NSArray arrayWithObjects:payment1, payment2, payment3, nil]];


//     SBMoney *money3 = [SBMoney moneyWithWhole:10 andDecimal:20];
//     SBMoney *money4 = [SBMoney moneyWithWhole:15 andDecimal:55];
//     SBPayment *payment4 = [SBPayment paymentWithPerson:person1 andAmount:money3];
//     SBPayment *payment5 = [SBPayment paymentWithPerson:person2 andAmount:money4];
//     SBExpense *expense2 = [SBExpense expenseWithName:@"TPT" andPayments:[NSArray arrayWithObjects:payment4, payment5, nil]];

//     SBSplitEngine *engine = [SBSplitEngine engineWithExpenses:[NSArray arrayWithObjects:expense1, expense2, nil]];
//     NSArray *results = [engine resultsForEvaluation];
//     NSLog(@"%@", results);
// }

// - (void)testLondonBillSplit
// {
//     SBPerson *p1 = [SBPerson personWithName:@"Lan" andWeight:2];
//     SBPerson *p2 = [SBPerson personWithName:@"Man" andWeight:1];
//     SBPerson *p3 = [SBPerson personWithName:@"Chen" andWeight:1];

//     SBMoney *m1 = [SBMoney moneyWithWhole:51 andDecimal:80];
//     SBMoney *m2 = [SBMoney moneyWithWhole:13 andDecimal:50];
//     SBMoney *m3 = [SBMoney moneyWithWhole:463 andDecimal:10];
//     SBMoney *m4 = [SBMoney moneyWithWhole:71 andDecimal:17];
//     SBMoney *m5 = [SBMoney moneyWithWhole:424 andDecimal:0];

//     SBExpense *e1 = [SBExpense expenseWithName:@"Abby Tickets" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p1 andAmount:m1], [SBPayment paymentWithPerson:p3 andAmount:[SBMoney moneyWithVal:0]], nil]];
//     SBExpense *e2 = [SBExpense expenseWithName:@"Medicine" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p1 andAmount:m2], [SBPayment paymentWithPerson:p2 andAmount: [SBMoney moneyWithVal:0]], nil]];
//     SBExpense *e3 = [SBExpense expenseWithName:@"Lan Total" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p1 andAmount:m3], [SBPayment paymentWithPerson:p2 andAmount: [SBMoney moneyWithVal:0]], [SBPayment paymentWithPerson:p3 andAmount: [SBMoney moneyWithVal:0]], nil]];
//     SBExpense *e4 = [SBExpense expenseWithName:@"Chen Total" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p3 andAmount:m4], [SBPayment paymentWithPerson:p1 andAmount: [SBMoney moneyWithVal:0]], [SBPayment paymentWithPerson:p2 andAmount: [SBMoney moneyWithVal:0]], nil]];
//     SBExpense *e5 = [SBExpense expenseWithName:@"Man Total" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p3 andAmount:m5], [SBPayment paymentWithPerson:p1 andAmount: [SBMoney moneyWithVal:0]], [SBPayment paymentWithPerson:p3 andAmount: [SBMoney moneyWithVal:0]], nil]];

//     NSLog(@"%@", e1);
//     NSLog(@"%@", e2);
//     NSLog(@"%@", e3);
//     NSLog(@"%@", e4);
//     NSLog(@"%@", e5);

//     SBSplitEngine *engine = [SBSplitEngine engineWithExpenses:[NSArray arrayWithObjects:e1, e2, e3, e4, e5, nil]];
//     NSArray *results = [engine resultsForEvaluation];
//     NSLog(@"%@", results);

// }

@end
