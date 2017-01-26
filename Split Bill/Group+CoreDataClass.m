//
//  Group+CoreDataClass.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Group+CoreDataClass.h"
#import "Expense+CoreDataClass.h"
#import "Person+CoreDataClass.h"

@implementation Group

+ (Group *)groupWithName:(NSString *)name
                  unique:(NSString *)unique
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Group *group = nil;

    // Search for the given group
    NSFetchRequest *req = [Group fetchRequest];
    req.predicate = [NSPredicate predicateWithFormat:@"unique ==[c] %@", unique];
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];

    if (!results || error) {
        NSLog(@"ERROR in fetching GROUP with unique: %@", unique);
    } else if (results.count > 1) {
        NSLog(@"ERROR: more than 1 match for GROUP with unique: %@", unique);
    } else if (results.count == 1) {
        NSLog(@"Found GROUP with unique: %@", unique);
        group = [results lastObject];
    } else {
        NSLog(@"Insering GROUP with unique: %@", unique);
        group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
        group.name = name;
        group.unique = unique;
    }

    return group;
}

+ (void)deleteGroupWithUnique:(NSString *)unique
     fromManagedObjectContext:(NSManagedObjectContext *)context
{
    // Search for the given group
    NSFetchRequest *req = [Group fetchRequest];
    req.predicate = [NSPredicate predicateWithFormat:@"unique ==[c] %@", unique];
    NSError *error;
    NSArray *results = [context executeFetchRequest:req error:&error];

    if (!results || error) {
        NSLog(@"ERROR in fetching GROUP with unique: %@", unique);
    } else if (results.count > 1) {
        NSLog(@"ERROR: more than 1 match for GROUP with unique: %@", unique);
    } else if (results.count == 1) {
        NSLog(@"Found GROUP with unique: %@", unique);
        Group* group = [results lastObject];
        [context deleteObject:group];
    } else {
        NSLog(@"Did not find GROUP with unique: %@", unique);
    }
}

@end
