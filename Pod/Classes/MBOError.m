//
//  MBOError.m
//  SensorLogger
//
//  Created by Hugo Lefrancois on 2014-06-27.
//  Copyright (c) 2014 Mirego. All rights reserved.
//

#import "MBOError.h"

@implementation MBOError

- (instancetype)initWithError:(NSError *)error extraInfo:(id)extraInfo
{
    self = [super initWithDomain:error.domain code:error.code userInfo:error.userInfo];
    if(self)
    {
        if([extraInfo isKindOfClass:[NSDictionary class]])
        {
            
            _mnuboErrorMessage = [extraInfo objectForKey:@"message"];
            _mnuboErrorDescription = [extraInfo objectForKey:@"error_description"];
            
            
            if ([_mnuboErrorDescription isEqualToString:@"Bad credentials"])
            {
                _mnuboErrorCode = MBOErrorCodeBadCredentials;
            }
            else if ([_mnuboErrorMessage rangeOfString:@"User "].location != NSNotFound && [_mnuboErrorMessage rangeOfString:@" already exists."].location != NSNotFound)
            {
                _mnuboErrorCode = MBOErrorCodeUserAlreadyExists;
            }
            else
            {
                _mnuboErrorCode = [[extraInfo objectForKey:@"errorCode"] integerValue];
            }
        }
    }

    return self;
}

+ (MBOError *)errorWithError:(NSError *)error extraInfo:(id)extraInfoData
{

    return [[MBOError alloc] initWithError:error extraInfo:extraInfoData];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ mnuboMessage:%@ mnobuError:%ld", [super description], _mnuboErrorMessage, (long)_mnuboErrorCode];
}

@end
