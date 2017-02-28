//
//  Expense+CoreDataClass.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Payment, Person;

NS_ASSUME_NONNULL_BEGIN

@interface Expense : NSManagedObject

+ (Expense *)expenseWithName:(NSString *)name
                      unique:(NSString *)unique
                    currency:(NSString *)currency
                   isPayback:(BOOL)isPayback
                       group:(Group *)group
              peopleInvolved:(NSSet<Person *> *)peopleInvolved
      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteExpenseWithUnique:(NSString *)unique
       fromManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Expense+CoreDataProperties.h"
