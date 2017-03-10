//
//  Expense+CoreDataProperties.h
//  Split Bill
//
//  Created by Qingwei Lan on 2/27/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Expense+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Expense (CoreDataProperties)

+ (NSFetchRequest<Expense *> *)fetchRequest;

@property (nonatomic) BOOL isPayback;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *unique;
@property (nullable, nonatomic, copy) NSString *currency;
@property (nullable, nonatomic, retain) Group *group;
@property (nullable, nonatomic, retain) NSSet<Payment *> *paymentsInvolved;
@property (nullable, nonatomic, retain) NSSet<Person *> *peopleInvolved;

@end

@interface Expense (CoreDataGeneratedAccessors)

- (void)addPaymentsInvolvedObject:(Payment *)value;
- (void)removePaymentsInvolvedObject:(Payment *)value;
- (void)addPaymentsInvolved:(NSSet<Payment *> *)values;
- (void)removePaymentsInvolved:(NSSet<Payment *> *)values;

- (void)addPeopleInvolvedObject:(Person *)value;
- (void)removePeopleInvolvedObject:(Person *)value;
- (void)addPeopleInvolved:(NSSet<Person *> *)values;
- (void)removePeopleInvolved:(NSSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
