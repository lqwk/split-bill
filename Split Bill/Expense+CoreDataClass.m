//
//  Expense+CoreDataClass.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Expense+CoreDataClass.h"
#import "Group+CoreDataClass.h"
#import "Payment+CoreDataClass.h"
#import "Person+CoreDataClass.h"

@implementation Expense

+ (Expense *)expenseWithName:(NSString *)name
                      unique:(NSString *)unique
                       group:(Group *)group
              peopleInvolved:(NSSet<Person *> *)peopleInvolved
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    Expense *expense = nil;

    // Search for the given group
    NSFetchRequest *req = [Expense fetchRequest];
    req.predicate = [NSPredicate predicateWithFormat:@"unique ==[c] %@", unique];
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];

    if (!results || error) {
        NSLog(@"ERROR in fetching EXPENSE with unique: %@", unique);
    } else if (results.count > 1) {
        NSLog(@"ERROR: more than 1 match for EXPENSE with unique: %@", unique);
    } else if (results.count == 1) {
        NSLog(@"Found EXPENSE with unique: %@", unique);
        expense = [results lastObject];
    } else {
        NSLog(@"Insering EXPENSE with unique: %@", unique);
        expense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:context];
        expense.name = name;
        expense.unique = unique;
        expense.group = group;
        if (expense.peopleInvolved == nil) {
            expense.peopleInvolved = peopleInvolved;
        } else {
            [expense addPeopleInvolved:peopleInvolved];
        }
    }

    return expense;
}

@end
