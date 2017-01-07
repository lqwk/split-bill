//
//  Payment+CoreDataClass.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Payment+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "Person+CoreDataClass.h"

@implementation Payment

+ (Payment *)paymentWithAmount:(int64_t)amount
                        person:(Person *)person
                       expense:(Expense *)expense
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    Payment *payment = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:context];
    payment.amount = amount;
    payment.person = person;
    payment.expense = expense;
    return payment;
}

@end
