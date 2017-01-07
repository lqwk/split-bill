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

+ (Person *)insertPersonWithName:(NSString *)name
                          unique:(NSString *)unique
                          weight:(NSInteger)weight
                       groupName:(NSString *)groupName
                     groupUnique:(NSString *)groupUnique
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    person.name = name;
    person.unique = unique;
    person.weight = weight;
    return person;
}

@end
