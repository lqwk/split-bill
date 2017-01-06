//
//  ModelTests.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/5/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBMoney.h"

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

- (void)testMoney {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    SBMoney *m1 = [SBMoney moneyWithWhole:10 andDecimal:10];
    SBMoney *m2 = [SBMoney moneyWithWhole:5 andDecimal:50];
    XCTAssertEqual(m1.whole, 10);
    XCTAssertEqual(m1.decimal, 10);

    [m1 add:m2];
    XCTAssertEqual(m1.whole, 15);
    XCTAssertEqual(m1.decimal, 60);
    XCTAssertEqual(m2.whole, 5);
    XCTAssertEqual(m2.decimal, 50);

    [m1 add:m2];
    XCTAssertEqual(m1.whole, 21);
    XCTAssertEqual(m1.decimal, 10);
    XCTAssertEqual(m2.whole, 5);
    XCTAssertEqual(m2.decimal, 50);
}

@end
