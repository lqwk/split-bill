//
//  SBPerson.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface SBPerson : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger weight;

+ (SBPerson *)personWithName:(NSString *)name andWeight:(NSInteger)weight;

// Convert Core Data <Person> to <SBPerson>
+ (SBPerson *)personFromCDPerson:(Person *)person;

@end
