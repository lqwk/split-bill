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

    SBExpense *e1 = [SBExpense expenseWithName:@"Weird" andPayments:[NSArray arrayWithObjects:pp1, pp2, pp3, pp4, pp5, nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, p4, nil]];
    SBExpense *e2 = [SBExpense expenseWithName:@"Weird" andPayments:[NSArray arrayWithObjects:pp1, pp2, pp3, pp4, pp5, nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, p4, nil]];
    SBExpense *e3 = [SBExpense expenseWithName:@"Weird" andPayments:[NSArray arrayWithObjects:pp1, pp2, pp3, pp4, pp5, nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, p4, nil]];
    SBExpense *e4 = [SBExpense expenseWithName:@"Weird" andPayments:[NSArray arrayWithObjects:pp1, pp2, pp3, pp4, pp5, nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, p4, nil]];
    SBExpense *e5 = [SBExpense expenseWithName:@"Weird" andPayments:[NSArray arrayWithObjects:pp1, pp2, pp3, pp4, pp5, nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, p4, nil]];

    NSArray *results = [e1 resultsForEvaluation];
    NSLog(@"%@", results);

    SBSplitEngine *engine = [SBSplitEngine engineWithExpenses:[NSArray arrayWithObjects:e1, e2, e3, e4, e5, nil]];
    NSArray *rr = [engine resultsForEvaluation];
    NSLog(@"%@", rr);
}

- (void)testAggregate {
    SBPerson *a = [SBPerson personWithName:@"A" andWeight:1];
    SBPerson *b = [SBPerson personWithName:@"B" andWeight:1];
    SBPerson *c = [SBPerson personWithName:@"C" andWeight:1];
    SBPerson *d = [SBPerson personWithName:@"D" andWeight:1];

    SBResult *r1 = [SBResult resultWithLendee:a andLender:b andAmount:[SBMoney moneyWithWhole:2 andDecimal:0]];
    SBResult *r2 = [SBResult resultWithLendee:b andLender:c andAmount:[SBMoney moneyWithWhole:5 andDecimal:0]];
    SBResult *r3 = [SBResult resultWithLendee:a andLender:b andAmount:[SBMoney moneyWithWhole:10 andDecimal:0]];
    SBResult *r4 = [SBResult resultWithLendee:b andLender:a andAmount:[SBMoney moneyWithWhole:7 andDecimal:10]];
    SBResult *r5 = [SBResult resultWithLendee:c andLender:d andAmount:[SBMoney moneyWithWhole:7 andDecimal:10]];

    NSInteger flag = [r1 canAggregateWith:r2];
    NSLog(@"%ld", flag);
    NSArray *r = [r1 aggregateWith:r2 withFlag:flag];
    NSLog(@"%@", r);

    flag = [r2 canAggregateWith:r1];
    NSLog(@"%ld", flag);
    r = [r2 aggregateWith:r1 withFlag:flag];
    NSLog(@"%@", r);

    flag = [r1 canAggregateWith:r3];
    NSLog(@"%ld", flag);
    r = [r1 aggregateWith:r3 withFlag:flag];
    NSLog(@"%@", r);

    flag = [r1 canAggregateWith:r4];
    NSLog(@"%ld", flag);
    r = [r1 aggregateWith:r4 withFlag:flag];
    NSLog(@"%@", r);

    flag = [r3 canAggregateWith:r4];
    NSLog(@"%ld", flag);
    r = [r3 aggregateWith:r4 withFlag:flag];
    NSLog(@"%@", r);

    flag = [r1 canAggregateWith:r5];
    NSLog(@"%ld", flag);
    r = [r1 aggregateWith:r5 withFlag:flag];
    NSLog(@"%@", r);
}

- (void)testLondonBillSplit
{
    SBPerson *p1 = [SBPerson personWithName:@"Lan" andWeight:2];
    SBPerson *p2 = [SBPerson personWithName:@"Man" andWeight:1];
    SBPerson *p3 = [SBPerson personWithName:@"Chen" andWeight:1];

    SBMoney *m1 = [SBMoney moneyWithWhole:51 andDecimal:80];
    SBMoney *m2 = [SBMoney moneyWithWhole:13 andDecimal:50];
    SBMoney *m3 = [SBMoney moneyWithWhole:463 andDecimal:10];
    SBMoney *m4 = [SBMoney moneyWithWhole:71 andDecimal:17];
    SBMoney *m5 = [SBMoney moneyWithWhole:424 andDecimal:0];

    SBExpense *e1 = [SBExpense expenseWithName:@"Abby Tickets" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p1 andAmount:m1], nil] andPeople:[NSArray arrayWithObjects:p1, p3, nil]];
    SBExpense *e2 = [SBExpense expenseWithName:@"Medicine" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p1 andAmount:m2], nil] andPeople:[NSArray arrayWithObjects:p2, nil]];
    SBExpense *e3 = [SBExpense expenseWithName:@"Lan Total" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p1 andAmount:m3], nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, nil]];
    SBExpense *e4 = [SBExpense expenseWithName:@"Chen Total" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p3 andAmount:m4], nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, nil]];
    SBExpense *e5 = [SBExpense expenseWithName:@"Man Total" andPayments:[NSArray arrayWithObjects:[SBPayment paymentWithPerson:p2 andAmount:m5], nil] andPeople:[NSArray arrayWithObjects:p1, p2, p3, nil]];

    NSLog(@"%@", e1);
    NSLog(@"%@", e2);
    NSLog(@"%@", e3);
    NSLog(@"%@", e4);
    NSLog(@"%@", e5);

    SBSplitEngine *engine = [SBSplitEngine engineWithExpenses:[NSArray arrayWithObjects:e1, e2, e3, e4, e5, nil]];
    NSArray *results = [engine resultsForEvaluation];
    NSLog(@"%@", results);
}

@end
