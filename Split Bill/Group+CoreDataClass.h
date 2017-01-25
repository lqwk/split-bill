//
//  Group+CoreDataClass.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/6/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense, Person;

NS_ASSUME_NONNULL_BEGIN

@interface Group : NSManagedObject

+ (Group *)groupWithName:(NSString *)name
                  unique:(NSString *)unique
  inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)deleteGroupWithUnique:(NSString *)unique
     fromManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Group+CoreDataProperties.h"
