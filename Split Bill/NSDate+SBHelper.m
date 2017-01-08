//
//  NSDate+SBHelper.m
//  Split Bill
//
//  Created by Qingwei Lan on 1/7/17.
//  Copyright © 2017 Qingwei Lan. All rights reserved.
//

#import "NSDate+SBHelper.h"

@implementation NSDate (SBHelper)

- (NSString *)dateID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"PDT"];
    [formatter setTimeZone:timezone];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:self];
}

@end
