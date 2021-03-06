//
//  MBODateHelper.m
//  SensorLogger
//
//  Created by Hugo Lefrancois on 2014-07-02.
//  Copyright (c) 2014 Mirego. All rights reserved.
//

#import "MBODateHelper.h"

@implementation MBODateHelper

+ (NSDate *)dateFromMnuboString:(NSString *)dateString
{
    return [[MBODateHelper currentThreadDateFormatter] dateFromString:dateString];
}

+ (NSString *)mnuboStringFromDate:(NSDate *)date
{
    return [[MBODateHelper currentThreadDateFormatter] stringFromDate:date];
}

//------------------------------------------------------------------------------
#pragma mark Private Methods
//------------------------------------------------------------------------------
+ (NSDateFormatter *)currentThreadDateFormatter
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey:@"MBODateHelperDateFormatter"];

    if(dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
        dateFormatter.dateFormat = @"YYYY-MM-dd'T'HH:mm:ssZZZ";
        [threadDictionary setObject:dateFormatter forKey:@"MBODateHelperDateFormatter"];
    }

    return dateFormatter;
}

@end
