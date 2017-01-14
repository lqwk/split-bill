//
//  Person+CoreDataClass.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Person+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "Group+CoreDataClass.h"
#import "Payment+CoreDataClass.h"

@implementation Person

+ (Person *)personWithName:(NSString *)name
                    unique:(NSString *)unique
                    weight:(NSInteger)weight
                     group:(Group *)group
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    Person *person = nil;

    // Search for the given person
    NSFetchRequest *req = [Person fetchRequest];
    req.predicate = [NSPredicate predicateWithFormat:@"unique ==[c] %@", unique];
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];

    if (!results || error) {
        NSLog(@"ERROR in fetching PERSON with unique: %@", unique);
    } else if (results.count > 1) {
        NSLog(@"ERROR: more than 1 match for PERSON with unique: %@", unique);
    } else if (results.count == 1) {
        NSLog(@"Found PERSON with unique: %@", unique);
        person = [results lastObject];
    } else {
        NSLog(@"Insering PERSON with unique: %@", unique);
        person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        person.name = name;
        person.unique = unique;
        person.weight = weight;
        person.group = group;
    }

    return person;
}

+ (void)deletePersonWithUnique:(NSString *)unique
      fromManagedObjectContext:(NSManagedObjectContext *)context
{
    // Search for the given person
    NSFetchRequest *req = [Person fetchRequest];
    req.predicate = [NSPredicate predicateWithFormat:@"unique ==[c] %@", unique];
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];

    if (!results || error) {
        NSLog(@"ERROR in fetching PERSON with unique: %@", unique);
    } else if (results.count > 1) {
        NSLog(@"ERROR: more than 1 match for PERSON with unique: %@", unique);
    } else if (results.count == 1) {
        NSLog(@"Found PERSON with unique: %@", unique);
        Person *person = [results lastObject];
        [context deleteObject:person];
    } else {
        NSLog(@"Did not find PERSON with unique: %@", unique);
    }
}

@end
