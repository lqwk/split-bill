//
//  Group+CoreDataProperties.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/13/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Group+CoreDataProperties.h"

@implementation Group (CoreDataProperties)

+ (NSFetchRequest<Group *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Group"];
}

@dynamic name;
@dynamic unique;
@dynamic expenses;
@dynamic people;

@end
