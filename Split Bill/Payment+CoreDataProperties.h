//
//  Payment+CoreDataProperties.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/13/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Payment+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Payment (CoreDataProperties)

+ (NSFetchRequest<Payment *> *)fetchRequest;

@property (nonatomic) int64_t amount;
@property (nullable, nonatomic, retain) Expense *expense;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
