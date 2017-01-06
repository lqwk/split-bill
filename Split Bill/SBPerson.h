//
//  SBPerson.h
//  Split Bill
//
//  Created by Qingwei Lan on 1/4/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPerson : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger weight;

+ (SBPerson *)personWithName:(NSString *)name andWeight:(NSInteger)weight;

@end
