//
//  Group+CoreDataProperties.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Group+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

+ (NSFetchRequest<Group *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *unique;
@property (nullable, nonatomic, retain) NSSet<Person *> *people;
@property (nullable, nonatomic, retain) NSSet<Expense *> *expenses;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSSet<Person *> *)values;
- (void)removePeople:(NSSet<Person *> *)values;

- (void)addExpensesObject:(Expense *)value;
- (void)removeExpensesObject:(Expense *)value;
- (void)addExpenses:(NSSet<Expense *> *)values;
- (void)removeExpenses:(NSSet<Expense *> *)values;

@end

NS_ASSUME_NONNULL_END
