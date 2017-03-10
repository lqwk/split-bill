//
//  Person+CoreDataProperties.h
//  Split Bill
//
//  Created by Qingwei Lan on 3/9/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *unique;
@property (nonatomic) int64_t weight;
@property (nullable, nonatomic, retain) NSSet<Expense *> *expensesInvolved;
@property (nullable, nonatomic, retain) Group *group;
@property (nullable, nonatomic, retain) NSSet<Payment *> *paymentsMade;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addExpensesInvolvedObject:(Expense *)value;
- (void)removeExpensesInvolvedObject:(Expense *)value;
- (void)addExpensesInvolved:(NSSet<Expense *> *)values;
- (void)removeExpensesInvolved:(NSSet<Expense *> *)values;

- (void)addPaymentsMadeObject:(Payment *)value;
- (void)removePaymentsMadeObject:(Payment *)value;
- (void)addPaymentsMade:(NSSet<Payment *> *)values;
- (void)removePaymentsMade:(NSSet<Payment *> *)values;

@end

NS_ASSUME_NONNULL_END
